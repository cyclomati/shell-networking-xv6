// mini-project1/networking/logging.h
#ifndef LOGGING_H
#define LOGGING_H

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <stdarg.h>

typedef struct {
    FILE *fp;
    int   enabled;
} rudp_logger_t;

static inline void rudp_log_init(rudp_logger_t *lg, const char *role_name) {
    lg->enabled = 0;
    lg->fp = NULL;
    const char *env = getenv("RUDP_LOG");
    if (!env || env[0] != '1') return;
    lg->enabled = 1;
    const char *fname = (role_name && role_name[0]=='c') ? "client_log.txt" : "server_log.txt";
    lg->fp = fopen(fname, "w");
    if (!lg->fp) lg->enabled = 0;
}

static inline void rudp_logf(rudp_logger_t *lg, const char *fmt, ...) {
    if (!lg || !lg->enabled || !lg->fp) return;
    char timebuf[32];
    struct timeval tv;
    gettimeofday(&tv, NULL);
    time_t cur = tv.tv_sec;
    strftime(timebuf, sizeof(timebuf), "%Y-%m-%d %H:%M:%S", localtime(&cur));
    fprintf(lg->fp, "[%s.%06ld] [LOG] ", timebuf, (long)tv.tv_usec);
    va_list ap;
    va_start(ap, fmt);
    vfprintf(lg->fp, fmt, ap);
    va_end(ap);
    fputc('\n', lg->fp);
    fflush(lg->fp);
}

static inline void rudp_log_close(rudp_logger_t *lg) {
    if (lg && lg->fp) { fclose(lg->fp); lg->fp = NULL; }
}

#endif