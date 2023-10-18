*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
SYSTEM_INIT:
    ;CONFIGURE SCREEN
    MOVE.B #33, D0
    MOVE.L #SCREEN_WIDTH*$10000+SCREEN_HEIGHT, D1
    TRAP #15

    MOVE.B #92, D0  ;dbuf
    MOVE.B #17, D1
    TRAP #15  

    ;INT OFF
    ORI.W #%0000111000000000, SR
    ;INSTALL
    MOVE.L #UPDATE_KEYS, (TRAPBASE)  
    
    ;INT ON
    ANDI.W #%111100011111111, SR
    
    MOVE.B #32, D0
    MOVE.B #5, D1
    TRAP #15

    JSR START_CLIENT

    MOVE.W #-1, (CURRENTTXTID)

    MOVE.W SR, -(SP)    ;PASA A USUARIO
    ANDI.W #$DFFF, (SP) ;D8FF
    RTE

    

SET_SCROLL_TEXT:
    MOVEM.L D0-D2, -(SP)

    MOVE.B #21, D0
    MOVE.L #WHITE, D1
    ;MOVE.L #$04060000, D2   ;Example: D2.L = $01090005 is Fixedsys, 9 point, Bold Underline 8px
    MOVE.L #$04100000, D2
    TRAP #15

    MOVEM.L (SP)+, D2-D0
    RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
