*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ORG    $1000
START:                  ; first instruction of program
    
* Put program code here

    CLR.L D0
    MOVE.L #0, D1
    .A:
    ADDQ.W #1, D0
    DBRA D1, .A
    
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here


    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
