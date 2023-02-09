#![no_std]
#![feature(start)]
#![allow(unused_imports)]

use core::mem::MaybeUninit;
use core::panic::PanicInfo;
use ufmt_stdio::*;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    println!("PANIC!!!");
    loop {}
}

#[start]
fn _main(_argc: isize, _argv: *const *const u8) -> isize {
    let mut a: u32 = 0;
    let mut b: u32 = 1;
    println!("{}", a);
    println!("{}", b);
    for _i in 0..30 {
        let c = a + b;
        println!("{}", c);
        a = b;
        b = c;
    }
    0
}
