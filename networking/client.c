// mini-project1/networking/client.c (pure C implementation)
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#include "sham.h"
#include "util.h"
#include "logging.h"
#include "timer.h"

// externs from C objects
void loss_init(double rate);
int  loss_should_drop(void);
int  md5_file_hex(const char *path, char out_hex[33]);

typedef struct {
    sham_header_t h;
    unsigned char data[SHAM_MSS];
} __attribute__((packed)) pkt_t;

typedef struct {
    uint32_t seq;
    size_t   len;
    uint64_t last_send_us;
    int      in_flight;   // 1 if sent but not cumul-acked
    unsigned char data[SHAM_MSS];
} wnd_pkt_t;

static void send_hdr(int fd, const struct sockaddr_in *peer, rudp_logger_t *log, sham_header_t *h) {
    if (sendto(fd, h, sizeof(*h), 0, (const struct sockaddr*)peer, sizeof(*peer)) < 0) die("sendto hdr");
    if (h->flags & SHAM_SYN && !(h->flags & SHAM_ACK)) rudp_logf(log, "SND SYN SEQ=%u", h->seq_num);
    else if ((h->flags & (SHAM_SYN|SHAM_ACK)) == (SHAM_SYN|SHAM_ACK)) rudp_logf(log, "SND SYN-ACK SEQ=%u ACK=%u", h->seq_num, h->ack_num);
    else if (h->flags & SHAM_ACK) rudp_logf(log, "SND ACK=%u WIN=%u", h->ack_num, h->window_size);
    else if (h->flags & SHAM_FIN) rudp_logf(log, "SND FIN SEQ=%u", h->seq_num);
}

static void send_data_pkt(int fd, const struct sockaddr_in *peer, rudp_logger_t *log, uint32_t seq, const unsigned char *buf, size_t len) {
    pkt_t p = {0};
    p.h.seq_num = seq;
    p.h.ack_num = 0;
    p.h.flags   = 0;
    p.h.window_size = SHAM_RECV_BUF_U16;
    memcpy(p.data, buf, len);
    size_t total = sizeof(p.h) + len;
    if (sendto(fd, &p, total, 0, (const struct sockaddr*)peer, sizeof(*peer)) < 0) die("sendto data");
    rudp_logf(log, "SND DATA SEQ=%u LEN=%zu", seq, len);
}

// Helper: retransmit timed-out and send new (subject to advertised window)
static void try_send(int fd,
                     const struct sockaddr_in *svr,
                     rudp_logger_t *log,
                     FILE *fp,
                     wnd_pkt_t *wnd,
                     int *peof,
                     uint32_t *pnext_seq,
                     uint32_t adv_win)
{
    // Retransmit timers (retransmissions do not increase inflight-bytes)
    for (int i = 0; i < SHAM_SEND_WIN_PKTS; ++i) {
        if (!wnd[i].len) continue;
        if (!wnd[i].in_flight) continue;
        uint64_t now = now_us();
        if (now - wnd[i].last_send_us >= (uint64_t)SHAM_RTO_MS * 1000ULL) {
            rudp_logf(log, "TIMEOUT SEQ=%u", wnd[i].seq);
            send_data_pkt(fd, svr, log, wnd[i].seq, wnd[i].data, wnd[i].len);
            wnd[i].last_send_us = now;
            rudp_logf(log, "RETX DATA SEQ=%u LEN=%zu", wnd[i].seq, wnd[i].len);
        }
    }

    // Compute current inflight bytes
    uint32_t inflight = 0;
    for (int i = 0; i < SHAM_SEND_WIN_PKTS; ++i) {
        if (wnd[i].len && wnd[i].in_flight) inflight += (uint32_t)wnd[i].len;
    }

    // Fill window with new or unsent packets (respect advertised window)
    for (int i = 0; i < SHAM_SEND_WIN_PKTS; ++i) {
        if (wnd[i].len && wnd[i].in_flight) continue; // already sent
        if (!wnd[i].len) {
            if (*peof) continue;
            // read next chunk
            size_t rn = fread(wnd[i].data, 1, SHAM_MSS, fp);
            if (rn == 0) { *peof = 1; continue; }
            wnd[i].seq = *pnext_seq;
            wnd[i].len = rn;
            *pnext_seq += (uint32_t)rn;
        }
        // Respect advertised window for NEW sends
        if (inflight + (uint32_t)wnd[i].len > adv_win) break; // cannot send more now
        send_data_pkt(fd, svr, log, wnd[i].seq, wnd[i].data, wnd[i].len);
        wnd[i].last_send_us = now_us();
        wnd[i].in_flight = 1;
        inflight += (uint32_t)wnd[i].len;
    }
}

int main(int argc, char **argv) {
    if (argc < 4) {
        fprintf(stderr, "Usage:\n  %s <server_ip> <port> <input_file> <output_file_name> [loss_rate]\n  %s <server_ip> <port> --chat [loss_rate]\n", argv[0], argv[0]);
        return 1;
    }
    const char *sip = argv[1];
    int port = atoi(argv[2]);

    int chat_mode = (strcmp(argv[3], "--chat") == 0);
    double loss = 0.0;
    const char *infile = NULL;
    const char *outfile = NULL;

    if (chat_mode) {
        if (argc >= 5) loss = atof(argv[4]);
    } else {
        if (argc < 5) {
            fprintf(stderr, "Missing output_file_name\n");
            return 1;
        }
        infile = argv[3];
        outfile = argv[4];
        if (argc >= 6) loss = atof(argv[5]);
    }

    loss_init(loss);

    rudp_logger_t log;
    rudp_log_init(&log, "client");

    int fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) die("socket");
    struct sockaddr_in svr = {0};
    svr.sin_family = AF_INET;
    svr.sin_port   = htons((uint16_t)port);
    if (inet_pton(AF_INET, sip, &svr.sin_addr) != 1) {
        fprintf(stderr, "bad ip\n"); return 1;
    }

    // handshake
    uint32_t my_isn = 100;
    sham_header_t syn = {.seq_num=my_isn, .ack_num=0, .flags=SHAM_SYN, .window_size=SHAM_RECV_BUF_U16};
    send_hdr(fd, &svr, &log, &syn);

    uint32_t peer_isn = 0;
    for (;;) {
        sham_header_t h;
        ssize_t rn = recvfrom(fd, &h, sizeof(h), 0, NULL, 0);
        if (rn < (ssize_t)sizeof(h)) continue;
        if (h.flags & SHAM_SYN) {
            peer_isn = h.seq_num;
            rudp_logf(&log, "RCV SYN SEQ=%u", peer_isn);
        }
        if ((h.flags & (SHAM_SYN|SHAM_ACK)) == (SHAM_SYN|SHAM_ACK)) {
            rudp_logf(&log, "RCV SYN-ACK SEQ=%u ACK=%u", h.seq_num, h.ack_num);
            sham_header_t ack = {.seq_num=my_isn+1, .ack_num=h.seq_num+1, .flags=SHAM_ACK, .window_size=SHAM_RECV_BUF_U16};
            send_hdr(fd, &svr, &log, &ack);
            break;
        }
    }

    if (chat_mode) {
        // Chat loop: select stdin + socket; /quit sends FIN and completes 4-way close.
        int fin_sent = 0, fin_acked = 0, peer_fin_seen = 0;
        uint32_t fin_seq = 0; // sequence number used for our FIN
        char line[2048];

        for (;;) {
            fd_set rfds; FD_ZERO(&rfds);
            FD_SET(fd, &rfds);
            FD_SET(STDIN_FILENO, &rfds);
            int mx = (fd > STDIN_FILENO ? fd : STDIN_FILENO) + 1;
            if (select(mx, &rfds, NULL, NULL, NULL) < 0) die("select");

            if (FD_ISSET(STDIN_FILENO, &rfds)) {
                ssize_t r = read(STDIN_FILENO, line, sizeof(line)-1);
                if (r > 0) {
                    line[r] = 0;
                    if (strncmp(line, "/quit", 5) == 0 && !fin_sent) {
                        fin_seq = my_isn + 2;
                        sham_header_t fin = {.seq_num=fin_seq, .ack_num=0, .flags=SHAM_FIN, .window_size=SHAM_RECV_BUF_U16};
                        send_hdr(fd, &svr, &log, &fin);
                        fin_sent = 1;
                    } else {
                        pkt_t p = {0};
                        p.h.seq_num = my_isn + 1;
                        p.h.ack_num = 0;
                        p.h.flags   = 0;
                        p.h.window_size = SHAM_RECV_BUF_U16;
                        size_t len = (size_t)r;
                        if (len > SHAM_MSS) len = SHAM_MSS;
                        memcpy(p.data, line, len);
                        sendto(fd, &p, sizeof(p.h)+len, 0, (struct sockaddr*)&svr, sizeof(svr));
                    }
                }
            }
            if (FD_ISSET(fd, &rfds)) {
                unsigned char buf[sizeof(pkt_t)];
                ssize_t rn = recvfrom(fd, buf, sizeof(buf), 0, NULL, 0);
                if (rn < (ssize_t)sizeof(sham_header_t)) continue;
                sham_header_t *h = (sham_header_t*)buf;

                if (h->flags & SHAM_FIN) {
                    rudp_logf(&log, "RCV FIN SEQ=%u", h->seq_num);
                    peer_fin_seen = 1;
                    sham_header_t ack = {.seq_num=my_isn+2, .ack_num=h->seq_num+1, .flags=SHAM_ACK, .window_size=SHAM_RECV_BUF_U16};
                    send_hdr(fd, &svr, &log, &ack);
                    rudp_logf(&log, "SND ACK FOR FIN");
                    if (!fin_sent) {
                        fin_seq = my_isn + 3;
                        sham_header_t fin2 = {.seq_num=fin_seq, .ack_num=0, .flags=SHAM_FIN, .window_size=SHAM_RECV_BUF_U16};
                        send_hdr(fd, &svr, &log, &fin2);
                        fin_sent = 1;
                    }
                } else if (h->flags & SHAM_ACK) {
                    rudp_logf(&log, "RCV ACK=%u", h->ack_num);
                    if (fin_sent && h->ack_num == (fin_seq + 1)) {
                        fin_acked = 1;
                    }
                } else {
                    // data: simulate loss and log RCV DATA
                    if (loss_should_drop()) {
                        rudp_logf(&log, "DROP DATA SEQ=%u", h->seq_num);
                        continue;
                    }
                    size_t dlen = (size_t)rn - sizeof(sham_header_t);
                    rudp_logf(&log, "RCV DATA SEQ=%u LEN=%zu", h->seq_num, dlen);
                    write(STDOUT_FILENO, buf+sizeof(sham_header_t), dlen);
                }

                if (fin_sent && peer_fin_seen && fin_acked) break;
            }
        }
        rudp_log_close(&log);
        return 0;
    }

    // ---- File transfer mode ----
    // 1) Send outfile name first as data (one packet).
    // 2) Send file content with sliding window + cumulative ACK + RTO.
    FILE *fp = fopen(infile, "rb");
    if (!fp) { perror("open input"); return 1; }

    // sender advertised window from receiver; default to max
    uint32_t adv_win = SHAM_RECV_BUF_U16;
    uint32_t last_adv_win = adv_win;

    // window
    wnd_pkt_t wnd[SHAM_SEND_WIN_PKTS];
    memset(wnd, 0, sizeof(wnd));
    uint32_t base_seq = 1;        // first data seq will be 1 (filename)
    uint32_t next_seq = base_seq; // next seq to assign

    // send outfile name once (retransmit as needed)
    size_t outn = strlen(outfile) + 1;
    if (outn > SHAM_MSS) outn = SHAM_MSS;
    // Stage filename in first window slot
    wnd[0].seq = next_seq;
    memcpy(wnd[0].data, outfile, outn);
    wnd[0].len = outn;
    wnd[0].last_send_us = 0;
    wnd[0].in_flight = 0;
    next_seq += (uint32_t)outn;

    // Preload file chunks (on demand)
    int eof = 0;

    // Main send/ack loop
    uint32_t last_acked = base_seq; // cumulative ack we’ve seen
    for (;;) {
        // Try send/retransmit
        try_send(fd, &svr, &log, fp, wnd, &eof, &next_seq, adv_win);

        // Wait a bit for ACK or timeout tick; use select with small timeout
        struct timeval tv = {0};
        tv.tv_sec = 0;
        tv.tv_usec = 50000; // 50ms tick
        fd_set rfds; FD_ZERO(&rfds); FD_SET(fd, &rfds);
        int rv = select(fd+1, &rfds, NULL, NULL, &tv);
        if (rv < 0) die("select");

        if (rv > 0 && FD_ISSET(fd, &rfds)) {
            sham_header_t ack;
            ssize_t rn = recvfrom(fd, &ack, sizeof(ack), 0, NULL, 0);
            if (rn >= (ssize_t)sizeof(ack) && (ack.flags & SHAM_ACK)) {
                rudp_logf(&log, "RCV ACK=%u", ack.ack_num);
                // Flow control update from receiver
                adv_win = (uint32_t)ack.window_size;
                if (adv_win != last_adv_win) {
                    rudp_logf(&log, "FLOW WIN UPDATE=%u", (unsigned)adv_win);
                    last_adv_win = adv_win;
                }
                // mark all packets < ack.ack_num as delivered
                for (int i = 0; i < SHAM_SEND_WIN_PKTS; ++i) {
                    if (!wnd[i].len) continue;
                    if ((wnd[i].seq + (uint32_t)wnd[i].len) <= ack.ack_num) {
                        // slide out
                        wnd[i].len = 0;
                        wnd[i].in_flight = 0;
                    }
                }
                if (ack.ack_num > last_acked) last_acked = ack.ack_num;
            }
        }

        // Check done: all data read (eof) and window empty
        int any = 0;
        for (int i = 0; i < SHAM_SEND_WIN_PKTS; ++i) if (wnd[i].len) { any = 1; break; }
        if (eof && !any) break;
    }

    fclose(fp);

    // 4-way FIN
    sham_header_t fin = {.seq_num=next_seq, .ack_num=0, .flags=SHAM_FIN, .window_size=SHAM_RECV_BUF_U16};
    send_hdr(fd, &svr, &log, &fin);

    // expect ACK for our FIN, then FIN from server, then ACK
    int got_ack_for_fin = 0, got_fin = 0;
    for (;;) {
        sham_header_t h;
        ssize_t rn = recvfrom(fd, &h, sizeof(h), 0, NULL, 0);
        if (rn < (ssize_t)sizeof(h)) continue;
        if ((h.flags & SHAM_ACK) && h.ack_num == (next_seq+1)) {
            got_ack_for_fin = 1;
            if (got_fin) break;
        } else if (h.flags & SHAM_FIN) {
            got_fin = 1;
            sham_header_t ack = {.seq_num=next_seq+1, .ack_num=h.seq_num+1, .flags=SHAM_ACK, .window_size=SHAM_RECV_BUF_U16};
            send_hdr(fd, &svr, &log, &ack);
            rudp_logf(&log, "SND ACK FOR FIN");
            if (got_ack_for_fin) break;
        }
    }

    rudp_log_close(&log);
    return 0;
}
