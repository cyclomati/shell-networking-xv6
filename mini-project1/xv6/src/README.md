XV6 Assignment Readme (Total Marks: 140)

Overview

- This xv6 extension adds a global read byte counter system call and compile‑time‑selectable schedulers (RR default, FCFS, CFS), plus a bonus MLFQ. It includes logging to verify fair scheduling decisions and a test workload to compare policies.

Build & Run

- Toolchain: RISC‑V GCC/binutils and QEMU (see stock `README`).
- Build disk + boot: `make -C mini-project1/xv6/src qemu SCHEDULER=<RR|FCFS|CFS|MLFQ> CPUS=1`
- Default: `SCHEDULER=RR` if not specified. Use `CPUS=1` for fair comparisons.

Part A — System Call: getreadcount

- Goal: Track total bytes returned by `read()` across all processes since boot; wrap on overflow.
- Kernel changes:
  - Global counter + lock: `mini-project1/xv6/src/kernel/file.c:17` and `:195`–`:210`
  - Increment on successful reads: `mini-project1/xv6/src/kernel/sysfile.c:85`
  - Syscall number: `mini-project1/xv6/src/kernel/syscall.h:27`
  - Syscall impl: `mini-project1/xv6/src/kernel/sysproc.c:16`
  - Prototypes: `mini-project1/xv6/src/kernel/defs.h:17`–`:18`
- User API:
  - Prototype: `mini-project1/xv6/src/user/user.h:34` (int `getreadcount(void)`)
  - Demo: `readcount` program `mini-project1/xv6/src/user/readcount.c:9` reads 100 bytes from `README` and prints before/after/delta.
- Notes:
  - Counter wraps naturally (unsigned int). Concurrent reads are accounted collectively.

Part B — Scheduling Policies (compile‑time via `SCHEDULER=<...>`)

Makefile Integration

- Macro pass‑through: `mini-project1/xv6/src/Makefile:38` sets `CFLAGS += -D $(SCHEDULER)`.
- Default: Round Robin (RR). Select policy at build: `make qemu SCHEDULER=FCFS` or `make qemu SCHEDULER=CFS`.

First Come First Serve [20]

- Non‑preemptive: pick RUNNABLE with smallest creation time and run until it yields/exits.
- Selection: `mini-project1/xv6/src/kernel/proc.c:860`–`:902` under `#ifdef FCFS`.
- Tick behavior: no preemption on timer interrupts (`mini-project1/xv6/src/kernel/trap.c:88`, `:184`).
- Tip: Use `Ctrl‑P` in QEMU to invoke `procdump()` (`mini-project1/xv6/src/kernel/console.c:142`, `mini-project1/xv6/src/kernel/proc.c:1207`) to observe processes.

Completely Fair Scheduler (CFS)

B.1 Priority (nice → weight) [10]

- State in PCB: `nice`, `weight`, `vruntime`, `slice_rem` (`mini-project1/xv6/src/kernel/proc.h:151`–`:155`).
- Init: `nice=0`, `weight=nice_to_weight(0)=1024`, `vruntime=0` at `allocproc()` (`mini-project1/xv6/src/kernel/proc.c:280`–`:289`).
- Weight function (approximation required): `weight = 1024 / (1.25^nice)` implemented integer‑only with repeated ×5/÷4 steps and clamped `[-20,19]` (`mini-project1/xv6/src/kernel/proc.c:601`–`:636`).

B.2 Virtual Runtime Tracking [20]

- Update per tick normalized by weight: `vruntime += delta * (1024/weight)` fixed‑point (`mini-project1/xv6/src/kernel/proc.c:649`–`:657`).
- Tick hook: `cfs_tick_and_should_preempt()` decrements `slice_rem`, updates `vruntime` (`mini-project1/xv6/src/kernel/proc.c:43`–`:56`).

B.2 Scheduling (choose smallest vruntime) [50]

- On each decision, scan RUNNABLE and pick the smallest `vruntime` (`mini-project1/xv6/src/kernel/proc.c:676`–`:720`) under `#ifdef CFS`.
- Preemption only at tick boundaries: `trap.c` timer path calls `yield()` if slice ended (`mini-project1/xv6/src/kernel/trap.c:73`–`:110`).
- Logging before pick: `cfs_log_snapshot()` prints vRuntime of all RUNNABLE and the chosen PID (`mini-project1/xv6/src/kernel/proc.c:661`–`:675`).

B.3 Time Slice Calculation [20]

- Target latency and min slice: `CFS_TARGET_LATENCY=48`, `CFS_MIN_SLICE=3` (`mini-project1/xv6/src/kernel/proc.h:1`–`:6`).
- Slice per decision: `slice = target_latency / runnable_count`, floored at min; stored in `p->slice_rem` (`mini-project1/xv6/src/kernel/proc.c:703`–`:725`).

Scheduler Logging (Report) [20]

- Enable/disable with user tool: `cfslog 1|0` (`mini-project1/xv6/src/user/cfslog.c`).
- Syscall: `setcfslog(int on)` (`mini-project1/xv6/src/kernel/sysproc.c:79`, `mini-project1/xv6/src/kernel/syscall.h:28`).
- Log format (on console):
  - `[Scheduler Tick]`
  - `PID: <pid> | vRuntime: <scaled>` for each RUNNABLE
  - `--> Scheduling PID <pid> (lowest vRuntime)`
- Example (matches requirement):
  - `[Scheduler Tick]` newline, then PIDs with vRuntime, arrow to chosen PID.

Running and Verifying

- Boot with CFS: `make qemu SCHEDULER=CFS CPUS=1`
- In the shell:
  - Enable logs: `cfslog 1`
  - Run workload: `schedulertest` (spawns CPU‑ and IO‑bound children)
  - Observe vRuntime logs and ensure lowest vRuntime is chosen.
  - Stats: `schedulertest` prints per‑child `runtime` and `wait`, plus averages.
  - Disable logs: `cfslog 0`

Part A Demo (User Program)

- In the shell: run `readcount`.
- Output shows `getreadcount before/after` and `delta` after reading 100 bytes from `README`.

Bonus — Preemptive MLFQ [25]

- Build: `make qemu SCHEDULER=MLFQ CPUS=1`
- Queues 0..3 with slices {1,4,8,16}; RR within the lowest queue; preempt on tick.
- Promotion/demotion and starvation prevention:
  - On full time slice, move to next lower priority queue (cap at 3).
  - On voluntary yield, re‑enter same queue.
  - Every 48 ticks, age all RUNNABLE processes back to queue 0.
- Implementation: `#ifdef MLFQ` block in `mini-project1/xv6/src/kernel/proc.c:908`–`:1400`.

Notes & Tips

- Default policy stays RR unless `SCHEDULER` is set at build time.
- `procdump` (Ctrl‑P) prints per‑process status helpful for debugging.
- Keep `CPUS=1` to make results comparable across policies.
- If you want to expose a setter for `nice`, add a syscall that updates `p->nice` and recomputes `p->weight`.

Grading Checklist (Mapping to Code)

- A. System Call — getreadcount: implemented; user demo present.
- B. FCFS [20]: compile flag; earliest creation time; non‑preemptive.
- B.1 Nice→Weight [10]: `nice_to_weight()`; defaults applied at spawn.
- B.2 vRuntime [20]: weighted accumulation per tick.
- B.2 Scheduling [50]: pick smallest vRuntime; tick preemption via `slice_rem`.
- B.3 Time Slice [20]: target latency and minimum enforced.
- Report [20]: scheduler tick logs show vRuntime and chosen PID; toggle via `cfslog`.
- Bonus MLFQ [25]: available under `SCHEDULER=MLFQ` with documented behavior.

