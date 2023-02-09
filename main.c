#include <stdio.h>

// putchar() on the Apple II system
void __putchar(char c) {
  // TODO: add repositioning code
  // TODO: account for I/O card scratch space and text repositioning
  static char x = 0;
  static char y = 0;
  static char *textscreen = (char *)0x0400;
  if (c > 0x20) {
    textscreen[((int)y / 3 * 128) + (y % 3 * 40) + x] = (c | 128);
  }
  x++;
  if (x >= 40 || c == '\r') {
    x = 0;
    y++;
    if (y >= 24) {
        y = 0;
    }
  }
}

int main(void) { 
    for (int x = 0; x < 100; x++) {
        printf("Hello %d!\r", 6502); 
    }
}