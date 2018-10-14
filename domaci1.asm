

	org 100h
segment .code
ESC  equ  1bh

                mov     cx, 0FFh                ;This will be the ID number.
IDLoop:         mov     ah, cl                  ;ID -> AH.
                push    cx                      ;Preserve CX across call
                mov     al, 0                   ;Test presence function code.
                int     2Fh                     ;Call multiplex interrupt.
                pop     cx                      ;Restore CX.
                cmp     al, 0                   ;Installed TSR?
                je      TryNext                 ;Returns zero if none there.

				push cx
				mov     cx, 18                  ; CL = broj znakova u imenu (DOS 8+3). CH = 0.
				mov 	si, string_id
				
				pusha
				repe    cmpsb                   ; Ova instrikcija poredi [DS:SI] sa [ES:DI] 
				popa                            ; Poredi se CX bajtova, pri cemu se CX ne menja
				pop cx
                je      Installed                 ;Branch off if it is ours.
TryNext:        
				mov     [FuncID], cl              ;Save function result.
				
				loop    IDLoop                  ;Otherwise, try the next one.
                jmp     NotInstalled            ;Failure if we get to this point.

Installed:


				
				call get_cmd_str_tsr

				mov word[es_tmp], es ;segment programa iz rezidentnog dela
				
				
				call check_arg				
				
				
ret


NotInstalled:
	call ucitaj_flegove
	
	call get_cmd_str
	call check_arg


	ret
	
	
;poziva se kada se ukuca -stop i ako je program pre toga startovan	
stop:
	;setujemo bajt da je obrisano
	push word [es_tmp]
	pop es
	mov [es:obrisan], byte 0ffh

	;Ne brisemo hendlere da ne pokvarimo lanac
	;call _stari_09
	;call _stari_2fh
	
	;Ovo dole ako se brise tsr iz memorije
	;mov     es, [es_tmp]
	;mov     es, [es:2Ch]    ;Get address of environment block.
	;mov     ah, 49h         ;DOS deallocate block call.
	;int     21h

	;mov     es, [es_tmp]         ;Now free the program's memory
	;mov     ah, 49h         ; space.
	;int     21h
	ret

;poziva se kada se unese -start i ako program pre toga nije pokrenut
main:
	
	
	; Cuvaju se trenutne vrednosti registara
	mov [ds:curr_ax], word ax
	mov [ds:curr_bx], word bx
	mov [ds:curr_cx], word cx
	mov [ds:curr_dx], word dx
	mov [ds:curr_si], word si
	mov [ds:curr_di], word di
	
	;uzimanje sistemskog vremena
	;mov ah, 2ch
	;int 21h
	;Cuvanje vremena 
	;mov byte[ds:hours], ch
	;mov byte[ds:minutes], cl
	;mov byte[ds:seconds], dh

	;ovde se sigurno nece izvrsiti jos jedan 21h paralelno
	call ucitaj_vreme
	
	call pocetak
	jmp kraj

;racunanje pozicije (ofsetna adresa u video memoriji) na osnovu varijabli red i kolona
;izracunata vrednost je smestena u varijabli pozicija	
izracunaj_poziciju:
	push ax
	push bx
	;postavljanje "kursora"
	mov al, [red]
	mov bl, 160
	mul bl 
	mov [pozicija], ax
	mov al, [kolona]
	mov bl, 2
	mul bl
	add [pozicija], ax
	pop bx
	pop ax
	ret
	
	
	
	
pocetak:
	pusha
	
	call izracunaj_poziciju
	
_ispis_vremena:
	
	
	;ispis sati
	mov ah, 0
	mov al, byte[ds:hours]
	call ucitaj_broj
	mov bx, [pozicija]
	mov si, broj
	call ispis_u_video
	mov si, dve_tacke
	call ispis_u_video
	
	;ispis minuta
	mov ah, 0
	mov al, byte[ds:minutes]
	call ucitaj_broj
	mov si, broj
	call ispis_u_video
	mov si, dve_tacke
	call ispis_u_video
	
	;ispis sekundi
	mov ah, byte[ds:seconds]
	mov al, ah
	mov ah, 0
	call ucitaj_broj
	mov si, broj
	call ispis_u_video	
	
	cmp [ds:registri_stack], byte 0
	je sad_stek
	
sad_registri:
	call ispis_registara
	jmp sad_peek
sad_stek:	
	call ispis_steka
sad_peek:
	cmp [is_peek], byte 0
	je izlaz_is_ispisa
	
	call ispis_peek
	
izlaz_is_ispisa:	
	popa
	ret
	

;Kraj programa, vraca kursor tamo gde je i bio
kraj:
	;pop dx
	;mov ah, 02h
	;int 10h
	call install_2fh
	call install_1ch

	;09h je na kraju jer sam tu stavio da se da program ostane u rezidentnom delu, malo glupavo, ali me mrzi da menjam sad
	call install_09h
	;ret
	
	
segment .data
kolona: 		db 70 ;kolona stampanja
red: 			db 0 ;red stampanja
pozicija:		dw 0 ;ofsetni deo video memorije koji racunamo na osnovu reda i kolone

dve_tacke: 		db ':', 0

hex_code: 		db 0, 0,0,0, 0
hex_char:		db 'h',0
broj:			db 0,0,0,0,0,0

string_id:		db 'Antic je bio ovde!', 0
FuncID:			db 0
es_tmp:			dw 0


obrisan:		db 0
%include "pomocne/broj.asm"
%include "pomocne/ekran.asm"
%include "pomocne/bin2hex.asm"
%include "pomocne/9h.asm"
%include "pomocne/2fh.asm"
%include "pomocne/1ch.asm"
%include "pomocne/str2hex.asm"
%include "pomocne/sys_int.asm"
%include "registri.asm"
%include "stek.asm"
%include "cmd.asm"
%include "peek.asm"