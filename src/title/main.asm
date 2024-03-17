
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		main.asm
//	Contents:	SEGA Screen
//
// ---------------------------------------------------------------------

TitleScreen:
	phk					// Data bank = program bank
	plb

	jsl	FadeToBlack			// Fade to black

	rep	#P_A				// 16 bit accumulator
	sep	#P_XY				// 8 bit index

	lda.w	#%011				// Set sprite sizes to 16x16 and 32x32
	jsl	SetSpriteSizes
	lda.w	#$0000>>$E			// Set OAM Base
	jsl	SetOAMBase

	ldx.b	#$71				// Set BG1 base and size
	stx.w	REG_BG1SC
	ldx.b	#$79				// Set BG2 base and size
	stx.w	REG_BG2SC
	ldx.b	#$00				// Disable NMI
	stx.w	REG_NMITIMEN
	ldx.b	#$80				// Disable screen
	stx.b	r_Scr_Enable
	stx.w	REG_INIDISP
	ldx.b	#$00				// Set palette mode to normal
	stx.b	r_Pal_Mode
	jsl	InitScreen			// Initialize the screen

	stz.w	REG_BG1HOFS			// Reset HScroll
	stz.w	REG_BG1HOFS
	stz.w	REG_BG2HOFS
	stz.w	REG_BG2HOFS

	rep	#P_XY
	clrMem(r_Objects, r_Objects_End)	// Clear object RAM
	sep	#P_XY

	loadKosArtImm(ArtKos_JapCredits, r_Buffer, $0000)
	loadKosArtImm(ArtKos_Credits, r_Buffer, $1800)
	loadKosMap(MapKos_JapCredits, r_Buffer, $E000, $0000)	
	loadFadePal(Pal_Sonic, $0000)

	lda24(ObjCredits, r_Objects+(oSize*2))	// Load credits text
	jsl	RunObjects			// Run objects
	jsl	RenderObjects			// Render objects

	ldx.b	#$0F				// Enable screen
	stx.b	r_Scr_Enable
	stx.w	REG_INIDISP
	jsl	FadeFromBlack			// Fade from black

	loadKosDat(BlkKos_GHZ, r_Blocks)
	loadKosDat(ChkKos_GHZ, r_Chunks)

	lda.w	#1*60				// Set delay timer
	sta.b	r_Timer

-
	lda.w	#$04				// VSync
	jsl	VSync
	lda.b	r_Timer				// Has the timer run out?
	bne	-				// If not, wait

	jsl	FadeToBlack			// Fade to black
	ldx.b	#$00				// Disable NMI
	stx.w	REG_NMITIMEN
	ldx.b	#$80				// Disable screen
	stx.b	r_Scr_Enable
	stx.w	REG_INIDISP
	jsl	InitScreen			// Initialize the screen

	loadKosMap(MapKos_TitleEmblem, r_Buffer, $E100, $0000)

	queueKosM(ArtKosM_GHZ1, $0000)
	queueKosM(ArtKosM_TitleEmblem, $4000)
	queueKosM(ArtKosM_TitleSprites, $8000)
	waitKosM($04)
	ldx.b	#$00				// Disable NMI
	stx.w	REG_NMITIMEN
	
	loadFadePal(Pal_Title, $0000)

	rep	#P_XY				// Clear object RAM
	clrMem(r_Objects+(oSize*2), r_Objects+(oSize*2)+(oSize/2))
	sep	#P_XY

	lda.w	#$8000>>$E			// Set OAM Base
	jsl	SetOAMBase

	ldx.b	#%00000010			// Set up window for Sonic sprite masking
	stx.w	REG_WOBJSEL
	ldx.b	#%00000001
	stx.w	REG_WOBJLOG
	ldx.b	#%00010000
	stx.w	REG_TMW

	lda.w	#$FF67				// Set up HDMA for left side of the window
	sta.l	r_HDMA_Buf_1
	lda.w	#$007F
	sta.l	r_HDMA_Buf_1+2
	lda.w	#$FF01
	sta.l	r_HDMA_Buf_1+4
	lda.w	#$0000
	sta.l	r_HDMA_Buf_1+6
	sta.l	r_HDMA_Buf_2+6

	lda.w	#$0067				// Set up HDMA for right side of the window
	sta.l	r_HDMA_Buf_2
	lda.w	#$FF7F
	sta.l	r_HDMA_Buf_2+2
	lda.w	#$0001
	sta.l	r_HDMA_Buf_2+4

	lda24(ObjTtlSonic, r_Objects+(oSize))	// Load Sonic object
	jsl	RunObjects			// Run objects
	jsl	RenderObjects			// Render objects

	ldx.b	#$0F				// Enable screen
	stx.b	r_Scr_Enable
	stx.w	REG_INIDISP
	jsl	FadeFromBlack			// Fade from black

Title_MainLoop:
	lda.w	#$04				// VSync
	jsl	VSync
	jsl	RunObjects			// Run objects
	jsl	RenderObjects			// Render objects
	jmp	Title_MainLoop

	rtl

// ---------------------------------------------------------------------
// Set up the Sonic sprite mask H-DMA
// ---------------------------------------------------------------------

Title_SetupHDMA:
	php
	rep	#P_A				// 16 bit accumulator
	sep	#P_XY				// 8 bit index

	lda.w	#r_HDMA_Buf_1			// Set HDMA1 address
	sta.w	REG_A1T6L
	lda.w	#r_HDMA_Buf_2			// Set HDMA2 address
	sta.w	REG_A1T5L
	ldx.b	#r_HDMA_Buf_1>>16		// Set HDMA1 bank
	stx.w	REG_A1B6
	ldx.b	#r_HDMA_Buf_2>>16		// Set HDMA2 bank
	stx.w	REG_A1B5
	lda.w	#REG_WH0<<8			// Set HDMA1 parameters
	sta.w	REG_DMAP6
	lda.w	#REG_WH1<<8			// Set HDMA2 parameters
	sta.w	REG_DMAP5

	plp
	rtl

// ---------------------------------------------------------------------
// Objects
// ---------------------------------------------------------------------

	include	"objects/sonic/main.asm"	// Sonic

// ---------------------------------------------------------------------
