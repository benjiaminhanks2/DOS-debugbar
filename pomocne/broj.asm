	
	
;Ispis decimalnog broja koji se nalazi u ax 
;string broj se nalazi u varijabli broj
segment .code
ucitaj_broj:
	pusha
	mov cx, 0
	;mov ax, 1334 pre poziva u ax stavi sta voles
	push ax
deli:
	pop ax
	mov dx, 0
	mov bx, 10
	div bx
	
	push dx
	push ax
	inc cx
	
	cmp ax, 0
	jne deli
	
		
	pop dx
	
	mov bx, broj
upisi:
	pop dx
	add dl, 48
	mov [bx], byte dl
	
	inc bx
	dec cx
	
	cmp cx, 0
	jne upisi
	mov [bx], byte 0
	
	popa
	ret
	