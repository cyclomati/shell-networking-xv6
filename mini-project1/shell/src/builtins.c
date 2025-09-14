#include "builtins.h"
#include "paths.h"
#include "jobs.h"
#include "exec.h"
#include "parser.h"
#include "loghist.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <errno.h>

/* ---------- helpers ---------- */

static int parse_int(const char *s, int *out) {
    if (!s || !*s) return 0;
    char *end = NULL;
    long v = strtol(s, &end, 10);
    if (*end != '\0') return 0;
    *out = (int)v;
    return 1;
}

/* ---------- builtins api ---------- */

int is_builtin(const char *cmd) {
    if (!cmd) return 0;
    return strcmp(cmd, "hop") == 0 ||
           strcmp(cmd, "reveal") == 0 ||
           strcmp(cmd, "jobs") == 0 ||
           strcmp(cmd, "fg") == 0 ||
           strcmp(cmd, "bg") == 0 ||
           strcmp(cmd, "activities") == 0 ||
           strcmp(cmd, "ping") == 0 ||
           strcmp(cmd, "log") == 0 ||
           strcmp(cmd, "tac") == 0 ||
           strcmp(cmd, "true") == 0 ||
           strcmp(cmd, "false") == 0;
}

int run_builtin(int argc, char **argv) {
    if (argc <= 0) return 0;
    const char *cmd = argv[0];

    /* ---- hop ---- */
    if (strcmp(cmd, "hop") == 0) {
        return paths_hop(argc - 1, &argv[1]);
    }

    /* ---- reveal ---- */
    if (strcmp(cmd, "reveal") == 0) {
        return paths_reveal(argc - 1, &argv[1]);
    }

    /* ---- jobs ---- */
    if (strcmp(cmd, "jobs") == 0) {
        jobs_list();
        return 0;
    }

    /* ---- fg ---- */
    if (strcmp(cmd, "fg") == 0) {
        int jobno = -1;
        if (argc == 1) jobno = get_last_job_id();
        else if (!parse_int(argv[1], &jobno)) {
            printf("No such job\n");
            return 1;
        }
        int rc = jobs_fg(jobno);
        if (rc != 0) printf("No such job\n");
        return rc;
    }

    /* ---- bg ---- */
    if (strcmp(cmd, "bg") == 0) {
        int jobno = -1;
        if (argc == 1) jobno = get_last_job_id();
        else if (!parse_int(argv[1], &jobno)) {
            printf("No such job\n");
            return 1;
        }
        int rc = jobs_bg(jobno);
        if (rc == -2) printf("Job already running\n");
        else if (rc != 0) printf("No such job\n");
        return rc;
    }

    /* ---- activities (E.1) ---- */
    if (strcmp(cmd, "activities") == 0) {
        jobs_activities();           /* prints sorted list per spec */
        return 0;
    }

    /* ---- ping (E.2) ---- */
    if (strcmp(cmd, "ping") == 0) {
        if (argc != 3) {
            printf("No such process found\n");
            return 1;
        }

        int pid_i = 0, sig_i = 0;
        if (!parse_int(argv[1], &pid_i)) {
            printf("No such process found\n");
            return 1;
        }
        if (!parse_int(argv[2], &sig_i)) {
            printf("Invalid syntax!\n");
            return 1;
        }

        int actual = sig_i % 32;
        if (actual < 0) actual += 32;

        if (kill((pid_t)pid_i, actual) == -1) {
            printf("No such process found\n");
            return 1;
        }
        printf("Sent signal %d to process with pid %d\n", sig_i, pid_i);
        return 0;
    }

    /* ---- log (B.3) ---- */
    if (strcmp(cmd, "log") == 0) {
        if (argc == 1) {
            log_print();                 /* oldest -> newest */
            return 0;
        }
        if (argc == 2 && strcmp(argv[1], "purge") == 0) {
            log_purge();
            return 0;
        }
        if (argc == 3 && strcmp(argv[1], "execute") == 0) {
            int idx = 0;
            if (!parse_int(argv[2], &idx) || idx <= 0) return 1;

            /* newest-first indexing */
            char *line = log_get_newest_idx(idx);
            if (!line) return 1;

            command_t *tree = parse_shell_cmd(line);
            if (!tree) { free(line); return 1; }

            /* do NOT re-store this executed command */
            log_set_suppress(1);
            execute_shell_cmd(tree);
            log_set_suppress(0);

            free_command(tree);
            free(line);
            return 0;
        }
        /* invalid log usage -> generic failure */
        return 1;
    }

    /* ---- true/false ---- */
    if (strcmp(cmd, "true") == 0) {
        return 0; /* success, no output */
    }
    if (strcmp(cmd, "false") == 0) {
        return 1; /* failure, no output */
    }

    /* ---- tac (fallback for environments without GNU tac) ---- */
    if (strcmp(cmd, "tac") == 0) {
        /* Reverse input by lines from stdin and print to stdout. */
        size_t cap = 0, n = 0, cap_lines = 64;
        char *line = NULL;
        char **lines = (char**)malloc(sizeof(char*) * cap_lines);
        if (!lines) return 1;
        ssize_t r;
        while ((r = getline(&line, &cap, stdin)) != -1) {
            if (n == cap_lines) {
                cap_lines *= 2;
                char **tmp = (char**)realloc(lines, sizeof(char*) * cap_lines);
                if (!tmp) { free(line); for (size_t i=0;i<n;i++) free(lines[i]); free(lines); return 1; }
                lines = tmp;
            }
            lines[n] = (char*)malloc((size_t)r + 1);
            if (!lines[n]) { free(line); for (size_t i=0;i<n;i++) free(lines[i]); free(lines); return 1; }
            memcpy(lines[n], line, (size_t)r);
            lines[n][r] = '\0';
            n++;
        }
        for (ssize_t i = (ssize_t)n - 1; i >= 0; --i) {
            fputs(lines[(size_t)i], stdout);
            free(lines[(size_t)i]);
        }
        free(lines);
        free(line);
        return 0;
    }

    return 0; /* not a builtin (shouldn’t reach here if caller checked) */
}
