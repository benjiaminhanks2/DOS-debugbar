segment .code
install_2fh:
	call   _novi_2fh
    ret

; Sacuvati originalni vektor prekida 0x1C, tako da kasnije mozemo da ga vratimo
_novi_2fh:
	cli
	xor ax, ax
	mov es, ax
	mov bx, [es:2fh*4]
	mov [old_2fh_off], bx 
	mov bx, [es:2fh*4+2]
	mov [old_2fh_seg], bx

; Modifikacija u tabeli vektora prekida tako da pokazuje na nasu rutinu
	mov dx, hendler_2fh
	mov [es:2fh*4], dx
	mov ax, cs
	mov [es:2fh*4+2], ax
	sti         
	ret


; Vratiti stari vektor prekida 0x09
_stari_2fh:
	cli
	xor ax, ax
	mov es, ax
	mov gs, [es_tmp]
	mov ax, [gs:old_2fh_seg]
	mov [es:2fh*4+2], ax
	mov dx, [gs:old_2fh_off]
	mov [es:2fh*4], dx
	sti
	ret


hendler_2fh:
	cmp [cs:obrisan], byte 0
	jne izlaz_2fh
	
	cmp ah, [cs:FuncID]
	jne izlaz_2fh
	mov al, 0ffh
	
	push cs
	pop es
	mov di, string_id
	
	iret

	;jmp izlaz_2fh
	
izlaz_2fh:
	push word [cs:old_2fh_seg]
	push word [cs:old_2fh_off]
	retf
	;iret

segment .data
old_2fh_seg: dw 0
old_2fh_off: dw 0