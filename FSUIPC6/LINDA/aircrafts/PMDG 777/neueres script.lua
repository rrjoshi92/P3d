



 

 
 -- ## Overhead - Hydraulic
function DEMAND_ELEC1_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +35, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function DEMAND_ELEC1_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +35, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function DEMAND_ELEC1_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +35, 1)
	DspShow (" ", "on", " ", "on")
	end
end



function AIR1_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +36, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function AIR1_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +36, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function AIR1_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +36, 1)
	DspShow (" ", "on", " ", "on")
	end
end



function AIR2_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +37, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function AIR2_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +37, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function AIR2_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +37, 1)
	DspShow (" ", "on", " ", "on")
	end
end


function DEMAND_ELEC2_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +38, 1)
	DspShow (" ", "on", " ", "on")
end

function DEMAND_ELEC2_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +38, 1)
	DspShow (" ", "on", " ", "on")
end

function DEMAND_ELEC2_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +38, 1)
	DspShow (" ", "on", " ", "on")
end


function ENG1_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +39, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ENG1_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +39, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ENG1_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +39, 1)
	DspShow (" ", "on", " ", "on")
	end
end



function ELEC1_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +40, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ELEC1_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +40, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ELEC1_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +40, 1)
	DspShow (" ", "on", " ", "on")
	end
end



function ELEC2_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +41, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ELEC2_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +41, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ELEC2_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +41, 1)
	DspShow (" ", "on", " ", "on")
	end
end



function ENG2_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +42, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ENG2_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +42, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ENG2_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +42, 1)
	DspShow (" ", "on", " ", "on")
	end
end



function RAM_AIR_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +43, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function RAM_AIR_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +43, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function RAM_AIR_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +43, 1)
	DspShow (" ", "on", " ", "on")
	end
end


function RAM_AIR_COVER_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +44, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function RAM_AIR_COVER_off ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +44, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function RAM_AIR_COVER_toggle ()
	if ipc.readLvar("switch_02_a") > 0 then
	ipc.control(PMDGBaseVariable +44, 1)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 
 
 -- ## Overhead - Electric  
function BATTERY_SWITCH_on ()
    if ipc.readLvar("switch_01_a") == 0 then
    ipc.control(PMDGBaseVariable + 1, 1)
    DspShow ("BATT", "on")
	end
end

function BATTERY_SWITCH_off ()
    if ipc.readLvar("switch_01_a") > 0 then
    ipc.control(PMDGBaseVariable + 1, 0)
    DspShow ("BATT", "off")
	end
end

function BATTERY_SWITCH_toggle ()
	if _tl("switch_01_a", 0) then
       BATTERY_SWITCH_on ()
	else
       BATTERY_SWITCH_off ()
	end
end
    

function APU_GEN_SWITCH_on ()
    if ipc.readLvar("switch_02_a") == 0 then
    ipc.control(PMDGBaseVariable + 2, 1)
	DspShow ("ApuG", "on", "APU GEN ", "on")
	end
end

function APU_GEN_SWITCH_off ()
    if ipc.readLvar("switch_02_a") > 0 then
    ipc.control(PMDGBaseVariable + 2, 0)
	DspShow ("ApuG", "off", "APU GEN ", "off")
	end
end

function APU_GEN_SWITCH_toggle ()
	if _tl("switch_02_a", 0) then
       APU_GEN_SWITCH_on ()
	else
       APU_GEN_SWITCH_off ()
	end
end



function APU_SEL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 3, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function BUS_TIE1_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 5, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function BUS_TIE2_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 6, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function GRD_PWR_SEC_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 7, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function GRD_PWR_PRIM_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 8, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function GEN1_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 9, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function GEN2_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function BACKUP_GEN1_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function BACKUP_GEN2_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function DISCONNECT1_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 1)	DspShow (" ", "on", " ", "on")
	end
end


function DISCONNECT1_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1)	DspShow (" ", "on", " ", "on")
	end
end


function DISCONNECT2_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +15, 1)	DspShow (" ", "on", " ", "on")
	end
end


function DISCONNECT2_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 1)	DspShow (" ", "on", " ", "on")
	end
end


function IFE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function CAB_UTIL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 1)	DspShow (" ", "on", " ", "on")
	end
end


function STBY_PWR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +81, 1)
	DspShow (" ", "on", " ", "on")
	end
end
    
function STBY_PWR_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +82, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function TOWING_PWR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +15, 10)
	DspShow (" ", "on", " ", "on")
	end
end
    
function TOWING_PWR_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +15, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function GND_TEST_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +15, 12)
	DspShow (" ", "on", " ", "on")
	end
end
    
function GND_TEST_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +15, 13)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 
 
 -- ## Overhead - FUEL Panel
function JETTISON_NOZZLE_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +97, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function JETTISON_NOZZLE_L_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +98, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function JETTISON_NOZZLE_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +99, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function JETTISON_NOZZLE_R_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function TO_REMAIN_ROTATE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function TO_REMAIN_PULL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 1100)
	DspShow (" ", "on", " ", "on")
	end
end


function JETTISON_ARM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function PUMP_1_FORWARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function PUMP_2_FORWARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function PUMP_1_AFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function PUMP_2_AFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function CROSSFEED_FORWARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function CROSSFEED_AFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function PUMP_L_CENTER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function PUMP_R_CENTER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 10)	DspShow (" ", "on", " ", "on")
	end
end

function PUMP_AUX ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 137)	DspShow (" ", "on", " ", "on")
	end
end




 
 
 
 
 
 -- ## Overhead Air
function ENG_1_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function ENG_2_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function APU_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function ISOLATION_VALVE_SWITCH_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function ISOLATION_VALVE_SWITCH_C ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function ISOLATION_VALVE_SWITCH_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_PACK_SWITCH_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_PACK_SWITCH_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TRIM_AIR_SWITCH_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 17)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TRIM_AIR_SWITCH_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 18)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TEMP_SELECTOR_FLT_DECK ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +13, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TEMP_SELECTOR_CABIN ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_RESET_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_RECIRC_FAN_UPP_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_RECIRC_FAN_LWR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_EQUIP_COOLING_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_GASPER_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 15)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TEMP_SELECTOR_CARGO_AFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 18)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TEMP_SELECTOR_CARGO_BULK ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 19)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TEMP_SELECTOR_LWR_CARGO_FWD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 150)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TEMP_SELECTOR_LWR_CARGO_AFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 151)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_RECIRC_FANS_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 152)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TEMP_SELECTOR_MAIN_CARGO_FWD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 154)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_TEMP_SELECTOR_MAIN_CARGO_AFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 155)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_MAIN_DECK_FLOW_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 153)	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_ALT_VENT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 157)
	DspShow (" ", "on", " ", "on")
	end
end

function AIRCOND_ALT_VENT_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 111)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 
 
 -- ## Overhead - Cabin Press
function PRESS_VALVE_SWITCH_MANUAL_1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 14)	DspShow (" ", "on", " ", "on")
	end
end

function PRESS_VALVE_SWITCH_MANUAL_2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 15)	DspShow (" ", "on", " ", "on")
	end
end

function PRESS_LAND_ALT_KNOB_ROTATE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 16)  	DspShow (" ", "on", " ", "on")
	end
end

function PRESS_LAND_ALT_KNOB_PULL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 1600)  --12, 16B	DspShow (" ", "on", " ", "on")
	end
end

function PRESS_VALVE_SWITCH_1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 17)  	DspShow (" ", "on", " ", "on")
	end
end

function PRESS_VALVE_SWITCH_2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 18)  	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Overhead - ANTI-ICE
function WINDOW_HEAT_1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +45, 1)

	DspShow (" ", "on", " ", "on")
	end
end

function WINDOW_HEAT_2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +46, 1)

	DspShow (" ", "on", " ", "on")
	end
end

function WINDOW_HEAT_3 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +47, 1)

	DspShow (" ", "on", " ", "on")
	end
end

function WINDOW_HEAT_4 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +48, 1)

	DspShow (" ", "on", " ", "on")
	end
end

function BU_WINDOW_HEAT_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function BU_WINDOW_HEAT_L_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +78, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function BU_WINDOW_HEAT_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function BU_WINDOW_HEAT_R_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +80, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function WING_ANTIICE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function ENGINE_ANTIICE_1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function ENGINE_ANTIICE_2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 13)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Overhead Lights Panel
function LANDING_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function LANDING_NOSE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function LANDING_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function STORM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function BEACON ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function NAV ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 15)	DspShow (" ", "on", " ", "on")
	end
end

function LOGO ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function WING ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function IND_LTS_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 18)	DspShow (" ", "on", " ", "on")
	end
end

function L_TURNOFF ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function R_TURNOFF ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function TAXI ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function STROBE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function NO_SMOKING_LIGHT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function FASTEN_BELTS_LIGHT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +30, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function PANEL_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function CB_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 101)  
	DspShow (" ", "on", " ", "on")
	end
end

function GS_PANEL_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function GS_FLOOD_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 101)
	DspShow (" ", "on", " ", "on")
	end
end

function DOME_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 1)	DspShow (" ", "on", " ", "on")
	end
end

function MASTER_BRIGHT_ROTATE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function MASTER_BRIGHT_PUSH ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 101)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Overhead - APU & Cargo Fire Panel
function CARGO_ARM_FWD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 85, 1)	DspShow (" ", "on", " ", "on")
	end
end

function CARGO_ARM_AFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 86, 1)	DspShow (" ", "on", " ", "on")
	end
end

function CARGO_DISCH ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 87, 1)	DspShow (" ", "on", " ", "on")
	end
end

function CARGO_DISCH_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 88, 1)	DspShow (" ", "on", " ", "on")
	end
end

function OVHT_TEST ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 89, 1)	DspShow (" ", "on", " ", "on")
	end
end

function HANDLE_APU_TOP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 84, 1)	DspShow (" ", "on", " ", "on")
	end
end

function HANDLE_APU_BOTTOM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 84, 101)	DspShow (" ", "on", " ", "on")
	end
end

function UNLOCK_SWITCH_APU ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 84, 102)	DspShow (" ", "on", " ", "on")
	end
end

function CARGO_ARM_MAIN_DECK ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 10, 174)	DspShow (" ", "on", " ", "on")
	end
end

function CARGO_DISCH_DEPR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 10, 175)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Overhead - Engine control
function L_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +90, 1)	DspShow (" ", "on", " ", "on")
	end
end

function L_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +91, 1)	DspShow (" ", "on", " ", "on")
	end
end

function R_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +92, 1)	DspShow (" ", "on", " ", "on")
	end
end

function R_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +93, 1)	DspShow (" ", "on", " ", "on")
	end
end

function ENGINE_L_START ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +94, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ENGINE_R_START ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +95, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function ENGINE_AUTOSTART ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +96, 1)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Overhead - Miscellaneous
function CAMERA_LTS_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function WIPER_LEFT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function EMER_EXIT_LIGHT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function EMER_EXIT_LIGHT_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function SERVICE_INTERPHONE_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +51, 1)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_PASS_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +52, 1)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_PASS_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 1)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_SUPRNMRY_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 176) 	DspShow (" ", "on", " ", "on")
	end
end

function OXY_SUPRNMRY_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 177) 	DspShow (" ", "on", " ", "on")
	end
end

function THRUST_ASYM_COMP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +54, 1)	DspShow (" ", "on", " ", "on")
	end
end

function PRIM_FLT_COMPUTERS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 1)	DspShow (" ", "on", " ", "on")
	end
end

function PRIM_FLT_COMPUTERS_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +56, 1)	DspShow (" ", "on", " ", "on")
	end
end

function ADIRU_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +59, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_WING_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_WING_L_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +61, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_WING_C ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +63, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_WING_C_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +64, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_WING_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +66, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_WING_R_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +67, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_TAIL_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +69, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_TAIL_L_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +70, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_TAIL_C ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +71, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_TAIL_C_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +72, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_TAIL_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 1)	DspShow (" ", "on", " ", "on")
	end
end

function VLV_PWR_TAIL_R_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +75, 1)	DspShow (" ", "on", " ", "on")
	end
end

function WIPER_RIGHT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +12, 13)	DspShow (" ", "on", " ", "on")
	end
end

function CVR_TEST ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +15, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function CVR_ERASE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +15, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function APU_TEST_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +15, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function APU_TEST_SWITCH_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function TEST_L_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function TEST_L_SWITCH_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function TEST_R_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function TEST_R_SWITCH_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function GPWS_RWY_OVRD_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 109)
	DspShow (" ", "on", " ", "on")
	end
end

function GPWS_RWY_OVRD_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 110)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - Instrument Source Select
function FWD_NAV_SOURCE_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_DSPL_CTRL_SOURCE_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_AIR_DATA_ATT_SOURCE_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_NAV_SOURCE_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_DSPL_CTRL_SOURCE_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_AIR_DATA_ATT_SOURCE_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 18)	DspShow (" ", "on", " ", "on")
	end
end

function FWD_FMC_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 11)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - Display Selectors
function DSP_INDB_DSPL_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +31, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_INDB_DSPL_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 10)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - Heading Reference
function EFIS_HDG_REF_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +31, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_HDG_REF_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +31, 14)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - Gear
function Gear_down ()
	if ipc.readLvar("switch_02_a") == 0 then

    ipc.writeLvar("switch_295_a",10, 10)
    ipc.control(66080)
    ipc.sleep(50)
    ipc.writeUW("0BE8",16, 1383)

    DspShow ("Gear", "dn")	DspShow (" ", "on", " ", "on")
	end
end

function Gear_up ()
	if ipc.readLvar("switch_02_a") == 0 then

    ipc.writeLvar("switch_295_a", 0)
    ipc.control(66079)
    ipc.sleep(50)
    ipc.writeUW("0BE8", 0)


    DspShow ("Gear", "up")	DspShow (" ", "on", " ", "on")
	end
end

function GEAR_LEVER_up ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 15, 1)
    DspShow ("Gear", "up")	DspShow (" ", "on", " ", "on")
	end
end

function GEAR_LEVER_down ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 15, 0)
    DspShow ("Gear", "down")	DspShow (" ", "on", " ", "on")
	end
end

function GEAR_LEVER_UNLOCK ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 16)	DspShow (" ", "on", " ", "on")
	end
end

function GEAR_ALTN_GEAR_DOWN ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 13)	DspShow (" ", "on", " ", "on")
	end
end

function GEAR_ALTN_GEAR_DOWN_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 14)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - GPWS
function GPWS_TERR_OVRD_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function GPWS_TERR_OVRD_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function GPWS_GEAR_OVRD_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function GPWS_GEAR_OVRD_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +30, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function GPWS_FLAP_OVRD_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +30, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function GPWS_FLAP_OVRD_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +30, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function GPWS_GS_INHIBIT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +30, 13)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - Autobrakes
function ABS_AUTOBRAKE_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +29, 12)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - ISFD
function ISFD_APP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +81, 10)
	DspShow (" ", "on", " ", "on")
	end
end
 

function ISFD_HP_IN ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +81, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function ISFD_PLUS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +81, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function ISFD_MINUS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +81, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function ISFD_ATT_RST ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +81, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function ISFD_BARO ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +81, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function ISFD_BARO_PUSH ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +81, 16)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - non-ISFD standby instruments
function STANDBY_ASI_KNOB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 158)
	DspShow (" ", "on", " ", "on")
	end
end

function STANDBY_ASI_KNOB_PUSH ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 159)
	DspShow (" ", "on", " ", "on")
	end
end

function STANDBY_ALTIMETER_KNOB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 160)
	DspShow (" ", "on", " ", "on")
	end
end

function STANDBY_ALTIMETER_KNOB_PUSH ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 161)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - Chronometers
function CHRONO_L_CHR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function CHRONO_L_TIME_DATE_SELECT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function CHRONO_L_TIME_DATE_PUSH ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 121)
	DspShow (" ", "on", " ", "on")
	end
end

function CHRONO_L_ET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function CHRONO_L_SET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function CHRONO_R_CHR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function CHRONO_R_TIME_DATE_SELECT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function CHRONO_R_TIME_DATE_PUSH ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 102) --28, 101 is in use
	DspShow (" ", "on", " ", "on")
	end
end

function CHRONO_R_ET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function CHRONO_R_SET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 12)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - Left Sidewall
function FWD_LEFT_SHOULDER_HEATER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +31, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_LEFT_FOOT_HEATER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +31, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_LEFT_OUTBD_BRIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +32, 10)	DspShow (" ", "on", " ", "on")
	end
end

function FWD_LEFT_INBD_BRIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +32, 11)	DspShow (" ", "on", " ", "on")
	end
end

function FWD_LEFT_INBD_TERR_BRIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +32, 110)	DspShow (" ", "on", " ", "on")
	end
end

function FWD_LEFT_PANEL_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +32, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_LEFT_FLOOD_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +32, 120)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Forward Panel - Right Sidewall
function FWD_RIGHT_FOOT_HEATER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_RIGHT_SHOULDER_HEATER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_RIGHT_PANEL_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_RIGHT_FLOOD_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 150)
	DspShow (" ", "on", " ", "on")
	end
end

function FWD_RIGHT_INBD_BRIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 16)	DspShow (" ", "on", " ", "on")
	end
end

function FWD_RIGHT_INBD_TERR_BRIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 160)	DspShow (" ", "on", " ", "on")
	end
end

function FWD_RIGHT_OUTBD_BRIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +28, 17)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Glareshield - EFIS Captain control panel
function EFIS_CPT_MINIMUMS_RADIO_BARO ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 11)
	DspShow (" ", "on", " ", "on")
	end
end

--function EFIS_CPT_FIRST ()
	if ipc.readLvar("switch_02_a") == 0 then
--	ipc.control(PMDGBaseVariable +18, 12)
--end

--function EFIS_CPT_MINIMUMS_RADIO_BARO ()
	if ipc.readLvar("switch_02_a") == 0 then
--	ipc.control(PMDGBaseVariable +18, 12)
--end

function EFIS_CPT_MINIMUMS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_MINIMUMS_RST ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_VOR_ADF_SELECTOR_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_MODE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_MODE_CTR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_RANGE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_RANGE_TFC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_VOR_ADF_SELECTOR_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_BARO_IN_HPA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_BARO ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_BARO_STD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_FPV ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_MTRS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_WXR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_STA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_WPT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_ARPT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_DATA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +19, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_POS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_CPT_TERR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 11)
	DspShow (" ", "on", " ", "on")
	end
end




 
 
 
 -- ## Glareshield - EFIS F/O control panels
function EFIS_FO_MINIMUMS_RADIO_BARO ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 18)	DspShow (" ", "on", " ", "on")
	end
end


function EFIS_FO_MINIMUMS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 19)	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_MINIMUMS_RST ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_VOR_ADF_SELECTOR_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_MODE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_MODE_CTR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_RANGE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_RANGE_TFC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_VOR_ADF_SELECTOR_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_BARO_IN_HPA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_BARO ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_BARO_STD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +25, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_FPV ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_MTRS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_WXR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_STA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_WPT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_ARPT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_DATA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 161) 	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_POS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function EFIS_FO_TERR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 18)
	DspShow (" ", "on", " ", "on")
	end
end




 
 
 
 -- ## Glareshield - MCP
function MCP_FD_SWITCH_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_AP_L_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 13)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_AT_ARM_SWITCH_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_AT_ARM_SWITCH_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_CLB_CON_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_AT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_IAS_MACH_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +20, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_SPEED_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 10)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_SPEED_PUSH_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 100)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_LNAV_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 11)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_VNAV_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_LVL_CHG_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_DISENGAGE_BAR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 14)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_HDG_TRK_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 16)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_HEADING_PUSH_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_HEADING_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 180)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_BANK_ANGLE_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 181)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_HDG_HOLD_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +21, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_VS_FPA_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_VS_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 12)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_VS_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_ALTITUDE_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 150)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_ALTITUDE_PUSH_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 151)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_ALT_INCR_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_ALT_HOLD_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_LOC_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_APP_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_AP_R_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 19)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_FD_SWITCH_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 10)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_TOGA_SCREW_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 101)	DspShow (" ", "on", " ", "on")
	end
end

function MCP_TOGA_SCREW_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 102)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Glareshield - Display Select Panel
function DSP_L_INBD_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_R_INBD_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_LWR_CTR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_ENG_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_STAT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_ELEC_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_HYD_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_FUEL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_AIR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_DOOR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_GEAR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_FCTL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_CAM_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_CHKL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_COMM_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_NAV_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function DSP_CANC_RCL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 17)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Glareshield - Master Warning/caution
function MASTER_WARNING_RESET_LEFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 17)	DspShow (" ", "on", " ", "on")
	end
end

function MASTER_WARNING_RESET_RIGHT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 12)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Glareshield - Data Link Switches
function DATA_LINK_ACPT_LEFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 18)	DspShow (" ", "on", " ", "on")
	end
end

function DATA_LINK_CANC_LEFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +17, 19)	DspShow (" ", "on", " ", "on")
	end
end

function DATA_LINK_RJCT_LEFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +18, 10)	DspShow (" ", "on", " ", "on")
	end
end

function DATA_LINK_ACPT_RIGHT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +26, 19)	DspShow (" ", "on", " ", "on")
	end
end

function DATA_LINK_CANC_RIGHT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 10)	DspShow (" ", "on", " ", "on")
	end
end

function DATA_LINK_RJCT_RIGHT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 11)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Glareshield - Map/Chart/Worktable Lights, MIC & Clock Switches
function CLOCK_L ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +16, 15)	DspShow (" ", "on", " ", "on")
	end
end

function MAP_LIGHT_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function GLARESHIELD_MIC_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +16, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function GLARESHIELD_MIC_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 13)	DspShow (" ", "on", " ", "on")
	end
end

function MAP_LIGHT_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function CLOCK_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +27, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function CHART_LIGHT_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 107)
	DspShow (" ", "on", " ", "on")
	end
end

function CHART_LIGHT_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 108)
	DspShow (" ", "on", " ", "on")
	end
end

function WORKTABLE_LIGHT_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 105)
	DspShow (" ", "on", " ", "on")
	end
end

function WORKTABLE_LIGHT_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 106)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Pedestal - Fwd Aisle Stand - CDUs
function CDU_L_L1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 32, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_L2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 32, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_L3 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_L4 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_L5 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_L6 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_R1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_R2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_R3 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_R4 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_R5 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_R6 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 33, 19)	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_INIT_REF ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_RTE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_DEP_ARR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_ALTN ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_VNAV ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_FIX ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_LEGS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_HOLD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_FMCCOMM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 171)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_PROG ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_EXEC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 34, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_MENU ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 35, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_NAV_RAD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 35, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_PREV_PAGE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 35, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_NEXT_PAGE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 35, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_1 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 35, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_2 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 35, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_3 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 35, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_4 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 35, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_5 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 35, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_6 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 35, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_7 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 36, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_8 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 36, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_9 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 36, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_DOT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 36, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_0 ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 36, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_PLUS_MINUS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 36, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_A ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 36, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_B ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 36, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_C ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 36, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_D ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 36, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_E ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_F ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_G ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_H ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_I ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_J ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_K ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_L ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_M ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_N ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 37, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_O ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_P ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_Q ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_R ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_S ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_T ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_U ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_V ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_W ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_X ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 38, 19)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_Y ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 39, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_Z ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable + 39, 11)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_SPACE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 39, 12)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_DEL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 39, 13)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_SLASH ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 39, 14)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_CLR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 39, 15)
	DspShow (" ", "on", " ", "on")
	end
end

function CDU_L_BRITENESS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable + 40, 10)
	DspShow (" ", "on", " ", "on")
	end
end


function CDU_R_L1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +40, 11)
	DspShow (" ", "on", " ", "on")
	end
end




 
 
 
 -- ## Pedestal - Fwd Aisle Stand
function PED_DSPL_CTRL_SOURCE_C ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +47, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function PED_EICAS_EVENT_RCD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +47, 19)	DspShow (" ", "on", " ", "on")
	end
end

function PED_UPPER_BRIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +48, 10)	DspShow (" ", "on", " ", "on")
	end
end

function PED_LOWER_BRIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +48, 11)	DspShow (" ", "on", " ", "on")
	end
end

function PED_LOWER_TERR_BRIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +48, 111)	DspShow (" ", "on", " ", "on")
	end
end

function PED_L_CCD_SIDE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +48, 12)	DspShow (" ", "on", " ", "on")
	end
end

function PED_L_CCD_INBD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +48, 13)	DspShow (" ", "on", " ", "on")
	end
end

function PED_L_CCD_LWR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +48, 14)	DspShow (" ", "on", " ", "on")
	end
end

function PED_R_CCD_LWR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +48, 19)	DspShow (" ", "on", " ", "on")
	end
end

function PED_R_CCD_INBD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 10)	DspShow (" ", "on", " ", "on")
	end
end

function PED_R_CCD_SIDE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 11)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Pedestal - Control Stand - Fire protection panel
function FIRE_HANDLE_ENGINE_1_TOP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +65, 11)	DspShow (" ", "on", " ", "on")
	end
end

function FIRE_HANDLE_ENGINE_1_BOTTOM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +65, 111)	DspShow (" ", "on", " ", "on")
	end
end

function FIRE_HANDLE_ENGINE_2_TOP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +65, 12)	DspShow (" ", "on", " ", "on")
	end
end

function FIRE_HANDLE_ENGINE_2_BOTTOM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +65, 121)	DspShow (" ", "on", " ", "on")
	end
end

function FIRE_UNLOCK_SWITCH_ENGINE_1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +65, 112)	DspShow (" ", "on", " ", "on")
	end
end

function FIRE_UNLOCK_SWITCH_ENGINE_2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +65, 122)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Pedestal - Control Stand - Flaps
function ALTN_FLAPS_ARM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +51, 10)	DspShow (" ", "on", " ", "on")
	end
end

function ALTN_FLAPS_ARM_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +51, 11)	DspShow (" ", "on", " ", "on")
	end
end

function ALTN_FLAPS_POS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +51, 12)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Pedestal - Control Stand - Fuel Control
function CONTROL_STAND_ENG1_START_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +52, 10)
	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_ENG2_START_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +52, 11)
	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Pedestal - Aft Aisle Stand - COMM Panels
function COM1_HF_SENSOR_KNOB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +52, 15)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_TRANSFER_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +52, 16)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_OUTER_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +52, 17)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_INNER_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +52, 18)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_VHFL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +52, 19)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_VHFC_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 10)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_VHFR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 11)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_PNL_OFF_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 12)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_HFL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 13)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_AM_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 14)	DspShow (" ", "on", " ", "on")
	end
end

function COM1_HFR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 15)	DspShow (" ", "on", " ", "on")
	end
end

--function COM1_end_RANGE ()
	if ipc.readLvar("switch_02_a") == 0 then
--	ipc.control(PMDGBaseVariable +79, 12)
--end

--function COM1_HFR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
--	ipc.control(PMDGBaseVariable +79, 12)
--end

function COM2_HFR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 12)	DspShow (" ", "on", " ", "on")
	end
end


function COM2_AM_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 13)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_HFL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 14)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_PNL_OFF_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 15)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_VHFR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 16)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_VHFC_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 17)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_VHFL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 18)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_INNER_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 19)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_OUTER_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +80, 10)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_TRANSFER_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +80, 11)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_HF_SENSOR_KNOB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +80, 12)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_end_RANGE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 12)	DspShow (" ", "on", " ", "on")
	end
end

function COM2_HF_SENSOR_KNOB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 12)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_HF_SENSOR_KNOB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +59, 16)	DspShow (" ", "on", " ", "on")
	end
end

---function COM3_START_RANGE ()
	if ipc.readLvar("switch_02_a") == 0 then
---	ipc.control(PMDGBaseVariable +79, 12)
---end

---function COM3_HF_SENSOR_KNOB ()
	if ipc.readLvar("switch_02_a") == 0 then
---	ipc.control(PMDGBaseVariable +79, 12)
---end

function COM3_TRANSFER_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +59, 17)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_OUTER_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +59, 18)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_INNER_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +59, 19)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_VHFL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 10)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_VHFC_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 11)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_VHFR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 12)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_PNL_OFF_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 13)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_HFL_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 14)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_AM_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 15)	DspShow (" ", "on", " ", "on")
	end
end

function COM3_HFR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 16)	DspShow (" ", "on", " ", "on")
	end
end

--function COM3_end_RANGE ()
	if ipc.readLvar("switch_02_a") == 0 then
--	ipc.control(PMDGBaseVariable +79, 12)
--end

--function EVT_COM3_HFR_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
--	ipc.control(PMDGBaseVariable +79, 12)
--end



 
 
 
 -- ## Pedestal - Aft Aisle Stand - ACP Captain
function ACP_CAPT_MIC_VHFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 16)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_VHFC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 17)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_VHFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 18) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_FLT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +53, 19)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_CAB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +54, 10)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_PA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +54, 11)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_HFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 15) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_HFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 16) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_SAT1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 17) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_SAT2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 18) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_VHFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +54, 18)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_VHFC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +54, 19)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_VHFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 10) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_FLT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 11)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_CAB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 12)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_PA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 13)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_HFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +56, 15) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_HFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +56, 16) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_SAT1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +56, 17) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_SAT2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +56, 18) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_SPKR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +56, 14) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_VORADF ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +57, 11) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_REC_APP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +57, 13) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_MIC_INT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +55, 14)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_FILTER_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +57, 12)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_VOR_ADF_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +56, 19)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_CAPT_APP_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +57, 15)	DspShow (" ", "on", " ", "on")
	end
end




 
 
 
 -- ## Pedestal - Aft Aisle Stand - ACP F/O
function ACP_FO_MIC_VHFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 11)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_VHFC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +79, 10)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_VHFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +78, 19) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_FLT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +78, 18)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_CAB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +78, 17)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_PA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +78, 16)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_HFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 12) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_HFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 11) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_SAT1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 10) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_SAT2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +76, 19) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_VHFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 19)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_VHFC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 18)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_VHFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 17) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_FLT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 16)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_CAB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 15)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_PA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 14)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_HFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +76, 12) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_HFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +76, 11) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_SAT1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +76, 10) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_SAT2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +75, 19) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_SPKR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +76, 13) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_VORADF ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +75, 16) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_REC_APP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +75, 14) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_MIC_INT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +77, 13)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_FILTER_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +75, 15)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_VOR_ADF_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +75, 18)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_FO_APP_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +75, 12)	DspShow (" ", "on", " ", "on")
	end
end




 
 
 
 -- ## Pedestal - Aft Aisle Stand - ACP Observer
function ACP_OBS_MIC_VHFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 17)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_VHFC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 18)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_VHFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +60, 19) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_FLT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +61, 10)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_CAB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +61, 11)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_PA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +61, 12)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_HFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 16) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_HFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 17) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_SAT1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 18) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_SAT2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 19) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_VHFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +61, 19)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_VHFC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 10)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_VHFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 11) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_FLT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 12)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_CAB ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 13)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_PA ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 14)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_HFL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +63, 16) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_HFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +63, 17) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_SAT1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +63, 18) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_SAT2 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +63, 19) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_SPKR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +63, 15) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_VORADF ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +64, 12) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_REC_APP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +64, 14) 	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_MIC_INT_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +62, 15)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_FILTER_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +64, 13)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_VOR_ADF_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +64, 10)	DspShow (" ", "on", " ", "on")
	end
end

function ACP_OBS_APP_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +64, 16)	DspShow (" ", "on", " ", "on")
	end
end




 
 
 
 -- ## Pedestal - Aft Aisle Stand - WX RADAR panel
function WXR_L_TFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +57, 16)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_L_WX ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +57, 17)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_L_WX_T ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +57, 18)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_L_MAP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +57, 19)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_L_GC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +58, 10)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_AUTO ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +58, 13)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_L_R ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +58, 14)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_TEST ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +58, 15)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_R_TFR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +58, 18)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_R_WX ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +58, 19)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_R_WX_T ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +59, 10)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_R_MAP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +59, 11)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_R_GC ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +59, 12)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_L_TILT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +58, 11)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_L_GAIN_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +58, 12)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_R_TILT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +58, 16)	DspShow (" ", "on", " ", "on")
	end
end

function WXR_R_GAIN_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +58, 17)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Pedestal - Aft Aisle Stand - TCAS panel
function TCAS_ALTSOURCE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 13)	DspShow (" ", "on", " ", "on")
	end
end

function TCAS_KNOB_L_OUTER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 14)	DspShow (" ", "on", " ", "on")
	end
end

function TCAS_KNOB_L_INNER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 15)	DspShow (" ", "on", " ", "on")
	end
end

function TCAS_IDENT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 16)	DspShow (" ", "on", " ", "on")
	end
end

function TCAS_KNOB_R_OUTER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 17)	DspShow (" ", "on", " ", "on")
	end
end

function TCAS_KNOB_R_INNER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 18)	DspShow (" ", "on", " ", "on")
	end
end

function TCAS_MODE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 19)	DspShow (" ", "on", " ", "on")
	end
end

function TCAS_TEST ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 191)	DspShow (" ", "on", " ", "on")
	end
end

function TCAS_XPNDR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +75, 11)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Pedestal - Aft Aisle Stand - CALL Panel (Freighter only)
function PED_CALL_GND ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 178)
	DspShow (" ", "on", " ", "on")
	end
end


function PED_CALL_CREW_REST ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 179)
	DspShow (" ", "on", " ", "on")
	end
end

function PED_CALL_SUPRNMRY ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 180)
	DspShow (" ", "on", " ", "on")
	end
end

function PED_CALL_CARGO ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 181)
	DspShow (" ", "on", " ", "on")
	end
end

function PED_CALL_CARGO_AUDIO ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 182)
	DspShow (" ", "on", " ", "on")
	end
end

function PED_CALL_MAIN_DK_ALERT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 183)
	DspShow (" ", "on", " ", "on")
	end
end




 
 
 
 -- ## Pedestal - Aft Aisle Stand - Various
function PED_OBS_AUDIO_SELECTOR ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +64, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function FCTL_AILERON_TRIM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +72, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function FCTL_RUDDER_TRIM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +72, 18)	DspShow (" ", "on", " ", "on")
	end
end

function FCTL_RUDDER_TRIM_CANCEL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +72, 19)	DspShow (" ", "on", " ", "on")
	end
end

function PED_FLOOR_LIGHTS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +73, 15)	DspShow (" ", "on", " ", "on")
	end
end

function PED_PANEL_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +73, 16)	DspShow (" ", "on", " ", "on")
	end
end

function PED_FLOOD_LIGHT_CONTROL ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +73, 17)	DspShow (" ", "on", " ", "on")
	end
end

function PED_EVAC_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +73, 19)	DspShow (" ", "on", " ", "on")
	end
end

function PED_EVAC_SWITCH_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 10)	DspShow (" ", "on", " ", "on")
	end
end

function PED_EVAC_HORN_SHUTOFF ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 11)	DspShow (" ", "on", " ", "on")
	end
end

function PED_EVAC_TEST_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +74, 12)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Pedestal - Control Stand

function CONTROL_STAND_SPEED_BRAKE_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_SPEED_BRAKE_LEVER_DOWN ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 181)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_SPEED_BRAKE_LEVER_ARM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 182)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_SPEED_BRAKE_LEVER_UP ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 183)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_SPEED_BRAKE_LEVER_50 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 184)	DspShow (" ", "on", " ", "on")
	end
end


function CONTROL_STAND_FLAPS_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_FLAPS_LEVER_0 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 171)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_FLAPS_LEVER_1 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 172)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_FLAPS_LEVER_5 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 173)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_FLAPS_LEVER_15 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 174)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_FLAPS_LEVER_20 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 175)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_FLAPS_LEVER_25 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 176)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_FLAPS_LEVER_30 ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 177)	DspShow (" ", "on", " ", "on")
	end
end


function CONTROL_STAND_ALT_PITCH_TRIM_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 16)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_REV_THRUST1_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +49, 19)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_REV_THRUST2_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 13)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_FWD_THRUST1_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 11)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_FWD_THRUST2_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 15)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_AT1_DISENGAGE_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 12)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_AT2_DISENGAGE_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 16)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_TOGA1_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 10)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_TOGA2_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 14)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_PARK_BRAKE_LEVER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +51, 15)	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_STABCUTOUT_SWITCH_C_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +51, 16)
	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_STABCUTOUT_SWITCH_C ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +51, 17)
	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_STABCUTOUT_SWITCH_R_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +51, 18)
	DspShow (" ", "on", " ", "on")
	end
end

function CONTROL_STAND_STABCUTOUT_SWITCH_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +51, 19)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## Oxygen Panels

function OXY_TEST_RESET_SWITCH_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 163)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_TEST_RESET_SWITCH_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 166)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_TEST_RESET_SWITCH_OBS_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 169)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_TEST_RESET_SWITCH_OBS_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 172)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_NORM_EMER_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 164)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_NORM_EMER_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 167)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_NORM_EMER_OBS_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 170)	DspShow (" ", "on", " ", "on")
	end
end

function OXY_NORM_EMER_OBS_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 173)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## miscellaneous

function YOKE_AP_DISC_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +10, 184)	DspShow (" ", "on", " ", "on")
	end
end

function CLICKSPOT_ISFD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 101)	DspShow (" ", "on", " ", "on")
	end
end

function CLICKSPOT_STBY_ADI ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 102)	DspShow (" ", "on", " ", "on")
	end
end

function CLICKSPOT_STBY_ASI ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 103)	DspShow (" ", "on", " ", "on")
	end
end

function CLICKSPOT_STBY_ALTIMETER ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 104)	DspShow (" ", "on", " ", "on")
	end
end

function CLICKSPOT_GMCS_ZOOM ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +11, 112)	DspShow (" ", "on", " ", "on")
	end
end




 
 
 
 -- ## Custom shortcut special events

function LDG_LIGHTS_TOGGLE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1000)	DspShow (" ", "on", " ", "on")
	end
end

function TURNOFF_LIGHTS_TOGGLE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1001)	DspShow (" ", "on", " ", "on")
	end
end

function COCKPIT_LIGHTS_TOGGLE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1002)	DspShow (" ", "on", " ", "on")
	end
end

function PANEL_LIGHTS_TOGGLE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1003)	DspShow (" ", "on", " ", "on")
	end
end

function FLOOD_LIGHTS_TOGGLE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1004)	DspShow (" ", "on", " ", "on")
	end
end


function DOOR_1L ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +14, 1011)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_1R ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +14, 1012)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_2L ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +14, 1013)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_2R ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +14, 1014)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_3L ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +14, 1015)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_3R ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +14, 1016)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_4L ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +14, 1017)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_4R ()
	if ipc.readLvar("switch_02_a") == 0 then

	ipc.control(PMDGBaseVariable +14, 1018)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_OVERWING_EXIT_L ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1019)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_OVERWING_EXIT_R ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1020)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_CARGO_FWD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1021)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_CARGO_AFT ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1022)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_CARGO_BULK ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1023)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_CARGO_MAIN ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1024)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_FWD_ACCESS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1025)	DspShow (" ", "on", " ", "on")
	end
end

function DOOR_EE_ACCESS ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1026)	DspShow (" ", "on", " ", "on")
	end
end

function AT_ARM_SWITCHES ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1027)	DspShow (" ", "on", " ", "on")
	end
end



 
 
 
 -- ## MCP Direct Control 
function MCP_IAS_SET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1502)
	DspShow (" ", "on", " ", "on")
	end
end
-- Sets MCP IAS, if IAS mode is active
function MCP_MACH_SET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1503)
	DspShow (" ", "on", " ", "on")
	end
end
-- Sets MCP MACH (if active) to parameter*0.01 (e.g. send78, 1 to set M0.78)
function MCP_HDGTRK_SET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1504)
	DspShow (" ", "on", " ", "on")
	end
end
-- Sets new heading  or track, commands the shortest turn
function MCP_ALT_SET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1505)
	DspShow (" ", "on", " ", "on")
	end
end

function MCP_VS_SET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1506)
	DspShow (" ", "on", " ", "on")
	end
end
-- Sets MCP VS (if VS window open) to parameter-10000 (e.g. send82, 100 for -1800fpm)
function MCP_FPA_SET ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1507)
	DspShow (" ", "on", " ", "on")
	end
end
-- Sets MCP FPA (if VS window open) to (parameter*0.1-10) (e.g. send82, 1 for -1.8 degrees)


 
 
 
 -- ## Panel system events
function CTRL_ACCELERATION_DISABLE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1600)	DspShow (" ", "on", " ", "on")
	end
end

function CTRL_ACCELERATION_ENABLE ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +14, 1600)	DspShow (" ", "on", " ", "on")
	end
end

