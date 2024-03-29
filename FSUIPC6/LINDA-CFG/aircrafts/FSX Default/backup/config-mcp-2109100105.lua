-- config-mcp.lua @ 2109090039 (LINDA 3.2.6.1111) --

-- ############################################### --
-- ## EFIS block mode1
-- ############################################### --

-- EFIS block buttons and switches
EFIS1 = {
["ENABLED"]		= true  ,
["IDENT"]		= "GPS"  ,
["FPV"] 		= GPS_ENTER_button  ,
["MTR"] 		= GPS_DIRECTTO_button  ,
["WX"] 			= RXP_WX500_POPUP_TOGGLE  ,
["STA"] 		= GPS_MENU_button  ,
["WPT"] 		= GPS_CLR_button  ,
["ARPT"] 		= GPS_NRST_button  ,
["DATA"] 		= GPS_FPL_button  ,
["POS"] 		= GPS_PROC_button  ,
["TERR"] 		= GPS_TERR_button  ,
["ADF1"] 		= EFIS_ADF1  ,
["ADF2"] 		= EFIS_ADF2  ,
["VOR1"] 		= EFIS_VOR1  ,
["VOR2"] 		= EFIS_VOR2  ,
}


-- EFIS MINS knob
MINS1 = {
["A SHOW"]		= GPS_PAGE_show  ,
["A +"]			= GPS_PAGE_inc  ,
["A ++"]		= GPS_PAGE_inc  ,
["A -"]			= GPS_PAGE_dec  ,
["A --"]		= GPS_PAGE_dec  ,
["PRESS"] 		= KNOB_MODE_toggle  ,
["B SHOW"]		= EFIS_MINIMUMS_show  ,
["B +"]			= EFIS_MINIMUMS_inc  ,
["B ++"]		= EFIS_MINIMUMS_inc  ,
["B -"]			= EFIS_MINIMUMS_dec  ,
["B --"]		= EFIS_MINIMUMS_dec  ,
}


-- EFIS BARO knob
BARO1 = {
["A SHOW"]		= Altimeter_BARO_show  ,
["A +"]			= Altimeter_BARO_plus  ,
["A ++"]		= Altimeter_BARO_plusfast  ,
["A -"]			= Altimeter_BARO_minus  ,
["A --"]		= Altimeter_BARO_minusfast  ,
["PRESS"] 		= Altimeter_BARO_MODE_toggle  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS CTR knob
CTR1 = {
["A SHOW"]		= empty  ,
["A +"]			= GPS_GROUP_inc  ,
["A ++"]		= GPS_GROUP_inc  ,
["A -"]			= GPS_GROUP_dec  ,
["A --"]		= GPS_GROUP_dec  ,
["PRESS"] 		= GPS_CRSR_button  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS TFC knob
TFC1 = {
["A SHOW"]		= empty  ,
["A +"]			= GPS_ZOOM_inc  ,
["A ++"]		= GPS_ZOOM_inc  ,
["A -"]			= GPS_ZOOM_dec  ,
["A --"]		= GPS_ZOOM_dec  ,
["PRESS"] 		= GPS_CRSR_button  ,
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
["WX"] 			= RXP_WX500_POPUP_TOGGLE  ,
["STA"] 		= empty  ,
["WPT"] 		= empty  ,
["ARPT"] 		= empty  ,
["DATA"] 		= empty  ,
["POS"] 		= EFB_MOVING_MAP_toggle  ,
["TERR"] 		= EFB_COLOR_MODE_toggle  ,
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
["TOGA"] 	= Autopilot_TOGA_hold  ,
["TOGN"] 	= Autopilot_TOGA_off  ,
["N1"] 		= Autopilot_N1_hold  ,
["SPD"] 	= Autopilot_IAS_hold  ,
["FLCH"] 	= empty  ,
["HDGSEL"] 	= Autopilot_HDGSEL_hold  ,
["HDGHLD"] 	= Autopilot_HDG_hold  ,
["ALTHLD"] 	= Autopilot_ALT_hold  ,
["V/S FPA"] 	= Autopilot_VS_hold  ,
["APP"] 	= Autopilot_APR_hold  ,
["VNAV"] 	= Autopilot_Attitude_hold  ,
["LNAV"] 	= Autopilot_NAV_hold  ,
["CMDA"] 	= Autopilot_MASTER_toggle  ,
["CMDB"] 	= empty  ,
["CMDC"] 	= empty  ,
["LOC"] 	= Autopilot_LOC_hold  ,
["CWSA"] 	= Autopilot_NAVGPS_toggle  ,
["CWSB"] 	= DSP_MODE_toggle  ,
["A/T UP"] 	= Autopilot_AT_arm  ,
["A/T DN"] 	= Autopilot_AT_disarm  ,
["F/D UP"] 	= Autopilot_FD_on  ,
["F/D DN"] 	= Autopilot_FD_off  ,
["MASTER UP"] 	= Autopilot_MASTER_on  ,
["MASTER DN"] 	= Autopilot_MASTER_off  ,
}


-- MCP CRS knob
CRS1 = {
["A SHOW"]	= CRS_show  ,
["A +"]		= CRS_plus  ,
["A ++"]	= CRS_plusfast  ,
["A -"]		= CRS_minus  ,
["A --"]	= CRS_minusfast  ,
["PRESS"] 	= empty  ,
}


-- MCP SPD knob
SPD1 = {
["A SHOW"]	= SPD_show  ,
["A +"]		= SPD_plus  ,
["A ++"]	= SPD_plusfast  ,
["A -"]		= SPD_minus  ,
["A --"]	= SPD_minusfast  ,
["PRESS"] 	= empty  ,
}


-- MCP HDG knob
HDG1 = {
["A SHOW"]	= HDG_show  ,
["A +"]		= HDG_plus  ,
["A ++"]	= HDG_plusfast  ,
["A -"]		= HDG_minus  ,
["A --"]	= HDG_minusfast  ,
["PRESS"] 	= Autopilot_HDG_Bug_align  ,
}


-- MCP ALT knob
ALT1 = {
["A SHOW"]	= ALT_show  ,
["A +"]		= ALT_plus  ,
["A ++"]	= ALT_plusfast  ,
["A -"]		= ALT_minus  ,
["A --"]	= ALT_minusfast  ,
["PRESS"] 	= Autopilot_ALTSEL_mode  ,
}


-- MCP VVS knob
VVS1 = {
["A SHOW"]	= VVS_show  ,
["A +"]		= VVS_plus  ,
["A ++"]	= VVS_plusfast  ,
["A -"]		= VVS_minus  ,
["A --"]	= VVS_minusfast  ,
["PRESS"] 	= Autopilot_VSSEL_mode  ,
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
["IDENT"]	= "Lght"  ,
["0"] 		= Lights_PANEL_toggle  ,
["1"] 		= Lights_TAXI_toggle  ,
["2"] 		= Lights_NAV_toggle  ,
["3"] 		= Lights_STROBE_toggle  ,
["4"] 		= Lights_BEACON_toggle  ,
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
["IDENT"]	= "DeIc"  ,
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
-- ## USER block mode3
-- ############################################### --

-- USER block buttons and switches
USER3 = {
["ENABLED"]	= true  ,
["IDENT"]	= "Othr"  ,
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

