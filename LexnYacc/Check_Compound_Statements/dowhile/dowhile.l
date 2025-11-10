%{
    #include <stdio.h>
    #include "dowhile.tab.h"
%}

D       [0-9]+
L       [a-zA-Z]
ID      {L}({L}|{D})*
DO      "do"
WH      "while"
OB      "("
CB      ")"
AOP     "="
ROP     "<"|">"
SC      ";"

%%
[ \t\r\n]+           ;  /* ignore whitespace */

{DO}    { printf("%s : This is 'do' keyword\n", yytext); return DO; }
{WH}    { printf("%s : This is 'while' keyword\n", yytext); return WH; }
{ID}    { printf("%s : This is an identifier\n", yytext); return ID; }
{OB}    { printf("%s : This is an opening bracket\n", yytext); return OB; }
{CB}    { printf("%s : This is a closing bracket\n", yytext); return CB; }
{SC}    { printf("%s : This is a semi-colon\n", yytext); return SC; }
{AOP}   { printf("%s : This is an assignment operator\n", yytext); return AOP; }
{ROP}   { printf("%s : This is a relational operator\n", yytext); return ROP; }
{D}     { printf("%s : This is a digit\n", yytext); return D; }

.       { printf("Unknown symbol: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
