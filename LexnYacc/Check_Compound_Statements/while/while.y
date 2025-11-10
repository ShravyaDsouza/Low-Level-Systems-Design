%{
    #include<stdio.h>
    extern int yyerror(char *str);
    extern int yylex();
%}

%token ID WH OB CB ROP AOP D SC

%%
S : WH OB CD CB STMT {printf("S -> while(condition)statement");};
CD : ID ROP ID {printf("condition -> id ROP id");};
STMT : ID AOP D SC {printf("statement -> id AOP digit semi-colon");};
%%

int main()
{
    yyparse();
    return 0;
}

int yyerror(char *str) {
    printf("Error");
    return 0; 
}
