/*
 * Copyright (C) 2020 Ruigang Wan <rgwan@nucleisys.com>
 * Copyright (C) 2020 Nuclei System Technologies
 */

.global _start
.section .text
_start:
	/* configure nuspi to maximum speed */
	la t0, 0x10014000
	la t1, 0x01
	sw t1, 0(t0)

    /* move _copy_data() to ITCM region */
	li t0, 0x80000000
	la t1, _copy_data
	la t2, _copy_data + 4 * 8
	call _copy_data

	/* move data from NOR to DDR */
	li t0, 0xa0000000
	la t1, sbi
	la t2, _end_sbi

	/* call faraway function */
	li t3, 0x80000000
	//call _copy_data
	jalr ra, t3, 0


	li t0, 0xa0200000
	la t1, uboot
	la t2, _end_uboot

	/* call faraway function */
	li t3, 0x80000000
	//call _copy_data
	jalr ra, t3, 0

	/* Goto DDR region */
	fence
	fence.i
	sfence.vma

	li t0, 0xa0000000
	jr t0

_deadloop:
	j .


/* copy_data(void *dst, void *src, void *end) */
.align 4

_copy_data:
_loop:
	ld t3, 0(t1)
	sd t3, 0(t0)
	addi t0, t0, 8
	addi t1, t1, 8
	blt t1, t2, _loop

	ret

.section .sbipayload
.global sbi
.type sbi, @object
sbi:
.incbin "fw_jump.bin"


.section .ubootpayload
.global uboot
.type uboot, @object
uboot:
.incbin "u-boot.bin"


