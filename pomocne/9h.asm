; =====================================================
; test_tsr.asm
;    - Instalira TSR rutinu i zavrsava se
; ===================================================== 

KBD equ 60h
segment .code
install_09h:
        call   _novi_09
        mov dx, 00FFh
        mov ah, 31h
        int 21h
        
        ;ret

; Sacuvati originalni vektor prekida 0x1C, tako da kasnije mozemo da ga vratimo
_novi_09:
	cli
	xor ax, ax
	mov es, ax
	mov bx, [es:09h*4]
	mov [old_int_off], bx 
	mov bx, [es:09h*4+2]
	mov [old_int_seg], bx

; Modifikacija u tabeli vektora prekida tako da pokazuje na nasu rutinu
	mov dx, tast_int
	mov [es:09h*4], dx
	mov ax, cs
	mov [es:09h*4+2], ax
	sti         
	ret


; Vratiti stari vektor prekida 0x09
_stari_09:
	cli
	xor ax, ax
	mov es, ax
	mov gs, [es_tmp]
	mov ax, [gs:old_int_seg]
	mov [es:09h*4+2], ax
	mov dx, [gs:old_int_off]
	mov [es:09h*4], dx
	sti
	ret


tast_int:

	pop word[cs:nesto_1]
	pop word[cs:nesto_2]
	pop word[cs:nesto_3]
	
	pop word[cs:tmp_stack_1]
	pop word[cs:tmp_stack_2]
	pop word[cs:tmp_stack_3]
	pop word[cs:tmp_stack_4]
	pop word[cs:tmp_stack_5]
	pop word[cs:tmp_stack_6]
	
	push word[cs:tmp_stack_6]
	push word[cs:tmp_stack_5]
	push word[cs:tmp_stack_4]
	push word[cs:tmp_stack_3]
	push word[cs:tmp_stack_2]
	push word[cs:tmp_stack_1]
	
	push word[cs:nesto_3]
	push word[cs:nesto_2]
	push word[cs:nesto_1]
	
	pusha
	
	;resavamo problem sa data segmentom,
	;jedino cs pokazuje na pravi segment
	push ds
	
	cmp [cs:obrisan], byte 0
	jne izlaz
	
	push cs
	pop ds
	
	; Cuvaju se trenutne vrednosti registara
	mov [ds:tmp_ax], word ax
	mov [ds:tmp_bx], word bx
	mov [ds:tmp_cx], word cx
	mov [ds:tmp_dx], word dx
	mov [ds:tmp_si], word si
	mov [ds:tmp_di], word di
	
	
	

; Obrada tastaturnog prekida 
	in al, KBD
	;mov bx, 0B800h
	;mov es, bx
	;mov bx, 460
	cmp al, 3Bh
	je .f1
	cmp al, 3Ch
	je .f2
	cmp al, 3Dh
	je .f3
	cmp al, 3Eh
	je .f4
	cmp al, 3Fh
	je .f5
	cmp al, 1Ch
	je .enter_down
	cmp al, 9Ch
	je .enter_up
	
	
	jmp izlaz
.f1:
	cmp [kolona], byte 0
	je izlaz
	
	call _cls
	dec byte[kolona]	
	
	call pocetak
 	jmp izlaz
	
.f2:
	cmp [kolona], byte 70
	je izlaz
	
	call _cls
	inc byte[kolona]
	
	call pocetak
 	jmp izlaz
	
.f3:
	cmp [red], byte 0
	je izlaz
	
	call _cls
	dec byte[red]
	
	call pocetak
 	jmp izlaz

.f4:
	cmp [red], byte 14
	je izlaz
	
	call _cls
	inc byte[red]
	
	call pocetak
 	jmp izlaz
	
.f5:
	call _cls
	;Rivrtujemo da se prikaze stek ili registri
	not byte[ds:registri_stack]
	
	;Osvezimo registre
	mov ax, word[ds:tmp_ax]
	mov word[ds:curr_ax], ax
	
	mov ax, word[ds:tmp_bx]
	mov word[ds:curr_bx], ax
	
	mov ax, word[ds:tmp_cx]
	mov word[ds:curr_cx], ax
	
	mov ax, word[ds:tmp_dx]
	mov word[ds:curr_dx], ax
	
	mov ax, word[ds:tmp_si]
	mov word[ds:curr_si], ax
	
	mov ax, word[ds:tmp_di]
	mov word[ds:curr_di], ax
	
	
	;Osvezimo stek
	mov ax, word[ds:tmp_stack_1]
	mov word[ds:stack_1], ax
	
	mov ax, word[ds:tmp_stack_2]
	mov word[ds:stack_2], ax
	
	mov ax, word[ds:tmp_stack_3]
	mov word[ds:stack_3], ax
	
	mov ax, word[ds:tmp_stack_4]
	mov word[ds:stack_4], ax
	
	mov ax, word[ds:tmp_stack_5]
	mov word[ds:stack_5], ax
	
	mov ax, word[ds:tmp_stack_6]
	mov word[ds:stack_6], ax
	
	call ucitaj_vreme
	
	call pocetak

	jmp izlaz	
	
	
.enter_down:
	;ocisti mesto gde je prozor trenutno
	call _cls
	jmp izlaz
	
.enter_up:
	call pocetak
 	jmp izlaz
	

	
	
izlaz:
	;pop ss
	pop ds
	popa
	push word [cs:old_int_seg]
	push word [cs:old_int_off]
	retf
	;iret

segment .data
old_int_seg: dw 0
old_int_off: dw 0

hours: db 0
minutes: db 0
seconds: db 0

curr_ax: dw 0000h
curr_bx: dw 0
curr_cx: dw 0
curr_dx: dw 0
curr_si: dw 0
curr_di: dw 0

tmp_ax: dw 0000h
tmp_bx: dw 0
tmp_cx: dw 0
tmp_dx: dw 0
tmp_si: dw 0
tmp_di: dw 0

stack_1: dw 0
stack_2: dw 0
stack_3: dw 0
stack_4: dw 0
stack_5: dw 0
stack_6: dw 0

tmp_stack_1: dw 0
tmp_stack_2: dw 0
tmp_stack_3: dw 0
tmp_stack_4: dw 0
tmp_stack_5: dw 0
tmp_stack_6: dw 0

nesto_1: dw 0
nesto_2: dw 0
nesto_3: dw 0

registri_stack: db 0ffh



