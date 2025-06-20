.386 
.MODEL flat, stdcall
.STACK
INCLUDE D:/Irvine/Irvine32.inc
INCLUDELIB D:/Irvine/Irvine32.lib

.data
tic BYTE "TIC TAC TOE GAME",0
player BYTE "PLAYER 1 (X) : PLAYER 2 (O)",0
myarray1 BYTE '1' , ' ' , '|' , ' ' , '2' , ' ' , '|' ,' ' ,'3'
myarray2 BYTE '4' , ' ' , '|' , ' ' , '5' , ' ' , '|' ,' ' ,'6'
myarray3 BYTE '7',  ' ' , '|' , ' ' , '8' , ' ' , '|' ,' ' ,'9'
choise BYTE ?                  ; current symbol 'X' or 'O'
player1 BYTE "Player 1 select your position: ",0
player2 BYTE "Player 2 select your position: ",0
winnerX BYTE "Player 1 (X) wins!",0
winnerO BYTE "Player 2 (O) wins!",0
drawMsg BYTE "It's a Draw!",0
info BYTE ?
turn BYTE 1                   ; start with Player 1
moves BYTE 0                 ; track total moves

.code 
main PROC
game_loop:
    call clrscr
    call BOARD
    call GAME
    call CHECKWIN
    cmp al, 1
    je Xwins
    cmp al, 2
    je Owins

    ; Check for draw (9 moves)
    mov al, moves
    cmp al, 9
    jne game_loop
    ; If 9 moves and no winner
    call clrscr
    call BOARD
    mov edx, OFFSET drawMsg
    call writestring
    call crlf
    jmp endProgram

Xwins:
    call clrscr
    call BOARD
    mov edx, OFFSET winnerX
    call writestring
    call crlf
    jmp endProgram

Owins:
    call clrscr
    call BOARD
    mov edx, OFFSET winnerO
    call writestring
    call crlf

endProgram:
    exit
main ENDP

; ========== DISPLAY BOARD ==========
BOARD PROC
    mov edx, OFFSET tic
    call writestring
    call crlf
    call crlf

    mov edx, OFFSET player
    call writestring
    call crlf
    call crlf

    ; Display myarray1
    mov ecx, LENGTHOF myarray1
    mov esi, OFFSET myarray1
L1:
    mov al, [esi]
    call writechar
    inc esi
    loop L1
    call crlf

    ; Display myarray2
    mov ecx, LENGTHOF myarray2
    mov esi, OFFSET myarray2
L2:
    mov al, [esi]
    call writechar
    inc esi
    loop L2
    call crlf

    ; Display myarray3
    mov ecx, LENGTHOF myarray3
    mov esi, OFFSET myarray3
L3:
    mov al, [esi]
    call writechar
    inc esi
    loop L3
    call crlf
    call crlf

    ret
BOARD ENDP

; ========== GAME LOGIC ==========
GAME PROC
try_input:
    cmp turn, 1
    je player1_turn
    mov edx, OFFSET player2
    mov al, 'O'
    mov choise, al
    mov turn, 1
    jmp show_prompt

player1_turn:
    mov edx, OFFSET player1
    mov al, 'X'
    mov choise, al
    mov turn, 2

show_prompt:
    call writestring
    call crlf
    call readint
    movzx eax, ax
    mov info, al

    ; Check if valid (1–9)
    cmp info, 1
    je one
    cmp info, 2
    je two
    cmp info, 3
    je three
    cmp info, 4
    je four
    cmp info, 5
    je five
    cmp info, 6
    je six
    cmp info, 7
    je seven
    cmp info, 8
    je eight
    cmp info, 9
    je nine
    jmp try_input

; For each cell, check if already taken. If yes, retry input.
one:
    cmp [myarray1], '1'
    jne try_input
    mov al, choise
    mov [myarray1], al
    jmp done

two:
    cmp [myarray1+4], '2'
    jne try_input
    mov al, choise
    mov [myarray1+4], al
    jmp done

three:
    cmp [myarray1+8], '3'
    jne try_input
    mov al, choise
    mov [myarray1+8], al
    jmp done

four:
    cmp [myarray2], '4'
    jne try_input
    mov al, choise
    mov [myarray2], al
    jmp done

five:
    cmp [myarray2+4], '5'
    jne try_input
    mov al, choise
    mov [myarray2+4], al
    jmp done

six:
    cmp [myarray2+8], '6'
    jne try_input
    mov al, choise
    mov [myarray2+8], al
    jmp done

seven:
    cmp [myarray3], '7'
    jne try_input
    mov al, choise
    mov [myarray3], al
    jmp done

eight:
    cmp [myarray3+4], '8'
    jne try_input
    mov al, choise
    mov [myarray3+4], al
    jmp done

nine:
    cmp [myarray3+8], '9'
    jne try_input
    mov al, choise
    mov [myarray3+8], al

done:
    inc moves
    ret
GAME ENDP

; ========== WINNING CONDITION ==========
CHECKWIN PROC
    ; Horizontal lines
    mov al, [myarray1]
    cmp al, [myarray1+4]
    jne check2
    cmp al, [myarray1+8]
    jne check2
    jmp declare

check2:
    mov al, [myarray2]
    cmp al, [myarray2+4]
    jne check3
    cmp al, [myarray2+8]
    jne check3
    jmp declare

check3:
    mov al, [myarray3]
    cmp al, [myarray3+4]
    jne check4
    cmp al, [myarray3+8]
    jne check4
    jmp declare

; Vertical lines
check4:
    mov al, [myarray1]
    cmp al, [myarray2]
    jne check5
    cmp al, [myarray3]
    jne check5
    jmp declare

check5:
    mov al, [myarray1+4]
    cmp al, [myarray2+4]
    jne check6
    cmp al, [myarray3+4]
    jne check6
    jmp declare

check6:
    mov al, [myarray1+8]
    cmp al, [myarray2+8]
    jne check7
    cmp al, [myarray3+8]
    jne check7
    jmp declare

; Diagonals
check7:
    mov al, [myarray1]
    cmp al, [myarray2+4]
    jne check8
    cmp al, [myarray3+8]
    jne check8
    jmp declare

check8:
    mov al, [myarray1+8]
    cmp al, [myarray2+4]
    jne nowinner
    cmp al, [myarray3]
    jne nowinner
    jmp declare

declare:
    cmp al, 'X'
    je retX
    cmp al, 'O'
    je retO

nowinner:
    mov al, 0
    ret

retX:
    mov al, 1
    ret

retO:
    mov al, 2
    ret

CHECKWIN ENDP

END main
