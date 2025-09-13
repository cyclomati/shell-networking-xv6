#ifndef INPUT_H
#define INPUT_H
#include <sys/types.h>
#include <stddef.h>
ssize_t read_line(char **buf, size_t *cap);
#endif