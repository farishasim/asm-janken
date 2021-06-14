SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
SYS_OPEN    equ 5
SYS_CLOSE   equ 6
SYS_TIME    equ 13

READ_ONLY   equ 0
WRITE_ONLY  equ 1
READ_WRITE  equ 2

STDIN       equ 0
STDOUT      equ 1

section .data
    greeting    db "Hello, let's play the game!", 0xa, 0xa
    lengreet    equ $ - greeting

    rules       db 'You need to reach 9 points to win the game.', 0xa, 0xa
    lenRules    equ $ - rules

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

    loadMsg     db '7. load', 0xa
    lenLoad     equ $ - loadMsg

    saveMsg     db '8. save', 0xa
    lenSave     equ $ - saveMsg

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

    winner      db 'Congratulations, You win the game!', 0xa, 0xa
    len_winner  equ $ - winner

    loser       db 'You lose the game. Bye!', 0xa, 0xa
    len_loser   equ $ - loser

    filename    db 'temp.txt'
    lenFile     equ $ - filename

section .bss
    p_choice    resd 1  ; player choice
    c_choice    resd 1  ; computer choice

    p_count     resd 1  ; player win counter
    c_count     resd 1  ; computer win counter

    bufferIn    resb 2

    somechar    resd 1

    fd          resb 1

section .text
    global _start

_start:
    call    newLine
    mov     ecx, greeting
    mov     edx, lengreet
    call    printMsg
    call    readEnter

    mov     ecx, rules
    mov     edx, lenRules
    call    printMsg
    call    readEnter

    mov     dword [p_count], '0'
    mov     dword [c_count], '0'

    mov     byte [c_choice], '2'

    lmain:
        call    random
        mov     [c_choice], eax
        call    printMenu

        mov     ecx, [p_choice]
        cmp     ecx, '9'
        je      exit

        cmp     ecx, '8'
        je      saveGame

        cmp     ecx, '7'
        je      loadGame

        call    cmpChoice

        cmp     dword [p_count], '9'
        je      win_game

        cmp     dword [c_count], '9'
        je      lose_game

        jmp     lmain

win_game:
    mov     ecx, winner
    mov     edx, len_winner
    call    printMsg
    call    newLine
    jmp     exit

lose_game:
    mov     ecx, loser
    mov     edx, len_loser
    call    printMsg
    call    newLine

exit:
    mov     eax, SYS_EXIT
    mov     ebx, 0
    int     0x80

saveGame:
    mov     eax, SYS_OPEN
    mov     ebx, filename
    mov     ecx, WRITE_ONLY
    mov     edx, 0x777
    int     0x80

    mov     [fd], eax

    mov     ebx, [fd]
    mov     eax, SYS_WRITE
    mov     ecx, p_count
    mov     edx, 1
    int     0x80

    mov     ebx, [fd]
    mov     eax, SYS_WRITE
    mov     ecx, c_count
    mov     edx, 1
    int     0x80

    mov     eax, SYS_CLOSE
    mov     ebx, [fd]
    int     0x80

    jmp     lmain

loadGame:
    mov     eax, SYS_OPEN
    mov     ebx, filename
    mov     ecx, READ_ONLY
    mov     edx, 0x777
    int     0x80

    mov     [fd], eax

    mov     ebx, [fd]
    mov     eax, SYS_READ
    mov     ecx, bufferIn
    mov     edx, 2
    int     0x80

    xor     eax, eax
    mov     al, byte [bufferIn]
    mov     dword [p_count], eax
    mov     al, byte [bufferIn + 1]
    mov     dword [c_count], eax

    mov     eax, SYS_CLOSE
    mov     ebx, [fd]
    int     0x80

    jmp     lmain

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

    mov     ecx, loadMsg
    mov     edx, lenLoad
    call    printMsg

    mov     ecx, saveMsg
    mov     edx, lenSave
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
    jmp     l3    
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

random:
    mov     ebx, somechar
    mov     eax, SYS_TIME
    int     0x80

    mov     eax, [ebx]
    mov     ebx, 3
    div     ebx
    add     edx, '1'

    mov     eax, edx
    ret