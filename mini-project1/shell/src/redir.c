#include "redir.h"

#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

int apply_input_redirection(const char *infile) {
    if (!infile || !*infile) return 0;
    int fd = open(infile, O_RDONLY);
    if (fd < 0) {
        puts("No such file or directory");
        return -1;
    }
    if (dup2(fd, STDIN_FILENO) < 0) {
        close(fd);
        return -1;
    }
    close(fd);
    return 0;
}

int apply_output_redirection(const char *outfile, int append) {
    if (!outfile || !*outfile) return 0;
    int flags = O_CREAT | O_WRONLY | (append ? O_APPEND : O_TRUNC);
    int fd = open(outfile, flags, 0644);
    if (fd < 0) {
        puts("Unable to create file for writing");
        return -1;
    }
    if (dup2(fd, STDOUT_FILENO) < 0) {
        close(fd);
        return -1;
    }
    close(fd);
    return 0;
}
