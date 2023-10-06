*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
START_CLIENT:
    LEA SFX_V, A0
    MOVE.W #NUMSFX-1, D7
    BRA LDR_MUS
    
START_SERVER:
    RTS
PLAY_SFX:
    ; 22(SP).W ID SND
    ; 20(SP).W HAS PRIO
    MOVEM.L D0-D2/A0, -(SP)

    MOVE.B #76, D0
    CMP.W #0, 20(SP)
    BEQ .NOSTOP
    MOVE.L #3, D2
    TRAP #15
    .NOSTOP:
    MOVE.B #76, D0
    MOVE.W 22(SP), D1
    CLR.L D2
    TRAP #15

    MOVEM.L (SP)+, A0/D2-D0
    RTS

LDR_MUS:
    MOVE.B #71, D0
    CLR.W D2
    CLR.L D1
    .LOOP:
    MOVE.L (A0, D2.W), A1
    TRAP #15
    ADDQ.B #1, D1
    ADDQ.W #4, D2
    DBRA D7, .LOOP
    RTS

NUMSFX  EQU 3
SFX_V   DC.L .SFXPYRHURT, .SFXPYRDEATH, .SFXPYRWALK
.SFXPYRHURT     DC.B './SFX/snd_quote_hurt.wav',0
.SFXPYRDEATH    DC.B './SFX/snd_quote_die.wav',0
.SFXPYRWALK    DC.B './SFX/snd_quote_walk.wav',0

NUMBGM  EQU 0
BGM_V   DC.L 0





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
