#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
  int before = getreadcount();
  printf("getreadcount before = %d\n", before);

  int fd = open("README", O_RDONLY);
  if(fd < 0){
    printf("open README failed\n");
    exit(1);
  }

  char buf[100];
  int want = 100;
  int got = read(fd, buf, want);
  close(fd);

  if(got < 0){
    printf("read failed\n");
    exit(1);
  }

  int after = getreadcount();
  printf("read returned      = %d\n", got);
  printf("getreadcount after = %d\n", after);
  printf("delta              = %d\n", (after - before));

  if(got > 0 && (after - before) != got){
    printf("note: delta != bytes read (wrap or concurrent reads)\n");
  }
  exit(0);
}
