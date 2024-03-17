
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		main.asm
//	Contents:	Main source
//
// ---------------------------------------------------------------------

	arch	snes.cpu

// ---------------------------------------------------------------------
// Includes
// ---------------------------------------------------------------------

	include	"../src/flags.asm"		// User flags
	include	"constants.asm"			// Constants
	include	"macros.asm"			// Macros
	include	"ram.asm"			// RAM
	include	"../src/_inc/ram.asm"		// User RAM

// ---------------------------------------------------------------------
// Initialization routine (by krom)
// ---------------------------------------------------------------------

	bankseek(ROM_SECTION)

Reset:
	sei					// Disable interrupts
	clc					// Switch to native mode
	xce

	jml	+				// Set program bank
+;	phk					// Data bank = program bank
	plb

	rep	#P_A|P_XY|P_D			// 16 bit registers, binary arithmetic

	ldx.w	#r_Stack			// Set stack pointer
	txs

	lda.w	#$0000				// Set direct page
	tcd

	sep	#P_A				// 8 bit accumulator

	lda.b	#ROM_SPEED			// Set ROM speed
	sta.w	REG_MEMSEL

	// Set up general PPU registers

	lda.b	#$80				// Disable screen
	sta.b	r_Scr_Enable
	sta.w	REG_INIDISP

	lda.b	#$01				// Mode 1
	stz.w	REG_OBSEL			// Reset object size and base
	stz.w	REG_OAMADDL			// Reset lower OAM address
	stz.w	REG_OAMADDH			// Reset upper OAM address and priority rotation
	sta.w	REG_BGMODE 			// Set to mode 1
	stz.w	REG_MOSAIC 			// Disable mosaic
	stz.w	REG_BG1SC			// Set BG1 base and size
	stz.w	REG_BG2SC			// Set BG2 base and size
	stz.w	REG_BG3SC  			// Set BG3 base and size
	stz.w	REG_BG4SC  			// Reset BG4 base and size
	stz.w	REG_BG12NBA			// Set BG1/BG2 character data area designation
	stz.w	REG_BG34NBA			// Reset BG3/BG4 character data area designation
	stz.w	REG_BG1HOFS			// Reset BG1 horizontal scroll offset
	stz.w	REG_BG1HOFS
	stz.w	REG_BG1VOFS			// Reset BG1 vertical scroll offset
	stz.w	REG_BG1VOFS
	stz.w	REG_BG2HOFS			// Reset BG2 horizontal scroll offset
	stz.w	REG_BG2HOFS
	stz.w	REG_BG2VOFS			// Reset BG2 vertical scroll offset
	stz.w	REG_BG2VOFS
	stz.w	REG_BG3HOFS			// Reset BG3 horizontal scroll offset
	stz.w	REG_BG3HOFS
	stz.w	REG_BG3VOFS			// Reset BG3 vertical scroll offset
	stz.w	REG_BG3VOFS
	stz.w	REG_BG4HOFS			// Reset BG4 horizontal scroll offset
	stz.w	REG_BG4HOFS
	stz.w	REG_BG4VOFS			// Reset BG4 vertical scroll offset
	stz.w	REG_BG4VOFS

	// Set up mode 7

	lda.b	#$01
	stz.w	REG_M7A				// Reset mode 7 rot/scale A
	sta.w	REG_M7A
	stz.w	REG_M7B				// Reset mode 7 rot/scale B
	stz.w	REG_M7B
	stz.w	REG_M7C				// Reset mode 7 rot/scale C
	stz.w	REG_M7C
	stz.w	REG_M7D				// Reset mode 7 rot/scale D
	sta.w	REG_M7D
	stz.w	REG_M7X				// Reset mode 7 center X
	stz.w	REG_M7X
	stz.w	REG_M7Y				// Reset mode 7 center Y
	stz.w	REG_M7Y

	// Set up window registers

	lda.b	#%00010011			// Enable sprites, BG1 and BG2
	stz.w	REG_W12SEL			// Reset window BG1/BG2 mask settings
	stz.w	REG_W34SEL			// Reset window BG3/BG4 mask settings
	stz.w	REG_WOBJSEL			// Reset window OBJ/MATH mask settings
	stz.w	REG_WH0				// Reset window 1 left position
	stz.w	REG_WH1				// Reset window 1 right position
	stz.w	REG_WH2				// Reset window 2 left position
	stz.w	REG_WH3				// Reset window 2 right position
	stz.w	REG_WBGLOG			// Reset window 1/2 mask logic (BG1-4)
	stz.w	REG_WOBJLOG			// Reset window 1/2 mask logic (OBJ/MATH)
	sta.w	REG_TM				// Reset main screen designation
	stz.w	REG_TS				// Reset sub screen designation
	stz.w	REG_TMW				// Disable window area main screen
	stz.w	REG_TSW				// Disable window area sub screen

	// Set up color math

	lda.b	#$30				// Set color math control A
	sta.w	REG_CGWSEL
	stz.w	REG_CGADSUB			// Reset color math control B

	lda.b	#$E0				// Set color math sub screen backdrop color
	sta.w	REG_COLDATA

	stz.w	REG_SETINI			// Reset display control 2

	// Set up I/O registers

	stz.w	REG_JOYWR			// Reset joypad output
	stz.w	REG_NMITIMEN			// Reset VBlank, interrupt, and joypad

	lda.b	#$FF				// Reset programmable I/O port
	sta.w	REG_WRIO

	stz.w	REG_WRMPYA			// Reset unsigned 8-bit multiplicand
	stz.w	REG_WRMPYB			// Reset unsigned 8-bit multiplier
	stz.w	REG_WRDIVL			// Reset unsigned 16-bit dividend
	stz.w	REG_WRDIVH
	stz.w	REG_WRDIVB			// Reset unsigned 8-bit divisior
	stz.w	REG_HTIMEL			// Reset H-Count timer setting
	stz.w	REG_HTIMEH
	stz.w	REG_VTIMEL			// Reset V-Count timer setting
	stz.w	REG_VTIMEH
	stz.w	REG_MDMAEN			// Reset DMA channel selection
	stz.w	REG_MDMAEN

	// Clear OAM low table

	ldx.w	#$200/4
	lda.b	#224

-;	sta.w	REG_OAMDATA			// Reset X position
	sta.w	REG_OAMDATA			// Reset Y position
	stz.w	REG_OAMDATA			// Reset starting tile
	stz.w	REG_OAMDATA			// Reset tile settings
	dex
	bne	-

	// Clear OAM high table

	ldx.w	#$20

-;	stz.w	REG_OAMDATA			// Reset high X bit and sprite size
	dex
	bne	-

	// Clear WRAM

	ldy.w	#$0000				// Set WRAM address
	sty.w	REG_WMADDL
	stz.w	REG_WMADDH

	ldx.w	#$08|((REG_WMDATA&$FF)<<8)	// DMA fixed source byte write to WRAM
	stx.w	REG_DMAP0
	ldx.w	#Init_ClrDMA			// Set DMA source data address
	lda.b	#Init_ClrDMA>>16
	stx.w	REG_A1T0L
	sta.w	REG_A1B0
	sty.w	REG_DAS0L			// Transfer 64 KB in DMA
	lda.b	#$01				// Select DMA channel and start transfer
	sta.w	REG_MDMAEN
	nop
	sta.w	REG_MDMAEN

	// Clear VRAM

	lda.b	#$80				// Set VRAM increment mode
	sta.w	REG_VMAIN
	ldy.w	#$0000				// Reset VRAM address
	sty.w	REG_VMADDL

	sty.w	REG_DAS0L			// Transfer 64 KB in DMA
	ldx.w	#$09|((REG_VMDATAL&$FF)<<8)	// DMA fixed source alternate byte write to VRAM
	stx.w	REG_DMAP0
	lda.b	#$01				// Select DMA channel and start transfer
	sta.w	REG_MDMAEN

	// Clear CGRAM

	stz.w	REG_CGADD			// Reset CGRAM address

	ldx.w	#$0200				// Transfer 512 bytes in DMA
	stx.w	REG_DAS0L
	ldx.w	#$08|((REG_CGDATA&$FF)<<8)	// DMA fixed source byte write to CGRAM
	stx.w	REG_DMAP0
	sta.w	REG_MDMAEN			// Select DMA channel and start transfer

	// Initialize the rest

	jsl	InitScreen			// Initialize the screen

	lda.b	#%000				// Set sprite sizes
	jsl	SetSpriteSizes

	// Finished

	jml	Main				// Go to main routine

// ---------------------------------------------------------------------

Init_ClrDMA:
	dw	$0000				// Source data for DMA clear

// ---------------------------------------------------------------------
// NMI base
// ---------------------------------------------------------------------

NMIBase:
	php					// Push registers
	rep	#P_A|P_XY
	pha
	phx
	phy
	phd
	phb
	sep	#P_XY				// 8 bit index

	ldx.b	#$00				// Disable H-DMA
	stx.w	REG_HDMAEN

	ldx.w	REG_RDNMI			// Clear NMI flag
	
	jsl	NMI				// Go to the actual NMI routine

	rep	#P_A|P_XY			// Pop registers
	plb
	pld
	ply
	plx
	pla
	plp
	rti

// ---------------------------------------------------------------------
// Libraries
// ---------------------------------------------------------------------

	include	"../lib/ppu.asm"		// PPU functions
	include	"../lib/decomp.asm"		// Decompression functions
	include	"../lib/object.asm"		// Object functions

// ---------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------

	constant BANK0_FREE(pc()&$FFFF)

	// Game title
	bankseek(ROM_HEADER)
	db	{GAME_TITLE}
	if pc() < ROM_HEADER+$15 {
		fill	(ROM_HEADER+$15)-pc(), $20
	}
	bankseek(ROM_HEADER+$15)

	// ROM mode/speed
	db	$20|((ROM_SPEED&1)<<4)|(ROM_MODE&$F)

	// ROM type
	db	((ROM_COPROC&$F)<<4)|(ROM_TYPE&$F)

	// ROM size
	if ROM_BANKS<0 {
		error "Cannot have a negative amount of ROM banks"
	} else if ROM_BANKS==0 {
		error "Cannot have 0 ROM banks"
	} else if ROM_BANKS>$0C {
		warning "Too many ROM banks defined, capping at 128 banks"
		db	$0C
	} else {
		db	ROM_BANKS
	}

	// SRAM size
	if SRAM_SIZE<0 {
		error "Cannot have a negative size for SRAM"
	} else if SRAM_SIZE>7 {
		warning "Size for SRAM too large, capping at 128 KB"
		db	$07
	} else {
		db	SRAM_SIZE
	}

	// Region
	db	REGION

	// Developer ID
	db	$00

	// ROM version number
	db	$00

	// Checksum
	dw	$0000
	dw	$0000

	// Vector table (native mode)
	dw	$0000				// Reserved
	dw	$0000				// Reserved
	dw	$0000				// COP
	dw	$0000				// BRK
	dw	$0000				// ABORT (unused)
	dw	NMIBase				// NMI
	dw	Reset				// RESET (unused)
	dw	$0000				// IRQ

	// Vector table (emulation mode)
	dw	$0000				// Reserved
	dw	$0000				// Reserved
	dw	$0000				// COP
	dw	$0000				// Unused
	dw	$0000				// ABORT (unused)
	dw	NMIBase				// NMI
	dw	Reset				// RESET
	dw	$0000				// IRQ/BRK

	chkBank(0)

// ---------------------------------------------------------------------
// Fill ROM with empty banks
// ---------------------------------------------------------------------

	if ROM_BANKS>$01 && ROM_BANKS<$09 {
		fill (ROM_BANKS-1)*$8000
	} else if ROM_BANKS==$09 {
		fill 15*$8000
	} else if ROM_BANKS==$0A {
		fill 31*$8000
	} else if ROM_BANKS==$0B {
		fill 63*$8000
	} else if ROM_BANKS>=$0C {
		fill 127*$8000
	}

// ---------------------------------------------------------------------
// Main source
// ---------------------------------------------------------------------

	include	"../src/main.asm"

// ---------------------------------------------------------------------
