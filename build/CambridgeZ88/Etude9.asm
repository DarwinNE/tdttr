; *****************************************************************************
; * QChan Player
; *
; * By Shiru (shiru@mail.ru) 03'11
; *
; * Four channels of tone with global volumes, per-pattern tempo and decays
; * One channel of interrupting drums, no ROM data required
; * Feel free to do whatever you want with the code, it is PD
; *
; * Produced by Beepola v1.08.01
; ******************************************************************************


		; This code is self modifying so needs to be run from RAM
		SECTION	smc_user

OP_NOP:         EQU   $00                 ; NOP opcode (used for CHECK_KEMPSTON)
OP_ORC:         EQU   $b1                 ; OR C opcode (used in CHECK_KEMPSTON)

		defc	FORz88 = 1

		PUBLIC	_demo_play

_demo_play:
                LD    HL,MUSICDATA
                CALL  QCHAN_PLAY
                RET

QCHAN_PLAY:
                DI			;Locking OZ like this is a bad thing to do...
                LD    A,(HL)
                INC   HL
                LD    (CH0_VOL + 1),A
                LD    A,(HL)
                INC   HL
                LD    (CH1_VOL + 1),A
                LD    A,(HL)
                INC   HL
                LD    (CH2_VOL + 1),A
                LD    A,(HL)
                INC   HL
                LD    (CH3_VOL + 1),A
                LD    (ORDER_PTR + 1),HL
                LD    HL,0
                LD    (FRQ0 + 1),HL
                LD    (FRQ1 + 1),HL
                LD    (FRQ2 + 1),HL
                LD    (FRQ3 + 1),HL
                LD    A,L
                LD    (VOL0 + 1),A
                LD    (VOL1 + 1),A
                LD    (VOL2 + 1),A
                LD    (VOL3 + 1),A
                LD    (FRAME_CNT + 1),A
IF FORz88
		; Ensure that we don't disrupt port B0 - save some copies
		ld	a,($4B0)
		and	@00111111
		ld	(z88_fixup1+1),a
		ld	(z88_fixup3+1),a
		or	64
		ld	(z88_fixup2+1),a
ELSE
                IN    A,($1F)
                AND   $1F
                LD    A,OP_NOP
                JR    NZ,SET_KEMPSTON     ; Jump if Kempston not present
                LD    A,OP_ORC
SET_KEMPSTON:   LD    (CHECK_KEMPSTON),A
ENDIF
                EXX
                PUSH  HL
                PUSH  IY
                LD    (OLD_SP + 1),SP
                JR    NEXT_POSITION
READ_LOOP:
MUSIC_PTR:      LD    DE,0                ; 
READ_ROW:       LD    A,(DE)
                CP    128
                JP    NZ,READ_NOTES
NEXT_POSITION:
ORDER_PTR:      LD    HL,0                ; 
                LD    E,(HL)
                INC   HL
                LD    D,(HL)
                INC   HL
                LD    A,D
                OR    E
                JR    Z,ORDER_LOOP
                LD    (ORDER_PTR + 1),HL
                LD    A,(DE)
                LD    (FRAME_MAX + 1),A
                INC   DE
                LD    A,(DE)
                LD    (CH0_DECAY + 1),A
                INC   DE
                LD    A,(DE)
                LD    (CH1_DECAY + 1),A
                INC   DE
                LD    A,(DE)
                LD    (CH2_DECAY + 1),A
                INC   DE
                LD    A,(DE)
                LD    (CH3_DECAY + 1),A
                INC   DE
                JP    READ_ROW

ORDER_LOOP:     LD    E,(HL)
                INC   HL
                LD    D,(HL)
                LD    (ORDER_PTR+1),DE
                JP    NEXT_POSITION
READ_NOTES:
                ld    hl,FREQ_TABLE
                inc   de
                OR    A
                JR    Z,NO_NOTE0
                add   l
                ld    l,a
                ld    a,0
                adc   h
                ld    h,a
                LD    C,(HL)
                INC   hl
                LD    B,(HL)
                LD    (FRQ0 + 1),BC
                ld    hl,FREQ_TABLE
CH0_VOL:
                LD    A,16
                LD    (VOL0 + 1),A
NO_NOTE0:
                LD    A,(DE)
                INC   DE
                OR    A
                JR    Z,NO_NOTE1
                add   l
                ld    l,a
                ld    a,h
                adc   0
                ld    h,a
                LD    c,(HL)
                INC   hL
                LD    B,(HL)
                LD    (FRQ1 + 1),BC
                ld    hl,FREQ_TABLE
FRQ1:           LD    SP,0
CH1_VOL:        LD    A,16
                LD    (VOL1 + 1),A
NO_NOTE1:       LD    A,(DE)
                INC   DE
                OR    A
                JR    Z,NO_NOTE2
                add   l
                ld    l,a
                ld    a,0
                adc   h
                ld    h,a
                LD    C,(HL)
                INC   hL
                LD    B,(HL)
                LD    (FRQ2 + 1),BC
                ld    hl,FREQ_TABLE
                EXX
FRQ2:           LD    DE,0
                EXX
CH2_VOL:        LD    A,16
                LD    (VOL2 + 1),A
NO_NOTE2:       LD    A,(DE)
                INC   DE
                OR    A
                JR    Z,NO_NOTE3
                add   l
                ld    l,a
                ld    a,0
                adc   h
                ld    h,a
                LD    C,(HL)
                INC  hL
                LD    B,(HL)
                LD    (FRQ3 + 1),BC
                EXX
FRQ3:           LD    BC,0
                EXX
CH3_VOL:        LD    A,16
                LD    (VOL3 + 1),A
NO_NOTE3:       LD    (MUSIC_PTR + 1),DE
                LD    A,(DE)
                CP    129
                JR    C,NO_DRUM
                INC   DE
                LD    (MUSIC_PTR + 1),DE
                LD    B,128
                SUB   B
                ADD   A,A
                LD    C,A
                LD    E,A
                LD    L,A
                LD    H,A

DRUM_1:         DEC   C
                JR    NZ,DRUM_2
                LD    C,E
IF FORz88
		rlca	
		rlca
		and	64
z88_fixup1:	or	0
		out	($b0),a
ELSE
                AND   16
                OUT   ($FE),A
ENDIF
DRUM_2:         LD    A,L
                ADD   A,11
                XOR   H
                LD    L,A
                LD    A,H
                ADD   A,12
                XOR   L
                LD    H,A
                DJNZ  DRUM_1

NO_DRUM:        XOR   A
FRQ0:           LD    DE,0
SOUND_LOOP_RPT: EX    AF,AF'
PREV_CNT1:      LD    HL,0
                LD    C,64
                                    ; T-States...
SOUND_LOOP:     ADD   IX,DE         ; 15
                SBC   A,A           ;  4
VOL0:           AND   0             ;  7
                LD    B,A           ;  4
                ADD   HL,SP         ; 11
                SBC   A,A           ;  4
VOL1:           AND   0             ;  7
                OR    B             ;  4
                LD    B,A           ;  4
                EXX                 ;  4
                ADD   IY,DE         ; 15
                SBC   A,A           ;  4
VOL2:           AND   0             ;  7
                EXX                 ;  4
                OR    B             ;  4
                LD    B,A           ;  4
                EXX                 ;  4
                ADD   HL,BC         ; 11
                SBC   A,A           ;  4
VOL3:           AND   0             ;  7
                EXX                 ;  4
                OR    B             ;  4
                JR    Z,NO_OUT      ;7/12
                LD    B,A           ;  4
IF FORz88
z88_fixup2:	ld	a,64
		out	($B0),a
ELSE
                LD    A,16          ;  7
                OUT  ($FE),A	      ; 11
ENDIF
                LD    A,B           ;  4
SND_DELAY:      DJNZ  SND_DELAY     ;~
                CPL                 ;  4
NO_OUT:         ADD   A,17          ;  7
                LD    B,A           ;  4
IF FORz88
z88_fixup3:	ld	a,0
		out	($B0),a
ELSE
                XOR   A             ;  4
                OUT   ($FE),A       ; 11
ENDIF
SND_DELAY2:     DJNZ  SND_DELAY2    ;~
                DEC   C             ;  4
                JP    NZ,SOUND_LOOP ; 10 = ~404Ts

                LD    (PREV_CNT1 + 1),HL
FRAME_CNT:      LD    A,0
                LD    C,A
CH0_DECAY:      AND   0
                JR    NZ,CH0_DSKIP
                LD    HL,VOL0 + 1
                OR    (HL)
                JR    Z,CH0_DSKIP
                DEC   (HL)
CH0_DSKIP:      LD    A,C
CH1_DECAY:      AND   0
                JR    NZ,CH1_DSKIP
                LD    HL,VOL1 + 1
                OR    (HL)
                JR    Z,CH1_DSKIP
                DEC   (HL)
CH1_DSKIP:      LD    A,C
CH2_DECAY:      AND   0
                JR    NZ,CH2_DSKIP
                LD    HL,VOL2 + 1
                OR    (HL)
                JR    Z,CH2_DSKIP
                DEC   (HL)
CH2_DSKIP:      LD    A,C
CH3_DECAY:      AND   0
                JR    NZ,CH3_DSKIP
                LD    HL,VOL3 + 1
                OR    (HL)
                JR    Z,CH3_DSKIP
                DEC   (HL)
CH3_DSKIP:      LD    HL,FRAME_CNT + 1
                INC   (HL)
                EX    AF,AF'
                INC   A
FRAME_MAX:      CP    20
                JP    C,SOUND_LOOP_RPT
IF FORz88
		xor	a
		in      a,($B2)
        	cpl
        	and     127
ELSE
                IN    A,($1F)             ; Read Kempston port
                LD    C,A                 ; Store Kempston state
                XOR   A
                IN    A,($FE)             ; Read Keyboard
                CPL
CHECK_KEMPSTON: OR    C                   ; NOPped out if no Kempston present
                AND   $1F
ENDIF
                JR    NZ,STOP_MUSIC
                JP    READ_LOOP

STOP_MUSIC:
OLD_SP:         LD    SP,0
                POP   IY
                POP   HL
                EXX
                EI
                RET

; The line below is to align FREQ_TABLE on a page boundary. If you assembler
; emits an error, try replacing the '%' with whatever it's MODULO operator
; is. Alternatively some assemblers offer an ALIGN directive.
                ;DEFS (-$) % 256           ; Page align FREQ_TABLE
FREQ_TABLE:
	              DEFW 0
	              DEFW 247,262,277,294,311,330,349,370,392,416,440,467
	              DEFW 494,524,555,588,623,660,699,741,785,832,881,934
	              DEFW 989,1048,1110,1176,1246,1320,1399,1482,1570,1664,1763,1868
	              DEFW 1979,2096,2221,2353,2493,2641,2798,2965,3141,3328,3526,3736
	              DEFW 3958,4193,4442,4707,4987,5283,5597,5930,6283,6656,7052,7472
	              DEFW 0



; ************************************************************************
; * Song data...
; ************************************************************************
BORDER_CLR:          EQU $0

; *** DATA ***
; *** DATA ***
MUSICDATA:

; *** Volumes ***
                     DEFB  $0F,$0F,$0F,$0F
; *** Song layout ***
LOOPSTART:            DEFW      PAT0
                      DEFW      PAT0
                      DEFW      PAT3
                      DEFW      PAT4
                      DEFW      PAT5
                      DEFW      PAT6
                      DEFW      PAT7
                      DEFW      PAT8
                      DEFW      PAT9
                      DEFW      PAT10
                      DEFW      PAT11
                      DEFW      PAT24
                      DEFW      PAT14
                      DEFW      PAT15
                      DEFW      PAT16
                      DEFW      PAT18
                      DEFW      PAT19
                      DEFW      PAT20
                      DEFW      PAT21
                      DEFW      PAT22
                      DEFW      PAT23
                      DEFW      $0000
                      DEFW      LOOPSTART

; *** Patterns ***
PAT0:             DEFB 18             ; Pattern tempo
                     DEFB 7,7,7,7        ; Decays
                     DEFB 30,54,78,102
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 98,106,112,118
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 6,30,54,78
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 64,70,76,84
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB $80             ; Pattern end

PAT3:             DEFB 18             ; Pattern tempo
                     DEFB 7,7,7,7        ; Decays
                     DEFB 14,38,62,86
                     DEFB 0,0,0,0
                     DEFB 54,58,70,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 6,30,54,0
                     DEFB 0,0,0,0
                     DEFB 0,60,70,46
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB $80             ; Pattern end

PAT4:             DEFB 18             ; Pattern tempo
                     DEFB 7,7,7,7        ; Decays
                     DEFB 14,38,62,86
                     DEFB 0,0,0,0
                     DEFB 54,58,70,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 6,30,54,0
                     DEFB 0,0,0,0
                     DEFB 0,60,70,46
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB $80             ; Pattern end

PAT5:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 122,54,78,102
                     DEFB 0,54,78,102
                     DEFB 122,54,78,102
                     DEFB 0,0,0,0
                     DEFB 64,70,78,0
                     DEFB 64,70,78,0
                     DEFB 64,70,78,0
                     DEFB 0,0,0,0
                     DEFB 50,56,64,0
                     DEFB 50,56,64,0
                     DEFB 50,56,64,0
                     DEFB 0,0,0,0
                     DEFB 64,70,76,0
                     DEFB 64,70,76,0
                     DEFB 64,70,76,0
                     DEFB 0,0,0,0
                     DEFB 30,60,68,84
                     DEFB 30,60,68,84
                     DEFB $80             ; Pattern end

PAT6:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 54,54,68,84
                     DEFB 0,0,0,0
                     DEFB 102,88,70,82
                     DEFB 102,0,0,0
                     DEFB 102,92,78,84
                     DEFB 0,0,0,0
                     DEFB 102,84,68,80
                     DEFB 102,0,0,0
                     DEFB 102,92,78,86
                     DEFB 0,0,0,0
                     DEFB 102,82,62,78
                     DEFB 100,0,0,0
                     DEFB 96,78,46,60
                     DEFB 92,0,0,0
                     DEFB 88,76,32,58
                     DEFB 0,0,0,0
                     DEFB $80             ; Pattern end

PAT7:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 54,86,68,102
                     DEFB 0,0,0,0
                     DEFB 46,92,68,102
                     DEFB 0,0,0,102
                     DEFB 56,88,64,102
                     DEFB 0,0,0,0
                     DEFB 36,92,68,102
                     DEFB 0,0,0,102
                     DEFB 46,84,46,102
                     DEFB 0,0,0,0
                     DEFB 32,46,62,80
                     DEFB 0,0,0,84
                     DEFB 36,54,70,86
                     DEFB 0,0,0,90
                     DEFB 38,52,58,94
                     DEFB 0,0,0,0
                     DEFB $80             ; Pattern end

PAT8:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 30,44,62,78
                     DEFB 0,0,0,0
                     DEFB 42,76,78,0
                     DEFB 56,0,78,0
                     DEFB 54,70,78,0
                     DEFB 40,0,0,0
                     DEFB 36,68,0,0
                     DEFB 50,0,0,0
                     DEFB 46,64,78,0
                     DEFB 32,0,0,0
                     DEFB 30,62,78,86
                     DEFB 44,0,0,86
                     DEFB 44,62,76,86
                     DEFB 26,0,0,0
                     DEFB 24,54,72,0
                     DEFB 38,0,0,0
                     DEFB $80             ; Pattern end

PAT9:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 38,52,68,86
                     DEFB 20,0,0,0
                     DEFB 16,44,50,68
                     DEFB 32,0,0,68
                     DEFB 30,44,54,68
                     DEFB 14,0,0,0
                     DEFB 32,50,62,70
                     DEFB 50,0,0,70
                     DEFB 46,60,122,70
                     DEFB 30,0,0,0
                     DEFB 42,64,72,88
                     DEFB 60,0,0,88
                     DEFB 56,74,122,88
                     DEFB 40,0,0,0
                     DEFB 6,30,78,102
                     DEFB 6,30,78,102
                     DEFB $80             ; Pattern end

PAT10:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 6,30,78,102
                     DEFB 0,0,0,0
                     DEFB 74,88,94,102
                     DEFB 0,0,0,102
                     DEFB 78,86,92,102
                     DEFB 0,0,0,0
                     DEFB 72,84,90,102
                     DEFB 0,0,0,102
                     DEFB 74,82,88,102
                     DEFB 0,0,0,0
                     DEFB 68,80,86,102
                     DEFB 0,0,0,100
                     DEFB 70,78,84,94
                     DEFB 0,0,0,92
                     DEFB 32,40,76,88
                     DEFB 0,0,0,0
                     DEFB $80             ; Pattern end

PAT11:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 30,38,62,102
                     DEFB 0,0,0,0
                     DEFB 26,50,68,78
                     DEFB 0,36,0,78
                     DEFB 22,46,64,78
                     DEFB 0,32,0,0
                     DEFB 20,44,60,0
                     DEFB 0,30,0,0
                     DEFB 16,40,56,0
                     DEFB 0,26,0,0
                     DEFB 14,38,50,56
                     DEFB 0,22,0,68
                     DEFB 12,36,54,70
                     DEFB 0,18,0,78
                     DEFB 8,32,50,62
                     DEFB 0,14,0,68
                     DEFB $80             ; Pattern end

PAT14:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 74,88,94,102
                     DEFB 0,0,0,0
                     DEFB 68,100,82,88
                     DEFB 68,100,82,88
                     DEFB 68,100,82,88
                     DEFB 0,0,0,0
                     DEFB 54,68,62,78
                     DEFB 54,68,62,78
                     DEFB 54,68,62,78
                     DEFB 0,0,0,0
                     DEFB 62,74,80,90
                     DEFB 62,74,80,90
                     DEFB $80             ; Pattern end

PAT15:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 62,74,80,90
                     DEFB 0,0,0,0
                     DEFB 68,100,82,88
                     DEFB 68,100,82,88
                     DEFB 68,100,82,88
                     DEFB 0,0,0,0
                     DEFB 54,68,62,78
                     DEFB 54,68,62,78
                     DEFB 54,68,62,78
                     DEFB 0,0,0,0
                     DEFB 70,78,84,90
                     DEFB 70,78,84,90
                     DEFB $80             ; Pattern end

PAT16:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 70,78,84,90
                     DEFB 0,0,0,0
                     DEFB 68,100,82,88
                     DEFB 68,100,82,88
                     DEFB 68,100,82,88
                     DEFB 0,0,0,0
                     DEFB 54,68,62,78
                     DEFB 54,68,62,78
                     DEFB 54,68,62,78
                     DEFB 0,0,0,0
                     DEFB 38,62,86,110
                     DEFB 0,0,0,0
                     DEFB $80             ; Pattern end

PAT18:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 54,58,70,78
                     DEFB 0,0,0,0
                     DEFB 30,0,0,54
                     DEFB 0,0,0,0
                     DEFB 46,60,70,0
                     DEFB 0,0,0,0
                     DEFB 38,0,0,62
                     DEFB 0,0,0,0
                     DEFB 30,34,46,54
                     DEFB 0,0,0,0
                     DEFB 30,0,0,6
                     DEFB 0,0,0,0
                     DEFB 22,36,46,60
                     DEFB 0,0,0,0
                     DEFB 14,0,0,38
                     DEFB 0,0,0,0
                     DEFB $80             ; Pattern end

PAT19:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 30,46,54,122
                     DEFB 0,0,0,0
                     DEFB 38,62,86,0
                     DEFB 0,0,0,0
                     DEFB 54,70,78,0
                     DEFB 0,0,0,0
                     DEFB 62,86,122,110
                     DEFB 0,0,0,0
                     DEFB 30,38,54,102
                     DEFB 0,0,0,0
                     DEFB 38,62,122,110
                     DEFB 0,0,0,0
                     DEFB 54,70,78,102
                     DEFB 0,0,0,0
                     DEFB 30,54,78,102
                     DEFB 30,54,78,102
                     DEFB $80             ; Pattern end

PAT20:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 30,54,78,102
                     DEFB 0,0,0,0
                     DEFB 44,0,106,112
                     DEFB 44,0,92,116
                     DEFB 54,0,102,110
                     DEFB 0,0,92,116
                     DEFB 58,0,96,102
                     DEFB 0,0,82,106
                     DEFB 62,0,86,92
                     DEFB 0,0,78,102
                     DEFB 64,0,82,88
                     DEFB 0,0,68,92
                     DEFB 68,0,78,86
                     DEFB 0,0,68,92
                     DEFB 44,0,82,88
                     DEFB 0,0,68,92
                     DEFB $80             ; Pattern end

PAT21:             DEFB 18             ; Pattern tempo
                     DEFB 15,15,15,15        ; Decays
                     DEFB 30,0,78,86
                     DEFB 0,0,0,0
                     DEFB 44,0,82,88
                     DEFB 44,0,68,92
                     DEFB 30,0,78,86
                     DEFB 0,0,68,92
                     DEFB 34,0,72,78
                     DEFB 0,0,58,82
                     DEFB 38,0,62,68
                     DEFB 0,0,54,78
                     DEFB 40,0,58,64
                     DEFB 0,0,44,68
                     DEFB 44,0,54,62
                     DEFB 0,0,44,68
                     DEFB 44,0,58,64
                     DEFB 0,0,44,68
                     DEFB $80             ; Pattern end

PAT22:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 30,44,54,62
                     DEFB 0,0,0,0
                     DEFB 30,44,62,122
                     DEFB 0,54,68,0
                     DEFB 30,44,78,0
                     DEFB 0,0,62,0
                     DEFB 54,68,82,0
                     DEFB 0,78,92,0
                     DEFB 54,68,102,0
                     DEFB 0,0,86,0
                     DEFB 54,68,82,0
                     DEFB 0,78,92,0
                     DEFB 54,68,102,0
                     DEFB 0,0,86,0
                     DEFB 62,0,82,0
                     DEFB 68,0,92,0
                     DEFB $80             ; Pattern end

PAT23:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,15        ; Decays
                     DEFB 54,68,86,102
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 6,30,54,0
                     DEFB 6,30,54,0
                     DEFB 6,30,54,0
                     DEFB 6,30,54,0
                     DEFB 6,30,54,30
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 0,0,0,0
                     DEFB 122,122,122,122
                     DEFB $80             ; Pattern end

PAT24:             DEFB 18             ; Pattern tempo
                     DEFB 3,3,3,3        ; Decays
                     DEFB 30,44,54,62
                     DEFB 0,0,0,0
                     DEFB 40,68,52,68
                     DEFB 56,0,0,68
                     DEFB 54,68,54,68
                     DEFB 38,0,0,0
                     DEFB 56,86,50,70
                     DEFB 50,0,0,70
                     DEFB 46,122,60,70
                     DEFB 30,0,0,0
                     DEFB 38,72,64,88
                     DEFB 60,0,0,88
                     DEFB 56,122,74,88
                     DEFB 38,0,0,0
                     DEFB 74,88,94,102
                     DEFB 74,88,94,102
                     DEFB $80             ; Pattern end

