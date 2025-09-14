#include "signals.h"
#include <signal.h>
#include <unistd.h>
#include <stdio.h>

/* Track foreground process group id (pgid). */
static volatile pid_t g_fg_pgid = 0;
static volatile int g_disable_tty = 0;
/* No SIGCHLD handler; job completion is polled in input loop */

void set_foreground_pid(pid_t pid) {
    /* Backward compat: treat pid as pgid */
    g_fg_pgid = pid;
}

void set_foreground_pgid(pid_t pgid) {
    g_fg_pgid = pgid;
}

int get_disable_tty_control(void) { return g_disable_tty; }
void set_disable_tty_control(int on) { g_disable_tty = on ? 1 : 0; }

static void on_sigint(int signo) {
    (void)signo;
    pid_t pgid = g_fg_pgid;
    if (pgid > 0) {
        /* Send to foreground process group */
        kill(-pgid, SIGINT);
    }
    /* Shell must NOT die */
}

static void on_sigtstp(int signo) {
    (void)signo;
    pid_t pgid = g_fg_pgid;
    if (pgid > 0) {
        /* Forward stop to the foreground process group */
        kill(-pgid, SIGTSTP);
    }
    /* Shell must NOT stop */
}

void install_shell_signal_handlers(void) {
    struct sigaction sa = {0};

    /* SIGINT -> forward to fg child */
    sa.sa_handler = on_sigint;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART;
    sigaction(SIGINT, &sa, NULL);

    /* SIGTSTP -> forward to fg child */
    sa.sa_handler = on_sigtstp;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART;
    sigaction(SIGTSTP, &sa, NULL);

    /* Shell should ignore SIGQUIT, SIGTTIN, SIGTTOU to avoid self-stop */
    signal(SIGQUIT, SIG_IGN);
    signal(SIGTTIN, SIG_IGN);
    signal(SIGTTOU, SIG_IGN);
}

void setup_child_signals(void) {
    /* Child should restore defaults so it can receive Ctrl-C/Z normally */
    signal(SIGINT, SIG_DFL);
    signal(SIGTSTP, SIG_DFL);
    signal(SIGQUIT, SIG_DFL);
    signal(SIGTTIN, SIG_DFL);
    signal(SIGTTOU, SIG_DFL);
}
