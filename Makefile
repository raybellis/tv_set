DISK = 500

AS = ca65
LD = ld65

tv255.ssd:	tv255.rom
	$(RM) $@
	beeb blank_ssd $@
	beeb title $@ "TV255"
	beeb putfile $@ $^

tv255.rom:		tv255.o
	$(LD) --target bbc -o $@ $^ 

tv255.o:	tv255.s
	$(AS) -l $(^:.s=.lst) $^

.PHONY:	disk clean

disk:	tv255.ssd
	beeb dkill -y ${DISK}
	beeb dput_ssd ${DISK} $^
	diskutil eject "/Volumes/NO NAME"

clean:
	$(RM) tv255.ssd tv255.rom tv255.o tv255.lst
