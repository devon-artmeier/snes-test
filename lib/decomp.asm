
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		lib/decomp.asm
//	Contents:	Decompression functions
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Decompress Kosinski compressed data
// Based on vladikcomper's optimized version with improvements
// by Flamewing and MarkeyJester
// ---------------------------------------------------------------------

macro _Kos_RunBitStream() {
	dec	r_Kos_Repeat
	bpl	+
	lda.b	#$07				// Set repeat count to 8
	sta.b	r_Kos_Repeat
	lda.b	r_Kos_Desc+1			// Use the remaining 8 bits
	sta.b	r_Kos_Desc
	lda.b	r_Kos_Switch			// Have all 16 bits been used up?
	eor.b	#$FF
	sta.b	r_Kos_Switch
	bne	+				// If not, branch
	lda	[r_Kos_Data],y			// Get description field low byte
	iny
	sta.b	r_Kos_Desc
	lda	[r_Kos_Data],y			// Get description field high byte
	iny
	sta.b	r_Kos_Desc+1
+
}

macro _Kos_ReadBit() {
	lda.b	r_Kos_Desc
	lsr					// Get a bit from the bitstream
	sta.b	r_Kos_Desc
}

// ---------------------------------------------------------------------

KosDec:
	php
	phb
	phk					// Data bank = program bank
	plb
	rep	#P_A|P_XY			// 16 bit registers

	ldy.w	#$0000				// Reset data index		
	lda.w	#(1<<3)-1			// Set unroll mask
	sta.b	r_Kos_Unroll

	sep	#P_A				// 8 bit accumulator

	lda	[r_Kos_Data],y			// Get description field low byte
	iny
	sta.b	r_Kos_Desc
	lda	[r_Kos_Data],y			// Get description field high byte
	iny
	sta.b	r_Kos_Desc+1

	lda.b	#$07				// Set repeat count to 8
	sta.b	r_Kos_Repeat
	stz.b	r_Kos_Switch			// Reset description field switcher
	jmp	Kos_FetchNewCode

// ---------------------------------------------------------------------

Kos_FetchCodeLoop:
	// Code 1 (Uncompressed byte)
	_Kos_RunBitStream()
	lda	[r_Kos_Data],y
	iny
	sta	[r_Kos_Dest]
	rep	#P_A
	inc	r_Kos_Dest

Kos_FetchNewCode:
	sep	#P_A
	_Kos_ReadBit()
	bcs	Kos_FetchCodeLoop		// If code = 1, branch

	// Codes 00 and 01
	lda.b	r_Kos_Dest
	sta.b	r_Kos_Copy
	lda.b	r_Kos_Dest+1
	sta.b	r_Kos_Copy+1
	lda.b	r_Kos_Dest+2
	sta.b	r_Kos_Copy+2
	_Kos_RunBitStream()

	_Kos_ReadBit()
	bcc	+
	jmp	Kos_Code_01
+
	// Code 00 (Dictionary ref. short)
	_Kos_RunBitStream()
	_Kos_ReadBit()
	bcc	+
	jmp	Kos_Copy45
+
	_Kos_RunBitStream()
	_Kos_ReadBit()
	bcs	Kos_Copy3
	_Kos_RunBitStream()
	rep	#P_A
	lda	[r_Kos_Data],y			// Get displacement
	iny
	ora.w	#$FF00
	clc
	adc.b	r_Kos_Copy
	sta.b	r_Kos_Copy
	define c(0)
	while ({c} < 2) {
		lda	[r_Kos_Copy]
		sta	[r_Kos_Dest]
		inc	r_Kos_Dest
		inc	r_Kos_Copy
		evaluate c({c} + 1)
	}
	jmp	Kos_FetchNewCode

// ---------------------------------------------------------------------

Kos_Copy3:
	_Kos_RunBitStream()
	rep	#P_A
	lda	[r_Kos_Data],y			// Get displacement
	iny
	ora.w	#$FF00
	clc
	adc.b	r_Kos_Copy
	sta.b	r_Kos_Copy
	define c(0)
	while ({c} < 3) {
		lda	[r_Kos_Copy]
		sta	[r_Kos_Dest]
		inc	r_Kos_Dest
		inc	r_Kos_Copy
		evaluate c({c} + 1)
	}
	jmp	Kos_FetchNewCode

// ---------------------------------------------------------------------

Kos_Copy45:
	_Kos_RunBitStream()
	_Kos_ReadBit()
	bcs	Kos_Copy5
	_Kos_RunBitStream()
	rep	#P_A
	lda	[r_Kos_Data],y			// Get displacement
	iny
	ora.w	#$FF00
	clc
	adc.b	r_Kos_Copy
	sta.b	r_Kos_Copy
	define c(0)
	while ({c} < 4) {
		lda	[r_Kos_Copy]
		sta	[r_Kos_Dest]
		inc	r_Kos_Dest
		inc	r_Kos_Copy
		evaluate c({c} + 1)
	}
	jmp	Kos_FetchNewCode

// ---------------------------------------------------------------------

Kos_Copy5:
	_Kos_RunBitStream()
	rep	#P_A
	lda	[r_Kos_Data],y			// Get displacement
	iny
	ora.w	#$FF00
	clc
	adc.b	r_Kos_Copy
	sta.b	r_Kos_Copy
	define c(0)
	while ({c} < 5) {
		lda	[r_Kos_Copy]
		sta	[r_Kos_Dest]
		inc	r_Kos_Dest
		inc	r_Kos_Copy
		evaluate c({c} + 1)
	}
	jmp	Kos_FetchNewCode

// ---------------------------------------------------------------------

Kos_Code_01:
	// Code 01 (Dictionary ref. long/special)
	_Kos_RunBitStream()
	rep	#P_A
	lda	[r_Kos_Data],y			// Copy count = %HHHHHCCC LLLLLLLL
	sta.b	r_Kos_Count
	iny
	iny
	lda.b	r_Kos_Count+1			// Displacement = %11111111 HHHHHCCC
	ora.w	#$FF00
	asl	#5				// Displacement = %111HHHHH 00000000
	and.w	#$FF00
	sta.b	r_Kos_Displace
	lda.b	r_Kos_Count			// Displacement = %111HHHHH LLLLLLLL
	and.w	#$FF
	ora.b	r_Kos_Displace
	sta.b	r_Kos_Displace
	lda.b	r_Kos_Count			// Copy count = %00000CCC
	xba
	and.w	#$07
	sta.b	r_Kos_Count
	beq	+
	jmp	Kos_StreamCopy
+
	// Special mode (extended counter)
	lda	[r_Kos_Data],y			// Read cnt
	iny
	and.w	#$FF
	bne	+
	jmp	Kos_Quit			// If cnt=0, quit decompression
+
	dec
	bne	+
	jmp	Kos_FetchNewCode		// If cnt=1, fetch a new code
+
	sta.b	r_Kos_Count

	lda.b	r_Kos_Copy
	clc
	adc.b	r_Kos_Displace
	sta.b	r_Kos_Copy

	sep	#P_A
	lda	[r_Kos_Copy]			// Do 1 extra copy (to compensate +1 to copy counter)
	sta	[r_Kos_Dest]
	rep	#P_A
	inc	r_Kos_Copy
	inc	r_Kos_Dest

	lda.b	r_Kos_Count
	eor.w	#$FFFF
	and.b	r_Kos_Unroll
	asl
	tax
	lda.b	r_Kos_Count
	lsr	#3
	sta.b	r_Kos_Count
	jmp	(Kos_LargeCopy,x)

// ---------------------------------------------------------------------

Kos_LargeCopy:
	define c(0)
	while ({c} < (1<<3)) {
		dw	Kos_LargeCopy{c}
		evaluate c({c} + 1)
	}
	define c(0)
	while ({c} < (1<<3)-1) {
		Kos_LargeCopy{c}:
			lda	[r_Kos_Copy]
			sta	[r_Kos_Dest]
			inc	r_Kos_Copy
			inc	r_Kos_Dest
		evaluate c({c} + 1)
	}
	Kos_LargeCopy{c}:
		sep	#P_A
		lda	[r_Kos_Copy]
		sta	[r_Kos_Dest]
		rep	#P_A
		inc	r_Kos_Copy
		inc	r_Kos_Dest
		dec	r_Kos_Count
		bmi	+
		jmp	Kos_LargeCopy0
	+
		jmp	Kos_FetchNewCode

// ---------------------------------------------------------------------

Kos_StreamCopy:
	lda.b	r_Kos_Copy
	clc
	adc.b	r_Kos_Displace
	sta.b	r_Kos_Copy

	sep	#P_A
	lda	[r_Kos_Copy]			// Do 1 extra copy (to compensate +1 to copy counter)
	sta	[r_Kos_Dest]
	rep	#P_A
	inc	r_Kos_Copy
	inc	r_Kos_Dest
	
	lda.b	r_Kos_Count
	eor.b	r_Kos_Unroll
	asl
	tax
	jmp	(Kos_MediumCopy,x)

// ---------------------------------------------------------------------

Kos_MediumCopy:
	define c(0)
	while ({c} < 8) {
		dw	Kos_MediumCopy{c}
		evaluate c({c} + 1)
	}
	define c(0)
	while ({c} < 7) {
		Kos_MediumCopy{c}:
			lda	[r_Kos_Copy]
			sta	[r_Kos_Dest]
			inc	r_Kos_Copy
			inc	r_Kos_Dest
		evaluate c({c} + 1)
	}
Kos_MediumCopy{c}:
	sep	#P_A
	lda	[r_Kos_Copy]
	sta	[r_Kos_Dest]
	rep	#P_A
	inc	r_Kos_Copy
	inc	r_Kos_Dest
	jmp	Kos_FetchNewCode

// ---------------------------------------------------------------------

Kos_Quit:
	plb
	plp
	rtl

// ---------------------------------------------------------------------
// Queue Kosinski Moduled data for decompression
// ---------------------------------------------------------------------

QueueKosM:
	php
	rep	#P_A|P_XY			// 16 bit registers

	ldx.w	#$0000				// Index of KosM slot

	lda.b	r_KosM_Data			// Store as current data to be decompressed
	sta.b	r_KosMQ_Data
	lda.b	r_KosM_Data+1
	sta.b	r_KosMQ_Data+1
	lda.b	r_KosM_Dest
	sta.b	r_KosMQ_VRAM

	lda.w	r_KosMQ_Src			// Is the first slot free?
	bne	+
	lda.w	r_KosMQ_Src+1
	bne	+
	jsr	ProcessKosM_Init		// If it is, branch
	jmp	QueueKosM_End
+
-
	inx	#5				// If not, check next slot
	lda.w	r_KosMQ_Src,x			// Is this slot free?
	bne	-
	lda.w	r_KosMQ_Src+1,x
	bne	-

	lda.b	r_KosMQ_Data			// Store source address
	sta.w	r_KosMQ_Src,x
	lda.b	r_KosMQ_Data+1
	sta.w	r_KosMQ_Src+1,x
	lda.b	r_KosMQ_VRAM			// Store destination VRAM address
	sta.w	r_KosMQ_Dest,x

QueueKosM_End:
	plp
	rtl

// ---------------------------------------------------------------------
// Initialize the processing of the first module on the queue
// ---------------------------------------------------------------------

ProcessKosM_Init:
	lda	[r_KosMQ_Data]			// Get uncompressed size
	inc	r_KosMQ_Data
	inc	r_KosMQ_Data
	xba
	cmp.w	#$A000				// $A000 means $8000 for some reason
	bne	+
	lda.w	#$8000
+
	sta.w	r_KosMQ_Last_Sz
	lsr
	rol	#6
	and.w	#$1F				// Get number of complete modules
	sta.w	r_KosMQ_Cnt
	lda.w	r_KosMQ_Last_Sz
	and.w	#$FFF				// Get size of last module in words
	bne	+
	dec	r_KosMQ_Cnt			// Otherwise decrement the number of modules
	lda.w	#$1000				// And take the size of the last module to be $1000 bytes
+
	sta.w	r_KosMQ_Last_Sz
	lda.b	r_KosMQ_VRAM
	sta.w	r_KosMQ_Dest
	lda.b	r_KosMQ_Data
	sta.w	r_KosMQ_Src
	lda.b	r_KosMQ_Data+1
	sta.w	r_KosMQ_Src+1
	inc	r_KosMQ_Cnt			// Sotre total number of modules
	rts

// ---------------------------------------------------------------------
// Process the first module on the queue
// ---------------------------------------------------------------------

ProcessKosM:
	php
	rep	#P_A|P_XY			// 16 bit registers
	lda.w	r_KosMQ_Cnt
	bne	+
	jmp	ProcessKosM_Exit
+
	bmi	++

	lda.w	r_KosQ_Index
	cmp.w	#r_KosQ_List_End-r_KosQ_List
	bmi	+
	jmp	ProcessKosM_Exit		// Branch if the Kosinski decompression queue is full
+	
	lda.w	r_KosMQ_Src
	sta.w	r_KosQ_Data
	lda.w	r_KosMQ_Src+1
	sta.w	r_KosQ_Data+1
	lda24(r_KosM_Buffer, r_KosQ_Buffer)
	jsl	QueueKos			// Add current module to decompression queue
	lda.w	r_KosMQ_Cnt			// And set bit to signify decompression in progress
	ora.w	#$8000
	sta.w	r_KosMQ_Cnt
	jmp	ProcessKosM_Exit
+
	lda.w	r_KosQ_Index
	beq	+
	jmp	ProcessKosM_Exit		// Branch if the decompression isn't complete
+
	// Otherwise, DMA the decompressed data to VRAM
	lda.w	r_KosMQ_Cnt
	and.w	#$7FFF
	sta.w	r_KosMQ_Cnt
	lda.w	#$1000
	dec	r_KosMQ_Cnt
	bne	+				// Branch if it isn't the last module
	lda.w	r_KosMQ_Last_Sz
+
	sta.w	r_DMA_Len
	lda.w	r_KosMQ_Dest
	sta.w	r_DMA_Dest
	lda.w	r_DMA_Len
	lsr
	clc
	adc.w	r_KosMQ_Dest
	sta.w	r_KosMQ_Dest			// Set new destination
	lda.w	r_KosMQ_Src
	sec
	sbc.w	r_KosQ_Src
	and.w	#$F
	clc
	adc.w	r_KosQ_Src			// Round to the nearest $10 boundary
	sta.w	r_KosMQ_Src			// And set new source
	lda24(r_KosM_Buffer, r_DMA_Src)
	jsl	QueueDMA

	lda.w	r_KosMQ_Cnt
	beq	+
	jmp	ProcessKosM_Exit		// Return if this wasn't the last module
+
	define c(0)
	while ({c} < (r_KosMQ_List_End-r_KosMQ_List)-5) {
		lda.w	r_KosMQ_Src+{c}+5
		sta.w	r_KosMQ_Src+{c}
		lda.w	r_KosMQ_Src+{c}+5+1
		sta.w	r_KosMQ_Src+{c}+1
		lda.w	r_KosMQ_Dest+{c}+5
		sta.w	r_KosMQ_Dest+{c}
		evaluate c({c} + 5)
	}
	stz.w	r_KosMQ_Src+{c}
	stz.w	r_KosMQ_Src+{c}+1
	stz.w	r_KosMQ_Dest+{c}

	lda.w	r_KosMQ_Src
	bne	+
	lda.w	r_KosMQ_Src+1
	beq	ProcessKosM_Exit		// Return if the queue is now empty
+
	lda.w	r_KosMQ_Src
	sta.b	r_KosMQ_Data
	lda.w	r_KosMQ_Src+1
	sta.b	r_KosMQ_Data+1
	lda.w	r_KosMQ_Dest
	sta.b	r_KosMQ_VRAM
	jsr	ProcessKosM_Init

ProcessKosM_Exit:
	plp
	rtl

// ---------------------------------------------------------------------
// Add Kosinski compressed data to the decompression queue
// ---------------------------------------------------------------------

QueueKos:
	php
	rep	#P_A|P_XY			// 16 bit registers

	ldx.w	r_KosQ_Index
	lda.w	r_KosQ_Data			// Store source
	sta.w	r_KosQ_Src,x
	lda.w	r_KosQ_Data+1
	sta.w	r_KosQ_Src+1,x
	lda.w	r_KosQ_Buffer			// Store destination
	sta.w	r_KosQ_Dest,x
	lda.w	r_KosQ_Buffer+1
	sta.w	r_KosQ_Dest+1,x
	txa
	clc
	adc.w	#$06
	sta.w	r_KosQ_Index

	plp
	rtl

// ---------------------------------------------------------------------
// Process the first entry in the Kosinski decompression queue
// ---------------------------------------------------------------------

ProcessKos:
	php
	rep	#P_A|P_XY			// 16 bit registers

	lda.w	r_KosQ_Index
	bmi	+				// Branch if decompression is still in progress
	bne	++
+
	jmp	ProcessKos_Done
+
	ora.w	#$8000				// Set sign bit to signify decompression in progress
	sta.w	r_KosQ_Index
	lda.w	r_KosQ_Src
	sta.w	r_Kos_Data
	lda.w	r_KosQ_Src+1
	sta.w	r_Kos_Data+1
	lda.w	r_KosQ_Dest
	sta.w	r_Kos_Dest
	lda.w	r_KosQ_Dest+1
	sta.w	r_Kos_Dest+1
	jsl	KosDec				// Decompress the data

	lda.b	r_Kos_Data+1
	sta.w	r_KosQ_Src+1
	tya
	clc
	adc.b	r_Kos_Data
	sta.w	r_KosQ_Src
	lda.b	r_Kos_Dest
	sta.w	r_KosQ_Dest
	lda.b	r_Kos_Dest+1
	sta.w	r_KosQ_Dest+1
	lda.w	r_KosQ_Index
	and.w	#$7FFF				// Clear decompression in progress bit
	sec
	sbc.w	#$06
	sta.w	r_KosQ_Index
	beq	ProcessKos_Done			// Branch if there aren't any entries remaining in the queue

	define c(0)				// Otherwise, shift all entries up
	while ({c} < (r_KosQ_List_End-r_KosQ_List)-6) {
		lda.w	r_KosQ_Src+{c}+6
		sta.w	r_KosQ_Src+{c}
		lda.w	r_KosQ_Src+{c}+6+1
		sta.w	r_KosQ_Src+{c}+1
		lda.w	r_KosQ_Dest+{c}+6
		sta.w	r_KosQ_Dest+{c}
		lda.w	r_KosQ_Dest+{c}+6+1
		sta.w	r_KosQ_Dest+{c}+1
		evaluate c({c} + 6)
	}
	stz.w	r_KosQ_Src+{c}
	stz.w	r_KosQ_Src+{c}+1
	stz.w	r_KosQ_Dest+{c}
	stz.w	r_KosQ_Dest+{c}+1

ProcessKos_Done:
	plp
	rtl

// ---------------------------------------------------------------------
