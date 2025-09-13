#ifndef REDIR_H
#define REDIR_H

int apply_input_redirection(const char *infile);
int apply_output_redirection(const char *outfile, int append);

#endif