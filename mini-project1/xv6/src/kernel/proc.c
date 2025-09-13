#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"



int cfs_logging_enabled = 0;
 int j;

 #define refmin1 1000000


#include <stdint.h>
#define NUMBER_OF_SYSCALLS 32 
extern char *syscall_names[];

struct log_entry {
  int pid;
  int time; // Tick at which the event occurred
  int ticktime;
  int qquu; // qquu the process is in
};

#define MAX_LOG_ENTRIES 10071
struct log_entry logs[MAX_LOG_ENTRIES];
int log_index = 0;

int jhjh =0 ;

void log_process_qquu(struct proc *p) {
  if (log_index < MAX_LOG_ENTRIES) {
    logs[log_index].pid = p->pid - 2;
    logs[log_index].time = jhjh;
    logs[log_index].ticktime = ticks;
    logs[log_index].qquu = p->qquu;
    log_index++;
  }
}


int
cfs_tick_and_should_preempt(struct proc *p)
{
  // vruntime += 1 tick normalized by weight
  cfs_update_vruntime(p, 1);

  if(p->slice_rem > 0)
    p->slice_rem--;

  return p->slice_rem <= 0;
}


int count_trailing_zeros(uint64_t value) {
    if (value == 0) {
        return 64; // If the value is zero, return 64 (all bits are zero)
    }
    
    int count = 0;
    while ((value & 1) == 0) { // While the least significant bit is 0
        count++;
        value >>= 1; // Right shift to check the next bit
    }
    return count; // Return the count of trailing zeros
}






int rg(int l, int r)
{
  uint64 lbs_tr = (uint64)ticks + 0;
  lbs_tr = lbs_tr ^ (lbs_tr << 13);
  lbs_tr = lbs_tr ^ (lbs_tr >> 17);
  lbs_tr = lbs_tr ^ (lbs_tr << 5);

  lbs_tr = lbs_tr % (r - l);
  lbs_tr = lbs_tr + l;

  return lbs_tr;
}


int max(int a, int b)
{

  if (a > b)
  {
    return a;
  }
  else
  {
    return b;
  }
}

int min(int a, int b)
{

  if (a < b)
  {
    return a;
  }
  else
  {
    return b;
  }
}






struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;

extern void forkret(void);
static void freeproc(struct proc *p);

extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;


int jghd[4] = {0};
int arr_used_for_q[4] = {0};


// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table.
void procinit(void)
{
  struct proc *p;

  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  for (p = proc; p < &proc[NPROC]; p++)
  {
    initlock(&p->lock, "proc");
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

int allocpid()
{
  int pid;

  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->state == UNUSED)
    {
      goto found;
    }
    else
    {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

  // Allocate a trapframe page.
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
  {
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if (p->pagetable == 0)
  {
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;
   memset(p->syscall_count, 0, sizeof(p->syscall_count));
  p->rtime = 0;
  p->etime = 0;
  p->ctime = ticks;
  p->tickets = 1;
  p->arrival_t =ticks;
  p->s_tcks = 0;
  p->hlp = 1;

   p->twt = 0;
  p->qquu = 0;
  p->pqbb = 0;
  p->ind_q = jghd[0];
  jghd[0]++;
  arr_used_for_q[0]++;

  // kernel/proc.c : allocproc()
  p->nice = 0;
  p->weight = nice_to_weight(p->nice);
  p->vruntime = 0;
  p->slice_rem = 0;

  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if (p->trapframe)
    kfree((void *)p->trapframe);
  p->trapframe = 0;
  if (p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if (pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
               (uint64)trampoline, PTE_R | PTE_X) < 0)
  {
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
               (uint64)(p->trapframe), PTE_R | PTE_W) < 0)
  {
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// a user program that calls exec("/init")
// assembled from ../user/initcode.S
// od -t xC ../user/initcode
uchar initcode[] = {
    0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
    0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
    0x93, 0x08, 0x70, 0x00, 0x73, 0x00, 0x00, 0x00,
    0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
    0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
    0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00};

// Set up first user process.
void userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;

  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;     // user program counter
  p->trapframe->sp = PGSIZE; // user stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;

  release(&p->lock);


}




// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint64 sz;
  struct proc *p = myproc();

  sz = p->sz;
  if (n > 0)
  {
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    {
      return -1;
    }
  }
  else if (n < 0)
  {
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy user memory from parent to child.
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
  {
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  np->s1 = p->s1;

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for (i = 0; i < NOFILE; i++)
    if (p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;

  np->tickets = np->parent->tickets;

  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;
  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void reparent(struct proc *p)
{
  struct proc *pp;

  for (pp = proc; pp < &proc[NPROC]; pp++)
  {
    if (pp->parent == p)
    {
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void exit(int status)
{
  struct proc *p = myproc();

  if (p == initproc)
    panic("init exiting");

  // Close all open files.
  for (int fd = 0; fd < NOFILE; fd++)
  {
    if (p->ofile[fd])
    {
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);

  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;
  p->etime = ticks;

  release(&wait_lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(uint64 addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (pp = proc; pp < &proc[NPROC]; pp++)
    {
      if (pp->parent == p)
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if (pp->state == ZOMBIE)
        {
          // Found one.
          pid = pp->pid;
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
                                   sizeof(pp->xstate)) < 0)
          {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || killed(p))
    {
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.

 // Variable to track elapsed time in ticks


uint64
nice_to_weight(int nice)
{
  // Requirement: use approximation weight = 1024 / (1.25 ^ nice)
  // Implemented with integer arithmetic:
  //  - For nice > 0: repeatedly divide by (5/4) => weight = weight * 4 / 5
  //  - For nice < 0: repeatedly multiply by (5/4) => weight = weight * 5 / 4
  if(nice < -20) nice = -20;
  if(nice >  19) nice =  19;

  uint64 w = 1024;
  if(nice > 0){
    for(int i = 0; i < nice; i++){
      // round to nearest to keep values reasonable
      w = (w * 4 + 2) / 5;
      if(w < 1) w = 1;
    }
  } else if(nice < 0){
    for(int i = 0; i < -nice; i++){
      w = (w * 5 + 2) / 4;
    }
  }
  return w;
}

int
runnable_count(void)
{
  struct proc *p;
  int n = 0;
  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->state == RUNNABLE) n++;
    release(&p->lock);
  }
  return n;
}

// vruntime += delta * (1024/weight)  (fixed-point with 1024*1024 scale)
void
cfs_update_vruntime(struct proc *p, int delta_ticks)
{
  if(delta_ticks <= 0) return;
  uint64 w = p->weight ? p->weight : 1024;
  uint64 inc = ((uint64)delta_ticks * 1024ull * 1024ull) / w;
  p->vruntime += inc;
}

#ifdef CFS
static void
cfs_log_snapshot(struct proc *chosen)
{
  if (!cfs_logging_enabled) return;

  printf("[Scheduler Tick]\n");

  // Debug-only: read without locks to avoid re-entrancy/panic.
  // Matches xv6's procdump approach.
  for (struct proc *p = proc; p < &proc[NPROC]; p++) {
    if (p->state == RUNNABLE) {
      // vruntime is 64-bit; printing a scaled int for readability is fine.
      printf("PID: %d | vRuntime: %d\n", p->pid, (int)(p->vruntime / 1024));
    }
  }

  if (chosen) {
    printf("--> Scheduling PID %d (lowest vRuntime)\n", chosen->pid);
  }
}
#endif


void scheduler(void)
{  

  #ifdef CFS
  {
    struct proc *p, *best;
    struct cpu *c = mycpu();
    c->proc = 0;

    for(;;){
      intr_on();

      int nr = runnable_count();
      if(nr <= 0){
        // idle; wait for next interrupt
        asm volatile("wfi");
        continue;
      }

      // Compute fair slice (B.3)
      int slice = CFS_TARGET_LATENCY / nr;
      if(slice < CFS_MIN_SLICE) slice = CFS_MIN_SLICE;

      // Pick RUNNABLE with smallest vruntime (B.2 Scheduling)
      best = 0;
      uint64 best_vr = ~0ull;

      for(p = proc; p < &proc[NPROC]; p++){
        acquire(&p->lock);
        if(p->state == RUNNABLE && p->vruntime < best_vr){
          if(best) release(&best->lock);
          best = p;
          best_vr = p->vruntime;
        }else{
          release(&p->lock);
        }
      }

      // Required logging (before decision) + chosen process
      
     if (best) {
  cfs_log_snapshot(best);
  best->slice_rem = slice;
  best->state = RUNNING;
  c->proc = best;
  swtch(&c->context, &best->context);
  c->proc = 0;
  // still holding best->lock per xv6 convention
  release(&best->lock);
}

    }
  }
#endif

#ifdef FCFS
{
  struct cpu *c = mycpu();
  c->proc = 0;

 for(;;){
  intr_on();
  struct proc *minP = 0;
  uint64 best_ctime = ~0ull;

  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->state == RUNNABLE && p->ctime < best_ctime){
      if(minP) release(&minP->lock);
      minP = p;
      best_ctime = p->ctime;
    } else {
      release(&p->lock);
    }
  }

  if(minP){
    minP->state = RUNNING;
    c->proc = minP;
    swtch(&c->context, &minP->context);
    c->proc = 0;
    release(&minP->lock);
  } else {
    asm volatile("wfi");
  }
}

}
#endif


  
 
#ifdef MLFQ

 struct proc *p;
  struct proc *q;
  struct cpu *c = mycpu();
  // Bonus MLFQ: time slices by qquu 0..3
  int ccc_p[4] = {1, 4, 8, 16};
  c->proc = 0;

  for (;;)
  {
        intr_on();
    jhjh++; 
    int qm = 4;
    for (p = proc; p < &proc[NPROC]; p++)
    {
      acquire(&p->lock);
      if (p->state == RUNNABLE && p->qquu < qm)
      {
        qm = p->qquu;
      }
      release(&p->lock);
    }

    if(qm == 3) {
      for (p = proc; p < &proc[NPROC]; p++)
      {
        acquire(&p->lock);
        if (p->state == RUNNABLE)
        {
          p->state = RUNNING;
          c->proc = p;
          swtch(&c->context, &p->context);
          c->proc = 0;
          for (q = proc; q < &proc[NPROC]; q++)
          {
            
            if (p != q && q->state == RUNNABLE)
            {
              acquire(&q->lock);
              q->pqbb++;

              if (q-> pqbb >= 48)
              {
                if(q->pid > 2) log_process_qquu(q);
                jghd[q->qquu]--;
                q->qquu=0;
                jghd[q->qquu]++;
                q->twt = 0;
                q->pqbb = 0;
                q->ind_q = arr_used_for_q[q->qquu];
                arr_used_for_q[q->qquu]++;
               if(q->pid > 2) log_process_qquu(q);
              }
              release(&q->lock);
            }
          }
          
        }
        release(&p->lock);
      }
    }
    else
    {
      int refm = refmin1;
      struct proc *prngd = 0;
      for (p = proc; p < &proc[NPROC]; p++)
      {
        acquire(&p->lock);
        if (p->state == RUNNABLE && p->qquu == qm)
        {
          if (p->ind_q < refm)
          {
            prngd = p;
            refm = p->ind_q;
          }
        }
        release(&p->lock);
      }
     
      for (p = proc; p < &proc[NPROC]; p++)
      {
        acquire(&p->lock);
        
         if (p->state == RUNNABLE && p != prngd)
        {
        
          p->pqbb++;
          if (p->qquu != 0)
          {
            if (p->pqbb >= 48)
            {
              if(p->pid > 2) ;
              jghd[p->qquu]--;
              p->qquu = 0;
              jghd[p->qquu]++;
              p->twt = 0;
              p->pqbb = 0;
              p->ind_q = arr_used_for_q[p->qquu];
              arr_used_for_q[p->qquu]++;
               if(p->pid > 2) ;
            }
          }
        }
        else if (p->state == RUNNABLE && p == prngd)
        {

          p->state = RUNNING;
          c->proc = p;
          swtch(&c->context, &p->context);

          c->proc = 0;
          p->twt++;
          if(p->pid > 2) ;
          if (p->twt >= ccc_p[p->qquu] && p->qquu != 3)
          {
            jghd[p->qquu]--;
            p->qquu++;
            jghd[p->qquu]++;
            p->twt = 0;
            p->ind_q = arr_used_for_q[p->qquu];
            arr_used_for_q[p->qquu]++;
            if(p->pid > 2) ;
          }
          p->pqbb = 0;
        
        }
        release(&p->lock);
      }
    }
  }
  #endif



  #ifdef RR
  struct proc *p;
  struct cpu *c = mycpu();

  c->proc = 0;
  for (;;)
  {
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();

    for (p = proc; p < &proc[NPROC]; p++)
    {
      acquire(&p->lock);
      if (p->state == RUNNABLE)
      {
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        p->state = RUNNING;
        c->proc = p;
        swtch(&c->context, &p->context);

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
      }
      release(&p->lock);
    }
  }
  #endif


}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&p->lock))
    panic("sched p->lock");
  if (mycpu()->noff != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  struct proc *p = myproc();
  acquire(&p->lock);
  p->state = RUNNABLE;
  sched();
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);

  if (first)
  {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
      {
        p->state = RUNNABLE;
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->pid == pid)
    {
      p->killed = 1;
      if (p->state == SLEEPING)
      {
        // Wake process from sleep().
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

int getSysCount(int mask) 
{
  struct proc *p = myproc(); // Get the current process
  
  
   for (int i = 1; i < NUMBER_OF_SYSCALLS; i++) {

    if ((mask>>i) & 1) j =i;

   }
   printf("PID %d called %s %d times.\n",p-> pid, syscall_names[j-1], p->syscall_count[j]);
   return p->syscall_count[j];
}

void setkilled(struct proc *p)
{
  acquire(&p->lock);
  p->killed = 1;
  release(&p->lock);
}

int killed(struct proc *p)
{
  int k;

  acquire(&p->lock);
  k = p->killed;
  release(&p->lock);
  return k;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if (user_dst)
  {
    return copyout(p->pagetable, dst, src, len);
  }
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if (user_src)
  {
    return copyin(p->pagetable, dst, src, len);
  }
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  /* static char *states[] = {
      [UNUSED] "unused",
      [USED] "used",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"}; */
  struct proc *p;
 // char *state;

  printf("\n");
  for (p = proc; p < &proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
   /* if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???"; */
    
    
    //printf("%d %s", p->pid, p->name);
     if(p->pid > 2){
    printf("%d  %d  %d  %d  %d ", p->pid, p->qquu, p->twt, p->pqbb,p->ind_q);
    //printf("#NN - %d %s %s %d %d %d %d", p->pid, p->state, p->name, p->qquu, p->tickcount, p->waittickcount, p->qquuposition);
    printf("\n");
    }
  }
}

int
waitx(uint64 addr, uint *wtime, uint *rtime)
{
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);
  for (;;) {
    havekids = 0;
    for (np = proc; np < &proc[NPROC]; np++) {
      if (np->parent == p) {
        havekids = 1;
        acquire(&np->lock);
        if (np->state == ZOMBIE) {
          pid    = np->pid;
          if (rtime) *rtime = np->rtime;
          if (wtime) *wtime = np->etime - np->ctime - np->rtime;

          if (addr != 0 && copyout(p->pagetable, addr,
                                   (char*)&np->xstate, sizeof(np->xstate)) < 0) {
            release(&np->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(np);
          release(&np->lock);
          release(&wait_lock);
          return pid;
        }
        release(&np->lock);
      }
    }
    if (!havekids || killed(p)) {
      release(&wait_lock);
      return -1;
    }
    sleep(p, &wait_lock);
  }
}

void update_time()
{
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    {
   
    }
    release(&p->lock);
  }
}


void print_logg() {
    // Check if there are any log entries to print
    if (log_index == 0) {
        printf("No log entries available.\n");
        return;
    }

    printf("Process qquu Log:\n");
    printf("----------------------------------------------------\n");
    printf("| PID | Time | qquu | TckTime\n");
    printf("----------------------------------------------------\n");

    // Loop through each log entry and print the details
    for (int i = 0; i < log_index; i++) {
        printf("| %d | %d | %d | %d |\n", logs[i].pid, logs[i].time, logs[i].qquu, logs[i].ticktime) ;
    }

    printf("----------------------------------------------------\n");
}
