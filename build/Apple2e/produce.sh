#!/bin/bash


# All names of the tools used for accessing the disk images in the different
# platforms are defined in a single config file in the parent directory:
. ../config.sh

# Assemble the disk image for the italian version of the game
cp dsk/prodos.po ./tdttr_it.po
java -jar $acjarfile -as ./tdttr_it.po TDTTR.SYSTEM < tdttr_it.bin
java -jar $acjarfile -p ./tdttr_it.po EM.DRV 0 < dsk/a2e.auxmem.emd
java -jar $acjarfile -p ./tdttr_it.po TEXT.DAT 0 < text_it.dat

# Assemble the disk image for the english version of the game
cp dsk/prodos.po ./tdttr_en.po
java -jar $acjarfile -as ./tdttr_en.po TDTTR.SYSTEM < tdttr_en.bin
java -jar $acjarfile -p ./tdttr_en.po EM.DRV 0 < dsk/a2e.auxmem.emd
java -jar $acjarfile -p ./tdttr_en.po TEXT.DAT 0 < text_en.dat

cp ../readme.txt .

rm  AppleIIe_TDTTR.zip
zip -r *.zip *.po readme.txt 
cp AppleIIe_TDTTR.zip $ditdir
