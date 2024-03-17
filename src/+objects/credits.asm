
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		+objects/credits.asm
//	Contents:	Credits object
//
// ---------------------------------------------------------------------

ObjCredits:
	phk
	plb

	lda.w	#ObjCredits_Main		// Next routine
	staSST(oAddr)
	lda.w	#ObjCredits_Main>>8
	staSST(oAddr+1)
	lda.w	#$A0				// Set X position
	staSST(oX)
	lda.w	#$70				// Set Y position
	staSST(oY)
	lda.w	#MapSpr_Credits			// Set mappings
	staSST(oMap)
	lda.w	#MapSpr_Credits>>8
	staSST(oMap+1)
	lda.w	#$31A0				// Set base tile
	staSST(oTile)
	sep	#P_A
	lda.b	#$00
	staSST(oRender)				// Set render flags
	staSST(oPrio)				// Set priority
	rep	#P_A

	lda.l	r_Scene				// Are we in the title screen?
	and.w	#$FE
	cmp.w	#sceneTitle
	bne	ObjCredits_Main			// If not, branch

	lda.w	#$30C0				// Set base tile
	staSST(oTile)
	sep	#P_A
	lda.b	#$0a				// Set sprite frame
	staSST(oFrame)
	rep	#P_A

// ---------------------------------------------------------------------

ObjCredits_Main:
	phk
	plb
	jml	DisplayObject			// Display sprite

// ---------------------------------------------------------------------
