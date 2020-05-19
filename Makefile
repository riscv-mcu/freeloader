all: freeloader.bin freeloader.dis

u-boot.bin: ../u-boot/u-boot.bin
	cp ../u-boot/u-boot.bin ./u-boot.bin

fw_jump.bin: ../opensbi/build/platform/nuclei/ux600/firmware/fw_jump.bin
	cp ../opensbi/build/platform/nuclei/ux600/firmware/fw_jump.bin .

fdt.dtb: ../u-boot/u-boot.dtb
	cp ../u-boot/u-boot.dtb ./fdt.dtb

freeloader: u-boot.bin fw_jump.bin  linker.lds freeloader.S fdt.dtb
	riscv-nuclei-elf-gcc -march=rv64imac -mabi=lp64 freeloader.S -o freeloader -nostartfiles -Tlinker.lds -g
freeloader.bin: freeloader
	riscv-nuclei-elf-objcopy freeloader -O binary freeloader.bin

freeloader.dis: freeloader
	riscv-nuclei-elf-objdump -d freeloader > freeloader.dis
.PHONY: clean all

clean:
	rm -f *.bin
	rm -f freeloader.bin
	rm -f freeloader
	rm -f *.dtb
