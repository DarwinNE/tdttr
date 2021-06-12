aws_options  = -m -c -s -d -n -w -l -3

all: amiga

two_days_no_UTF8.c: ../../aws_sources/all_parts/Two_days_to_the_race.aws
	../../../aws2c $(aws_options) ../../aws_sources/all_parts/Two_days_to_the_race.aws two_days_no_UTF8.c



amiga: all_parts

all_parts: two_days_no_UTF8.c inout.c loadsave.c
	./compile_all.sh


clean:
	rm config.h two_days_no_UTF8.c config*.h  *.o tdttr
