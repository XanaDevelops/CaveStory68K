*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ORG    $1000
START:                  ; first instruction of program
    
* Put program code here

    MOVE.W #4, D0
    CMP.W #2, D0
    BLT _A
    MOVE.W #$FF, D1
    _A:
    
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here


    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
