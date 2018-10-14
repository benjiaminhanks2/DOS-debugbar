
	org 100h
main:
	mov ax, 1001h
	mov bx, 1a1bh
	mov cx, 0aaaah
	mov dx, 3f3fh
	mov si, 0ffffh
	mov di, 0101h

cekaj:
	jmp cekaj