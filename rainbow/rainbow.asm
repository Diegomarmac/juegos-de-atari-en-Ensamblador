	processor 6502
	
	include "vcs.h"
	inlcude "macro.h"

	seg code
	org $F000

Start:
	CLEAN_START	; Macro para limpiar de forma segura la memoria y la TIA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Start a new fram by turning on Vblank and Vsync
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NextFrame:
	lda #2		; el mismo valor binario que %00000010
	sta VBLANK 	; activa Vblank
	sta VSYNC	; activa Vsync
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generate the three lines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	sta WSYNC	; first scanline
	sta WSYNC	; second scanline
	sta WSYNC	; third scanline

	lda #0
	sta VSYNC 	; tunf off VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Let the TIA output the recommended 37 scanlines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	ldx #37		; X = 37 (para contar 37 scanlines)

LoopVBlank:
	sta WSYNC	; hit WSYNC and wait for the next scanline
	dex		; x--
	bne LoopVBlank	; loop while x != 0

	lda #0
	STA VBLANK	; TURN OFF VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw 192 visible scanlines (kernel)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldx #192	; counter for 192 visible scanlines

LoopVisible:

	stx COLUBK	; Set the background color
	sta WSYNC	; wait fot the next scanline
	dex		; x--
	bne LoopVisible ; loop while x!=0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Output 30 more VBLANK lines (overscan) to complete our frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #2		; hit and turn on Vblank again
	sta VBLANK
	
	ldx #30		; counter for 30 scanlines

LoopOverscan:

	sta WSYNC	;wait for the next scanline
	dex
	bne LoopOverscan ; Loop while x!=0

	jmp NextFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Complete my ROM size to 4kb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org $FFFC
	.word Start
	.word Start
