*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
;------ Z ORDER ----- ;
; PARA TENER UN Z ORDER USO UNA DOBLE LISTA ENLAZADA Y ORDENADA
; PERMITE FLEXIBILIDAD EN RUNTIME
; ESTRUCTURA NODE
;   DC.L @ET ;-1 LIBRE
;   DC.W ID NEXT NODE
;   DC.W ID PREV NODE

ZORD_CLEAR:
    ;LIMPIA LA LISTA 
    CLR.W   (TOPNODE)
    CLR.W   (N_NODES)
    MOVE.L  #-1, (NODEVECTOR)
    RTS

ZORD_ADD:
    ;AÑADE ENTIDAD A LA LISTA
    ;X(SP).L @ET
    RTS

ZORD_REMOVE:
    ;ELIMINA ENTIDAD DE LA LISTA

    RTS

ZORD_UPDATE:
    ;ACTUALIZA POS ENTIDAD

    BSR ZORD_REMOVE
    BRA ZORD_ADD

N_NODES     DC.W 0
TOPNODE     DC.W 0

NODEVECTOR  DCB.L NUM_ENT*2,-1

NODESIZE    EQU 8  ;EN BYTES


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~