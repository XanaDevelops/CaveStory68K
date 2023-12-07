*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

SPIKE_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS
    ;32(SP).W DIR

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    MOVE.W  32(SP), ET_ISPR+2(A0)
    
    RTS

SPIKE_UPDATE:
    MOVE.L  A1, -(SP)

    MOVE.L  A0, -(SP)
    SUBQ.L  #4, SP
    BSR     COLLISION_ENT_PLR
    MOVE.L  (SP)+, A1
    ADDQ.L  #4, SP

    CMP.L   #-1, A1
    BEQ     .NOCOLIE

    MOVE.W  SPIKEATK(A0), -(SP)
    MOVE.L  A1, -(SP)
    MOVE.L  ET_REVDAM(A1), A1
    JSR     (A1)
    ADDQ.L  #6, SP
    .NOCOLIE:

    MOVE.L  (SP)+, A1
    RTS


SPIKE:
    DC.W -2                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 9999                                       ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 8,12, 56,64                                 ;ET_HBOX 44
    DC.L SPIKE_START, SPIKE_UPDATE, DEFAULT_PAINT   ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L SPIKE_SPR                                  ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
                                         
       

SPIKEATK    EQU ET_HP
    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
