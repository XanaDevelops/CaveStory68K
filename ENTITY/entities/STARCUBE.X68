*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

STARCB_START:
    ;28+8(SP) ET_YPOS 
    ;30+8(SP) ET_XPOS
    MOVEM.L D1/A1, -(SP)

    ADDS_ZORD

    MOVE.W  36(SP), ET_YPOS(A0)
    MOVE.W  38(SP), ET_XPOS(A0)

    ;HACER COLISIONABLE SU POSICIÓN
    MOVE.L  (CURRENTMAPDIR), A1
    MOVE.W  ET_XPOS(A0), D0
    MOVE.W  ET_YPOS(A0), D1
    LSR.L   #6, D0
    LSR.L   #6, D1
    MULU.W  8(A1), D1
    ADD.W   D1, D0
    MOVE.W  D0, SC_CINDEX(A0)
    LEA     INTERACT_MAP, A1
    MOVE.B  #-1, (A1, D0)

    MOVEM.L (SP)+, A1/D1
    RTS

STARCB_UPDATE:
    RTS


STARCB_DESTROY:
    RTS

STARCB:
    DC.W -4                                          ;ET_ID
    DC.W 0, 0                                       ;ET_XPOS, ET_YPOS
    DC.W 1                                          ;ET_HP
    DC.W 0, 0                                       ;ET_XSPEED, ET_YSPEED
    DC.W 0                                          ;ET_MSTATE 00 
                                                    ;ET_BSTATE UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 64,64                                   ;ET_HBOX 44
    DC.L STARCB_START, STARCB_UPDATE, DEFAULT_PAINT      ;@EXECUTES
    DC.L STARCB_DESTROY                             ;@INTERACT/EXTRA
    DC.L SPR_STARCB                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0                                          ;ET_TSPRT
    DC.W 0                                          ;ET_ZORD
    DS.W 1                                         

SC_CINDEX   EQU ET_DATA   ;W
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
