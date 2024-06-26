
// ---------------------------------------------------------------------
//
//	SNES Library
//		By Devon Artmeier 2019
//
//	File:		constants.asm
//	Contents:	SNES constants
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Memory map
// ---------------------------------------------------------------------

constant LOW_RAM($0000)				// LowRAM
constant ROM_SECTION($8000)			// ROM section
constant ROM_HEADER($FFC0)			// ROM header

// ---------------------------------------------------------------------
// PPU ports
// ---------------------------------------------------------------------

constant REG_INIDISP($2100)			// Display control 1
constant REG_OBSEL($2101)			// Object size and base
constant REG_OAMADDL($2102)			// OAM address (lower byte)
constant REG_OAMADDH($2103)			// OAM address (upper bit) and priority rotation
constant REG_OAMDATA($2104)			// OAM data write
constant REG_BGMODE($2105)			// BG mode and character size
constant REG_MOSAIC($2106)			// Mosaic size and enable
constant REG_BG1SC($2107)			// BG1 screen base and size
constant REG_BG2SC($2108)			// BG2 screen base and size
constant REG_BG3SC($2109)			// BG3 screen base and size
constant REG_BG4SC($210A)			// BG4 screen base and size
constant REG_BG12NBA($210B)			// BG1/BG2 character data area designation
constant REG_BG34NBA($210C)			// BG3/BG4 character data area designation
constant REG_BG1HOFS($210D)			// BG1 horizontal scroll / M7HOFS
constant REG_BG1VOFS($210E)			// BG1 vertical scroll / M7VOFS
constant REG_BG2HOFS($210F)			// BG2 horizontal scroll
constant REG_BG2VOFS($2110)			// BG2 vertical scroll
constant REG_BG3HOFS($2111)			// BG3 horizontal scroll
constant REG_BG3VOFS($2112)			// BG3 vertical scroll
constant REG_BG4HOFS($2113)			// BG4 horizontal scroll
constant REG_BG4VOFS($2114)			// BG4 vertical scroll
constant REG_VMAIN($2115)			// VRAM address increment mode
constant REG_VMADDL($2116)			// VRAM address (lower byte)
constant REG_VMADDH($2117)			// VRAM address (upper byte)
constant REG_VMDATAL($2118)			// VRAM data write (lower byte)
constant REG_VMDATAH($2119)			// VRAM data write (upper byte)
constant REG_M7SEL($211A)			// Mode 7 settings
constant REG_M7A($211B)				// Mode 7 A (cosine A) and 16-bit operand
constant REG_M7B($211C)				// Mode 7 B (sine A) and 8-bit operand
constant REG_M7C($211D)				// Mode 7 C (sine B)
constant REG_M7D($211E)				// Mode 7 D (cosine B)
constant REG_M7X($211F)				// Mode 7 center X
constant REG_M7Y($2120)				// Mode 7 center Y
constant REG_CGADD($2121)			// CGRAM address
constant REG_CGDATA($2122)			// CGRAM data write
constant REG_W12SEL($2123)			// Window BG1/BG2 mask settings
constant REG_W34SEL($2124)			// Window BG3/BG4 mask settings
constant REG_WOBJSEL($2125)			// Window OBJ/MATH mask settings
constant REG_WH0($2126)				// Window 1 left position
constant REG_WH1($2127)				// Window 1 right position
constant REG_WH2($2128)				// Window 2 left position
constant REG_WH3($2129)				// Window 2 right position
constant REG_WBGLOG($212A)			// Window 1/2 mask logic (BG1-4)
constant REG_WOBJLOG($212B)			// Window 1/2 mask logic (OBJ/MATH)
constant REG_TM($212C)				// Main screen designation
constant REG_TS($212D)				// Sub screen designation
constant REG_TMW($212E)				// Window area main screen disable
constant REG_TSW($212F)				// Window area sub screen disable
constant REG_CGWSEL($2130)			// Color math control A
constant REG_CGADSUB($2131)			// Color math control B
constant REG_COLDATA($2132)			// Color math sub screen backdrop color
constant REG_SETINI($2133)			// Display control 2
constant REG_MPYL($2134)			// PPU1 signed multiply result (lower byte)
constant REG_MPYM($2135)			// PPU1 signed multiply result (middle byte)
constant REG_MPYH($2136)			// PPU1 signed multiply result (upper byte)
constant REG_SLHV($2137)			// PPU1 latch H/V counter by software
constant REG_RDOAM($2138)			// PPU1 OAM data read
constant REG_RDVRAML($2139)			// PPU1 VRAM data read (lower byte)
constant REG_RDVRAMH($213A)			// PPU1 VRAM data read (upper byte)
constant REG_RDCGRAM($213B)			// PPU2 CGRAM data read
constant REG_OPHCT($213C)			// PPU2 horizontal counter latch
constant REG_OPVCT($213D)			// PPU2 vertical counter latch
constant REG_STAT77($213E)			// PPU1 status and version number
constant REG_STAT78($213F)			// PPU2 status and version number

// ---------------------------------------------------------------------
// APU ports
// ---------------------------------------------------------------------

constant REG_APUIO0($2140)			// Main CPU to Sound CPU communication port 0
constant REG_APUIO1($2141)			// Main CPU to Sound CPU communication port 1
constant REG_APUIO2($2142)			// Main CPU to Sound CPU communication port 2
constant REG_APUIO3($2143)			// Main CPU to Sound CPU communication port 3

// ---------------------------------------------------------------------
// WRAM ports
// ---------------------------------------------------------------------

constant REG_WMDATA($2180)			// WRAM data read/write
constant REG_WMADDL($2181)			// WRAM address (lower byte)
constant REG_WMADDM($2182)			// WRAM address (middle byte)
constant REG_WMADDH($2183)			// WRAM address (upper bit)

// ---------------------------------------------------------------------
// I/O ports
// ---------------------------------------------------------------------

constant REG_JOYWR($4016)			// Joypad output
constant REG_JOYA($4016)			// Joypad input register A
constant REG_JOYB($4017)			// Joypad input register B
constant REG_NMITIMEN($4200)			// Interrupt enable and joypad request
constant REG_WRIO($4201)			// Programmable I/O port
constant REG_WRMPYA($4202)			// Set unsigned 8-bit multiplicand
constant REG_WRMPYB($4203)			// Set unsigned 8-bit multiplier and start multiplication
constant REG_WRDIVL($4204)			// Set unsigned 16-bit dividend (lower byte)
constant REG_WRDIVH($4205)			// Set unsigned 16-bit dividend (upper byte)
constant REG_WRDIVB($4206)			// Set ungisned 8-bit divisor and start division
constant REG_HTIMEL($4207)			// H-Count timer setting (lower byte)
constant REG_HTIMEH($4208)			// H-Count timer setting (upper bit)
constant REG_VTIMEL($4209)			// V-Count timer setting (lower byte)
constant REG_VTIMEH($420A)			// V-Count timer setting (upper bit)
constant REG_MDMAEN($420B)			// Select general purpose DMA channels and start transfer
constant REG_HDMAEN($420C)			// Select HDMA channels
constant REG_MEMSEL($420D)			// Memory-2 waitstate control
constant REG_RDNMI($4210)			// V-Blank NMI flag and CPU version number
constant REG_TIMEUP($4211)			// H/V-Timer IRQ flag
constant REG_HVBJOY($4212)			// H/V-Blank flag and joypad busy flag
constant REG_RDIO($4213)			// Joypad programmable I/O port
constant REG_RDDIVL($4214)			// Unsigned division result (lower byte)
constant REG_RDDIVH($4215)			// Unsigned division result (upper byte)
constant REG_RDMPYL($4216)			// Unsigned division remainder / multiplication result (lower byte)
constant REG_RDMPYH($4217)			// Unsigned division remainder / multiplication result (upper byte)
constant REG_JOY1L($4218)			// Joypad 1 (Gameport 1, Pin 4) (Lower byte)
constant REG_JOY1H($4219)			// Joypad 1 (Gameport 1, Pin 4) (Upper byte)
constant REG_JOY2L($421A)			// Joypad 2 (Gameport 2, Pin 4) (Lower byte)
constant REG_JOY2H($421B)			// Joypad 2 (Gameport 2, Pin 4) (Upper byte)
constant REG_JOY3L($421C)			// Joypad 3 (Gameport 1, Pin 5) (Lower byte)
constant REG_JOY3H($421D)			// Joypad 3 (Gameport 1, Pin 5) (Upper byte)
constant REG_JOY4L($421E)			// Joypad 4 (Gameport 2, Pin 5) (Lower byte)
constant REG_JOY4H($421F)			// Joypad 2 (Gameport 2, Pin 5) (Upper byte)

// ---------------------------------------------------------------------
// DMA ports
// ---------------------------------------------------------------------

constant REG_DMAP0($4300)			// DMA0 DMA/HDMA parameters
constant REG_BBAD0($4301)			// DMA0 DMA/HDMA I/O bus address
constant REG_A1T0L($4302)			// DMA0 DMA/HDMA table start address (lower byte)
constant REG_A1T0H($4303)			// DMA0 DMA/HDMA table start address (upper byte)
constant REG_A1B0($4304)			// DMA0 DMA/HDMA table start address (bank)
constant REG_DAS0L($4305)			// DMA0 DMA count / Indirect HDMA address (lower byte)
constant REG_DAS0H($4306)			// DMA0 DMA count / Indirect HDMA address (upper byte)
constant REG_DASB0($4307)			// DMA0 Indirect HDMA address (bank)
constant REG_A2A0L($4308)			// DMA0 HDMA table current address (lower byte)
constant REG_A2A0H($4309)			// DMA0 HDMA table current address (upper byte)
constant REG_NTRL0($430A)			// DMA0 HDMA line counter (from current table entry)
constant REG_UNUSED0($430B)			// DMA0 unused byte
constant REG_MIRR0($430F)			// DMA0 mirror of unused byte

constant REG_DMAP1($4310)			// DMA1 DMA/HDMA parameters
constant REG_BBAD1($4311)			// DMA1 DMA/HDMA I/O bus address
constant REG_A1T1L($4312)			// DMA1 DMA/HDMA table start address (lower byte)
constant REG_A1T1H($4313)			// DMA1 DMA/HDMA table start address (upper byte)
constant REG_A1B1($4314)			// DMA1 DMA/HDMA table start address (bank)
constant REG_DAS1L($4315)			// DMA1 DMA count / Indirect HDMA address (lower byte)
constant REG_DAS1H($4316)			// DMA1 DMA count / Indirect HDMA address (upper byte)
constant REG_DASB1($4317)			// DMA1 Indirect HDMA address (bank)
constant REG_A2A1L($4318)			// DMA1 HDMA table current address (lower byte)
constant REG_A2A1H($4319)			// DMA1 HDMA table current address (upper byte)
constant REG_NTRL1($431A)			// DMA1 HDMA line counter (from current table entry)
constant REG_UNUSED1($431B)			// DMA1 unused byte
constant REG_MIRR1($431F)			// DMA1 mirror of unused byte

constant REG_DMAP2($4320)			// DMA2 DMA/HDMA parameters
constant REG_BBAD2($4321)			// DMA2 DMA/HDMA I/O bus address
constant REG_A1T2L($4322)			// DMA2 DMA/HDMA table start address (lower byte)
constant REG_A1T2H($4323)			// DMA2 DMA/HDMA table start address (upper byte)
constant REG_A1B2($4324)			// DMA2 DMA/HDMA table start address (bank)
constant REG_DAS2L($4325)			// DMA2 DMA count / Indirect HDMA address (lower byte)
constant REG_DAS2H($4326)			// DMA2 DMA count / Indirect HDMA address (upper byte)
constant REG_DASB2($4327)			// DMA2 Indirect HDMA address (bank)
constant REG_A2A2L($4328)			// DMA2 HDMA table current address (lower byte)
constant REG_A2A2H($4329)			// DMA2 HDMA table current address (upper byte)
constant REG_NTRL2($432A)			// DMA2 HDMA line counter (from current table entry)
constant REG_UNUSED2($432B)			// DMA2 unused byte
constant REG_MIRR2($432F)			// DMA2 mirror of unused byte

constant REG_DMAP3($4330)			// DMA3 DMA/HDMA parameters
constant REG_BBAD3($4331)			// DMA3 DMA/HDMA I/O bus address
constant REG_A1T3L($4332)			// DMA3 DMA/HDMA table start address (lower byte)
constant REG_A1T3H($4333)			// DMA3 DMA/HDMA table start address (upper byte)
constant REG_A1B3($4334)			// DMA3 DMA/HDMA table start address (bank)
constant REG_DAS3L($4335)			// DMA3 DMA count / Indirect HDMA address (lower byte)
constant REG_DAS3H($4336)			// DMA3 DMA count / Indirect HDMA address (upper byte)
constant REG_DASB3($4337)			// DMA3 Indirect HDMA address (bank)
constant REG_A2A3L($4338)			// DMA3 HDMA table current address (lower byte)
constant REG_A2A3H($4339)			// DMA3 HDMA table current address (upper byte)
constant REG_NTRL3($433A)			// DMA3 HDMA line counter (from current table entry)
constant REG_UNUSED3($433B)			// DMA3 unused byte
constant REG_MIRR3($433F)			// DMA3 mirror of unused byte

constant REG_DMAP4($4340)			// DMA4 DMA/HDMA parameters
constant REG_BBAD4($4341)			// DMA4 DMA/HDMA I/O bus address
constant REG_A1T4L($4342)			// DMA4 DMA/HDMA table start address (lower byte)
constant REG_A1T4H($4343)			// DMA4 DMA/HDMA table start address (upper byte)
constant REG_A1B4($4344)			// DMA4 DMA/HDMA table start address (bank)
constant REG_DAS4L($4345)			// DMA4 DMA count / Indirect HDMA address (lower byte)
constant REG_DAS4H($4346)			// DMA4 DMA count / Indirect HDMA address (upper byte)
constant REG_DASB4($4347)			// DMA4 Indirect HDMA address (bank)
constant REG_A2A4L($4348)			// DMA4 HDMA table current address (lower byte)
constant REG_A2A4H($4349)			// DMA4 HDMA table current address (upper byte)
constant REG_NTRL4($434A)			// DMA4 HDMA line counter (from current table entry)
constant REG_UNUSED4($434B)			// DMA4 unused byte
constant REG_MIRR4($434F)			// DMA4 mirror of unused byte

constant REG_DMAP5($4350)			// DMA5 DMA/HDMA parameters
constant REG_BBAD5($4351)			// DMA5 DMA/HDMA I/O bus address
constant REG_A1T5L($4352)			// DMA5 DMA/HDMA table start address (lower byte)
constant REG_A1T5H($4353)			// DMA5 DMA/HDMA table start address (upper byte)
constant REG_A1B5($4354)			// DMA5 DMA/HDMA table start address (bank)
constant REG_DAS5L($4355)			// DMA5 DMA count / Indirect HDMA address (lower byte)
constant REG_DAS5H($4356)			// DMA5 DMA count / Indirect HDMA address (upper byte)
constant REG_DASB5($4357)			// DMA5 Indirect HDMA address (bank)
constant REG_A2A5L($4358)			// DMA5 HDMA table current address (lower byte)
constant REG_A2A5H($4359)			// DMA5 HDMA table current address (upper byte)
constant REG_NTRL5($435A)			// DMA5 HDMA line counter (from current table entry)
constant REG_UNUSED5($435B)			// DMA5 unused byte
constant REG_MIRR5($435F)			// DMA5 mirror of unused byte

constant REG_DMAP6($4360)			// DMA6 DMA/HDMA parameters
constant REG_BBAD6($4361)			// DMA6 DMA/HDMA I/O bus address
constant REG_A1T6L($4362)			// DMA6 DMA/HDMA table start address (lower byte)
constant REG_A1T6H($4363)			// DMA6 DMA/HDMA table start address (upper byte)
constant REG_A1B6($4364)			// DMA6 DMA/HDMA table start address (bank)
constant REG_DAS6L($4365)			// DMA6 DMA count / Indirect HDMA address (lower byte)
constant REG_DAS6H($4366)			// DMA6 DMA count / Indirect HDMA address (upper byte)
constant REG_DASB6($4367)			// DMA6 Indirect HDMA address (bank)
constant REG_A2A6L($4368)			// DMA6 HDMA table current address (lower byte)
constant REG_A2A6H($4369)			// DMA6 HDMA table current address (upper byte)
constant REG_NTRL6($436A)			// DMA6 HDMA line counter (from current table entry)
constant REG_UNUSED6($436B)			// DMA6 unused byte
constant REG_MIRR6($436F)			// DMA6 mirror of unused byte

constant REG_DMAP7($4370)			// DMA7 DMA/HDMA parameters
constant REG_BBAD7($4371)			// DMA7 DMA/HDMA I/O bus address
constant REG_A1T7L($4372)			// DMA7 DMA/HDMA table start address (lower byte)
constant REG_A1T7H($4373)			// DMA7 DMA/HDMA table start address (upper byte)
constant REG_A1B7($4374)			// DMA7 DMA/HDMA table start address (bank)
constant REG_DAS7L($4375)			// DMA7 DMA count / Indirect HDMA address (lower byte)
constant REG_DAS7H($4376)			// DMA7 DMA count / Indirect HDMA address (upper byte)
constant REG_DASB7($4377)			// DMA7 Indirect HDMA address (bank)
constant REG_A2A7L($4378)			// DMA7 HDMA table current address (lower byte)
constant REG_A2A7H($4379)			// DMA7 HDMA table current address (upper byte)
constant REG_NTRL7($437A)			// DMA7 HDMA line counter (from current table entry)
constant REG_UNUSED7($437B)			// DMA7 unused byte
constant REG_MIRR7($437F)			// DMA7 mirror of unused byte

// ---------------------------------------------------------------------
// Processor status bits
// ---------------------------------------------------------------------

constant P_I($04)				// I flag
constant P_D($08)				// D flag
constant P_XY($10)				// X/Y width bit (X flag)
constant P_A($20)				// A width bit (M flag)

// ---------------------------------------------------------------------
