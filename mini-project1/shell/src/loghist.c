#include "loghist.h"
#include "parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <unistd.h>

#define MAX_HIST 15

static char hist_path[PATH_MAX] = {0};
static int suppress = 0;

static void build_path(void) {
    if (hist_path[0]) return;
    const char *home = getenv("HOME");
    if (!home) home = ".";
    snprintf(hist_path, sizeof(hist_path), "%s/.mysh_history", home);
}

void log_set_suppress(int on) { suppress = on ? 1 : 0; }

void log_init(void) { build_path(); }

/* load all lines into memory; returns count.
   out[i] are malloc'ed; caller frees with free_lines */
static int load_lines(char **out, int max) {
    build_path();
    FILE *f = fopen(hist_path, "r");
    if (!f) return 0;
    char *line = NULL; size_t cap = 0;
    int n = 0;
    while (getline(&line, &cap, f) != -1 && n < max) {
        size_t L = strlen(line);
        while (L && (line[L-1] == '\n' || line[L-1] == '\r')) line[--L] = 0;
        out[n++] = strdup(line);
    }
    free(line);
    fclose(f);
    return n;
}

static void save_lines(char **arr, int n) {
    build_path();
    FILE *f = fopen(hist_path, "w");
    if (!f) return;
    for (int i = 0; i < n; ++i) {
        fprintf(f, "%s\n", arr[i]);
    }
    fclose(f);
}

static void free_lines(char **arr, int n) {
    for (int i = 0; i < n; ++i) free(arr[i]);
}

/* walk tree; return 1 if any command is "log" */
static int tree_has_log(command_t *root) {
    for (command_t *g = root; g; g = g->next_seq) {
        for (command_t *p = g; p; p = p->next_pipe) {
            if (p->argv && p->argv[0] && strcmp(p->argv[0], "log") == 0) {
                return 1;
            }
        }
    }
    return 0;
}

int log_maybe_store(command_t *root, const char *raw_line) {
    if (suppress) return 0;                     // executing from history
    if (!raw_line || !*raw_line) return 0;
    if (tree_has_log(root)) return 0;           // skip anything with 'log'

    char *arr[MAX_HIST+1] = {0};
    int n = load_lines(arr, MAX_HIST);

    // skip if identical to previous (exact match)
    if (n > 0 && strcmp(arr[n-1], raw_line) == 0) {
        free_lines(arr, n);
        return 0;
    }

    // append; if exceed, drop oldest
    if (n == MAX_HIST) {
        free(arr[0]);
        memmove(&arr[0], &arr[1], sizeof(arr[0]) * (MAX_HIST-1));
        n = MAX_HIST-1;
    }
    arr[n++] = strdup(raw_line);
    save_lines(arr, n);
    free_lines(arr, n);
    return 1;
}

void log_print(void) {
    char *arr[MAX_HIST] = {0};
    int n = load_lines(arr, MAX_HIST);
    for (int i = 0; i < n; ++i) puts(arr[i]);
    free_lines(arr, n);
}

void log_purge(void) {
    build_path();
    FILE *f = fopen(hist_path, "w");
    if (f) fclose(f);
}

char *log_get_newest_idx(int one_indexed) {
    if (one_indexed <= 0) return NULL;
    char *arr[MAX_HIST] = {0};
    int n = load_lines(arr, MAX_HIST);
    // newest -> oldest indexing
    int idx = n - one_indexed;
    char *res = NULL;
    if (idx >= 0 && idx < n) res = strdup(arr[idx]);
    free_lines(arr, n);
    return res;
}