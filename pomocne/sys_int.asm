segment .code
;ucitava flegove i smeta u varijable InDOS_flag i CritErr_flag
ucitaj_flegove:
	pusha
	push es   ;ovo je tu jer zovem interapte koji ih menja

	cli
	
	mov ah, 34h
	int 21h ;da dobijemo adresu bajta na memoriji es:bx

	mov al, byte [es:bx]
	mov byte [ds:InDOS_flag], al
	
	
	push ds
	push si
	
	mov ah, 5dh
	mov al, 06h
	int 21h ;da dobijemo adresu gde se nalazi critical error flag
	
	mov al, byte [ds:si]
	mov byte [ds:CritErr_flag], al
	
	pop si
	pop ds
	
	sti
	
	pop es
	popa
	ret
	
	

;equal flag stavlja na 1 ako moze, inace ga stavlja na 0
can_int:
	push ax
	cmp [InDOS_flag], byte 0
	je _check_crictical
	mov al, 1
	cmp al, 0; da bi setovali equal flag na 0
	jmp _check_int_izlaz
_check_crictical:
	mov al, byte [ds:CritErr_flag]
	cmp byte [ds:InDOS_flag], al
	
_check_int_izlaz:
	pop ax
	ret
	
	
;ako moze ucitava vreme i smesta u varijable hours, minutes i seconds
;ako ne moze, postavlja flag treba_ponoviti na 0ffh
ucitaj_vreme:
	pusha
	
	call can_int ;proveri da li moze
	je .daj_vreme	;uzme ako moze
	mov [ds:treba_ponoviti], byte 0ffh ;ako ne moze, zapamti
	popa
	ret
.daj_vreme:
	;uzimanje sistemskog vremena
	mov ah, 2ch
	int 21h
	
	mov byte[ds:hours], ch
	mov byte[ds:minutes], cl
	mov byte[ds:seconds], dh
	
	popa
	ret
	
	
segment .data
InDOS_flag:		db 0
CritErr_flag: 	db 0
treba_ponoviti:	db 0