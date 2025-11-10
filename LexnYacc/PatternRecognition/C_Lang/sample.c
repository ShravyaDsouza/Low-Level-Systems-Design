#include<stdio.h>
void print() {
    printf("Hello!\n");
}
int main(){
    int a , b ,c;
    float d[10];
    int *pt1;
    printf("Enter value of a:");
    scanf("%d",&a);
    printf("Enter value of b:");
    scanf("%d",&b);

    print();

    c = a+b;
    printf("Sum:%d",c);
    if(c < 5){
        a = 20;
        printf("%d %d:",c,a);
    }
    return 0;
}
