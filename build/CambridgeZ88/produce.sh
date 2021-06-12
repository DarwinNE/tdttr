#!/bin/bash

. ../config.sh

rm  Z88_TDTTR.zip

cp ../readme.txt .

zip -r Z88_TDTTR.zip tdttr1.bin tdttr2.bin tdttr34.bin readme.txt TDTTR1.BAS TDTTR2.BAS TDTTR34.BAS notes_z88.txt

cp Z88_TDTTR.zip $ditdir
