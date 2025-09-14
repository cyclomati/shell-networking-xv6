// mini-project1/shell/src/parser.c
#include "parser.h"

#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* helpers */

static int is_ws(char c) {
    return c==' ' || c=='\t' || c=='\r' || c=='\n';
}
static void skip_ws(const char **ps) {
    while (**ps && is_ws(**ps)) (*ps)++;
}
static int is_special(char c) {
    return (c=='|' || c=='&' || c==';' || c=='<' || c=='>');
}

/* Read a NAME token:
   - quoted with ' or " (no escapes inside quotes)
   - or an unquoted run of non-space, non-special characters
   Returns malloc'd string (caller frees) or NULL on error. */
static char *read_name(const char **ps) {
    const char *p = *ps;
    skip_ws(&p);
    if (!*p) { *ps = p; return NULL; }

    if (*p == '\'' || *p == '\"') {
        char q = *p++;                      /* quote char */
        const char *start = p;
        while (*p && *p != q) p++;
        if (*p != q) {                      /* unmatched quote -> error */
            return NULL;
        }
        size_t len = (size_t)(p - start);
        char *out = (char*)malloc(len + 1);
        if (!out) return NULL;
        memcpy(out, start, len);
        out[len] = '\0';
        p++;                                /* skip closing quote */
        *ps = p;
        return out;
    }

    const char *start = p;
    while (*p && !is_ws(*p) && !is_special(*p)) p++;
    if (p == start) { *ps = p; return NULL; }
    size_t len = (size_t)(p - start);
    char *out = (char*)malloc(len + 1);
    if (!out) return NULL;
    memcpy(out, start, len);
    out[len] = '\0';
    *ps = p;
    return out;
}

static int argv_push(char ***argvp, int *cap, int *argc, char *word) {
    if (*cap == 0) {
        *cap = 8;
        *argvp = (char**)calloc(*cap, sizeof(char*));
        if (!*argvp) return -1;
    }
    if (*argc + 1 >= *cap) {
        int ncap = (*cap) * 2;
        char **tmp = (char**)realloc(*argvp, sizeof(char*) * ncap);
        if (!tmp) return -1;
        *argvp = tmp;
        *cap = ncap;
    }
    (*argvp)[(*argc)++] = word;
    (*argvp)[*argc] = NULL;
    return 0;
}

static command_t *new_cmd(void) {
    return (command_t*)calloc(1, sizeof(command_t));
}

static void free_cmd_node(command_t *c) {
    if (!c) return;
    if (c->argv) {
        for (int i = 0; c->argv[i]; i++) free(c->argv[i]);
        free(c->argv);
    }
    // Free redirection lists if present; they own the strings.
    if (c->in_redirs_count > 0 && c->in_redirs) {
        for (int i = 0; i < c->in_redirs_count; ++i) free(c->in_redirs[i]);
        free(c->in_redirs);
        c->in_redirs = NULL;
        c->in_redirs_count = 0;
        c->input_file = NULL;
    } else {
        free(c->input_file);
    }
    if (c->out_redirs_count > 0 && c->out_redirs) {
        for (int i = 0; i < c->out_redirs_count; ++i) free(c->out_redirs[i]);
        free(c->out_redirs);
        free(c->out_is_append);
        c->out_redirs = NULL;
        c->out_is_append = NULL;
        c->out_redirs_count = 0;
        c->output_file = NULL;
    } else {
        free(c->output_file);
    }
    free(c);
}

/* Free whole graph: for each sequence node, free its pipeline chain */
void free_command(command_t *cmd) {
    while (cmd) {
        command_t *seq_next = cmd->next_seq;

        command_t *p = cmd;
        while (p) {
            command_t *pipe_next = p->next_pipe;
            p->next_pipe = NULL;
            p->next_seq  = NULL;
            free_cmd_node(p);
            p = pipe_next;
        }

        cmd = seq_next;
    }
}

/* ───────────────────── parsing ─────────────────────
   Grammar (whitespace allowed anywhere between tokens):

   shell_cmd  -> group ( (';'|'&') group )* [';'|'&']?
   group      -> atomic ( '|' atomic )*
   atomic     -> NAME ( NAME | '<' NAME | '>' NAME | '>>' NAME )*

   Rules:
   - background flag is attached to the group's first node if '&' is used.
   - last redirection wins within an atomic.
*/

static int parse_group(const char **ps, command_t **out_first) {
    const char *p = *ps;
    command_t *head = NULL, *tail = NULL;

    while (1) {
        skip_ws(&p);
        /* empty / bad operator where a command is expected -> invalid */
        if (!*p || *p=='|' || *p==';' || *p=='&') goto fail;

        command_t *node = new_cmd();
        if (!node) goto fail;

        int argv_cap = 0;
        int in_cap = 0;
        int out_cap = 0;
        int out_append_cap = 0;
        int saw_cmd = 0;

        while (1) {
            skip_ws(&p);
            if (!*p || *p=='|' || *p==';' || *p=='&') break;

            if (*p == '<') {
                p++;
                char *nm = read_name(&p);
                if (!nm) { free_cmd_node(node); goto fail; }
                if (node->in_redirs_count + 1 > in_cap) {
                    in_cap = in_cap ? in_cap*2 : 4;
                    char **tmp = (char**)realloc(node->in_redirs, sizeof(char*) * in_cap);
                    if (!tmp) { free(nm); free_cmd_node(node); goto fail; }
                    node->in_redirs = tmp;
                }
                node->in_redirs[node->in_redirs_count++] = nm;
                node->input_file = nm;                 /* last one wins */
                continue;
            }
            if (*p == '>') {
                p++;
                int append = 0;
                if (*p == '>') { append = 1; p++; }
                char *nm = read_name(&p);
                if (!nm) { free_cmd_node(node); goto fail; }
                if (node->out_redirs_count + 1 > out_cap) {
                    out_cap = out_cap ? out_cap*2 : 4;
                    char **ot = (char**)realloc(node->out_redirs, sizeof(char*) * out_cap);
                    if (!ot) { free(nm); free_cmd_node(node); goto fail; }
                    node->out_redirs = ot;
                }
                if (node->out_redirs_count + 1 > out_append_cap) {
                    out_append_cap = out_append_cap ? out_append_cap*2 : 4;
                    int *at = (int*)realloc(node->out_is_append, sizeof(int) * out_append_cap);
                    if (!at) { free(nm); free_cmd_node(node); goto fail; }
                    node->out_is_append = at;
                }
                node->out_redirs[node->out_redirs_count] = nm;
                node->out_is_append[node->out_redirs_count] = append;
                node->out_redirs_count++;
                node->output_file = nm;                /* last one wins */
                node->append = append;
                continue;
            }

            char *nm = read_name(&p);
            if (!nm) { free_cmd_node(node); goto fail; }
            saw_cmd = 1;
            if (argv_push(&node->argv, &argv_cap, &node->argc, nm) < 0) {
                free(nm); free_cmd_node(node); goto fail;
            }
        }

        if (!saw_cmd) { free_cmd_node(node); goto fail; }

        if (!head) head = tail = node;
        else { tail->next_pipe = node; tail = node; }

        if (*p == '|') { p++; continue; }
        break;
    }

    *ps = p;
    *out_first = head;
    return 1;

fail:
    while (head) {
        command_t *n = head->next_pipe;
        free_cmd_node(head);
        head = n;
    }
    return 0;
}

command_t *parse_shell_cmd(const char *line) {
    if (!line) return NULL;

    const char *p = line;
    command_t *seq_head = NULL, *seq_tail = NULL;

    while (1) {
        skip_ws(&p);
        if (!*p) break; /* no more groups */

        command_t *grp = NULL;
        if (!parse_group(&p, &grp)) {
            free_command(seq_head);
            return NULL;
        }

        /* optional separator following the group */
        skip_ws(&p);
        int background = 0;
        if (*p == ';' || *p == '&') {
            if (*p == '&') background = 1;
            p++; /* consume separator */
        }

        if (grp) grp->background = background;

        if (!seq_head) seq_head = seq_tail = grp;
        else { seq_tail->next_seq = grp; seq_tail = grp; }

        skip_ws(&p);
        if (!*p) break;
        /* loop to parse next group (if next token starts a group,
           parse_group will accept it; stray operators are caught there) */
    }

    return seq_head;
}
