*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
        INCLUDE "DATA/SPRITEVECTOR.X68"

QUOTE_WALK_LN   DC.L 4
                DC.L QUOTE_L_N_0, QUOTE_L_N_1, QUOTE_L_N_0, QUOTE_L_N_2
QUOTE_WALK_RN   DC.L 4
                DC.L QUOTE_R_N_0, QUOTE_R_N_1, QUOTE_R_N_0, QUOTE_R_N_2
QUOTE_WALK_LU   DC.L 4
                DC.L QUOTE_L_U_0, QUOTE_L_U_1, QUOTE_L_U_0, QUOTE_L_U_2
QUOTE_WALK_RU   DC.L 4
                DC.L QUOTE_R_U_0, QUOTE_R_U_1, QUOTE_R_U_0, QUOTE_R_U_2
QUOTE_WALK_LB   DC.L 1
                DC.L QUOTE_L_B_0
QUOTE_WALK_RB   DC.L 1
                DC.L QUOTE_R_B_0
QUOTE_AIRB_RD   DC.L 1
                DC.L QUOTE_R_D_0
QUOTE_AIRB_LD    DC.L 1
                DC.L QUOTE_L_D_0

QUOTE_ANIM_V    DC.L QUOTE_WALK_LN, QUOTE_WALK_RN, QUOTE_WALK_LU, QUOTE_WALK_RU
                DC.L QUOTE_WALK_LB, QUOTE_WALK_RB, QUOTE_AIRB_LD, QUOTE_AIRB_RD


PSTAR_BULLET_1  DC.L 2
                DC.L POLARSTAR_H_1, POLARSTAR_V_1
PSTAR_BULLET_2  DC.L 2
                DC.L POLARSTAR_H_2, POLARSTAR_V_2
PSTAR_BULLET_3  DC.L 2
                DC.L POLARSTAR_H_3, POLARSTAR_V_3

PSTAR_BULLETS   DC.L PSTAR_BULLET_1, PSTAR_BULLET_2, PSTAR_BULLET_3

ARM_POLARSTAR   DC.L POLARSTAR_L_N, POLARSTAR_R_N, POLARSTAR_L_U, POLARSTAR_R_U
                DC.L POLARSTAR_L_D, POLARSTAR_R_D


ICONOARMS       DC.L POLARSTARICO


BAT_FLY_L       DC.L 3
                DC.L CAVEBAT_F_L_0, CAVEBAT_F_L_1, CAVEBAT_F_L_2

CRITTER_L       DC.L 1
                DC.L CRITTER_L_0, CRITTER_L_1, CRITTER_L_2
                DC.L CRITTER_R_0, CRITTER_R_1, CRITTER_R_2

SPIKE_SPR       DC.L 4
                DC.L SPIKE_U, SPIKE_D, SPIKE_L, SPIKE_R

SPR_STARCB      DC.L 1
                DC.L SPR_STARCUBE                

CARTELS         DC.L 1
                DC.L SPR_CARTEL

DISKQ_SPR       DC.L 8
                DC.L SPR_SAVE_0, SPR_SAVE_1, SPR_SAVE_2, SPR_SAVE_3, SPR_SAVE_4, SPR_SAVE_5, SPR_SAVE_6, SPR_SAVE_7
HEALER_SPR      DC.L 2
                DC.L SPR_HEALER_0, SPR_HEALER_1
DOOR_SPR        DC.L 1
                DC.L SPR_DOOR_0
CHEST_C_SPR     DC.L 3
                DC.L SPR_CHEST_C_0, SPR_CHEST_C_1, SPR_CHEST_C_2
                
HEART_SM        DC.L 2
                DC.L HEART_SM_0, HEART_SM_1
DORITO_M        DC.L 5
                DC.L DORITO_M_0, DORITO_M_1, DORITO_M_2, DORITO_M_3, DORITO_M_4, DORITO_M_5


CLOUDS          DC.L NUBE0, NUBE1, NUBE2, NUBE3

SPR_G_DUST      DC.L 7
                DC.L DUST_G_0, DUST_G_1, DUST_G_2, DUST_G_3, DUST_G_4, DUST_G_5, DUST_G_6

SQR_TRANS       DC.L 16
                DC.L NULL, SQR_TRANS_1, SQR_TRANS_2, SQR_TRANS_3, SQR_TRANS_4, SQR_TRANS_5, SQR_TRANS_6, SQR_TRANS_7, SQR_TRANS_8
                DC.L SQR_TRANS_9, SQR_TRANS_10, SQR_TRANS_11, SQR_TRANS_12, SQR_TRANS_13, SQR_TRANS_14, SQR_TRANS_15




BGMMUS  DC.B 4, 41, 41, 41, 41, 41, 41 ;PLACEHOLDER
        DS.W 0

ALLARMS DC.L BULLET_POLARSTAR



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
