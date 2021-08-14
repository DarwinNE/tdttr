aws_options  = -m -c -s -d -n -w -l -3
zcc_options_epr = +z88 -DZ88 -create-app -pragma-define:ansicolumns=80  z88.c -DALTSPLASH  Z88SP.c screen.asm z88gfx.asm  -pragma-define:CRT_ORG_CODE=32768 -clib=ansi -m -subtype=app 
zcc_options_ins = +z88 -DZ88 -create-app -pragma-define:ansicolumns=80  z88.c -DALTSPLASH  Z88SP.c screen.asm z88gfx.asm -pragma-define:CRT_ORG_CODE=32768 -clib=ansi -m -subtype=installer 
zcc_options_bas = +z88 -DZ88 -DALTSPLASH  Z88SP.c screen.asm z88gfx.asm -clib=ansi -m 

.PHONY: part1 part2 part34 all z88

all: z88

two_days_no_UTF8_1.c: ../../aws_sources/part1/Two_days_to_the_race_1.aws
	../../../aws2c $(aws_options) -f config1.h ../../aws_sources/part1/Two_days_to_the_race_1.aws two_days_no_UTF8_1.c

two_days_no_UTF8_2.c: ../../aws_sources/part2/Two_days_to_the_race_2.aws
	../../../aws2c $(aws_options) -f config2.h ../../aws_sources/part2/Two_days_to_the_race_2.aws two_days_no_UTF8_2.c

two_days_no_UTF8_34.c: ../../aws_sources/part34/Two_days_to_the_race_3_4.aws
	../../../aws2c $(aws_options) -f config34.h  ../../aws_sources/part34/Two_days_to_the_race_3_4.aws two_days_no_UTF8_34.c

z88: part1 part2 part34

part1: two_days_no_UTF8_1.c inout.c loadsave.c
	zcc $(zcc_options_epr) -DAPP_NAME="\"\\\"TwoDays 1"\"\\\" -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" two_days_no_UTF8_1.c inout.c loadsave.c Etude9.asm -o tdttr1.bin
	zcc $(zcc_options_ins) -DAPP_NAME="\"\\\"TwoDays 1"\"\\\" -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" two_days_no_UTF8_1.c inout.c loadsave.c Etude9.asm -o tdttr1.bin
	zcc $(zcc_options_bas) -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" two_days_no_UTF8_1.c inout.c loadsave.c  Etude9.asm -o TDTTR1.BAS


part2: two_days_no_UTF8_2.c inout.c loadsave.c
	zcc $(zcc_options_epr) -DAPP_NAME="\"\\\"TwoDays 2"\"\\\" -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" two_days_no_UTF8_2.c inout.c loadsave.c Etude9.asm -o tdttr2.bin
	zcc $(zcc_options_ins) -DAPP_NAME="\"\\\"TwoDays 2"\"\\\" -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" two_days_no_UTF8_2.c inout.c loadsave.c Etude9.asm -o tdttr2.bin
	zcc $(zcc_options_bas) -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" two_days_no_UTF8_2.c inout.c loadsave.c  Etude9.asm -o TDTTR2.BAS


part34: two_days_no_UTF8_34.c inout.c loadsave.c
	zcc $(zcc_options_epr) -DAPP_NAME="\"\\\"TwoDays 3"\"\\\" -DCONFIG_FILENAME="\"\\\"config34.h"\"\\\" two_days_no_UTF8_34.c inout.c loadsave.c Etude9.asm -o tdttr34.bin
	zcc $(zcc_options_ins) -DAPP_NAME="\"\\\"TwoDays 3"\"\\\" -DCONFIG_FILENAME="\"\\\"config34.h"\"\\\" two_days_no_UTF8_34.c inout.c loadsave.c Etude9.asm -o tdttr34.bin
	zcc $(zcc_options_bas) -DCONFIG_FILENAME="\"\\\"config34.h"\"\\\" two_days_no_UTF8_34.c inout.c loadsave.c  Etude9.asm -o TDTTR34.BAS


clean:
	rm *.o *.app *.ap1 *.ap0  *.map *.epr *.62 *.63 config1.h config34.h two_days_no_UTF8_1.c config2.h two_days_no_UTF8_34.c two_days_no_UTF8_2.c *.bin *.BAS *.bas