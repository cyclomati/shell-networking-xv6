# ===== mini-project1/networking/Makefile =====

CC      := gcc          # C compiler
CSTD    := -std=c99
WARN    := -Wall -Wextra -Werror
DEFS    := -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700
INCS    := -I.

# --- OpenSSL detection ---
UNAME_S := $(shell uname -s)

OPENSSL_CFLAGS ?= $(shell pkg-config --cflags openssl 2>/dev/null)
OPENSSL_LIBS   ?= $(shell pkg-config --libs   openssl 2>/dev/null)

ifeq ($(UNAME_S),Darwin)
OPENSSL_PREFIX := $(shell brew --prefix openssl@3 2>/dev/null)
# If Homebrew OpenSSL is available, use it; otherwise, fall back to CommonCrypto
ifeq ($(OPENSSL_PREFIX),)
OPENSSL_CFLAGS :=
OPENSSL_LIBS   :=
else
OPENSSL_CFLAGS := -I$(OPENSSL_PREFIX)/include
OPENSSL_LIBS   := -L$(OPENSSL_PREFIX)/lib -lcrypto
endif
MD5_SRC        := md5_macos.c
else
MD5_SRC        := md5_linux.c
# Fallback: if pkg-config didn't supply libs, link with -lcrypto
ifeq ($(strip $(OPENSSL_LIBS)),)
OPENSSL_LIBS := -lcrypto
endif
endif

CFLAGS  := $(CSTD) $(WARN) $(DEFS) $(INCS) $(OPENSSL_CFLAGS)
LDFLAGS := $(OPENSSL_LIBS)

SERVER_SRC := server.c
CLIENT_SRC := client.c
COMMON_SRC := loss.c $(MD5_SRC)

SERVER_OBJ := $(SERVER_SRC:.c=.o) $(COMMON_SRC:.c=.o)
CLIENT_OBJ := client.o loss.o $(MD5_SRC:.c=.o)

PROGS := server client

all: $(PROGS)

server: $(SERVER_OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

client: $(CLIENT_OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Compile rules
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean run-server run-client

clean:
	rm -f *.o server client *.out client_log.txt server_log.txt recv.out received.txt

run-server: server
	./server 9000

run-client: client
	./client 127.0.0.1 9000 sample.txt received.txt