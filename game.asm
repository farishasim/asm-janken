SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4

STDIN       equ 0
STDOUT      equ 1

section .data
    inputMsg    db 'Masukkan nomor pilihan : '
    lenInputMsg equ $ - inputMsg

    kertas      db '1. kertas', 0xa
    lenKertas   equ $ - kertas
    
    gunting     db '2. gunting', 0xa
    lenGunting  equ $ - gunting

    batu        db '3. batu', 0xa
    lenBatu     equ $ - batu

    exitMsg     db '9. exit', 0xa
    lenExitMsg  equ $ - exitMsg

    newline     db 0xa

section .bss
    p_choice    resb 1  ; player choice
    c_choice    resb 1  ; computer choice

    p_count     resw 1  ; player win counter
    c_count     resw 1  ; computer win counter

section .text
    global _start

_start:
    call    printMenu

    mov     ecx, p_choice
    mov     edx, 1
    call    printMsg
    call    newLine

exit:
    mov     eax, SYS_EXIT
    mov     ebx, 0
    int     0x80

printMsg:
    mov     eax, SYS_WRITE
    mov     ebx, STDOUT
    int     0x80
    ret

newLine:
    mov     ecx, newline
    mov     edx, 1
    call    printMsg
    ret

readInput:
    mov     eax, SYS_READ
    mov     ebx, STDIN
    int     0x80
    ret

printMenu:
    mov     ecx, kertas
    mov     edx, lenKertas
    call    printMsg

    mov     ecx, gunting
    mov     edx, lenGunting
    call    printMsg

    mov     ecx, batu
    mov     edx, lenBatu
    call    printMsg
    
    call    newLine

    mov     ecx, inputMsg
    mov     edx, lenInputMsg
    call    printMsg

    mov     ecx, p_choice
    mov     edx, 1
    call    readInput

    ret