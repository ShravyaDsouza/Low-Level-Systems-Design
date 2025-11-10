%{
    #include<stdio.h>
    #include<math.h>
    extern int yyerror(char *str);
    extern int yylex();
%}

%union{ float a; char *name;}
%token AOP ADD SC MUL SUB DIV OB CB SIN COS LOG POW SQRT TAN
%token <name> ID
%token <a>D
%type <a>exp

%right AOP
%left ADD SUB 
%left MUL DIV

%%
EDASH : exp {printf("=%fd\n",$1);}
      | ID AOP exp { printf("%s=%f\n", $1, $3);};
exp : OB exp CB {$$ = $2;}
    | exp ADD exp {$$ = $1 + $3;}
    | exp MUL exp {$$ = $1 * $3;}
    | exp SUB exp {$$ = $1 - $3;}
    | exp DIV exp {$$ = $1 / $3;}
    | SIN OB exp CB         { $$ = sin($3); }
    | COS OB exp CB         { $$ = cos($3); }
    | TAN OB exp CB         { $$ = tan($3); }
    | LOG OB exp CB         { $$ = log($3); }  
    | SQRT OB exp CB        { $$ = sqrt($3); }
    | POW OB exp CB         { $$ = pow($3, 2); } 
    | D {$$ = $1;};
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