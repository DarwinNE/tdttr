
/* Convert screen to linear */


#include <stdio.h>

static unsigned char buf[6912];


int main() {
    unsigned char *Dest;

    fread(buf, 1, 6912, stdin);

    for ( int seg = 0; seg < 3; seg++ ) {
        unsigned char *segstart = buf + (seg * 2048);
        for ( int row = 0; row < 8 ; row++ ) {
           unsigned char *rowstart = segstart + (32 * row);
           for ( int crow = 0; crow < 8; crow++ ) {
		printf("%d\n",rowstart - buf);
//                fwrite(rowstart, 1, 32, stdout);
                rowstart = rowstart + 256;
           }          
        }
    }

}
