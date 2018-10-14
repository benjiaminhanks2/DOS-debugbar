segment .code
ispis_steka:
	pusha
_ispis_labele_stack:
	call izracunaj_poziciju
	add [pozicija], word 160
	mov bx, [pozicija]
	mov si, stack_labela
	call ispis_u_video
	
_ispis_prvog_sa_steka:
	call izracunaj_poziciju
	add [pozicija], word 320
	mov bx, [pozicija]
	
	mov si, stack_1_labela
	call ispis_u_video
	
	mov ax, word[ds:stack_1]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video

_ispis_drugog_sa_steka:
	call izracunaj_poziciju
	add [pozicija], word 480
	mov bx, [pozicija]
	
	mov si, stack_2_labela
	call ispis_u_video
	
	mov ax, [ds:stack_2]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
_ispis_treceg_sa_steka:
	call izracunaj_poziciju
	add [pozicija], word 640
	mov bx, [pozicija]
	
	mov si, stack_3_labela
	call ispis_u_video
	
	mov ax, [ds:stack_3]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
_ispis_cetvrtog_sa_steka:
	call izracunaj_poziciju
	add [pozicija], word 800
	mov bx, [pozicija]
	
	mov si, stack_4_labela
	call ispis_u_video
	
	mov ax, [ds:stack_4]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
_ispis_petog_sa_steka:
	call izracunaj_poziciju
	add [pozicija], word 960
	mov bx, [pozicija]
	
	mov si, stack_5_labela
	call ispis_u_video
	
	mov ax, [ds:stack_5]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
_ispis_sestog_sa_steka:
	call izracunaj_poziciju
	add [pozicija], word 1120
	mov bx, [pozicija]
	
	mov si, stack_6_labela
	call ispis_u_video
	
	mov ax, [ds:stack_6]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
	popa
	ret
	
segment .data
stack_labela: 	db 'Stack', 0 
stack_1_labela: db '1: ', 0
stack_2_labela: db '2: ', 0
stack_3_labela: db '3: ', 0
stack_4_labela: db '4: ', 0
stack_5_labela: db '5: ', 0
stack_6_labela: db '6: ', 0