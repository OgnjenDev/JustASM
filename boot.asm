; boot.asm - tries int13 then falls back to jump
[BITS 16]
[ORG 0x7C00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; save drive
    mov byte [boot_drive], dl

    mov si, boot_msg
    call print_string

    ; set ES:BX to 0x0000:0x7E00 (where kernel will be loaded)
    xor ax, ax
    mov es, ax
    mov bx, 0x7E00

    ; number of sectors to read (adjust if kernel bigger)
    mov al, [kernel_sectors]
    cmp al, 0
    je .jump_kernel

    mov ah, 0x02        ; BIOS read sectors
    mov ch, 0x00
    mov cl, 0x02        ; start sector = 2 (boot is sector 1)
    mov dh, 0x00
    mov dl, [boot_drive]
    int 0x13
    jc .read_failed

    ; success
    mov si, ok_msg
    call print_string
    jmp 0x0000:0x7E00

.read_failed:
    mov si, fail_msg
    call print_string
    ; fallthrough to jump anyway (useful when kernel appended)
.jump_kernel:
    jmp 0x0000:0x7E00

; print string (SI -> zero-terminated)
print_string:
    lodsb
    or al, al
    jz .ps_done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.ps_done:
    ret

boot_drive     db 0
kernel_sectors db 16          ; SET: koliko sektora kernel.bin zauzima (1 sektor = 512B)
boot_msg       db "JustASM Bootloader v1.0",13,10,0
ok_msg         db "Kernel read OK. Jumping...",13,10,0
fail_msg       db "Disk read failed (BIOS). Jumping anyway...",13,10,0

times 510 - ($ - $$) db 0
dw 0xAA55
