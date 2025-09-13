#ifndef LEXER_H
#define LEXER_H
#include <stddef.h>

typedef enum {
    T_NAME, T_PIPE, T_AMP, T_SEMI, T_LT, T_GT, T_GTGT, T_END, T_ERR
} TokenKind;

typedef struct { TokenKind kind; } Token;

typedef struct {
    const char *s; size_t i, n;
    int has_peek; Token peek;
} Lexer;

void lexer_init(Lexer *lx, const char *s);
Token lexer_next(Lexer *lx);
Token lexer_peek(Lexer *lx);
void lexer_pushback(Lexer *lx, Token t);

#endif