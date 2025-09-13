#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include <stdint.h>

extern char *syscall_names[];

#define NUMBER_OF_SYSCALLS 32 

// sysproc.c
uint64
sys_getreadcount(void)
{
  return (uint64)get_readcount();  // returns a uint; wraps naturally
}


uint64 
sys_printlog(void) {
  print_logg();
  return 0 ;
}


uint64
 sys_sigalarm(void) {
  int intervalj;
  uint64 handlerj;

  argint(0, &intervalj) ;
  argaddr(1, &handlerj) ;
  

  struct proc *p = myproc();
  
  p->ticks = intervalj;

  p->handler = handlerj;
  p->alarm_act = 1;  // Alarm is now active
  

  return 0;
}

uint64 
sys_sigreturn(void)
{
  struct proc *p = myproc();
  memmove(p->trapframe, p->alarm_tf, PGSIZE);
 
  kfree(p->alarm_tf);
  p->hlp = 1;
  return myproc()->trapframe->a0;
}

uint64
sys_settickets(void)
{
    int n;
     (argint(0, &n)); 
     if( n < 1) {
        return -1; // Invalid input
    }
    
    // Set the tickets for the calling process
    struct proc *p = myproc();
    p->tickets = n;
    
    return 0;
}



uint64
sys_setcfslog(void)
{
  int on;
  if (argint(0, &on) < 0)
    return -1;
  cfs_logging_enabled = on;
  return 0;
}




uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0; // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_waitx(void)
{
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
  argaddr(1, &addr1); // user virtual memory
  argaddr(2, &addr2);
  int ret = waitx(addr, &wtime, &rtime);
  struct proc *p = myproc();
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    return -1;
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    return -1;
  return ret;
}
