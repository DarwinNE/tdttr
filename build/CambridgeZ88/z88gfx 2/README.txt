

To compile the demo program:

zcc +z88 -subtype=app main.c screens.asm z88gfx.asm -create-app

And then insert the .epr into a cartridge slot in OZvm

Screens are 2k (uncompressed) in:

charbychar.bin
linebyline.bin

To convert a ZX screen to linebyline:

gcc conv.c 
./a.out < SCR > linearfile

And then extract the appropriate picture third to show.

