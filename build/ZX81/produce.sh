#!/bin/bash

. ../config.sh

rm  ZX81_TDTTR.zip

cp ../readme.txt .

zip -r ZX81_TDTTR.zip *.P readme.txt notes_ZX81.txt

cp ZX81_TDTTR.zip $ditdir
