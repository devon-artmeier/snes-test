
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		main.asm
//	Contents:	Main source
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Bank 1
// ---------------------------------------------------------------------

	rombank(1)

// ---------------------------------------------------------------------
// Libraries
// ---------------------------------------------------------------------

	include	"_lib/ppu.asm"			// PPU functions
	include	"_lib/int.asm"			// Interrupt functions

// ---------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------

Main:
	phk					// Data bank = program bank
	plb
	rep	#P_A				// 16 bit accumulator
	sep	#P_XY				// 8 bit index

MainLoop:
	lda.l	r_Scene				// Get scene ID
	and.w	#$FE
	tax
	jsr	(SceneIndex,x)			// Go to scene
	jmp	MainLoop			// Loop

// ---------------------------------------------------------------------
// Scenes
// ---------------------------------------------------------------------

constant sceneSega($00)
constant sceneTitle($02)

// ---------------------------------------------------------------------

SceneIndex:
	dw	Scene_Sega			// Sega screen
	dw	Scene_Title			// Title screen

Scene_Sega:
	jsl	SegaScreen
	rts

Scene_Title:
	jsl	TitleScreen
	rts

// ---------------------------------------------------------------------
// NMI
// ---------------------------------------------------------------------

NMI:
	lda.l	r_NMI_Routine			// Are we lagging?
	beq	NMI_Exit			// If so, branch

	ldx.b	r_BG_A_VScrl			// Set VScroll
	stx.w	REG_BG1VOFS
	ldx.b	r_BG_A_VScrl+1
	stx.w	REG_BG1VOFS
	ldx.b	r_BG_B_VScrl
	stx.w	REG_BG2VOFS
	ldx.b	r_BG_B_VScrl+1
	stx.w	REG_BG2VOFS

	lda.l	r_NMI_Routine			// Get NMI routine
	and.w	#$3E
	tax

	sep	#P_A				// Reset NMI routine
	lda.b	#$00
	sta.l	r_NMI_Routine
	rep	#P_A

	jsr	(NMI_Index,x)			// Go to NMI routine

NMI_Exit:
	inc	r_Frames			// Increment frame count

	rtl

// ---------------------------------------------------------------------
// NMI index
// ---------------------------------------------------------------------

NMI_Index:
	dw	NMI_Lag				// Lag
	dw	NMI_General			// General
	dw	NMI_Title			// Title screen
	dw	NMI_Update			// General (no timer decrement)
	dw	NMI_General			// Level
	dw	NMI_General			// Special stage
	dw	NMI_General			// Level load
	dw	NMI_General			// Unused
	dw	NMI_General			// Paused
	dw	NMI_PalFade			// Palette fade
	dw	NMI_General			// SEGA screen

// ---------------------------------------------------------------------
// Lag routine
// ---------------------------------------------------------------------

NMI_Lag:
	rts

// ---------------------------------------------------------------------
// General routine
// ---------------------------------------------------------------------

NMI_General:
	jsr	NMI_Update			// Do updates

	lda.b	r_Timer				// Does the timer need to be decremented?
	beq	+				// If not, branch
	dec	r_Timer				// Decrement the timer

+
	rts

// ---------------------------------------------------------------------
// Title screen routine
// ---------------------------------------------------------------------

NMI_Title:
	jsl	Title_SetupHDMA			// Set up Sonic sprite mask HDMA
	ldx.b	#%01100000			// Enable HDMA
	stx.w	REG_HDMAEN

	jsr	NMI_Update			// Do updates

	lda.b	r_Timer				// Does the timer need to be decremented?
	beq	+				// If not, branch
	dec	r_Timer				// Decrement the timer

+
	rts

// ---------------------------------------------------------------------
// Palette fade routine
// ---------------------------------------------------------------------

NMI_PalFade:

// ---------------------------------------------------------------------
// Common NMI updates
// ---------------------------------------------------------------------

NMI_Update:
	ldx.b	#$80				// Disable screen
	stx.w	REG_INIDISP
	
	jsl	DMAPalette			// DMA the palette
	dmaOAM(r_Sprites)			// DMA sprite butter to OAM
	jsl	ProcessDMA			// Process the DMA queue
	
	ldx.b	r_Scr_Enable			// Reset screen enable flag
	stx.w	REG_INIDISP
	rts

// ---------------------------------------------------------------------
// Scenes
// ---------------------------------------------------------------------

	include	"sega/main.asm"
	include	"title/main.asm"

// ---------------------------------------------------------------------

	chkBank(1)

// ---------------------------------------------------------------------
// Object bank 1
// ---------------------------------------------------------------------

	rombank(2)

	include	"+objects/credits.asm"

	chkBank(2)

// ---------------------------------------------------------------------
// Data bank 1
// ---------------------------------------------------------------------

	rombank(3)

ArtKosM_GHZ1:
	insert	"level/data/ghz/tiles1.kosm"
ArtKosM_GHZ2:
	insert	"level/data/ghz/tiles2.kosm"
BlkKos_GHZ:
	insert	"level/data/ghz/blocks.kos"
ChkKos_GHZ:
	insert	"level/data/ghz/chunks.kos"

	chkBank(3)

// ---------------------------------------------------------------------
// Data bank 2
// ---------------------------------------------------------------------

	rombank(4)

Pal_Sonic:
	insert	"+palette/sonic.pal"
Pal_Title:
	insert	"title/data/palette.pal"

ArtKos_Credits:
	insert	"+art/credits.kos"
MapSpr_Credits:
	include	"+sprite/credits.asm"
ArtKos_JapCredits:
	insert	"+art/japcredits.kos"
MapKos_JapCredits:
	insert	"+plane/japcredits.kos"
ArtKosM_TitleEmblem:
	insert	"title/data/emblemart.kosm"
MapKos_TitleEmblem:
	insert	"title/data/emblemmap.kos"
ArtKosM_TitleSprites:
	insert	"title/data/sprites.kosm"
MapSpr_TtlSonic:
	include	"title/objects/sonic/map.asm"

ArtNem_Motobug:
	insert	"+art/motobug.kos"

	chkBank(4)

// ---------------------------------------------------------------------
