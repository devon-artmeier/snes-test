
// ---------------------------------------------------------------------
//
//	Sonic 1 SNES port
//		By Devon Artmeier 2019
//
//	File:		ram.asm
//	Contents:	System RAM
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Render flags
// ---------------------------------------------------------------------

constant rOnScr($80)
constant rDirect($20)
constant rYChk($10)
constant rCam($04)
constant rYFlip($02)
constant rXFlip($01)

// ---------------------------------------------------------------------
// Object SSTs
// ---------------------------------------------------------------------

	seek($0000)

oAddr:;			dl	$00000000		// Object pointer
oRender:;		db	$00			// Render flags
oTile:;			dw	$0000			// Base tile
oMap:;			dl	$000000			// Mappings
oX:;			dl	$000000			// X position
oY:;			dl	$000000			// Y position
oXVel:;			dw	$0000			// X velocity
oYVel:;			dw	$0000			// Y velocity
oColH:;			db	$00			// Collision height
oColW:;			db	$00			// Collision width
oPrio:;			db	$00			// Priority
oDrawW:;		db	$00			// Draw width
oFrame:;		db	$00			// Sprite frame
oAniFrame:;		db	$00			// Animation frame
oAnim:;			db	$00			// Animation ID
oPrvAnim:;		db	$00			// Previous animation
oAniTime:;		dw	$00			// Animation frame timer
oStatus:;		db	$00			// Status
oRoutine:;		db	$00			// Routine
oSize:

// ---------------------------------------------------------------------
// RAM definitions
// ---------------------------------------------------------------------

	bankseek($7E0000)

r_Pointer:;		dl	$000000			// General pointer 1
r_Pointer2:;		dl	$000000			// General pointer 2

r_Shift_Buf:;		dw	$0000			// Bit shift buffers
r_Shift_Buf_2:;		dw	$0000

r_Counter:;		dw	$0000			// General counter 1
r_Counter_2:;		dw	$0000			// General counter 2

r_Scr_Enable:;		db	$00			// Screen enable flag

r_OAM_Size:;		db	$00			// OAM size
r_OAM_Base:;		db	$00			// OAM base

r_PalCyc_Time:;		dw	$0000			// Palette cycle timer
r_PalCyc_Index:;	dw	$0000			// Palette cycle index

r_Pal_Mode:;		db	$00			// Palette mode
r_Pal_Fade:;		dw	$0000			// Palette fade settings
r_Color:;		dw	$0000			// Color buffer

r_Pal_Data:;		dl	$000000			// Palette data pointer
r_Pal_Size:;		dw	$0000			// Palette size
r_Pal_Index:;		dw	$0000			// Starting palette index

r_Spr_HSize:;		dw	$0000			// Horizontal sprite sizes
r_Spr_VSize:;		dw	$0000			// Vertical sprite sizes
r_Spr_Offset:;		dw	$0000			// Sprite offset buffer
r_Spr_Count:;		dw	$0000			// Sprite count
r_Spr_Map:						// Sprite mappings pointer
r_Spr_Data:;		dl	$000000			// Sprite data pointer
r_Spr_Pieces:;		dw	$0000			// Sprite piece count
r_Spr_Flags:						// Sprite flags
r_Spr_Flip:;		dw	$0000			// Sprite flip bits
r_Spr_Size:;		db	$00			// Sprite size
r_Spr_X:;		dw	$0000			// Sprite X
r_Spr_Y:;		dw	$0000			// Sprite Y
r_Spr_Tile:;		dw	$0000			// Sprite tile base

r_Map_Data:;		dl	$000000			// Map data pointer
r_Map_VRAM:;		dw	$0000			// Plane map base VRAM address
r_Map_Base_VRAM:;	dw	$0000			// Base map data VRAM address
r_Map_Tile:;		dw	$0000				// Plane map base tile
r_Map_Width:;		dw	$0000			// Plane map width
r_Map_Height:;		dw	$0000			// Plane map height

r_Kos_Data:;		dl	$000000			// Kosinski compressed data
r_Kos_Dest:;		dl	$000000			// Kosinski decompression destination address
r_Kos_Copy:;		dl	$000000			// Kosinski decompression copy source
r_Kos_Repeat:;		db	$00			// Kosinski decompression repeat count
r_Kos_Switch:;		db	$00			// Kosinski decompression 
r_Kos_Desc:;		dw	$0000			// Kosinski decompression description field
r_Kos_Unroll:;		dw	$0000			// Kosinski decompression unroll mask
r_Kos_Count:;		dw	$0000			// Kosinski decompression copy count
r_Kos_Displace:;	dw	$0000			// Kosinski decompression copy source displacement
r_KosM_Data:;		dl	$000000			// Kosinski moduled compressed data
r_KosM_Dest:;		dl	$000000			// Kosinski moduled decompression destination VRAM address
r_KosMQ_Data:;		dl	$000000			// Kosinski moduled decompression queue compressed data
r_KosMQ_VRAM:;		dw	$0000			// Kosinski moduled decompression queue destination VRAM address

r_Obj_Addr:;		dl	$000000			// Object RAM address
r_Obj_Run:;		dd	$00000000		// Object run code

r_Spr_Queue_Obj:;	dl	$000000			// Sprite queue object
r_Spr_Queue_Off:;	dl	$000000			// Sprite queue offset

r_BG_A_X:;		dl	$000000			// BG A X position
r_BG_A_Y:;		dl	$000000			// BG A Y position

r_BG_A_VScrl:;		dw	$0000			// BG A VScroll value
r_BG_B_VScrl:;		dw	$0000			// BG B VScroll value

r_Frames:;		dw	$0000			// Frame counter
r_Timer:;		dw	$0000			// Universal timer

r_DMA_Queue:						// DMA queue
r_DMA_Len:;		dw	$0000			// DMA length
r_DMA_Src:;		dl	$000000			// DMA source
r_DMA_Dest:;		dw	$0000			// DMA destination
			fill	18*7
r_DMA_Slot:;		db	$00			// DMA slot

r_Sprites:;		fill	$220			// Sprite buffer
r_Palette:;		fill	$200			// Palette buffer
r_Palette_2:;		fill	$200			// Palette buffer 2
r_Fade_Pal:;		fill	$200			// Fade palette buffer
r_Fade_Pal_2:;		fill	$200			// Fade palette buffer 2

r_KosQ_Vars:						// Kosinski decompression queue variables
r_KosQ_Data:;		dl	$000000			// Kosinski decompression queue compressed data
r_KosQ_Buffer:;		dl	$000000			// Kosinski decompression queue destination buffer
r_KosQ_Index:;		dw	$0000			// Kosinski decompression queue index
r_KosQ_List:;		fill	4*6			// Kosinski decompression queue
			constant r_KosQ_Src(r_KosQ_List)
			constant r_KosQ_Dest(r_KosQ_List+3)
r_KosQ_List_End:
r_KosMQ_Cnt:;		dw	$0000			// Kosinski moduled decompression queue count
r_KosMQ_Last_Sz:;	dw	$0000			// Kosinski moduled decompression queue last size
r_KosMQ_List:;		fill	$20*5			// Kosinski moduled decompression queue
			constant r_KosMQ_Src(r_KosMQ_List)
			constant r_KosMQ_Dest(r_KosMQ_List+3)
r_KosMQ_List_End:
r_KosQ_Vars_End:

		if ($7E1F00-pc() > 0) {
			fill	$7E1F00-pc()
		}
		if (pc()>$7E1F00) {
			print "error: 2KB WRAM mirror is too large by ", pc()-$7E1F00, " bytes\n"
			error "2KB WRAM mirror too large"
		}

			fill	$FF			// Stack
r_Stack:;		db	$00

// ---------------------------------------------------------------------

r_KosM_Buffer:;		fill	$1000			// Kosinski moduled decompression buffer

r_HDMA_Buf_1:;		fill	$1C1			// HDMA buffer 1
r_HDMA_Buf_2:;		fill	$1C1			// HDMA buffer 2

r_Objects:
r_Res_Obj:
r_Player:;		fill	oSize			// Player object
r_HUD:;			fill	oSize			// HUD object
			fill	$1E*oSize		// Reserved object RAM
r_Res_Objs_End:
r_Dyn_Objs:;		fill	$60*oSize		// Dynamic object RAM
r_Dyn_Objs_End:
r_Objects_End:

r_Sprite_Queue:;	fill	8*$80			// Sprite queue
r_Spr_Queue_End:

// ---------------------------------------------------------------------
