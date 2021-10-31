-- config-mcp.lua @ 2108182222 (LINDA 3.2.6.1111) --

-- ############################################### --
-- ## EFIS block mode1
-- ############################################### --

-- EFIS block buttons and switches
EFIS1 = {
["ENABLED"]		= true  ,
["IDENT"]		= "GPS"  ,
["FPV"] 		= VC_GSLD_FCU_HDGTRKVSFPA  ,
["MTR"] 		= VC_GSLD_FCU_METRIC_ALT  ,
["WX"] 			= VC_WXR_PWSandSYS1_toggle  ,
["STA"] 		= VC_GSLD_CP_EFIS_VORNDB_toggle  ,
["WPT"] 		= VC_GSLD_CP_EFIS_WPT  ,
["ARPT"] 		= VC_GSLD_CP_EFIS_ARPT  ,
["DATA"] 		= VC_GSLD_CP_EFIS_CSTR  ,
["POS"] 		= empty  ,
["TERR"] 		= empty  ,
["ADF1"] 		= VC_GSLD_CP_EFIS_VORADF_1_RtoL  ,
["ADF2"] 		= VC_GSLD_CP_EFIS_VORADF_2_adf  ,
["VOR1"] 		= VC_GSLD_CP_EFIS_VORADF_1_LtoR  ,
["VOR2"] 		= VC_GSLD_CP_EFIS_VORADF_2_toggle  ,
}


-- EFIS MINS knob
MINS1 = {
["A SHOW"]		= empty  ,
["A +"]			= empty  ,
["A ++"]		= empty  ,
["A -"]			= empty  ,
["A --"]		= empty  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS BARO knob
BARO1 = {
["A SHOW"]		= Altimeter_BARO_show  ,
["A +"]			= VC_GSLD_CP_BARO_inc  ,
["A ++"]		= VC_GSLD_CP_BARO_inc  ,
["A -"]			= VC_GSLD_CP_BARO_dec  ,
["A --"]		= VC_GSLD_CP_BARO_dec  ,
["PRESS"] 		= VC_GSLD_CP_EFIS_Baro_toggle  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS CTR knob
CTR1 = {
["A SHOW"]		= empty  ,
["A +"]			= VC_GSLD_CP_EFIS_ND_Mode_inc  ,
["A ++"]		= VC_GSLD_CP_EFIS_ND_Mode_inc  ,
["A -"]			= VC_GSLD_CP_EFIS_ND_Mode_dec  ,
["A --"]		= VC_GSLD_CP_EFIS_ND_Mode_dec  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= Do_nothing  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS TFC knob
TFC1 = {
["A SHOW"]		= empty  ,
["A +"]			= VC_GSLD_CP_EFIS_ND_Range_inc  ,
["A ++"]		= VC_GSLD_CP_EFIS_ND_Range_inc  ,
["A -"]			= VC_GSLD_CP_EFIS_ND_Range_dec  ,
["A --"]		= VC_GSLD_CP_EFIS_ND_Range_dec  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- ############################################### --
-- ## EFIS block mode2
-- ############################################### --

-- EFIS block buttons and switches
EFIS2 = {
["ENABLED"]		= true  ,
["IDENT"]		= "EFB"  ,
["FPV"] 		= empty  ,
["MTR"] 		= empty  ,
["WX"] 			= EFB_ON_SCREEN_MENU_hide  ,
["STA"] 		= EFB_ON_SCREEN_MENU_show  ,
["WPT"] 		= empty  ,
["ARPT"] 		= EFB_DISPLAY_UNIT_tofront  ,
["DATA"] 		= EFB_DISPLAY_UNIT_toggle  ,
["POS"] 		= EFB_MOVING_MAP_toggle  ,
["TERR"] 		= EFB_COLOR_MODE_toggle  ,
["ADF1"] 		= empty  ,
["ADF2"] 		= EFB_DISPLAY_UNIT_toback  ,
["VOR1"] 		= empty  ,
["VOR2"] 		= EFB_DISPLAY_UNIT_tofront  ,
}


-- EFIS MINS knob
MINS2 = {
["A SHOW"]		= empty  ,
["A +"]			= empty  ,
["A ++"]		= empty  ,
["A -"]			= empty  ,
["A --"]		= empty  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS BARO knob
BARO2 = {
["A SHOW"]		= empty  ,
["A +"]			= empty  ,
["A ++"]		= empty  ,
["A -"]			= empty  ,
["A --"]		= empty  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS CTR knob
CTR2 = {
["A SHOW"]		= empty  ,
["A +"]			= empty  ,
["A ++"]		= empty  ,
["A -"]			= empty  ,
["A --"]		= empty  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS TFC knob
TFC2 = {
["A SHOW"]		= empty  ,
["A +"]			= EFB_ZOOM_out  ,
["A ++"]		= EFB_ZOOM_out  ,
["A -"]			= EFB_ZOOM_in  ,
["A --"]		= EFB_ZOOM_in  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- ############################################### --
-- ## EFIS block mode3
-- ############################################### --

-- EFIS block buttons and switches
EFIS3 = {
["ENABLED"]		= false  ,
["IDENT"]		= "WXR"  ,
["FPV"] 		= RXP_WX500_TRACK_L  ,
["MTR"] 		= RXP_WX500_TRACK_R  ,
["WX"] 			= RXP_WX500_POPUP_TOGGLE  ,
["STA"] 		= empty  ,
["WPT"] 		= empty  ,
["ARPT"] 		= empty  ,
["DATA"] 		= weather_OAT  ,
["POS"] 		= empty  ,
["TERR"] 		= empty  ,
["ADF1"] 		= RXP_WX500_SUBMODE_DN  ,
["ADF2"] 		= RXP_WX500_RANGE_DN  ,
["VOR1"] 		= RXP_WX500_SUBMODE_UP  ,
["VOR2"] 		= RXP_WX500_RANGE_UP  ,
}


-- EFIS MINS knob
MINS3 = {
["A SHOW"]		= empty  ,
["A +"]			= RXP_WX500_BRT_INC  ,
["A ++"]		= RXP_WX500_BRT_INC  ,
["A -"]			= RXP_WX500_BRT_DEC  ,
["A --"]		= RXP_WX500_BRT_DEC  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS BARO knob
BARO3 = {
["A SHOW"]		= empty  ,
["A +"]			= RXP_WX500_GAIN_INC  ,
["A ++"]		= RXP_WX500_GAIN_INC  ,
["A -"]			= RXP_WX500_GAIN_DEC  ,
["A --"]		= RXP_WX500_GAIN_DEC  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS CTR knob
CTR3 = {
["A SHOW"]		= empty  ,
["A +"]			= RXP_WX500_MAIN_MODE_NEXT  ,
["A ++"]		= RXP_WX500_MAIN_MODE_NEXT  ,
["A -"]			= RXP_WX500_MAIN_MODE_PREV  ,
["A --"]		= RXP_WX500_MAIN_MODE_PREV  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS TFC knob
TFC3 = {
["A SHOW"]		= empty  ,
["A +"]			= RXP_WX500_TILT_INC  ,
["A ++"]		= RXP_WX500_TILT_INC  ,
["A -"]			= RXP_WX500_TILT_DEC  ,
["A --"]		= RXP_WX500_TILT_DEC  ,
["PRESS"] 		= RXP_WX500_TILT_ZERO  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- ############################################### --
-- ## MCP block mode1
-- ############################################### --

-- MCP block buttons and switches
MCP1 = {
["ENABLED"]	= true  ,
["IDENT"]	= "MCP1"  ,
["TOGA"] 	= MCP2_WIND_BARO_OAT  ,
["TOGN"] 	= empty  ,
["N1"] 		= VC_GSLD_FCU_ATHR  ,
["SPD"] 	= VC_GSLD_FCU_SPD_pull  ,
["FLCH"] 	= VC_GSLD_FCU_EXPED  ,
["HDGSEL"] 	= empty  ,
["HDGHLD"] 	= VC_GSLD_FCU_HDG_pull  ,
["ALTHLD"] 	= VC_GSLD_FCU_ALT_pull  ,
["V/S FPA"] 	= VC_GSLD_FCU_VS_pull  ,
["APP"] 	= VC_GSLD_FCU_APPR  ,
["VNAV"] 	= VC_GSLD_FCU_ALT_push  ,
["LNAV"] 	= VC_GSLD_FCU_HDG_push  ,
["CMDA"] 	= VC_GSLD_FCU_AP1  ,
["CMDB"] 	= VC_GSLD_FCU_AP2  ,
["CMDC"] 	= VC_GSLD_FCU_ALT_STEP_toggle  ,
["LOC"] 	= VC_GSLD_FCU_LOC  ,
["CWSA"] 	= VC_GSLD_CP_EFIS_LS  ,
["CWSB"] 	= VC_GSLD_FCU_EXPED  ,
["A/T UP"] 	= VC_GSLD_FCU_ATHR  ,
["A/T DN"] 	= VC_GSLD_FCU_ATHR  ,
["F/D UP"] 	= VC_GSLD_CP_EFIS_FD_on  ,
["F/D DN"] 	= VC_GSLD_CP_EFIS_FD_off  ,
["MASTER UP"] 	= empty  ,
["MASTER DN"] 	= empty  ,
}


-- MCP CRS knob
CRS1 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- MCP SPD knob
SPD1 = {
["A SHOW"]	= SPD_show  ,
["A +"]		= VC_GSLD_FCU_SPD_inc  ,
["A ++"]	= VC_GSLD_FCU_SPD_inc  ,
["A -"]		= VC_GSLD_FCU_SPD_dec  ,
["A --"]	= VC_GSLD_FCU_SPD_dec  ,
["PRESS"] 	= VC_GSLD_FCU_SPD_push  ,
}


-- MCP HDG knob
HDG1 = {
["A SHOW"]	= HDG_show  ,
["A +"]		= VC_GSLD_FCU_HDG_inc  ,
["A ++"]	= VC_GSLD_FCU_HDG_inc  ,
["A -"]		= VC_GSLD_FCU_HDG_dec  ,
["A --"]	= VC_GSLD_FCU_HDG_dec  ,
["PRESS"] 	= VC_GSLD_FCU_HDG_push  ,
}


-- MCP ALT knob
ALT1 = {
["A SHOW"]	= ALT_show  ,
["A +"]		= VC_GSLD_FCU_ALT_inc  ,
["A ++"]	= VC_GSLD_FCU_ALT_inc  ,
["A -"]		= VC_GSLD_FCU_ALT_dec  ,
["A --"]	= VC_GSLD_FCU_ALT_dec  ,
["PRESS"] 	= VC_GSLD_FCU_ALT_push  ,
}


-- MCP VVS knob
VVS1 = {
["A SHOW"]	= VVS_show  ,
["A +"]		= VC_GSLD_FCU_VS_inc  ,
["A ++"]	= VC_GSLD_FCU_VS_inc  ,
["A -"]		= VC_GSLD_FCU_VS_dec  ,
["A --"]	= VC_GSLD_FCU_VS_dec  ,
["PRESS"] 	= VC_GSLD_FCU_VS_push  ,
}


-- ############################################### --
-- ## MCP block mode2
-- ############################################### --

-- MCP block buttons and switches
MCP2 = {
["ENABLED"]	= true  ,
["IDENT"]	= "MCP2"  ,
["TOGA"] 	= empty  ,
["TOGN"] 	= empty  ,
["N1"] 		= empty  ,
["SPD"] 	= empty  ,
["FLCH"] 	= empty  ,
["HDGSEL"] 	= empty  ,
["HDGHLD"] 	= empty  ,
["ALTHLD"] 	= empty  ,
["V/S FPA"] 	= empty  ,
["APP"] 	= empty  ,
["VNAV"] 	= empty  ,
["LNAV"] 	= empty  ,
["CMDA"] 	= empty  ,
["CMDB"] 	= empty  ,
["CMDC"] 	= empty  ,
["LOC"] 	= empty  ,
["CWSA"] 	= empty  ,
["CWSB"] 	= DSP_MODE_toggle  ,
["A/T UP"] 	= empty  ,
["A/T DN"] 	= empty  ,
["F/D UP"] 	= empty  ,
["F/D DN"] 	= empty  ,
["MASTER UP"] 	= empty  ,
["MASTER DN"] 	= empty  ,
}


-- MCP CRS knob
CRS2 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- MCP SPD knob
SPD2 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- MCP HDG knob
HDG2 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- MCP ALT knob
ALT2 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- MCP VVS knob
VVS2 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- ############################################### --
-- ## MCP block mode3
-- ############################################### --

-- MCP block buttons and switches
MCP3 = {
["ENABLED"]	= false  ,
["IDENT"]	= "MCP3"  ,
["TOGA"] 	= empty  ,
["TOGN"] 	= empty  ,
["N1"] 		= empty  ,
["SPD"] 	= empty  ,
["FLCH"] 	= empty  ,
["HDGSEL"] 	= empty  ,
["HDGHLD"] 	= empty  ,
["ALTHLD"] 	= empty  ,
["V/S FPA"] 	= empty  ,
["APP"] 	= empty  ,
["VNAV"] 	= empty  ,
["LNAV"] 	= empty  ,
["CMDA"] 	= empty  ,
["CMDB"] 	= empty  ,
["CMDC"] 	= empty  ,
["LOC"] 	= empty  ,
["CWSA"] 	= empty  ,
["CWSB"] 	= DSP_MODE_toggle  ,
["A/T UP"] 	= empty  ,
["A/T DN"] 	= empty  ,
["F/D UP"] 	= empty  ,
["F/D DN"] 	= empty  ,
["MASTER UP"] 	= empty  ,
["MASTER DN"] 	= empty  ,
}


-- MCP CRS knob
CRS3 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- MCP SPD knob
SPD3 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- MCP HDG knob
HDG3 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- MCP ALT knob
ALT3 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- MCP VVS knob
VVS3 = {
["A SHOW"]	= empty  ,
["A +"]		= empty  ,
["A ++"]	= empty  ,
["A -"]		= empty  ,
["A --"]	= empty  ,
["PRESS"] 	= empty  ,
}


-- ############################################### --
-- ## USER block mode1
-- ############################################### --

-- USER block buttons and switches
USER1 = {
["ENABLED"]	= true  ,
["IDENT"]	= "empty"  ,
["0"] 		= empty  ,
["1"] 		= empty  ,
["2"] 		= VC_PED_ATCXPDR_MODE_dec  ,
["3"] 		= VC_PED_ATCXPDR_MODE_inc  ,
["4"] 		= empty  ,
["5"] 		= VC_PED_XPDRRPTG_toggle  ,
["6"] 		= VRI_EFIS_MODE_toggle  ,
["7"] 		= VRI_USER_MODE_toggle  ,
}

-- ############################################### --
-- ## USER block mode2
-- ############################################### --

-- USER block buttons and switches
USER2 = {
["ENABLED"]	= true  ,
["IDENT"]	= "ECP"  ,
["0"] 		= VC_PED_ECP_ENG  ,
["1"] 		= VC_PED_ECP_SYS  ,
["2"] 		= VC_PED_ECP_FCTRL  ,
["3"] 		= VC_PED_ECP_APU  ,
["4"] 		= VC_PED_ECP_DOOR  ,
["5"] 		= VC_PED_ECP_FUEL  ,
["6"] 		= VRI_MCP_MODE_toggle  ,
["7"] 		= VRI_USER_MODE_toggle  ,
}

-- ############################################### --
-- ## USER block mode3
-- ############################################### --

-- USER block buttons and switches
USER3 = {
["ENABLED"]	= false  ,
["IDENT"]	= "USR3"  ,
["0"] 		= empty  ,
["1"] 		= empty  ,
["2"] 		= empty  ,
["3"] 		= empty  ,
["4"] 		= empty  ,
["5"] 		= VRI_EFIS_MODE_toggle  ,
["6"] 		= VRI_MCP_MODE_toggle  ,
["7"] 		= VRI_USER_MODE_toggle  ,
}

-- ############################################### --
-- ## RADIOS block mode1
-- ############################################### --

-- RADIOS block buttons and switches
RADIOS = {
["COM1 Select"]	= empty  ,
["COM2 Select"]	= empty  ,
["COM1 Swap"]	= empty  ,
["COM2 Swap"]	= empty  ,
["COMs Mode"]	= Radios_COM_AUDIO_toggle  ,

["NAV1 Select"]	= empty  ,
["NAV2 Select"]	= empty  ,
["NAV1 Swap"]	= empty  ,
["NAV2 Swap"]	= empty  ,
["NAVs Mode"]	= Radios_NAV_AUDIO_toggle  ,

["ADF1 Select"]	= empty  ,
["ADF2 Select"]	= empty  ,
["ADFs Mode"]	= Radios_ADF_AUDIO_toggle  ,

["DME1 Select"]	= empty  ,
["DME2 Select"]	= empty  ,
["DMEs Mode"]	= Radios_DME_AUDIO_toggle  ,

["XPND Select"]	= empty  ,
["XPND Swap"]	= empty  ,
["XPND Mode"]	= Transponder_MODE_toggle  ,
}

