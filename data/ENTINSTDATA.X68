*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

ENTINSTADA  DC.L .EIDAT1 
        ;WORDS-1
        ;XY @ENTITY
.EIDAT1 DC.W 3
            DC.L $01200380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $02200380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $02600380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $02A00380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $02D00380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $03200380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $03600380, BAT>>16|BAT<<16
        DC.W 3
            DC.L $03A00380, BAT>>16|BAT<<16

        DC.W 4
            DC.W 0
            DC.L $01400400, CARTEL>>16|CARTEL<<16
        DC.W 4
            DC.W 2
            DC.L $01C00400, CARTEL>>16|CARTEL<<16
        DC.W 3
            DC.L $008003A0, PLAYER>>16|PLAYER<<16
        DC.W -1

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
