// src/pipe.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include "parser.h"
#include "util.h"

int execute_pipeline(char ***commands, int num_cmds) {
    int i;
    int pipefd[2];
    int in_fd = 0;  // start with stdin
    pid_t pid;
    int status = 0;

    for (i = 0; i < num_cmds; i++) {
        if (i < num_cmds - 1) {
            if (pipe(pipefd) < 0) {
                perror("pipe");
                return -1;
            }
        }

        pid = fork();
        if (pid < 0) {
            perror("fork");
            return -1;
        } else if (pid == 0) {
            // child process
            if (in_fd != 0) {
                dup2(in_fd, STDIN_FILENO);
                close(in_fd);
            }
            if (i < num_cmds - 1) {
                close(pipefd[0]); // close read end
                dup2(pipefd[1], STDOUT_FILENO);
                close(pipefd[1]);
            }
            execvp(commands[i][0], commands[i]);
            perror("execvp");
            exit(1);
        } else {
            // parent
            if (in_fd != 0) close(in_fd);
            if (i < num_cmds - 1) {
                close(pipefd[1]);
                in_fd = pipefd[0]; // next cmd reads from this
            }
        }
    }

    // wait for all children
    for (i = 0; i < num_cmds; i++) {
        wait(&status);
    }

    return WIFEXITED(status) ? WEXITSTATUS(status) : -1;
}