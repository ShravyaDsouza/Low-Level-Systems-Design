%{
#include<stdio.h>
#include "while.tab.h"
%}

D [0-9]+
L [a-zA-z]
ID {L}({L}|{D})*
WH "while"
OB  "("
CB  ")"
AOP  "="
ROP "<"|">"
SC ";"

%%
[ \t\r\n]+           ;  /* skip whitespace */
{WH}   { printf("%s : this is while keyword\n", yytext); return WH; }
{ID}   { printf("%s : this is an identifier\n", yytext); return ID; }
{D}    { printf("%s : this is a digit\n", yytext); return D; }
{OB}   { printf("%s : this is an open bracket\n", yytext); return OB; }
{CB}   { printf("%s : this is a closing bracket\n", yytext); return CB; }
{AOP}  { printf("%s : this is assignment operator\n", yytext); return AOP; }
{ROP}  { printf("%s : this is a relational operator\n", yytext); return ROP; }
{SC}   { printf("%s : this is semi-colon\n", yytext); return SC; }

.      { /* unknown char */ printf("Unknown: %s\n", yytext); }
%%

int yywrap() { 
    return 1; 
}