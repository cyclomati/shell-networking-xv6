// mini-project1/networking/timer.h
#ifndef TIMER_H
#define TIMER_H

#include <sys/time.h>
#include <stdint.h>

static inline uint64_t now_us(void) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (uint64_t)tv.tv_sec * 1000000ULL + (uint64_t)tv.tv_usec;
}

#endif