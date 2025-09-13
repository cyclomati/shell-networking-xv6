#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: syscount <mask> <command> [args...]\n");
        exit(1);
    }

    int mask = atoi(argv[1]);
    char *command[MAXARG];

  

    // Prepare the command
    for (int i = 2; i < argc; i++) {
        command[i - 2] = argv[i];
    }
    command[argc - 2] = 0; // Null terminate the command array

    // Fork to execute the command
    int pid = fork();
    if (pid == 0) {
        // In child process
        exec(command[0], command);
        printf("exec failed\n");
        exit(1);
    } else if (pid < 0) {
        // Fork failed
        printf("fork failed\n");
        exit(1);
    }

    // In parent process
    wait(0); // Wait for child to finish

    // Get the count of syscalls
    int count = getSysCount(mask);
    if (count) ;

    exit(0);
}
