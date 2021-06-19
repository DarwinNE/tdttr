#!/bin/bash

. ../config.sh

rm  Next_TDTTR.zip
rm  -r Next_TDTTR

mkdir Next_TDTTR
cp ../readme.txt .

cp readme.txt Next_TDTTR
cp notes_Next.txt Next_TDTTR

# .epr files are for emulators
cp tdttr1.nex Next_TDTTR
cp tdttr2.nex Next_TDTTR
cp tdttr34.nex Next_TDTTR

zip -r Next_TDTTR.zip Next_TDTTR

cp Next_TDTTR.zip $ditdir
