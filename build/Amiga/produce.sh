#!/bin/bash

. ../config.sh


echo "Copy Amiga files"

outputfile="Amiga_TDTTR.adf"

rm Amiga_TDTTR.adf
$xdftoolcommand $outputfile format "Two Days to the Race"
$xdftoolcommand $outputfile boot install boot1x
$xdftoolcommand $outputfile makedir C
$xdftoolcommand $outputfile makedir S
$xdftoolcommand $outputfile makedir libs
# $xdftoolcommand $outputfile write loader C/
$xdftoolcommand $outputfile write startup-sequence S/

$xdftoolcommand $outputfile write tdttr /
$xdftoolcommand $outputfile write AMItdttr /
$xdftoolcommand $outputfile write AMItdttr.info /

$xdftoolcommand $outputfile write disk.info /


cp ../readme.txt .

zip -r Amiga_TDTTR.zip $outputfile readme.txt notes_amiga.txt
cp Amiga_TDTTR.zip $ditdir