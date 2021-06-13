SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4

STDIN equ 0
STDOUT equ 1

section .data
    inputMsg db 'Masukkan nomor pilihan : '
    lenInputMsg equ $ - inputMsg

    kertas db '1. kertas', 0xa
    lenKertas equ $ - kertas
    
    gunting db '2. gunting', 0xa
    lenGunting equ $ - gunting

    batu db '3. batu', 0xa
    lenBatu equ $ - batu

    exitMsg db '9. exit', 0xa
    lenExitMsg equ $ - exitMsg

section .text
    global _start

_start:



exit:
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80