DISK = 500

AS = ca65
LD = ld65

tv_set.rom:	tv_set.o
	$(LD) --target bbc -o $@ $^ 

tv_set.o:	tv_set.s
	$(AS) -l $(^:.s=.lst) $^

tv_set.s:	bbc.inc

tv_set.ssd:	tv_set.rom
	$(RM) $@
	beeb blank_ssd $@
	beeb title $@ "TVSET"
	beeb putfile $@ $^

.PHONY:	disk clean

disk:	tv_set.ssd
	beeb dkill -y ${DISK}
	beeb dput_ssd ${DISK} $^
	diskutil eject "/Volumes/NO NAME"

clean:
	$(RM) tv_set.ssd tv_set.rom tv_set.o tv_set.lst
