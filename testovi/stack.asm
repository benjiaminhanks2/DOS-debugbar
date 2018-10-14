	org 100h
main:
	mov ax, 1001h
	push ax
	
	mov bx, 1a1bh
	push bx
	
	mov cx, 0aaaah
	push cx
	
	mov dx, 3f3fh
	push dx
	
	mov si, 0ffffh
	push si
	
	mov di, 0101h
	push di
cekaj:
	jmp cekaj