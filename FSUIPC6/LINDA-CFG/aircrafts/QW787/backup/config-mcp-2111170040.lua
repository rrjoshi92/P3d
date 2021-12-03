-- config-mcp.lua @ 2111170038 (LINDA 3.2.6.1111) --

-- ############################################### --
-- ## EFIS block mode1
-- ############################################### --

-- EFIS block buttons and switches
EFIS1 = {
["ENABLED"]		= true  ,
["IDENT"]		= "GPS"  ,
["FPV"] 		= QW_MCP_L_FPV_press  ,
["MTR"] 		= QW_MCP_L_MTRS_press  ,
["WX"] 			= QW_MCP_L_WXR_press  ,
["STA"] 		= QW_MCP_L_TFC_press  ,
["WPT"] 		= QW_MCP_L_TERR_press  ,
["ARPT"] 		= QW_MCP_L_RadBaro_toggle  ,
["DATA"] 		= QW_MCP_L_BaroSet_toggle  ,
["POS"] 		= empty  ,
["TERR"] 		= empty  ,
["ADF1"] 		= EFIS_ADF1  ,
["ADF2"] 		= EFIS_ADF2  ,
["VOR1"] 		= EFIS_VOR1  ,
["VOR2"] 		= EFIS_VOR2  ,
}


-- EFIS MINS knob
MINS1 = {
["A SHOW"]		= empty  ,
["A +"]			= QW_MCP_MINS_inc  ,
["A ++"]		= QW_MCP_MINS_inc  ,
["A -"]			= QW_MCP_MINS_dec  ,
["A --"]		= QW_MCP_MINS_dec  ,
["PRESS"] 		= QW_MCP_L_RST_press  ,
["B SHOW"]		= EFIS_MINIMUMS_show  ,
["B +"]			= EFIS_MINIMUMS_inc  ,
["B ++"]		= EFIS_MINIMUMS_inc  ,
["B -"]			= EFIS_MINIMUMS_dec  ,
["B --"]		= EFIS_MINIMUMS_dec  ,
}


-- EFIS BARO knob
BARO1 = {
["A SHOW"]		= QW_MCP_BARO_show  ,
["A +"]			= QW_MCP_BARO_inc  ,
["A ++"]		= QW_MCP_BARO_incfast  ,
["A -"]			= QW_MCP_BARO_dec  ,
["A --"]		= QW_MCP_BARO_decfast  ,
["PRESS"] 		= QW_MCP_L_BaroStd_press  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS CTR knob
CTR1 = {
["A SHOW"]		= QW_MCP_L_ND_Map_show  ,
["A +"]			= QW_MCP_L_NDMAP_inc  ,
["A ++"]		= QW_MCP_L_NDMAP_inc  ,
["A -"]			= QW_MCP_L_NDMAP_dec  ,
["A --"]		= QW_MCP_L_NDMAP_dec  ,
["PRESS"] 		= QW_MCP_L_NDMAP_press  ,
["B SHOW"]		= Do_nothing  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS TFC knob
TFC1 = {
["A SHOW"]		= QW_MCP_L_ND_Rng_show  ,
["A +"]			= QW_MCP_L_ND_Rng_inc  ,
["A ++"]		= QW_MCP_L_ND_Rng_inc  ,
["A -"]			= QW_MCP_L_ND_Rng_dec  ,
["A --"]		= QW_MCP_L_ND_Rng_dec  ,
["PRESS"] 		= QW_MCP_L_RngCtr_press  ,
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
["IDENT"]		= "NDOp"  ,
["FPV"] 		= QW_MCP_L_ENG_press  ,
["MTR"] 		= QW_MCP_L_CANRCL_press  ,
["WX"] 			= QW_MCP_L_SYS_press  ,
["STA"] 		= QW_MCP_L_CDU_press  ,
["WPT"] 		= QW_MCP_L_INFO_press  ,
["ARPT"] 		= QW_MCP_L_CHKL_press  ,
["DATA"] 		= QW_MCP_L_COMM_press  ,
["POS"] 		= QW_MCP_L_ND_press  ,
["TERR"] 		= QW_MCP_L_EICAS_press  ,
["ADF1"] 		= empty  ,
["ADF2"] 		= empty  ,
["VOR1"] 		= empty  ,
["VOR2"] 		= empty  ,
}


-- EFIS MINS knob
MINS2 = {
["A SHOW"]		= empty  ,
["A +"]			= empty  ,
["A ++"]		= empty  ,
["A -"]			= empty  ,
["A --"]		= empty  ,
["PRESS"] 		= QW_MCP_L_RadBaro_toggle  ,
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
["PRESS"] 		= QW_MCP_L_BaroSet_toggle  ,
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
["TOGA"] 	= QW_MCP_TOGA_press  ,
["TOGN"] 	= empty  ,
["N1"] 		= QW_MCP_CLB_CON_press  ,
["SPD"] 	= QW_MCP_AT_press  ,
["FLCH"] 	= QW_MCP_FLCH_press  ,
["HDGSEL"] 	= empty  ,
["HDGHLD"] 	= QW_MCP_HDG_HOLD_press  ,
["ALTHLD"] 	= QW_MCP_ALT_HOLD_press  ,
["V/S FPA"] 	= QW_MCP_VS_FPA_press  ,
["APP"] 	= QW_MCP_APP_press  ,
["VNAV"] 	= QW_MCP_VNAV_press  ,
["LNAV"] 	= QW_MCP_LNAV_press  ,
["CMDA"] 	= QW_AP_MasterLeft_toggle  ,
["CMDB"] 	= QW_AP_MasterRight_toggle  ,
["CMDC"] 	= QW_MCP_L_WARNING_press  ,
["LOC"] 	= QW_MCP_LOC_press  ,
["CWSA"] 	= empty  ,
["CWSB"] 	= empty  ,
["A/T UP"] 	= QW_AT_Both_Arm_on  ,
["A/T DN"] 	= QW_AT_Both_Arm_off  ,
["F/D UP"] 	= QW_MCP_L_FD_on  ,
["F/D DN"] 	= QW_MCP_L_FD_off  ,
["MASTER UP"] 	= QW_MCP_AP_Disengage_on  ,
["MASTER DN"] 	= QW_MCP_AP_Disengage_off  ,
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
["A +"]		= QW_AP_Spd_inc  ,
["A ++"]	= QW_AP_Spd_incfast  ,
["A -"]		= QW_AP_Spd_dec  ,
["A --"]	= QW_AP_Spd_decfast  ,
["PRESS"] 	= empty  ,
}


-- MCP HDG knob
HDG1 = {
["A SHOW"]	= HDG_show  ,
["A +"]		= QW_AP_Hdg_inc  ,
["A ++"]	= QW_AP_Hdg_incfast  ,
["A -"]		= QW_AP_Hdg_dec  ,
["A --"]	= QW_AP_Hdg_decfast  ,
["PRESS"] 	= QW_MCP_HDG_SEL_press  ,
}


-- MCP ALT knob
ALT1 = {
["A SHOW"]	= ALT_show  ,
["A +"]		= QW_AP_Alt_inc  ,
["A ++"]	= QW_AP_Alt_inc  ,
["A -"]		= QW_AP_Alt_dec  ,
["A --"]	= QW_AP_Alt_dec  ,
["PRESS"] 	= QW_MCP_ALT_AUTO_toggle  ,
}


-- MCP VVS knob
VVS1 = {
["A SHOW"]	= VVS_show  ,
["A +"]		= QW_AP_VS_up  ,
["A ++"]	= QW_AP_VS_up  ,
["A -"]		= QW_AP_VS_down  ,
["A --"]	= QW_AP_VS_down  ,
["PRESS"] 	= Autopilot_VSSEL_mode  ,
}


-- ############################################### --
-- ## MCP block mode2
-- ############################################### --

-- MCP block buttons and switches
MCP2 = {
["ENABLED"]	= true  ,
["IDENT"]	= "Eng"  ,
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
["CMDA"] 	= QW_OH_ENG_L_START_toggle  ,
["CMDB"] 	= QW_OH_ENG_R_START_toggle  ,
["CMDC"] 	= QW_OH_ELE_APU_cycle  ,
["LOC"] 	= empty  ,
["CWSA"] 	= QW_Fuel_Control_L_toggle  ,
["CWSB"] 	= QW_Fuel_Control_R_toggle  ,
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
["IDENT"]	= "Lght"  ,
["0"] 		= QW_OH_LDG_ALL_toggle  ,
["1"] 		= QW_OH_LT_BEACON_toggle  ,
["2"] 		= QW_OH_LT_NAV_toggle  ,
["3"] 		= QW_OH_LT_Both_RWYTF_toggle  ,
["4"] 		= QW_OH_LT_STROBE_toggle  ,
["5"] 		= VRI_EFIS_MODE_toggle  ,
["6"] 		= VRI_MCP_MODE_toggle  ,
["7"] 		= VRI_USER_MODE_toggle  ,
}

-- ############################################### --
-- ## USER block mode2
-- ############################################### --

-- USER block buttons and switches
USER2 = {
["ENABLED"]	= true  ,
["IDENT"]	= "ELEC"  ,
["0"] 		= QW_OH_ELE_BATT_toggle  ,
["1"] 		= QW_OH_ELE_APU_cycle  ,
["2"] 		= QW_OH_ENG_L_START_toggle  ,
["3"] 		= QW_OH_ENG_R_START_toggle  ,
["4"] 		= empty  ,
["5"] 		= VRI_EFIS_MODE_toggle  ,
["6"] 		= VRI_MCP_MODE_toggle  ,
["7"] 		= VRI_USER_MODE_toggle  ,
}

-- ############################################### --
-- ## USER block mode3
-- ############################################### --

-- USER block buttons and switches
USER3 = {
["ENABLED"]	= true  ,
["IDENT"]	= "IntL"  ,
["0"] 		= QW_OH_TEXT_toggle  ,
["1"] 		= QW_OH_DOME_toggle  ,
["2"] 		= QW_OH_MSTR_BRT_dec  ,
["3"] 		= QW_OH_MSTR_BRT_inc  ,
["4"] 		= QW_OH_MSTR_BRT_TEST_toggle  ,
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

