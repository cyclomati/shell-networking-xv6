#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define NFORK 10
#define IO 5

int main(void) {
  int n, pid;
  int started = 0;

  printf("schedulertest: starting %d children (IO=%d)\n", NFORK, IO);
  setcfslog(1);

  for (n = 0; n < NFORK; n++) {
    pid = fork();
    if (pid < 0)
      break;
    if (pid == 0) {
      if (n < IO) {
        sleep(200);               // IO-bound-ish
      } else {
        for (volatile int i = 0; i < 1000000000; i++) { } // CPU-bound
      }
      exit(0);
    } else {
      started++;
    }
  }

  // Parent waits and prints per-child stats (requires waitx)
  int exited = 0;
  int w = 0, r = 0;
  long long sumw = 0, sumr = 0;
  int cpid;

  while (exited < started && (cpid = waitx(0, &w, &r)) > 0) {
    printf("child %d: runtime=%d wait=%d\n", cpid, r, w);
    sumw += w;
    sumr += r;
    exited++;
  }

  if (exited > 0) {
    printf("schedulertest: done. pid=%d avg_runtime=%d avg_wait=%d\n",
           exited, (int)(sumr / exited), (int)(sumw / exited));
  } else {
    printf("schedulertest: no children waited\n");
  }

  
  setcfslog(0);

  exit(0);
}
