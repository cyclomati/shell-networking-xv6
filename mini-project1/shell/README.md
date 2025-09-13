Shell (POSIX C) — README

**Overview**
- **Goal:** A small POSIX-compliant C shell implementing prompt, parsing, built-ins, pipes/redirection, sequential and background execution, job control, signals, and history, per the assignment spec.
- **Binary:** `shell.out` (built in this `shell` directory).
- **Toolchain:** `gcc` with strict POSIX flags; no non‑POSIX syscalls.

**Build & Run**
- **Build:** `make all` (in `mini-project1/shell`)
- **Run:** `./shell.out`
- **Clean:** `make clean`
- **Compiler flags:** `-std=c99 -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700 -Wall -Wextra -Werror -Wno-unused-parameter -fno-asm -Iinclude`

**Prompt**
- **Format:** `<Username@SystemName:current_path> `
- **Home detection:** The startup CWD is the shell’s “home”. Paths under home are shown with `~` prefix.

**Input & Parsing**
- **Loop:** Prints prompt, reads a line, parses, then executes.
- **Grammar:** Implements the provided CFG (names, `<`, `>`, `>>`, `|`, `&`, `;`) with arbitrary whitespace between tokens.
- **Quoting:** Single `'...'` or double `"..."` quotes group words (no escape sequences inside quotes).
- **Validity:** Invalid input prints `Invalid Syntax!` and returns to prompt.

**Built-ins (No exec*)**
- **`hop`**: Change directory per spec.
  - `~` or no args → home. `.` → stay. `..` → parent. `-` → previous dir (if known). `name` → chdir to path.
  - **Errors:** `No such directory!` when target doesn’t exist.
- **`reveal`**: List directory contents per spec.
  - Flags `-a`, `-l` (repeatable, combinable). One optional target like `hop` (`~ . .. - name`).
  - Sorted ASCII. `-l` prints one per line; otherwise space-separated.
  - **Errors:** `reveal: Invalid Syntax!` on too many args; `No such directory!` when path not found; `reveal -` before any `hop` prints `No such directory!`.
- **`jobs`**: Print background/stopped jobs as `[jobno] pid state name`.
- **`activities`**: Print active (Running/Stopped) jobs as `[pid] : command_name - State`, sorted lexicographically by command name.
- **`ping <pid> <signal>`**: Sends `signal % 32` to pid.
  - **Success:** `Sent signal <signal> to process with pid <pid>`
  - **Failure / bad input / no such pid:** `No such process found`
- **`fg [jobno]`**: Bring job to foreground; if stopped, sends `SIGCONT`. Prints the full command. Errors print `No such job`.
- **`bg [jobno]`**: Resume a stopped job in background; prints `[jobno] command &`. Errors print `No such job`; if already running prints `Job already running`.

**History (`log`)**
- **Storage:** Persists at `$HOME/.mysh_history` (text), max 15 lines (oldest overwritten).
- **De-dup:** Skips storing if identical to immediately previous line.
- **Skip self:** If any atomic command is `log`, the entire input is not stored.
- **Commands:**
  - `log` → print oldest → newest
  - `log purge` → clear history
  - `log execute <idx>` → execute command at index, where 1 is newest (newest→oldest indexing). Executed command is not re-logged.

**Command Execution (Part C.1)**
- **Arbitrary commands:** Non-builtins are invoked via `execvp` in children.
- **Not found:** Prints `Command not found!` to stderr.

**Redirection (Parts C.2, C.3)**
- **Input `< file`**: Opens with `O_RDONLY`; on failure prints `No such file or directory` and does not execute.
- **Output `> file`**: Opens with `O_CREAT|O_WRONLY|O_TRUNC` 0644; on failure prints `Unable to create file for writing`.
- **Append `>> file`**: Opens with `O_CREAT|O_WRONLY|O_APPEND` 0644; same error behavior.
- **Precedence:** If multiple `<` or `>`/`>>` are present, the last one applies.
- **Combination:** Input and output redirections work together and with pipelines.

**Pipes (Part C.4)**
- **Form:** `cmd1 | cmd2 | ... | cmdN`
- **Execution:** Creates `N-1` pipes, forks `N` children, wires stdout→pipe and pipe→stdin appropriately, then execs each stage.
- **Parent:** Waits for all children in the pipeline when foreground; background returns immediately (still tracks job).
- **Error:** If a stage fails to exec, other stages still run; errors are per-stage.

**Sequential & Background (Part D)**
- **Sequential `;`**: Executes groups left to right, waiting for each to finish before starting the next. Prompt prints after all groups complete.
- **Background `&`**: Launches group without waiting; prints `[job_number] pid`, immediately shows prompt.
- **Job completion messages:** On next prompt cycle, completed background jobs print:
  - Normal exit: `command_name with pid <pid> exited normally`
  - Abnormal exit: `command_name with pid <pid> exited abnormally`
- **TTY input:** Background children are created in their own process group and do not control the terminal for input.

**Signals & Job Control (Part E.3)**
- **Ctrl-C (SIGINT):** Shell handler forwards SIGINT to the current foreground process group (if any). The shell does not exit.
- **Ctrl-Z (SIGTSTP):** Shell handler forwards SIGTSTP to the current foreground process group and records the job as Stopped; prints `[job_number] Stopped command_name`.
- **Ctrl-D (EOF):** Shell prints `logout`, sends `SIGKILL` to all child processes it tracks, and exits with status 0.
- **TTY control:** On foreground runs, the shell hands the terminal to the child’s process group and restores it on return.

**Directory Structure**
- `src/main.c`: Main loop (prompt → read → parse → log → execute); EOF handling and background completion polling.
- `src/prompt.c`: Prompt rendering with `~` compression relative to shell home.
- `src/input.c`: Line reading (`getline` wrapper) with EOF detection.
- `src/lexer.c`, `src/parser.c`: Tokenization and CFG parser into a command graph (pipelines, sequences, background; tracks last `<`, `>`, `>>`).
- `src/builtins.c`: Implements `hop`, `reveal`, `jobs`, `activities`, `ping`, `fg`, `bg`, and small helpers (`true`, `false`, `tac`).
- `src/paths.c`: Filesystem helpers for `hop`/`reveal`, pretty path, previous dir bookkeeping.
- `src/exec.c`: Executes command graphs; sets up redirections and pipelines; manages foreground/background and terminal control.
- `src/redir.c`: `<`, `>`, `>>` helpers with exact error messages.
- `src/jobs.c`: Background/stopped job tracking, reporting, `fg`/`bg`, `activities` sorting.
- `src/signals.c`: Shell and child signal handlers; foreground process group tracking.
- `src/loghist.c`: Persistent history management in `$HOME/.mysh_history`.
- `include/*.h`: Public headers for the above modules.

**Usage Examples**
- Prompt and simple input:
  - `<user@host:~> echo hello`
- Parsing validity:
  - Valid: `cat a.txt | grep x ; echo done &`
  - Invalid: `cat a.txt | ; echo` → `Invalid Syntax!`
- `hop`:
  - `hop ~` → home; `hop ..` → parent; `hop -` → previous; `hop path/to/dir`
- `reveal`:
  - `reveal` (CWD), `reveal -a`, `reveal -l`, `reveal -al ~`, error on too many args.
- Redirection:
  - `cat < in.txt > out.txt`, `echo hi >> out.txt`
- Pipes:
  - `cat file | grep key | wc -l`
- Background:
  - `sleep 2 &` → prints `[N] <pid>`; later prints completion message.
- Job control:
  - Ctrl-Z stops foreground, run `bg` to resume in background, `fg` to bring back.
- History:
  - `log`, `log purge`, `log execute 1` (newest), skips storing commands containing `log`.

**Notes & Limitations**
- Quoted words don’t support escapes; use simple `'...'` or `"..."` quoting.
- Background jobs don’t read from the terminal; they’re in their own process group.
- When running pipelines, the shell waits for all stages in foreground.
- Minimal niceties (e.g., PATH hashing, advanced globbing) are not implemented; rely on `execvp` lookup.

**Testing**
- Manual: build with `make all`, run `./shell.out`, exercise each Part (A–E) behaviors.
- The shell adheres to the exact messages required by the spec to ease automated evaluation.
