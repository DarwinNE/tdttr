aws_options = -m -c -s -d -n -w -l -3
zcc_options = +zxn -lesxdos -DSPECTRUMNEXT -lm -clib=classic -create-app -subtype=nex


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
	zcc $(zcc_options) -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" two_days_no_UTF8_1.c inout.c loadsave.c -o tdttr1.bin

part2: two_days_no_UTF8_2.c inout.c loadsave.c
	zcc $(zcc_options) -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" two_days_no_UTF8_2.c inout.c loadsave.c -o tdttr2.bin

part34: two_days_no_UTF8_34.c inout.c loadsave.c
	zcc $(zcc_options) -DCONFIG_FILENAME="\"\\\"config34.h"\"\\\" two_days_no_UTF8_34.c inout.c loadsave.c -o tdttr34.bin

clean:
	rm *.o config1.h config34.h two_days_no_UTF8_1.c config2.h two_days_no_UTF8_34.c two_days_no_UTF8_2.c *.bin *.nex