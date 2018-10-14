; ---------------------------------------------------
; Konverzija binarnog broja u heksadecimalne znakove
; cx - broj znakova
; dx - adresa gde se smestaju znakovi
; Data segment mora da sadrzi string hex_chr
; ---------------------------------------------------

segment .code

bin2hex:
	push bp
	mov word bp, dx               ; [bp+di] cemo koristiti da pristupimo
	mov word di, cx               ; memoriji u koju smestamo rezultat
	push di
	dec di	
	push ax   
L:	call konv                     ; vrsi konverziju najmanje znacajna 4 bita
	dec  di
	pop  ax   
	shr  ax,4                    ; shift right
	push ax   
	loop L
	pop ax    
	pop di
	mov  byte [ds:bp+di], 0	      ; h za kraj stringa
	pop bp		
	ret

konv:
	and  ax, 0x000f	              ; u ax upisemo poslednjih 4 bita iz ax
	mov  si, ax
	mov  byte al, [ds:hex_chr+si]    ; koristimo hex_chr kao malu translacionu tabelu
	mov  byte [ds:bp+di], al		  ; upisemo rezultat
	ret
; --------------------------------------

segment .data
hex_chr:  db '0123456789ABCDEF'

