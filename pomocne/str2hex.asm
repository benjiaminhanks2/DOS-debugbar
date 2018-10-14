; ------------------------------------------------------------------
; hex_string_to_hex -- Konvertuje heksadecimalni string u int
; Ulaz: SI = pocetak stringa
; Izlaz: AX = celobrojna vrednost (int)
; -------------------------------------------------------------------
hex_string_to_int:
        pusha
        mov     ax, si                      ; Duzina stringa
		; u ax stavi duzinu stringa 
        call    _string_length				
        add     si, ax                      ; Pocinjemo od znaka sa krajnje desne strane
        dec     si
        mov     cx, ax                      ; Duzina stringa se koristi kao brojac znakova
        mov     bx, 0                       ; U BX ce biti trazena celobrojna vrednost
        mov     ax, 0

      ; Racunamo hdecimalnudecimalnu vrednost kod pozicionog sistema sa osnovom 16        

        mov word [multiplikator], 1        ; Prvi znak mnozimo sa 1
Sledeci:
		mov     ax, 0
        mov byte al, [si]                   ; Uzimamo znak
		
		; proveravamo da li je cifra od 0 do 9
		cmp al, 57	;9
		jg proveri_veliko_slovo
		cmp al, 48	;0
		jl greska
		jmp cifra
		
		proveri_veliko_slovo:
		cmp al, 70		;F
		jg proveri_malo_slovo
		cmp al, 65		;A
		jl greska
		jmp veliko_slovo
		
		proveri_malo_slovo:
		cmp al, 102 	;f
		jg greska 
		cmp al, 97		;a
		jl greska
		jmp malo_slovo
		
		malo_slovo:
		sub     al, 97
		add al, 10
		jmp dalje
		
		veliko_slovo:
		sub     al, 65
		add al, 10
		jmp dalje
		
		cifra: 
		sub     al, 48                      ; Konvertujemo iz ASCII u broj
		jmp dalje
		
		
		dalje:
        ;sub     al, 48                      ; Konvertujemo iz ASCII u broj
        mul word [multiplikator]           ; Mnozimo sa pozicijom
        add     bx, ax                      ; Dodajemo u BX
        push    ax                          ; Mnozimo multiplikator sa 16
        mov word ax, [multiplikator]
        mov     dx, 16
        mul     dx
        mov word [multiplikator], ax
        pop     ax
        dec     cx                          ; Da li ima jos znakova
        cmp     cx, 0
        je     Izlaz
        dec     si                          ; Pomeramo se na sledecu poziciju ulevo
        jmp    Sledeci
Izlaz:
        mov word [tmp], bx                 ; Privremeno cuvamo dobijeni int zbog 'popa'
        popa
        mov word ax, [tmp]
        ret

       multiplikator   dw 0  
       tmp             dw 0
	   
	   greska:
	   ; ispis poruke
	   ret 

; ------------------------------------------------------------------
; _string_length -- Vraca duzinu stringa
; Ulaz: AX = pointer na pocetak stringa
; Izlaz: AX = duzina u bajtovoma (bez zavrsne nule)
; ------------------------------------------------------------------

_string_length:
        pusha
        mov     bx, ax                      ; Adresa pocetka stringa u BX
        mov     cx, 0                       ; Brojac bajtova
Dalje:
        cmp byte [bx], 0                    ; Da li se na lokaciji na koju pokazuje 
        je     Kraj                        ; pointer nalazi nula (kraj stringa)?
        inc     bx                          ; Ako nije nula, uvecaj brojac za jedan
        inc     cx                          ; i pomeri pointer na sledeci bajt.
        jmp    Dalje
Kraj:
        mov word [TmpBrojac], cx           ; Privremeno sacuvati broj bajtova
        popa                                ; jer vacamo sve registre sa steka (tj. menjamo AX).
        mov     ax, [TmpBrojac]            ; Vracamo broj bajtova (duzinu stringa) u AX.
        ret

       TmpBrojac    dw 0