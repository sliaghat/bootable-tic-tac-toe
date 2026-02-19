; ------------------------------------------------------------------------------------------------------ ;
; ------------------------------------------------ Header ---------------------------------------------- ;
; ------------------------------------------------------------------------------------------------------ ;

global kernel_main
BITS 32

; ------------------------------------------------------------------------------------------------------ ;
; ---------------------------------------------- Constants --------------------------------------------- ;
; ------------------------------------------------------------------------------------------------------ ;

VGA_WIDTH equ 80
VGA_HEIGHT equ 25

VGA_COLOR_BLACK equ 0
VGA_COLOR_BLUE equ 1
VGA_COLOR_GREEN equ 2
VGA_COLOR_CYAN equ 3
VGA_COLOR_RED equ 4
VGA_COLOR_MAGENTA equ 5
VGA_COLOR_BROWN equ 6
VGA_COLOR_LIGHT_GREY equ 7
VGA_COLOR_DARK_GREY equ 8
VGA_COLOR_LIGHT_BLUE equ 9
VGA_COLOR_LIGHT_GREEN equ 10
VGA_COLOR_LIGHT_CYAN equ 11
VGA_COLOR_LIGHT_RED equ 12
VGA_COLOR_LIGHT_MAGENTA equ 13
VGA_COLOR_LIGHT_BROWN equ 14
VGA_COLOR_WHITE equ 15

xwin equ 3 * 'X'
owin equ 3 * 'O'

INF  equ 10000

; ------------------------------------------------------------------------------------------------------ ;
; --------------------------------------------- Variables ---------------------------------------------- ;
; ------------------------------------------------------------------------------------------------------ ;

section .data

introduction db "##########################################", 0xA
	     db "#                                        #", 0xA
       db "#           <Assembly Project>           #", 0xA
	     db "#                                        #", 0xA
	     db "#         <Bootable Tic-Tac-Toe>         #", 0xA
	     db "#                                        #", 0xA
	     db "#  <Parmida Hooshang> && <Sina Liaghat>  #", 0xA
	     db "#                                        #", 0xA
	     db "#      <40231980>    &&    <40232000>    #", 0xA
	     db "#                                        #", 0xA
	     db "##########################################", 0xA, 0xA, 0

intro_prompt db "Press the space key to continue: ", 0

char_description db "###########################################", 0xA
	       db "#                                         #", 0xA
	    	 db "# Welcome to the Tic-Tac-Toe Arena!       #", 0xA
	    	 db "#                                         #", 0xA
	    	 db "# Are you ready to make your mark?        #", 0xA
	    	 db "# Choose your champion:                   #", 0xA
	    	 db "#                                         #", 0xA
	    	 db "#    X - The fearless warrior!            #", 0xA
	    	 db "#    O - The mystical circle!             #", 0xA
	    	 db "#                                         #", 0xA
	    	 db "###########################################", 0xA, 0xA, 0

char_prompt db "Enter your champion (x or o): ", 0

display_board db "################## ARENA ##################", 0xA
        db "#                                         #", 0xA
	      db "#                                         #", 0xA
	      db "#                  |   |                  #", 0xA
	      db "#               -----------               #", 0xA
	      db "#                  |   |                  #", 0xA
	      db "#               -----------               #", 0xA
	      db "#                  |   |                  #", 0xA
	      db "#                                         #", 0xA
	      db "#                                         #", 0xA
	      db "###########################################", 0xA, 0xA, 0

move_prompt db "Which magic number (1-9) will you summon for your next move? ", 0

ai_move_prompt db "Don't blink! The AI is about to outsmart you! Tap space: ", 0

tie_msg db "Neither of us could claim victory this time!", 0xA
        db "But don't get too comfortable.", 0xA 
        db "I'm sharpening my skills for our next encounter!", 0xA
	db "Press 1 for rematch or 2 for exit: ", 0

ai_win_msg db "I'm sorry, but your moves were... adorable. Try harder next time :)", 0xA
	   db "Press 1 for rematch or 2 for exit: ", 0

cell_idx   dd 149, 153, 157, 237, 241, 245, 325, 329, 333

board   db  '_', '_', '_'
        db  '_', '_', '_'
        db  '_', '_', '_'

new_scr db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0xA
	db  "                                                                                ", 0

terminal_color db 0
terminal_cursor_pos:
terminal_column db 0
terminal_row db 0


; ------------------------------------------------------------------------------------------------------ ;
; ------------------------------------------------ Main ------------------------------------------------ ;
; ------------------------------------------------------------------------------------------------------ ;

section .text

kernel_main:

	
    ; Print Introduction
    xor    edx, edx
    mov	   dh, VGA_COLOR_CYAN
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, introduction
    call   terminal_write_string

    ; Print Intro Prompt
    xor    edx, edx
    mov	   dh, VGA_COLOR_LIGHT_GREEN
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, intro_prompt
    call   terminal_write_string
    
    
    ; Scan answer
    call   scan_any

.menu:
    call   halt
    
    ; Clear screen
    call   clear_screen

    call   clear_board
    
    ; Print Description
    xor    edx, edx
    mov	   dh, VGA_COLOR_CYAN
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, char_description
    call   terminal_write_string

    ; Print Char Prompt
    xor    edx, edx
    mov	   dh, VGA_COLOR_LIGHT_GREEN
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, char_prompt
    call   terminal_write_string

    ; Scan answer
    call   scan_char

    cmp	   al, 1
    jne	   .ocase

.xcase:
    call   halt
    
    ; Clear screen
    call   clear_screen
    
    ; Print Board
    call   print_board

    ; Check Status
    call   get_status
    cmp    eax, 'O'
    je	   .endgame_w
    cmp    eax, 'T'
    je     .endgame_t

    ; Print Move Prompt
    xor    edx, edx
    mov	   dh, VGA_COLOR_LIGHT_GREEN
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, move_prompt
    call   terminal_write_string

    ; Scan answer
    call   scan_move
    call   halt
    
    ; Apply move
    mov	   ebx, 'X'
    push   ebx
    push   eax
    call   make_move
    add    esp, 8
    
    ; Clear screen
    call   clear_screen
    
    ; Print Board
    call   print_board

    ; Check Status
    call   get_status
    cmp    eax, 'O'
    je	   .endgame_w
    cmp    eax, 'T'
    je     .endgame_t

    ; Print AI Move Prompt
    xor    edx, edx
    mov	   dh, VGA_COLOR_LIGHT_GREEN
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, ai_move_prompt
    call   terminal_write_string

    ; Scan answer
    call   scan_any

    ; AI Move
    mov	   ebx, 'O'
    push   ebx
    call   find_best_move
    add    esp, 4
	
    
    ; Apply move
    mov	   ebx, 'O'
    push   ebx
    sub    edx, board - 1
    push   edx
    call   make_move
    add    esp, 8
    
    jmp    .xcase


.ocase:
    call   halt
    
    ; Clear screen
    call   clear_screen
    
    ; Print Board
    call   print_board

    ; Check Status
    call   get_status
    cmp    eax, 'X'
    je	   .endgame_w
    cmp    eax, 'T'
    je     .endgame_t

    ; Print AI Move Prompt
    xor    edx, edx
    mov	   dh, VGA_COLOR_LIGHT_GREEN
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, ai_move_prompt
    call   terminal_write_string

    ; Scan answer
    call   scan_any

    ; AI Move
    mov	   ebx, 'X'
    push   ebx
    call   find_best_move
    add    esp, 4
    
    ; Apply move
    mov	   ebx, 'X'
    push   ebx
    sub    edx, board - 1
    push   edx
    call   make_move
    add    esp, 8

    ; Clear screen
    call   clear_screen
    
    ; Print Board
    call   print_board

    ; Check Status
    call   get_status
    cmp    eax, 'X'
    je	   .endgame_w
    cmp    eax, 'T'
    je     .endgame_t

    ; Print Move Prompt
    xor    edx, edx
    mov	   dh, VGA_COLOR_LIGHT_GREEN
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, move_prompt
    call   terminal_write_string

    ; Scan answer
    call   scan_move
    
    ; Apply move
    mov	   ebx, 'O'
    push   ebx
    push   eax
    call   make_move
    add    esp, 8

    jmp    .ocase


.endgame_w:
    ; Print AI Win Message
    xor    edx, edx
    mov	   dh, VGA_COLOR_LIGHT_RED
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, ai_win_msg
    call   terminal_write_string
    jmp    .game_cont

.endgame_t:
    ; Print Tie Message
    xor    edx, edx
    mov	   dh, VGA_COLOR_LIGHT_RED
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, tie_msg
    call   terminal_write_string

.game_cont:
    
    ; Scan answer
    call   scan_option

    ; Check answer
    cmp    eax, 1
    je     .menu
	
    ; Clear screen
    call   clear_screen

    jmp $


; ------------------------------------------------------------------------------------------------------ ;
; ----------------------------------------------- Output ----------------------------------------------- ;
; ------------------------------------------------------------------------------------------------------ ;

;---------------------------------------------------------------------------------------;
; Procedure: terminal_getidx								;
; Source: OSDev (https://wiki.osdev.org/Bare_Bones_with_NASM) with modification	 	;
;											;
; Input:										;
;   - dl: y										;
;   - dh: x										;
; Output:										;
;   - dx: Index with offset 0xB8000 at VGA buffer					;
;											;
; P.S. Many thanks to Artin Zareie for helping us solve the mysterious problem of 	;
;      this procedure.									;
;---------------------------------------------------------------------------------------;
terminal_getidx:
    push eax
    push ebx
    
    mov ax, VGA_WIDTH
    mul dl
    movzx bx, dh
    add ax, bx
    shl ax, 1
    mov dx, ax
    
    pop ebx
    pop eax
    ret

;---------------------------------------------------------------------------------------;
; Procedure: terminal_set_color								;
; Source: OSDev (https://wiki.osdev.org/Bare_Bones_with_NASM)		 		;
;											;
; Input:										;
;   - dl: bg color									;
;   - dh: fg color									;
;---------------------------------------------------------------------------------------;
terminal_set_color:
    shl dl, 4

    or dl, dh
    mov [terminal_color], dl


    ret

;---------------------------------------------------------------------------------------;
; Procedure: terminal_putentryat							;
; Source: OSDev (https://wiki.osdev.org/Bare_Bones_with_NASM)		 		;
;											;
; Input:										;
;   - dl: y										;
;   - dh: x										;
;   - al: ASCII char									;
;---------------------------------------------------------------------------------------;
terminal_putentryat:
    pusha
    call terminal_getidx
    mov ebx, edx

    mov dl, [terminal_color]
    mov byte [0xB8000 + ebx], al
    mov byte [0xB8001 + ebx], dl


    popa
    ret
    
;---------------------------------------------------------------------------------------;
; Procedure: terminal_putchar								;
; Source: OSDev (https://wiki.osdev.org/Bare_Bones_with_NASM)		 		;
;											;
; Input:										;
;   - al: ASCII char									;
;---------------------------------------------------------------------------------------;
terminal_putchar:
    mov dx, [terminal_cursor_pos] ; This loads terminal_column at DH, and terminal_row at DL

    cmp al, 0xA
    jne .nlf

    mov dh, 0
    inc dl
    jmp .cursor_moved

.nlf:
    call terminal_putentryat
    
    inc dh
    cmp dh, VGA_WIDTH
    jne .cursor_moved

    mov dh, 0
    inc dl

    cmp dl, VGA_HEIGHT
    jne .cursor_moved

    mov dl, 0


.cursor_moved:
    ; Store new cursor position 
    mov [terminal_cursor_pos], dx

    ret

;---------------------------------------------------------------------------------------;
; Procedure: terminal_write								;
; Source: OSDev (https://wiki.osdev.org/Bare_Bones_with_NASM)		 		;
;											;
; Input:										;
;   - cx: length of string								;
;   - ESI: string location								;
;---------------------------------------------------------------------------------------;
terminal_write:
    pusha
.loopy:

    mov al, [esi]
    call terminal_putchar

    dec cx
    cmp cx, 0
    je .done

    inc esi
    jmp .loopy


.done:
    popa
    ret

;---------------------------------------------------------------------------------------;
; Procedure: terminal_strlen								;
; Source: OSDev (https://wiki.osdev.org/Bare_Bones_with_NASM)		 		;
;											;
; Input:										;
;   - ESI: zero delimited string location						;
;   - ESI: string location								;
; Output:										;
;   - ECX: length of string								;
;---------------------------------------------------------------------------------------;
terminal_strlen:
    push eax
    push esi
    mov ecx, 0
.loopy:
    mov al, [esi]
    cmp al, 0
    je .done

    inc esi
    inc ecx

    jmp .loopy


.done:
    pop esi
    pop eax
    ret

;---------------------------------------------------------------------------------------;
; Procedure: terminal_write_string							;
; Source: OSDev (https://wiki.osdev.org/Bare_Bones_with_NASM)		 		;
;											;
; Input:										;
;   - ESI: string location								;
;---------------------------------------------------------------------------------------;
terminal_write_string:
    pusha
    call terminal_strlen
    call terminal_write
    popa
    ret

;---------------------------------------------------------------------------------------;
; Procedure: clear_screen								;
; Purpose: Clears the screen and resets the location of the cursor.			;		
;---------------------------------------------------------------------------------------;
clear_screen:
    push   edx
    push   esi
    
    mov    byte [terminal_column], 0
    mov    byte [terminal_row], 0
    
    mov edx, 0 
    mov	   dh, VGA_COLOR_BLACK
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    mov    esi, new_scr
    call   terminal_write_string
    
    mov    byte [terminal_column], 0
    mov    byte [terminal_row], 0
    
    pop    esi
    pop    edx
    ret
   
;---------------------------------------------------------------------------------------;
; Procedure: clear_board								;
; Purpose: Clears the board and display_board						;		
;---------------------------------------------------------------------------------------;
clear_board:
	push	eax
	push	ecx
	push	esi
	push    edi
	
	mov     eax, cell_idx
	mov	esi, board
	mov	ecx, 9

.clear_cell:
	mov     edi, display_board
	add     edi, dword [eax]
	mov     byte [edi], ' '
	mov     byte [esi], '_'

	add     eax, 4
	inc	esi

	loop	.clear_cell
	
	pop	edi
	pop     esi
	pop	ecx
	pop	eax
	ret
	
;---------------------------------------------------------------------------------------;
; Procedure: print_board								;
; Purpose: Prints display_board								;		
;---------------------------------------------------------------------------------------;
print_board:
    push   edx
    push   esi
    xor    edx, edx
    mov	   dh, VGA_COLOR_CYAN
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    xor    edx, edx
    mov    esi, display_board
    call   terminal_write_string
    pop    esi
    pop    edx
    ret


; ------------------------------------------------------------------------------------------------------ ;
; ----------------------------------------------- Input ------------------------------------------------ ;
; ------------------------------------------------------------------------------------------------------ ;

;---------------------------------------------------------------------------------------;
; Procedure: scan_move									;
; Purpose: Monitors keyboard input to capture a player's move in the Tic-Tac-Toe game.	;
; This function waits for a key press and checks if the corresponding scancode is valid,;
; indicating a move from '1' to '9'. This function also considers the emptiness of the  ;
; selected cell for the move to be valid.						;
;                                          						;
; Input:										;
;   - No parameters. It directly reads from the keyboard input.				;
; Output:										;
;   - Displays the valid move number on the terminal in a specific color.		;
;   - Returns the valid move number in al (one-based).					;
;---------------------------------------------------------------------------------------;
scan_move:
    push   esi
    push   edx

.sm_polling:
    in	   al, 0x64	   ; Read status
    test   al, 1	   ; Check status
    jz	   .sm_polling	   ; If not ready, loop

    in	   al, 0x60	   ; al = Scancode

    ; Check if the scancode corresponds to '1' to '9'

    cmp    al, 0x2         ; Compare with scancode for '1'
    jb     .sm_polling     ; If below, it's invalid
    cmp    al, 0xA         ; Compare with scancode for '9'
    ja     .sm_polling     ; If above, it's invalid

    sub	   al, 2           ; al = index of move
    movzx  eax, al	   ; eax = index of move
    mov	   esi, board	   ; esi = offset of the first cell in board
    add	   esi, eax	   ; esi = offset of move
    
    cmp    byte [esi], '_' ; alredy filled
    jne    .sm_polling
    
    ; Print the valid move number
    mov    edx, 0
    mov    dh, VGA_COLOR_LIGHT_MAGENTA
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    mov    edx, 0    
    add    al, 49
    call   terminal_putchar
	
    sub    al, 48	  ; Set al to the actual move number in order to be returned
    
    pop    edx
    pop    esi
    ret

;---------------------------------------------------------------------------------------;
; Procedure: scan_char									;
; Purpose: Monitors keyboard input to capture a player's character choice ('x' or 'o')	;
; This function waits for a key press and checks if the scancode corresponds to the     ;
; characters 'x' or 'o'. Upon detecting a valid input, it sets the appropriate value    ;
; for the player's choice and displays it on the terminal in a specified color.         ;
;                                          						;
; Input:										;
;   - No parameters. It directly reads from the keyboard input.				;
; Output:										;
;   - Displays the valid character ('x' or 'o') on the terminal in a specific color.	;
;   - Returns the character choice in al (1 for 'x', 2 for 'o').			;
;---------------------------------------------------------------------------------------;
scan_char:
    push   esi
    push   edx
    push   ebx

.so_polling:
    in	   al, 0x64	   ; Read status
    test   al, 1	   ; Check status
    jz	   .so_polling	   ; If not ready, loop

    in	   al, 0x60	   ; al = Scancode

    ; Check if the scancode corresponds to 'x' or 'o'

    cmp    al, 45
    je     .retx
    cmp    al, 24
    je     .reto
    jmp    .so_polling
  
.retx:
    add    al, 75
    mov    bl, 1
    jmp    .retopt
.reto:  
    add    al, 87
    mov    bl, 2
     
.retopt:
    mov   edx, 0
    mov    dh, VGA_COLOR_LIGHT_MAGENTA
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    mov    edx, 0
    call   terminal_putchar

    mov    al, bl
    
    pop    ebx
    pop    edx
    pop    esi
    ret
    
;---------------------------------------------------------------------------------------;
; Procedure: scan_option								;
; Purpose: Monitors keyboard input to capture a player's menu option in the Tic-Tac-Toe ;
; game. This function waits for a key press and checks if the corresponding scancode is ;
; valid, specifically for options '1' (rematch) and '2' (exit). This function ensures   ;
; that only valid options are accepted before proceeding.				;
;                                          						;
; Input:										;
;   - No parameters. It directly reads from the keyboard input.				;
; Output:										;
;   - Displays the valid option number on the terminal in a specific color.		;
;   - Returns the valid option number in al.						;
;---------------------------------------------------------------------------------------;
scan_option:
    push   esi
    push   edx

.so_polling:
    in	   al, 0x64	   ; Read status
    test   al, 1	   ; Check status
    jz	   .so_polling	   ; If not ready, loop

    in	   al, 0x60	   ; al = Scancode

    ; Check if the scancode corresponds to '1' or '2'

    cmp    al, 0x2
    je     .retopt
    cmp    al, 0x3
    je     .retopt
    jmp    .so_polling
     
.retopt:
    mov   edx, 0
    mov    dh, VGA_COLOR_LIGHT_MAGENTA
    mov    dl, VGA_COLOR_BLACK
    call   terminal_set_color
    mov    edx, 0
    add    al, 47
    call   terminal_putchar

    sub    al, 48
    
    pop    edx
    pop    esi
    ret
    
;---------------------------------------------------------------------------------------;
; Procedure: scan_any									;
; Purpose: Monitors keyboard input to capture any key press, specifically looking for   ;
; the Space key. This function waits for a key press and determines if the pressed key  ;
; corresponds to the Space key. If the Space key is detected, the function will exit    ;
; and return control to the calling procedure.                                          ;
;                                          						;
; Input:										;
;   - No parameters. It directly reads from the keyboard input.				;
; Output:										;
;   - Returns when the Space key is pressed, indicating a valid key input.		;
;---------------------------------------------------------------------------------------;
scan_any:
    push   esi

.sa_polling:
    in	   al, 0x64	   ; Read status
    test   al, 1	   ; Check status
    jz	   .sa_polling	   ; If not ready, loop
    
    in	   al, 0x60	   ; al = Scancode
    
    cmp    al, 57          ; Check for Space
    jne    .sa_polling
    
    pop    esi
    ret

;---------------------------------------------------------------------------------------;
; Procedure: halt									;
; Purpose: Creates a small delay, resulting in a smooth user interface.			;		
;---------------------------------------------------------------------------------------;
halt:
    push ecx
    mov ecx, 03FFFFFFh
.delay:
    loop .delay
  
    pop ecx
    ret


; ------------------------------------------------------------------------------------------------------ ;
; --------------------------------------------- Algorithm ---------------------------------------------- ;
; ------------------------------------------------------------------------------------------------------ ;

;---------------------------------------------------------------------------------------;
; Procedure: make_move									;
; Purpose: Executes a move for the current player in the Tic-Tac-Toe game.		;
; This function updates the game board by placing the current player ('X' or 'O')	;
; in the specified cell index. It also updates the display board to reflect the current	;
; state of the game. Note that the cell index parameter is one-based.			;
;											;
; Input:										;
;   - Param1: cell index (1-9) for the move to be made					;
;   - Param2: current player ('X' or 'O')						;
; Output:										;
;   - The game board and display_board are updated with the current player's move.	;
;---------------------------------------------------------------------------------------;
make_move:
	push	ebp                   ; Save the base pointere
	mov	ebp, esp              ; Set a new base pointer
	push	eax                   ; Save EAX register
	push	ebx                   ; Save EBX register
	push	esi                   ; Save ESI register

	; Retrieve parameters:
	; [ebp +  8] -> Param1: cell index
	; [ebp + 12] -> Param2: current player ('X' or 'O')

	mov	eax, dword [ebp +  8] ; Load cell index from parameters
	dec	eax 		      ; Convert to zero-based index
	mov	ebx, dword [ebp + 12] ; Load current player symbol ('X' or 'O')
	mov	esi, board 	      ; Point to the game board
	add	esi, eax	      ; Calculate address of the specific cell
	mov	byte [esi], bl	      ; Place the current player's symbol in the board
	
	mov	esi, display_board    ; Point to the display_board
	shl	eax, 2		      ; Calculate the byte offset for the display_board
	add	eax, cell_idx	      ; Get the correct offset based on cell index
	add	esi, dword [eax]      ; Adjust display board pointer to the correct cell
	mov	byte [esi], bl	      ; Update display board with the current player's symbol

	pop	esi		      ; Restore ESI register
	pop	ebx		      ; Restore EBX register
	pop	eax		      ; Restore EAX register
	mov	esp, ebp	      ; Restore the stack pointer
	pop	ebp		      ; Restore the base pointer
	ret			      ; Return to caller

;---------------------------------------------------------------------------------------;
; Procedure: find_best_move								;
; Purpose: Determines the best move for the current player in Tic-Tac-Toe game.		;
; This function evaluates all possible moves for the current player and uses the	;
; minimax algorithm to find the move that maximizes the player's chances of winning.	;
; The function differentiates between the maximizer player ('X') and the minimizer	;
; player ('O') to identify the optimal move. 						;
; The offset of the best move is returned in EDX register 				;
;											;
; Input:										;
;   - Param1: current player ('X' or 'O')						;
; Output:										;
;   - EDX: Offset of the best move for the current player on the board.			;
;---------------------------------------------------------------------------------------;
find_best_move:
	push	ebp                   ; Save the base pointere
	mov	ebp, esp              ; Set a new base pointer
	push	eax                   ; Save EAX register
	push	ebx                   ; Save EBX register
	push	ecx                   ; Save ECX register
	push	esi                   ; Save ESI register
	push	edi                   ; Save EDI register
	
	; Retrieve parameters:
	; [ebp + 8] -> Param1: current player ('X' or 'O')

	cmp	dword [ebp + 8], 'X'  ; Check if the current player is 'X'
	jne	.FLX                  ; If not, handle player 'O' case
	
	mov	eax, -INF             ; Initialize result for 'X' as maximizer
	mov	ecx, 9                ; Initialize loop counter for board cells
	mov	esi, board            ; Point to the start of the game board
.FL1:                       
	cmp	byte [esi], '_'       ; Check if the current cell is empty
	jne	.FL2                  ; If not empty, skip to the next cell
	mov	byte [esi], 'X'       ; Place 'X' in the current cell
	mov	edi, edx              ; Save the current best move offset in EDI
	mov	edx, esi              ; Set EDX to the current position being evaluated
	mov	ebx, 'O'              ; Set the opponent as 'O'
	push	ebx                   ; Push opponent to stack
	push	dword 0               ; Push a zero to stack (for depth parameter)
	mov	ebx, eax              ; Store the current best score into EBX
	call	minimax               ; Call the minimax function
	add	esp, 8                ; Clean up the stack
	mov	byte [esi], '_'       ; Reset the cell to empty
	cmp	eax, ebx              ; Compare returned score with the best score
	jg	.FL2                  ; If the returned score is greater, keep it
	mov	eax, ebx              ; Otherwise, restore the current score
	mov	edx, edi              ; Restore the best move offset from EDI
	
		
.FL2:
	inc	esi                   ; Move to the next position on the board
	loop	.FL1                  ; Repeat the loop until all positions have been evaluated
	
	jmp	.FBR                  ; Exit the procedure

.FLX:                                 
	mov	eax, INF              ; Initialize result for 'O' as minimizer
	mov	ecx, 9                ; Initialize loop counter for board cells
	mov	esi, board            ; Point to the start of the game board
.FL3:                       
	cmp	byte [esi], '_'       ; Check if the current cell is empty
	jne	.FL4                  ; If not empty, skip to the next cell
	mov	byte [esi], 'O'       ; Place 'O' in the current cell
	mov	edi, edx              ; Save the current best move offset in EDI
	mov	edx, esi              ; Set EDX to the current position being evaluated
	mov	ebx, 'X'              ; Set the opponent as 'X'
	push	ebx                   ; Push opponent to stack
	push	dword 0               ; Push a zero to stack (for depth parameter)
	mov	ebx, eax              ; Store the current best score into EBX
	call	minimax               ; Call the minimax function
	add	esp, 8                ; Clean up the stack
	mov	byte [esi], '_'       ; Reset the cell to empty
	cmp	eax, ebx              ; Compare returned score with the best score
	jl	.FL4                  ; If the returned score is greater, keep i
	mov	eax, ebx              ; Otherwise, restore the current score
	mov	edx, edi              ; Restore the best move offset from EDI
		
.FL4:                       
	inc	esi                   ; Move to the next cell
	loop	.FL3                  ; Continue the loop for all cells

.FBR:                       
	pop	edi                   ; Restore EDI register
	pop	esi                   ; Restore ESI register
	pop	ecx                   ; Restore ECX register
	pop	ebx                   ; Restore EBX register
	pop	eax                   ; Restore EAX register
	mov	esp, ebp              ; Restore the stack pointer
	pop 	ebp                   ; Restore the base pointer
	ret                           ; Return to caller

;---------------------------------------------------------------------------------------;
; Procedure: minimax									;
; Purpose: Implements the minimax algorithm for optimal move in Tic-Tac-Toe game.	;
; This function recursively evaluates the game board to determine the best score	;
; for the current player based on the depth of the game tree. It considers the moves	;
; of both players ('X' and 'O') and returns a score that indicates the desirability of	;
; the current board state from the perspective of the player. The score is influenced	;
; by the depth of the recursion to favor quicker wins and longer losses.		;
; The resulting score is returned in EAX register.					;
;											;
; Input:										;
;   - Param1: depth of the current recursion level.					;
;   - Param2: current player ('X' or 'O') making the move.				;
; Output:										;
;   - EAX: Positive score if player 'X' has a winning path, negative if player 'O'	;
;          has a winning path, or zero if the game is a draw.				;
;---------------------------------------------------------------------------------------;
minimax:
	push	ebp                          ; Save the base pointer
	mov	ebp, esp                     ; Set a new base pointer
	push	ebx                          ; Save EBX register
	push	ecx                          ; Save ECX register
	push	edx                          ; Save EDX register
	push	esi                          ; Save ESI register

	; Retrieve parameters:
	; [ebp +  8] -> Param1: depth (current recursion depth)
	; [ebp + 12] -> Param2: current player ('X' or 'O')

	mov	edx, dword [ebp + 8]         ; Set EDX register to the current depth
	call	get_status                   ; Check the current status of the game
	cmp	eax, 'T'                     ; Check if the game is already a tie
	jne	.ML1                         ; If not a tie, proceed to evaluate scores

	xor	eax, eax                     ; If the game is a tie, return a score of 0
	jmp	.MBR                         ; Exit the procedure

.ML1:
	cmp	eax, 'X'                     ; Check if player 'X' has won
	jne	.ML2                         ; If not, check for player 'O'

	mov	eax, 10                      ; Assign score for player 'X' victory
	sub	eax, edx                     ; Adjust score by depth
	jmp	.MBR                         ; Exit the procedure

.ML2:
	cmp	eax, 'O'                     ; Check if player 'O' has won
	jne	.ML3                         ; If not, continue to evaluate moves

	mov	eax, -10                     ; Assign score for player 'O' victory
	add	eax, edx                     ; Adjust score by depth
	jmp	.MBR                         ; Exit the procedure

.ML3:
	cmp	dword [ebp + 12], 'X'        ; Check if the current player is 'X'
	jne	.MLX                         ; If not, handle player 'O' case

	; Determine the optimal score for player 'X' (maximizer player)

	mov	eax, -INF                    ; Initialize result for 'X' as maximizer
	mov	ecx, 9                       ; Initialize loop counter for board cells
	mov	esi, board                   ; Point to the start of the game board

.ML4:
	cmp	byte [esi], '_'              ; Check if the current cell is empty
	jne	.ML6                         ; If not empty, skip to the next cell

	mov	byte [esi], 'X'              ; Place 'X' in the current cell

	mov	ebx, 'O'                     ; Set the opponent as 'O'
	push	ebx                          ; Push opponent to stack
	inc	edx                          ; Increase depth for the next recursion
	push	edx                          ; Push updated depth to stack
	dec	edx                          ; Decrement depth for current recursion
	mov	ebx, eax                     ; Store current score in EBX
	call	minimax                      ; Recursive call to minimax
	add	esp, 8                       ; Clean up the stack

	cmp	eax, ebx                     ; Compare returned score with the best score
	jg	.ML5                         ; If the returned score is greater, keep it

	mov	eax, ebx                     ; Otherwise, restore the current score

.ML5:
	mov	byte [esi], '_'              ; Reset the cell to empty
.ML6:
	inc	esi                          ; Move to the next cell
	loop	.ML4                         ; Continue the loop for all cells

	jmp	.MBR                         ; Exit and return the best score

.MLX:
	; Determine the optimal score for player 'O' (minimizer player)

	mov	eax, INF                     ; Initialize result for 'O' as minimizer
	mov	ecx, 9                       ; Initialize loop counter for board cells
	mov	esi, board                   ; Point to the start of the game board

.ML7:
	cmp	byte [esi], '_'              ; Check if the current cell is empty
	jne	.ML9                         ; If not empty, skip to the next cell

	mov	byte [esi], 'O'              ; Place 'O' in the current cell

	mov	ebx, 'X'                     ; Set the opponent as 'X'
	push	ebx                          ; Push opponent to stack
	inc	edx                          ; Increase depth for the next recursion
	push	edx                          ; Push updated depth to stack
	dec	edx                          ; Decrement depth for current context
	mov	ebx, eax                     ; Store current score in EBX
	call	minimax                      ; Recursive call to minimax
	add	esp, 8                       ; Clean up the stack

	cmp	eax, ebx                     ; Compare returned score with the best score
	jl	.ML8                         ; If the returned score is lesser, keep it

	mov	eax, ebx                     ; Otherwise, restore the current best score

.ML8:
	mov	byte [esi], '_'              ; Reset the cell to empty
.ML9:
	inc	esi                          ; Move to the next cell
	loop	.ML7                         ; Continue the loop for all cells

.MBR:
	pop	esi                          ; Restore ESI register
	pop	edx                          ; Restore EDX register
	pop	ecx                          ; Restore ECX register
	pop	ebx                          ; Restore EBX register
	mov	esp, ebp                     ; Restore the stack pointer
	pop	ebp                          ; Restore the base pointer
	ret                                  ; Return to caller

;---------------------------------------------------------------------------------------;
; Procedure: get_status									;
; Purpose: Determines the current status of the Tic-Tac-Toe game.			;
; It checks if there is a winner ('X' or 'O'), if the game has ended in a tie ('T'),	;
; or if the game is still ongoing (returns 0).						;
; The status is returned in EAX register.						;
;											;
; Input:										;
;   - None										;
; Output:										;
;   - EAX: 'X' if player X has won, 'O' if player O has won,				;
;          'T' if the game is a tie, 0 if the game is still ongoing.			;
;---------------------------------------------------------------------------------------;
get_status:
            push    ecx             ; Save ECX register
            push    esi             ; Save ESI register

            xor     eax, eax        ; Initialize EAX to 0 (not over)

            ; Evaluate the board state to check for wins or ties
            call    evaluate

            ; Check for X victory
            cmp     eax, 10         ; Compare the score to the value indicating X victory
            jne     .GL1            ; If not equal, go check for O win
            mov     eax, 'X'        ; Set EAX to 'X' (X has won)
            jmp     .GBR            ; Exit the procedure

.GL1:
            ; Check for O victory
            cmp     eax, -10        ; Compare the score to the value indicating O victory
            jne     .GL2            ; If not equal, go check for tie
            mov     eax, 'O'        ; Set EAX to 'O' (O has won)
            jmp     .GBR            ; Exit the procedure

.GL2:
	    ; Check for tie
            mov     ecx, 9          ; Set loop counter for finding empty spots
            mov     esi, board      ; Point ESI to the start of the board

.GL3:
            cmp     byte [esi], '_' ; Check if the current spot is empty
            je      .GBR            ; If found an empty spot, game is not over
            inc     esi             ; Move to the next cell
            loop    .GL3            ; Loop until all cells are checked

            mov     eax, 'T'        ; No empty spots found, set EAX to 'T' (tie)

.GBR:
            pop     esi             ; Restore ESI register
            pop     ecx             ; Restore ECX register
            ret                     ; Return to caller

;---------------------------------------------------------------------------------------;
; Procedure: evaluate									;
; Purpose: Evaluates the current state of the Tic-Tac-Toe game and calculates the score.;
; The score is represented as follows:							;
;   -  10: Player X has won								;
;   - -10: Player O has won								;
;   -   0: The game is still ongoing or a tie						;
; The function checks all rows, columns, and diagonals for a winning condition.		;
; The score is returned in EAX register.						;
;											;
; Input:										;
;   - None										;
; Output:										;
;   - EAX: 10 if player X has won, -10 if player O has won, 0 if no winner.		;
;---------------------------------------------------------------------------------------;
evaluate:
            push    ebx             ; Save EBX register
            push    edx             ; Save EDX register
            push    esi             ; Save ESI register

            mov     esi, board      ; Point ESI to the start of the board
            xor     eax, eax        ; Initialize EAX to 0 (no winner)

            ; Check each row for a win
            ; Each row is checked by summing the ASCII values of X's and O's
            ; If the sum equals xwin or owin, we have a winner.

            ; Check first row
            movzx   ebx, byte [esi]
            movzx   edx, byte [esi + 1]
            add     ebx, edx
            movzx   edx, byte [esi + 2]
            add     ebx, edx
            cmp     ebx, xwin	    ; Check for X victory
            jne     .EL1            ; If not equal, go check for O victory
            mov     eax, 10         ; X wins
            jmp     .EBR            ; Exit the procedure

.EL1:
            cmp     ebx, owin	    ; Check for O victory
            jne     .EL2            ; If not equal, go check second row
            mov     eax, -10        ; O wins
            jmp     .EBR            ; Exit the procedure

.EL2:
            ; Check second row
            movzx   ebx, byte [esi + 3]
            movzx   edx, byte [esi + 4]
            add     ebx, edx
            movzx   edx, byte [esi + 5]
            add     ebx, edx
            cmp     ebx, xwin	    ; Check for X victory
            jne     .EL3	    ; If not equal, go check for O victory
            mov     eax, 10         ; X wins
            jmp     .EBR            ; Exit the procedure

.EL3:
            cmp     ebx, owin	    ; Check for O victory
            jne     .EL4	    ; If not equal, go check third row
            mov     eax, -10        ; O wins
            jmp     .EBR            ; Exit the procedure

.EL4:
            ; Check third row
            movzx   ebx, byte [esi + 6]
            movzx   edx, byte [esi + 7]
            add     ebx, edx
            movzx   edx, byte [esi + 8]
            add     ebx, edx
            cmp     ebx, xwin	    ; Check for X victory
            jne     .EL5	    ; If not equal, go check for O victory
            mov     eax, 10         ; X wins
            jmp     .EBR            ; Exit the procedure

.EL5:
            cmp     ebx, owin       ; Check for O victory
            jne     .EL6            ; If not equal, go check first column
            mov     eax, -10        ; O wins
            jmp     .EBR            ; Exit the procedure

.EL6:
            ; Check first column
            movzx   ebx, byte [esi]
            movzx   edx, byte [esi + 3]
            add     ebx, edx
            movzx   edx, byte [esi + 6]
            add     ebx, edx
            cmp     ebx, xwin       ; Check for X victory
            jne     .EL7	    ; If not equal, go check for O victory
            mov     eax, 10         ; X wins
            jmp     .EBR            ; Exit the procedure

.EL7:
            cmp     ebx, owin	    ; Check for O victory
            jne     .EL8	    ; If not equal, go check second column
            mov     eax, -10        ; O wins
            jmp     .EBR            ; Exit the procedure

.EL8:
            ; Check second column
            movzx   ebx, byte [esi + 1]
            movzx   edx, byte [esi + 4]
            add     ebx, edx
            movzx   edx, byte [esi + 7]
            add     ebx, edx
            cmp     ebx, xwin	    ; Check for X victory
            jne     .EL9	    ; If not equal, go check for O victory
            mov     eax, 10         ; X wins
            jmp     .EBR            ; Exit the procedure

.EL9:
            cmp     ebx, owin	    ; Check for O victory
            jne     .ELA	    ; If not equal, go check third column
            mov     eax, -10        ; O wins
            jmp     .EBR            ; Exit the procedure

.ELA:
            ; Check third column
            movzx   ebx, byte [esi + 2]
            movzx   edx, byte [esi + 5]
            add     ebx, edx
            movzx   edx, byte [esi + 8]
            add     ebx, edx
            cmp     ebx, xwin	    ; Check for X victory
            jne     .ELB	    ; If not equal, go check for O victory
            mov     eax, 10         ; X wins
            jmp     .EBR            ; Exit the procedure

.ELB:
            cmp     ebx, owin	    ; Check for O victory
            jne     .ELC	    ; If not equal, go check first diagonal
            mov     eax, -10        ; O wins
            jmp     .EBR            ; Exit the procedure

.ELC:
            ; Check first diagonal (\)
            movzx   ebx, byte [esi]
            movzx   edx, byte [esi + 4]
            add     ebx, edx
            movzx   edx, byte [esi + 8]
            add     ebx, edx
            cmp     ebx, xwin	    ; Check for X victory
            jne     .ELD	    ; If not equal, go check for O victory
            mov     eax, 10         ; X wins
            jmp     .EBR            ; Exit the procedure

.ELD:
            cmp     ebx, owin	    ; Check for O victory
            jne     .ELE	    ; If not equal, go check second diagonal
            mov     eax, -10        ; O wins
            jmp     .EBR            ; Exit the procedure

.ELE:
            ; Check second diagonal (/)
            movzx   ebx, byte [esi + 2]
            movzx   edx, byte [esi + 4]
            add     ebx, edx
            movzx   edx, byte [esi + 6]
            add     ebx, edx
            cmp     ebx, xwin	    ; Check for X victory
            jne     .ELF	    ; If not equal, go check for O victory
            mov     eax, 10         ; X wins
            jmp     .EBR            ; Exit the procedure

.ELF:
            cmp     ebx, owin	    ; CHeck for O victory
            jne     .EBR	    ; If not equal, go to the end
            mov     eax, -10        ; O wins

.EBR:
            pop     esi             ; Restore ESI register
            pop     edx             ; Restore EDX register
            pop     ebx             ; Restore EBX register
            ret                     ; Return to caller
            
