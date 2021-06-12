#!/bin/bash

. ../config.sh

rm  AtariST_TDTTR.zip

cp ../readme.txt .

zip -r AtariST_TDTTR.zip tdttr40.tos tdttr80.tos readme.txt notes_AtariST.txt

cp AtariST_TDTTR.zip $ditdir
