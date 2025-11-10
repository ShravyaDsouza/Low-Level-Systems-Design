%{
#include <stdio.h>
#include <string.h>

struct SymbolTable {
    char symbol[50];
    char type[50];
} SymbolTable[100];

int count = 0;
void insert(char data[], char type[]);
void display();

void insert(char data[], char type[]) {
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
void display() {
    int i;
    printf("\nSymbol Table:\n");
    for (i = 0; i < count; i++) {
        printf("%s\t%s\n", SymbolTable[i].symbol, SymbolTable[i].type);
    }
}
%}


Preprocessor_directive  \#[a-zA-Z_][a-zA-Z0-9_]*
Keywords               main|printf|scanf|if|else|for|while|return|switch|case|break|continue|void
L                      [a-zA-Z]
D                      [0-9]
Header                 \<[a-zA-Z0-9_]+\.h\>
Arithmetic_operator    "+"|"-"|"\\*"|"\\%"|"/"|"\\+\\+"|"--"
Relational_operator    "=="|"!="|"\\<"|"\\>"|">="|"<="
Logical_operator       "&&"|"\\|\\|"|"!"
Assignment_operator    "="|"+="|"-="|"\\*="|"/="|"%="
Bitwise_operator       "&"|"\\|"|"\\^"|"~"|"<<"|">>"
Derived_dt             struct|union
User_dt                enum|typedef
Id                     {L}({L}|{D})*
String                 \"([^\"\\]|\\.)*\"  
Separator              [;,()\{\}\[\],]     

%%
{Preprocessor_directive}    { printf("%s this is a preprocessor directive\n", yytext); }
{Header}                    { printf("%s this is the header file\n", yytext); }
int|float|char|double|long|bool  { printf("%s this is a datatype\n", yytext); }
{Derived_dt}                { printf("%s this is a derived data type\n", yytext); } 
{User_dt}                   { printf("%s this is a user defined data type\n", yytext); } 
{Keywords}"("   { printf("%s this is a library function\n", yytext); }
{Keywords}      { printf("%s this is a keyword\n", yytext); }
{Id}(\[\]|\[[0-9]+\])+   { printf("%s this is an array declarator\n", yytext); insert(yytext, "array"); }
{Id}"("          { printf("%s this is a user defined function\n", yytext); }
{Id}                        { printf("%s this is an identifier\n", yytext); insert(yytext, "id"); }
{Arithmetic_operator}       { printf("%s this is an arithmetic operator\n", yytext); }
{Relational_operator}       { printf("%s this is a relational operator\n", yytext); }
{Logical_operator}          { printf("%s this is a logical operator\n", yytext); }
{Assignment_operator}       { printf("%s this is an assignment operator\n", yytext); }
{Bitwise_operator}          { printf("%s this is a bitwise operator\n", yytext); }
{String}                    { printf("%s this is a string literal\n", yytext); }
{Separator}                 { printf("%s this is a separator/punctuator\n", yytext); }
"**"{Id}   { printf("%s this is a double-pointer declarator\n", yytext); }
"*"{Id}    { printf("%s this is a pointer declarator\n", yytext); }
%%


int main(){
    yyin = fopen("sample.c","r");
    yylex();
    display();
    yywrap();
    return 0; 
}

int yywrap() {
    return 1;
}
