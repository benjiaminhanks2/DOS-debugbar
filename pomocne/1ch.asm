segment .code
install_1ch:
	call   _novi_1ch
    ret

; Sacuvati originalni vektor prekida 0x1C, tako da kasnije mozemo da ga vratimo
_novi_1ch:
	cli
	xor ax, ax
	mov es, ax
	mov bx, [es:1ch*4]
	mov [old_1ch_off], bx 
	mov bx, [es:1ch*4+2]
	mov [old_1ch_seg], bx

; Modifikacija u tabeli vektora prekida tako da pokazuje na nasu rutinu
	mov dx, hendler_1ch
	mov [es:1ch*4], dx
	mov ax, cs
	mov [es:1ch*4+2], ax
	sti         
	ret


; Vratiti stari vektor prekida 0x09
_stari_1ch:
	cli
	xor ax, ax
	mov es, ax
	mov gs, [es_tmp]
	mov ax, [gs:old_1ch_seg]
	mov [es:1ch*4+2], ax
	mov dx, [gs:old_1ch_off]
	mov [es:1ch*4], dx
	sti
	ret


hendler_1ch:
	push ds
	
	cmp [cs:obrisan], byte 0
	jne izlaz_1ch
	
	push cs
	pop ds
	
	cmp [cs:treba_ponoviti], byte 0 ;ako ne treba ponoviti, izadji
	je izlaz_1ch
	
	call can_int
	jne izlaz_1ch
	
	;ponovi ucitavanje vremena
	call _cls
	call ucitaj_vreme
	call pocetak
	mov [cs:treba_ponoviti], byte 0
	
	jmp izlaz_1ch
	
izlaz_1ch:
	pop ds
	push word [cs:old_1ch_seg]
	push word [cs:old_1ch_off]
	retf
	;iret

segment .data
old_1ch_seg: dw 0
old_1ch_off: dw 0