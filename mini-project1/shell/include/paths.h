#ifndef PATHS_H
#define PATHS_H

#include <stddef.h>   // size_t

// hop: implements cd-like behavior per spec
// Usage inside builtins: return paths_hop(argc-1, &argv[1]);
int paths_hop(int argc, char **argv);

// reveal: implements ls-like behavior per spec
// Usage inside builtins: return paths_reveal(argc-1, &argv[1]);
int paths_reveal(int argc, char **argv);

// pretty path for prompt: replace leading home with '~'
void compute_pretty_path(const char *home, const char *cwd,
                         char *buf, size_t buflen);

#endif // PATHS_H