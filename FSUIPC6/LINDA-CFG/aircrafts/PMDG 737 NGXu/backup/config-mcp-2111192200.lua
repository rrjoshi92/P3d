-- config-mcp.lua @ 2111161904 (LINDA 3.2.6.1111) --

-- ############################################### --
-- ## EFIS block mode1
-- ############################################### --

-- EFIS block buttons and switches
EFIS1 = {
["ENABLED"]		= true  ,
["IDENT"]		= "MOD1"  ,
["FPV"] 		= NGX_EFIS_FPV  ,
["MTR"] 		= NGX_EFIS_MTRS  ,
["WX"] 			= NGX_EFIS_WXR  ,
["STA"] 		= NGX_EFIS_STA  ,
["WPT"] 		= NGX_EFIS_WPT  ,
["ARPT"] 		= NGX_EFIS_ARPT  ,
["DATA"] 		= EFB_DISPLAY_UNIT_toggle  ,
["POS"] 		= EFB_MOVING_MAP_toggle  ,
["TERR"] 		= NGX_EFIS_TERR  ,
["ADF1"] 		= NGX_EFIS_NAV1_dec  ,
["ADF2"] 		= NGX_EFIS_NAV2_dec  ,
["VOR1"] 		= NGX_EFIS_NAV1_inc  ,
["VOR2"] 		= NGX_EFIS_NAV2_toggle  ,
}


-- EFIS MINS knob
MINS1 = {
["A SHOW"]		= empty  ,
["A +"]			= NGX_EFIS_MINS_inc  ,
["A ++"]		= NGX_EFIS_MINS_inc  ,
["A -"]			= NGX_EFIS_MINS_dec  ,
["A --"]		= NGX_EFIS_MINS_dec  ,
["PRESS"] 		= NGX_EFIS_MINS_RST  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS BARO knob
BARO1 = {
["A SHOW"]		= empty  ,
["A +"]			= NGX_EFIS_BARO_inc  ,
["A ++"]		= NGX_EFIS_BARO_inc  ,
["A -"]			= NGX_EFIS_BARO_dec  ,
["A --"]		= NGX_EFIS_BARO_dec  ,
["PRESS"] 		= NGX_EFIS_BARO_STD_toggle  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS CTR knob
CTR1 = {
["A SHOW"]		= empty  ,
["A +"]			= NGX_EFIS_ND_MODE_inc  ,
["A ++"]		= NGX_EFIS_ND_MODE_inc  ,
["A -"]			= NGX_EFIS_ND_MODE_dec  ,
["A --"]		= NGX_EFIS_ND_MODE_dec  ,
["PRESS"] 		= NGX_EFIS_ND_MODE_CTR  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS TFC knob
TFC1 = {
["A SHOW"]		= empty  ,
["A +"]			= NGX_EFIS_ND_RNG_inc  ,
["A ++"]		= NGX_EFIS_ND_RNG_inc  ,
["A -"]			= NGX_EFIS_ND_RNG_dec  ,
["A --"]		= NGX_EFIS_ND_RNG_dec  ,
["PRESS"] 		= NGX_EFIS_ND_RNG_TFC  ,
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
["IDENT"]		= "EFB2"  ,
["FPV"] 		= EFB2_RSB_AUTO  ,
["MTR"] 		= EFB2_RSB_DIR_TO  ,
["WX"] 			= EFB2_RSB_ORIG_GND  ,
["STA"] 		= EFB2_RSB_DEP  ,
["WPT"] 		= EFB2_RSB_ARR  ,
["ARPT"] 		= EFB2_RSB_DEST_GND  ,
["DATA"] 		= EFB2_OptMISC_TRFC  ,
["POS"] 		= EFB2_OptAC_ACFT  ,
["TERR"] 		= EFB2_Option_MvMAP  ,
["ADF1"] 		= EFB2_Option_LIGHTING  ,
["ADF2"] 		= EFB2_Option_LIGHTING  ,
["VOR1"] 		= EFB2_Option_LIGHTING  ,
["VOR2"] 		= EFB2_Option_LIGHTING  ,
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
["PRESS"] 		= EFB2_Option_HDG_UP  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS TFC knob
TFC2 = {
["A SHOW"]		= empty  ,
["A +"]			= EFB2_ZoomOut  ,
["A ++"]		= EFB2_ZoomOut  ,
["A -"]			= EFB2_ZoomIn  ,
["A --"]		= EFB2_ZoomIn  ,
["PRESS"] 		= EFB2_MapPos_ACFT  ,
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
["ENABLED"]		= true  ,
["IDENT"]		= "Door"  ,
["FPV"] 		= empty  ,
["MTR"] 		= empty  ,
["WX"] 			= DOOR_FWD_L_toggle  ,
["STA"] 		= DOOR_L_All_open  ,
["WPT"] 		= DOOR_L_All_close  ,
["ARPT"] 		= DOOR_R_All_open  ,
["DATA"] 		= DOOR_R_All_close  ,
["POS"] 		= CARGO_All_open  ,
["TERR"] 		= CARGO_All_close  ,
["ADF1"] 		= empty  ,
["ADF2"] 		= empty  ,
["VOR1"] 		= empty  ,
["VOR2"] 		= empty  ,
}


-- EFIS MINS knob
MINS3 = {
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
BARO3 = {
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
CTR3 = {
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
TFC3 = {
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


-- ############################################### --
-- ## MCP block mode1
-- ############################################### --

-- MCP block buttons and switches
MCP1 = {
["ENABLED"]	= true  ,
["IDENT"]	= "empty"  ,
["TOGA"] 	= MCP2_WIND_BARO_OAT  ,
["TOGN"] 	= VRI_DSP_MODE_toggle  ,
["N1"] 		= NGX_AP_N1  ,
["SPD"] 	= NGX_AP_SPEED  ,
["FLCH"] 	= NGX_AP_LVLCHG  ,
["HDGSEL"] 	= NGX_AP_SPD_INTV  ,
["HDGHLD"] 	= NGX_AP_HDGSEL  ,
["ALTHLD"] 	= NGX_AP_ALTHLD  ,
["V/S FPA"] 	= NGX_AP_VS  ,
["APP"] 	= NGX_AP_APP  ,
["VNAV"] 	= NGX_AP_VNAV  ,
["LNAV"] 	= NGX_AP_LNAV  ,
["CMDA"] 	= NGX_AP_CMDA_toggle  ,
["CMDB"] 	= NGX_AP_CMDB_toggle  ,
["CMDC"] 	= empty  ,
["LOC"] 	= NGX_AP_VORLOC  ,
["CWSA"] 	= NGX_AP_CWSA  ,
["CWSB"] 	= NGX_AP_CWSB  ,
["A/T UP"] 	= NGX_AP_ATHR_arm  ,
["A/T DN"] 	= NGX_AP_ATHR_off  ,
["F/D UP"] 	= NGX_AP_FD_both_on  ,
["F/D DN"] 	= NGX_AP_FD_both_off  ,
["MASTER UP"] 	= NGX_AP_MASTER_on  ,
["MASTER DN"] 	= NGX_AP_MASTER_off  ,
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
["A SHOW"]	= empty  ,
["A +"]		= NGX_AP_SPD_inc  ,
["A ++"]	= NGX_AP_SPD_incfast  ,
["A -"]		= NGX_AP_SPD_dec  ,
["A --"]	= NGX_AP_SPD_decfast  ,
["PRESS"] 	= NGX_AP_SPD_INTV  ,
}


-- MCP HDG knob
HDG1 = {
["A SHOW"]	= empty  ,
["A +"]		= NGX_AP_HDG_inc  ,
["A ++"]	= NGX_AP_HDG_incfast  ,
["A -"]		= NGX_AP_HDG_dec  ,
["A --"]	= NGX_AP_HDG_decfast  ,
["PRESS"] 	= NGX_AP_HDG_BANK_toggle  ,
}


-- MCP ALT knob
ALT1 = {
["A SHOW"]	= empty  ,
["A +"]		= NGX_AP_ALT_inc  ,
["A ++"]	= NGX_AP_ALT_incfast  ,
["A -"]		= NGX_AP_ALT_dec  ,
["A --"]	= NGX_AP_ALT_decfast  ,
["PRESS"] 	= NGX_AP_ALT_INTV  ,
}


-- MCP VVS knob
VVS1 = {
["A SHOW"]	= empty  ,
["A +"]		= NGX_AP_VS_inc  ,
["A ++"]	= NGX_AP_VS_inc  ,
["A -"]		= NGX_AP_VS_dec  ,
["A --"]	= NGX_AP_VS_dec  ,
["PRESS"] 	= empty  ,
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
["IDENT"]	= "MOD1"  ,
["0"] 		= NGX_AUTOBRAKE_dec  ,
["1"] 		= NGX_AUTOBRAKE_inc  ,
["2"] 		= NGX_XPND_MODE_dec  ,
["3"] 		= NGX_XPND_MODE_inc  ,
["4"] 		= NGX_TCAS_test  ,
["5"] 		= empty  ,
["6"] 		= VRI_EFIS_MODE_toggle  ,
["7"] 		= VRI_USER_MODE_toggle  ,
}

-- ############################################### --
-- ## USER block mode2
-- ############################################### --

-- USER block buttons and switches
USER2 = {
["ENABLED"]	= true  ,
["IDENT"]	= "DSP"  ,
["0"] 		= NGX_DU_LOWER_eng  ,
["1"] 		= NGX_DU_LOWER_sys  ,
["2"] 		= NGX_DU_LOWER_sys  ,
["3"] 		= Do_nothing  ,
["4"] 		= Do_nothing  ,
["5"] 		= Do_nothing  ,
["6"] 		= VRI_EFIS_MODE_toggle  ,
["7"] 		= VRI_USER_MODE_toggle  ,
}

-- ############################################### --
-- ## USER block mode3
-- ############################################### --

-- USER block buttons and switches
USER3 = {
["ENABLED"]	= false  ,
["IDENT"]	= "DOOR"  ,
["0"] 		= NGX_CDU2_MainDoors_left  ,
["1"] 		= NGX_CDU2_MainDoors_right  ,
["2"] 		= NGX_CDU2_Cargo_Doors  ,
["3"] 		= NGX_CDU2_GPU_and_AC_and_AirStart_on  ,
["4"] 		= NGX_CDU2_GPU_and_AC_and_AirStart_off  ,
["5"] 		= NGX_CDU2_Doors_Airstair  ,
["6"] 		= NGX_CDU2_Fuel  ,
["7"] 		= NGX_CDU2_Payload  ,
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

["DME1 Select"]	= NGX_AP_CRS_LR_toggle  ,
["DME2 Select"]	= NGX_AP_CRS_LR_toggle  ,
["DMEs Mode"]	= Radios_DME_AUDIO_toggle  ,

["XPND Select"]	= empty  ,
["XPND Swap"]	= empty  ,
["XPND Mode"]	= Transponder_MODE_toggle  ,
}

