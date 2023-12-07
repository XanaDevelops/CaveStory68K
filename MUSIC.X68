*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
START_CLIENT:
    CLR.B   (HASBGMSRV)
    LEA     SFX_V, A0           ;SETUP LOAD SONGS
    MOVE.W  #NUMSFX-1, D7
    BSR     LDR_MUS
    SUBQ.L  #2, SP
    JSR     START_TCP_CLIENT
    MOVE.W  (SP)+, D0
    CMP.W   #-1, D0
    BNE     .HAYBGM
    MOVE.B  #-1, (HASBGMSRV)
    .HAYBGM:
    RTS

    
START_SERVER:
    LEA     BGM_V, A0           ;SETUP LOAD SONGS
    MOVE.W  #NUMBGM-1, D7
    BSR     LDR_MUS

    JSR     START_TCP_SERVER

    RTS

SEND_BGM:
    ; 6(SP) ET_ID BGM
    MOVE.W  D0, -(SP)
    
    MOVE.W  6(SP), D0
    ;SI YA SUENA, NO REINICIAR
    CMP.W   (CBGM), D0
    BEQ     .NOREP
    
    MOVE.W  D0, (CBGM)
    TST.B   (HASBGMSRV)
    BNE     LOCALBGM
    
    MOVE.W  #CMDPBGM, -(SP)
    JSR     SEND_DATA
    MOVE.W  D0, (SP)
    JSR     SEND_DATA
    ADDQ.L  #2, SP

    .NOREP:
    MOVE.W  (SP)+, D0
    RTS

LOCALBGM:
    MOVE.W  (SP)+, D0
    RTS

PLAY_BGM:
    ; 20(SP).W ET_ID SND
    MOVEM.L D0-D2/A0, -(SP)

    MOVE.B  #76, D0
    MOVE.L  #3, D2
    TRAP    #15

    MOVE.B  #76, D0
    MOVE.W  20(SP), D1
    SUBQ.L  #2, D2
    TRAP    #15

    MOVEM.L (SP)+, A0/D2-D0
    RTS


PLAY_SFX:
    ; 22(SP).W ET_ID SND
    ; 20(SP).W HAS PRIO
    MOVEM.L D0-D2/A0, -(SP)

    MOVE.B  #76, D0
    TST.W   20(SP)
    BEQ     .NOSTOP
    MOVE.L  #3, D2
    TRAP    #15
    .NOSTOP:
    MOVE.B  #76, D0
    MOVE.W  22(SP), D1
    CLR.L   D2
    TRAP    #15

    MOVEM.L (SP)+, A0/D2-D0
    RTS

STOP_SFX:  
    MOVEM.L D0/D2, -(SP)

    MOVE.B  #76, D0
    MOVE.L  #3, D2
    TRAP    #15

    MOVEM.L (SP)+, D2/D0

    RTS

STOP_BGM:  
    MOVE.W  #CMDSTOP, -(SP)
    JSR     SEND_DATA
    ADDQ.L  #2, SP

    RTS

LDR_MUS:
    MOVE.B  #71, D0
    CLR.W   D2
    CLR.L   D1
    .LOOP:
    MOVE.L  (A0, D2.W), A1
    TRAP    #15
    ADDQ.B  #1, D1
    ADDQ.W  #4, D2
    DBRA    D7, .LOOP
    RTS

    
HASBGMSRV       DC.B 0 ;0 SI, -1, NO
CURRPRIO        DC.B 0

CBGM            DC.W -1

CMDPBGM     EQU $1010
CMDSTOP     EQU $7676
CDMHBEAT    EQU $ACBD





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
