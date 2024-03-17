
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		ram.asm
//	Contents:	RAM definitions
//
// ---------------------------------------------------------------------

r_Scene:;		db	$00			// Scene ID
r_NMI_Routine:;		db	$00			// NMI routine

		if ($7F0000-pc() > 0) {
			fill	$7F0000-pc()
		}

r_Chunks:						// Level chunk data
r_Buffer:;		fill	$A400			// General buffer
r_Level:;		fill	$400			// Level layout data
r_Blocks:;		fill	$1800			// Level block data


	if (pc()>$800000) {
		print "error: System RAM is too large by ", pc()-$800000, " bytes\n"
		error "System RAM size too large"
	}

// ---------------------------------------------------------------------
