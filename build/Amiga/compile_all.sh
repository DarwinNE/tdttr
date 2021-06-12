#!/bin/bash

# I don't know why, but if I put this line in a makefile, it fails. It is
# probably an issue with my compiler, or its configuration on my machine.

m68k-amigaos-gcc -s -mcrt=nix13 -m68000 -Os -Wall -DCONFIG_FILENAME=\"config.h\"  -o tdttr two_days_no_UTF8.c inout.c loadsave.c