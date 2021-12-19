# SPDX-License-Identifier: GPL-3.0-or-later
# Eric Herman <eric@freesa.org>

# Makefile cheat-sheet:
#
# $@ : target label
# $< : the first prerequisite after the colon
# $^ : all of the prerequisite files
# $* : wildcard matched part
#
# Target-specific Variable syntax:
# https://www.gnu.org/software/make/manual/html_node/Target_002dspecific.html
#
# patsubst : $(patsubst pattern,replacement,text)
#	https://www.gnu.org/software/make/manual/html_node/Text-Functions.html
# call : $(call func,param1,param2,...)
#	https://www.gnu.org/software/make/manual/html_node/Call-Function.html
# define :
#	https://www.gnu.org/software/make/manual/html_node/Multi_002dLine.html

Name=toy

Stage2_eltorito_url="https://github.com/DexterHaslem/fasm-multiboot/blob/master/stage2_eltorito?raw=true"

default: $(Name).elf

stage2_eltorito:
	echo "WARNING: we will download some arbitrary binary from the internet"
	echo "but see also: man 1 geteltorito"
	wget $(Stage2_eltorito_url)
	mv -v 'stage2_eltorito?raw=true' stage2_eltorito
	file $@

start.o: start.s
	as -Wa -o $@ --32 $<
	file $@

$(Name).elf: start.o link.ld
	#ld -T link.ld -melf_x86_64 $< -o $@
	ld -T link.ld -melf_i386 $< -o $@ -M > $(Name).map
	file $@

$(Name).iso: $(Name).elf stage2_eltorito
	mkdir -pv iso/boot/grub
	cp -v stage2_eltorito iso/boot/grub/stage2_eltorito
	cp -v $(Name).elf iso/boot/
	echo 'default 0'		> iso/boot/grub/menu.lst
	echo 'timeout 1'		>> iso/boot/grub/menu.lst
	echo 'title $(Name) multiboot'	>> iso/boot/grub/menu.lst
	echo 'kernel /boot/$(Name).elf'	>> iso/boot/grub/menu.lst
	genisoimage -R \
		-b boot/grub/stage2_eltorito \
		-no-emul-boot \
		-boot-load-size 4 \
		-A $(Name) \
		-input-charset utf8 \
		-boot-info-table \
		-o $@ \
		iso

image: $(Name).iso

run: image
	qemu-system-i386 -cdrom $(Name).iso

qemu: $(Name).elf
	qemu-system-i386 -kernel $<

clean:
	rm -rfv *.elf *.o *.map iso
