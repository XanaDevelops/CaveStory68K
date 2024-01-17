*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

PEXLDUST_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    ;CONTADOR PARA INSTANCIAS PA_DUST
    MOVE.B  #25, PEXLD_COUNTER(A0)

    RTS

PEXLDUST_UPDATE:

    SUBI.B  #1, PEXLD_COUNTER(A0)
    BPL     .NOKILL
    MOVE.L  A0, -(SP)
    JSR     DESTROY_ENTITY
    ADDQ.L  #4, SP
    BRA     .END
    .NOKILL:
    
    ;INSTANCIA
    MOVE.W  ET_XPOS(A0), -(SP)
    MOVE.W  ET_YPOS(A0), -(SP)
    MOVE.L  #PADUST, -(SP)

    ;OFFSET ALEATORIO
    BSR     .D0VAL
    ADD.W   D0, 4(SP)
    BSR     .D0VAL
    ADD.W   D0, 6(SP)

    JSR     INSTANCE_ENTITY
    ADDQ.L  #8, SP
    .END:
    RTS

    .D0VAL:
    TRAP    #TRNG
    MOVE.L  (RNGVAL), D0
    AND.L   #$8000007F, D0
    BPL     .NONEG
    NEG.W   D0
    .NONEG:
    RTS


PEXLDUST:
    DC.W 42                                          ;ET_ID
    DC.W 0, 0                                       ;ET_XPOS, ET_YPOS
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;ET_XSPEED, ET_YSPEED
    DC.W 0                                          ;ET_MSTATE 00 
                                                    ;ET_BSTATE UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;ET_HBOX 44
    DC.L PEXLDUST_START, PEXLDUST_UPDATE, DEFAULT_RTS      ;@EXECUTES
    DC.L DEFAULT_RTS                             ;@INTERACT/EXTRA
    DC.L -1                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0                                          ;ET_TSPRT
    DC.W 0                                          ;ET_ZORD
    DS.W 1                                         

PEXLD_COUNTER   EQU ET_DATA ;B
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
