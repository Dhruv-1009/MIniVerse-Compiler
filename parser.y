%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int line;
int yylex();
void yyerror(const char *s);


char symbol_table[100][50];
int count = 0;
void insert(char *var) {
    for(int i=0; i<count; i++) {
        if(strcmp(symbol_table[i], var) == 0) {
            printf("Error: Duplicate declaration of %s at line %d\n", var, line);
            exit(1);
        }
    }
    strcpy(symbol_table[count++], var);
}

/* Lookup variable */
int lookup(char *var) {
    for(int i=0; i<count; i++) {
        if(strcmp(symbol_table[i], var) == 0)
            return 1;
    }
    return 0;
}
%}

/* -------- Data Types -------- */
%union {
    char *str;
}

/* -------- Tokens -------- */
%token INT FLOAT CHAR DOUBLE FOR WHILE IF ELSE
%token <str> IDENTIFIER NUMBER

%token PLUS MINUS MUL DIV MOD
%token ASSIGN
%token SEMICOLON
%token LPAREN RPAREN
%token LBRACE RBRACE

/* -------- Types -------- */
%type <str> expression term factor

%%

program
        : program statement
        | statement
        ;

statement
        : declaration
        | assignment
        ;

declaration
    : INT IDENTIFIER SEMICOLON
      { insert($2); }

    | INT IDENTIFIER ASSIGN expression SEMICOLON
      {
          insert($2);
      }

    | FLOAT IDENTIFIER SEMICOLON
      { insert($2); }

    | FLOAT IDENTIFIER ASSIGN expression SEMICOLON
      { insert($2); }

    | CHAR IDENTIFIER SEMICOLON
      { insert($2); }

    | CHAR IDENTIFIER ASSIGN expression SEMICOLON
      { insert($2); }

    | DOUBLE IDENTIFIER SEMICOLON
      { insert($2); }

    | DOUBLE IDENTIFIER ASSIGN expression SEMICOLON
      { insert($2); }
    ;
assignment
        : IDENTIFIER ASSIGN expression SEMICOLON
          {
              if(!lookup($1)) {
                  printf("Error: Variable %s not declared at line %d\n", $1, line);
                  exit(1);
              }
          }
        ;

expression
        : expression PLUS term   { $$ = $1; }
        | expression MINUS term  { $$ = $1; }
        | term                   { $$ = $1; }
        ;

term
        : term MUL factor   { $$ = $1; }
        | term DIV factor   { $$ = $1; }
        | factor            { $$ = $1; }
        ;

factor
        : IDENTIFIER
          {
              if(!lookup($1)) {
                  printf("Error: Variable %s not declared at line %d\n", $1, line);
                  exit(1);
              }
              $$ = $1;
          }
        | NUMBER
          {
              $$ = $1;
          }
        | LPAREN expression RPAREN
          {
              $$ = $2;
          }
        ;

%%

/* -------- Error Function -------- */
void yyerror(const char *s)
{
    printf("Syntax error at line %d\n", line);
}

/* -------- Main -------- */
int main()
{
    if(yyparse()==0)
        printf("Syntax Correct\n");

    return 0;
}
