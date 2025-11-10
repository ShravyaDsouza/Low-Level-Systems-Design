%{
#include <stdio.h>
#include <string.h>

struct SymbolTableEntry {
    char symbol[100];
    char type[50];
} SymbolTable[500];

int count = 0;

void insert(char data[], const char type[]);
void display();

int yywrap();

void insert(char data[], const char type[]) {
    // if already exists, update type
    for (int i = 0; i < count; i++) {
        if (strcmp(SymbolTable[i].symbol, data) == 0) {
            strcpy(SymbolTable[i].type, type);
            return;
        }
    }
    strcpy(SymbolTable[count].symbol, data);
    strcpy(SymbolTable[count].type, type);
    ++count;
}

void display(void) {
    printf("\n---------------- Symbol Table ----------------\n");
    printf("Identifier\tType\n");
    printf("---------------------------------------------\n");
    for (int i = 0; i < count; i++) {
        printf("%s\t\t%s\n", SymbolTable[i].symbol, SymbolTable[i].type);
    }
}
%}

Preprocessor_directive    \#[ \t]*[a-zA-Z_][a-zA-Z0-9_]*
Header                    \<[a-zA-Z0-9_\./]+>
L                         [a-zA-Z_]
D                         [0-9]
Id                        {L}({L}|{D})*
String                    \"([^\"\\]|\\.)*\"
CharConst                 \'([^\'\\]|\\.)\'
Builtin_type              int|float|double|char|bool|void|short|long|signed|unsigned|wchar_t|size_t
Derived_dt                struct|class|union
User_dt_kw                enum|typedef|using
Keyword                   alignas|alignof|asm|auto|break|case|catch|const|const_cast|constexpr|continue|decltype|default|delete|do|dynamic_cast|else|explicit|export|extern|false|for|friend|goto|if|inline|mutable|namespace|new|noexcept|nullptr|operator|private|protected|public|register|reinterpret_cast|return|sizeof|static|static_cast|static_assert|switch|template|this|thread_local|throw|true|try|typeid|typename|virtual|volatile|while
Relational_operator       (==|!=|<=|>=|<|>)
Logical_operator          (&&|\|\||!)
Arithmetic_operator    ("+"|"-"|"*"|"/"|"%"|"++"|"--")
Assignment_operator    ("="|"+="|"-="|"*="|"/="|"%="|"&="|"|="|"^="|"<<="|">>=")
Bitwise_operator          (&|\||\^|~|<<|>>)
Scope_resolution          "::"
Ternary_q                 \?
Ternary_c                 :
Separator                 [;,()\{\}\[\]\.]
Line_comment              \/\/[^\n]*
Block_comment             \/\\*([^*]|\*+[^/])*\*+\/
WS                        [ \t\r\n]+

%%

{WS}                      ;
{Line_comment}            ;
{Block_comment}           ;

{Preprocessor_directive}  {
    printf("%s this is a preprocessor directive\n", yytext);
}

{Header}                  {
    printf("%s this is a header file\n", yytext);
}

{Builtin_type}            {
    printf("%s this is a built-in datatype\n", yytext);
}

{Derived_dt}              {
    printf("%s this is a derived data type keyword\n", yytext);
}

{User_dt_kw}              {
    printf("%s this is a user-defined type keyword\n", yytext);
}

{Keyword}                 {
    printf("%s this is a C++ keyword\n", yytext);
}

{Id}"(" {
    char funcname[100];
    int len = yyleng - 1;        /* drop '(' */
    if (len >= (int)sizeof(funcname)) len = (int)sizeof(funcname) - 1;
    strncpy(funcname, yytext, len);
    funcname[len] = '\0';

    printf("%s this is a user defined function\n", funcname);
    insert(funcname, "function");
}

{Id}(\[[0-9]*\])+ {
    printf("%s this is an array declarator\n", yytext);
    insert(yytext, "array");
}


"*"{Id} {
    // pointer declarator like *ptr
    // yytext is "*id"
    char name[100];
    int len = yyleng - 1;
    if (len >= (int)sizeof(name)) len = (int)sizeof(name) - 1;
    strncpy(name, yytext + 1, len);
    name[len] = '\0';
    printf("%s this is a pointer declarator\n", name);
    insert(name, "pointer");
}

"&"{Id} {
    // reference declarator like &ref
    char name[100];
    int len = yyleng - 1;
    if (len >= (int)sizeof(name)) len = (int)sizeof(name) - 1;
    strncpy(name, yytext + 1, len);
    name[len] = '\0';
    printf("%s this is a reference declarator\n", name);
    insert(name, "reference");
}

{Id} {
    printf("%s this is an identifier\n", yytext);
    insert(yytext, "id");
}

{String} {
    printf("%s this is a string literal\n", yytext);
}

{CharConst} {
    printf("%s this is a character literal\n", yytext);
}

{Arithmetic_operator} {
    printf("%s this is an arithmetic operator\n", yytext);
}

{Relational_operator} {
    printf("%s this is a relational operator\n", yytext);
}

{Logical_operator} {
    printf("%s this is a logical operator\n", yytext);
}

{Assignment_operator} {
    printf("%s this is an assignment operator\n", yytext);
}

{Bitwise_operator} {
    printf("%s this is a bitwise operator\n", yytext);
}

{Scope_resolution} {
    printf("%s this is a scope resolution operator\n", yytext);
}

{Ternary_q} {
    printf("%s this is a ternary ? operator\n", yytext);
}

{Ternary_c} {
    printf("%s this is a ternary : operator\n", yytext);
}

{Separator} {
    printf("%s this is a separator/punctuator\n", yytext);
}

. {
    printf("%s is an unrecognized token\n", yytext);
}

%%

int main(void) {
    yyin = fopen("sample.cpp", "r");
    if (!yyin) {
        perror("fopen");
        return 1;
    }

    yylex();
    display();
    return 0;
}

int yywrap() {
    return 1;
}
