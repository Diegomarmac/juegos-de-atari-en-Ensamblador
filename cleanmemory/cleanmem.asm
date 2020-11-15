	processor 6502
	
	seg code
	org $F000	; define the code origin at $F000

Start:
	sei		; disable interrupts
	cld		; disable the BCD decimal math mode
	ldx #$FF	; loads the X registar with #$FF
	txs		; transfer X register to S(tack) register

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear the Zero Page regin ($00 to $FF)
; Meaning the entire TIA register space and also RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #0		; A = 0
	ldx #$FF	; X = #$FF
        STA $FF         ; make sure $FF is zero before the loop start
MemLoop:
	dex		; x--
	sta $0,X	; store A register at ddress $0 + X
	bne MemLoop	; loop until X==0 (z-flag set)
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill ROM size to exactly 4kB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org  $FFFC
	.word Start	; reset vector at $FFFC (where my program starts)
	.word Start	; interrupt vector at $FFFE (unused in VCS)
