segment .code
_print:
	push ax
	cld
.prn:
	lodsb ; ucitava ono sto pokazuje si i smesta u al, 
		  ; pa inkrementira si, jer je klirovan direction flag
	
	cmp al, 0
	je .end
	
	mov ah, 0eh
	int 10h
	jmp .prn
	
.end:
	pop ax
	ret
	
	
_clear:
	pusha
	mov cx, 0
	mov ax, 0b800h
	mov es, ax
.loop:
	mov bx, cx
	mov [es:bx], byte ' '
	inc cx
	mov [es:bx], byte 0
	inc cx
	
	cmp cx, 4000
	jne .loop
	
	
	popa
	ret

_cls:
	pusha
	
	mov al, [red]
	
	mov cx, 12
	ocisti_red:
	
	call izracunaj_poziciju
	mov bx, [pozicija]
	mov si, prazno
	call ispis_u_video
	inc byte [red]
	
	loop ocisti_red
	
	mov byte [red], al
	popa
	ret
	
ispis_u_video:
	push ax
	push si
	push es
		
	mov ax, 0b800h
	mov es, ax
petlja:
	mov al, byte [si] ;procitamo bajt sa lokacije na koju pokazuje SI
	cmp al, 0 ;proverimo da li smo dosli do kraja
	je vrati_se
 
	mov byte [es:bx], al ;upis karaktera u video memoriju
	inc bx
	mov [es:bx], byte 02h ;upis boje za trenutni karakter
 
	inc si ;naredni karakter u RAM
	inc bx ;naredna pozicija u video memoriji
		
	jmp petlja
 
vrati_se:
	pop es
	pop si
	pop ax
	ret
	
segment .data
razmak: db ' ',0
prazno: db '          ',0
	
	
	
	
	