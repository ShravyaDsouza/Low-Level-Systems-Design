%{
#include<stdio.h>
#include "cal.tab.h"
%}

D [0-9]+
L [a-zA-Z]
ID      {L}({L}|{D})*
OB "("
CB ")"
AOP "="
ADD "+"
SUB "-"
MUL "*"
DIV "/"
SIN "sin"
COS "cos"
TAN "tan"
LOG "log"
POW "pow"
SQRT "sqrt"
SC ";"

%%

{D}     { printf("%s : this is a digit\n", yytext);
          yylval.a = atoi(yytext); return D; }
{SIN}   { printf("%s : this is sine function\n", yytext); return SIN; }
{COS}   { printf("%s : this is cosine function\n", yytext); return COS; }
{TAN}   { printf("%s : this is tanh function\n", yytext); return TAN; }
{LOG}   { printf("%s : this is log function\n", yytext); return LOG; }
{POW}   { printf("%s : this is pow function\n", yytext); return POW; }
{SQRT}  { printf("%s : this is sqrt function\n", yytext); return SQRT; }
{ID}    { printf("%s : this is an identifier\n", yytext);
          yylval.name = strdup(yytext);
          return ID;
        }
{OB}    {printf("%s : this is opening bracket\n",yytext); return OB;}
{CB}    {printf("%s : this is closing bracket\n",yytext); return CB;}
{AOP}   { printf("%s : this is assignment operator\n", yytext); return AOP; }
{ADD}   { printf("%s : this is addition operator\n", yytext); return ADD; }
{MUL}   { printf("%s : this is multiplication operator\n", yytext); return MUL; }
{SUB}   { printf("%s : this is subtraction operator\n", yytext); return SUB; }
{DIV}   { printf("%s : this is division operator\n", yytext); return DIV; }
{SC}    { printf("%s : this is semi-colon\n", yytext); return SC; }

%%
int yywrap(){
    return 1;
}