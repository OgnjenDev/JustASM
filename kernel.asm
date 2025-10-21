; kernel.asm - JustASM kernel
[BITS 16]
[ORG 0x7E00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov si, km_welcome
    call k_print

main_loop:
    mov si, k_prompt
    call k_print
    call k_read_command
    call k_handle_command
    jmp main_loop

; ---------- print string ----------
k_print:
    lodsb
    or al, al
    jz .kp_done
    mov ah, 0x0E
    int 0x10
    jmp k_print
.kp_done:
    ret

; ---------- read command ----------
k_read_command:
    mov di, cmd_buf
.kr_loop:
    mov ah, 0
    int 0x16
    cmp al, 13
    je .kr_done
    cmp al, 8
    je .kr_back
    stosb
    mov ah, 0x0E
    int 0x10
    jmp .kr_loop

.kr_back:
    cmp di, cmd_buf
    jbe .kr_loop
    dec di
    mov ah,0x0E
    mov al,8
    int 0x10
    mov al,' '
    int 0x10
    mov al,8
    int 0x10
    jmp .kr_loop

.kr_done:
    mov byte [di],0
    mov ah,0x0E
    mov al,13
    int 0x10
    mov al,10
    int 0x10
    ret

; ---------- strcmp ----------
k_strcmp:
    push si
    push di
.ks_loop:
    lodsb
    mov bl,[di]
    cmp al,bl
    jne .ks_not
    or al, al
    jz .ks_yes
    inc di
    jmp .ks_loop
.ks_yes:
    mov al,1
    pop di
    pop si
    ret
.ks_not:
    xor al,al
    pop di
    pop si
    ret

; ---------- handle commands ----------
k_handle_command:
    mov si, cmd_buf

    mov di, kw_ls
    call k_strcmp
    cmp al,1
    je .do_ls

    mov si, cmd_buf
    mov di, kw_time
    call k_strcmp
    cmp al,1
    je .do_time

    mov si, cmd_buf
    mov di, kw_about
    call k_strcmp
    cmp al,1
    je .do_about

    mov si, cmd_buf
    mov di, kw_ver
    call k_strcmp
    cmp al,1
    je .do_ver

    mov si, cmd_buf
    mov di, kw_hello
    call k_strcmp
    cmp al,1
    je .do_hello

    mov si, cmd_buf
    mov di, kw_help
    call k_strcmp
    cmp al,1
    je .do_help

    mov si, cmd_buf
    mov di, kw_clear
    call k_strcmp
    cmp al,1
    je .do_clear

    mov si, k_unknown
    call k_print
    ret

.do_ls:
    mov si, k_ls1
    call k_print
    mov si, k_ls2
    call k_print
    ret

.do_time:
    mov si, k_time_msg
    call k_print
    ret

.do_about:
    mov si, k_about1
    call k_print
    mov si, k_about2
    call k_print
    ret

.do_ver:
    mov si, k_ver
    call k_print
    ret

.do_hello:
    mov si, k_hello_msg
    call k_print
    ret

.do_help:
    mov si, k_help
    call k_print
    ret

.do_clear:
    mov ah, 0x06
    mov al, 0
    mov bh, 0x07
    mov cx, 0
    mov dx, 184Fh
    int 0x10
    ret

; ---------- data ----------
km_welcome db "JustASM Kernel ready",13,10,0
k_prompt   db "> ",0
cmd_buf    times 128 db 0

kw_ls     db "ls",0
kw_time   db "time",0
kw_about  db "about",0
kw_ver    db "ver",0
kw_hello  db "hello",0
kw_help   db "help",0
kw_clear  db "clear",0

k_ls1     db "boot.bin",13,10,0
k_ls2     db "kernel.bin",13,10,0
k_time_msg db "Current time: 12:34",13,10,0
k_about1  db "OS: JustASM",13,10,0
k_about2  db "Author: User",13,10,0
k_ver     db "JustASM v1.0",13,10,0
k_hello_msg db "Hello, User thank you for using JustASM",13,10,0
k_help    db "Commands: ls, time, about, ver, hello, help, clear",13,10,0
k_unknown db "Unknown command",13,10,0

times 2048 - ($ - $$) db 0
dw 0xAA55
