#ifndef PARSER_H
#define PARSER_H

// Represents a single shell command or part of a pipeline/sequence
typedef struct command {
    char **argv;                  // arguments (NULL-terminated array)
    int argc;                     // number of arguments
    struct command *next_pipe;    // next command in a pipeline (|)
    struct command *next_seq;     // next command in a sequence (;)
    int background;               // run in background if '&'
    char *input_file;             // last input redirection file (<)
    char *output_file;            // last output redirection file (> or >>)
    int append;                   // append mode of last output redirection (>>)

    // For shell semantics: we must attempt opens for ALL redirections
    // in the order they appear, even if only the last takes effect.
    char **in_redirs;             // list of input files in order
    int    in_redirs_count;
    char **out_redirs;            // list of output files in order
    int   *out_is_append;         // flags for each output file (1 if >>)
    int    out_redirs_count;
} command_t;

// Parse a full input line into a command tree (pipelines, sequences, bg)
command_t *parse_shell_cmd(const char *line);

// Free a command tree created by parse_shell_cmd
void free_command(command_t *cmd);

#endif // PARSER_H
