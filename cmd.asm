segment .code
;si stavlja na adresu stringa koji ne pocinje razmakom i koji se zavrsava nulom
get_cmd_str:
		push cx
		push di
		push ax
		cld
        mov     cx, 0080h                   ; Maksimalni broj izvrsavanja instrukcije sa prefiksom REPx
        mov     di, 81h                     ; Pocetak komandne linije u PSP.
        mov     al, ' '                     ; String uvek pocinje praznim mestom (razmak izmedju komande i parametra) 
repe    scasb                               ; Trazimo prvo mesto koje nije prazno (tada DI pokazuje na lokaciju iza njega)



        dec     di                          ; Vracamo DI da pokazuje gde treba
        mov     si, di                      ; Pocetak stringa u SI
        mov     al, 0dh                     ; Trazimo kraj stringa (pritisnut Enter)
repne   scasb                               ; (tada DI pokazuje na lokaciju iza njega) 
        mov byte [ds:di-1], 0                  ; string zavrsavamo nulom   
		
		pop ax
		pop di
		pop cx
		ret
		
;Ova funkcija radi kao i ova gore, samo na neki moj nacin
get_cmd_str_tsr:
		push cx
		push di
		push ax
		cld
        mov     cx, 0080h                   ; Maksimalni broj izvrsavanja instrukcije sa prefiksom REPx
		;mov     di, 81h                     ; Pocetak komandne linije u PSP.
        ;mov     al, ' '                     ; String uvek pocinje praznim mestom (razmak izmedju komande i parametra) 
;repe    scasb                               ; Trazimo prvo mesto koje nije prazno (tada DI pokazuje na lokaciju iza njega)
		mov     si, 81h                     ; Pocetak komandne linije u PSP.
		call pomeri_se_do_reci
		mov di, si
        ;dec     di                          ; Vracamo DI da pokazuje gde treba
		;mov     si, di                      ; Pocetak stringa u SI
citaj_chr: ;idemo do kraja da bi nasli enter i zamenili ga nulom
		cmp [cs:di], word 0dh
		je izlaz_cmd
		inc di
		jmp citaj_chr

izlaz_cmd:
		mov byte [cs:di], 0                  ; string zavrsavamo nulom   

		pop ax
		pop di
		pop cx
		ret
		
		
	
;podrazumeva da je u si pocetna adresa stringa koji pocinje crticom "-"	
check_arg:
	;push di
	;push ax
	;push bx
	
	mov bx, si ;sacuvam pokazivac na pocetak stringa
	
check_start:
	mov cx, 6
	mov si, bx
	push ds
	pop es
	mov di, arg_start
	pusha
	repe cmpsb                   ; Ova instrikcija poredi [DS:SI] sa [ES:DI] 
	popa
	jne check_stop

_check_again_start: ;proverimo da li je program vec startovan
	cmp [ds:es_tmp], word 0
	je main
	
	push si
	mov si, vec_pokrenut_poruka
	call _print
	pop si
	
	ret


	
	
check_stop:
	mov cx, 5
	mov si, bx
	push ds
	pop es
	mov di, arg_stop
	pusha
	repe cmpsb                   ; Ova instrikcija poredi [DS:SI] sa [ES:DI] 
	popa
	jne check_peek

	
_check_again_stop:
	cmp [ds:es_tmp], word 0
	jne stop
	
	push si
	mov si, prvo_pokreni_poruka
	call _print
	pop si
	
	ret
	


check_peek:
	mov cx, 5
	mov si, bx
	push ds
	pop es
	mov di, arg_peek
	pusha
	repe cmpsb                   ; Ova instrikcija poredi [DS:SI] sa [ES:DI] 
	popa
	je _check_again_peek
	jmp check_poke
_check_again_peek:
	cmp [ds:es_tmp], word 0 ; ako nije nula onda je vec pokrenut i moze se izvrsiti peek
	jne peek
	
	push si
	mov si, prvo_pokreni_poruka
	call _print
	pop si
	
	ret
	
check_poke:
	mov cx, 5
	mov si, bx
	push ds
	pop es
	mov di, arg_poke
	pusha
	repe cmpsb                   ; Ova instrikcija poredi [DS:SI] sa [ES:DI] 
	popa
	je _check_poke_again
	jmp nepoznat_argument
_check_poke_again:
	cmp [ds:es_tmp], word 0 ; ako nije nula onda je vec pokrenut i moze se izvrsiti peek
	jne poke
	
	push si
	mov si, prvo_pokreni_poruka
	call _print
	pop si
	
	ret

nepoznat_argument:
	push si
	mov si, nepoznat_argument_poruka
	call _print
	pop si
	
	ret
	
	
	
;si je na pocetku unetog stringa
peek:
	mov gs, [es_tmp]
	add si, 5 ;pomerimo se posle -peek
	call pomeri_se_do_reci
	
	call ucitaj_hex_string
	;kad zavrsi pomeranje, si pokazuje na prvi karakter koji nije spejs
	;ucitaj string u varijablu hex_str

	;ucitamo taj hex_str u ax kao pravu vrednost (decimalan broj) i smestimo ga u peek_off
	push si
	mov si, hex_str
	call hex_string_to_int ; u ax-u je prvi hex (segment)
	mov [gs:peek_seg], ax ;ucitali segment
	
	pop si
	
	;pomerimo se u ulaznom stringu za 4 karaktera (4 cifre hex broja) koje smo ucitali
	add si, 4
	call pomeri_se_do_reci
	;sada si pokazuje na drugu rec, rec koja ce biti ofsetni deo
	
	call ucitaj_hex_string
	mov si, hex_str
	call hex_string_to_int
	mov [gs:peek_off], ax ;ucitali ofset u peek_off	


	mov es, [gs:peek_seg]	;namontiram segment
	mov di, [gs:peek_off]	;namontiram ofset 
	mov al, byte [es:di]
	mov [gs:peek_val], byte al	;upisujem u varijablu na segmentnom delu programa koji je u TSR-u
	
	
	mov byte [gs:is_peek], byte 0ffh

	ret
	
	
poke:
	mov gs, [es_tmp]
	add si, 5 ;pomerimo se posle -poke
	call pomeri_se_do_reci
	
	call ucitaj_hex_string
	;kad zavrsi pomeranje, si pokazuje na prvi karakter koji nije spejs
	;ucitaj string u varijablu hex_str

	;ucitamo taj hex_str u ax kao pravu vrednost (decimalan broj) i smestimo ga u peek_off
	push si
	mov si, hex_str
	call hex_string_to_int ; u ax-u je prvi hex (segment)
	mov [gs:poke_seg], ax ;ucitali segment
	pop si
	
	;pomerimo se u ulaznom stringu za 4 karaktera (4 cifre hex broja) koje smo ucitali
	add si, 4
	call pomeri_se_do_reci
	;sada si pokazuje na drugu rec, rec koja ce biti ofsetni deo
	
	call ucitaj_hex_string
	push si
	mov si, hex_str
	call hex_string_to_int
	mov [gs:poke_off], ax ;ucitali ofset u peek_off	
	pop si
	
	
	add si, 4 ;preskocimo drugi dvobajt
	call pomeri_se_do_reci

	;ucitamo bajt koji zelimo upisati
	call ucitaj_hex_string
	push si
	mov si, hex_str
	call hex_string_to_int ;u ax nam je bajt (konkretno u al)
	pop si

	
	mov es, [gs:poke_seg]	;namontiram segment
	mov di, [gs:poke_off]	;namontiram ofset 
	mov [es:di], byte al	;upisujem u izabranu adresu
	
	ret
	
	
	
	
;pomera si do prvog karaktera koji nije razmak
pomeri_se_do_reci:
	cmp [si], byte' '
	je .brisi_spejsove
	ret
.brisi_spejsove:
	inc si
	jmp pomeri_se_do_reci

;ucitaj string u varijablu hex_str
;podrazumeva da si pokazuje na string od 4 karaktera (hex string)
ucitaj_hex_string:
	push cx
	push di
	push ax
	push si
	
	mov cx, 4
	mov di, hex_str
	petlja_hex:
	mov ax, [si]
	mov word[cs:di], ax
	inc di
	inc si
	loop petlja_hex
	mov [cs:di], byte 0 ;moramo string determinisati nulom
	
	pop si
	pop ax
	pop di
	pop cx
	ret
	
	
segment .data
arg_start:	db '-start', 0
arg_stop: 	db '-stop', 0
arg_peek: 	db '-peek', 0
arg_poke: 	db '-poke', 0
hex_str:	db 0,0,0,0,0
vec_pokrenut_poruka: db 'Vas program je vec pokrenut', 0
prvo_pokreni_poruka: db 'Program se mora pokrenuti pre izabrane akicje, pozdrav, svako dobro!', 0
nepoznat_argument_poruka: db 'Nepoznat argument!', 0
is_peek: db 0
peek_off: dw 0
peek_seg: dw 0
peek_val: db 0
poke_seg: dw 0
poke_off: dw 0