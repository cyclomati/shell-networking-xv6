#include "lexer.h"
#include <ctype.h>

static int is_special(int c) { return c=='|'||c=='&'||c=='>'||c=='<'||c==';'; }

void lexer_init(Lexer *lx, const char *s) {
    lx->s = s; lx->i = 0; lx->n = 0;
    if (s) while (s[lx->n] != '\0') lx->n++;
    lx->has_peek = 0;
}

static void skip_ws(Lexer *lx) {
    while (lx->i < lx->n) {
        unsigned char c = (unsigned char)lx->s[lx->i];
        if (c==' ' || c=='\t' || c=='\r' || c=='\n') lx->i++; else break;
    }
}

Token lexer_next(Lexer *lx) {
    if (lx->has_peek) { lx->has_peek = 0; return lx->peek; }
    skip_ws(lx);
    if (lx->i >= lx->n) return (Token){ T_END };
    char c = lx->s[lx->i++];
    switch (c) {
        case '|': return (Token){ T_PIPE };
        case '&': return (Token){ T_AMP };
        case ';': return (Token){ T_SEMI };
        case '<': return (Token){ T_LT };
        case '>':
            if (lx->i < lx->n && lx->s[lx->i] == '>') { lx->i++; return (Token){ T_GTGT }; }
            return (Token){ T_GT };
        default: {
            while (lx->i < lx->n) {
                unsigned char d = (unsigned char)lx->s[lx->i];
                if (isspace(d) || is_special(d)) break;
                lx->i++;
            }
            return (Token){ T_NAME };
        }
    }
}

Token lexer_peek(Lexer *lx) {
    if (lx->has_peek) return lx->peek;
    lx->peek = lexer_next(lx);
    lx->has_peek = 1;
    return lx->peek;
}

void lexer_pushback(Lexer *lx, Token t) {
    lx->peek = t; lx->has_peek = 1;
}