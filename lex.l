%{
#include "parser.tab.h"
#include <string.h>
#include <stdio.h>

int line = 1;
%}

letter [a-zA-Z]
digit  [0-9]
id     {letter}({letter}|{digit})*

%%

"int"      { return INT; }
"float"    { return FLOAT; }
"char"     { return CHAR; }
"double"   { return DOUBLE; }

{id}       { yylval.str = strdup(yytext); return IDENTIFIER; }
{digit}+   { yylval.str = strdup(yytext); return NUMBER; }

"+"        { return PLUS; }
"-"        { return MINUS; }
"*"        { return MUL; }
"/"        { return DIV; }
"%"        { return MOD; }

"="        { return ASSIGN; }
"("        { return LPAREN; }
")"        { return RPAREN; }
"{"        { return LBRACE; }
"}"        { return RBRACE; }
";"        { return SEMICOLON; }

\n         { line++; }
[ \t]+     ;

.          { return yytext[0]; }

%%

int yywrap() { return 1; }
