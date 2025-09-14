#include "jobs.h"
#include "signals.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <sys/wait.h>
#include <unistd.h>

static job_t *job_list = NULL;
static int next_jobno = 1;

/* helpers */

static job_t *find_job_by_pid(pid_t pid) {
    for (job_t *j = job_list; j; j = j->next) {
        if (j->pid == pid) return j;
    }
    return NULL;
}

static job_t *find_job_by_no(int jobno) {
    for (job_t *j = job_list; j; j = j->next) {
        if (j->jobno == jobno) return j;
    }
    return NULL;
}

/* core API */

void add_job(pid_t pid, const char *cmd) {
    job_t *j = calloc(1, sizeof(job_t));
    if (!j) return;
    j->jobno = next_jobno++;
    j->pid   = pid;
    j->state = JOB_RUNNING;
    strncpy(j->name, cmd ? cmd : "command", sizeof(j->name) - 1);
    j->name[sizeof(j->name) - 1] = '\0';
    j->next  = job_list;
    job_list = j;
}

void jobs_list(void) {
    for (job_t *j = job_list; j; j = j->next) {
        const char *st = (j->state == JOB_RUNNING) ? "running" :
                         (j->state == JOB_STOPPED) ? "stopped" : "done";
        printf("[%d] %d %s %s\n", j->jobno, (int)j->pid, st, j->name);
    }
}

void jobs_check_and_report(void) {
    int status;
    pid_t pid;
    while ((pid = waitpid(-1, &status, WNOHANG)) > 0) {
        job_t *prev = NULL;
        job_t *j = job_list;
        while (j && j->pid != pid) { prev = j; j = j->next; }
        if (!j) continue;

        int normal = 0;
        if (WIFEXITED(status)) {
            normal = (WEXITSTATUS(status) == 0);
        } else if (WIFSIGNALED(status)) {
            normal = 0;
        }

        /* Print only the command name (first token, basename) per spec */
        char cname[256];
        strncpy(cname, j->name, sizeof(cname)-1);
        cname[sizeof(cname)-1] = '\0';
        for (int k = 0; cname[k]; ++k) {
            if (cname[k] == ' ') { cname[k] = '\0'; break; }
        }
        /* Strip directory components if present */
        char *base = cname;
        for (char *p = cname; *p; ++p) {
            if (*p == '/') base = p + 1;
        }
        if (normal) {
            printf("%s with pid %d exited normally\n", base, (int)j->pid);
        } else {
            printf("%s with pid %d exited abnormally\n", base, (int)j->pid);
        }
        fflush(stdout);

        /* remove from list */
        if (prev) prev->next = j->next; else job_list = j->next;
        free(j);
    }
}

void jobs_kill_all(void) {
    for (job_t *j = job_list; j; j = j->next) {
        kill(j->pid, SIGKILL);
    }
}

int get_last_job_id(void) {
    return (next_jobno > 1) ? next_jobno - 1 : -1;
}

void jobs_mark_stopped(pid_t pid, const char *cmd, int *jobno_out) {
    job_t *j = find_job_by_pid(pid);
    if (!j) {
        add_job(pid, cmd);
        j = job_list;
    }
    if (j) {
        j->state = JOB_STOPPED;
        if (jobno_out) *jobno_out = j->jobno;
    }
}

/* snapshot (E.1 support) */

int jobs_snapshot(job_t **arr, int max) {
    int n = 0;
    for (job_t *j = job_list; j && n < max; j = j->next) {
        if (j->state == JOB_RUNNING || j->state == JOB_STOPPED) {
            arr[n++] = j;
        }
    }
    return n;
}

/* activities (E.1) */

void jobs_activities(void) {
    job_t *arr[256];
    int n = jobs_snapshot(arr, 256);

    // sort by command name
    for (int i = 1; i < n; ++i) {
        job_t *key = arr[i];
        int j = i - 1;
        while (j >= 0 && strcmp(arr[j]->name, key->name) > 0) {
            arr[j + 1] = arr[j];
            --j;
        }
        arr[j + 1] = key;
    }

    for (int i = 0; i < n; ++i) {
        const char *st = (arr[i]->state == JOB_RUNNING) ? "Running" : "Stopped";
        printf("[%d] : %s - %s\n", (int)arr[i]->pid, arr[i]->name, st);
    }
}

/* fg/bg (D.2) */

int jobs_fg(int jobno) {
    job_t *j = find_job_by_no(jobno);
    if (!j) return 1; // no such job

    printf("%s\n", j->name);
    fflush(stdout);

    if (j->state == JOB_STOPPED) {
        if (kill(j->pid, SIGCONT) == -1) {
            return 1;
        }
        j->state = JOB_RUNNING;
    }

    /* make this job the foreground process group for signal forwarding */
    set_foreground_pgid(j->pid);
    /* Give the terminal to this job's process group */
    tcsetpgrp(STDIN_FILENO, j->pid);

    int status;
    for (;;) {
        pid_t r = waitpid(j->pid, &status, WUNTRACED);
        if (r == -1) {
            j->state = JOB_DONE;
            break;
        }
        if (WIFSTOPPED(status)) {
            j->state = JOB_STOPPED;
            break;
        }
        if (WIFEXITED(status) || WIFSIGNALED(status)) {
            j->state = JOB_DONE;
            break;
        }
    }
    /* Restore terminal control to shell */
    tcsetpgrp(STDIN_FILENO, getpgrp());
    set_foreground_pgid(0);
    return 0;
}

int jobs_bg(int jobno) {
    job_t *j = find_job_by_no(jobno);
    if (!j) return 1;

    if (j->state == JOB_RUNNING) {
        return -2; // already running
    }
    if (j->state == JOB_STOPPED) {
        if (kill(j->pid, SIGCONT) == -1) {
            return 1;
        }
        j->state = JOB_RUNNING;
        printf("[%d] %s &\n", j->jobno, j->name);
        return 0;
    }
    return 1;
}
