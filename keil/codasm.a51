; Definirea pinilor conectati la microcontroller
ADCPIN equ P1	; P1 este conectat la ADC
LCDPIN equ P2	; P2 este conectat la LCD
RS equ P3.0     ; P3.0 pin RS al LCD-ului
RW equ P3.1     ; P3.1 pin RW al LCD-ului
EN equ P3.4     ; P3.4 pin EN al LCD-ului
EOC equ P3.5    ; P3.5 pin EOC al ADC-ului
START equ P3.6  ; P3.6 pin START al ADC-ului
OE equ P3.7     ; P3.7 pin OE al ADC-ului
B_PLUS equ P3.2 ; P3.2 buton increment temp setata
B_MINUS equ P3.3; P3.3 buton decrement temp setata
RELEU equ P0.3  ; P0.3 releu
temp_setata_partea_intreaga equ 31h ; alocare memorie la 31h. valoarea intreaga setata 21
temp_setata_partea_fractionara equ 32h ; alocare memorie la 32h. valoarea fractionara setata 2 => val setata: 21.2
temp_citita_partea_intreaga equ 33h ; alocare memorie la 33h pt valoarea intreaga citita
temp_citita_partea_fractionara equ 34h ; alocare memorie la 34h pt valoarea fractionara citita
	
ORG 0000h
LJMP init
	
ORG 0003h
	acall intrerupere_increment
	reti

ORG 0013h
	acall intrerupere_decrement
	reti

init:
    mov a, #38h
    acall LCD
    acall delay
    mov a, #0Eh
    acall LCD
    acall delay
    mov a, #01h
    acall LCD
    acall delay

	mov a, #38h      ; Setare mod 8-bit, 2 linii, caractere 5x7
	acall LCD
	acall delay
	mov a, #0Eh      ; Pornire display, cursor activ
	acall LCD
	acall delay
	mov a, #01h      ; sterge display-ul
	acall LCD
	acall delay

	mov temp_setata_partea_intreaga, #21
	mov temp_setata_partea_fractionara, #4

	; initializare mesaje dispaly
	; Temp:   
	mov a, #80h      
	acall LCD
	acall delay
	mov a, #'T'
	acall write
	acall delay
	mov a, #'e'
	acall write
	acall delay
	mov a, #'m'
	acall write
	acall delay
	mov a, #'p'
	acall write
	acall delay
	mov a, #':'
	acall write
	acall delay
	mov a, #89h
	acall LCD
	acall delay
	mov a, #0DFh
	acall write
	acall delay
	mov a, #'C'
	acall write 
	acall delay

	;Setat:
	mov a, #0C0h
	acall LCD
	acall delay
	mov a, #'S'
	acall write
	acall delay
	mov a, #'e'
	acall write
	acall delay
	mov a, #'t'
	acall write
	acall delay
	mov a, #'a'
	acall write
	acall delay
	mov a, #'t'
	acall write
	acall delay
	mov a, #':'
	acall write
	acall delay
	mov a, temp_setata_partea_intreaga
	acall convert_hex_dec
	acall convert_dec_ascii
	mov a, R0
	acall write
	acall delay
	mov a, R1
	acall write
	acall delay
	mov a, #'.'
	acall write
	acall delay
	mov a, temp_setata_partea_fractionara ; se ia val fractionara
	acall convert_hex_dec
    acall convert_dec_ascii
	mov a, R1
    acall write
    acall delay
	mov a, #0DFh
	acall write
	acall delay
	mov a, #'C'
	acall write 
	acall delay
	
	mov IE, #10000101b  ; setare intreruperi
    ;bit 7:EA=1 (Enable global interrupts)
    ;bit 2: EX1=1 (Enable INT1)
    ;bit 0: EX0=1 (Enable INT0)
    
    mov TCON, #00000101b
    ;bit 2: IT1=1 (INT1 pe flanc negativ)
    ;bit 0: IT0=1 (INT0 pe flanc negativ)
	
	ljmp main

main:
    ; Citire temperatura reala
    acall adc
    mov R5, A      ; Salvam temperatura reala in R5
    acall convert
    acall convert_hex_dec
    acall convert_dec_ascii

    ; Afiseaza temperatura pe linia 1
	mov a, #85h ; punem cursorul pe pozitie
	acall LCD ; initializam comanda
	acall delay
	
    mov a, R0 ; punem valoarea zecilor in a
    acall write
    acall delay
	mov a, R1 ; punem valoarea unitatilor in a
    acall write
    acall delay
	mov a, #'.'
    acall write
    acall delay
    mov a, R3 ; punem valoarea fractionara in a
    acall write
    acall delay
	
	acall verificare_releu
	
    ljmp main

LCD:
	mov LCDPIN, a 	 ; Scrie comanda in portul P2
	clr RS           ; RS=0  comanda
	clr RW           ; RW=0  scriere
	setb EN          ; EN=1  activeaza trimiterea
	acall delay
	clr EN           ; Dezactiveaza semnalul EN
	ret

write:
	mov LCDPIN, a	 ; Scrie caracterul în portul P2
	setb RS          ; RS=1 date (caracter)
	clr RW           ; RW=0  scriere
	setb EN
	acall delay
	clr EN
	ret

delay:
	mov R2, #255     
again:
	djnz R2, again   
	ret

convert:
    mov A, R5         ; valoarea citita este salvata in main pe registrul 5
    mov B, #27
    mul AB            ; A*27, 35-8 = 27, deci rezultat pe 16 biti: B = MSB, A = LSB
	
    push B            ; salvam MSB (partea intreaga inainte de offset +8)
    
    mov B, #10
    mul AB            ; (LSB * 10) si ajunge B = fractiune (între 0 si 9)
    mov A, B
	mov temp_citita_partea_fractionara, A
    add A, #30h       ; il convertesc direct in ASCII
    mov R3, A         ; si se pune rezultaul in registrul 3

    pop B             ; luam MSB din nou (partea intreaga fara offset 8)
    mov A, B
    add A, #8         ; adaugam offsetul temperaturii
	mov temp_citita_partea_intreaga, A
    ret

convert_hex_dec:
	mov b, #10 ; din hexa in zecimal
	div ab
	ret

convert_dec_ascii:
	add a, #30h
	mov r0, a
	mov a, b
	add a, #30h;	
	mov r1, a
	ret
	
convert_ascii_dec:
	mov b, #30h
    subb a, b
    mov r7, a
    ret
	
adc:
	setb START       ; Porneste conversia ADC
	acall delay		 ; Se asteapta
	acall asteapta	 ; Asteapta terminarea conversiei

asteapta:
	clr START		 ; Sterge bit START (LOW)
	jnb EOC, asteapta; Asteapta finalizarea conversiei
	acall delay		 ; Delay
	mov a, ADCPIN	 ; Citeste valoarea ADC de pe portul P1
	ret
	
	

intrerupere_increment:
	mov A, temp_setata_partea_intreaga
	cjne A, #35, increment_normal ; verifica limita maxima (35). Daca este 35, se ignora intreruperea
	ret  ; Daca e exact 35, nu incrementa
		
	increment_normal:
		mov A, temp_setata_partea_fractionara
		add A, #2 ; incrementeaza p.fractionara cu 2
		cjne A, #10, update_fraction ; daca p.frac nu este 10, se actualizeaza
		
		; Daca se ajunge aici, atunci p.fractionara = 10, incrementeaza p.intreaga si reseteaza p.fractionara
		mov temp_setata_partea_fractionara, #0
		mov A, temp_setata_partea_intreaga
		inc A
		cjne A, #36, update_integer  ; verifica sa nu depaseasca 35, in teorie nu ar trebui sa ajunga aici never
		mov temp_setata_partea_intreaga, #35 ; dar daca ajunge, resetam valoarea la cea maxima
		mov temp_setata_partea_fractionara, #0 ; resetam si p.fractionara
		ret ; inchidem intreruperea

intrerupere_decrement:
    ; Verificare: daca partea intreaga <= 8
    mov A, temp_setata_partea_intreaga
    clr C ; stergere carry
    subb A, #8 ; daca e sub, inseamna carry.
    jc check_frac		  ; daca A < 8 => carry, se poate iesi direct... dar oricum se apeleaza check_frac daca e 8 sau sub 8 si se iese acolo
    jz check_frac         ; daca A == 8, verificam partea fractionara
	
	decrement_normal:
		; decrementeaza p.fractionara cu 2
		mov A, temp_setata_partea_fractionara
		jz borrow_from_integer ; daca este 0, se apeleaza rutine de "imprumut" din partea intreaga
		clr C ; sterge carry
		subb A, #2 ; se decrementeaza cu 2
		jnc update_fraction ; daca nu carry, update

	borrow_from_integer:
		; daca p.fractionara < 2, "imprumuta" de la partea intreaga
		mov temp_setata_partea_fractionara, #8 ; si reinitializam cu 8 (ofc... prea mult am stat s-o gandesc pe asta)
		mov A, temp_setata_partea_intreaga
		dec A
		cjne A, #7, update_integer  ; verifica sa nu scada sub 8, dar daca scade se apeleaza chestiuta de mai jos
		mov A, #8 ; chestiuta de mai jos, daca a dat fail verificare jc si jz check_frac, reinitializeaza la 8 (redundant, stiu... dar am stat prea mult aici)
		mov temp_setata_partea_fractionara, #0 ; reinitializam si partea frac daca a dat fail partea intreaga, ofc
		sjmp update_integer ; in teorie nu e necesar, dar again... REDUNDANTAAAA

		mov temp_setata_partea_intreaga, A
		mov A, temp_setata_partea_fractionara
		add A, #10
		subb A, #2
		mov temp_setata_partea_fractionara, A
		acall afisare_temp_setata ; update display
		ret
	check_frac:
		mov A, temp_setata_partea_fractionara
		jz too_small         ; daca e 0, inseamna ca am ajuns la 8.0
		clr C
		subb A, #1
		jc too_small         ; daca e mai mic decat 1 (adica 0)

		sjmp decrement_normal ; altfel sarim la decrement normal
	too_small: ; reinitializare valori, redundant... Pentru ca oricum nu am dat update la variabile
		mov temp_setata_partea_intreaga, #8 ; redundantttt
		mov temp_setata_partea_fractionara, #0 ; also this... redundaaant
		acall afisare_temp_setata ; redundant also, pt ca nu tre sa schimbam nimic daca tot "iesim"
		;din ce se vede... mai are sens aceasta subrutina sa fie ? Direct ret :D But, la cat de multe bug-uri am inghitit, sa fie.
		ret
;update_fraction cu update_integer pot sa fie o singura subrutina. Dar am lasat asa ca mi s-a luat de bug-uri
update_fraction:
	mov temp_setata_partea_fractionara, A ; se seteaza partea frac din acc
	acall afisare_temp_setata ; update display
	ret
		
update_integer:
	mov temp_setata_partea_intreaga, A 	; se seteaza partea intreaga din acc
	acall afisare_temp_setata ; update display
	ret ; se returneaza rutina pt reti

verificare_releu:
    mov A, temp_citita_partea_intreaga               ; A - temp curenta intreaga
    clr C
    subb A, temp_setata_partea_intreaga              ; A - temp setata intreaga
    jc temp_mai_mica         						 ; daca A < 0 => temp_citita < temp_setata
    jnz reseteaza_releu       						 ; daca A > 0 => temp_citita > temp_setata

    ; daca partile intregi ale temperaturii sunt egale, verificam partea fractionara
    mov A, temp_citita_partea_fractionara            ; partea fractionara citita
    clr C
    subb A, temp_setata_partea_fractionara           ; A = frac_citita - frac_setata
	jc temp_mai_mica         					   	 ; daca frac_citita < frac_setata => porneste releul
    jz reseteaza_releu          					 ; daca sunt egale => releu oprit
    sjmp reseteaza_releu      						 ; daca frac_citita > frac_setata => oprire releu

	temp_mai_mica:
		; Calculam temperatura setata - 0.2 (toleranta)
		mov A, temp_setata_partea_fractionara        ; partea fractionara setata
		clr C
		subb A, #2               					 ; A = partea fractionara setata - 2
		jnc toleranta_directa	 					 ; daca nu e 0 sa se imprumute un intreg

		; imprumutam de la partea intreaga daca p.frac.setata < 0
		mov A, temp_setata_partea_intreaga           ; partea intreaga setata
		dec A                    					 ; se scade 1 din partea intreaga
		mov B, A                 					 ; B = p.intreaga - 1
		mov A, #10
		add A, temp_setata_partea_fractionara        ; A = 10 + p.frac.setata
		subb A, #2              					 ; A = A - 2 (=> toleranta pe frac)
		mov R0, B               					 ; salvam partea intreaga temperatura setata - 1 in registrul 0
		mov R1, A               					 ; salvam partea frac ajustata in registrul 1
		sjmp compara_toleranta

	toleranta_directa:
		mov R0, temp_setata_partea_intreaga          ; R0 = temperatura intreaga setata
		mov R1, A               					 ; R1 = temperatura fractionara setata - 2

	compara_toleranta:
		; se compara temperatura citita cu temperatura setata - 0.2 (R0:R1)
		mov A, temp_citita_partea_intreaga           ; intreaga citita
		clr C
		subb A, R0
		jc seteaza_releu
		jnz reseteaza_releu

		; daca intregii is egali, verificam fractiunile
		mov A, temp_citita_partea_fractionara
		clr C
		subb A, R1
		jc seteaza_releu
		jz seteaza_releu
		sjmp reseteaza_releu

	seteaza_releu:
		setb RELEU
		ret

	reseteaza_releu:
		clr RELEU
		ret

afisare_temp_setata: ; folosita in intreruperi
	mov a, #0C6h	 ; setare cursor la dupa Setat:
	acall LCD		 ; se da comanda la lcd
	acall delay		 ; delay
	
	mov a, temp_setata_partea_intreaga ; punem in a valoarea intreaga
	acall convert_hex_dec ; extragem din hex in zecimal
	acall convert_dec_ascii ; din zecimal in ascii
	mov a, R0		 ; registrul 0 are zecile
	acall write		 ; se scriu datele pe lcd
	acall delay		 ; delay pt lcd
	mov a, R1 		 ; in registrul 1 sunt zecile
	acall write	
	acall delay
	mov a, #'.'		 ; virgula pe lcd
	acall write
	acall delay
	mov a, temp_setata_partea_fractionara ; se ia val fractionara
	acall convert_hex_dec
    acall convert_dec_ascii
	mov a, R1
    acall write
    acall delay
	mov a, #0DFh
	acall write
	acall delay
	mov a, #'C'
	acall write 
	acall delay
	mov a, #' ' ; de aici, stergem artefactele. Apar cateodata, nu-mi explic de ce
	acall write 
	acall delay
	mov a, #' '
	acall write 
	acall delay
	mov a, #' '
	acall write 
	acall delay
	mov a, #' '
	acall write 
	acall delay
	
	ret
end