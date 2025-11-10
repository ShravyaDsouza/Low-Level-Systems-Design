%{
    #include <stdio.h>
    int yylex(void);
    int yyerror(char *s);
%}

%token ID IF OB CB ROP AOP D SC

%%
S
    : IF OB CD CB STMT
        { printf("S -> if(condition)statement\n"); }
    ;

CD
    : ID ROP ID
        { printf("condition -> id ROP id\n"); }
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
