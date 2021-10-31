-- config-mcp.lua @ 2110300940 (LINDA 3.2.6.1111) --

-- ############################################### --
-- ## EFIS block mode1
-- ############################################### --

-- EFIS block buttons and switches
EFIS1 = {
["ENABLED"]		= true  ,
["IDENT"]		= "EFIS"  ,
["FPV"] 		= EFIS_CPT_FPV  ,
["MTR"] 		= EFIS_CPT_MTRS  ,
["WX"] 			= EFIS_CPT_WXR  ,
["STA"] 		= EFIS_CPT_STA  ,
["WPT"] 		= EFIS_CPT_WPT  ,
["ARPT"] 		= EFIS_CPT_ARPT  ,
["DATA"] 		= EFIS_CPT_DATA  ,
["POS"] 		= EFIS_CPT_POS  ,
["TERR"] 		= EFIS_CPT_TERR  ,
["ADF1"] 		= EFIS_CPT_VOR_ADF_L_adf  ,
["ADF2"] 		= EFIS_CPT_VOR_ADF_R_adf  ,
["VOR1"] 		= EFIS_CPT_VOR_ADF_L_vor  ,
["VOR2"] 		= EFIS_CPT_VOR_ADF_R_vor  ,
}


-- EFIS MINS knob
MINS1 = {
["A SHOW"]		= empty  ,
["A +"]			= EFIS_CPT_MINIMUMS_inc  ,
["A ++"]		= EFIS_CPT_MINIMUMS_inc  ,
["A -"]			= EFIS_CPT_MINIMUMS_dec  ,
["A --"]		= EFIS_CPT_MINIMUMS_dec  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
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
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS CTR knob
CTR1 = {
["A SHOW"]		= EFIS_CPT_MAP_MODE_show  ,
["A +"]			= EFIS_CPT_MAP_MODE_inc  ,
["A ++"]		= EFIS_CPT_MAP_MODE_inc  ,
["A -"]			= EFIS_CPT_MAP_MODE_dec  ,
["A --"]		= EFIS_CPT_MAP_MODE_dec  ,
["PRESS"] 		= empty  ,
["B SHOW"]		= empty  ,
["B +"]			= empty  ,
["B ++"]		= empty  ,
["B -"]			= empty  ,
["B --"]		= empty  ,
}


-- EFIS TFC knob
TFC1 = {
["A SHOW"]		= EFIS_CPT_RANGE_show  ,
["A +"]			= EFIS_CPT_RANGE_inc  ,
["A ++"]		= EFIS_CPT_RANGE_inc  ,
["A -"]			= EFIS_CPT_RANGE_dec  ,
["A --"]		= EFIS_CPT_RANGE_dec  ,
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
["IDENT"]		= "WXR"  ,
["FPV"] 		= TCAS_ALTSOURCE_toggle  ,
["MTR"] 		= TCAS_IDENT  ,
["WX"] 			= WXR_L_TFR  ,
["STA"] 		= WXR_L_WX  ,
["WPT"] 		= WXR_L_WX_T  ,
["ARPT"] 		= WXR_L_MAP  ,
["DATA"] 		= WXR_L_GC  ,
["POS"] 		= WXR_AUTO  ,
["TERR"] 		= empty  ,
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
["A +"]			= WXR_L_TILT_CONTROL_inc  ,
["A ++"]		= WXR_L_TILT_CONTROL_inc  ,
["A -"]			= WXR_L_TILT_CONTROL_dec  ,
["A --"]		= WXR_L_TILT_CONTROL_dec  ,
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
["A +"]			= WXR_L_GAIN_CONTROL_inc  ,
["A ++"]		= WXR_L_GAIN_CONTROL_inc  ,
["A -"]			= WXR_L_GAIN_CONTROL_dec  ,
["A --"]		= WXR_L_GAIN_CONTROL_dec  ,
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
["IDENT"]		= "PFD"  ,
["FPV"] 		= PMDG_Disp_Eng  ,
["MTR"] 		= PMDG_Disp_Stat  ,
["WX"] 			= PMDG_Disp_Elec  ,
["STA"] 		= PMDG_Disp_Hyd  ,
["WPT"] 		= PMDG_Disp_Fuel  ,
["ARPT"] 		= PMDG_Disp_Air  ,
["DATA"] 		= PMDG_Disp_Door  ,
["POS"] 		= PMDG_Disp_Gear  ,
["TERR"] 		= PMDG_Disp_Fctl  ,
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
["IDENT"]	= "AP"  ,
["TOGA"] 	= PMDG_AP_TOGA  ,
["TOGN"] 	= empty  ,
["N1"] 		= PMDG_CLB_CON  ,
["SPD"] 	= PMDG_AT  ,
["FLCH"] 	= PMDG_FLCH  ,
["HDGSEL"] 	= empty  ,
["HDGHLD"] 	= PMDG_HDG_HOLD  ,
["ALTHLD"] 	= PMDG_ALT_HOLD  ,
["V/S FPA"] 	= PMDG_VS_FPA  ,
["APP"] 	= PMDG_APP  ,
["VNAV"] 	= PMDG_VNAV  ,
["LNAV"] 	= PMDG_LNAV  ,
["CMDA"] 	= PMDG_AP_L  ,
["CMDB"] 	= PMDG_AP_R  ,
["CMDC"] 	= PMDG_MasterWarn_Capt  ,
["LOC"] 	= PMDG_LOC  ,
["CWSA"] 	= Do_nothing  ,
["CWSB"] 	= DSP_MODE_toggle  ,
["A/T UP"] 	= PMDG_AP_both_AT_on  ,
["A/T DN"] 	= PMDG_AP_both_AT_toggle  ,
["F/D UP"] 	= PMDG_AP_both_FD_on  ,
["F/D DN"] 	= PMDG_AP_both_FD_off  ,
["MASTER UP"] 	= PMDG_AP_Disengage_Bar_on  ,
["MASTER DN"] 	= PMDG_AP_Disengage_Bar_off  ,
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
["A +"]		= PMDG_AP_SPD_inc  ,
["A ++"]	= PMDG_AP_SPD_incfast  ,
["A -"]		= PMDG_AP_SPD_dec  ,
["A --"]	= PMDG_AP_SPD_decfast  ,
["PRESS"] 	= PMDG_Push_SPD  ,
}


-- MCP HDG knob
HDG1 = {
["A SHOW"]	= HDG_show  ,
["A +"]		= PMDG_AP_HDG_inc  ,
["A ++"]	= PMDG_AP_HDG_incfast  ,
["A -"]		= PMDG_AP_HDG_dec  ,
["A --"]	= PMDG_AP_HDG_decfast  ,
["PRESS"] 	= PMDG_Push_HDG  ,
}


-- MCP ALT knob
ALT1 = {
["A SHOW"]	= ALT_show  ,
["A +"]		= PMDG_AP_ALT_inc  ,
["A ++"]	= PMDG_AP_ALT_incfast  ,
["A -"]		= PMDG_AP_ALT_dec  ,
["A --"]	= PMDG_AP_ALT_decfast  ,
["PRESS"] 	= PMDG_Push_ALT  ,
}


-- MCP VVS knob
VVS1 = {
["A SHOW"]	= VVS_show  ,
["A +"]		= PMDG_AP_VS_inc  ,
["A ++"]	= PMDG_AP_VS_inc  ,
["A -"]		= PMDG_AP_VS_dec  ,
["A --"]	= PMDG_AP_VS_dec  ,
["PRESS"] 	= PMDG_AP_VS_show  ,
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
["A +"]		= PMDG_AP_CRS_LR_inc  ,
["A ++"]	= PMDG_AP_CRS_LR_incfast  ,
["A -"]		= PMDG_AP_CRS_LR_dec  ,
["A --"]	= PMDG_AP_CRS_LR_decfast  ,
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
["ENABLED"]	= true  ,
["IDENT"]	= "Dspl"  ,
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
["A +"]		= PANEL_LIGHT_CONTROL_inc  ,
["A ++"]	= PANEL_LIGHT_CONTROL_incfast  ,
["A -"]		= PANEL_LIGHT_CONTROL_dec  ,
["A --"]	= PANEL_LIGHT_CONTROL_decfast  ,
["PRESS"] 	= empty  ,
}


-- MCP HDG knob
HDG3 = {
["A SHOW"]	= empty  ,
["A +"]		= PED_FLOOD_LIGHT_CONTROL_inc  ,
["A ++"]	= PED_FLOOD_LIGHT_CONTROL_incfast  ,
["A -"]		= PED_FLOOD_LIGHT_CONTROL_dec  ,
["A --"]	= PED_FLOOD_LIGHT_CONTROL_decfast  ,
["PRESS"] 	= empty  ,
}


-- MCP ALT knob
ALT3 = {
["A SHOW"]	= empty  ,
["A +"]		= ALL_PANEL_FLOOD_LIGHTS_inc  ,
["A ++"]	= GS_LIGHT_CONTROL_incfast  ,
["A -"]		= GS_LIGHT_CONTROL_dec  ,
["A --"]	= GS_LIGHT_CONTROL_decfast  ,
["PRESS"] 	= empty  ,
}


-- MCP VVS knob
VVS3 = {
["A SHOW"]	= empty  ,
["A +"]		= ALL_PANEL_FLOOD_LIGHTS_inc  ,
["A ++"]	= ALL_PANEL_FLOOD_LIGHTS_incfast  ,
["A -"]		= ALL_PANEL_FLOOD_LIGHTS_dec  ,
["A --"]	= ALL_PANEL_FLOOD_LIGHTS_decfast  ,
["PRESS"] 	= empty  ,
}


-- ############################################### --
-- ## USER block mode1
-- ############################################### --

-- USER block buttons and switches
USER1 = {
["ENABLED"]	= true  ,
["IDENT"]	= "Lght"  ,
["0"] 		= LANDING_LIGHTS_toggle  ,
["1"] 		= PMDG_Taxi_toggle  ,
["2"] 		= PMDG_Strobe_toggle  ,
["3"] 		= PMDG_BCN_toggle  ,
["4"] 		= PMDG_NAV_toggle  ,
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
["IDENT"]	= "USR2"  ,
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

