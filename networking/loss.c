// mini-project1/networking/loss.c
#include <stdlib.h>
#include <time.h>

static double g_loss_rate = 0.0;

void loss_init(double rate) {
    if (rate < 0) rate = 0;
    if (rate > 1) rate = 1;
    g_loss_rate = rate;
    static int seeded = 0;
    if (!seeded) { srand((unsigned)time(NULL)); seeded = 1; }
}

int loss_should_drop(void) {
    double r = (double)rand() / (double)RAND_MAX;
    return r < g_loss_rate;
}