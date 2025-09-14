#include "input.h"
#include "jobs.h"
#include <stdio.h>
#include <sys/select.h>
#include <unistd.h>
#include <errno.h>

ssize_t read_line(char **buf, size_t *cap) {
    for (;;) {
        fd_set rfds;
        FD_ZERO(&rfds);
        FD_SET(STDIN_FILENO, &rfds);
        struct timeval tv;
        tv.tv_sec = 0;
        tv.tv_usec = 200000; /* 200 ms */
        int rv = select(STDIN_FILENO + 1, &rfds, NULL, NULL, &tv);
        if (rv > 0 && FD_ISSET(STDIN_FILENO, &rfds)) {
            return getline(buf, cap, stdin); /* -1 on EOF */
        } else if (rv == 0) {
            /* timeout: poll background jobs */
            jobs_check_and_report();
            continue;
        } else if (rv < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
    }
}
