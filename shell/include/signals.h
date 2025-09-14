#ifndef SIGNALS_H
#define SIGNALS_H

#include <sys/types.h>

/* Foreground tracking (simple) */
void set_foreground_pid(pid_t pid);   /* 0 when none */
void set_foreground_pgid(pid_t pgid); /* 0 when none */

/* Control whether exec paths should manipulate terminal pgroups */
int  get_disable_tty_control(void);
void set_disable_tty_control(int on);

/* (no SIGCHLD flag utilities) */

/* Install shell handlers:
   - Shell ignores being killed/stopped by Ctrl-C/Z
   - Forwards SIGINT/SIGTSTP to current fg pid (if set) */
void install_shell_signal_handlers(void);

/* Child signal setup */
void setup_child_signals(void);

/* SIGINT flag helpers for loops that want to return to prompt promptly */
int  sigint_received(void);
void clear_sigint_flag(void);

#endif // SIGNALS_H
