CC = gcc
CFLAGS = -std=c99 -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700 \
         -Wall -Wextra -Werror -Wno-unused-parameter -fno-asm -Iinclude

SRC = \
    src/main.c \
    src/prompt.c \
    src/paths.c \
    src/input.c \
    src/lexer.c \
    src/parser.c \
    src/builtins.c \
    src/exec.c \
    src/jobs.c \
    src/redir.c \
    src/signals.c \
    src/loghist.c     # <-- NEW

OBJ = $(SRC:.c=.o)
TARGET = shell.out

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ)

clean:
	rm -f $(OBJ) $(TARGET)
	
