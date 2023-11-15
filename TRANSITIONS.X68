*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

TRANS_CONTROL:
    ;CONTROLAR TRANS
    BTST.B  #0, (TRANS_STATUS) ;SI 0 O 2
    BEQ     .NOTRANS

    MOVE.W  TRANS_INDEX, D1                   ;ANIM_INDEX
    BTST.B  #1, (TRANS_STATUS)
    BNE     .UNDO
    ;AVANZAR TRANS
    ADDQ.L  #1, D1
    LEA     SQR_TRANS, A1
    CMP.L   (A1), D1
    BLT     .NOOF
    SUBQ.L  #1, D1
    MOVE.B  #2, (TRANS_STATUS)
    .NOOF:
    BRA     .ENDDIR
    .UNDO:
    ;RETROCEDER
    SUBQ.L  #1, D1
    BPL     .NOOF2
    CLR.L   D1
    MOVE.B  #0, (TRANS_STATUS)
    .NOOF2:
    .ENDDIR:
    MOVE.W  D1, TRANS_INDEX    

    .NOTRANS:
    RTS
    
TRANS_DRAW:
    TST.B   (TRANS_STATUS)
    BEQ     .END
    MOVEM.L D1-D3/D6-D7/A0-A1, -(SP)
    ;DIBUJAR EFECTO TRANSICION
    LEA     SQR_TRANS, A1
    MOVE.W  TRANS_INDEX, D1

    ;OBTENER SPRITE
    ASL.L   #2, D1
    MOVE.L  4(A1, D1), A1

    ;PINTAR
    CLR.W   D3 ;Y
    MOVE.W  #SCREEN_YTILE-1, D7
    .LOOPY:
    CLR.W   D2 ;X
    MOVE.W  #SCREEN_XTILE-1, D6
    .LOOPX:
    MOVE.L  A1, -(SP)
    MOVE.W  D3, -(SP)
    MOVE.W  D2, -(SP)
    JSR FASTSPRITE
    ADDQ.L #8, SP

    ADD.W   #TILESIZE, D2
    DBRA    D6, .LOOPX
    ADD.W   #TILESIZE, D3
    DBRA    D7, .LOOPY  

    MOVEM.L (SP)+, A1-A0/D7-D6/D3-D1
    .END:
    RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
