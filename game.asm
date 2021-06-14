SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4

STDIN       equ 0
STDOUT      equ 1

section .data
    greeting    db "Hello, let's play the game!", 0xa, 0xa
    lengreet    equ $ - greeting

    inputMsg    db 'Masukkan nomor pilihan : '
    lenInputMsg equ $ - inputMsg

    enterMsg    db '(Tekan "enter" untuk melanjutkan)', 0xa
    lenEnter    equ $ - enterMsg

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

    playerSts   db "Player wins : "
    lenPStat    equ $ - playerSts

    compSts     db "Computer wins : "
    lenCStat    equ $ - compSts

    word_1      db 'kertas'
    len_1       equ $ - word_1

    word_2      db 'gunting'
    len_2       equ $ - word_2

    word_3      db 'batu'
    len_3       equ $ - word_3

    versus      db ' vs. '
    len_v       equ $ - versus

section .bss
    p_choice    resd 1  ; player choice
    c_choice    resd 1  ; computer choice

    p_count     resd 1  ; player win counter
    c_count     resd 1  ; computer win counter

    somechar    resd 1

section .text
    global _start

_start:
    call    newLine
    mov     ecx, greeting
    mov     edx, lengreet
    call    printMsg
    call    readEnter

    mov     byte [p_count], '0'
    mov     byte [c_count], '0'

    mov     byte [c_choice], '2'

lmain:
    call    printMenu

    mov     ecx, [p_choice]
    cmp     ecx, '9'
    je      exit

    ; mov     ecx, p_choice
    ; mov     edx, 1
    ; call    printMsg

    call    cmpChoice
    jmp     lmain

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

readEnter:
    mov     ecx, enterMsg
    mov     edx, lenEnter
    call    printMsg

    mov     ecx, somechar
    mov     edx, 1
    call    readInput

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

    call    newLine

    ret

printStatus:
    mov     ecx, playerSts
    mov     edx, lenPStat
    call    printMsg

    mov     ecx, p_count
    mov     edx, 2
    call    printMsg
    call    newLine

    mov     ecx, compSts
    mov     edx, lenCStat
    call    printMsg

    mov     ecx, c_count
    mov     edx, 2
    call    printMsg
    call    newLine
    ret

printKertas:
    push    eax
    push    ebx
    push    ecx
    push    edx

    mov     ecx, word_1
    mov     edx, len_1
    call    printMsg

    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    ret

printGunting:
    push    eax
    push    ebx
    push    ecx
    push    edx

    mov     ecx, word_2
    mov     edx, len_2
    call    printMsg

    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    ret

printBatu:
    push    eax
    push    ebx
    push    ecx
    push    edx

    mov     ecx, word_3
    mov     edx, len_3
    call    printMsg

    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    ret

printVersus:
    push    eax
    push    ebx
    push    ecx
    push    edx

    mov     ecx, versus
    mov     edx, len_v
    call    printMsg

    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    ret

; void cmpChoice()
cmpChoice:
    push    eax
    push    ebx
    mov     eax, dword [p_choice]
    mov     ebx, dword [c_choice]

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
    call    printKertas
    call    printVersus
    cmp     ebx, '2'
    je      l1
    cmp     ebx, '3'
    je      l2
    jmp     draw    
l1:
    call    printGunting
    jmp     lose
l2: 
    call    printBatu
    jmp     win
l3:
    call    printKertas
    jmp     draw

guntingChoice:
    call    printGunting
    call    printVersus
    cmp     ebx, '3'
    je      l4
    cmp     ebx, '1'
    je      l5
    jmp     l6
l4:
    call    printBatu
    jmp     lose
l5:
    call    printKertas
    jmp     win
l6:
    call    printGunting
    jmp     draw

batuChoice:
    call    printBatu
    call    printVersus
    cmp     ebx, '1'
    je      l7
    cmp     ebx, '2'
    je      l8
    jmp     l9
l7:
    call    printKertas
    jmp     lose
l8:
    call    printGunting
    jmp     win
l9:
    call    printBatu
    jmp     draw

lose:
    call    newLine
    call    newLine
    inc     dword [c_count]
    mov     ecx, loseMsg
    mov     edx, lenLose
    jmp     returnChoice

win:
    call    newLine
    call    newLine
    inc     dword [p_count]
    mov     ecx, winMsg
    mov     edx, lenWin
    jmp     returnChoice

draw:
    call    newLine
    call    newLine
    mov     ecx, drawMsg
    mov     edx, lenDraw

returnChoice:
    call    printMsg
    call    newLine
    
    call    printStatus
    call    newLine

    call    readEnter

    pop     ebx
    pop     eax
    ret