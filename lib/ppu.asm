
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		lib/ppu.asm
//	Contents:	PPU functions
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Initialize the screen
// ---------------------------------------------------------------------

InitScreen:
	php
	rep	#P_A				// 16 bit accumulator
	sep	#P_XY				// 8 bit index

	jsl	InitSprites			// Initialize sprites

	stz.w	r_DMA_Len+7			// Reset DMA queue
	stz.w	r_DMA_Slot-1

	fillVRAM(InitScr_DMAClr, $C000, $4000)	// Clear planes

	plp
	rtl

// ---------------------------------------------------------------------

InitScr_DMAClr:
	dw	$0000

// ---------------------------------------------------------------------
// Initialize the sprite buffer
// ---------------------------------------------------------------------

InitSprites:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.w	#$E0E0				// Reset position
	sta.w	r_Sprites
	stz.w	r_Sprites+2			// Reset tile

	phb					// Fill the low OAM table with the default values
	lda.w	#$200-4-1
	ldx.w	#r_Sprites
	ldy.w	#r_Sprites+4
	mvn	(r_Sprites>>16)=(r_Sprites>>16)

	lda.w	#$20-1				// Clear the high OAM table buffer
	ldx.w	#r_Sprites+$1FF
	mvn	((r_Sprites+$200)>>16)=((r_Sprites+$200)>>16)
	plb

	plp
	rtl

// ---------------------------------------------------------------------
// Set the sprite sizes
// ---------------------------------------------------------------------

SetSpriteSizes:
	php
	phb
	phk					// Data bank = program bank
	plb
	rep	#P_A				// 16 bit accumulator
	sep	#P_XY				// 8 bit index

	and.w	#$0007				// Get actual sizes in pixels
	asl	#2
	tax
	lda.w	SpriteSzPixels,x
	sta.b	r_Spr_HSize
	lda.w	SpriteSzPixels+2,x
	sta.b	r_Spr_VSize
	txa
	
	sep	#P_A				// 8 bit accumulator
	asl	#3				// Set size bits
	sta.b	r_OAM_Size
	ora.b	r_OAM_Base
	sta.w	REG_OBSEL

	plb
	plp
	rtl

// ---------------------------------------------------------------------

SpriteSzPixels:
	//	H	  V
	db	$08, $10, $08, $10
	db	$08, $20, $08, $20
	db	$08, $40, $08, $40
	db	$10, $20, $10, $20
	db	$10, $40, $10, $40
	db	$20, $40, $20, $40
	db	$10, $20, $20, $40
	db	$10, $20, $20, $20

// ---------------------------------------------------------------------
// Set the OAM base address
// ---------------------------------------------------------------------

SetOAMBase:
	php
	sep	#P_A				// 8 bit accumulator
	
	sta.b	r_OAM_Base			// Set OAM base
	ora.b	r_OAM_Size
	sta.w	REG_OBSEL

	plp
	rtl

// ---------------------------------------------------------------------
// Draw an object sprite
// ---------------------------------------------------------------------

DrawSprite:
	php
	phb
	phk					// Data bank = program bank
	plb
	rep	#P_A|P_XY			// 16 bit registers

	lda.b	r_Spr_Count			// Check if we have already reached the max amount of sprites
	cmp.w	#128
	bne	+				// If not, branch
	jmp	DrawSprite_End			// Exit

+
	asl	#2				// OAM low table buffer index
	tax
	lsr	#4				// OAM high table buffer index
	dec
	tay

-
	lda.b	r_Spr_Count			// Check if we need to advance the high table
	and.w	#$0003
	bne	+
	iny					// Next entry in the high table
	phx					// Save X
	tyx					// Transfer Y to X
	sep	#P_A				// 8 bit accumulator
	stz.w	r_Sprites+$200,x		// Clear the current high table byte
	rep	#P_A				// 16 bit accumulator
	plx

+
	lda	[r_Spr_Data]			// Get sprite base tile
	clc
	adc.b	r_Spr_Tile			// Add object base tile
	sta.w	r_Sprites+2,x			// Store in sprite buffer
	inc	r_Spr_Data			// Next piece of data
	inc	r_Spr_Data

	lda	[r_Spr_Data]			// Get sprite size
	and.w	#$0001
	sep	#P_A				// 8 bit accumulator
	sta.b	r_Spr_Size
	rep	#P_A				// 16 bit accumulator
	beq	+				// If it's zero, branch
	phx
	lda.b	r_Spr_Count			// Get index in bit table
	and.w	#$0003
	tax
	sep	#P_A				// 8 bit accumulator
	lda.w	DrawSprite_HighSz,x		// Get the bit to set
	tyx					// Transfer Y to X
	ora.w	r_Sprites+$200,x		// Set the bit
	sta.w	r_Sprites+$200,x
	rep	#P_A				// 16 bit accumulator
	plx

+
	lda	[r_Spr_Data]			// Get flip bits
	and.w	#$C000
	eor.b	r_Spr_Flip			// Apply flipping
	ora.w	r_Sprites+2,x			// Store in sprite buffer
	sta.w	r_Sprites+2,x
	inc	r_Spr_Data			// Next piece of data
	inc	r_Spr_Data

	phx
	lda	[r_Spr_Data]			// Get sprite X position
	tax
	lda.b	r_Spr_Flip			// Is the sprite horizontally flipped?
	bit.w	#$4000
	beq	+				// If not, branch
	txa
	plx
	eor.w	#$FFFF				// Negate the X position
	inc
	phx
	pha
	sep	#P_A|P_XY			// 8 bit registers
	ldx.b	r_Spr_Size			// Get horizontal offset
	lda.b	r_Spr_HSize,x
	sta.b	r_Spr_Offset
	rep	#P_A|P_XY			// 16 bit registers
	pla
	plx
	sec					// Apply horizontal offset
	sbc	r_Spr_Offset
	jmp	++
+
	txa
	plx
+
	clc
	adc.b	r_Spr_X				// Add object X position
	sta.w	r_Sprites,x			// Store in sprite buffer
	and.w	#$100				// Is the high bit set?
	beq	+				// If not, branch
	phx
	lda.b	r_Spr_Count			// Get index in bit table
	and.w	#$0003
	tax
	sep	#P_A				// 8 bit accumulator
	lda.w	DrawSprite_HighX,x		// Get the bit to set
	tyx					// Transfer Y to X
	ora.w	r_Sprites+$200,x		// Set the bit
	sta.w	r_Sprites+$200,x
	rep	#P_A				// 16 bit accumulator
	plx
+
	inc	r_Spr_Data			// Next piece of data
	inc	r_Spr_Data

	phx
	lda	[r_Spr_Data]			// Get sprite Y position
	tax
	lda.b	r_Spr_Flip			// Is the sprite vertically flipped?
	bit.w	#$8000
	beq	+				// If not, branch
	txa
	plx
	eor.w	#$FFFF				// Negate the Y position
	inc
	phx
	pha
	sep	#P_A|P_XY			// 8 bit registers
	ldx.b	r_Spr_Size			// Get vertical offset
	lda.b	r_Spr_VSize,x
	sta.b	r_Spr_Offset
	rep	#P_A|P_XY			// 16 bit registers
	pla
	plx
	sec					// Apply vertical offset
	sbc	r_Spr_Offset
	jmp	++
+
	txa
	plx
+
	clc
	adc.b	r_Spr_Y				// Add object Y position
	sep	#P_A				// 8 bit accumulator
	sta.w	r_Sprites+1,x			// Store in sprite buffer
	rep	#P_A				// 16 bit accumulator
	inc	r_Spr_Data			// Next piece of data
	inc	r_Spr_Data

	inx	#4				// Next sprite in buffer
	inc.b	r_Spr_Count			// Increment sprite count

	dec.b	r_Spr_Pieces			// Decrement piece count
	beq	DrawSprite_End			// If no more sprites left, branch
	jmp	-				// Loop


DrawSprite_End:
	plb
	plp
	rtl

// ---------------------------------------------------------------------

DrawSprite_HighX:
	db	$01, $04, $10, $40
DrawSprite_HighSz:
	db	$02, $08, $20, $80

// ---------------------------------------------------------------------
// Draw a plane map
// ---------------------------------------------------------------------

DrawPlane:
	php
	sep	#P_A				// 8 bit accumulator
	rep	#P_XY				// 16 bit index

	lda.b	#%10000000			// Set up increment
	sta.w	REG_VMAIN

	rep	#P_A				// 16 bit accumulator

	lda.b	r_Map_VRAM			// Set base VRAM address
	sta.b	r_Map_Base_VRAM

	ldy.w	#$0000				// Reset tile map index

DrawPlane_Section:
	lda	[r_Map_Data],y			// Get map section width
	bmi	+
	iny	#2
	sta.b	r_Map_Width
	
	lda	[r_Map_Data],y			// Get map section width
	iny	#2
	sta.b	r_Map_Height

-
	lda.b	r_Map_VRAM			// Set VRAM address
	sta.w	REG_VMADDL
	ldx.b	r_Map_Width			// Get map width

-
	lda	[r_Map_Data],y			// Get tile
	iny	#2
	clc
	adc.b	r_Map_Tile
	sta.w	REG_VMDATAL			// Store it in VRAM
	dex					// Next tile
	bne	-

	lda.b	r_Map_VRAM			// Next row
	clc
	adc.w	#$20
	sta.b	r_Map_VRAM
	dec	r_Map_Height
	bne	--

	lda.b	r_Map_Base_VRAM			// Next VRAM section
	clc
	adc.w	#$400
	sta.b	r_Map_Base_VRAM
	sta.b	r_Map_VRAM

	jmp	DrawPlane_Section		// Next section

+
	plp
	rtl

// ---------------------------------------------------------------------
// Queue a DMA trasnfer
// ---------------------------------------------------------------------

QueueDMA:
	php

	rep	#P_A				// 16 bit accumulator
	sep	#P_XY				// 8 bit index

	ldx.w	r_DMA_Slot			// Get current DMA slot
	cpx.b	#r_DMA_Slot-r_DMA_Queue		// Are we at the end of the queue?
	beq	+				// If so, branch

	lda.w	r_DMA_Len			// Set DMA length
	sta.w	r_DMA_Len+7,x

	lda.w	r_DMA_Src			// Set DMA source
	sta.w	r_DMA_Src+7,x
	lda.w	r_DMA_Src+2
	sta.w	r_DMA_Src+2+7,x

	lda.w	r_DMA_Dest			// Set DMA destination
	sta.w	r_DMA_Dest+7,x

	inx	#7				// Next DMA slot
	stx.w	r_DMA_Slot
	cpx.b	#r_DMA_Slot-r_DMA_Queue		// Have we reached the end of the queue?
	beq	+				// If so, branch
	stz.w	r_DMA_Len+7,x			// Set termination token

+
	plp
	rtl

// ---------------------------------------------------------------------
// Process the DMA queue
// ---------------------------------------------------------------------

ProcessDMA:
	php

	rep	#P_A				// 16 bit accumulator
	sep	#P_XY				// 8 bit index

	ldx.b	#$80				// Set VRAM increment
	stx.w	REG_VMAIN

	ldx.b	#$00				// Current queue entry
	ldy.b	#$01				// DMA channel

	lda.w	#$01|((REG_VMDATAL&$FF)<<8)	// DMA to VRAM
	sta.w	REG_DMAP0

-;	lda.w	r_DMA_Src+7,x			// Set DMA source
	sta.w	REG_A1T0L
	lda.w	r_DMA_Src+7+2,x
	sta.w	REG_A1B0

	lda.w	r_DMA_Len+7,x			// Get DMA length
	beq	+				// If it's actually the termination token, branch
	sta.w	REG_DAS0L			// Set DMA length

	lda.w	r_DMA_Dest+7,x			// Set VRAM address
	sta.w	REG_VMADDL

	sty.w	REG_MDMAEN			// Select DMA channel and start transfer

	inx	#7				// Next DMA slot
	cpx.b	#r_DMA_Slot-r_DMA_Queue		// Have we reached the end of the queue?
	bne	-				// If not, loop

+
	stz.w	r_DMA_Len+7			// Reset DMA queue
	ldx.b	#$00
	stx.w	r_DMA_Slot

	plp
	rtl

// ---------------------------------------------------------------------
// DMA a palette to CGRAM
// ---------------------------------------------------------------------

DMAPalette:
	php
	rep	#P_A				// 16 bit accumulator
	sep	#P_XY				// 8 bit index

	ldx.b	r_Pal_Mode			// Are we in secondary palette mode?
	bne	+				// If so, branch
	dmaCGRAM(r_Palette)			// DMA primary palette buffer to CGRAM
	jmp	++
+
	dmaCGRAM(r_Palette_2)			// DMA secondary palette buffer to CGRAM
+
	plp
	rtl

// ---------------------------------------------------------------------
// Load a palette
// ---------------------------------------------------------------------

LoadPal:
	php
	rep	#P_A|P_XY			// 16 bit registers

	ldx.b	r_Pal_Index			// Palette buffer index
	ldy.w	#$0000				// Reset palette data index

	lda	[r_Pal_Data],y			// Get palette size
	iny	#2
	sta.b	r_Pal_Size
-
	lda	[r_Pal_Data],y			// Get color
	iny	#2
	sta	r_Palette,x			// Store it
	sta	r_Palette+$100,x
	inx	#2

	dec	r_Pal_Size			// Next color
	bne	-

	plp
	rtl

// ---------------------------------------------------------------------
// Load a fade palette
// ---------------------------------------------------------------------

LoadFadePal:
	php
	rep	#P_A|P_XY			// 16 bit registers

	ldx.b	r_Pal_Index			// Palette buffer index
	ldy.w	#$0000				// Reset palette data index

	lda	[r_Pal_Data],y			// Get palette size
	iny	#2
	sta.b	r_Pal_Size
-
	lda	[r_Pal_Data],y			// Get color
	iny	#2
	sta	r_Fade_Pal,x			// Store it
	sta	r_Fade_Pal+$100,x
	inx	#2

	dec	r_Pal_Size			// Next color
	bne	-

	plp
	rtl

// ---------------------------------------------------------------------
// Fade the palette from black
// ---------------------------------------------------------------------

FadeFromBlack:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.w	#$FF00				// Set fade settings
	sta.b	r_Pal_Fade
	jmp	+

FadeFromBlack_Alt:
	php
	rep	#P_A|P_XY			// 16 bit registers

+
	lda.w	#8*3				// Loop count
	sta.b	r_Counter_2

-
	lda.w	#$12				// VSync
	jsl	VSync
	jsl	FadeFromBlackOnce		// Fade once
	dec	r_Counter_2			// Next fade session
	bne	-
	lda.w	#$12				// VSync
	jsl	VSync

	plp
	rtl

// ---------------------------------------------------------------------

FadeFromBlackOnce:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.b	r_Pal_Fade			// Get starting index for palette 1
	and.w	#$FF
	tax
	lda.b	r_Pal_Fade+1			// Get length
	and.w	#$FF
	tay

-
	jsr	FadeColorFromBlack		// Fade color
	dey					// Next color
	bpl	-

	lda.b	r_Pal_Fade			// Get starting index for palette 2
	and.w	#$FF
	clc
	adc.w	#r_Palette_2-r_Palette
	tax
	lda.b	r_Pal_Fade+1			// Get length
	and.w	#$FF
	tay

-
	jsr	FadeColorFromBlack		// Fade color
	dey					// Next color
	bpl	-

	plp
	rtl

// ---------------------------------------------------------------------

FadeColorFromBlack:
	lda.w	r_Palette,x			// Get color
	cmp	r_Fade_Pal,x			// Has it already reached the target color?
	beq	FCFB_End			// If so, branch
	clc					// Fade blue
	adc.w	#$04<<10
	cmp.w	r_Fade_Pal,x			// Has it reached the target color?
	bcs	+				// If not, branch
	sta.w	r_Palette,x
	jmp	FCFB_End

+
	lda.w	r_Fade_Pal,x			// Cap at the target color
	and.w	#%0111110000000000
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0000001111111111
	ora.b	r_Color
	sta.w	r_Palette,x

	lda.w	r_Palette,x			// Fade green
	clc
	adc.w	#$04<<5
	cmp	r_Fade_Pal,x			// Has it reached the target color?
	bcs	+				// If so, branch
	sta.w	r_Palette,x			// Store the color
	jmp	FCFB_End

+
	lda.w	r_Fade_Pal,x			// Cap at the target color
	and.w	#%0000001111100000
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0111110000011111
	ora.b	r_Color
	sta.w	r_Palette,x

	lda.w	r_Palette,x			// Fade red
	clc
	adc.w	#$04
	cmp	r_Fade_Pal,x			// Has it reached the target color?
	bcs	+				// If so, branch
	sta.w	r_Palette,x			// Store the color
	jmp	FCFB_End

+
	lda.w	r_Fade_Pal,x			// Cap at the target color
	and.w	#%0000000000011111
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0111111111100000
	ora.b	r_Color
	sta.w	r_Palette,x

FCFB_End:
	inx	#2
	rts

// ---------------------------------------------------------------------
// Fade the palette to black
// ---------------------------------------------------------------------

FadeToBlack:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.w	#$FF00				// Set fade settings
	sta.b	r_Pal_Fade
	lda.w	#8*3				// Loop count
	sta.b	r_Counter_2

-
	lda.w	#$12				// VSync
	jsl	VSync
	jsl	FadeToBlackOnce			// Fade once
	dec	r_Counter_2			// Next fade session
	bne	-
	lda.w	#$12				// VSync
	jsl	VSync

	plp
	rtl

// ---------------------------------------------------------------------

FadeToBlackOnce:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.b	r_Pal_Fade			// Get starting index for palette 1
	and.w	#$FF
	tax
	lda.b	r_Pal_Fade+1			// Get length
	and.w	#$FF
	tay

-
	jsr	FadeColorToBlack		// Fade color
	dey					// Next color
	bpl	-

	lda.b	r_Pal_Fade			// Get starting index for palette 2
	and.w	#$FF
	adc.w	#r_Palette_2-r_Palette
	tax
	lda.b	r_Pal_Fade+1			// Get length
	and.w	#$FF
	tay

-
	jsr	FadeColorToBlack		// Fade color
	dey					// Next color
	bpl	-

	plp
	rtl

// ---------------------------------------------------------------------

FadeColorToBlack:
	lda.w	r_Palette,x			// Get color
	beq	FCTB_End			// If it's already black, branch
	and.w	#%11111				// Is red 0?
	beq	++				// If so, branch
	sec					// Fade red
	sbc.w	#$04
	bpl	+
	lda.w	#$00

+
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0111111111100000
	ora.b	r_Color
	sta.w	r_Palette,x
	jmp	FCTB_End

+
	lda.w	r_Palette,x			// Get green
	and.w	#%11111<<5			// Is green 0?
	beq	++				// If so, branch
	sec					// Fade green
	sbc.w	#$04<<5
	bpl	+
	lda.w	#$00

+
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0111110000011111
	ora.b	r_Color
	sta.w	r_Palette,x
	jmp	FCTB_End

+
	lda.w	r_Palette,x			// Get blue
	and.w	#%11111<<10			// Is blue 0?
	beq	FCTB_End			// If so, branch
	sec					// Fade blue
	sbc.w	#$04<<10
	bpl	+
	lda.w	#$00

+
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0000001111111111
	ora.b	r_Color
	sta.w	r_Palette,x

FCTB_End:
	inx	#2
	rts


// ---------------------------------------------------------------------
// Fade the palette from white
// ---------------------------------------------------------------------

FadeFromWhite:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.w	#$FF00				// Set fade settings
	sta.b	r_Pal_Fade
	jmp	+

FadeFromWhite_Alt:
	php
	rep	#P_A|P_XY			// 16 bit registers

+
	lda.w	#8*3				// Loop count
	sta.b	r_Counter_2

-
	lda.w	#$12				// VSync
	jsl	VSync
	jsl	FadeFromWhiteOnce		// Fade once
	dec	r_Counter_2			// Next fade session
	bne	-
	lda.w	#$12				// VSync
	jsl	VSync

	plp
	rtl

// ---------------------------------------------------------------------

FadeFromWhiteOnce:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.b	r_Pal_Fade			// Get starting index for palette 1
	and.w	#$FF
	tax
	lda.b	r_Pal_Fade+1			// Get length
	and.w	#$FF
	tay

-
	jsr	FadeColorFromWhite		// Fade color
	dey					// Next color
	bpl	-

	lda.b	r_Pal_Fade			// Get starting index for palette 2
	and.w	#$FF
	clc
	adc.w	#r_Palette_2-r_Palette
	tax
	lda.b	r_Pal_Fade+1			// Get length
	and.w	#$FF
	tay

-
	jsr	FadeColorFromWhite		// Fade color
	dey					// Next color
	bpl	-

	plp
	rtl

// ---------------------------------------------------------------------

FadeColorFromWhite:
	lda.w	r_Palette,x			// Get color
	cmp	r_Fade_Pal,x			// Has it already reached the target color?
	beq	FCFW_End			// If so, branch
	sec					// Fade blue
	sbc.w	#$04<<10
	bmi	+
	cmp.w	r_Fade_Pal,x			// Has it reached the target color?
	bcc	+				// If not, branch
	sta.w	r_Palette,x
	jmp	FCFW_End

+
	lda.w	r_Fade_Pal,x			// Cap at the target color
	and.w	#%0111110000000000
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0000001111111111
	ora.b	r_Color
	sta.w	r_Palette,x

	lda.w	r_Palette,x			// Fade green
	sec
	sbc.w	#$04<<5
	bmi	+
	cmp	r_Fade_Pal,x			// Has it reached the target color?
	bcc	+				// If so, branch
	sta.w	r_Palette,x			// Store the color
	jmp	FCFW_End

+
	lda.w	r_Fade_Pal,x			// Cap at the target color
	and.w	#%0000001111100000
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0111110000011111
	ora.b	r_Color
	sta.w	r_Palette,x

	lda.w	r_Palette,x			// Fade red
	sec
	sbc.w	#$04
	bmi	+
	cmp	r_Fade_Pal,x			// Has it reached the target color?
	bcc	+				// If so, branch
	sta.w	r_Palette,x			// Store the color
	jmp	FCFW_End

+
	lda.w	r_Fade_Pal,x			// Cap at the target color
	and.w	#%0000000000011111
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0111111111100000
	ora.b	r_Color
	sta.w	r_Palette,x

FCFW_End:
	inx	#2
	rts

// ---------------------------------------------------------------------
// Fade the palette to white
// ---------------------------------------------------------------------

FadeToWhite:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.w	#$FF00				// Set fade settings
	sta.b	r_Pal_Fade
	lda.w	#8*3				// Loop count
	sta.b	r_Counter_2

-
	lda.w	#$12				// VSync
	jsl	VSync
	jsl	FadeToWhiteOnce			// Fade once
	dec	r_Counter_2			// Next fade session
	bne	-
	lda.w	#$12				// VSync
	jsl	VSync

	plp
	rtl

// ---------------------------------------------------------------------

FadeToWhiteOnce:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.b	r_Pal_Fade			// Get starting index for palette 1
	and.w	#$FF
	tax
	lda.b	r_Pal_Fade+1			// Get length
	and.w	#$FF
	tay

-
	jsr	FadeColorToWhite		// Fade color
	dey					// Next color
	bpl	-

	lda.b	r_Pal_Fade			// Get starting index for palette 2
	and.w	#$FF
	adc.w	#r_Palette_2-r_Palette
	tax
	lda.b	r_Pal_Fade+1			// Get length
	and.w	#$FF
	tay

-
	jsr	FadeColorToWhite		// Fade color
	dey					// Next color
	bpl	-

	plp
	rtl

// ---------------------------------------------------------------------

FadeColorToWhite:
	lda.w	r_Palette,x			// Get color
	cmp.w	#%0111111111111111		// Is it already white?
	beq	FCTW_End			// If so, branch
	and.w	#%11111				// Is red at max?
	cmp.w	#%11111
	beq	++				// If so, branch
	clc					// Fade red
	adc.w	#$04
	cmp.w	#%11111
	bcc	+
	lda.w	#%11111

+
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0111111111100000
	ora.b	r_Color
	sta.w	r_Palette,x
	jmp	FCTW_End

+
	lda.w	r_Palette,x			// Get green
	and.w	#%11111<<5			// Is green at max?
	cmp.w	#%11111<<5
	beq	++				// If so, branch
	clc					// Fade green
	adc.w	#$04<<5
	cmp.w	#%11111<<5
	bcc	+
	lda.w	#%11111<<5

+
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0111110000011111
	ora.b	r_Color
	sta.w	r_Palette,x
	jmp	FCTW_End

+
	lda.w	r_Palette,x			// Get blue
	and.w	#%11111<<10			// Is blue at max?
	cmp.w	#%11111<<10
	beq	FCTW_End			// If so, branch
	clc					// Fade blue
	adc.w	#$04<<10
	cmp.w	#%11111<<10
	bcc	+
	lda.w	#%11111<<10

+
	sta.b	r_Color				// Store the color
	lda.w	r_Palette,x
	and.w	#%0000001111111111
	ora.b	r_Color
	sta.w	r_Palette,x

FCTW_End:
	inx	#2
	rts

// ---------------------------------------------------------------------
