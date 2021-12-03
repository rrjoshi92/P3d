-- config-mcp.lua @ 2111101916 (LINDA 3.2.6.1111) --

-- ############################################### --
-- ## EFIS block mode1
-- ############################################### --

-- EFIS block buttons and switches
EFIS1 = {
["ENABLED"]		= true  ,
["IDENT"]		= "empty"  ,
["FPV"] 		= EFIS_CPT_FPV  ,
["MTR"] 		= EFIS_CPT_MTRS  ,
["WX"] 			= EFIS_CPT_WXR  ,
["STA"] 		= EFIS_CPT_STA  ,
["WPT"] 		= EFIS_CPT_WPT  ,
["ARPT"] 		= EFIS_CPT_ARPT  ,
["DATA"] 		= EFIS_CPT_DATA  ,
["POS"] 		= EFIS_CPT_POS  ,
["TERR"] 		= EFIS_CPT_TERR  ,
["ADF1"] 		= EFIS_CPT_VOR_ADFVOR_L_dec  ,
["ADF2"] 		= EFIS_CPT_VOR_ADFVOR_R_dec  ,
["VOR1"] 		= EFIS_CPT_VOR_ADFVOR_L_inc  ,
["VOR2"] 		= EFIS_CPT_VOR_ADFVOR_R_toggle  ,
}


-- EFIS MINS knob
MINS1 = {
["A SHOW"]		= empty  ,
["A +"]			= EFIS_CPT_MINIMUMS_inc  ,
["A ++"]		= EFIS_CPT_MINIMUMS_inc  ,
["A -"]			= EFIS_CPT_MINIMUMS_dec  ,
["A --"]		= EFIS_CPT_MINIMUMS_dec  ,
["PRESS"] 		= EFIS_CPT_MINIMUMS_RST  ,
["B SHOW"]		= empty  ,
["B +"]			= EFIS_CPT_MINIMUMS_inc  ,
["B ++"]		= EFIS_CPT_MINIMUMS_inc  ,
["B -"]			= EFIS_CPT_MINIMUMS_dec  ,
["B --"]		= EFIS_CPT_MINIMUMS_dec  ,
}


-- EFIS BARO knob
BARO1 = {
["A SHOW"]		= empty  ,
["A +"]			= EFIS_CPT_BARO_inc  ,
["A ++"]		= EFIS_CPT_BARO_inc  ,
["A -"]			= EFIS_CPT_BARO_dec  ,
["A --"]		= EFIS_CPT_BARO_dec  ,
["PRESS"] 		= EFIS_CPT_BARO_STD  ,
["B SHOW"]		= empty  ,
["B +"]			= EFIS_CPT_BARO_inc  ,
["B ++"]		= EFIS_CPT_BARO_inc  ,
["B -"]			= EFIS_CPT_BARO_dec  ,
["B --"]		= EFIS_CPT_BARO_dec  ,
}


-- EFIS CTR knob
CTR1 = {
["A SHOW"]		= empty  ,
["A +"]			= EFIS_CPT_MAP_MODE_inc  ,
["A ++"]		= EFIS_CPT_MAP_MODE_inc  ,
["A -"]			= EFIS_CPT_MAP_MODE_dec  ,
["A --"]		= EFIS_CPT_MAP_MODE_dec  ,
["PRESS"] 		= EFIS_CPT_MODE_CTR  ,
["B SHOW"]		= empty  ,
["B +"]			= EFIS_CPT_MAP_MODE_inc  ,
["B ++"]		= EFIS_CPT_MAP_MODE_inc  ,
["B -"]			= EFIS_CPT_MAP_MODE_dec  ,
["B --"]		= EFIS_CPT_MAP_MODE_dec  ,
}


-- EFIS TFC knob
TFC1 = {
["A SHOW"]		= empty  ,
["A +"]			= EFIS_CPT_RANGE_inc  ,
["A ++"]		= EFIS_CPT_RANGE_inc  ,
["A -"]			= EFIS_CPT_RANGE_dec  ,
["A --"]		= EFIS_CPT_RANGE_dec  ,
["PRESS"] 		= EFIS_CPT_RANGE_TFC  ,
["B SHOW"]		= empty  ,
["B +"]			= EFIS_CPT_RANGE_inc  ,
["B ++"]		= EFIS_CPT_RANGE_inc  ,
["B -"]			= EFIS_CPT_RANGE_dec  ,
["B --"]		= EFIS_CPT_RANGE_dec  ,
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
["WX"] 			= empty  ,
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
["ENABLED"]		= true  ,
["IDENT"]		= "DOOR"  ,
["FPV"] 		= empty  ,
["MTR"] 		= empty  ,
["WX"] 			= DOOR_1L_toggle  ,
["STA"] 		= DOOR_GSX_L_open  ,
["WPT"] 		= DOOR_ALL_L_close  ,
["ARPT"] 		= DOOR_GSX_R_open  ,
["DATA"] 		= DOOR_ALL_R_close  ,
["POS"] 		= CARGO_ALL_open  ,
["TERR"] 		= CARGO_ALL_close  ,
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
["TOGN"] 	= empty  ,
["N1"] 		= MCP_THR_SWITCH  ,
["SPD"] 	= MCP_SPD_SWITCH  ,
["FLCH"] 	= MCP_LVL_CHG_SWITCH  ,
["HDGSEL"] 	= empty  ,
["HDGHLD"] 	= MCP_HDG_HOLD_SWITCH  ,
["ALTHLD"] 	= MCP_ALT_HOLD_SWITCH  ,
["V/S FPA"] 	= MCP_VS_SWITCH  ,
["APP"] 	= MCP_APP_SWITCH  ,
["VNAV"] 	= MCP_VNAV_SWITCH  ,
["LNAV"] 	= MCP_LNAV_SWITCH  ,
["CMDA"] 	= MCP_AP_L_SWITCH  ,
["CMDB"] 	= MCP_AP_R_SWITCH  ,
["CMDC"] 	= MCP_AP_C_SWITCH  ,
["LOC"] 	= MCP_LOC_SWITCH  ,
["CWSA"] 	= empty  ,
["CWSB"] 	= empty  ,
["A/T UP"] 	= EVT_MCP_AT_ARM_SWITCH_on  ,
["A/T DN"] 	= EVT_MCP_AT_ARM_SWITCH_off  ,
["F/D UP"] 	= MCP_FD_SWITCH_L_on  ,
["F/D DN"] 	= MCP_FD_SWITCH_L_off  ,
["MASTER UP"] 	= MCP_DISENGAGE_BAR_on  ,
["MASTER DN"] 	= MCP_DISENGAGE_BAR_off  ,
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
["A +"]		= MCP_SPEED_SELECTOR_inc  ,
["A ++"]	= MCP_SPEED_SELECTOR_incfast  ,
["A -"]		= MCP_SPEED_SELECTOR_dec  ,
["A --"]	= MCP_SPEED_SELECTOR_decfast  ,
["PRESS"] 	= MCP_SPEED_PUSH_SWITCH  ,
}


-- MCP HDG knob
HDG1 = {
["A SHOW"]	= empty  ,
["A +"]		= MCP_HDG_SELECTOR_inc  ,
["A ++"]	= MCP_HDG_SELECTOR_incfast  ,
["A -"]		= MCP_HDG_SELECTOR_dec  ,
["A --"]	= MCP_HDG_SELECTOR_decfast  ,
["PRESS"] 	= MCP_HEADING_PUSH_SWITCH  ,
}


-- MCP ALT knob
ALT1 = {
["A SHOW"]	= empty  ,
["A +"]		= MCP_ALT_SELECTOR_inc  ,
["A ++"]	= MCP_ALT_SELECTOR_incfast  ,
["A -"]		= MCP_ALT_SELECTOR_dec  ,
["A --"]	= MCP_ALT_SELECTOR_decfast  ,
["PRESS"] 	= MCP_ALT_PUSH_SWITCH  ,
}


-- MCP VVS knob
VVS1 = {
["A SHOW"]	= empty  ,
["A +"]		= MCP_VS_SELECTOR_inc  ,
["A ++"]	= MCP_VS_SELECTOR_inc  ,
["A -"]		= MCP_VS_SELECTOR_dec  ,
["A --"]	= MCP_VS_SELECTOR_dec  ,
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
["IDENT"]	= "MAIN"  ,
["0"] 		= Autobrake_dec  ,
["1"] 		= Autobrake_inc  ,
["2"] 		= TCAS_MODE_dec  ,
["3"] 		= TCAS_MODE_inc  ,
["4"] 		= TCAS_TEST  ,
["5"] 		= VRI_EFIS_MODE_toggle  ,
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
["0"] 		= DSP_ENG  ,
["1"] 		= DSP_STAT  ,
["2"] 		= DSP_STAT  ,
["3"] 		= DSP_STAT  ,
["4"] 		= DSP_DOOR  ,
["5"] 		= DSP_FUEL  ,
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

