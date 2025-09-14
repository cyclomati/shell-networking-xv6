// mini-project1/shell/src/exec.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <errno.h>

#include "parser.h"
#include "builtins.h"
#include "jobs.h"
#include "signals.h"
#include "redir.h"

/* helpers */

static void apply_redirections(command_t *cmd, int is_background) {
    /* Input redirection(s): try all in order; last one takes effect.
       If any open fails, print exact message and abort. */
    if (cmd->in_redirs_count > 0 && cmd->in_redirs) {
        for (int i = 0; i < cmd->in_redirs_count; ++i) {
            const char *f = cmd->in_redirs[i];
            if (i < cmd->in_redirs_count - 1) {
                int fd = open(f, O_RDONLY);
                if (fd < 0) { puts("No such file or directory"); _exit(EXIT_FAILURE); }
                close(fd);
            } else {
                if (apply_input_redirection(f) < 0) { _exit(EXIT_FAILURE); }
            }
        }
    } else if (cmd->input_file) {
        if (apply_input_redirection(cmd->input_file) < 0) { _exit(EXIT_FAILURE); }
    } else if (is_background) {
        /* Background jobs must not read from terminal */
        int devnull = open("/dev/null", O_RDONLY);
        if (devnull >= 0) {
            dup2(devnull, STDIN_FILENO);
            close(devnull);
        }
    }
    /* Output redirection(s): try all creates in order; last one dup2's.
       On failure, print exact message and abort. */
    if (cmd->out_redirs_count > 0 && cmd->out_redirs) {
        for (int i = 0; i < cmd->out_redirs_count; ++i) {
            const char *f = cmd->out_redirs[i];
            int append = cmd->out_is_append ? cmd->out_is_append[i] : 0;
            if (i < cmd->out_redirs_count - 1) {
                int flags = O_CREAT | O_WRONLY | (append ? O_APPEND : O_TRUNC);
                int fd = open(f, flags, 0644);
                if (fd < 0) { puts("Unable to create file for writing"); _exit(EXIT_FAILURE); }
                close(fd);
            } else {
                if (apply_output_redirection(f, append) < 0) { _exit(EXIT_FAILURE); }
            }
        }
    } else if (cmd->output_file) {
        if (apply_output_redirection(cmd->output_file, cmd->append) < 0) { _exit(EXIT_FAILURE); }
    }
}

/* builtins that must run in the parent */
static int is_parent_builtin(const char *name) {
    if (!name) return 0;
    return
        strcmp(name, "hop")  == 0 ||
        strcmp(name, "jobs") == 0 ||
        strcmp(name, "fg")   == 0 ||
        strcmp(name, "bg")   == 0;
}

/* exec paths */

/* Execute ONE non-pipeline command in a child and return pid to parent */
static pid_t exec_single(command_t *cmd, int is_background) {
    pid_t pid = fork();
    if (pid == 0) {
        /* child */
        setup_child_signals();
        /* put child in its own process group */
        setpgid(0, 0);
        apply_redirections(cmd, is_background);

        if (is_builtin(cmd->argv[0])) {
            /* builtin in child (e.g., background / with redirs) */
            int rc = run_builtin(cmd->argc, cmd->argv);
            _exit(rc ? 0 : 0);
        } else {
            execvp(cmd->argv[0], cmd->argv);
            /* standardize error to spec (stderr, not affected by stdout redirs) */
            fputs("Command not found!\n", stderr);
            _exit(EXIT_FAILURE);
        }
    } else if (pid < 0) {
        perror("fork");
    }
    /* parent: set child's process group (pgid = pid) */
    if (pid > 0) setpgid(pid, pid);
    return pid;
}

/* Execute a pipeline like: a | b | c ; return pid of LAST stage */
static pid_t exec_pipeline(command_t *cmd, int is_background) {
    int in_fd = STDIN_FILENO;
    int pipefd[2];
    pid_t last_pid = -1;
    pid_t pgid = 0;

    /* store PIDs to wait on all */
    pid_t pids[128];
    int npids = 0;

    for (command_t *c = cmd; c; c = c->next_pipe) {
        if (c->next_pipe) {
            if (pipe(pipefd) < 0) { perror("pipe"); return -1; }
            /* Ensure these raw pipe fds don't leak across exec except via dup2 */
            fcntl(pipefd[0], F_SETFD, FD_CLOEXEC);
            fcntl(pipefd[1], F_SETFD, FD_CLOEXEC);
        }

        pid_t pid = fork();
        if (pid == 0) {
            /* child */
            setup_child_signals();
            /* Disable TTY control in nested execs (e.g., log execute in a pipeline) */
            set_disable_tty_control(1);

            if (in_fd != STDIN_FILENO) {
                if (dup2(in_fd, STDIN_FILENO) < 0) { perror("dup2 in"); _exit(EXIT_FAILURE); }
                close(in_fd);
            }

            if (c->next_pipe) {
                if (dup2(pipefd[1], STDOUT_FILENO) < 0) { perror("dup2 out"); _exit(EXIT_FAILURE); }
                close(pipefd[0]);
                close(pipefd[1]);
            }

            apply_redirections(c, is_background);

            if (is_builtin(c->argv[0])) {
                int rc = run_builtin(c->argc, c->argv);
                _exit(rc ? 0 : 0);
            } else {
                execvp(c->argv[0], c->argv);
                fputs("Command not found!\n", stderr);
                _exit(EXIT_FAILURE);
            }
        } else if (pid < 0) {
            perror("fork");
            if (in_fd != STDIN_FILENO) close(in_fd);
            if (c->next_pipe) { close(pipefd[0]); close(pipefd[1]); }
            return -1;
        }

        /* parent side of stage */
        if (in_fd != STDIN_FILENO) close(in_fd);
        if (c->next_pipe) {
            close(pipefd[1]);
            in_fd = pipefd[0];
        }
        /* set process group for this child */
        if (pgid == 0) pgid = pid;
        setpgid(pid, pgid);
        last_pid = pid;
        if (npids < (int)(sizeof(pids)/sizeof(pids[0]))) pids[npids++] = pid;
    }

    /* Wait for all processes in the pipeline when in foreground */
    if (!is_background && npids > 0) {
        set_foreground_pgid(pgid);
        /* Give the terminal to the pipeline's process group */
        if (!get_disable_tty_control()) {
            tcsetpgrp(STDIN_FILENO, pgid);
        }
        int stopped_reported = 0;
        for (int i = npids - 1; i >= 0; --i) {
            int status;
            for (;;) {
                pid_t w = waitpid(pids[i], &status, WUNTRACED);
                if (w == -1) { continue; }
                if (WIFSTOPPED(status) && !stopped_reported) {
                    int jobno = -1;
                    jobs_mark_stopped(w, "(pipeline)", &jobno);
                    printf("[%d] Stopped %s\n", jobno, "(pipeline)");
                    stopped_reported = 1;
                }
                break;
            }
            if (stopped_reported) break;
        }
        /* Restore terminal control to shell */
        if (!get_disable_tty_control()) {
            tcsetpgrp(STDIN_FILENO, getpgrp());
        }
        set_foreground_pgid(0);
    }
    return last_pid;
}

/* execute a command tree */
void execute_shell_cmd(command_t *cmd) {
    for (command_t *c = cmd; c; c = c->next_seq) {
        if (!c->argv || !c->argv[0]) continue;

        /* parent-state builtins (foreground, non-pipeline) */
        if (!c->next_pipe && is_parent_builtin(c->argv[0]) && !c->background) {
            /* NOTE: these ignore redirections in this minimal version.
               If you want, you can add save/dup/restore around stdout/stdin. */
            run_builtin(c->argc, c->argv);
            continue;
        }

        pid_t pid;
        command_t *group_head = c;
        int had_pipeline = (c->next_pipe != NULL);
        if (c->next_pipe) {
            pid = exec_pipeline(c, c->background);
            /* Skip the rest of this pipeline in the sequence loop */
            while (c->next_pipe) c = c->next_pipe;
        } else {
            pid = exec_single(c, c->background);
        }
        if (pid < 0) continue;

        if (c->background) {
            /* Store full command line for job name; completion prints first token */
            char line[256];
            size_t pos = 0;
            line[0] = '\0';
            for (int i = 0; i < group_head->argc; ++i) {
                const char *w = group_head->argv[i];
                if (!w) continue;
                size_t wl = strlen(w);
                if (pos && pos + 1 < sizeof(line)) line[pos++] = ' ';
                size_t room = (pos < sizeof(line)) ? (sizeof(line) - 1 - pos) : 0;
                if (wl > room) wl = room;
                if (wl) { memcpy(line + pos, w, wl); pos += wl; line[pos] = '\0'; }
            }
            add_job(pid, (line[0] ? line : (group_head->argv[0] ? group_head->argv[0] : "command")));
            printf("[%d] %d\n", get_last_job_id(), pid);
            fflush(stdout);
        } else {
            /* ==== Foreground wait with Ctrl-Z support ==== */
            if (!had_pipeline) {
                set_foreground_pgid(pid); /* pgid == pid for single */
                if (!get_disable_tty_control()) {
                    /* Hand terminal control to child process group */
                    tcsetpgrp(STDIN_FILENO, pid);
                }

                int status;
                for (;;) {
                    pid_t w = waitpid(pid, &status, WUNTRACED);
                    if (w == -1) { continue; }

                    if (WIFSTOPPED(status)) {
                        int jobno = -1;
                        jobs_mark_stopped(pid, c->argv[0], &jobno);
                        printf("[%d] Stopped %s\n", jobno, c->argv[0]);
                        break; /* return to prompt */
                    }
                    if (WIFEXITED(status) || WIFSIGNALED(status)) {
                        /* finished */
                        break;
                    }
                }

                /* Restore terminal control to shell */
                if (!get_disable_tty_control()) {
                    tcsetpgrp(STDIN_FILENO, getpgrp());
                }
                set_foreground_pgid(0);
            }
        }
    }
}
