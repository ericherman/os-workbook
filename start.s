.global start				# entry symbol for ELF

.equ MAGIC, 0x4BADC0DE			# define the magic constant
.equ FLAGS, 0x0				# multiboot flags
.equ CHECKSUM, -MAGIC			# calculate the checksum
					# (magic + checksum + flags == 0)
# XXX: FIXME: PVH ELF Note does not work
# qemu-system-i386: Error loading uncompressed kernel without PVH ELF Note
.note:
.align 4
.long 6 # name size == strlen(".note") + 1
.long 4 # data size
.long 18 # type (0x12)
.align 4
.long ".note" # name
.align 4
.long start
# XXX: End FIXME

.text					# start of the text (code) section
.align 4				# the code must be 4 byte aligned
	.long MAGIC			# write the magic number,
	.long FLAGS			# the flags,
	.long CHECKSUM			# and the checksum

start:					# the entry label in linker script
	mov $0x12DABB1E, %eax		# contant to %EAX

.loop:
	jmp .loop			# loop forever
