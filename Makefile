all: justasm.img

kernel.bin: kernel.asm
        nasm -f bin kernel.asm -o kernel.bin

boot.bin: boot.asm kernel.bin
        nasm -f bin -D KSECT=3 boot.asm -o boot.bin

justasm.img: boot.bin kernel.bin
        cat boot.bin kernel.bin > justasm.img
        @ls -l boot.bin kernel.bin justasm.img

clean:
        rm -f boot.bin kernel.bin justasm.img
