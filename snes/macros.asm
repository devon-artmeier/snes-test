
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		macros.asm
//	Contents:	SNES and assembler macros
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Seek
// ---------------------------------------------------------------------

macro seek(variable offset) {
	origin offset
	base offset
}

// ---------------------------------------------------------------------
// Seek within the bank
// ---------------------------------------------------------------------

macro bankseek(variable offset) {
	origin (offset & $7FFF)
	if (offset & $FF0000 == $7E0000 || offset & $FF0000 == $7F0000) {
		base offset
	} else {
		base ($800000*ROM_SPEED)|(offset & $7FFFFF)
	}
}

// ---------------------------------------------------------------------
// Set the current ROM bank
// ---------------------------------------------------------------------

macro rombank(variable bank) {
	origin bank*$8000
	base ($800000*ROM_SPEED)|((bank*$10000)+$8000)
}

// ---------------------------------------------------------------------
// Check if the PC has gone past a specific address in a bank
// ---------------------------------------------------------------------

macro chkBank(variable bank, variable offset) {
	variable offchk(($800000*ROM_SPEED)|((bank*$10000)+$8000+offset))
	if (pc() > offchk) {
		print "error: Bank ", bank, " is too large by ", pc()-offchk, " bytes\n"
		error "Bank size too large"
	}
}

macro chkBank(variable bank) {
	chkBank(bank, $8000)
}

// ---------------------------------------------------------------------
// Fill a section of VRAM with a value at an address
// ---------------------------------------------------------------------
// REQUIRES:
//	16 bit accumulator
//	8 bit index
// BREAKS:
//	A, X
// ---------------------------------------------------------------------

macro fillVRAM(variable source, variable dest, variable length) {
	ldx.b	#$80				// Set VRAM increment
	stx.w	REG_VMAIN

	lda.w	#$09|((REG_VMDATAL&$FF)<<8)	// DMA fixed source alternate byte write to VRAM
	sta.w	REG_DMAP0

	lda.w	#source				// DMA source
	sta.w	REG_A1T0L
	ldx.b	#source>>16
	stx.w	REG_A1B0

	lda.w	#length				// DMA length
	sta.w	REG_DAS0L

	lda.w	#dest/2				// VRAM address
	sta.w	REG_VMADDL

	ldx.b	#$01				// Select DMA channel and start transfer
	stx.w	REG_MDMAEN
}

// ---------------------------------------------------------------------
// DMA to VRAM
// ---------------------------------------------------------------------
// REQUIRES:
//	16 bit accumulator
//	8 bit index
// BREAKS:
//	A, X
// ---------------------------------------------------------------------

macro dmaVRAM(variable source, variable dest, variable length) {
	ldx.b	#$80				// Set VRAM increment
	stx.w	REG_VMAIN

	lda.w	#$01|((REG_VMDATAL&$FF)<<8)	// DMA to VRAM
	sta.w	REG_DMAP0

	lda.w	#source				// DMA source
	sta.w	REG_A1T0L
	ldx.b	#source>>16
	stx.w	REG_A1B0

	lda.w	#length				// DMA length
	sta.w	REG_DAS0L

	lda.w	#dest/2				// VRAM address
	sta.w	REG_VMADDL

	ldx.b	#$01				// Select DMA channel and start transfer
	stx.w	REG_MDMAEN
}

// ---------------------------------------------------------------------
// DMA to CGRAM
// ---------------------------------------------------------------------
// REQUIRES:
//	16 bit accumulator
//	8 bit index
// BREAKS:
//	A, X
// ---------------------------------------------------------------------

macro dmaCGRAM(variable source) {
	lda.w	#$00|((REG_CGDATA&$FF)<<8)	// DMA to CGRAM
	sta.w	REG_DMAP0

	lda.w	#source				// DMA source
	sta.w	REG_A1T0L
	ldx.b	#source>>16
	stx.w	REG_A1B0

	lda.w	#$200				// DMA length
	sta.w	REG_DAS0L

	ldx.b	#$00				// CGRAM address
	stx.w	REG_CGADD

	ldx.b	#$01				// Select DMA channel and start transfer
	stx.w	REG_MDMAEN
}

// ---------------------------------------------------------------------
// DMA to OAM
// ---------------------------------------------------------------------
// REQUIRES:
//	16 bit accumulator
//	8 bit index
// BREAKS:
//	A, X
// ---------------------------------------------------------------------

macro dmaOAM(variable source) {
	lda.w	#$00|((REG_OAMDATA&$FF)<<8)	// DMA to OAM
	sta.w	REG_DMAP0

	lda.w	#source				// DMA source
	sta.w	REG_A1T0L
	ldx.b	#source>>16
	stx.w	REG_A1B0

	lda.w	#$220				// DMA length
	sta.w	REG_DAS0L

	stz.w	REG_OAMADDL			// OAM address

	ldx.b	#$01				// Select DMA channel and start transfer
	stx.w	REG_MDMAEN
}

// ---------------------------------------------------------------------
// Convert RGB to a CGRAM color
// ---------------------------------------------------------------------

macro rgb(variable r, variable g, variable b) {
	dw ((b&$1F)<<10)|((g&$1F)<<5)|(r&$1F)
}

// ---------------------------------------------------------------------
// Clear an area of memory
// ---------------------------------------------------------------------
// REQUIRES:
//	16 bit accumulator
//	16 bit index
// BREAKS:
//	A, X, Y
// ---------------------------------------------------------------------

macro clrMem(variable src, variable end) {
	phb
	lda.w	#$0000
	sta.l	src
	lda.w	#end-src-2-1
	ldx.w	#src
	ldy.w	#src+2
	mvn	(src>>16)=(src>>16)
	plb
}

// ---------------------------------------------------------------------
// Load a 24 bit value into RAM
// ---------------------------------------------------------------------

macro lda24(variable value, variable addr) {
	lda.w	#value
	if (addr >= $7E2000) {
		sta.l	addr
	} else {
		if (addr < $7E0100) {
			sta.b	addr
		} else {
			sta.w	addr
		}
	}
	lda.w	#value>>8
	if (addr+1 >= $7E2000) {
		sta.l	addr+1
	} else {
		if (addr+1 < $7E0100) {
			sta.b	addr+1
		} else {
			sta.w	addr+1
		}
	}
}

// ---------------------------------------------------------------------
// Set an object's SST
// ---------------------------------------------------------------------

macro staSST(variable sst) {
	ldy.w	#sst				// Get SST
	sta	[r_Obj_Addr],y			// Set value
}

// ---------------------------------------------------------------------
// Get an object's SST
// ---------------------------------------------------------------------

macro ldaSST(variable sst) {
	ldy.w	#sst				// Get SST
	lda	[r_Obj_Addr],y			// Get value
}

// ---------------------------------------------------------------------
// Queue a DMA transfer
// ---------------------------------------------------------------------

macro queueDMA(variable src, variable vram, variable length) {
	lda24(src, r_DMA_Src)			// Set DMA source
	lda.w	#length				// Set DMA length
	sta.w	r_DMA_Len
	lda.w	#vram/2				// Set DMA destination
	sta.w	r_DMA_Dest
	jsl	QueueDMA			// Queue the transfer
}

// ---------------------------------------------------------------------
// Load a plane map
// ---------------------------------------------------------------------

macro loadPlane(variable data, variable vram, variable base) {
	lda24(data, r_Map_Data)
	if (vram == 0) {
		stz.w	r_Map_VRAM		// Set VRAM address
	} else {
		lda.w	#vram/2			// Set VRAM address
		sta.w	r_Map_VRAM
	}
	if (base == 0) {
		stz.b	r_Map_Tile		// Set base tile
	} else {
		lda.w	#base			// Set base tile
		sta.b	r_Map_Tile
	}
	jsl	DrawPlane
}

// ---------------------------------------------------------------------
// Load a palette
// ---------------------------------------------------------------------

macro loadPal(variable data, variable index) {
	lda24(data, r_Pal_Data)			// Get palette data
	if (index == 0) {
		stz.b	r_Pal_Index		// Set palette buffer index
	} else {
		lda.w	#index*2		// Set palette buffer index
		sta.b	r_Pal_Index
	}
	jsl	LoadPal				// Load palette
}

// ---------------------------------------------------------------------
// Load a fade palette
// ---------------------------------------------------------------------

macro loadFadePal(variable data, variable index) {
	lda24(data, r_Pal_Data)			// Get palette data
	if (index == 0) {
		stz.b	r_Pal_Index		// Set palette buffer index
	} else {
		lda.w	#index*2		// Set palette buffer index
		sta.b	r_Pal_Index
	}
	jsl	LoadFadePal			// Load palette
}

// ---------------------------------------------------------------------
// Decompress Kosinski data
// ---------------------------------------------------------------------

macro loadKosDat(variable data, variable dest) {
	lda24(data, r_Kos_Data)			// Set data pointer
	lda24(dest, r_Kos_Dest)			// Set destination pointer
	jsl	KosDec				// Decompress the data
}

// ---------------------------------------------------------------------
// Decompress Kosinski art
// ---------------------------------------------------------------------

macro loadKosArt(variable data, variable dest, variable vram) {
	loadKosDat(data, dest)			// Decompress data
	lda24(dest, r_DMA_Src)			// Set DMA source
	lda.w	#vram/2				// Set DMA destination
	sta.w	r_DMA_Dest
	lda.b	r_Kos_Dest			// Set DMA length
	if (dest&$FFFF > 0) {
		sec
		sbc.w	#dest
	}
	sta.w	r_DMA_Len
	jsl	QueueDMA			// Queue the transfer
}

// ---------------------------------------------------------------------
// Decompress Kosinski art immediately
// ---------------------------------------------------------------------

macro loadKosArtImm(variable data, variable dest, variable vram) {
	loadKosDat(data, dest)			// Decompress data

	ldx.b	#$80				// Set VRAM increment
	stx.w	REG_VMAIN

	lda.w	#$01|((REG_VMDATAL&$FF)<<8)	// DMA to VRAM
	sta.w	REG_DMAP0

	lda.w	#dest				// DMA source
	sta.w	REG_A1T0L
	ldx.b	#dest>>16
	stx.w	REG_A1B0

	lda.b	r_Kos_Dest			// DMA length
	if (dest&$FFFF > 0) {
		sec
		sbc.w	#dest
	}
	sta.w	REG_DAS0L

	lda.w	#vram/2				// VRAM address
	sta.w	REG_VMADDL

	ldx.b	#$01				// Select DMA channel and start transfer
	stx.w	REG_MDMAEN
}

// ---------------------------------------------------------------------
// Decompress Kosinski map
// ---------------------------------------------------------------------

macro loadKosMap(variable data, variable dest, variable vram, variable base) {
	loadKosDat(data, dest)			// Decompress data
	loadPlane(dest, vram, base)		// Load into VRAM
}

// ---------------------------------------------------------------------
// Queue Kosinski Moduled data
// ---------------------------------------------------------------------

macro queueKosM(variable data, variable vram) {
	lda24(data, r_KosM_Data)		// Source
	lda.w	#vram/2				// Destination
	sta.b	r_KosM_Dest
	jsl	QueueKosM
}

// ---------------------------------------------------------------------
// Wait for Kosinski Moduled art to be loaded
// ---------------------------------------------------------------------

macro waitKosM(variable routine) {
-;	jsl	ProcessKosM			// Process KosM queue
	lda.w	#routine
	jsl	VSync				// VSync
	jsl	ProcessKos			// Process Kos queue
	lda.w	r_KosMQ_Cnt			// Has all the KosM art been loaded?
	bne	-				// If not, wait
}

// ---------------------------------------------------------------------
