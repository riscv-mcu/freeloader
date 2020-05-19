ARCH ?= rv64imac
ABI ?= lp64
FW_JUMP_BIN ?= ../opensbi/build/platform/nuclei/ux600/firmware/fw_jump.bin
UBOOT_BIN ?= ../u-boot/u-boot.bin
DTB ?= ../u-boot/u-boot.dtb
CROSS_COMPILE ?= riscv-nuclei-elf-

all: freeloader.bin freeloader.dis

freeloader: u-boot.bin fw_jump.bin  linker.lds freeloader.S fdt.dtb

u-boot.bin: $(UBOOT_BIN)
	cp $< .

fw_jump.bin: $(FW_JUMP_BIN)
	cp $< .

fdt.dtb: $(DTB)
	cp $< ./$@

freeloader: u-boot.bin fw_jump.bin  linker.lds freeloader.S
	$(CROSS_COMPILE)gcc -march=$(ARCH) -mabi=$(ABI) freeloader.S -o freeloader -nostartfiles -Tlinker.lds -g

freeloader.bin: freeloader
	$(CROSS_COMPILE)objcopy freeloader -O binary freeloader.bin

freeloader.dis: freeloader
	$(CROSS_COMPILE)objdump -d freeloader > freeloader.dis

.PHONY: clean all

clean:
	rm -f *.bin
	rm -f freeloader.bin
	rm -f freeloader
	rm -f *.dtb
