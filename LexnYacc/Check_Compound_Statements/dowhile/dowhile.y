%{
    #include <stdio.h>
    int yylex(void);
    int yyerror(char *s);
%}

%token DO WH ID OB CB ROP AOP D SC

%%
S
    : DO STMT WH OB CD CB SC
        { printf("S -> do statement while(condition);\n"); }
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
