# Makefile - Make script for this template

# Please, indicate which is your USB stick device, e.g. /dev/sdb.
# If unsure, check with 'fdisk -l', 'cat /proc/mounts' etc.
# Warning, if your accidentally indicate your HD, you may be in trouble.

STICK = /dev/sdb

# From here down, you probably don't need to change anything.

MBR = mbr.bin
QEMU=qemu-system-i386
ISO = boot.iso
FLOPPY = floppy.img

all: $(MBR) 


# Build bin from asm

%.bin : %.asm
	nasm -O0 $< -f bin -o $@

# Test with x86 emulator

test: $(MBR)
	qemu-system-i386 -drive format=raw,file=$(MBR) -net none

# Create bootable USP stick

iso: $(ISO)

$(ISO) : $(FLOPPY)
	xorriso -as mkisofs -b $< -o $@ -isohybrid-mbr $(MBR) \
	-no-emul-boot -boot-load-size 4 ./

$(FLOPPY) : $(MBR)
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=$< of=$@ seek=0 conv=notrunc

test-iso: $(ISO)
	qemu-system-i386 -drive format=raw,file=$(MBR) -net none

stick: $(ISO)
	@if test -z "$(STICK)"; then \
	 echo "*** ATTENTION: Edit Makefile first"; exit 1; fi 
	dd if=$< of=$(STICK)

# Housekeeping

.PHONE: clean

clean:
	rm -f *.bin *.img *.iso *~ *.o 


