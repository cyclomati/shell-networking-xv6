// mini-project1/networking/sham.h
#ifndef SHAM_H
#define SHAM_H

#include <stdint.h>

#define SHAM_SYN 0x1
#define SHAM_ACK 0x2
#define SHAM_FIN 0x4

// --- protocol constants ---
#define SHAM_MSS               1024          // data bytes per packet
#define SHAM_SEND_WIN_PKTS     10            // sender sliding window (packets)
#define SHAM_RTO_MS            500           // retransmission timeout
// Receiver advertised window must fit uint16_t.
#define SHAM_RECV_BUF_BYTES    (60*1024)     // 61440 bytes (fits in uint16_t)
#define SHAM_RECV_BUF_U16      ((uint16_t)SHAM_RECV_BUF_BYTES)

typedef struct sham_header {
    uint32_t seq_num;     // first-byte seq in this datagram's payload
    uint32_t ack_num;     // cumulative next-byte expected by ACK sender
    uint16_t flags;       // SHAM_SYN / SHAM_ACK / SHAM_FIN (bitmask)
    uint16_t window_size; // receiver's available byte window (<= 65535)
} __attribute__((packed)) sham_header_t;

#endif // SHAM_H