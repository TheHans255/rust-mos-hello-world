/*
 * Apple //e linker script
 */

/* Available RAM goes from 0x0800 to 0x9600, skipping 0x2000-0x5fff
 * for HIRES graphics. The program will be loaded at 0x6000,
 * and the 6K below HIRES will be reserved for the soft stack
 */
MEMORY {
    ram (rw) : ORIGIN = 0x6000, LENGTH = 0x35ff
}

INPUT(apple_putchar.o)

/*
 * Set zero page registers to skip the locations
 * used by the System Monitor (so that we can use
 * monitor routines like COUT)
 * Note that it would be good to also skip the locations
 * used by DOS 3.3 so that we can use those routines as well,
 * though those locations are unfortunately scattered.
 */
__rc0 = 0x0002;
__rc30 = 0x0056;
INCLUDE imag-regs.ld
ASSERT(__rc29 == 0x001f, "Inconsistent zero page map.")

MEMORY { zp : ORIGIN = 0x0078, LENGTH = 0x0030 }

SECTIONS {
    INCLUDE c.ld
}

/* 
 * Set the operand stack to the 6K memory region below HIRES
 */
__stack = 0x1FFF;

OUTPUT_FORMAT {
    TRIM(ram)
}