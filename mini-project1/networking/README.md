S.H.A.M. Reliable UDP Networking (Total 80)

Objective

- Build a simple reliable protocol on top of UDP that simulates key TCP behaviors: 3‑way connect, 4‑way close, byte‑stream sequencing, cumulative ACKs, retransmission with RTO, and flow control. Two modes are supported: file transfer and interactive chat.

Quick Start

- Build: `make -C mini-project1/networking`
- Binaries: `server`, `client` (built in `mini-project1/networking`)
- Logs: enable with `RUDP_LOG=1` to write `client_log.txt` or `server_log.txt`

Prerequisites

- Linux: `sudo apt update && sudo apt install -y libssl-dev`
- macOS (Homebrew): `brew install openssl@3`
- The Makefile auto-detects OpenSSL on macOS and falls back to CommonCrypto if not found. On Linux it links with `-lcrypto`.

Usage

- Server: `./server <port> [--chat] [loss_rate]`
- Client (file transfer): `./client <server_ip> <port> <input_file> <output_file_name> [loss_rate]`
- Client (chat): `./client <server_ip> <port> --chat [loss_rate]`
- `loss_rate` is optional (0.0–1.0). If provided, only DATA packets are randomly dropped at the receiver to test reliability. Control packets (SYN/ACK/FIN) are never dropped by the simulator.

Project Layout

- `mini-project1/networking/sham.h`: Protocol constants and the S.H.A.M. header definition
- `mini-project1/networking/server.c`: UDP server (file receiver, optional chat)
- `mini-project1/networking/client.c`: UDP client (file sender, optional chat)
- `mini-project1/networking/logging.h`: Timestamped logging helper (RUDP_LOG=1)
- `mini-project1/networking/loss.c`: Probabilistic loss simulation for DATA only
- `mini-project1/networking/timer.h`: Microsecond clock for RTO
- `mini-project1/networking/md5_macos.c`, `md5_linux.c`: MD5 helpers
- `mini-project1/networking/Makefile`: Portable build with OpenSSL autodetect

1. Core Functionalities

1.1 S.H.A.M. Packet Structure [5]

- All messages are UDP datagrams whose payload begins with a fixed header:
- Header (see `mini-project1/networking/sham.h`):
  - `uint32_t seq_num`: First-byte sequence number in this datagram’s payload.
  - `uint32_t ack_num`: Cumulative next expected byte (ACK sender’s view).
  - `uint16_t flags`: Bitmask of `SHAM_SYN=0x1`, `SHAM_ACK=0x2`, `SHAM_FIN=0x4`.
  - `uint16_t window_size`: Receiver’s advertised available bytes (flow control).
- Constants (defaults from code):
  - `SHAM_MSS=1024` bytes payload per packet.
  - `SHAM_SEND_WIN_PKTS=10` packets sender window.
  - `SHAM_RTO_MS=500` ms retransmission timeout.
  - `SHAM_RECV_BUF_BYTES=61440` (fits in 16 bits; advertised in `window_size`).

1.2 Connection Management [10]

- Three-Way Handshake (connect):
  - Client: `SYN` with ISN X (code uses X=100).
  - Server: `SYN|ACK` with ISN Y (code uses Y=5000) and `ack_num=X+1`.
  - Client: `ACK` with `ack_num=Y+1`.
- Four-Way Handshake (close):
  - Initiator sends `FIN` (unique `seq_num`), waits for `ACK(FIN+1)`.
  - Peer replies `ACK`, then sends its own `FIN` when ready.
  - Initiator replies final `ACK` and both exit after FIN seen and own FIN is ACKed.
- Chat Mode: typing `/quit` on either side initiates this 4‑way close. The code tracks the exact FIN sequence and only exits after FIN+ACK is complete on both sides.

1.3 Data Sequencing and Retransmission [25]

- Data Segmentation: fixed 1024‑byte chunks (`SHAM_MSS`).
- Sliding Window: up to `SHAM_SEND_WIN_PKTS` packets may be in flight without per‑pkt ACK.
- Cumulative ACKs: receiver ACKs the next missing byte (e.g., ACK=1025 means contiguous bytes <1025 were received). Out‑of‑order data are buffered.
- RTO: per-packet timers; if `ACK` does not cover a packet within `SHAM_RTO_MS`, the sender retransmits that packet only.
- Implementation details per mode:
  - File Transfer (client→server):
    - First DATA packet carries the desired output filename as a NUL‑terminated string; subsequent DATA packets carry file bytes.
    - Receiver (`server.c`) reassembles by sequence, buffers up to 128 out‑of‑order fragments, and ACKs cumulatively.
  - Chat: best‑effort DATA send with FIN‑based termination; retransmission is only relevant for file mode.

Example: Basic Retransmission

- Window: 4 packets, MSS=1024. Sender sends SEQ=1,1025,2049,3073; suppose SEQ=1025 is lost.
- Receiver buffers later ones and sends `ACK=1025`.
- Sender timeout fires for SEQ=1025 → `TIMEOUT SEQ=1025`, `RETX DATA SEQ=1025`.
- Receiver can now deliver contiguous up to 4096 and replies `ACK=4097` (covers 2,3,4). No need to retransmit 2049 or 3073 thanks to cumulative ACKs.

2. Flow Control [10]

- Receiver sets `window_size` in every outgoing header to its currently available buffer bytes.
- Sender caps newly sent (unsent) data so inflight bytes (`sum(len of in‑flight packets)`) never exceed the peer’s advertised `window_size`.
- In file mode, the server updates `window_size` as buffered out‑of‑order bytes change and logs `FLOW WIN UPDATE=<bytes>` when it changes.

3. Implementation and Testing Requirements

3.1 Command-Line Interface

- Server: `./server <port> [--chat] [loss_rate]`
- Client (file): `./client <server_ip> <server_port> <input_file> <output_file_name> [loss_rate]`
- Client (chat): `./client <server_ip> <server_port> --chat [loss_rate]`
- Loss: `loss_rate` is a float [0.0,1.0]. If omitted, defaults to 0.0.

3.2 Mode-Specific Behavior [10]

- File Transfer (default): client sends filename (first DATA), then file bytes with sliding window, cumulative ACKs, RTO, flow control. Server writes to the requested file and closes via 4‑way FIN.
- Chat Mode (`--chat` on client, optional `--chat` on server): both sides `select()` on stdin and the UDP socket, echo text data. Type `/quit` to start 4‑way FIN close; both sides exit after FIN observed and own FIN is ACKed.

3.3 Standardized Output for Verification [5]

- File mode only: after full file is received and the connection closes, the server prints the MD5 checksum to stdout as:
- `MD5: <32-character_lowercase_md5_hash>`
- MD5 is computed via OpenSSL `EVP` on Linux and OpenSSL/CommonCrypto on macOS (`md5_linux.c` / `md5_macos.c`).

3.4 Simulating Packet Loss for Testing [5]

- The receiver probabilistically drops DATA packets according to `loss_rate` (see `loss.c`). Control packets (SYN/ACK/FIN) are never dropped in the simulation.
- Drop events are logged as `DROP DATA SEQ=<num>` when logging is enabled.

4. Verbose Logging for Evaluation [10]

- Activate by setting `RUDP_LOG=1` in the environment. If unset, no log file is produced.
- Log files: `client_log.txt` (client), `server_log.txt` (server).
- Each line: `[YYYY-MM-DD HH:MM:SS.micro] [LOG] <event>` (uses `gettimeofday()` for microseconds).
- Required events (all are implemented):
  - Handshake: `SND SYN`, `RCV SYN`, `SND SYN-ACK`, `RCV ACK FOR SYN`
  - Data: `SND DATA SEQ=<n> LEN=<bytes>`, `RCV DATA SEQ=<n> LEN=<bytes>`
  - ACKs: `SND ACK=<num> WIN=<bytes>`, `RCV ACK=<num>`
  - Retransmission: `TIMEOUT SEQ=<n>`, `RETX DATA SEQ=<n> LEN=<bytes>`
  - Flow control: `FLOW WIN UPDATE=<bytes>`
  - Loss: `DROP DATA SEQ=<n>`
  - Close: `RCV FIN SEQ=<n>`, `SND ACK FOR FIN`, `SND FIN SEQ=<n>`

Sample Logs (excerpt)

Client (chat, `/quit` typed):

```
[... ] SND SYN SEQ=100
[... ] RCV SYN SEQ=5000
[... ] RCV SYN-ACK SEQ=5000 ACK=101
[... ] SND ACK=5001 WIN=61440
[... ] SND FIN SEQ=102
[... ] RCV ACK=103
[... ] RCV FIN SEQ=5002
[... ] SND ACK=5003 WIN=61440
[... ] SND ACK FOR FIN
```

Server (file transfer, end of session):

```
[... ] RCV FIN SEQ=4197
[... ] SND ACK FOR FIN
[... ] SND FIN SEQ=8500
[... ] RCV ACK=8501
```

How To Run

- Terminal 1 (server, file mode):
  - `cd mini-project1/networking && RUDP_LOG=1 ./server 9000`
- Terminal 2 (client, send file):
  - `cd mini-project1/networking && RUDP_LOG=1 ./client 127.0.0.1 9000 sample.txt received.txt`
- Verify server prints: `MD5: <hash>` and `received.txt` exists with the same MD5 as `sample.txt`.
- Introduce loss (e.g., 30%):
  - Server: `RUDP_LOG=1 ./server 9000 0.3`
  - Client: `RUDP_LOG=1 ./client 127.0.0.1 9000 sample.bin received.bin 0.3`
  - Inspect logs for `TIMEOUT`/`RETX` and cumulative `RCV ACK` growth.

Chat Mode Demo

- Server: `RUDP_LOG=1 ./server 9001 --chat`
- Client: `RUDP_LOG=1 ./client 127.0.0.1 9001 --chat`
- Type messages on either side; they appear on the peer. Type `/quit` on either side to initiate a graceful 4‑way close. Both exit after the peer’s `FIN` is seen and our `FIN` is ACKed.

Implementation Notes (according to this codebase)

- Fixed ISNs for clarity: client uses 100; server uses 5000.
- File transfer staging: first DATA packet carries the destination filename (NUL‑terminated), then the file bytes stream begins at the next sequence.
- Receiver buffering: up to 128 out‑of‑order fragments are held and drained when gaps close.
- Flow control: server advertises `window_size` as available bytes = `SHAM_RECV_BUF_BYTES - buffered_ooo_bytes`.
- Sender behavior: new sends respect the latest advertised `window_size` by limiting additional in‑flight bytes; retransmissions do not change in‑flight accounting.
- Timers: per‑packet timers checked on a 50ms tick (`select()` timeout); RTO=500ms.
- No congestion control (intentional for this assignment) — only flow control is implemented.
- I/O model: single-threaded `select()` over UDP socket (and stdin in chat mode).

Tuning

- Adjust protocol constants in `mini-project1/networking/sham.h`:
  - `SHAM_MSS`, `SHAM_SEND_WIN_PKTS`, `SHAM_RTO_MS`, `SHAM_RECV_BUF_BYTES`.
- Rebuild after changes: `make -C mini-project1/networking clean all`.

Troubleshooting

- macOS link errors for OpenSSL: install with `brew install openssl@3`; the Makefile auto-includes the proper `-I/-L` flags.
- Linux missing headers: `sudo apt install -y libssl-dev`.
- Port already in use: choose another port, e.g., 9001.
- No logs emitted: ensure `RUDP_LOG=1` is set in the environment before launching.

Make Targets

- `make` or `make all`: build `server` and `client`.
- `make clean`: remove binaries, objects, logs, and temporary outputs.
- Convenience:
  - `make run-server`: runs `./server 9000`
  - `make run-client`: runs `./client 127.0.0.1 9000 sample.txt received.txt`

Grading Coverage Mapping

- S.H.A.M. Header [5]: implemented in `sham.h` and used everywhere.
- Connection Management [10]: 3‑way connect and 4‑way close with correct FIN/ACK matching; `/quit` in chat initiates graceful termination.
- Data Sequencing & Retransmission [25]: byte‑based SEQ, cumulative ACKs, sliding window, per‑packet RTO, selective retransmit.
- Flow Control [10]: byte‑based advertised window, sender respects inflight ≤ window.
- CLI & Modes [10]: interfaces as specified; file transfer default, `--chat` optional.
- MD5 Output [5]: server prints exact `MD5: <hex>` line after successful transfer and close.
- Loss Simulation [5]: receiver drops only DATA based on `loss_rate`.
- Verbose Logging [10]: timestamped logs with required events under `RUDP_LOG=1`.
