


#include <graphics.h>
#include <stdio.h>
#include <stdlib.h>
#include <arch/z88/z88.h>


// Minimal Code for generation an application header
#include <arch/z88/dor.h>
#define APP_NAME "copyscreen"
#define APP_KEY 'c'
#include <arch/z88/application.h>


extern void z88_copy_char_screen_to_map(void *data);
extern void z88_copy_zx0_char_screen_to_map(void *data);
extern void z88_copy_line_screen_to_map(void *data);


/* Definition for the z88 map window */
static struct window graphics;


extern void *char_screen;
extern void *char_screen_zx0;
extern void *line_screen;

int main() {
    // The z88 map is of variable width so we need to specify the size
    graphics.graph=1;
    graphics.width=255;
    graphics.number='4';
    if (window(&graphics)) {
            printf("Sorry, Can't Open Map");
            exit(0);
    }

    printf("Showing screen by character\n");
    z88_copy_char_screen_to_map(&char_screen);
    printf("Press any key to clear the graphics\n");
    fgetc_cons();
    clg();

    printf("Press any key to show line by line\n");
    fgetc_cons();
    z88_copy_line_screen_to_map(&line_screen);
    printf("Press any key to show compressed by character\n");
    fgetc_cons();
    z88_copy_zx0_char_screen_to_map(&char_screen_zx0);
    printf("Press any key to exit\n");
    fgetc_cons();


    closegfx(&graphics);
}


