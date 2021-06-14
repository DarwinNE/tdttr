#!/bin/bash

. ../config.sh

rm  Z88_TDTTR.zip

cp ../readme.txt .

rm -r Z88_TDTTR
mkdir Z88_TDTTR
mkdir Z88_TDTTR/epr
mkdir Z88_TDTTR/app
mkdir Z88_TDTTR/bas

cp readme.txt Z88_TDTTR
cp notes_z88.txt Z88_TDTTR

# .epr files are for emulators
cp tdttr1.epr Z88_TDTTR/epr
cp tdttr2.epr Z88_TDTTR/epr
cp tdttr34.epr Z88_TDTTR/epr

# .app files for installing application in RAM
cp tdttr1.ap* Z88_TDTTR/app
cp tdttr2.ap* Z88_TDTTR/app
cp tdttr34.ap* Z88_TDTTR/app

# .BAS files for the BBC basic
cp TDTTR1.BAS Z88_TDTTR/bas
cp TDTTR2.BAS Z88_TDTTR/bas
cp TDTTR34.BAS Z88_TDTTR/bas


zip -r Z88_TDTTR.zip Z88_TDTTR

cp Z88_TDTTR.zip $ditdir
