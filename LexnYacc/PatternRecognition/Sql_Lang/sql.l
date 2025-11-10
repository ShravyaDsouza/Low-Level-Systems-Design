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

/* Case-insensitive SQL */
%option caseless
WS                  [ \t\r\n]+
D                   [0-9]
L                   [a-zA-Z_]
Id                  {L}({L}|{D}|_)*
Number              {D}+("."{D}*)?|"."{D}+
String              \'([^\'\n]|\'\')*\'
Builtin_dt      INT|INTEGER|SMALLINT|BIGINT|FLOAT|REAL|DOUBLE|DECIMAL|NUMERIC|CHAR|VARCHAR|TEXT|DATE|TIME|TIMESTAMP
Keywords        SELECT|FROM|WHERE|INSERT|INTO|VALUES|UPDATE|SET|DELETE|CREATE|TABLE|ALTER|DROP|JOIN|INNER|LEFT|RIGHT|FULL|OUTER|ON|GROUP|BY|ORDER|HAVING|DISTINCT|AS|AND|OR|NOT|IN|IS|NULL|LIKE|BETWEEN|UNION|ALL|LIMIT|OFFSET|PRIMARY|KEY|FOREIGN|REFERENCES|CHECK|DEFAULT|VIEW|INDEX|TOP
Arithmetic_operator ("+"|"-"|"*"|"/"|"%")
Relational_operator ("="|"<>"|"!="|"<="|">="|"<"|">")
Logical_operator    AND|OR|NOT
Concat_operator     ("||")

%%

{WS}                    ;   
{Logical_operator}      { printf("%s this is a logical operator\n", yytext); }  
{Builtin_dt}        { printf("%s this is a datatype\n", yytext);}
{Keywords}              { printf("%s this is a keyword\n", yytext); }            
{Id}                    { printf("%s this is an identifier\n", yytext); insert(yytext,"id"); } 
{Number}                { printf("%s this is a number literal\n", yytext); }      
{String}                { printf("%s this is a string literal\n", yytext); }          
{Arithmetic_operator}   { printf("%s this is an arithmetic operator\n", yytext); }     
{Relational_operator}   { printf("%s this is a relational operator\n", yytext); }   
{Concat_operator}       { printf("%s this is a concatenation operator\n", yytext); }   
","                     { printf("%s this is a comma\n", yytext); }               
";"                     { printf("%s this is a semicolon\n", yytext); }             
"("                     { printf("%s this is a left parenthesis\n", yytext); }          
")"                     { printf("%s this is a right parenthesis\n", yytext); }      
"."                     { printf("%s this is a dot operator\n", yytext); }           
.                       { printf("%s is an unrecognized token\n", yytext); }           

%%

int yywrap() {
    return 1;
}

int main() {
    yyin = fopen("/Users/shravyadsouza/Desktop/Low-Level-Systems-Design/LexnYacc/PatternRecognition/Sql_Lang/sample.sql","r");
    if (!yyin) {
        perror("fopen");
        return 1;
    }
    yylex();
    display();
    return 0; 
}