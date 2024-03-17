
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		title/objects/sonic/main.asm
//	Contents:	Title screen Sonic object
//
// ---------------------------------------------------------------------

ObjTtlSonic:
	phk
	plb

	lda.w	#ObjTtlSonic_Main		// Next routine
	staSST(oAddr)
	lda.w	#ObjTtlSonic_Main>>8
	staSST(oAddr+1)
	lda.w	#$70				// Set X position
	staSST(oX)
	lda.w	#$5E				// Set Y position
	staSST(oY)
	lda.w	#MapSpr_TtlSonic		// Set mappings
	staSST(oMap)
	lda.w	#MapSpr_TtlSonic>>8
	staSST(oMap+1)
	lda.w	#$3200				// Set base tile
	staSST(oTile)
	lda.w	#30-1				// Set delay to a half second
	staSST(oAniTime)
	sep	#P_A
	lda.b	#$00				// Set priority
	staSST(oPrio)
	rep	#P_A

// ---------------------------------------------------------------------

ObjTtlSonic_Main:
	phk
	plb

	ldaSST(oAniTime)			// Get delay time
	dec					// Decrement it
	staSST(oAniTime)
	cmp.w	#$00
	bpl	+				// If time remains, branch
	lda.w	#ObjTtlSonic_Move		// Next routine
	staSST(oAddr)
	lda.w	#ObjTtlSonic_Move>>8
	staSST(oAddr+1)
	jml	DisplayObject			// Display sprite
+
	rtl

// ---------------------------------------------------------------------

ObjTtlSonic_Move:
	phk
	plb

	ldaSST(oY)				// Move Sonic up
	sec
	sbc.w	#$08
	staSST(oY)
	cmp.w	#$16				// Has Sonic reached the final position?
	bne	+				// If not, branch
	lda.w	#ObjTtlSonic_Animate		// Next routine
	staSST(oAddr)
	lda.w	#ObjTtlSonic_Animate>>8
	staSST(oAddr+1)
	lda.w	#$001F				// Update sprite mask height
	sta.l	r_HDMA_Buf_1+2
	lda.w	#$FF1F
	sta.l	r_HDMA_Buf_2+2
+
	jml	DisplayObject			// Display sprite

// ---------------------------------------------------------------------

ObjTtlSonic_Animate:
	phk
	plb

	jml	DisplayObject			// Display sprite

// ---------------------------------------------------------------------
