#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *ip_ptr;

/*
E  -> T E'
E' -> + T E' | ε
T  -> F T'
T' -> * F T' | ε
F  -> ( E ) | i      
*/

int E();
int ED();
int T();
int TD();
int F();

void adv(){ 
    ip_ptr++; 
}

int E(){
    if (T()){
        if (ED()){
            return 1;
        }
    }
    return 0;
}

int ED(){
    if (*ip_ptr == '+'){
        adv();             
        if (T()){
            if (ED()){
                return 1;
            }
        }
        return 0;
    } else {
        return 1;
    }
}

int T(){
    if (F()){
        if (TD()){
            return 1;
        }
    }
    return 0;
}

int TD(){
    if (*ip_ptr == '*'){
        adv();             
        if (F()){
            if (TD()){
                return 1;
            }
        }
        return 0;
    } else {
        return 1;
    }
}

int F(){
    if (*ip_ptr == '('){
        adv();          
        if (!E()) return 0;
        if (*ip_ptr != ')') return 0;
        adv();             
        return 1;
    } else if (*ip_ptr == 'i'){
        adv();              
        return 1;
    }
    return 0;
}

int main(){
    char ip[100];
    printf("Enter an arithmetic expression (use 'i' as id and end with $): ");
    scanf("%s",ip);
    ip_ptr = ip;

    if (E() && *ip_ptr == '$'){
        printf("Expression Accepted\n");
    } else {
        printf("Expression Rejected\n");
    }
    return 0;
}
