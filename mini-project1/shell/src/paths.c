#include "paths.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <dirent.h>
#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>

#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

// Keep module-local state for home and "previous directory".
static char g_home[PATH_MAX] = {0};
static char g_prev[PATH_MAX] = {0};
static int  g_prev_set = 0;
static int  g_home_set = 0;

static void ensure_home_initialized(void) {
    if (!g_home_set) {
        if (!getcwd(g_home, sizeof(g_home))) {
            g_home[0] = '\0';
        }
        g_home_set = 1;
    }
}

void compute_pretty_path(const char *home, const char *cwd,
                         char *buf, size_t buflen)
{
    if (!home || !cwd || !buf || buflen == 0) return;

    size_t hlen = strlen(home);
    if (hlen > 0 &&
        strncmp(cwd, home, hlen) == 0 &&
        (cwd[hlen] == '/' || cwd[hlen] == '\0'))
    {
        if (cwd[hlen] == '\0') {
            snprintf(buf, buflen, "~");
        } else {
            snprintf(buf, buflen, "~%s", cwd + hlen);
        }
    } else {
        snprintf(buf, buflen, "%s", cwd);
    }
}

// ---------- hop ----------

static int change_to(const char *path) {
    char cur[PATH_MAX];
    if (!getcwd(cur, sizeof(cur))) cur[0] = '\0';

    if (chdir(path) == 0) {
        // update previous dir
        if (cur[0] != '\0') {
            strncpy(g_prev, cur, sizeof(g_prev) - 1);
            g_prev[sizeof(g_prev) - 1] = '\0';
            g_prev_set = 1;
        }
        return 0;
    }
    return -1;
}

int paths_hop(int argc, char **argv) {
    ensure_home_initialized();

    if (argc == 0) {
        // No args: go to home
        if (g_home[0] == '\0' || change_to(g_home) != 0) {
            puts("No such directory!");
            return 1;
        }
        return 0;
    }

    // Execute each argument sequentially
    for (int i = 0; i < argc; ++i) {
        const char *arg = argv[i];

        if (strcmp(arg, "~") == 0) {
            if (g_home[0] == '\0' || change_to(g_home) != 0) {
                puts("No such directory!");
                return 1;
            }
        } else if (strcmp(arg, ".") == 0) {
            // do nothing
        } else if (strcmp(arg, "..") == 0) {
            if (change_to("..") != 0) {
                // if no parent (e.g., /), do nothing as per spec
            }
        } else if (strcmp(arg, "-") == 0) {
            if (g_prev_set) {
                if (change_to(g_prev) != 0) {
                    // if prev vanished, do nothing
                }
            } else {
                // before first non-"-" hop occurred: do nothing
            }
        } else {
            // relative or absolute path
            if (change_to(arg) != 0) {
                puts("No such directory!");
                return 1;
            }
        }
    }

    return 0;
}

// ---------- reveal ----------

static int name_is_hidden(const char *name) {
    return name[0] == '.';
}

static int cmp_ascii(const void *a, const void *b) {
    const char *const *pa = (const char *const *)a;
    const char *const *pb = (const char *const *)b;
    return strcmp(*pa, *pb); // ASCII-order compare
}

int paths_reveal(int argc, char **argv) {
    ensure_home_initialized();

    // Parse flags: -a and -l (can be repeated and combined)
    int show_all = 0;
    int long_list = 0;

    int argi = 0;
    for (; argi < argc; ++argi) {
        const char *t = argv[argi];
        if (t[0] != '-') break;           // not a flag → stop flags
        if (t[1] == '\0') break;         // lone "-" is a positional arg (prev dir)
        for (int k = 1; t[k] != '\0'; ++k) {
            if (t[k] == 'a') show_all = 1;
            else if (t[k] == 'l') long_list = 1;
            else {
                // unknown flag treated as normal char per spec? They only mention a/l.
                // We'll ignore unknowns to be lenient.
            }
        }
    }

    // Remaining non-flag args: directory 0 or 1 allowed
    const char *dir_arg = NULL;
    if (argi < argc) {
        dir_arg = argv[argi++];
    }
    if (argi < argc) {
        // too many args
        puts("reveal: Invalid Syntax!");
        return 1;
    }

    char target[PATH_MAX] = {0};

    if (!dir_arg) {
        // no argument → list CWD
        if (!getcwd(target, sizeof(target))) {
            puts("No such directory!");
            return 1;
        }
    } else if (strcmp(dir_arg, "~") == 0) {
        if (g_home[0] == '\0') {
            puts("No such directory!");
            return 1;
        }
        strncpy(target, g_home, sizeof(target) - 1);
        target[sizeof(target) - 1] = '\0';
    } else if (strcmp(dir_arg, ".") == 0) {
        if (!getcwd(target, sizeof(target))) {
            puts("No such directory!");
            return 1;
        }
    } else if (strcmp(dir_arg, "..") == 0) {
        // build parent of cwd
        char cwd[PATH_MAX] = {0};
        if (!getcwd(cwd, sizeof(cwd))) {
            puts("No such directory!");
            return 1;
        }
        // Append "/.." and let OS canonicalize via opendir
        snprintf(target, sizeof(target), "%s/..", cwd);
    } else if (strcmp(dir_arg, "-") == 0) {
        if (!g_prev_set) {
            puts("No such directory!");
            return 1;
        }
        strncpy(target, g_prev, sizeof(target) - 1);
        target[sizeof(target) - 1] = '\0';
    } else {
        // relative or absolute path to list
        strncpy(target, dir_arg, sizeof(target) - 1);
        target[sizeof(target) - 1] = '\0';
    }

    DIR *dp = opendir(target);
    if (!dp) {
        puts("No such directory!");
        return 1;
    }

    // Collect names
    size_t cap = 64, n = 0;
    char **names = malloc(cap * sizeof(*names));
    if (!names) { closedir(dp); return 1; }

    struct dirent *de;
    while ((de = readdir(dp)) != NULL) {
        const char *nm = de->d_name;
        if (!show_all && name_is_hidden(nm)) continue;

        if (n == cap) {
            cap *= 2;
            char **tmp = realloc(names, cap * sizeof(*tmp));
            if (!tmp) { /* out of mem */ break; }
            names = tmp;
        }
        names[n] = strdup(nm);
        if (!names[n]) { /* out of mem */ break; }
        ++n;
    }
    closedir(dp);

    // Sort ASCII
    qsort(names, n, sizeof(names[0]), cmp_ascii);

    // Print
    if (long_list) {
        for (size_t i = 0; i < n; ++i) {
            puts(names[i]);
        }
    } else {
        for (size_t i = 0; i < n; ++i) {
            fputs(names[i], stdout);
            if (i + 1 < n) fputc(' ', stdout);
        }
        if (n > 0) fputc('\n', stdout);
    }

    // Free
    for (size_t i = 0; i < n; ++i) free(names[i]);
    free(names);
    return 0;
}
