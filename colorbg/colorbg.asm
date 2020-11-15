	processor 6502

	include "vcs.h"
	include "macro.h"

	seg code
	org $F000	; Definimos el origen del ROM en $F000
	
START:

	;CLEAN_START	; Macro para limpiar de forma segura la memoria
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Set background luminosity color to yellow   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #$1E	; LOAD el color en A ($ 1E es amarillo en NTSC)
	sta COLUBK	; STORAGE A en la direccion $09
	
	jmp START	; Repetimos desde START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Fill ROM siza exactly 4kb   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org $FFFC	; Definimos como origen la direccion $FFFC
	.word START	; Reset el vector a $FFFC 
	.word START	; Interrumpe el vector en $FFFE (unsued in the VCS)
