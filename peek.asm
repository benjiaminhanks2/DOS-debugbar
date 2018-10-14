segment .code
ispis_peek:
	pusha

_ispis_segmenta:	
	call izracunaj_poziciju
	add [pozicija], word 1280
	mov bx, [pozicija]
	mov si, seg_labela
	call ispis_u_video
	
	mov ax, [peek_seg]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
_ispis_ofseta:
	call izracunaj_poziciju
	add [pozicija], word 1440
	mov bx, [pozicija]
	mov si, off_labela
	call ispis_u_video
	
	mov ax, [peek_off]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
	
_ispis_vrednosti:
	call izracunaj_poziciju
	add [pozicija], word 1600
	mov bx, [pozicija]
	mov si, peek_val_labela
	call ispis_u_video
	
	mov ax, [peek_val]
	mov cx, 2
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
	
	popa
	ret
segment .data	
seg_labela:			db 'seg: ', 0
off_labela:			db 'off: ', 0
peek_val_labela:	db 'val: ', 0
