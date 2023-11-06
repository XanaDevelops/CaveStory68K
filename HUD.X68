*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
HUD_DRAW:
    CLR.L   D2
    MOVE.B  (EQUIPARM), D2

    ;DEPENDE ARMA EQUIPADA
    MOVE.L  #POLARSTARICO, -(SP)
    MOVE.W  #20, -(SP)
    MOVE.W  #20, -(SP)

    BSR     FASTSPRITE
    ADDA.L  #8, SP 
    ;MOVER CURSOR
    MOVE.B  #11, D0
    MOVE.W  #$0204, D1
    TRAP    #15
    ;COLOR FONDO
    MOVE.B  #81, D0
    MOVE.L  #BLACK, D1
    TRAP    #15
    
    MOVE.B  #14, D0
    LEA     .TEXTLVL, A1
    TRAP    #15

    ;ARMA LVL XP
    MOVE.B  #3, D0
    LEA     ARMS_STS, A0
    MOVE.W  (A0, D2), D1
    EXT.L   D1
    CLR.L D2
    MOVE.B  D1, D2 ;GUARDA XP
    ASR.L #8, D1
    TRAP    #15

    ;XP VBAR
    MOVE.W  #HBX, -(SP)
    MOVE.W  #HBY-20, -(SP)
    MOVE.W  #HBL, -(SP)
    MOVE.W  #HBW, -(SP)
    MOVE.W  D2, -(SP)
    MOVE.W  #20, -(SP)
    MOVE.L  #YELLOW, -(SP)
    BSR     VALUEBAR
    ADDA.L  #16, SP

    MOVE.B  #11, D0
    MOVE.W  #$0205, D1
    TRAP    #15

    ;COLOR FONDO
    MOVE.B  #81, D0
    MOVE.L  #BLACK, D1
    TRAP    #15

    MOVE.B  #14, D0
    LEA     .TEXTHP, A1
    TRAP    #15

    MOVE.B  #3, D0
    MOVE.L  (PLAYERREF), A0  ;COMPROBAR QUE EXISTA!
    CLR.L   D1
    MOVE.W  HP(A0), D1
    TRAP    #15

    ;HEALTH VBAR
    MOVE.W  #HBX, -(SP)
    MOVE.W  #HBY, -(SP)
    MOVE.W  #HBL, -(SP)
    MOVE.W  #HBW, -(SP)
    MOVE.W  HP(A0), -(SP)
    MOVE.W  (PMAXHP), -(SP)
    MOVE.L  #RED, -(SP)
    BSR     VALUEBAR
    ADDA.L  #16, SP

    
    RTS
.TEXTLVL     DC.B 'LVL:',0
.TEXTHP      DC.B 'HP:',0
            DS.W 0

VALUEBAR:
    ;MUESTRA UNA BARRA HORIZONTAL
    ; 38(SP).W XPOS
    ; 36(SP).W YPOS
    ; 34(SP).W LENGTH (PX) (multiplo vMAx)
    ; 32(SP).W WIDTH
    ; 30(SP).W VALUE
    ; 28(SP).W MAXVALUE
    ; 24(SP).L COLOR
    MOVEM.L D0-D4, -(SP)

    ;COLOR
    MOVE.B  #80, D0
    MOVE.L  24(SP), D1   ;COLOR
    TRAP    #15
    ADDQ.B  #1, D0
    ANDI.L  #$007F7F7F, D1 ;COLOR ATENUADO
    TRAP    #15
    
    ;RECT GRANDE
    MOVE.B  #87, D0
    MOVE.W  38(SP), D1   ;XPOS
    MOVE.W  36(SP), D2   ;YPOS
    MOVE.W  34(SP), D3   ;LENGTH
    MOVE.W  32(SP), D4   ;WIDTH
    ADD.W   D1, D3
    ADD.W   D2, D4
    TRAP    #15

    MOVE.B  #81, D0
    MOVE.L  24(SP), D1   ;COLOR
    TRAP    #15

    ;CALCULAR POS PX VALOR
    MOVE.W  34(SP), D3   ;L (XP)
    DIVU.W  28(SP), D3   ;MAX V
    MULU.W  30(SP), D3   ;V   
    MOVE.W  38(SP), D1
    ADD.W   D1, D3

    ;PINTAR
    ;SUBQ.B  #3, D0
    MOVE.B  #87, D0
    TRAP    #15

    MOVEM.L (SP)+, D4-D0 
    RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
