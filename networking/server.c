// mini-project1/networking/server.c
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

void loss_init(double rate);
int  loss_should_drop(void);
int  md5_file_hex(const char *path, char out_hex[33]);

typedef struct {
    sham_header_t h;
    unsigned char data[SHAM_MSS];
} __attribute__((packed)) pkt_t;

static void send_hdr(int fd, const struct sockaddr_in *peer, rudp_logger_t *log, sham_header_t *h) {
    if (sendto(fd, h, sizeof(*h), 0, (const struct sockaddr*)peer, sizeof(*peer)) < 0) die("sendto hdr");
    if (h->flags & SHAM_SYN && !(h->flags & SHAM_ACK)) rudp_logf(log, "SND SYN SEQ=%u", h->seq_num);
    else if ((h->flags & (SHAM_SYN|SHAM_ACK)) == (SHAM_SYN|SHAM_ACK)) rudp_logf(log, "SND SYN-ACK SEQ=%u ACK=%u", h->seq_num, h->ack_num);
    else if (h->flags & SHAM_ACK) rudp_logf(log, "SND ACK=%u WIN=%u", h->ack_num, h->window_size);
    else if (h->flags & SHAM_FIN) rudp_logf(log, "SND FIN SEQ=%u", h->seq_num);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage:\n  %s <port> [--chat] [loss_rate]\n", argv[0]);
        return 1;
    }
    int port = atoi(argv[1]);
    int chat_mode = 0;
    double loss = 0.0;
    if (argc >= 3 && strcmp(argv[2], "--chat") == 0) chat_mode = 1;
    if ((!chat_mode && argc >= 3) || (chat_mode && argc >= 4)) {
        const char *p = chat_mode ? argv[3] : argv[2];
        if (strcmp(p, "--chat") != 0) loss = atof(p);
    }

    loss_init(loss);

    rudp_logger_t log;
    rudp_log_init(&log, "server");

    int fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) die("socket");
    struct sockaddr_in me = {0};
    me.sin_family = AF_INET;
    me.sin_port = htons((uint16_t)port);
    me.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(fd, (struct sockaddr*)&me, sizeof(me)) < 0) die("bind");

    // ---- Handshake ----
    struct sockaddr_in peer = {0};
    socklen_t plen = sizeof(peer);
    uint32_t my_isn = 5000;
    uint32_t peer_isn = 0;

    for (;;) {
        sham_header_t ih;
        ssize_t n = recvfrom(fd, &ih, sizeof(ih), 0, (struct sockaddr*)&peer, &plen);
        if (n < 0) die("recvfrom");
        // Only simulate loss for data, not handshake/control
        if (!(ih.flags & (SHAM_SYN|SHAM_ACK|SHAM_FIN)) && loss_should_drop()) { continue; }
        if (ih.flags & SHAM_SYN) {
            rudp_logf(&log, "RCV SYN SEQ=%u", ih.seq_num);
            peer_isn = ih.seq_num;
            sham_header_t synack = {
                .seq_num = my_isn,
                .ack_num = peer_isn + 1,
                .flags   = SHAM_SYN | SHAM_ACK,
                .window_size = SHAM_RECV_BUF_U16
            };
            send_hdr(fd, &peer, &log, &synack);
        } else if (ih.flags & SHAM_ACK) {
            if (ih.ack_num == (my_isn + 1)) {
                rudp_logf(&log, "RCV ACK FOR SYN");
                break;
            }
        }
    }

    if (chat_mode) {
        // ---- Chat Mode ----
        // After handshake, echo chat using select on stdin + socket.
        // /quit triggers FIN 4-way close.
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
                        fin_seq = my_isn + 1;
                        sham_header_t fin = {.seq_num=fin_seq, .ack_num=0, .flags=SHAM_FIN, .window_size=SHAM_RECV_BUF_U16};
                        send_hdr(fd, &peer, &log, &fin);
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
                        sendto(fd, &p, sizeof(p.h)+len, 0, (struct sockaddr*)&peer, sizeof(peer));
                    }
                }
            }
            if (FD_ISSET(fd, &rfds)) {
                unsigned char buf[sizeof(pkt_t)];
                struct sockaddr_in src; socklen_t sl = sizeof(src);
                ssize_t rn = recvfrom(fd, buf, sizeof(buf), 0, (struct sockaddr*)&src, &sl);
                if (rn < (ssize_t)sizeof(sham_header_t)) continue;
                sham_header_t *h = (sham_header_t*)buf;
                if (loss_should_drop() && !(h->flags & (SHAM_SYN|SHAM_ACK|SHAM_FIN))) {
                    rudp_logf(&log, "DROP DATA SEQ=%u", h->seq_num);
                    continue;
                }
                if (h->flags & SHAM_FIN) {
                    rudp_logf(&log, "RCV FIN SEQ=%u", h->seq_num);
                    sham_header_t ack = {.seq_num=my_isn+1, .ack_num=h->seq_num+1, .flags=SHAM_ACK, .window_size=SHAM_RECV_BUF_U16};
                    send_hdr(fd, &peer, &log, &ack);
                    rudp_logf(&log, "SND ACK FOR FIN");
                    peer_fin_seen = 1;
                    if (!fin_sent) {
                        fin_seq = my_isn + 2;
                        sham_header_t fin2 = {.seq_num=fin_seq, .ack_num=0, .flags=SHAM_FIN, .window_size=SHAM_RECV_BUF_U16};
                        send_hdr(fd, &peer, &log, &fin2);
                        fin_sent = 1;
                    }
                } else if (h->flags & SHAM_ACK) {
                    // final ACK for our FIN?
                    rudp_logf(&log, "RCV ACK=%u", h->ack_num);
                    if (fin_sent && h->ack_num == (fin_seq + 1)) {
                        fin_acked = 1;
                    }
                } else {
                    // data
                    size_t dlen = (size_t)rn - sizeof(sham_header_t);
                    write(STDOUT_FILENO, buf+sizeof(sham_header_t), dlen);
                    sham_header_t ack = {.seq_num=my_isn+1, .ack_num=h->seq_num + (uint32_t)dlen, .flags=SHAM_ACK, .window_size=SHAM_RECV_BUF_U16};
                    send_hdr(fd, &peer, &log, &ack);
                }
            }
            if (fin_sent && peer_fin_seen && fin_acked) break;
        }
        rudp_log_close(&log);
        return 0;
    }

    // ---- File-transfer mode ----
    // Expect client to first send desired output filename (as a data packet), then file data.
    // We reassemble by sequence, cumulative ACK, buffer out to a temp file.
    char outfile[256] = "recv.out";
    FILE *fp = fopen(outfile, "wb");
    if (!fp) die("fopen recv.out");

    uint32_t next_expected = 0;
    // simple reassembly buffer for out-of-order
    typedef struct { uint32_t seq; size_t len; unsigned char data[SHAM_MSS]; } frag_t;
    frag_t ooo[128]; int ooo_n = 0;
    uint32_t ooo_bytes = 0; // bytes buffered out-of-order
    uint32_t last_adv = SHAM_RECV_BUF_U16;

    int have_filename = 0;

    for (;;) {
        unsigned char buf[sizeof(pkt_t)];
        struct sockaddr_in src; socklen_t sl = sizeof(src);
        ssize_t rn = recvfrom(fd, buf, sizeof(buf), 0, (struct sockaddr*)&src, &sl);
        if (rn < (ssize_t)sizeof(sham_header_t)) continue;
        sham_header_t *h = (sham_header_t*)buf;

        // FIN handling
        if (h->flags & SHAM_FIN) {
            rudp_logf(&log, "RCV FIN SEQ=%u", h->seq_num);
            sham_header_t ack = {.seq_num=my_isn+1, .ack_num=h->seq_num+1, .flags=SHAM_ACK, .window_size=SHAM_RECV_BUF_U16};
            send_hdr(fd, &peer, &log, &ack);
            rudp_logf(&log, "SND ACK FOR FIN");
            sham_header_t fin2 = {.seq_num=my_isn+2, .ack_num=0, .flags=SHAM_FIN, .window_size=SHAM_RECV_BUF_U16};
            send_hdr(fd, &peer, &log, &fin2);
            // wait final ACK
            unsigned char b2[sizeof(pkt_t)];
            struct sockaddr_in s2; socklen_t s2l=sizeof(s2);
            ssize_t rn2 = recvfrom(fd, b2, sizeof(b2), 0, (struct sockaddr*)&s2, &s2l);
            if (rn2 >= (ssize_t)sizeof(sham_header_t)) {
                sham_header_t *ah = (sham_header_t*)b2;
                if (ah->flags & SHAM_ACK) {
                    rudp_logf(&log, "RCV ACK=%u", ah->ack_num);
                }
            }
            break;
        }

        // drop simulation for DATA only
        if (!(h->flags & (SHAM_SYN|SHAM_ACK|SHAM_FIN)) && loss_should_drop()) {
            rudp_logf(&log, "DROP DATA SEQ=%u", h->seq_num);
            continue;
        }

        size_t dlen = (size_t)rn - sizeof(sham_header_t);
        rudp_logf(&log, "RCV DATA SEQ=%u LEN=%zu", h->seq_num, dlen);

        if (!have_filename) {
            // first data chunk is "output_file_name\0"
            size_t n = (dlen > sizeof(outfile)-1) ? sizeof(outfile)-1 : dlen;
            memcpy(outfile, buf+sizeof(sham_header_t), n);
            outfile[n] = 0;
            fclose(fp);
            fp = fopen(outfile, "wb");
            if (!fp) die("fopen outfile");
            have_filename = 1;
            next_expected = h->seq_num + (uint32_t)dlen;
        } else {
            // normal data
            if (h->seq_num == next_expected) {
                fwrite(buf+sizeof(sham_header_t), 1, dlen, fp);
                next_expected += (uint32_t)dlen;
                // drain any ooo that now fit
                int moved;
                do {
                    moved = 0;
                    for (int i = 0; i < ooo_n; ++i) {
                        if (ooo[i].seq == next_expected) {
                            fwrite(ooo[i].data, 1, ooo[i].len, fp);
                            next_expected += (uint32_t)ooo[i].len;
                            if (ooo_bytes >= (uint32_t)ooo[i].len) ooo_bytes -= (uint32_t)ooo[i].len;
                            // remove this slot
                            memmove(&ooo[i], &ooo[i+1], (ooo_n - i - 1)*sizeof(frag_t));
                            --ooo_n;
                            moved = 1;
                            break;
                        }
                    }
                } while (moved);
            } else if (h->seq_num > next_expected) {
                // buffer out-of-order (if space)
                if (ooo_n < (int)(sizeof(ooo)/sizeof(ooo[0]))) {
                    ooo[ooo_n].seq = h->seq_num;
                    ooo[ooo_n].len = dlen;
                    memcpy(ooo[ooo_n].data, buf+sizeof(sham_header_t), dlen);
                    ++ooo_n;
                    ooo_bytes += (uint32_t)dlen;
                }
            } else {
                // duplicate old chunk, ignore
            }
        }

        // send cumulative ACK and advertise available window (bytes)
        uint32_t avail = (SHAM_RECV_BUF_BYTES > ooo_bytes) ? (SHAM_RECV_BUF_BYTES - ooo_bytes) : 0u;
        if (avail != last_adv) { rudp_logf(&log, "FLOW WIN UPDATE=%u", (unsigned)avail); last_adv = avail; }
        sham_header_t ack = {.seq_num = my_isn+1, .ack_num = next_expected, .flags = SHAM_ACK, .window_size = (uint16_t)avail};
        send_hdr(fd, &peer, &log, &ack);
    }

    fclose(fp);

    // Print MD5 of received file (required)
    char md5hex[33];
    if (md5_file_hex(outfile, md5hex) == 0) {
        printf("MD5: %s\n", md5hex);
        fflush(stdout);
    }

    rudp_log_close(&log);
    return 0;
}
