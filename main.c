#include <stdio.h>

int main(void) { 
    unsigned long a = 0;
    unsigned long b = 1;
    printf("%ld\n", a);
    printf("%ld\n", b);
    for (int i = 0; i < 30; i++) {
        unsigned long c = a + b;
        printf("%ld\n", c);
        a = b;
        b = c; 
    }
    return 0;
}