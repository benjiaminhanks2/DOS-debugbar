segment .code
ispis_registara:
	pusha
_ispis_labele_registri:
	call izracunaj_poziciju
	add [pozicija], word 160
	mov bx, [pozicija]
	mov si, reg_labela
	call ispis_u_video
	
_ispis_ax_labele:
	call izracunaj_poziciju
	add [pozicija], word 320
	mov bx, [pozicija]
	
	mov si, ax_labela
	call ispis_u_video
	
	mov ax, word[ds:curr_ax]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
	
	
	
_ispis_bx_labele:
	call izracunaj_poziciju
	add [pozicija], word 480
	mov bx, [pozicija]
	
	mov si, bx_labela
	call ispis_u_video
	
	mov ax, [curr_bx]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
_ispis_cx_labele:
	call izracunaj_poziciju
	add [pozicija], word 640
	mov bx, [pozicija]
	
	mov si, cx_labela
	call ispis_u_video
	
	mov ax, [curr_cx]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
_ispis_dx_labele:
	call izracunaj_poziciju
	add [pozicija], word 800
	mov bx, [pozicija]
	
	mov si, dx_labela
	call ispis_u_video
	
	mov ax, [curr_dx]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
_ispis_si_labele:
	call izracunaj_poziciju
	add [pozicija], word 960
	mov bx, [pozicija]
	
	mov si, si_labela
	call ispis_u_video
	
	mov ax, [curr_si]
	mov cx, 4
	mov dx, hex_code
	call bin2hex
	mov si, hex_code
	call ispis_u_video
	mov si, hex_char
	call ispis_u_video
	
_ispis_di_labele:
	call izracunaj_poziciju
	add [pozicija], word 1120
	mov bx, [pozicija]
	
	mov si, di_labela
	call ispis_u_video
	
	mov ax, [curr_di]
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
reg_labela: 	db 'Registers', 0 
ax_labela: 		db 'ax: ', 0
bx_labela: 		db 'bx: ', 0
cx_labela: 		db 'cx: ', 0
dx_labela: 		db 'dx: ', 0
si_labela: 		db 'si: ', 0
di_labela: 		db 'di: ', 0