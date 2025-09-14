// src/main.c
#include "prompt.h"
#include "input.h"
#include "parser.h"
#include "builtins.h"
#include "exec.h"
#include "jobs.h"
#include "signals.h"
#include "loghist.h"   // <-- NEW

#include <unistd.h>
#include <pwd.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>

#ifndef HOST_NAME_MAX
#define HOST_NAME_MAX 255
#endif

int main(void) {
    // shell "home" is the startup directory
    char home[PATH_MAX] = {0};
    if (!getcwd(home, sizeof(home))) {
        fprintf(stderr, "Failed to get current working directory\n");
        return 1;
    }

    install_shell_signal_handlers();   // signals for the shell
    log_init();                        // <-- NEW: init persistent history

    // prompt identity
    char host[HOST_NAME_MAX + 1];
    memset(host, 0, sizeof(host));
    if (gethostname(host, sizeof(host)) != 0) {
        snprintf(host, sizeof(host), "host");
    }
    struct passwd *pw = getpwuid(getuid());
    const char *user = (pw && pw->pw_name) ? pw->pw_name : "user";

    for (;;) {
        // report completed background jobs if any
        jobs_check_and_report();

        // prompt
        print_prompt(home, user, host);

        // read line
        char *line = NULL;
        size_t cap = 0;
        ssize_t n = read_line(&line, &cap);
        if (n == -1) {
            // Ctrl-D (EOF) behavior per spec
            puts("logout");
            fflush(stdout);
            jobs_kill_all();
            free(line);
            return 0; // exit 0
        }
        if (n > 0 && line[n - 1] == '\n') line[n - 1] = '\0';
        if (*line == '\0') {
            free(line);
            continue;
        }

        // parse
        command_t *cmd = parse_shell_cmd(line);
        if (!cmd) {
            puts("Invalid Syntax!");
            free(line);
            continue;
        }

        // <-- NEW: store valid command (skips ones containing 'log' and
        //          skips if identical to previous)
        log_maybe_store(cmd, line);

        // exec
        execute_shell_cmd(cmd);

        // cleanup
        free_command(cmd);
        free(line);
    }
}
