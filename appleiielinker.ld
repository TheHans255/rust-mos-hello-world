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
/* INCLUDE imag-regs.ld */
__rc1 = __rc0 + 1;
PROVIDE(__rc2 = __rc1 + 1);
__rc3 = __rc2 + 1;
PROVIDE(__rc4 = __rc3 + 1);
__rc5 = __rc4 + 1;
PROVIDE(__rc6 = __rc5 + 1);
__rc7 = __rc6 + 1;
PROVIDE(__rc8 = __rc7 + 1);
__rc9 = __rc8 + 1;
PROVIDE(__rc10 = __rc9 + 1);
__rc11 = __rc10 + 1;
PROVIDE(__rc12 = __rc11 + 1);
__rc13 = __rc12 + 1;
PROVIDE(__rc14 = __rc13 + 1);
__rc15 = __rc14 + 1;
PROVIDE(__rc16 = __rc15 + 1);
__rc17 = __rc16 + 1;
PROVIDE(__rc18 = __rc17 + 1);
__rc19 = __rc18 + 1;
PROVIDE(__rc20 = __rc19 + 1);
__rc21 = __rc20 + 1;
PROVIDE(__rc22 = __rc21 + 1);
__rc23 = __rc22 + 1;
PROVIDE(__rc24 = __rc23 + 1);
__rc25 = __rc24 + 1;
PROVIDE(__rc26 = __rc25 + 1);
__rc27 = __rc26 + 1;
PROVIDE(__rc28 = __rc27 + 1);
__rc29 = __rc28 + 1;
PROVIDE(__rc30 = __rc29 + 1);
__rc31 = __rc30 + 1;

ASSERT(__rc31 == 0x0021, "Inconsistent zero page map.")

MEMORY { zp : ORIGIN = __rc31 + 1, LENGTH = 0x90 - (__rc31 + 1) }

SECTIONS {
    /* This is the entire included contents of c.ld - this can be
       replaced with INCLUDE c.ld if a link to that file can be
       established */
    .zp.data : { 
        __zp_data_start = .;
        *(.zp.data .zp.data.* .zp.rodata .zp.rodata.*) 
    } >zp AT>ram
    __zp_data_load_start = LOADADDR(.zp.data);
    __zp_data_size = SIZEOF(.zp.data);
    .zp.bss (NOLOAD) : { 
        __zp_bss_start = .;
        *(.zp.bss .zp.bss.*) 
    } >zp
    __zp_bss_size = SIZEOF(.zp.bss);
    .zp (NOLOAD) : { *(.zp .zp.*) } >zp
    .text : {
        /* A mechanism for dynamically building an _init script. */
        _init = .;
        _start = .;
        *(SORT_BY_INIT_PRIORITY(.init.* .init))
        *(.call_main)
        *(.after_main)

        /* A mechanism for dynamically building a _fini script. */
        _fini = .;
        *(SORT_BY_INIT_PRIORITY(.fini.* .fini))
        *(.fini_rts)

        *(.text .text.*)

        /* A sorted list of initialization function pointers. Used for GCC
        * constructor attribute and C++ global constructors. */
        __init_array_start = .;
        KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.* .init_array)))
        __init_array_end = .;

        /* A sorted list of finalization function pointers. Used for GCC destructor
        * attribute. */
        __fini_array_start = .;
        KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.* .fini_array)))
        __fini_array_end = .;
    }
    .rodata : { *(.rodata .rodata.*) }
    .data : { __data_start = .;
        *(.data .data.*)
        __data_end = .; 
    }
    __data_load_start = LOADADDR(.data);
    __data_size = SIZEOF(.data);
    .bss : { __bss_start = .;
        *(.bss .bss.* COMMON)
        __bss_end = .;
    }
    __bss_size = SIZEOF(.bss);
    .noinit (NOLOAD) : { 
        *(.noinit .noinit.*)
        __heap_start = .;
    }
}

/* Set the operand stack to the 6K memory region below HIRES
 */
__stack = 0x1FFF;

OUTPUT_FORMAT {
    TRIM(ram)
}