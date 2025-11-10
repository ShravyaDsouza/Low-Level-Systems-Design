%{
    #include <stdio.h>
    #include "for.tab.h"
%}

D       [0-9]+
L       [a-zA-Z]
ID      {L}({L}|{D})*
FOR     "for"
OB      "("
CB      ")"
AOP     "="
ROP     "<"|">"
SC      ";"
INCOP   "++"|"--"

%%
[ \t\r\n]+           ;  /* ignore whitespace */

{FOR}    { printf("%s : This is 'for' keyword\n", yytext); return FOR; }
{ID}     { printf("%s : This is an identifier\n", yytext); return ID; }
{OB}     { printf("%s : This is an opening bracket\n", yytext); return OB; }
{CB}     { printf("%s : This is a closing bracket\n", yytext); return CB; }
{SC}     { printf("%s : This is a semi-colon\n", yytext); return SC; }
{AOP}    { printf("%s : This is an assignment operator\n", yytext); return AOP; }
{ROP}    { printf("%s : This is a relational operator\n", yytext); return ROP; }
{INCOP}  { printf("%s : This is an increment/decrement operator\n", yytext); return INCOP; }
{D}      { printf("%s : This is a digit\n", yytext); return D; }

.        { printf("Unknown symbol: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
