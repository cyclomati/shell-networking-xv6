Mini‑Project 1 — Shell, Networking, and XV6 (Common README)

Overview

- Three parts implemented in C:
  - Shell: a small interactive shell with job control, pipelines, redirections, history, and utility built‑ins.
  - Networking: a reliable protocol built atop UDP (“S.H.A.M.”) that supports file transfer and interactive chat, with logging and packet‑loss simulation.
  - XV6: kernel extensions including a global read byte counter syscall and selectable schedulers (RR, FCFS, CFS), with optional MLFQ bonus and scheduler logging.

Repository Layout

- Shell: `mini-project1/shell`
- Networking: `mini-project1/networking`
- XV6: `mini-project1/xv6/src`

Prerequisites

- Common: GCC/Clang, Make.
- Networking:
  - Linux: `sudo apt update && sudo apt install -y libssl-dev`
  - macOS: `brew install openssl@3`
- XV6:
  - RISC‑V toolchain and QEMU as described in `mini-project1/xv6/src/README` (stock xv6 requirements).

Part A — Shell

- Build: `make -C mini-project1/shell`
- Run: `mini-project1/shell/shell.out`
- Features:
  - Parsing: sequences (`;`), background (`&`), pipelines (`|`), I/O redirections (`<`, `>`, `>>`).
  - Job control: background execution, `jobs`, `fg`, `bg`, correct terminal handoff, and signal forwarding (Ctrl‑C/Z) to foreground job.
  - History log: persistent command log with dedupe and filtering of `log` commands; execute previous entries.
  - Built‑ins (no external dependencies):
    - `hop [path ...]`: cd‑like navigation. Supports `~`, `.`, `..`, `-` (previous dir). Multiple hops in one command.
    - `reveal [-a] [-l] [dir]`: list directory; `-a` shows hidden, `-l` prints one per line; ASCII order.
    - `jobs`: list background/stopped jobs.
    - `fg [jobno]`, `bg [jobno]`: bring to foreground / resume in background (defaults to last job).
    - `activities`: print “[pid] : name - Running|Stopped” sorted by name.
    - `ping <pid> <signal>`: send a signal number (mod 32) to a pid (prints per spec).
    - `log`: print command history (oldest→newest).
    - `log purge`: clear history.
    - `log execute <N>`: execute the N‑th most recent command (newest‑first index).
    - `true`, `false`, `tac` (stdin lines reversed; fallback if GNU tac absent).
- Key files:
  - Parser/executor: `mini-project1/shell/src/parser.c`, `.../exec.c`
  - Jobs/signals: `mini-project1/shell/src/jobs.c`, `.../signals.c`
  - Built‑ins: `mini-project1/shell/src/builtins.c`

Part B — Networking (S.H.A.M. Reliable UDP)

- In‑depth spec and examples: `mini-project1/networking/README.md`
- Build: `make -C mini-project1/networking`
- Programs: `mini-project1/networking/server`, `mini-project1/networking/client`
- Usage:
  - Server: `./server <port> [--chat] [loss_rate]`
  - Client file mode: `./client <server_ip> <port> <input_file> <output_file_name> [loss_rate]`
  - Client chat mode: `./client <server_ip> <port> --chat [loss_rate]`
- Highlights:
  - Header: 32‑bit `seq_num`/`ack_num`, 16‑bit flags (SYN/ACK/FIN), 16‑bit `window_size`.
  - Connection: 3‑way handshake; 4‑way FIN close. Chat uses `/quit` to close.
  - Data: MSS=1024, sliding window (10 packets), cumulative ACKs, per‑packet retransmission with RTO=500ms.
  - Flow control: receiver advertises available bytes via `window_size`; sender caps new in‑flight bytes.
  - Logging: set `RUDP_LOG=1` to write `client_log.txt`/`server_log.txt` with timestamps.
  - Loss simulation: receiver drops only DATA packets per `loss_rate`; logs `DROP DATA SEQ=...`.
  - File mode: server prints `MD5: <32-hex>` on success (OpenSSL/CommonCrypto helper).

Quick examples

- File transfer (no loss):
  - Terminal 1: `cd mini-project1/networking && RUDP_LOG=1 ./server 9000`
  - Terminal 2: `cd mini-project1/networking && RUDP_LOG=1 ./client 127.0.0.1 9000 sample.txt received.txt`
- Chat: 
  - Server: `./server 9001 --chat`
  - Client: `./client 127.0.0.1 9001 --chat`
  - Type `/quit` to close gracefully.

Part C — XV6 (Syscall + Schedulers)

- In‑depth details: `mini-project1/xv6/src/README.md`
- Build & run (1 CPU for comparisons):
  - `make -C mini-project1/xv6/src clean`
  - `make -C mini-project1/xv6/src qemu SCHEDULER=<RR|FCFS|CFS|MLFQ> CPUS=1`

System Call — getreadcount

- Tracks total bytes returned by `read()` across the system since boot (wraps on overflow).
- User program: `readcount` prints the counter before/after reading 100 bytes.
- Relevant files:
  - Counter and updates: `mini-project1/xv6/src/kernel/file.c`
  - Hook in `read`: `mini-project1/xv6/src/kernel/sysfile.c`
  - Syscall glue: `mini-project1/xv6/src/kernel/sysproc.c`, `.../syscall.h`, `.../user/user.h`

Schedulers (compile‑time selectable)

- RR (default): unchanged xv6 round‑robin.
- FCFS [20]: non‑preemptive; picks RUNNABLE with earliest creation time. No timer preemption.
- CFS:
  - Priority/weight [10]: `nice` ∈ [-20,19]; weight via integer approx of `1024/(1.25^nice)`.
  - vRuntime [20]: accumulates normalized ticks `delta * (1024/weight)`.
  - Scheduling [50]: pick RUNNABLE with smallest vRuntime; time slice = `target_latency / runnable_count` with min slice=3 (target=48).
  - Logging [Report 20]: `cfslog 1` prints, at each decision: `[Scheduler Tick]`, PIDs with vRuntime, and the chosen PID.
- Bonus MLFQ [25]: 4 queues (0..3) with slices {1,4,8,16}, RR in lowest queue, preempt on tick, periodic aging.

Useful user programs

- `readcount`: demonstrates `getreadcount` syscall.
- `schedulertest`: mixed IO/CPU workload; prints per‑child runtime/wait and averages.
- `cfslog 1|0`: enable/disable CFS scheduler logging.

Troubleshooting

- Networking: On macOS, ensure OpenSSL is installed; Makefile auto‑detects Homebrew’s headers/libs.
- XV6: Verify RISC‑V toolchain and QEMU are in your PATH; keep `CPUS=1` for fair comparisons.
- Shell: If terminal control looks odd after a crash, run `reset` in your terminal.

References

- Shell sources: `mini-project1/shell/src/*`
- Networking spec: `mini-project1/networking/README.md`
- XV6 details: `mini-project1/xv6/src/README.md`

Detailed Guide

Shell Details

- Prompt: `<username@hostname:cwd>` where `cwd` shows `~` when the startup directory is an ancestor. Example: `<rudy@iiit:~>` then `<rudy@iiit:~/osnmp1>`.
- Parsing (CFG): Accepts `shell_cmd -> group ((&|;) group)* &?`, `group -> atomic (| atomic)*`, `atomic -> name (name|<name|>name|>>name)*`. Arbitrary whitespace allowed between tokens.
- Valid vs Invalid: On invalid syntax print exactly `Invalid Syntax!` and continue prompting.
- Execution:
  - Sequences `;` run left-to-right, waiting between commands.
  - Background `&` prints `[jobno] pid` and returns immediately; background jobs cannot read from the terminal.
  - Pipes `|` connect stdout→stdin across children, with proper closing of fds; the shell waits for the entire pipeline unless backgrounded.
  - Redirection: Last redirection wins. Input: `<` opens read-only; on failure print `No such file or directory`. Output: `>` truncates, `>>` appends; on failure print `Unable to create file for writing`.
- Built-ins (parent/child):
  - Parent-only: `hop`, `jobs`, `fg`, `bg` (non-pipeline, foreground).
  - Others run in child (so they work in pipelines/background): `reveal`, `activities`, `ping`, `log`, `true`, `false`, `tac`.
- Jobs and Signals:
  - After each input timeout, the shell polls finished background jobs and prints either `exited normally` or `exited abnormally` with the command name (first token).
  - Ctrl-C/Z are forwarded to the foreground process group; the shell itself does not exit/stop.
  - `fg [N]` brings job N (or most recent) to foreground, prints the full command, hands over the terminal, and waits.
  - `bg [N]` resumes a stopped job; prints `[N] name &`. If already running, print `Job already running`. Missing job → `No such job`.
- reveal specifics:
  - `-a` shows dotfiles; `-l` prints one per line; default prints in ASCII-sorted order on one line. Too many non-flag args → `reveal: Invalid Syntax!`.
  - `reveal -` before any `hop` prints `No such directory!`.
- ping specifics: `ping <pid> <signal>`; takes `signal % 32`. If PID invalid/missing → `No such process found`.
- log specifics: Store up to 15 full `shell_cmd` strings; skip duplicates and `log` commands; persistent across runs; `log`, `log purge`, `log execute <index>` (newest-first index). Bad usage → `log: Invalid Syntax!`.

Networking Details

- Programs: `server` (binds UDP), `client` (sends to server). Both support chat and file modes.
- Protocol header (S.H.A.M.): `seq_num` (first byte in packet), `ack_num` (cumulative next expected), `flags` (SYN=0x1/ACK=0x2/FIN=0x4), `window_size` (available bytes to accept).
- Connection management:
  - 3‑way handshake (SYN → SYN|ACK → ACK).
  - 4‑way close (FIN → ACK → FIN → ACK). Chat’s `/quit` triggers this; both sides exit after their FIN is ACKed and peer FIN is seen.
- File transfer:
  - First DATA carries NUL‑terminated output filename; subsequent DATA are file bytes.
  - Sender uses sliding window of 10 packets, MSS=1024; cumulative ACK; per‑packet RTO=500ms and selective retransmit.
  - Receiver buffers out‑of‑order, ACKs cumulatively, and advertises available bytes in every ACK (`window_size`).
  - Server prints `MD5: <32-hex>` on success.
- Chat:
  - Multiplexes stdin and socket with `select()`; forwards DATA as typed lines. Type `/quit` to close gracefully.
- Loss simulation:
  - Set `loss_rate` (0.0–1.0). Only DATA is dropped by `loss.c`; control (SYN/ACK/FIN) is not.
- Logging (RUDP_LOG=1):
  - Writes `client_log.txt` or `server_log.txt` with microsecond timestamps and events: SND/RCV for SYN/SYN‑ACK/ACK, DATA (SEQ/LEN), ACK (ACK/WIN), TIMEOUT/RETX, FLOW WIN UPDATE, DROP DATA, FIN/ACK FOR FIN.

XV6 Details

- Build:
  - `make -C mini-project1/xv6/src qemu SCHEDULER=<RR|FCFS|CFS|MLFQ> CPUS=1`
  - Toolchain & QEMU setup per stock xv6 README.
- Syscall `getreadcount`:
  - Counts bytes returned by `read()` across all processes; wraps on overflow.
  - Test with `readcount` (reads 100 bytes → delta 100).
- Schedulers:
  - RR: default; preempts every tick.
  - FCFS: non‑preemptive; earliest creation time wins; no timer preemption.
  - CFS: `nice`→`weight≈1024/(1.25^nice)`; `vruntime += delta*(1024/weight)`; time slice = `48 / runnable_count` (min 3). Enable logs via `cfslog 1`.
  - MLFQ (bonus): queues 0..3 with slices {1,4,8,16}, preempt at tick, aging every 48 ticks.
- Report: see `mini-project1/xv6/report.md` for logs, formulas, and performance comparisons from `schedulertest`.

Exact Output Strings (Shell)

- Invalid syntax: `Invalid Syntax!`
- Missing input file: `No such file or directory`
- Output create failure: `Unable to create file for writing`
- Command not found: `Command not found!`
- Background complete (normal): `<cmd> with pid <pid> exited normally`
- Background complete (abnormal): `<cmd> with pid <pid> exited abnormally`
- reveal bad usage: `reveal: Invalid Syntax!`
- ping unknown process: `No such process found`
- bg already running: `Job already running`
- fg/bg bad job: `No such job`
- Ctrl‑D exit: prints `logout` and exits 0

Make/Run Cheat Sheet

- Shell:
  - Build: `make -C mini-project1/shell`
  - Run: `mini-project1/shell/shell.out`
- Networking:
  - Build: `make -C mini-project1/networking`
  - Run server: `cd mini-project1/networking && ./server 9000`
  - Run client (file): `./client 127.0.0.1 9000 sample.txt received.txt`
  - Run chat: `./server 9001 --chat` and `./client 127.0.0.1 9001 --chat`
  - Logging: `RUDP_LOG=1 ./server ...` and `RUDP_LOG=1 ./client ...`
- XV6:
  - Clean: `make -C mini-project1/xv6/src clean`
  - Boot (RR): `make -C mini-project1/xv6/src qemu SCHEDULER=RR CPUS=1`
  - Boot (CFS): `... SCHEDULER=CFS CPUS=1` then run `cfslog 1`, `schedulertest`, `usertests`

