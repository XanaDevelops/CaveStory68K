*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ORG    $1000
START:                  ; first instruction of program
    
* Put program code here

    MOVE.L #0, D0
    MOVE.L #1, D1
    MOVE.L #2, D2
    MOVE.L #3, D3
    MOVE.L #4, D4
    MOVE.L #5, A1
    MOVE.L #5, A2
    
    MOVEM.L D0-D4/A1-A2, -(SP)
    NOP
    MOVEM.L (SP)+, A2-A1/D4-D0 
    
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here


    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
