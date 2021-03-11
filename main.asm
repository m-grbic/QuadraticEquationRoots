;*****************resenja kvadratne jednacine***************************************
	.bss	x1,1
	.bss	x2,1
;*****************koeficijenti kvadadratne jednacine***************************************
	.bss	a,1
	.bss	b,1
	.bss	c,1
; diskriminanta je 32-bitna pa je cuvamo u dve razlicite promenljive
	.bss	Dhigh,1	;	D31:D16
	.bss	Dlow,1	;	D15:D0
	.bss	tl,1
	.bss 	th,1
	.bss	tlh,1
	.bss	znak,1
	.bss    deljenik,1
	.bss 	ostatak,1 
	.bss	tmp,1
	.bss    indikator,1
;*****************promenljive za racunanje korena diskriminante*****************************
	.bss   koren,1         ; Tekuca pretpostavka o rezultatu
	.bss   Dsqrt,1   ; Sqrt(argument)
	.bss   klizbit,1   ; Postavljen je na 1 onaj bit koji se upravo testira. 

; pocetak koda

	.text
	.global _c_int0  

; inicijalizacija

_c_int0: 

	CLRC  CNF
	SPM   0    
	SETC  SXM		; ukljucena je ekstenzija znaka
	SETC  OVM		; ukljuceno je prekoracenje
	LDP   #2h               

	lacc	#1000h
	sacl	a
	lacc	#1000h
	sacl	b
	lacc	#0400h
	sacl	c

;***********proveravano da li su i a i b i c jednaki nuli
	lacc	a
	add	b
	add	c
	bz	sistem_je_nemoguc


;*********** proveravamo da li su parovi koeficijenata jednaki nuli
;***********proveravamo da li su i a i b jednaki nuli
	lacc	a
	bz	ab0
ab0:
	lacc	b
	bz	sistem_je_nemoguc
;***********proveravamo da li su i b i c jednaki nuli
	lacc	b
	bz	bc0
bc0:
	lacc	c
	bz	resenja_su_nule
;***********proveravamo da li su i c i a jednaki nuli
	lacc	c
	bz	ca0
ca0:
	lacc	a
	bz	resenja_su_nule

;***********proveramo da li su pojedinacno koeficijenti jednaki nuli
;***********provera da li je a=0
	lacc	a
	bz	a0
;***********provera da li je b=0
	lacc	b
	bz	b0
;***********provera da li je c=0
	lacc	c
	bz	c0

;***********racunanje diskriminante
; koeficijent c se koristi samo jednom u toku racuna, tako da cemo najpre uraditi negaciju 4*c, kako bi oslobodili ACC za cuvanje determinante

	lacc c
	neg
	sacl c
	lt	a
	mpy c
	pac
	sach th
	sacl tl
	
	lacc th,2
	sacl th
	lacc tl,2
	sach tlh
	sacl tl
	
	lacc tlh
	add  th
	sacl th
	

	lacc th,16
	add  tl
	
;	racunamo b^2	
	lt	b
	mpy	b
	apac

;	dobili smo b^2-4*a*c na akumulatoru
; rezultat je 32bit, cuvamo odvojeno prvih 16 bita i poslednjih 16 bita
	sach	Dhigh
	sacl	Dlow

;***********provera diskriminante
	bgz	normalno_racunanje
	bz	dvostruko_realno_resenje
	b	imaginarna_resenja

;**********resenje je -b/(2a), pa uzimamo da nam je deljenik=-b, a delioc 2a
dvostruko_realno_resenje:
	lacc  b
	neg
	sacl  deljenik
	lacc  #-1
	sacl  indikator

; kod deljenja i u slucaju dvostrukog resenja i u slucaju dva resenja, delimo deljenik sa 2*a, tako da je promenljiva samo deljenik
deljenje:

	lt	deljenik
	mpy	a
	sph	znak

	lacc	deljenik
	abs
	sacl	deljenik

	lacc	a
	abs
	sacl	a

	lacc	deljenik
	rpt	    #15
	subc	a

    sacl  x1
    sach  ostatak
    lacc  x1,12
    sacl  x1
	
; racunanje cifara iza decimalne tacke
    lacc  ostatak,1
    rpt   #15
    subc  a
      
    sacl  tmp
    sach  ostatak
    lacc  tmp,11
    sacl  tmp
    lacc  tmp
    add   x1
    sacl  x1


    lacc  ostatak,1
    rpt   #15
    subc  a
      
    sacl  tmp
    sach  ostatak
    lacc  tmp,10
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp,9
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp,8
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp,7
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp,6
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp,5
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp,4
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp,3
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp,2
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp,1
	sacl  tmp
	lacc  tmp
	add   x1
	sacl  x1


	lacc  ostatak,1
	rpt   #15
	subc  a
      
	sacl  tmp
	sach  ostatak
	lacc  tmp
	add   x1
	sacl  x1
	  
	lacc  x1,15
	sach	x1
	
	lacc  znak
    bgez  Nemoj_Menjati_Znak ; Branch (if) Greater (or) EQ 0

Znak_je_negativan:
	lacc  x1
	neg
	sacl  x1
	
Nemoj_Menjati_Znak:
	
	lacc  indikator
	bgz   kraj_deljenja_za_razlicita_realna_resenja
	bz    KRAJ
; u slucaju dvostrukog resenja, indikator je inicijalizovan na -1, pa rezultat x1 samo prepisujemo u x2
	lacc  x1
	sacl  x2
	b     KRAJ
	
	
normalno_racunanje:

; racunamo kvadratni koren iz diskriminante

   lacc  #0
   sacl  koren     ;Pocetna pretpostavka o resenju. 

 
   lacc  #0000000010000000B   ; lacc #0080h
   sacl  klizbit

petlja_high:
   
   lacc  koren
   or    klizbit
   sacl  koren          

   lt    koren
   mpy   koren
   pac             
   sub   Dhigh  
   bgz   Vrati_bit_na_nulu_high

Treba_ovaj_bit_da_ostane_na_jedinici_high:

   b     Zavrsen_test_sa_shift_klizbit_high

Vrati_bit_na_nulu_high:

   lacc  klizbit    
   cmpl              
   and   koren
   sacl  koren

Zavrsen_test_sa_shift_klizbit_high:

   lacc  klizbit,15
   sach  klizbit

   lacc  klizbit
   bz    Gotovo_je_high

   b     petlja_high
   
Gotovo_je_high: ; sada racunamo za low deo koren diskriminante
   lacc koren,8
   sacl Dsqrt

   CLRC  SXM
   lacc  #0
   sacl  koren     ;Pocetna pretpostavka o resenju. 

 
   lacc  #0000000010000000B   ; lacc #0080h
   sacl  klizbit

petlja_low:
   
   lacc  koren
   or    klizbit
   sacl  koren          

   lt    koren
   mpy   koren
   pac             
   sub   Dlow
   bgz   Vrati_bit_na_nulu_low
   
Treba_ovaj_bit_da_ostane_na_jedinici_low:

   b     Zavrsen_test_sa_shift_klizbit_low

Vrati_bit_na_nulu_low:

   lacc  klizbit    
   cmpl              
   and   koren
   sacl  koren

Zavrsen_test_sa_shift_klizbit_low:

   lacc  klizbit,15
   sach  klizbit

   lacc  klizbit
   bz    Gotovo_je_low

   b     petlja_low

Gotovo_je_low:
   lacc Dsqrt
   add koren
   sacl Dsqrt
   
   SETC  SXM
; racunanje x1 i x2 

   lacc b
   neg
   add	Dsqrt
   sacl deljenik
   lacc #1
   sacl indikator
   b    deljenje

   
kraj_deljenja_za_razlicita_realna_resenja:
; u x1 je sacuvano  -b+sqrt(D) 
   lacc x1
   sacl x2 
   lacc	b
   neg
   sub	Dsqrt
   sacl deljenik
   lacc #0
   sacl indikator
   b	deljenje 


KRAJ:

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

END

 

	