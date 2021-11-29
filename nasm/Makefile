all:
	nasm -f elf -l main.lst main.asm
	ld -m elf_i386 main.o -o main
	rm main.o
clean:
	rm main main.lst

