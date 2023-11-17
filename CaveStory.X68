*-----------------------------------------------------------
* Title      : Cave Story (Port)
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    INCLUDE "XPMODE.X68"
    INCLUDE "MACROS.X68"
    INCLUDE "CONST.X68"

INIT:                  ; first instruction of program
    CLR.B   (GAMEFLAGS)
    BSET.B  #4, (GAMEFLAGS)
    BSR     SYSTEM_INIT
    
    JSR     KC_INIT

    MOVE.W  #0, SCREEN_X
    MOVE.W  #TILESIZE*0, SCREEN_Y
    
    MOVE.W  #0, SCR_SPEED_X
    MOVE.W  #0, SCR_SPEED_Y

    JSR     ENTSTCSTART

    ;MANUALMENTE CARGAR MAPA
    MOVE.W  #0, (LOAD_MAP_ID)
    BSR     DO_LOAD_MAP
    

    ;MOVE.B #92, D0 ;don comedia, no apto fotosensibles
    ;MOVE.W #15, D1 ;el 12 no mola
    ;TRAP #15

    CLRSCREEN

    ;GAMEFLAGS
    ;7 UPDATE
    ;6 END DBOX
    ;5 LINE DBOX
    ;4 SHOW HUD
    ;3 WAIT Z DBOX
    ;0 FULLSCREEN TOGGLE
MAINLOOP:
    ;UPDATE RNG
    TRAP #14
    ;BSR UPDATE_KEYS
    TRAP #0
    
    ;CHECK FULLSCREEN (F11)
    BTST.B  #KEYM_F11, (KEY_PRESS_MENU)
    BEQ     .NOFS
    MOVE.B  #33, D0
    BCHG.B  #0, (GAMEFLAGS)
    BEQ     .TOGGLE
    ;WINDOWED
    MOVE.L  #1, D1
    BRA     .FSET
    .TOGGLE:
    ;FULLLSCREEN
    MOVE.L  #2, D1
    .FSET:
    TRAP    #15

    .NOFS:

    SUBQ.B  #1, (FTOSKIP)
    MOVE.B  (FTOSKIP), D0
    .UPDATE:
    MOVE.B  D0, (FTOSKIP)

    JSR     KC_UPD

    JSR     GM_UPDATE
    JSR     UPDATE_DBOX
    JSR     TRANS_CONTROL

    BTST.B  #7, (GAMEFLAGS)
    BNE     .NOUPD
    JSR     UPDATE_ALL_ENT
    
    MOVE.B  (FTOSKIP), D0
    EXT.W   D0
    DBRA    D0, .UPDATE
    
    .NOUPD:
    BTST.B  #0, (SCREEN_ST)
    BNE     .FSKIP
    CLR.B   (FTOSKIP)

    REPAINT
    CLRSCREEN

    MOVE.L  CURRENTMAPDIR, -(SP)
    BSR     DRAW_MAP
    ADDQ.L  #4, SP

    JSR     DRAW_ALL_ENT
    
    BTST.B  #4, (GAMEFLAGS)
    BNE     .NOHUD
    BSR     HUD_DRAW
    .NOHUD:

    JSR     TRANS_DRAW
    JSR     DRAW_DBOX
    .FSKIP:


    ;BCLR.B #0, (SCREEN_ST)

.PINTARFPS:
    MOVE.B  #11, D0      ;COLOCAR CURSOR
    MOVE.W  #45<<8, D1
    TRAP    #15

    MOVE.B  #81, D0      ;FONDO NEGRO
    MOVE.L  #BLACK, D1
    TRAP    #15

    BSR SET_SCROLL_TEXT ;COLOR BLANCO

ENDMAINLOOP:
    MOVE.B  #3, D0
    CLR.L   D1
    MOVE.B  (FTOSKIP), D1
    TRAP    #15

    .WAIT_REFRESH:
    TST.B   (FTOSKIP)
    BEQ     .WAIT_REFRESH
    CMP.B   #1, (FTOSKIP)
    BGT     .DOFSKIP
        BCLR.B  #0, (SCREEN_ST)
        BRA     MAINLOOP
    .DOFSKIP:
    BSET.B  #0, (SCREEN_ST)
    CMP.B   #MAXFSKIP, (FTOSKIP)
    BLE     MAINLOOP
    MOVE.B  #MAXFSKIP, (FTOSKIP)
    BCLR.B  #0, (SCREEN_ST)
    BRA     MAINLOOP



    INCLUDE "TECLADO.X68"
    INCLUDE "SYSTEM.X68"
    INCLUDE "FILEIO.X68"
    INCLUDE "TCPCLIENT.X68"
    INCLUDE "GAMEMANAGER.X68"
    INCLUDE "COLISSION.X68"
    INCLUDE "ScreenScroll.X68"
    INCLUDE "FastSprite.x68"
    INCLUDE "DRAWMAP.x68"
    INCLUDE "HUD.X68"
    INCLUDE "VARS.X68"
    INCLUDE "DBOX.X68"
    INCLUDE "TRANSITIONS.X68"
    INCLUDE "KC.X68"
    INCLUDE "ENTITY/EntityIncluder.x68"
    INCLUDE "ENTITY/EntityManagement.x68"
    INCLUDE "ENTITY/ENTITY_STATIC_START.x68"
    INCLUDE "ENTITY/Physics.X68"
    INCLUDE "ENTITY/Interactor.x68"
    INCLUDE "MUSIC.X68"
    INCLUDE "data/newEntsData.x68"
    INCLUDE "data/DATA.x68"
    INCLUDE "data/sprites.x68"
    ;INCLUDE "data/tiles.X68"
    INCLUDE "data/newMaps.x68"
    INCLUDE "data/Dialogs.x68"
    INCLUDE "data/sounds.x68"








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
