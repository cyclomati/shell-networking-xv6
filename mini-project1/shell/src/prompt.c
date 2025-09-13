#include "prompt.h"
#include "paths.h"
#include <unistd.h>
#include <pwd.h>
#include <stdio.h>
#include <limits.h>

void print_prompt(const char *home, const char *user, const char *host) {
    char cwd[PATH_MAX] = {0}, shown[PATH_MAX] = {0};
    if (!getcwd(cwd, sizeof(cwd))) return;
    compute_pretty_path(home, cwd, shown, sizeof(shown));
    printf("<%s@%s:%s> ", user ? user : "user", host ? host : "host", shown);
    fflush(stdout);
}