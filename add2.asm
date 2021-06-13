SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4

STDIN equ 0
STDOUT equ 1

section .data
    firstMsg db 'First Number : '
    lenfirstMsg equ $ - firstMsg
    secondMsg db 'Second Number : '
    lensecondMsg equ $ - secondMsg

section .bss
    num1 resb 2
    num2 resb 2
    res resb 2

section .text
    global _start

_start:
    ; input first number
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, firstMsg
    mov edx, lenfirstMsg
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num1
    mov edx, 2
    int 0x80

    ; input second number
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, secondMsg
    mov edx, lensecondMsg
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num2
    mov edx, 2
    int 0x80

    mov eax, [num1]
    sub eax, '0'

    mov ebx, [num2]
    sub ebx, '0'

    add eax, ebx

    mov ecx, 

    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80