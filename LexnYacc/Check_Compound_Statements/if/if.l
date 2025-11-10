%{
    #include <stdio.h>
    #include "if.tab.h"  
%}

D   [0-9]+
L   [a-zA-Z]
ID  {L}({L}|{D})*
IF  "if"
OB  "("
CB  ")"
AOP "="
ROP "<"|">"
SC  ";"

%%
[ \t\r\n]+           ;  /* ignore whitespace */

{IF}  { printf("%s : This is if statement\n", yytext); return IF; }
{ID}  { printf("%s : This is an identifier\n", yytext); return ID; }
{OB}  { printf("%s : This is an opening bracket\n", yytext); return OB; }
{CB}  { printf("%s : This is a closing bracket\n", yytext); return CB; }
{SC}  { printf("%s : This is a semi-colon\n", yytext); return SC; }
{AOP} { printf("%s : This is an assignment operator\n", yytext); return AOP; }
{ROP} { printf("%s : This is a relational operator\n", yytext); return ROP; }
{D}   { printf("%s : This is a digit\n", yytext); return D; }

.     { printf("Unknown symbol: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
