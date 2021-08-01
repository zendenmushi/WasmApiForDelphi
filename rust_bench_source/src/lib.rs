#![no_main] 
#![no_std]
#![feature(core_intrinsics, lang_items, alloc_error_handler)]

extern crate alloc;
extern crate wee_alloc;

use core::panic::PanicInfo;
use alloc::vec::Vec;
use alloc::boxed::Box;
use no_std_compat::slice;

#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;


fn fibonacci(n : i32) -> i32 {
    match n {
        0 => 0,
        1 => 1,
        _ => [1,2].iter().fold(0, |x,y| x + fibonacci(n - y) )
        }
}

#[no_mangle]
pub extern "C" fn fibonacci_bench() -> i32 {
    fibonacci(38)  
}

#[no_mangle]
pub extern "C" fn vec_bench() -> i32 {
//    let mut dat = Vec::with_capacity(1000000);
    let mut dat = Vec::new();
    for i in (0..1000000) {
        dat.push( i as i32 );
    }
    dat.iter().map(|x| x + 1).sum()
}



#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[alloc_error_handler]
#[no_mangle]
pub extern "C" fn oom(_: ::core::alloc::Layout) -> ! {
    unsafe {
        ::core::intrinsics::abort();
    }
}
