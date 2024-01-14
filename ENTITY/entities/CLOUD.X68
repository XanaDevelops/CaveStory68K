*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
CLOUD_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS
    ;32(SP) TYPE

    ADDS_ZORD

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    MOVE.W  32(SP), D0
    ASL.W   #1, D0
    MOVE.W  D0, TYPE(A0)
    ASL.W   #1, D0
    LEA     CLOUDS, A1
    MOVE.L  (A1, D0.W), ET_SPRITE(A0)

    RTS

CLOUD_UPDATE:
    MOVE.W  D0, -(SP)
    
    MOVE.W  ET_XPOS(A0), D0

    SUBQ.W  #STARTVEL, D0
    ADD.W   TYPE(A0), D0
    CMP.W   #-CLOUDXSIZE, D0
    BGT     .NOPAR
    MOVE.W  #CLOUDXSIZE+XPMODE*CLOUDXSIZE, D0
    .NOPAR:
    MOVE.W  D0, ET_XPOS(A0)

    MOVE.W  (SP)+, D0
    RTS

CLOUD_PAINT:
    MOVE.L  ET_SPRITE(A0), -(SP)
    MOVE.W  ET_YPOS(A0), -(SP) ;Y
    MOVE.W  ET_XPOS(A0), -(SP) ;X
    JSR     FASTSPRITE
    ADDQ.L  #8, SP
    RTS
    
CLOUD:
    DC.W 3                                          ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;ET_HBOX 44
    DC.L CLOUD_START, CLOUD_UPDATE, CLOUD_PAINT     ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L NUBE0                                     ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
    DC.W 0                                          ;ET_ZORD
                                                
    
TYPE        EQU ET_DATA

CLOUDXSIZE  EQU 640
STARTVEL    EQU 7


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
