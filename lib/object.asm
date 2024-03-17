
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		lib/objects.asm
//	Contents:	Object functions
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Run objects
// ---------------------------------------------------------------------

RunObjects:
	php
	rep	#P_A|P_XY				// 16 bit registers

	ldx.w	#$0000					// Object RAM index

-
	lda.l	r_Objects+oAddr,x			// Check if an object is loaded in this slot
	bne	+
	lda.l	r_Objects+oAddr+1,x
	beq	++					// If not, go to the next slot
+
	phx
	php
	phb

	lda.w	#$5C					// Set up object run code
	sta.b	r_Obj_Run
	lda.l	r_Objects+oAddr,x
	sta.b	r_Obj_Run+1
	lda.l	r_Objects+oAddr+1,x
	sta.b	r_Obj_Run+2

	lda.w	#(r_Objects>>8)&$FF00			// Store object RAM address
	sta.b	r_Obj_Addr+1
	txa
	clc
	adc.w	#r_Objects
	sta.b	r_Obj_Addr

	jsl	r_Obj_Run				// Run the object

	plb
	plp
	plx

+
	txa
	clc
	adc.w	#oSize					// Next slot
	tax
	cpx.w	#r_Objects_End-r_Objects		// Have we reached the end of object RAM?
	bne	-					// If not, loop

	plp
	rtl

// ---------------------------------------------------------------------
// Display an object's sprite
// ---------------------------------------------------------------------

DisplayObject:
	php
	rep	#P_A					// 16 bit accumulator

	ldy.w	#oPrio-1				// Get priority
	lda	[r_Obj_Addr],y
	lsr
	and.w	#$380
	tax

	lda.l	r_Sprite_Queue,x			// Get priority level queue count
	cmp.w	#$7E					// Is the queue full?
	bcs	+					// If so, branch
	clc						// Incrementcount
	adc	#2
	sta.l	r_Sprite_Queue,x
	tax

	lda.b	r_Obj_Addr				// Add to queue
	sta.l	r_Sprite_Queue,x

+
	plp
	rtl

// ---------------------------------------------------------------------
// Render object sprites
// ---------------------------------------------------------------------

RenderObjects:
	php
	rep	#P_A|P_XY				// 16 bit registers

	stz.b	r_Spr_Count				// Reset sprite count

	lda.w	#r_Sprite_Queue				// Set up sprite queue offset
	sta.b	r_Spr_Queue_Off
	lda.w	#r_Sprite_Queue>>8
	sta.b	r_Spr_Queue_Off+1

	lda.w	#(r_Objects>>8)&$FF00			// Set bank in sprite queue object
	sta.b	r_Spr_Queue_Obj+1

RndObjs_LvlLoop:
	ldy.w	#$0000					// Sprite queue index
	lda	[r_Spr_Queue_Off],y			// Is this priority level used?
	bne	+					// If so, branch
	jmp	RndObjs_NextLvl				// Next priority level

+
	iny	#2					// Go to object list

RndObjs_ObjLoop:
	rep	#P_A					// 16 bit accumulator
	lda	[r_Spr_Queue_Off],y			// Get object RAM pointer
	sta.b	r_Spr_Queue_Obj
	iny	#2
	phy

	ldy.w	#oAddr					// Get object ID
	lda	[r_Spr_Queue_Obj],y
	bne	+
	iny
	lda	[r_Spr_Queue_Obj],y
	bne	+
	jmp	RndObjs_NextObj				// There's no object loaded

+
	sep	#P_A					// 8 bit accumulator

	ldy.w	#oRender				// Get render flags
	lda	[r_Spr_Queue_Obj],y
	sta.b	r_Spr_Flags
	rep	#P_A					// 16 bit accumulator
	and.w	#~rOnScr				// Clear on screen flag
	bit.w	#rCam					// Are we drawing the sprite relative to the camera?
	beq	RndObjs_ScrDraw				// If not, branch

	ldy.w	#oX					// Get X position
	lda	[r_Spr_Queue_Obj],y
	sec						// Add plane X position
	sbc.b	r_BG_A_X
	sta.b	r_Spr_X					// Store object sprite X position

	ldy.w	#oY					// Get Y position
	lda	[r_Spr_Queue_Obj],y
	sec						// Add plane Y position
	sbc.b	r_BG_A_Y
	sta.b	r_Spr_Y					// Store object sprite Y position

	ldy.w	#oDrawW					// Get right draw boundary
	lda	[r_Spr_Queue_Obj],y
	and.w	#$FF
	clc
	adc.b	r_Spr_X
	bpl	+
	jmp	RndObjs_NextObj				// If we are off screen, branch
	
+
	lda	[r_Spr_Queue_Obj],y			// Get left draw boundary
	and.w	#$FF
	eor.w	#$FFFF
	inc
	clc
	adc.b	r_Spr_X
	cmp.w	#256
	bmi	+
	jmp	RndObjs_NextObj				// If we are off screen, branch

+
	lda.b	r_Spr_Flags				// Should we do a Y check?
	bit.w	#rYChk
	beq	++					// If not, branch
	ldy.w	#oColH					// Get bottom draw boundary
	lda	[r_Spr_Queue_Obj],y
	and.w	#$FF
	clc
	adc.b	r_Spr_Y
	bpl	+
	jmp	RndObjs_NextObj				// If we are off screen, branch

+
	lda	[r_Spr_Queue_Obj],y			// Get top draw boundary
	and.w	#$FF
	eor.w	#$FFFF
	inc
	clc
	adc.b	r_Spr_Y
	cmp.w	#224					// Are we off screen?
	bmi	RndObjs_StartDraw			// If not, branch
	jmp	RndObjs_NextObj				// Off screen

RndObjs_ScrDraw:
	ldy.w	#oX					// Get X position
	lda	[r_Spr_Queue_Obj],y
	sta.b	r_Spr_X					// Store object sprite X position

	ldy.w	#oY					// Get Y position
	lda	[r_Spr_Queue_Obj],y
	sta.b	r_Spr_Y					// Store object sprite Y position

	jmp	RndObjs_StartDraw			// Start drawing

+
	lda.b	r_Spr_Y					// Check if the sprite is on screen vertically
	cmp.w	#-32
	bmi	RndObjs_NextObj
	cmp.w	#256
	bpl	RndObjs_NextObj

RndObjs_StartDraw:
	ldy.w	#oMap					// Get mappings data
	lda	[r_Spr_Queue_Obj],y
	sta.b	r_Spr_Map
	iny
	lda	[r_Spr_Queue_Obj],y
	sta.b	r_Spr_Map+1

	lda.w	#$0001					// Set sprite piece count to 1
	sta.b	r_Spr_Pieces

	lda.b	r_Spr_Flags				// Is this a direct pointer to sprite data?
	bit.w	#rDirect
	bne	+					// If so, branch

	ldy.w	#oFrame					// Get pointer to sprite data
	lda	[r_Spr_Queue_Obj],y
	and.w	#$FF
	asl
	phy
	tay
	lda	[r_Spr_Map],y
	clc
	adc.b	r_Spr_Map
	sta.b	r_Spr_Map

	ldy.w	#$0000					// Get sprite piece count
	lda	[r_Spr_Map],y
	ply
	sta.b	r_Spr_Pieces
	beq	++
	bmi	++
	inc	r_Spr_Map
	inc	r_Spr_Map

+
	ldy.w	#oTile					// Get base tile
	lda	[r_Spr_Queue_Obj],y
	sta.b	r_Spr_Tile

	lda.b	r_Spr_Flags				// Get flip flags
	xba
	asl	#6
	and.w	#$C000
	sta.b	r_Spr_Flip

	phy
	jsl	DrawSprite				// Draw the sprite
	ply

+
	sep	#P_A					// 8 bit accumulator

	ldy.w	#oRender				// Set on screen flag
	lda	[r_Spr_Queue_Obj],y
	ora.b	#rOnScr

RndObjs_NextObj:
	rep	#P_A					// 16 bit accumulator
	ldy.w	#$0000					// Decrement priority level queue count
	lda	[r_Spr_Queue_Off],y
	sec
	sbc.w	#$02
	sta	[r_Spr_Queue_Off],y
	ply
	cmp.w	#$0000					// Are we done with this priority level?
	beq	RndObjs_NextLvl				// If so, branch
	jmp	RndObjs_ObjLoop				// Loop

RndObjs_NextLvl:
	rep	#P_A					// 16 bit accumulator

	lda.b	r_Spr_Queue_Off				// Next priority level
	clc
	adc.w	#$80
	cmp.w	#r_Spr_Queue_End
	beq	RndObjs_Finish
	sta.b	r_Spr_Queue_Off
	jmp	RndObjs_LvlLoop

RndObjs_Finish:
	plp
	rtl

// ---------------------------------------------------------------------
