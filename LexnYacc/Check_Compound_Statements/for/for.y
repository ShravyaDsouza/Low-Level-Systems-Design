%{
    #include <stdio.h>
    int yylex(void);
    int yyerror(char *s);
%}

%token FOR ID OB CB ROP AOP D SC INCOP

%%
S
    : FOR OB INIT SC CD SC UPDATE CB STMT
        { printf("S -> for(initialization; condition; update)statement\n"); }
    ;

INIT
    : ID AOP D
        { printf("initialization -> id AOP digit\n"); }
    ;

CD
    : ID ROP ID
        { printf("condition -> id ROP id\n"); }
    ;

UPDATE
    : ID INCOP
        { printf("update -> id increment-operator\n"); }
    ;

STMT
    : ID AOP D SC
        { printf("statement -> id AOP digit semi-colon\n"); }
    ;
%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char *str) {
    printf("Error: %s\n", str);
    return 0;
}
