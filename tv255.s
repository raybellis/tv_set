OSASCI = $ffe3
OSNEWL = $ffe7
OSWRCH = $ffee
OSBYTE = $fff4

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

		.byte		0, 0, 0
		jmp		ServiceEntry
		.byte		$82
		.byte		.lobyte(_cc) - 1
		.byte		$02		; version 02
		.asciiz		"TV255"
		.asciiz		"0.2"
_cc:		.asciiz		"(C) Ray Bellis"

ServiceEntry:	cmp		#$01
		beq		SrvWorkSpace
		cmp		#$09
		beq		SrvHelp
		rts

SrvWorkSpace:
.scope 
		pushregs

		; check for break type
		lda		#$fd
		ldx		#$00
		ldy		#$ff
		jsr		OSBYTE
		txa
		beq		Return

		; hard break or reset - emit empty line
		jsr		OSNEWL

		; issue *TV 255, 0 command
		lda		#$90
		ldx		#$ff
		ldy		#$00
		jsr		OSBYTE
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

_version:	.byte		13, "TV255 Mode Set v0.2", 13, 0
.endproc
