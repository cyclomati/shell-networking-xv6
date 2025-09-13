// mini-project1/networking/util.h
#ifndef UTIL_H
#define UTIL_H

#include <stdio.h>
#include <stdlib.h>

static inline void die(const char *msg) {
    perror(msg);
    exit(1);
}
static inline void sdprintf(const char *msg) {
    fputs(msg, stderr);
}

#endif