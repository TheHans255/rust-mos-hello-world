/*
 * Apple //e linker script
 */

/*
 * TODO: This linker script is generating files that are patently wrong - 
 * the executable code ends up who knows where and attempting to draw out
 * the binary from the linker file gives us something with mostly zeroes.
 * See if you can get this target into the system in a more straightforward
 * way (and also see if you can test this package using one of the targets
 * that have been included, such as by using a C64 or Atari 800 emulator)
 */

/* Available RAM goes from 0x0800 to 0x9600, skipping 0x2000-0x5fff
 * for HIRES graphics. The program will be loaded at 0x6000,
 * and the 6K below HIRES will be reserved for the soft stack
 */
MEMORY {
    ram (rw) : ORIGIN = 0x6000, LENGTH = 0x35ff
}

__rc0 = 0x0002;
INCLUDE imag-regs.ld
ASSERT(__rc31 == 0x0021, "Inconsistent zero page map.")

MEMORY { zp : ORIGIN = __rc31 + 1, LENGTH = 0x90 - (__rc31 + 1) }

SECTIONS {
    INCLUDE c.ld
}

/* Set the operand stack to the 6K memory region below HIRES
 */
__stack = 0x1FFF;

OUTPUT_FORMAT {
    TRIM(ram)
}