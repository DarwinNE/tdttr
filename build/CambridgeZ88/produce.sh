#!/bin/bash

. ../config.sh

rm  Z88_TDTTR.zip

cp ../readme.txt .

zip -r Z88_TDTTR.zip tdttr1.epr tdttr2.epr tdttr34.epr readme.txt notes_z88.txt

cp Z88_TDTTR.zip $ditdir
