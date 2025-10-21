# JustASM OS - Kernel v1.0

JustASM is a small, educational operating system written entirely in x86 assembly.  
This repository contains the **kernel** and a minimal **bootloader** that allows you to run JustASM in a virtual machine or emulator.

---

## Features (v1.0)

- Bootable kernel with a simple command-line interface (CLI)
- Commands:
  - `ls` - list available files
  - `time` - display current (fake) time
  - `about` - show information about the OS
  - `ver` - show the OS version
  - `hello` - display a welcome message
  - `help` - display all commands
  - `clear` - clear the screen
- Fully written in 16-bit x86 assembly
- Compatible with real-mode emulators (Bochs, QEMU, VirtualBox)
- Bootable as a 512B binary image

---

## Getting Started

### Requirements

- NASM assembler
- A virtual machine or emulator (e.g., QEMU, Bochs, VirtualBox)

### Build

```bash
make all
```

This will generate:

boot.bin - the bootloader binary

kernel.bin - the kernel binary

justasm.img - bootable image containing both bootloader and kernel


Run

Using QEMU:

qemu-system-i386 -fda justasm.img

Using Bochs:

bochs -f bochsrc.txt


---

File Structure

justasm/
├── boot.asm       # Bootloader
├── kernel.asm     # Kernel code
├── build.sh       # Build script
├── justasm.img    # Bootable image (generated)
└── README.md


---

Contributing

JustASM is in its first public version. Contributions, bug reports, and feature suggestions are welcome.
If you want a new command or feature, open an issue or submit a pull request.


---

License

This project is released under the GNU License.
