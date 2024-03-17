
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		_lib/int.asm
//	Contents:	Interrupt functions
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Do VSync
// ---------------------------------------------------------------------

VSync:
	php
	sep	#P_A|P_XY				// 8 bit registers

	ldx.b	#$80					// Enable NMI
	stx.w	REG_NMITIMEN

	sta.l	r_NMI_Routine				// Set NMI routine

	wai						// Wait for interrupt

	plp
	rtl

// ---------------------------------------------------------------------
