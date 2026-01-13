cc65_options = -O -C apple2enh-system.cfg -t apple2enh -D APPLE2E -D NCOL=80 -D CV_IS_A_FUNCTION 
aws_options  = -m -c -s -d -n -w -3 -kk -p

all: Apple2e

tdttr_no_utf8.c: ../../aws_sources/all_parts/Two_days_to_the_race_ita.aws
	../../../aws2c $(aws_options) -R res_it.lst mapfile_it.h -f config_it_nu.h $< $@

tdttr_no_utf8_en.c: ../../aws_sources/all_parts/Two_days_to_the_race.aws
	../../../aws2c $(aws_options) -R res_en.lst mapfile_en.h -f config_en_nu.h $< $@

text_en.dat: tdttr_no_utf8_en.c
	python ../../../utils/retro/res_packer.py res_en.lst text_en.dat

text_it.dat: tdttr_no_utf8.c
	python ../../../utils/retro/res_packer.py res_it.lst text_it.dat

tdttr_it.bin: inout.c tdttr_no_utf8.c resource.c text_it.dat
	cl65  -DCONFIG_FILENAME=\"config_it_nu.h\" --mapfile tdttr_it.map $(cc65_options) tdttr_no_utf8.c inout.c loadsave.c resource.c -o $@

tdttr_en.bin: inout.c tdttr_no_utf8_en.c resource.c text_en.dat
	cl65  -DCONFIG_FILENAME=\"config_en_nu.h\" --mapfile tdttr_en.map $(cc65_options) tdttr_no_utf8_en.c inout.c loadsave.c resource.c -o $@
	

Apple2e: tdttr_it.bin tdttr_en.bin

clean:
	rm tdttr_no_utf8*.c config_*_nu.h *.o *.dat *.po *.map *.bin mapfile_*.h *.lst
