
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		flags.asm
//	Contents:	Assembler flags
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------

// Game title
define GAME_TITLE("MasterF0x's Cum Quest")

// ROM speed
// $00 = SlowROM
// $01 = FastROM
constant ROM_SPEED($01)

// ROM mode
// $00 = LoROM
// $01 = HiROM
// $02 = LoROM + S-DD1
// $03 = HiROM + SA-1
// $05 = ExHiROM
// $0A = HiROM + SPC7110
constant ROM_MODE($00)

// ROM co-processor
// $00 = DSP
// $01 = GSU
// $02 = OBC1
// $03 = SA-1
// $04 = S-DD1
// $05 = S-RTC
constant ROM_COPROC($00)

// ROM type
// $00 = ROM
// $01 = ROM + RAM
// $02 = ROM + RAM + battery
// $03 = ROM + co-processor
// $04 = ROM + co-processor + RAM
// $05 = ROM + co-processor + RAM + battery
// $06 = ROM + co-processor + battery
// $09 = ROM + co-processor + RAM + battery + RTC-4513
// $0A = ROM + co-processor + RAM + battery + Overclocked
constant ROM_TYPE($00)

// Number of ROM banks
// $01 = 1 bank		$07 = 7 banks
// $02 = 2 banks	$08 = 8 banks
// $03 = 3 banks	$09 = 16 banks
// $04 = 4 banks	$0A = 32 banks
// $05 = 5 banks	$0B = 64 banks
// $06 = 6 banks	$0C = 128 banks 
constant ROM_BANKS($09)

// SRAM size
// $00 = None		$04 = 16 KB
// $01 = 2 KB		$05 = 32 KB
// $02 = 4 KB		$06 = 64 KB
// $03 = 8 KB		$07 = 128 KB
constant SRAM_SIZE($00)

// Region
// $00 = Japan (NTSC)			$09 = Germany, Austra, Switzerland (PAL)
// $01 = USA, Canada (NTSC)		$0A = Italy (PAL)
// $02 = Europe (PAL)			$0B = China, Hong Kong (PAL)
// $03 = Sweden, Scandinavia (PAL)	$0C = Indonesia (PAL)
// $04 = Finland (PAL)			$0D = South Korea (NTSC)
// $05 = Denmark (PAL)			$0E = Common (ANY)
// $06 = France (SECAM)			$0F = Canada (NTSC)
// $07 = Holland (PAL)			$10 = Brazil (PAL-M)
// $08 = Spain (NTSC)			$11 = Australia (PAL)
constant REGION($0E)

// ---------------------------------------------------------------------
