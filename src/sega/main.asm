
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		main.asm
//	Contents:	SEGA Screen
//
// ---------------------------------------------------------------------

SegaScreen:
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

	ldx.b	#$20				// Set HScroll
	stx.w	REG_BG1HOFS
	stx.w	REG_BG1HOFS
	stx.w	REG_BG2HOFS
	stx.w	REG_BG2HOFS

	loadKosArtImm(ArtKos_Sega, r_Buffer, $0000)
	loadPlane(Map_Sega, $F290, $0000)
	loadPlane(Map_Sega+$186, $E000, $0000)
	loadPal(Pal_SegaBG, $0000)

	lda.w	#-$A				// Initialize palette cycle
	sta.w	r_PalCyc_Index
	stz.w	r_PalCyc_Time

	ldx.b	#$0F				// Enable screen
	stx.b	r_Scr_Enable
	stx.w	REG_INIDISP

Sega_WaitPalCycle:
	lda.w	#$02				// VSync
	jsl	VSync
	jsr	PalCycle_Sega			// Do palette cycle
	cmp.w	#$00				// Is it done?
	bne	Sega_WaitPalCycle		// If not, loop

	// Play sound

	lda.w	#3*60				// Set timer
	sta.b	r_Timer

Sega_WaitEnd:
	lda.w	#$02				// VSync
	jsl	VSync
	lda.b	r_Timer				// Has the timer run out?
	beq	+
	jmp	Sega_WaitEnd

+
	lda.w	#sceneTitle			// Set scene to title screen
	sta.l	r_Scene
	rtl

// ---------------------------------------------------------------------
// SEGA screen palette cycle
// ---------------------------------------------------------------------

PalCycle_Sega:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.b	r_PalCyc_Time
	and.w	#$FF
	bne	loc_206A

	lda.w	#Pal_Sega1
	sta.b	r_Pointer
	lda.w	#Pal_Sega1>>8
	sta.b	r_Pointer+1
	ldy.w	#$0000

	lda.w	#$05
	sta.b	r_Counter

	ldx.b	r_PalCyc_Index

-
	bpl	loc_202A
	iny	#2
	dec	r_Counter
	inx	#2
	jmp	-

loc_202A:
	txa
	and.w	#$1E
	bne	+
	inx	#2
+
	cpx.w	#$60
	bpl	+
	lda	[r_Pointer],y
	iny	#2
	sta.w	r_Palette+$20,x

+
	inx	#2
	dec.b	r_Counter
	bpl	loc_202A

	ldx.b	r_PalCyc_Index
	inx	#2
	txa
	and.w	#$1E
	bne	+
	inx	#2

+
	cpx.w	#$64
	bmi	+
	lda.w	#$401
	sta.b	r_PalCyc_Time
	ldx.w	#-$C

+
	stx.b	r_PalCyc_Index
	lda.w	#$01

	plp
	rts

loc_206A:
	sep	#P_A
	dec	r_PalCyc_Time+1
	bpl	loc_20BC
	lda.b	#$04
	sta.b	r_PalCyc_Time+1
	rep	#P_A
	lda.b	r_PalCyc_Index
	clc
	adc.w	#$C
	cmp.w	#$30
	bmi	+
	lda.w	#$00
	plp
	rts
+
	sta.b	r_PalCyc_Index
	tax
	lda.w	Pal_Sega2,x
	sta.w	r_Palette+$04
	lda.w	Pal_Sega2+$02,x
	sta.w	r_Palette+$06
	lda.w	Pal_Sega2+$04,x
	sta.w	r_Palette+$08
	lda.w	Pal_Sega2+$06,x
	sta.w	r_Palette+$0A
	lda.w	Pal_Sega2+$08,x
	sta.w	r_Palette+$0C

	ldy.w	Pal_Sega2+$0A,x

	ldx.w	#$00
	lda.w	#$2C
	sta.b	r_Counter

-
	txa
	and.w	#$1E
	bne	+
	inx	#2

+
	tya
	sta	r_Palette+$20,x
	inx	#2
	dec	r_Counter
	bpl	-

loc_20BC:
	rep	#P_A
	lda.w	#$01
	plp
	rts

// ---------------------------------------------------------------------
// Palette cycle data
// ---------------------------------------------------------------------

Pal_Sega1:
	insert	"data/palcycle1.pal"
Pal_Sega2:
	insert	"data/palcycle2.pal"

// ---------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------

ArtKos_Sega:
	insert	"data/tiles.kos"
Map_Sega:
	insert	"data/map.map"
Pal_SegaBG:
	insert	"data/background.pal"
Pal_SegaBG_End:

// ---------------------------------------------------------------------
