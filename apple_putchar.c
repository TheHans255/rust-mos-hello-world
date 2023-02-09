// TODO: The compiler output from this messes with something in the stack
// for DOS 3.3 and does not return properly from BRUN. A simple "print a line
// multiple times" example looped infinitely, and this Fibonacci Sequence
// example executed an illegal instruction and ended up in the system monitor.
// Programs that use this run fine up until we try to exit from _main, and they also
// run correctly when called from Basic (BLOAD ..., CALL 24576)
// or from the System Monitor (6000G).
// Note that this could also be the linker's fault.

void __chrout(char c) {
  __attribute__((leaf)) asm volatile("jsr\t0xFDED" : : "a" (c) : "a", "x", "y", "p");
}

void __putchar(char c) {
  if (__builtin_expect(c == '\n', 0)) c = '\r';
  __chrout(c ^ -128);
}