#ifndef BUILTINS_H
#define BUILTINS_H

// check if a command is builtin
int is_builtin(const char *cmd);

// run a builtin command
int run_builtin(int argc, char **argv);

#endif // BUILTINS_H