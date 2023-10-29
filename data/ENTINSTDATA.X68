*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

ENTINSTADA  DC.L .TSCR, .TMAP1
        ;WORDS-1
        ;XY @ENTITY
.TSCR   DC.W 3
            DC.L $00800080, PLAYER>>16|PLAYER<<16
        DC.W -1

.TMAP1  DC.W 3
            DC.L $01200380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $02200380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $02600380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $02A00380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $02D003D0, BAT>>16|BAT<<16
        DC.W 3
            DC.L $032003D0, BAT>>16|BAT<<16
        DC.W 3
            DC.L $036003D0, BAT>>16|BAT<<16
        DC.W 3
            DC.L $03A003D0, BAT>>16|BAT<<16

        DC.W 4
            DC.W 0
            DC.L $01400400, CARTEL>>16|CARTEL<<16
        DC.W 4
            DC.W 2
            DC.L $01C00400, CARTEL>>16|CARTEL<<16
        DC.W 3
            DC.L $008003A0, PLAYER>>16|PLAYER<<16
        DC.W 4
            DC.W 0
            DC.L $00D003A0, HEART>>16|HEART<<16
        DC.W 4
            DC.W 1
            DC.L $018003A0, DORITO>>16|DORITO<<16
        DC.W -1

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
