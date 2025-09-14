#ifndef LOGHIST_H
#define LOGHIST_H

#include "parser.h"

/* call once at startup */
void log_init(void);

/* decide & store per spec; returns 1 if stored, 0 if skipped */
int  log_maybe_store(command_t *root, const char *raw_line);

/* print oldest -> newest */
void log_print(void);

/* clear history file */
void log_purge(void);

/* get command by newest-first index (1 = newest).
   returns malloc'ed string caller must free; NULL on error */
char *log_get_newest_idx(int one_indexed);

/* while executing `log execute`, avoid re-logging that command */
void log_set_suppress(int on);

#endif