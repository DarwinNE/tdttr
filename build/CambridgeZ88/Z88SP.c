#include <graphics.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <arch/z88/z88.h>
#include "Z88SP.h"
#include "inout.h"


extern int  z88_open_map(int width) __z88dk_fastcall;
extern int  z88_close_map(void);
extern int  z88_clear_map(void);
extern void z88_copy_zx0_char_screen_to_map(void *data) __z88dk_fastcall;


extern void *char_screen;


void showsplash(void)
{
    z88_open_map(255);  // Width of the screen
    writeln("");
    writeln("");
    
    z88_copy_zx0_char_screen_to_map(&char_screen);
    //z88_clear_map();
    //fgetc_cons();
    z88_close_map();
}


