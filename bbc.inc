;
; MOS Entry points
;

.define		OSRDCH		$ffe0
.define		OSASCI		$ffe3
.define		OSNEWL		$ffe7
.define		OSWRCH		$ffee
.define		OSWORD		$fff1
.define		OSBYTE		$fff4

.macro		osbyte		ra, rx, ry
		lda		#ra
		ldx		#rx
		ldy		#ry
		jsr		OSBYTE
.endmacro

.macro		tv		rx, ry
		osbyte		$90, rx, ry
.endmacro
