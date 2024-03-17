// ---------------------------------------------------------------------------
// Sprite mappings - "SONIC TEAM PRESENTS" and credits
//  ---------------------------------------------------------------------------
Map_Cred_internal:
		dw	Map_Cred_internal_staff-Map_Cred_internal
		dw	Map_Cred_internal_gameplan-Map_Cred_internal
		dw	Map_Cred_internal_program-Map_Cred_internal
		dw	Map_Cred_internal_character-Map_Cred_internal
		dw	Map_Cred_internal_design-Map_Cred_internal
		dw	Map_Cred_internal_soundproduce-Map_Cred_internal
		dw	Map_Cred_internal_soundprogram-Map_Cred_internal
		dw	Map_Cred_internal_thanks-Map_Cred_internal
		dw	Map_Cred_internal_presentedby-Map_Cred_internal
		dw	Map_Cred_internal_tryagain-Map_Cred_internal
		dw	Map_Cred_internal_sonicteam-Map_Cred_internal
Map_Cred_internal_staff:
		db	$E			// SONIC TEAM STAFF
		db	$F8, 5, 0, $2E, $88
		db	$F8, 5, 0, $26, $98
		db	$F8, 5, 0, $1A, $A8
		db	$F8, 1, 0, $46, $B8
		db	$F8, 5, 0, $1E, $C0
		db	$F8, 5, 0, $3E, $D8
		db	$F8, 5, 0, $E, $E8
		db	$F8, 5, 0, 4, $F8
		db	$F8, 9, 0, 8, 8
		db	$F8, 5, 0, $2E, $28
		db	$F8, 5, 0, $3E, $38
		db	$F8, 5, 0, 4, $48
		db	$F8, 5, 0, $5C, $58
		db	$F8, 5, 0, $5C, $68
Map_Cred_internal_gameplan:
		db	$10			// GAME PLAN CAROL YAS
		db	$D8, 5, 0, 0, $80
		db	$D8, 5, 0, 4, $90
		db	$D8, 9, 0, 8, $A0
		db	$D8, 5, 0, $E, $B4
		db	$D8, 5, 0, $12, $D0
		db	$D8, 5, 0, $16, $E0
		db	$D8, 5, 0, 4, $F0
		db	$D8, 5, 0, $1A, 0
		db	8, 5, 0, $1E, $C8
		db	8, 5, 0, 4, $D8
		db	8, 5, 0, $22, $E8
		db	8, 5, 0, $26, $F8
		db	8, 5, 0, $16, 8
		db	8, 5, 0, $2A, $20
		db	8, 5, 0, 4, $30
		db	8, 5, 0, $2E, $44
Map_Cred_internal_program:
		db	$A			// PROGRAM YU 2
		db	$D8, 5, 0, $12, $80
		db	$D8, 5, 0, $22, $90
		db	$D8, 5, 0, $26, $A0
		db	$D8, 5, 0, 0, $B0
		db	$D8, 5, 0, $22, $C0
		db	$D8, 5, 0, 4, $D0
		db	$D8, 9, 0, 8, $E0
		db	8, 5, 0, $2A, $E8
		db	8, 5, 0, $32, $F8
		db	8, 5, 0, $36, 8
Map_Cred_internal_character:
		db	$18			// CHARACTER DESIGN BIGISLAND
		db	$D8, 5, 0, $1E, $88
		db	$D8, 5, 0, $3A, $98
		db	$D8, 5, 0, 4, $A8
		db	$D8, 5, 0, $22, $B8
		db	$D8, 5, 0, 4, $C8
		db	$D8, 5, 0, $1E, $D8
		db	$D8, 5, 0, $3E, $E8
		db	$D8, 5, 0, $E, $F8
		db	$D8, 5, 0, $22, 8
		db	$D8, 5, 0, $42, $20
		db	$D8, 5, 0, $E, $30
		db	$D8, 5, 0, $2E, $40
		db	$D8, 1, 0, $46, $50
		db	$D8, 5, 0, 0, $58
		db	$D8, 5, 0, $1A, $68
		db	8, 5, 0, $48, $C0
		db	8, 1, 0, $46, $D0
		db	8, 5, 0, 0, $D8
		db	8, 1, 0, $46, $E8
		db	8, 5, 0, $2E, $F0
		db	8, 5, 0, $16, 0
		db	8, 5, 0, 4, $10
		db	8, 5, 0, $1A, $20
		db	8, 5, 0, $42, $30
Map_Cred_internal_design:
		db	$14			// DESIGN JINYA	PHENIX RIE
		db	$D0, 5, 0, $42, $A0
		db	$D0, 5, 0, $E, $B0
		db	$D0, 5, 0, $2E, $C0
		db	$D0, 1, 0, $46, $D0
		db	$D0, 5, 0, 0, $D8
		db	$D0, 5, 0, $1A, $E8
		db	0, 5, 0, $4C, $E8
		db	0, 1, 0, $46, $F8
		db	0, 5, 0, $1A, 4
		db	0, 5, 0, $2A, $14
		db	0, 5, 0, 4, $24
		db	$20, 5, 0, $12, $D0
		db	$20, 5, 0, $3A, $E0
		db	$20, 5, 0, $E, $F0
		db	$20, 5, 0, $1A, 0
		db	$20, 1, 0, $46, $10
		db	$20, 5, 0, $50, $18
		db	$20, 5, 0, $22, $30
		db	$20, 1, 0, $46, $40
		db	$20, 5, 0, $E, $48
Map_Cred_internal_soundproduce:
		db	$1A			// SOUND PRODUCE MASATO	NAKAMURA
		db	$D8, 5, 0, $2E, $98
		db	$D8, 5, 0, $26, $A8
		db	$D8, 5, 0, $32, $B8
		db	$D8, 5, 0, $1A, $C8
		db	$D8, 5, 0, $54, $D8
		db	$D8, 5, 0, $12, $F8
		db	$D8, 5, 0, $22, 8
		db	$D8, 5, 0, $26, $18
		db	$D8, 5, 0, $42, $28
		db	$D8, 5, 0, $32, $38
		db	$D8, 5, 0, $1E, $48
		db	$D8, 5, 0, $E, $58
		db	8, 9, 0, 8, $88
		db	8, 5, 0, 4, $9C
		db	8, 5, 0, $2E, $AC
		db	8, 5, 0, 4, $BC
		db	8, 5, 0, $3E, $CC
		db	8, 5, 0, $26, $DC
		db	8, 5, 0, $1A, $F8
		db	8, 5, 0, 4, 8
		db	8, 5, 0, $58, $18
		db	8, 5, 0, 4, $28
		db	8, 9, 0, 8, $38
		db	8, 5, 0, $32, $4C
		db	8, 5, 0, $22, $5C
		db	8, 5, 0, 4, $6C
Map_Cred_internal_soundprogram:
		db	$17			// SOUND PROGRAM JIMITA	MACKY
		db	$D0, 5, 0, $2E, $98
		db	$D0, 5, 0, $26, $A8
		db	$D0, 5, 0, $32, $B8
		db	$D0, 5, 0, $1A, $C8
		db	$D0, 5, 0, $54, $D8
		db	$D0, 5, 0, $12, $F8
		db	$D0, 5, 0, $22, 8
		db	$D0, 5, 0, $26, $18
		db	$D0, 5, 0, 0, $28
		db	$D0, 5, 0, $22, $38
		db	$D0, 5, 0, 4, $48
		db	$D0, 9, 0, 8, $58
		db	0, 5, 0, $4C, $D0
		db	0, 1, 0, $46, $E0
		db	0, 9, 0, 8, $E8
		db	0, 1, 0, $46, $FC
		db	0, 5, 0, $3E, 4
		db	0, 5, 0, 4, $14
		db	$20, 9, 0, 8, $D0
		db	$20, 5, 0, 4, $E4
		db	$20, 5, 0, $1E, $F4
		db	$20, 5, 0, $58, 4
		db	$20, 5, 0, $2A, $14
Map_Cred_internal_thanks:
		db	$1F			// SPECIAL THANKS FUJIO	MINEGISHI PAPA
		db	$D8, 5, 0, $2E, $80
		db	$D8, 5, 0, $12, $90
		db	$D8, 5, 0, $E, $A0
		db	$D8, 5, 0, $1E, $B0
		db	$D8, 1, 0, $46, $C0
		db	$D8, 5, 0, 4, $C8
		db	$D8, 5, 0, $16, $D8
		db	$D8, 5, 0, $3E, $F8
		db	$D8, 5, 0, $3A, 8
		db	$D8, 5, 0, 4, $18
		db	$D8, 5, 0, $1A, $28
		db	$D8, 5, 0, $58, $38
		db	$D8, 5, 0, $2E, $48
		db	0, 5, 0, $5C, $B0
		db	0, 5, 0, $32, $C0
		db	0, 5, 0, $4C, $D0
		db	0, 1, 0, $46, $E0
		db	0, 5, 0, $26, $E8
		db	0, 9, 0, 8, 0
		db	0, 1, 0, $46, $14
		db	0, 5, 0, $1A, $1C
		db	0, 5, 0, $E, $2C
		db	0, 5, 0, 0, $3C
		db	0, 1, 0, $46, $4C
		db	0, 5, 0, $2E, $54
		db	0, 5, 0, $3A, $64
		db	0, 1, 0, $46, $74
		db	$20, 5, 0, $12, $F8
		db	$20, 5, 0, 4, 8
		db	$20, 5, 0, $12, $18
		db	$20, 5, 0, 4, $28
Map_Cred_internal_presentedby:
		db	$F			// PRESENTED BY	SEGA
		db	$F8, 5, 0, $12, $80
		db	$F8, 5, 0, $22, $90
		db	$F8, 5, 0, $E, $A0
		db	$F8, 5, 0, $2E, $B0
		db	$F8, 5, 0, $E, $C0
		db	$F8, 5, 0, $1A, $D0
		db	$F8, 5, 0, $3E, $E0
		db	$F8, 5, 0, $E, $F0
		db	$F8, 5, 0, $42, 0
		db	$F8, 5, 0, $48, $18
		db	$F8, 5, 0, $2A, $28
		db	$F8, 5, 0, $2E, $40
		db	$F8, 5, 0, $E, $50
		db	$F8, 5, 0, 0, $60
		db	$F8, 5, 0, 4, $70
Map_Cred_internal_tryagain:
		db	8			// TRY AGAIN
		db	$30, 5, 0, $3E, $C0
		db	$30, 5, 0, $22, $D0
		db	$30, 5, 0, $2A, $E0
		db	$30, 5, 0, 4, $F8
		db	$30, 5, 0, 0, 8
		db	$30, 5, 0, 4, $18
		db	$30, 1, 0, $46, $28
		db	$30, 5, 0, $1A, $30
Map_Cred_internal_sonicteam:
		dw	$0012			// SONIC TEAM PRESENTS
		dw	$0028, $0000, $FF94, $FFE8
		dw	$0024, $0000, $FFA4, $FFE8
		dw	$000E, $0000, $FFB4, $FFE8
		dw	$0044, $0000, $FFC4, $FFE8
		dw	$0020, $0000, $FFCC, $FFE8
		dw	$0040, $0000, $FFE4, $FFE8
		dw	$0008, $0000, $FFF4, $FFE8
		dw	$0002, $0000, $0004, $FFE8
		dw	$0004, $0000, $0014, $FFE8
		dw	$0006, $0000, $0024, $FFE8
		dw	$000A, $0000, $FFA0, $0000
		dw	$0022, $0000, $FFB0, $0000
		dw	$0008, $0000, $FFC0, $0000
		dw	$0028, $0000, $FFD0, $0000
		dw	$0008, $0000, $FFE0, $0000
		dw	$000E, $0000, $FFF0, $0000
		dw	$0040, $0000, $0000, $0000
		dw	$0028, $0000, $0010, $0000