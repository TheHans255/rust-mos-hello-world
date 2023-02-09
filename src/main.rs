#![no_std]
#![feature(start)]
#![allow(unused_imports)]

use core::panic::PanicInfo;
use ufmt_stdio::*;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    //#[cfg(not(target_vendor = "nes-nrom-128"))]
    println!("PANIC!!!");
    loop {}
}

static mut PUTCHAR_X: u8 = 0;
static mut PUTCHAR_Y: u8 = 0;
const TEXT_SCREEN: *mut u8 = 0x0400 as *mut u8;

// TODO: This should use the COUT system call
#[no_mangle]
fn __putchar(c: u8) -> () {
    let mut x = unsafe { PUTCHAR_X };
    let mut y = unsafe { PUTCHAR_Y };
    if c >= 32 {
        let offset = (y as usize / 3 * 128) + (y % 3 * 40) as usize + x as usize;
        unsafe {
            *(TEXT_SCREEN.add(offset.into())) = c | 128;
        }
        
        x = x.wrapping_add(1);
        if x >= 40 {
            x = 0;
            y = y.wrapping_add(1);
            if y >= 24 {
                // TODO: scroll the screen
                y = 0;
            }
        }
    } else if c == 10 {
        x = 0;
        y = y.wrapping_add(1);
        if y >= 24 {
            // TODO: scroll the screen
            y = 0;
        }
    }
    unsafe {
        PUTCHAR_X = x;
        PUTCHAR_Y = y;
    }
}

#[start]
fn _main(_argc: isize, _argv: *const *const u8) -> isize {
    //#[cfg(not(target_vendor = "nes-nrom-128"))]
    for _i in 0..100 {
        println!("Hello {}!", 6502);
    }
    0
}
