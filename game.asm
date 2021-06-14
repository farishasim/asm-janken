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

    invalidMsg  db '!!! INVALID !!!', 0xa
    lenInvalid  equ $ - invalidMsg

    winMsg      db '$$$$$$$$$$$$$$', 0xa, '$  YOU  WIN  $', 0xa, '$$$$$$$$$$$$$$', 0xa
    lenWin      equ $ - winMsg

    drawMsg     db '##############', 0xa, '#  YOU DRAW  #', 0xa, '##############', 0xa
    lenDraw     equ $ - drawMsg

    loseMsg     db '%%%%%%%%%%%%%%', 0xa, '%  YOU LOSE  %', 0xa, '%%%%%%%%%%%%%%', 0xa
    lenLose     equ $ - loseMsg

section .bss
    p_choice    resb 1  ; player choice
    c_choice    resb 1  ; computer choice

    p_count     resw 1  ; player win counter
    c_count     resw 1  ; computer win counter

section .text
    global _start

_start:
    mov     [p_count], 0
    mov     [c_count], 0

    mov     ecx, winMsg
    mov     edx, lenWin
    call    printMsg

lmain:
    call    printMenu

    mov     ecx, p_choice
    mov     edx, 1
    call    printMsg
    call    newLine

    mov     ecx, [p_choice]
    cmp     ecx, '9'
    jne     lmain

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

    mov     ecx, exitMsg
    mov     edx, lenExitMsg
    call    printMsg
    
    call    newLine

    mov     ecx, inputMsg
    mov     edx, lenInputMsg
    call    printMsg

    mov     ecx, p_choice
    mov     edx, 1
    call    readInput

    mov     ecx, newline
    call    readInput

    ret

; void cmpChoice()
cmpChoice:
    cmp     eax, '1'
    je      kertasChoice
    cmp     eax, '2'
    je      guntingChoice
    cmp     eax, '3'
    je      batuChoice

    mov     ecx, invalidMsg
    mov     edx, lenInvalid
    jmp     returnChoice

kertasChoice:
    cmp     ebx, '2'
    je      lose
    cmp     ebx, '3'
    je      win
    jmp     draw    

guntingChoice:
    cmp     ebx, '3'
    je      lose
    cmp     ebx, '1'
    je      win
    jmp     draw

batuChoice:
    cmp     ebx, '1'
    je      lose
    cmp     ebx, '2'
    je      win
    jmp     draw

lose:
    inc     word [c_count]
    mov     ecx, loseMsg
    mov     edx, lenLose
    jmp     returnChoice

win:
    inc     word [p_count]
    mov     ecx, winMsg
    mov     edx, lenWin
    jmp     returnChoice

draw:
    mov     ecx, drawMsg
    mov     edx, lenDraw

returnChoice:
    call    printMsg
    call    newLine
    ret