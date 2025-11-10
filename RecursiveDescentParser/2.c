/*
E  → T E'
E' → + T E'
    | - T E'
    | ε

T  → F T'
T' → * F T'
    | / F T'
    | ε

F  → id
    | num
    | func ( E )
    | ( E )

func → sin
     | cos
     | log
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

char *ip_ptr;

void addr() {
    ip_ptr++;
}

int E();
int Edash();
int T();
int Tdash();
int F();

int E() {
    if (T()) {
        if (Edash()) {
            return 1;
        }
    }
    return 0;
}

int Edash() {
    if (*ip_ptr == '+' || *ip_ptr == '-') {
        addr();               // consume + or -
        if (T()) {
            if (Edash()) {
                return 1;
            }
        }
        return 0;
    }
    // ε-production
    return 1;
}

int T() {
    if (F()) {
        if (Tdash()) {
            return 1;
        }
    }
    return 0;
}

int Tdash() {
    if (*ip_ptr == '*' || *ip_ptr == '/') {
        addr();               // consume * or /
        if (F()) {
            if (Tdash()) {
                return 1;
            }
        }
        return 0;
    }
    // ε-production
    return 1;
}

int F() {
    // id -> 'i'
    if (*ip_ptr == 'i') {
        addr();
        return 1;
    }

    // num -> one or more digits
    if (isdigit((unsigned char)*ip_ptr)) {
        while (isdigit((unsigned char)*ip_ptr)) {
            addr();
        }
        return 1;
    }

    // func(E) where func ∈ {sin, cos, log}
    if (strncmp(ip_ptr, "sin", 3) == 0 ||
        strncmp(ip_ptr, "cos", 3) == 0 ||
        strncmp(ip_ptr, "log", 3) == 0) {

        if (strncmp(ip_ptr, "sin", 3) == 0) ip_ptr += 3;
        else if (strncmp(ip_ptr, "cos", 3) == 0) ip_ptr += 3;
        else if (strncmp(ip_ptr, "log", 3) == 0) ip_ptr += 3;

        if (*ip_ptr == '(') {
            addr();
            if (E()) {
                if (*ip_ptr == ')') {
                    addr();
                    return 1;
                }
            }
        }
        return 0;
    }

    // (E)
    if (*ip_ptr == '(') {
        addr();
        if (E()) {
            if (*ip_ptr == ')') {
                addr();
                return 1;
            }
        }
        return 0;
    }

    return 0;
}

int main() {
    char ip[100];
    printf("Enter an arithmetic expression (use 'i' as id and end with $): ");
    scanf("%s", ip);
    ip_ptr = ip;

    if (E() && *ip_ptr == '$') {
        printf("Expression Accepted\n");
    } else {
        printf("Expression Rejected\n");
    }
    return 0;
}
