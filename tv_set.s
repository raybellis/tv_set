.include	"bbc.inc"
.listbytes	unlimited

.macro		pushregs
		pha
		txa
		pha
		tya
		pha
.endmacro

.macro		pullregs
		pla
		tay
		pla
		tax
		pla
.endmacro

.segment "STARTUP"

.segment "CODE"

.org		$8000

.scope
		.byte		0, 0, 0
		jmp		ServiceEntry
		.byte		$82			; 6502
		.byte		<_copyright - 1		; offset
		.byte		$02			; version 02
		.asciiz		"TV SET"
		.asciiz		"0.3"
_copyright:	.asciiz		"(C) Ray Bellis"
.endscope


ServiceEntry:	cmp		#$01
		beq		SrvWorkSpace
		cmp		#$09
		beq		SrvHelp
		rts

SrvWorkSpace:
.scope 
		pushregs

		; check for break type - 0 = soft, 1 = pwr, 2 = hard
		osbyte		243, 0, 255
		txa
		beq             Return

		; issue *TV 255, 1 command
		tv		255, 1

		; read keyboard switches -> X
		osbyte		255, 0, 255

		; set mode accordingly
		lda		#22
		jsr		OSWRCH

		txa
		and		#7
		jsr		OSWRCH

.endscope

Return:		pullregs
		rts

SrvHelp:
.scope
		pushregs
		lda		($f2), y
		cmp		#13
		bne		_done
		jsr		PrintVersion
_done:		jmp		Return
.endscope
		
.proc		PrintVersion
		ldx		#$00
_loop:		lda		_version, x
		beq		_done
		jsr		OSASCI
		inx
		bne		_loop
_done:		rts

_version:	.byte		13, "TV Mode Set v0.3", 13, 0
.endproc
