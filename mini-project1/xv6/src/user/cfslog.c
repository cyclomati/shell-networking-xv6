#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc != 2){
    printf("usage: cfslog <0|1>\n");
    exit(1);
  }
  int on = argv[1][0] == '1' ? 1 : 0;
  int r = setcfslog(on);
  if(r < 0){
    printf("cfslog: failed to set log %d\n", on);
    exit(1);
  }
  printf("cfslog: logging %s\n", on ? "enabled" : "disabled");
  exit(0);
}

