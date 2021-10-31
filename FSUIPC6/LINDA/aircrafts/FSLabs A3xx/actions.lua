--  Aircraft: FSLabs A319X/A320X/A321 v.2.02.+
--  Version: 1.5
--  Date: Feb 2020
--  Author: Gunter Steiner and Andrew Gransden


-- ## System functions ##

-- Initial info on MCP display

function InitDsp ()
   _loggg('[A32X] InitDsp called')
end

function InitVars ()

    -- test for A321 present
    A321 = false -- flag for Airbus A321 X
    airfile = ipc.readSTR(0x3D00,35)
    _loggg('[A32X] Airfile=' .. airfile)
    if string.find(airfile, "A321") ~= nil then
        A321 = true
        _loggg("[A32X] A321 found")
    end

    DimDispPzthigh = 80 --- set value for high Display Dim
    DimDispPzt = 50 --- set value for med Display Dim
    DimDispPztlow = 30 --- set value for low Display Dim

    FSLBaro = 0


    -- uncomment to disable display
    AutopilotDisplayBlocked ()

    UpperInfoLong = " "
    LowerInfoLong = " "
    Airbus = false
    FSL = 66587

    -- FCU values    -- not is use
    A320_SPD = 100
    A320_HDG = 241
    A320_ALT = 1
    A320_VS = 0
    A320_SPD_mode = 0
    A320_HDG_mode = 0
    A320_ALT_mode = 0
    A320_VS_mode = 0
    A320_ALT_STEP = 1

    -- PED Gravity Landing Gear
    A320_GRV_LDG_GEAR = 0

    -- Auto Brake Default initialisation

    FSL_ABRK_var = ipc.set("FSL_ABRK", 0)

    ipc.set("DSPmode", 2)
    AutoDisplay = false

    -- creat events to sync radios with MCP
    event.offset(0x0354, "UW", "VC_PED_ATCXPDR_MCPUpdate")
end 

function Timer ()
    -- DisplayA320Test ()
    local UpperInfoLong = "FSL"
    local LowerInfoLong = "Test"

    -- display Weather data on MCP display
    Baro = round(ipc.readUW("0EC6")/16)
    OATval = round(ipc.readUW("0E8C")/256)
    WINDval = round(ipc.readUW("0E90"))
    WindDir = round(ipc.readUW("0E92")*360/65536)

    if OATval > 100 then OATval = OATval - 256 end

    if not Airbus then
        UpperInfoLong = Baro
        if (OATval >= 0) and (OATval < 100) then
            UpperInfoLong = UpperInfoLong .. " " .. OATval .. "C"
        elseif OATval < 0 then
            UpperInfoLong = UpperInfoLong .. " -" .. math.abs(OATval)
        else
            UpperInfoLong = UpperInfoLong .. " " .. OATval
        end
        LowerInfoLong = WindDir .. '/' .. WINDval
        if WINDval < 100 then
            LowerInfoLong = LowerInfoLong .. "kt"
        end
    else
        UpperInfoLong = Baro
        LowerInfoLong = OATval .. 'C'
    end
   
    -- display Engine start selection position
    local EngMode = ipc.readLvar("VC_PED_ENG_MODE_Switch")
    if EngMode == 0 then
        EngModeTxt = "crnk"
    elseif EngMode == 10 then
        EngModeTxt = "norm"
    elseif EngMode == 20 then
        EngModeTxt = "strt"
    end
    if EngMode ~= 10 then
        if _MCP2a() then
            UpperInfoLong = "Eng " .. EngModeTxt
            LowerInfoLong = ""
        else
            UpperInfoLong = "Engine"
            LowerInfoLong = EngModeTxt
        end
    end


   if Airbus then
        FLIGHT_INFO1 = UpperInfoLong
        FLIGHT_INFO2 = LowerInfoLong
   else
        FLIGHT_INFO1 = UpperInfoLong
        FLIGHT_INFO2 = LowerInfoLong
   end

   -- move emergency landing gear handle if operated
   VC_PED_LDG_GEAR_GRV_EXT_move ()
end

-- ## Pre-Flight Checks

-- required by BA Virtual to ensure engines off and park brake on
function A320X_Cycle_Engines_and_ParkBrake()
local ongnd =  ipc.readUW(0x0366)
local engStopped = ipc.readLvar('FSDT_VAR_EnginesStopped')
    if ongnd == 1 and engStopped == 1 then
        VC_PED_PARK_BRAKE_on()
        ipc.sleep(100)
        VC_PED_ENG_MODE_norm()
        ipc.sleep(100)
        VC_PED_PARK_BRAKE_on()
        ipc.sleep(100)
        VC_PED_PARK_BRAKE_off ()
        ipc.sleep(100)
        VC_PED_ENG_1_MSTR_Switch_on()
        ipc.sleep(100)
        VC_PED_ENG_1_MSTR_Switch_off()
        ipc.sleep(100)
        VC_PED_ENG_2_MSTR_Switch_on()
        ipc.sleep(100)
        VC_PED_ENG_2_MSTR_Switch_off()
        ipc.sleep(100)
        VC_PED_PARK_BRAKE_on()
        ipc.sleep(100)
        _loggg('[A320X] Cycle Engines - completed')
    else
        _loggg('[A320X] Cycle Engines - Not On Gnd/Eng Stopped')
    end
end

-- $$ MCDU Left Special Functions

function VC_PED_MDCU_L_EXTPWR_toggle()
    VC_PED_MDCU_L_MENU_press()
    ipc.sleep(20)
    VC_PED_MDCU_L_R5_press()
    ipc.sleep(20)
    VC_PED_MDCU_L_L6_press()
    ipc.sleep(20)
    VC_PED_MDCU_L_L3_press()
    ipc.sleep(20)
    VC_PED_MDCU_L_MENU_press()
    ipc.sleep(20)
    VC_PED_MDCU_L_L1_press()
    VC_OVHD_ELECExtPwr_toggle()
end

function VC_PED_MDCU_L_BRIGHT()
    VC_PED_MDCU_L_KEY_BRT_hold()
end

function VC_PED_MDCU_L_DIMMED()
    VC_PED_MDCU_L_KEY_DIM_hold()
end

-- $$ Pedal Disconnect

function VC_PEDAL_DISC_CPT_toggle()
    local Lvar = 'VC_PEDAL_DISC_CPT'
    local pos = ipc.readLvar(Lvar)
    local val = 76024
    ipc.control(FSL, val)
    ipc.sleep(200)
    local val = 76026
    ipc.control(FSL, val)
    ipc.sleep(200)
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        DspShow('CPdl', 'down')
    else
        DspShow('CPdl', 'up')
    end
end

function VC_PEDAL_DISC_FO_toggle()
    local Lvar = 'VC_PEDAL_DISC_FO'
    local pos = ipc.readLvar(Lvar)
    local val = 76030
    ipc.control(FSL, val)
    ipc.sleep(200)
    local val = 76032
    ipc.control(FSL, val)
    ipc.sleep(200)
     pos = ipc.readLvar(Lvar)
    if pos > 0 then
        DspShow('FPdl', 'down')
    else
        DspShow('FPdl', 'up')
    end
end

-- ## Warning and Caution

-- $$ Capt Master Warning and Caution

function VS_GSLD_CP_Master_Warning_button()
local text1 = "MSTR"
local text2 = "WARN"
local Lvar = "VC_GSLD_CP_Warning_Button"
local mcro = "FSLA3XX_MAIN: MasterWarn"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VS_GSLD_CP_Master_Caution_button()
local text1 = "MSTR"
local text2 = "CAUT"
local Lvar = "VC_GSLD_CP_Caution_Button"
local mcro = "FSLA3XX_MAIN: MasterCaution"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VS_GSLD_CP_MasterWarningCaution()
    VS_GSLD_CP_Master_Warning_button()
    VS_GSLD_CP_Master_Caution_button()
end

-- $$ Auto Land

function VS_GSLD_CP_Auto_Land_button()
local text1 = "AUTO"
local text2 = "LAND"
local Lvar = "VC_GSLD_CP_Autoland_Button"
local mcro = "FSLA3XX_MAIN: AutoLand"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- ## FCU Autopilot Buttons ###############

function VC_GSLD_FCU_SPD_MACH_Button ()
    ipc.control(FSL, 71178)
    DspShow ("SPD/", "MACH")
end

function VC_GSLD_FCU_HDGTRKVSFPA ()
    ipc.control(FSL, 71186)
    DspShow ("HDG/", "FPA", "HDG TRK", "V/S FPA")
end

function VC_GSLD_FCU_ALT_STEP_1000 ()
    ipc.control(FSL, 71243)
    ipc.set("FSLALTStep", 1000)
    DspShow ("ALT", "1000")
end

function VC_GSLD_FCU_ALT_STEP_100 ()
    ipc.control(FSL, 71242)
    ipc.set("FSLALTStep", 100)
    DspShow ("ALT", "100")
end

function VC_GSLD_FCU_ALT_STEP_toggle ()
    local FSLALTStepVar = ipc.get("FSLALTStep")
    if FSLALTStepVar == 100 then VC_GSLD_FCU_ALT_STEP_1000 ()
    else VC_GSLD_FCU_ALT_STEP_100 ()
    end
end

function VC_GSLD_FCU_METRIC_ALT ()
    ipc.control(FSL, 71206)
    DspShow ("METR", "ALT")
end

---

function VC_GSLD_FCU_AP1 ()
    ipc.control(FSL, 71190)
    DspShow ("AP1", "")
end

function VC_GSLD_FCU_AP2 ()
    ipc.control(FSL, 71194)
    DspShow ("AP2", "")
end

function VC_AP_Disconnect ()
    ipc.control(65580)  -- toggle Master AP
    DspShow ("AP", "disc")
end

function VC_GSLD_FCU_LOC ()
    ipc.control(FSL, 71182)
    DspShow ("LOC", "")
end

function VC_GSLD_FCU_ATHR ()
    ipc.control(FSL, 71198)
    DspShow ("ATHR", "")
end

function VC_GSLD_FCU_EXPED ()
    ipc.control(FSL, 71202)
    DspShow ("EXPD", "", "EXPED", "")
end

function VC_GSLD_FCU_APPR ()
    ipc.control(FSL, 71210)
    DspShow ("APPR", "")
end

-- $$ Autopiot disconnect

function Autopilot_Disconnect()
    ipc.control(65580, 1)  -- AP_MASTER
    DspShow('AP', 'disc')
end

-- ## FCU Autopilot Rotaries ###############

-- $$ SPD

function VC_GSLD_FCU_SPD_inc ()
    ipc.control(FSL, 71226)
    --A320_SPD = A320_SPD + 1
    DspShow ("SPD", "inc")
end

function VC_GSLD_FCU_SPD_dec ()
    ipc.control(FSL, 71227)
    --A320_SPD = A320_SPD - 1
    DspShow ("SPD", "dec")
end

function VC_GSLD_FCU_SPD_push ()
    ipc.control(FSL, 71214)
    --A320_SPD_mode = 1
    DspShow ("SPD", "push")
end

function VC_GSLD_FCU_SPD_pull ()
    ipc.control(FSL, 71215)
    --A320_SPD_mode = 2
    DspShow ("SPD", "pull")
end

-- $$ HDG

function VC_GSLD_FCU_HDG_inc ()
    ipc.control(FSL, 71233)
    --A320_HDG = A320_HDG + 1
    DspShow ("HDG", "inc")
end

function VC_GSLD_FCU_HDG_incfast ()
    local i
    for i = 1, 5 do
        ipc.control(FSL, 71233)
    end
    --A320_HDG = A320_HDG + 10
    DspShow ("HDG", "inc")
end

function VC_GSLD_FCU_HDG_dec ()
    ipc.control(FSL, 71234)
    --A320_HDG = A320_HDG - 1
    DspShow ("HDG", "dec")
end

function VC_GSLD_FCU_HDG_decfast ()
    local i
    for i = 1, 5 do
        ipc.control(FSL, 71234)
    end
    --A320_HDG = A320_HDG + 10
    DspShow ("HDG", "dec")
end

function VC_GSLD_FCU_HDG_push ()
    ipc.control(FSL, 71228)
    A320_HDG_mode = 1
    DspShow ("HDG", "push")
end

function VC_GSLD_FCU_HDG_pull ()
    ipc.control(FSL, 71229)
    A320_HDG_mode = 2
    DspShow ("HDG", "pull")
end

-- $$ ALT

function VC_GSLD_FCU_ALT_100 ()
    if ipc.readLvar('VC_GSLD_FCU_100_1000_Switch') > 0 then
        ipc.control(FSL, 71242)
        A320_ALT_STEP = 1
        _logg('[A320] alt step = ' .. A320_ALT_STEP)
        DspShow('ALT', '100')
    end
end

function VC_GSLD_FCU_ALT_1000 ()
    if ipc.readLvar('VC_GSLD_FCU_100_1000_Switch') == 0 then
        ipc.control(FSL, 71243)
        A320_ALT_STEP = 10
        _logg('[A320] alt step = ' .. A320_ALT_STEP)
        DspShow('ALT', '1000')
    end
end

function VC_GSLD_FCU_ALT_100_1000_toggle ()
    if ipc.readLvar('VC_GSLD_FCU_100_1000_Switch') > 0 then
        VC_GSLD_FCU_ALT_100 ()
    else
        VC_GSLD_FCU_ALT_1000 ()
    end
end

function VC_GSLD_FCU_ALT_inc ()
    ipc.control(FSL, 71261)
    --A320_ALT = A320_ALT + A320_ALT_STEP
    DspShow ("ALT", "inc")
end

function VC_GSLD_FCU_ALT_dec ()
    ipc.control(FSL, 71262)
    --A320_ALT = A320_ALT - A320_ALT_STEP
    if A320_ALT < 100 then
    --    A320_ALT = 100
    end
    DspShow ("ALT", "dec")
end

function VC_GSLD_FCU_ALT_incfast ()
    local oldStep = ipc.readLvar('VC_GSLD_FCU_100_1000_Switch')
    if oldStep == 0 then
        ipc.control(FSL, 71243)
        ipc.control(FSL, 71261)
        ipc.control(FSL, 71242)
    else
        ipc.control(FSL, 71261)
    end
    --A320_ALT = A320_ALT + 10
    DspShow ("ALT", "inc")
end

function VC_GSLD_FCU_ALT_decfast ()
    local oldStep = ipc.readLvar('VC_GSLD_FCU_100_1000_Switch')
    if oldStep == 0 then
        ipc.control(FSL, 71243)
        ipc.control(FSL, 71262)
        ipc.control(FSL, 71242)
    else
        ipc.control(FSL, 71262)
    end
    --A320_ALT = A320_ALT - 10
    DspShow ("ALT", "dec")
end

function VC_GSLD_FCU_ALT_push ()
    ipc.control(FSL, 71249)
    A320_ALT_mode = 1
    DspShow ("ALT", "push")
end

function VC_GSLD_FCU_ALT_pull ()
    ipc.control(FSL, 71250)
    A320_ALT_mode = 2
    DspShow ("ALT", "pull")
end

-- $$ VS

function VC_GSLD_FCU_VS_inc ()
    ipc.control(FSL, 71275)
    --A320_VS = A320_VS + 1
    DspShow ("VS", "inc")
end

function VC_GSLD_FCU_VS_dec ()
    ipc.control(FSL, 71276)
    --A320_VS = A320_VS - 1
    DspShow ("VS", "dec")
end

function VC_GSLD_FCU_VS_push ()
    ipc.control(FSL, 71263)
    A320_VS_mode = 1
    DspShow ("VS", "push")
end

function VC_GSLD_FCU_VS_pull ()
    ipc.control(FSL, 71264)
    A320_VS_mode = 2
    A320_VS = 0
    DspShow ("VS", "pull")
end

-- ## EFIS CAPT ###############

-- $$ Baro

function VC_GSLD_CP_BARO_Switch_inHg ()
    if ipc.readLvar("VC_GSLD_CP_BARO_Mode_switch") == 10 then
        ipc.control(FSL, 71014)
        DspShow ("Baro", "inHg")
    end
end

function VC_GSLD_CP_BARO_Switch_hPa ()
    if ipc.readLvar("VC_GSLD_CP_BARO_Mode_switch") == 0 then
        ipc.control(FSL, 71015)
        DspShow ("Baro", "hPa")
    end
end

function VC_GSLD_CP_BARO_Switch_toggle()
    if ipc.readLvar("VC_GSLD_CP_BARO_Mode_switch") == 10 then
        VC_GSLD_CP_BARO_Switch_inHg()
    else
        VC_GSLD_CP_BARO_Switch_hPa()
    end
end

function VC_GSLD_CP_BARO_inc ()
    ipc.control(FSL, 71005)
    DspShow ("Baro", "inc")
end

function VC_GSLD_CP_BARO_dec ()
    ipc.control(FSL, 71006)
    DspShow ("Baro", "dec")
end

-- $$ BARO Std/QNH

function VC_GSLD_CP_EFIS_Baro_std ()
    ipc.control(FSL, 71008)
    ipc.sleep(200)
    ipc.control(FSL, 71011)
    ipc.set("FSLBaro", 0)
    DspShow ("BARO", "STD")
end

function VC_GSLD_CP_EFIS_Baro_qnh ()
    ipc.control(FSL, 71007)
    ipc.sleep(200)
    ipc.control(FSL, 71010)
    ipc.set("FSLBaro", 1)
    DspShow ("BARO", "QNH")
end

function VC_GSLD_CP_EFIS_Baro_toggle ()
    local FSLBaroVar = ipc.get("FSLBaro")
    if FSLBaroVar == 0 then
        VC_GSLD_CP_EFIS_Baro_qnh ()
    else
        VC_GSLD_CP_EFIS_Baro_std ()
    end
end

-- $$ Buttons Capt

-- $$ Capt FD

function VC_GSLD_CP_EFIS_FD ()
    ipc.control(FSL, 71035)
    DspShow ("CPT", "FD")
end

function VC_GSLD_CP_EFIS_FD_on ()
    local FDCPVar1 = ipc.readLvar("VC_GSLD_CP_EFIS_FD_Dim_Lt")
    local FDCPVar2 = ipc.readLvar("VC_GSLD_CP_EFIS_FD_Brt_Lt")
    FDCPVar = FDCPVar1 + FDCPVar2
    if FDCPVar == 0 then ipc.control(FSL, 71035) end
    DspShow ("C FD", "on", "CAPT", "FD on" .. FDCPVar)
end

function VC_GSLD_CP_EFIS_FD_off ()
    local FDCPVar1 = ipc.readLvar("VC_GSLD_CP_EFIS_FD_Dim_Lt")
    local FDCPVar2 = ipc.readLvar("VC_GSLD_CP_EFIS_FD_Brt_Lt")
    FDCPVar = FDCPVar1 + FDCPVar2
    if FDCPVar ~= 0 then ipc.control(FSL, 71035) end
    DspShow ("C FD", "off", "CAPT", "FD off")
end

-- $$ Capt LS

function VC_GSLD_CP_EFIS_LS ()
    ipc.control(FSL, 71039)
    DspShow ("CPT", "LS")
end

function VC_GSLD_CP_EFIS_LS_on ()
    local LSCPVar1 = ipc.readLvar("VC_GSLD_CP_EFIS_LS_Dim_Lt")
    local LSCPVar2 = ipc.readLvar("VC_GSLD_CP_EFIS_LS_Brt_Lt")
    LSCPVar = LSCPVar1 + LSCPVar2
    if LSCPVar == 0 then ipc.control(FSL, 71039) end
    DspShow ("C LS", "on", "CAPT", "LS on" .. LSCPVar)
end

function VC_GSLD_CP_EFIS_LS_off ()
    local LSCPVar1 = ipc.readLvar("VC_GSLD_CP_EFIS_LS_Dim_Lt")
    local LSCPVar2 = ipc.readLvar("VC_GSLD_CP_EFIS_LS_Brt_Lt")
    LSCPVar = LSCPVar1 + LSCPVar2
    if LSCPVar ~= 0 then ipc.control(FSL, 71039) end
    DspShow ("C LS", "off", "CAPT", "LS off" .. LSCPVar)
end

-- $$ ND Data Display

function VC_GSLD_CP_EFIS_CSTR ()
     ipc.control(FSL, 71043)
     DspShow ("CPT", "CSTR")
end

function VC_GSLD_CP_EFIS_WPT ()
     ipc.control(FSL, 71047)
     DspShow ("CPT", "WPT")
end

function VC_GSLD_CP_EFIS_VORD ()
     ipc.control(FSL, 71051)
     DspShow ("CPT", "VORD")
end

function VC_GSLD_CP_EFIS_NDB ()
     ipc.control(FSL, 71055)
     DspShow ("CPT", "NDB")
end

function VC_GSLD_CP_EFIS_ARPT ()
     ipc.control(FSL, 71059)
     DspShow ("CPT", "ARPT")
end

--$$ VOR-ADF

function VC_GSLD_CP_EFIS_VORNDB_toggle ()
     local STACPVar1a= ipc.readLvar("VC_GSLD_CP_EFIS_VORD_Dim_Lt")
     local STACPVar1b = ipc.readLvar("VC_GSLD_CP_EFIS_VORD_Brt_Lt")
     if STACPVar1a == 0 and STACPVar1b == 0 then STACPVar1 = 0
     elseif STACPVar1a == 1 or STACPVar1b == 1 then STACPVar1 = 1
     end

     local STACPVar2a= ipc.readLvar("VC_GSLD_CP_EFIS_NDB_Dim_Lt")
     local STACPVar2b = ipc.readLvar("VC_GSLD_CP_EFIS_NDB_Brt_Lt")
     if STACPVar2a == 0 and STACPVar2b == 0 then STACPVar2 = 0
     elseif STACPVar2a == 1 or STACPVar2b == 1 then STACPVar2 = 1
     end

     if STACPVar1 == 0 and STACPVar2 == 0 then VC_GSLD_CP_EFIS_VORD ()
     elseif STACPVar1 == 1 and STACPVar2 == 0 then VC_GSLD_CP_EFIS_NDB ()
     elseif STACPVar1 == 0 and STACPVar2 == 1 then VC_GSLD_CP_EFIS_NDB ()
     end
end

-- ## EFIS Capt ND Range and Mode

-- $$ ND Mode

function VC_GSLD_CP_EFIS_ND_Mode_show ()
     ipc.sleep(20)
     local EfisCaptNDM = ipc.readLvar("VC_GSLD_CP_EFIS_ND_Mode_Knob")
     if EfisCaptNDM == 0 then EfisCaptNDMTxt = "LS"
     elseif EfisCaptNDM == 10 then EfisCaptNDMTxt = "VOR"
     elseif EfisCaptNDM == 20 then EfisCaptNDMTxt = "NAV"
     elseif EfisCaptNDM == 30 then EfisCaptNDMTxt = "ARC"
     elseif EfisCaptNDM == 40 then EfisCaptNDMTxt = "PLAN"
     end
     DspShow ("Mode", EfisCaptNDMTxt)
end

function VC_GSLD_CP_EFIS_ND_Mode_inc ()
    ipc.control(FSL, 71022)
    VC_GSLD_CP_EFIS_ND_Mode_show ()
end

function VC_GSLD_CP_EFIS_ND_Mode_dec ()
    ipc.control(FSL, 71021)
    VC_GSLD_CP_EFIS_ND_Mode_show ()
end

function VC_GSLD_CP_EFIS_ND_Mode_cycle ()
     ipc.sleep(20)
     local EfisCaptNDM = ipc.readLvar("VC_GSLD_CP_EFIS_ND_Mode_Knob")
     if EfisCaptNDM < 40 then
        VC_GSLD_CP_EFIS_ND_Mode_inc ()
     else
        for i = 1, 4 do
            VC_GSLD_CP_EFIS_ND_Mode_dec ()
        end
     end
     VC_GSLD_CP_EFIS_ND_Mode_show ()
end

-- $$ ND Range

function VC_GSLD_CP_EFIS_ND_Range_show ()
     ipc.sleep(20)
     local EfisCaptRNGM = ipc.readLvar("VC_GSLD_CP_EFIS_ND_Range_Knob")
     if  EfisCaptRNGM == 0 then  EfisCaptRNGMTxt = "10"
     elseif  EfisCaptRNGM == 10 then  EfisCaptRNGMTxt = "20"
     elseif  EfisCaptRNGM == 20 then  EfisCaptRNGMTxt = "40"
     elseif  EfisCaptRNGM == 30 then  EfisCaptRNGMTxt = "80"
     elseif  EfisCaptRNGM == 40 then  EfisCaptRNGMTxt = "160"
     elseif  EfisCaptRNGM == 50 then  EfisCaptRNGMTxt = "320"
     end
     DspShow ("Mode",  EfisCaptRNGMTxt)
end

function VC_GSLD_CP_EFIS_ND_Range_inc ()
    ipc.control(FSL, 71029)
    VC_GSLD_CP_EFIS_ND_Range_show ()
end

function VC_GSLD_CP_EFIS_ND_Range_dec ()
    ipc.control(FSL, 71028)
    VC_GSLD_CP_EFIS_ND_Range_show ()
end

function VC_GSLD_CP_EFIS_ND_Range_cycle ()
     ipc.sleep(20)
     local EfisCaptNDR = ipc.readLvar("VC_GSLD_CP_EFIS_ND_Range_Knob")
     if EfisCaptNDR < 50 then
        VC_GSLD_CP_EFIS_ND_Range_inc ()
     else
        for i = 1, 5 do
            VC_GSLD_CP_EFIS_ND_Range_dec ()
        end
     end
     VC_GSLD_CP_EFIS_ND_Range_show ()
end

-- $$ VOR-ADF 1

function VC_GSLD_CP_EFIS_VORADF_1_show ()
    ipc.sleep(20)
    local EfisCaptADFVOR1 = ipc.readLvar("VC_GSLD_CP_EFIS_VORADF_1_Switch")
    if EfisCaptADFVOR1 == 0 then EfisCaptADFVOR1Txt = "ADF1"
    elseif EfisCaptADFVOR1 == 10 then EfisCaptADFVOR1Txt = "OFF1"
    elseif EfisCaptADFVOR1 == 20 then EfisCaptADFVOR1Txt = "VOR1"
    end
    DspShow ("CAPT", EfisCaptADFVOR1Txt)
end

function VC_GSLD_CP_EFIS_VORADF_1_toggle ()
    local EfisCaptADFVOR1 = ipc.readLvar("VC_GSLD_CP_EFIS_VORADF_1_Switch")
    if EfisCaptADFVOR1 == 0 then VC_GSLD_CP_EFIS_VORADF_1_off ()
    elseif EfisCaptADFVOR1 == 10 then VC_GSLD_CP_EFIS_VORADF_1_vor ()
    elseif EfisCaptADFVOR1 == 20 then VC_GSLD_CP_EFIS_VORADF_1_adf ()
    end
end

function VC_GSLD_CP_EFIS_VORADF_1_LtoR ()
    ipc.control(FSL, 71064)
    VC_GSLD_CP_EFIS_VORADF_1_show ()
end

function VC_GSLD_CP_EFIS_VORADF_1_RtoL ()
    ipc.control(FSL, 71063)
    VC_GSLD_CP_EFIS_VORADF_1_show ()
end

function VC_GSLD_CP_EFIS_VORADF_1_adf ()
    local EfisCaptADFVOR1 = ipc.readLvar("VC_GSLD_CP_EFIS_VORADF_1_Switch")
    if EfisCaptADFVOR1 == 10 then ipc.control(FSL, 71063)
    elseif EfisCaptADFVOR1 == 20 then ipc.control(FSL, 71063) ipc.control(FSL, 71063)
    end
    DspShow ("CAPT", "ADF1")
end

function VC_GSLD_CP_EFIS_VORADF_1_off ()
    local EfisCaptADFVOR1 = ipc.readLvar("VC_GSLD_CP_EFIS_VORADF_1_Switch")
    if EfisCaptADFVOR1 == 0 then ipc.control(FSL, 71064)
    elseif EfisCaptADFVOR1 == 20 then ipc.control(FSL, 71063)
    end
    DspShow ("CAPT", "OFF1")
end

function VC_GSLD_CP_EFIS_VORADF_1_vor ()
    local EfisCaptADFVOR1 = ipc.readLvar("VC_GSLD_CP_EFIS_VORADF_1_Switch")
    if EfisCaptADFVOR1 == 10 then ipc.control(FSL, 71064)
    elseif EfisCaptADFVOR1 == 0 then ipc.control(FSL, 71064) ipc.control(FSL, 71064)
    end
    DspShow ("CAPT", "VOR1")
end

-- $$ VOR-ADF 2

function VC_GSLD_CP_EFIS_VORADF_2_show ()
    ipc.sleep(20)
    local EfisCaptADFVOR2 = ipc.readLvar("VC_GSLD_CP_VORADF_2_Switch")
    if EfisCaptADFVOR2 == 0 then EfisCaptADFVOR2Txt = "ADF2"
    elseif EfisCaptADFVOR2 == 10 then EfisCaptADFVOR2Txt = "OFF2"
    elseif EfisCaptADFVOR2 == 20 then EfisCaptADFVOR2Txt = "VOR2"
    end
    DspShow ("CAPT", EfisCaptADFVOR2Txt)
end

function VC_GSLD_CP_EFIS_VORADF_2_toggle ()
    local EfisCaptADFVOR2 = ipc.readLvar("VC_GSLD_CP_VORADF_2_Switch")
    if EfisCaptADFVOR2 == 0 then VC_GSLD_CP_EFIS_VORADF_2_off ()
    elseif EfisCaptADFVOR2 == 10 then VC_GSLD_CP_EFIS_VORADF_2_vor ()
    elseif EfisCaptADFVOR2 == 20 then VC_GSLD_CP_EFIS_VORADF_2_adf ()
    end
end

function VC_GSLD_CP_EFIS_VORADF_2_LtoR ()
    ipc.control(FSL, 71069)
    VC_GSLD_CP_EFIS_VORADF_2_show ()
end

function VC_GSLD_CP_EFIS_VORADF_2_RtoL ()
    ipc.control(FSL, 71068)
    VC_GSLD_CP_EFIS_VORADF_2_show ()
end

function VC_GSLD_CP_EFIS_VORADF_2_adf ()
    local EfisCaptADFVOR2 = ipc.readLvar("VC_GSLD_CP_VORADF_2_Switch")
    if EfisCaptADFVOR2 == 10 then ipc.control(FSL, 71068)
    elseif EfisCaptADFVOR2 == 20 then ipc.control(FSL, 71068) ipc.control(FSL, 71068)
    end
    DspShow ("CAPT", "ADF2")
end

function VC_GSLD_CP_EFIS_VORADF_2_off ()
    local EfisCaptADFVOR2 = ipc.readLvar("VC_GSLD_CP_VORADF_2_Switch")
    if EfisCaptADFVOR2 == 0 then ipc.control(FSL, 71069)
    elseif EfisCaptADFVOR2 == 20 then ipc.control(FSL, 71068)
    end
    DspShow ("CAPT", "OFF2")
end

function VC_GSLD_CP_EFIS_VORADF_2_vor ()
    local EfisCaptADFVOR2 = ipc.readLvar("VC_GSLD_CP_VORADF_2_Switch")
    if EfisCaptADFVOR2 == 10 then ipc.control(FSL, 71069)
    elseif EfisCaptADFVOR2 == 0 then ipc.control(FSL, 71069) ipc.control(FSL, 71069)
    end
    DspShow ("CAPT", "VOR2")
end

-- ## EFIS FO

-- $$ Baro

function VC_GSLD_FO_BARO_Switch_inHg ()
    if ipc.readLvar("VC_GSLD_FO_BARO_Mode_switch") == 10 then
        ipc.control(FSL, 71087)
        DspShow ("Baro", "inHg")
    end
end

function VC_GSLD_FO_BARO_Switch_hPa ()
    if ipc.readLvar("VC_GSLD_fo_BARO_Mode_switch") == 0 then
        ipc.control(FSL, 71088)
        DspShow ("Baro", "hPa")
    end
end

function VC_GSLD_FO_BARO_Switch_toggle()
    if ipc.readLvar("VC_GSLD_FO_BARO_Mode_switch") == 10 then
        VC_GSLD_FO_BARO_Switch_inHg()
    else
        VC_GSLD_FO_BARO_Switch_hPa()
    end
end

function VC_GSLD_FO_BARO_inc ()
    ipc.control(FSL, 71078)
    DspShow ("Baro", "inc")
end

function VC_GSLD_FO_BARO_dec ()
    ipc.control(FSL, 71079)
    DspShow ("Baro", "dec")
end

-- $$ BARO Std/QNH

function VC_GSLD_FO_EFIS_Baro_std ()
    ipc.control(FSL, 71074)
    ipc.sleep(200)
    ipc.control(FSL, 71077)
    ipc.set("FSLBaroFO", 0)
    DspShow ("BARO", "STD")
end

function VC_GSLD_FO_EFIS_Baro_qnh ()
    ipc.control(FSL, 71073)
    ipc.sleep(200)
    ipc.control(FSL, 71076)
    ipc.set("FSLBaroFO", 1)
    DspShow ("BARO", "QNH")
end

function VC_GSLD_FO_EFIS_Baro_toggle ()
    local FSLBaroVar = ipc.get("FSLBaroFO")
    if FSLBaroVar == 0 then
        VC_GSLD_FO_EFIS_Baro_qnh ()
    else
        VC_GSLD_FO_EFIS_Baro_std ()
    end
end

-- $$ FO FD

function VC_GSLD_FO_EFIS_FD ()
    ipc.control(FSL, 71108)
    DspShow ("FO", "FD")
end

function VC_GSLD_FO_EFIS_FD_on ()
    local FDCPVar1 = ipc.readLvar("VC_GSLD_FO_EFIS_FD_Dim_Lt")
    local FDCPVar2 = ipc.readLvar("VC_GSLD_FO_EFIS_FD_Brt_Lt")
    FDCPVar = FDCPVar1 + FDCPVar2
    if FDCPVar == 0 then ipc.control(FSL, 71108) end
    DspShow ("R FD", "on", "FO", "FD on" .. FDCPVar)
end

function VC_GSLD_FO_EFIS_FD_off ()
    local FDCPVar1 = ipc.readLvar("VC_GSLD_FO_EFIS_FD_Dim_Lt")
    local FDCPVar2 = ipc.readLvar("VC_GSLD_FO_EFIS_FD_Brt_Lt")
    FDCPVar = FDCPVar1 + FDCPVar2
    if FDCPVar ~= 0 then ipc.control(FSL, 71108) end
    DspShow ("R FD", "off", "FO", "FD off")
end

-- $$ FO LS

function VC_GSLD_FO_EFIS_LS ()
    ipc.control(FSL, 71112)
    DspShow ("FO", "LS")
end

function VC_GSLD_FO_EFIS_LS_on ()
    local LSFOVar1 = ipc.readLvar("VC_GSLD_FO_EFIS_LS_Dim_Lt")
    local LSFOVar2 = ipc.readLvar("VC_GSLD_FO_EFIS_LS_Brt_Lt")
    LSFOVar = LSFOVar1 + LSFOVar2
    if LSFOVar == 0 then ipc.control(FSL, 71112) end
    DspShow ("R LS", "on", "FO", "LS on" .. LSFOVar)
end

function VC_GSLD_FO_EFIS_LS_off ()
    local LSFOVar1 = ipc.readLvar("VC_GSLD_FO_EFIS_LS_Dim_Lt")
    local LSFOVar2 = ipc.readLvar("VC_GSLD_FO_EFIS_LS_Brt_Lt")
    LSFOVar = LSFOVar1 + LSFOVar2
    if LSFOVar ~= 0 then ipc.control(FSL, 71112) end
    DspShow ("R LS", "off", "FO", "LS off" .. LSFOVar)
end

-- ## EFIS FO ND Range and Mode

-- $$ FO ND Mode

function VC_GSLD_FO_EFIS_ND_Mode_show ()
     ipc.sleep(20)
     local EfisFONDM = ipc.readLvar("VC_GSLD_FO_EFIS_ND_Mode_Knob")
     if EfisFONDM == 0 then EfisFONDMTxt = "LS"
     elseif EfisFONDM == 10 then EfisFONDMTxt = "VOR"
     elseif EfisFONDM == 20 then EfisFONDMTxt = "NAV"
     elseif EfisFONDM == 30 then EfisFONDMTxt = "ARC"
     elseif EfisFONDM == 40 then EfisFONDMTxt = "PLAN"
     end
     DspShow ("NDM", EfisFONDMTxt)
end

function VC_GSLD_FO_EFIS_ND_Mode_inc ()
    ipc.control(FSL, 71095)
    VC_GSLD_FO_EFIS_ND_Mode_show ()
end

function VC_GSLD_FO_EFIS_ND_Mode_dec ()
    ipc.control(FSL, 71094)
    VC_GSLD_FO_EFIS_ND_Mode_show ()
end

function VC_GSLD_FO_EFIS_ND_Mode_cycle ()
     ipc.sleep(20)
     local EfisFONDM = ipc.readLvar("VC_GSLD_FO_EFIS_ND_Mode_Knob")
     if EfisFONDM < 40 then
        VC_GSLD_FO_EFIS_ND_Mode_inc ()
     else
        for i = 1, 4 do
            VC_GSLD_FO_EFIS_ND_Mode_dec ()
        end
     end
     VC_GSLD_FO_EFIS_ND_Mode_show ()
end

-- $$ FO ND Range

function VC_GSLD_FO_EFIS_ND_Range_show ()
     ipc.sleep(20)
     local EfisFORNGM = ipc.readLvar("VC_GSLD_FO_EFIS_ND_Range_Knob")
     if  EfisFORNGM == 0 then  EfisFORNGMTxt = "10"
     elseif  EfisFORNGM == 10 then  EfisFORNGMTxt = "20"
     elseif  EfisFORNGM == 20 then  EfisFORNGMTxt = "40"
     elseif  EfisFORNGM == 30 then  EfisFORNGMTxt = "80"
     elseif  EfisFORNGM == 40 then  EfisFORNGMTxt = "160"
     elseif  EfisFORNGM == 50 then  EfisFORNGMTxt = "320"
     end
     DspShow ("NDR",  EfisFORNGMTxt)
end

function VC_GSLD_FO_EFIS_ND_Range_inc ()
    ipc.control(FSL, 71102)
    VC_GSLD_FO_EFIS_ND_Range_show ()
end

function VC_GSLD_FO_EFIS_ND_Range_dec ()
    ipc.control(FSL, 71101)
    VC_GSLD_FO_EFIS_ND_Range_show ()
end

function VC_GSLD_FO_EFIS_ND_Range_cycle ()
     ipc.sleep(20)
     local EfisFONDR = ipc.readLvar("VC_GSLD_FO_EFIS_ND_Range_Knob")
     if EfisFONDR < 50 then
        VC_GSLD_FO_EFIS_ND_Range_inc ()
     else
        for i = 1, 5 do
            VC_GSLD_FO_EFIS_ND_Range_dec ()
        end
     end
     VC_GSLD_FO_EFIS_ND_Range_show ()
end

-- $$ FO ADF/VOR 1

function VC_GSLD_FO_EFIS_VORADF_1_show ()
    ipc.sleep(20)
    local EfisFOADFVOR1 = ipc.readLvar("VC_GSLD_FO_EFIS_VORADF_1_Switch")
    if EfisFOADFVOR1 == 0 then EfisFOADFVOR1Txt = "ADF1"
    elseif EfisFOADFVOR1 == 10 then EfisFOADFVOR1Txt = "OFF1"
    elseif EfisFOADFVOR1 == 20 then EfisFOADFVOR1Txt = "VOR1"
    end
    DspShow ("FO", EfisFOADFVOR1Txt)
end

function VC_GSLD_FO_EFIS_VORADF_1_toggle ()
   local  EfisFOADFVOR1 = ipc.readLvar("VC_GSLD_FO_EFIS_VORADF_1_Switch")
    if EfisFOADFVOR1 == 0 then VC_GSLD_FO_EFIS_VORADF_1_off ()
    elseif EfisFOADFVOR1 == 10 then VC_GSLD_FO_EFIS_VORADF_1_vor ()
    elseif EfisFOADFVOR1 == 20 then VC_GSLD_FO_EFIS_VORADF_1_adf ()
    end
end

function VC_GSLD_FO_EFIS_VORADF_1_LtoR ()
    ipc.control(FSL, 71137)
    VC_GSLD_FO_EFIS_VORADF_1_show ()
end

function VC_GSLD_FO_EFIS_VORADF_1_RtoL ()
    ipc.control(FSL, 71136)
    VC_GSLD_FO_EFIS_VORADF_1_show ()
end

function VC_GSLD_FO_EFIS_VORADF_1_adf ()
    local EfisFOADFVOR1 = ipc.readLvar("VC_GSLD_FO_EFIS_VORADF_1_Switch")
    if EfisFOADFVOR1 == 10 then ipc.control(FSL, 71136)
    elseif EfisFOADFVOR1 == 20 then
        ipc.control(FSL, 71136)
        ipc.control(FSL, 71136)
    end
    DspShow ("FO", "ADF1")
end

function VC_GSLD_FO_EFIS_VORADF_1_off ()
    EfisFOADFVOR1 = ipc.readLvar("VC_GSLD_FO_EFIS_VORADF_1_Switch")
    if EfisFOADFVOR1 == 0 then
        ipc.control(FSL, 71137)
    elseif EfisFOADFVOR1 == 20 then
        ipc.control(FSL, 71136)
    end
    DspShow ("FO", "OFF1")
end

function VC_GSLD_FO_EFIS_VORADF_1_vor ()
    local EfisFOADFVOR1 = ipc.readLvar("VC_GSLD_FO_EFIS_VORADF_1_Switch")
    if EfisFOADFVOR1 == 10 then
        ipc.control(FSL, 71137)
    elseif EfisFOADFVOR1 == 0 then
        ipc.control(FSL, 71137)
        ipc.control(FSL, 71137)
    end
    DspShow ("FO", "VOR1")
end

-- $$ FO ADF/VOR 2

function VC_GSLD_FO_EFIS_VORADF_2_show ()
    ipc.sleep(20)
    local EfisFOADFVOR2 = ipc.readLvar("VC_GSLD_FO_VORADF_2_Switch")
    if EfisFOADFVOR2 == 0 then EfisFOADFVOR2Txt = "ADF2"
    elseif EfisFOADFVOR2 == 10 then EfisFOADFVOR2Txt = "OFF2"
    elseif EfisFOADFVOR2 == 20 then EfisFOADFVOR2Txt = "VOR2"
    end
    DspShow ("FO", EfisFOADFVOR2Txt)
end

function VC_GSLD_FO_EFIS_VORADF_2_toggle ()
    local EfisFOADFVOR2 = ipc.readLvar("VC_GSLD_FO_VORADF_2_Switch")
    if EfisFOADFVOR2 == 0 then VC_GSLD_FO_EFIS_VORADF_2_off ()
    elseif EfisFOADFVOR2 == 10 then VC_GSLD_FO_EFIS_VORADF_2_vor ()
    elseif EfisFOADFVOR2 == 20 then VC_GSLD_FO_EFIS_VORADF_2_adf ()
    end
end

function VC_GSLD_FO_EFIS_VORADF_2_LtoR ()
    ipc.control(FSL, 71142)
    VC_GSLD_FO_EFIS_VORADF_2_show ()
end

function VC_GSLD_FO_EFIS_VORADF_2_RtoL ()
    ipc.control(FSL, 71141)
    VC_GSLD_FO_EFIS_VORADF_2_show ()
end

function VC_GSLD_FO_EFIS_VORADF_2_adf ()
    local EfisFOADFVOR2 = ipc.readLvar("VC_GSLD_FO_VORADF_2_Switch")
    if EfisFOADFVOR2 == 10 then
        ipc.control(FSL, 71141)
    elseif EfisFOADFVOR2 == 20 then
        ipc.control(FSL, 71141)
        ipc.control(FSL, 71141)
    end
    DspShow ("FO", "ADF2")
end

function VC_GSLD_FO_EFIS_VORADF_2_off ()
    local EfisFOADFVOR2 = ipc.readLvar("VC_GSLD_FO_VORADF_2_Switch")
    if EfisFOADFVOR2 == 0 then
        ipc.control(FSL, 71142)
    elseif EfisFOADFVOR2 == 20 then
        ipc.control(FSL, 71141)
    end
    DspShow ("FO", "OFF2")
end

function VC_GSLD_FO_EFIS_VORADF_2_vor ()
    local EfisFOADFVOR2 = ipc.readLvar("VC_GSLD_FO_VORADF_2_Switch")
    if EfisFOADFVOR2 == 10 then ipc.control(FSL, 71142)
    elseif EfisFOADFVOR2 == 0 then ipc.control(FSL, 71142) ipc.control(FSL, 71142)
    end
    DspShow ("FO", "VOR2")
end

-- $$ FO EFIS Buttons

function VC_GSLD_FO_EFIS_CSTR ()
     ipc.control(FSL, 71116)
     DspShow ("FO", "CSTR")
end

function VC_GSLD_FO_EFIS_WPT ()
     ipc.control(FSL, 71120)
     DspShow ("FO", "WPT")
end

function VC_GSLD_FO_EFIS_VORD ()
     ipc.control(FSL, 71124)
     DspShow ("FO", "VORD")
end

function VC_GSLD_FO_EFIS_NDB ()
     ipc.control(FSL, 71128)
     DspShow ("FO", "NDB")
end

function VC_GSLD_FO_EFIS_ARPT ()
     ipc.control(FSL, 71132)
     DspShow ("FO", "ARPT")
end

function VC_GSLD_FO_EFIS_VORNDB_toggle ()
     local STACPVar1a= ipc.readLvar("VC_GSLD_FO_EFIS_VORD_Dim_Lt")
     local STACPVar1b = ipc.readLvar("VC_GSLD_FO_EFIS_VORD_Brt_Lt")
     if STACPVar1a == 0 and STACPVar1b == 0 then STACPVar1 = 0
     elseif STACPVar1a == 1 or STACPVar1b == 1 then STACPVar1 = 1
     end

     local STACPVar2a= ipc.readLvar("VC_GSLD_FO_EFIS_NDB_Dim_Lt")
     local STACPVar2b = ipc.readLvar("VC_GSLD_FO_EFIS_NDB_Brt_Lt")
     if STACPVar2a == 0 and STACPVar2b == 0 then STACPVar2 = 0
     elseif STACPVar2a == 1 or STACPVar2b == 1 then STACPVar2 = 1
     end

     if STACPVar1 == 0 and STACPVar2 == 0 then VC_GSLD_FO_EFIS_VORD ()
     elseif STACPVar1 == 1 and STACPVar2 == 0 then VC_GSLD_FO_EFIS_NDB ()
     elseif STACPVar1 == 0 and STACPVar2 == 1 then VC_GSLD_FO_EFIS_NDB ()
     end
end

-- ## EFIS Capt and FO both

-- $$ FD both

function VC_GSLD_BOTH_EFIS_FD_toggle ()
    VC_GSLD_CP_EFIS_FD ()
    VC_GSLD_FO_EFIS_FD ()
end

function VC_GSLD_BOTH_EFIS_FD_on ()
    VC_GSLD_CP_EFIS_FD_on ()
    VC_GSLD_FO_EFIS_FD_on ()
end

function VC_GSLD_BOTH_EFIS_FD_off ()
    VC_GSLD_CP_EFIS_FD_off ()
    VC_GSLD_FO_EFIS_FD_off ()
end

-- $$ LS both

function VC_GSLD_BOTH_EFIS_LS_toggle ()
    VC_GSLD_CP_EFIS_LS ()
    VC_GSLD_FO_EFIS_LS ()
end

function VC_GSLD_BOTH_EFIS_LS_on ()
    VC_GSLD_CP_EFIS_LS_on ()
    VC_GSLD_FO_EFIS_LS_on ()
end

function VC_GSLD_BOTH_EFIS_LS_off ()
    VC_GSLD_CP_EFIS_LS_off ()
    VC_GSLD_FO_EFIS_LS_off ()
end

-- ## Overhead AIR COND #############

-- $$ AC Pack 1

function VC_OVHD_ACPACK_1_on ()
    if ipc.readLvar("VC_OVHD_AC_Pack_1_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: ACPACK1")
    end
    DspShow ("EGPK", "1 on")
end

function VC_OVHD_ACPACK_1_off ()
    if ipc.readLvar("VC_OVHD_AC_Pack_1_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: ACPACK1")
    end
    DspShow ("EGPK", "1 of")
end

function VC_OVHD_ACPack_1_toggle ()
    if ipc.readLvar("VC_OVHD_AC_Pack_1_Button") == 0 then
        VC_OVHD_ACPACK_1_on ()
    else
        VC_OVHD_ACPACK_1_off ()
    end
end

-- $$ AC Pack 2

function VC_OVHD_ACPACK_2_on ()
    if ipc.readLvar("VC_OVHD_AC_Pack_2_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: ACPACK2")
    end
    DspShow ("EGPK", "2 on")
end

function VC_OVHD_ACPACK_2_off ()
    if ipc.readLvar("VC_OVHD_AC_Pack_2_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: ACPACK2")
    end
    DspShow ("EGPK", "2 of")
end

function VC_OVHD_ACPack_2_toggle ()
    if ipc.readLvar("VC_OVHD_AC_Pack_2_Button") == 0 then
        VC_OVHD_ACPACK_2_on ()
    else
        VC_OVHD_ACPACK_2_off ()
    end
end

-- $$ APU Bleed

function VC_OVHD_ACAPU_BLEED_on ()
    if ipc.readLvar("VC_OVHD_AC_Eng_APU_Bleed_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: APUBleed")
    end
    DspShow ("APUB", "on")
end

function VC_OVHD_ACAPU_BLEED_off ()
    if ipc.readLvar("VC_OVHD_AC_Eng_APU_Bleed_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: APUBleed")
    end
    DspShow ("APUB", "off")
end

function VC_OVHD_ACAPU_BLEED_toggle ()
    if ipc.readLvar("VC_OVHD_AC_Eng_APU_Bleed_Button") == 0 then
        VC_OVHD_ACAPU_BLEED_on ()
    else
        VC_OVHD_ACAPU_BLEED_off ()
    end
end


-- ## Overhead FUEL ###############

-- $$ Left fuel Pumps

function VC_OVHD_FUEL_L_TK_1_PUMP_on ()
    if ipc.readLvar("VC_OVHD_FUEL_L_TK_1_PUMP_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: LPUMP1")
    end
    DspShow ("LPMP", "1 on")
    _sleep(50)
end

function VC_OVHD_FUEL_L_TK_1_PUMP_off ()
    if ipc.readLvar("VC_OVHD_FUEL_L_TK_1_PUMP_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: LPUMP1")
    end
    DspShow ("LPMP", "1off")
    _sleep(50)
end

function VC_OVHD_FUEL_L_TK_1_PUMP_toggle()
	if _tl("VC_OVHD_FUEL_L_TK_1_PUMP_Button", 0) then
       VC_OVHD_FUEL_L_TK_1_PUMP_on()
	else
       VC_OVHD_FUEL_L_TK_1_PUMP_off()
	end
end

--

function VC_OVHD_FUEL_L_TK_2_PUMP_on ()
    if ipc.readLvar("VC_OVHD_FUEL_L_TK_2_PUMP_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: LPUMP2")
    end
    DspShow ("LPMP", "2 on")
    _sleep(50)
end

function VC_OVHD_FUEL_L_TK_2_PUMP_off ()
    if ipc.readLvar("VC_OVHD_FUEL_L_TK_2_PUMP_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: LPUMP2")
    end
    DspShow ("LPMP", "2off")
    _sleep(50)
end

function VC_OVHD_FUEL_L_TK_2_PUMP_toggle()
	if _tl("VC_OVHD_FUEL_L_TK_2_PUMP_Button", 0) then
       VC_OVHD_FUEL_L_TK_2_PUMP_on()
	else
       VC_OVHD_FUEL_L_TK_2_PUMP_off()
	end
end

--

function VC_OVHD_FUEL_L_TK_both_PUMP_on ()
    VC_OVHD_FUEL_L_TK_1_PUMP_on ()
    _sleep(100,200)
    VC_OVHD_FUEL_L_TK_2_PUMP_on ()
end

function VC_OVHD_FUEL_L_TK_both_PUMP_off ()
    VC_OVHD_FUEL_L_TK_1_PUMP_off ()
    _sleep(100,200)
    VC_OVHD_FUEL_L_TK_2_PUMP_off ()
end

function VC_OVHD_FUEL_L_TK_both_PUMP_toggle ()
    VC_OVHD_FUEL_L_TK_1_PUMP_toggle ()
    _sleep(100,200)
    VC_OVHD_FUEL_L_TK_2_PUMP_toggle ()
end

-- $$ Center fuel Pumps

function VC_OVHD_FUEL_CTR_TK_1_PUMP_on ()
    if (not A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_1_PUMP_Button") == 0) or
        (A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_1_VALVE_Button") == 0)
    then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: CTRPUMP1")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED_L")
        end
    end
    DspShow ("CPMP", "1 on")
    _sleep(50)
end

function VC_OVHD_FUEL_CTR_TK_1_PUMP_off ()
    if (not A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_1_PUMP_Button") ~= 0) or
        (A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_1_VALVE_Button") ~= 0)
    then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: CTRPUMP1")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED_L")
        end
    end
    DspShow ("CPMP", "1off")
    _sleep(50)
end

function VC_OVHD_FUEL_CTR_TK_1_PUMP_toggle()
	if (not A321 and _tl("VC_OVHD_FUEL_CTR_TK_1_PUMP_Button", 0)) or
        (A321 and _tl("VC_OVHD_FUEL_CTR_TK_1_VALVE_Button", 0))
    then
       VC_OVHD_FUEL_CTR_TK_1_PUMP_on()
	else
       VC_OVHD_FUEL_CTR_TK_1_PUMP_off()
	end
end

--

function VC_OVHD_FUEL_CTR_TK_2_PUMP_on ()
    if (not A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_2_PUMP_Button") == 0) or
        (A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_2_VALVE_Button") == 0)
    then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: CTRPUMP2")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED_R")
        end
    end
    DspShow ("CPMP", "2 on")
    _sleep(50)
end

function VC_OVHD_FUEL_CTR_TK_2_PUMP_off ()
    if (not A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_2_PUMP_Button") ~= 0) or
         (A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_2_VALVE_Button") ~= 0)
    then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: CTRPUMP2")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED_R")
        end
    end
    DspShow ("CPMP", "2off")
    _sleep(50)
end

function VC_OVHD_FUEL_CTR_TK_2_PUMP_toggle()
	if (not A321 and _tl("VC_OVHD_FUEL_CTR_TK_2_PUMP_Button", 0)) or
        (A321 and _tl("VC_OVHD_FUEL_CTR_TK_2_VALVE_Button", 0) )
    then
       VC_OVHD_FUEL_CTR_TK_2_PUMP_on()
	else
       VC_OVHD_FUEL_CTR_TK_2_PUMP_off()
	end
end

--

function VC_OVHD_FUEL_CTR_TK_both_PUMP_on ()
    VC_OVHD_FUEL_CTR_TK_1_PUMP_on ()
    _sleep(100,200)
    VC_OVHD_FUEL_CTR_TK_2_PUMP_on ()
end

function VC_OVHD_FUEL_CTR_TK_both_PUMP_off ()
    VC_OVHD_FUEL_CTR_TK_1_PUMP_off ()
    _sleep(100,200)
    VC_OVHD_FUEL_CTR_TK_2_PUMP_off ()
end

function VC_OVHD_FUEL_CTR_TK_both_PUMP_toggle ()
    VC_OVHD_FUEL_CTR_TK_1_PUMP_toggle ()
    _sleep(100,200)
    VC_OVHD_FUEL_CTR_TK_2_PUMP_toggle ()
end


-- $$ Center fuel transfer A321

function VC_OVHD_FUEL_CTR_XFR_L_on ()
    if (not A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_1_PUMP_Button") == 0) or
        (A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_1_VALVE_Button") == 0)
    then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: CTRPUMP1")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED_L")
        end
    end
    DspShow ("XFR", "L on")
    _sleep(50)
end

function VC_OVHD_FUEL_CTR_XFR_L_off ()
    if (not A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_1_PUMP_Button") ~= 0) or
        (A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_1_VALVE_Button") ~= 0)
    then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: CTRPUMP1")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED_L")
        end
    end
    DspShow ("XFR", "Loff")
    _sleep(50)
end

function VC_OVHD_FUEL_CTR_XFR_L_toggle()
	if (not A321 and _tl("VC_OVHD_FUEL_CTR_TK_1_PUMP_Button", 0)) or
        (A321 and _tl("VC_OVHD_FUEL_CTR_TK_1_VALVE_Button", 0)) then
       VC_OVHD_FUEL_CTR_XFR_L_on()
	else
       VC_OVHD_FUEL_CTR_XFR_L_off()
	end
end

--

function VC_OVHD_FUEL_CTR_XFR_R_on ()
    if (not A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_2_PUMP_Button") == 0) or
        (A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_2_VALVE_Button") == 0)
    then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: CTRPUMP2")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED_R")
        end
    end
    DspShow ("XFR", "2 on")
    _sleep(50)
end

function VC_OVHD_FUEL_CTR_XFR_R_off ()
    if (not A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_2_PUMP_Button") ~= 0) or
        (A321 and ipc.readLvar("VC_OVHD_FUEL_CTR_TK_2_VALVE_Button") ~= 0)
    then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: CTRPUMP2")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED_R")
        end
    end
    DspShow ("XFR", "2off")
    _sleep(50)
end

function VC_OVHD_FUEL_CTR_XFR_R_toggle()
	if (not A321 and _tl("VC_OVHD_FUEL_CTR_TK_2_PUMP_Button", 0)) or
        (A321 and _tl("VC_OVHD_FUEL_CTR_TK_2_VALVE_Button"))
     then
       VC_OVHD_FUEL_CTR_XFR_R_on()
	else
       VC_OVHD_FUEL_CTR_XFR_R_off()
	end
end

--

function VC_OVHD_FUEL_CTR_TFR_both_on ()
    VC_OVHD_FUEL_CTR_XFR_L_on ()
    _sleep(100,200)
    VC_OVHD_FUEL_CTR_XFR_R_on ()
end

function VC_OVHD_FUEL_CTR_TFR_both_off ()
    VC_OVHD_FUEL_CTR_XFR_L_off ()
    _sleep(100,200)
    VC_OVHD_FUEL_CTR_XFR_R_off ()
end

function VC_OVHD_FUEL_CTR_TFR_both_toggle ()
    VC_OVHD_FUEL_CTR_XFR_L_toggle ()
    _sleep(100,200)
    VC_OVHD_FUEL_CTR_XFR_R_toggle ()
end


-- $$ Right fuel Pumps

function VC_OVHD_FUEL_R_TK_1_PUMP_on ()
    if ipc.readLvar("VC_OVHD_FUEL_R_TK_1_PUMP_Button") == 0 then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: RPUMP1")
        else
            ipc.macro("FSLA3XX_MAIN: FUEL_R1")
        end
    end
    DspShow ("RPMP", "1 on")
    _sleep(50)
end

function VC_OVHD_FUEL_R_TK_1_PUMP_off ()
    if ipc.readLvar("VC_OVHD_FUEL_R_TK_1_PUMP_Button") ~= 0 then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: RPUMP1")
        else
            ipc.macro("FSLA3XX_MAIN: FUEL_R1")
        end
    end
    DspShow ("RPMP", "1off")
    _sleep(50)
end

function VC_OVHD_FUEL_R_TK_1_PUMP_toggle()
	if _tl("VC_OVHD_FUEL_R_TK_1_PUMP_Button", 0) then
       VC_OVHD_FUEL_R_TK_1_PUMP_on()
	else
       VC_OVHD_FUEL_R_TK_1_PUMP_off()
	end
end

--

function VC_OVHD_FUEL_R_TK_2_PUMP_on ()
    if ipc.readLvar("VC_OVHD_FUEL_R_TK_2_PUMP_Button") == 0 then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: RPUMP2")
        else
            ipc.macro("FSLA3XX_MAIN: FUEL_R2")
        end
    end
    DspShow ("RPMP", "2 on")
    _sleep(50)
end

function VC_OVHD_FUEL_R_TK_2_PUMP_off ()
    if ipc.readLvar("VC_OVHD_FUEL_R_TK_2_PUMP_Button") ~= 0 then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: RPUMP2")
        else
            ipc.macro("FSLA3XX_MAIN: FUEL_R2")
        end
    end
    DspShow ("RPMP", "2off")
    _sleep(50)
end

function VC_OVHD_FUEL_R_TK_2_PUMP_toggle()
	if _tl("VC_OVHD_FUEL_R_TK_2_PUMP_Button", 0) then
       VC_OVHD_FUEL_R_TK_2_PUMP_on()
	else
       VC_OVHD_FUEL_R_TK_2_PUMP_off()
	end
end

--

function VC_OVHD_FUEL_R_TK_both_PUMP_on ()
    VC_OVHD_FUEL_R_TK_1_PUMP_on ()
    _sleep(100,200)
    VC_OVHD_FUEL_R_TK_2_PUMP_on ()
end

function VC_OVHD_FUEL_R_TK_both_PUMP_off ()
    VC_OVHD_FUEL_R_TK_1_PUMP_off ()
    _sleep(100,200)
    VC_OVHD_FUEL_R_TK_2_PUMP_off ()
end

function VC_OVHD_FUEL_R_TK_both_PUMP_toggle ()
    VC_OVHD_FUEL_R_TK_1_PUMP_toggle ()
    _sleep(100,200)
    VC_OVHD_FUEL_R_TK_2_PUMP_toggle ()
end


-- $$ FUEL PUMPS ALL

function VC_OVHD_FUEL_ALL_PUMP_on ()
    VC_OVHD_FUEL_L_TK_both_PUMP_on ()
    _sleep(100,200)
    VC_OVHD_FUEL_CTR_TK_both_PUMP_on ()
    _sleep(100,200)
    VC_OVHD_FUEL_R_TK_both_PUMP_on ()
end

function VC_OVHD_FUEL_ALL_PUMP_off ()
    VC_OVHD_FUEL_L_TK_both_PUMP_off ()
    _sleep(100,200)
    VC_OVHD_FUEL_CTR_TK_both_PUMP_off ()
    _sleep(100,200)
    VC_OVHD_FUEL_R_TK_both_PUMP_off ()
end

function VC_OVHD_FUEL_ALL_PUMP_toggle ()
    VC_OVHD_FUEL_L_TK_both_PUMP_toggle ()
    _sleep(100,200)
    VC_OVHD_FUEL_CTR_TK_both_PUMP_toggle ()
    _sleep(100,200)
    VC_OVHD_FUEL_R_TK_both_PUMP_toggle ()
end

-- $$ FUEL XFEED

function VC_OVHD_FUEL_XFEED_on ()
    if ipc.readLvar("VC_OVHD_FUEL_XFEED_Button") == 0 then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: FUELXFEED")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED")
        end
    end
    DspShow ("XFED", "on")
    _sleep(50)
end

function VC_OVHD_FUEL_XFEED_off ()
    if ipc.readLvar("VC_OVHD_FUEL_XFEED_Button") ~= 0 then
        if not A321 then
            ipc.macro("FSLA3XX_MAIN: FUELXFEED")
        else
            ipc.macro("FSLA3XX_MAIN: XFEED")
        end
    end
    DspShow ("XFED", "off")
    _sleep(50)
end

function VC_OVHD_FUEL_XFEED_toggle()
	if _tl("VC_OVHD_FUEL_XFEED_Button", 0) then
       VC_OVHD_FUEL_XFEED_on()
	else
       VC_OVHD_FUEL_XFEED_off()
	end
end

-- $$ FUEL XFEED MODE SEL A321

function VC_OVHD_FUEL_XFEED_MODE_auto ()
    if ipc.readLvar("VC_OVHD_FUEL_MODE_SEL_Button") == 0 then
        if A321 then
            ipc.macro("FSLA3XX_MAIN: XFEED_MD")
        end
    end
    DspShow ("XFED", "on")
    _sleep(50)
end

function VC_OVHD_FUEL_XFEED_MODE_man ()
    if ipc.readLvar("VC_OVHD_FUEL_MODE_SEL_Button") ~= 0 then
        if A321 then
            ipc.macro("FSLA3XX_MAIN: XFEED_MD")
        end
    end
    DspShow ("XFED", "off")
    _sleep(50)
end

function VC_OVHD_FUEL_XFEED_MODE_toggle()
	if _tl("VC_OVHD_FUEL_MODE_SEL_Button", 0) then
       VC_OVHD_FUEL_XFEED_MODE_auto()
	else
       VC_OVHD_FUEL_XFEED_MODE_man()
	end
end



-- ## Overhead ELEC ###############

function VC_OVHD_ELECExtPwr_toggle()
local text1 = "Ext"
local text2 = "Pwr"
local Lvar = "VC_OVHD_ELEC_EXT_PWR_Button"
local mcro = "FSLA3XX_MAIN: ELECEXTPWR"
    VC_Button_press(text1, text2, Lvar, mcro)
end

--

function VC_OVHD_ELECBatt1_on()
    if ipc.readLvar("VC_OVHD_ELEC_BAT_1_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: ELECBatt1")
    end
    DspShow ("BAT1", "on")
end

function VC_OVHD_ELECBatt1_off()
    if ipc.readLvar("VC_OVHD_ELEC_BAT_1_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: ELECBatt1")
    end
    DspShow ("BAT1", "off")
end

function VC_OVHD_ELECBatt1_toggle()
	if _tl("VC_OVHD_ELEC_BAT_1_Button", 0) then
       VC_OVHD_ELECBatt1_on()
	else
       VC_OVHD_ELECBatt1_off()
	end
end

--

function VC_OVHD_ELECBatt2_on()
    if ipc.readLvar("VC_OVHD_ELEC_BAT_2_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: ELECBatt2")
    end
    DspShow ("BAT2", "on")
end

function VC_OVHD_ELECBatt2_off()
    if ipc.readLvar("VC_OVHD_ELEC_BAT_2_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: ELECBatt2")
    end
    DspShow ("BAT2", "off")
end

function VC_OVHD_ELECBatt2_toggle()
	if _tl("VC_OVHD_ELEC_BAT_2_Button", 0) then
       VC_OVHD_ELECBatt2_on()
	else
       VC_OVHD_ELECBatt2_off()
	end
end

function VC_OVHD_ELECBattBoth_on()
    VC_OVHD_ELECBatt1_on()
    ipc.sleep(50)
    VC_OVHD_ELECBatt2_on()
    ipc.sleep(50)
end

function VC_OVHD_ELECBattBoth_off()
    VC_OVHD_ELECBatt1_off()
    ipc.sleep(50)
    VC_OVHD_ELECBatt2_off()
    ipc.sleep(50)
end

function VC_OVHD_ELECBattBoth_toggle()
    VC_OVHD_ELECBatt1_toggle()
    ipc.sleep(50)
    VC_OVHD_ELECBatt2_toggle()
    ipc.sleep(50)
end

--

function VC_OVHD_ELECGen1_on()
    if ipc.readLvar("VC_OVHD_ELEC_GEN_1_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: ELECGEN1")
    end
    DspShow ("GEN1", "on")
end

function VC_OVHD_ELECGen1_off()
    if ipc.readLvar("VC_OVHD_ELEC_GEN_1_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: ELECGEN1")
    end
    DspShow ("GEN1", "off")
end

function VC_OVHD_ELECGen1_toggle()
	if ipc.readLvar("VC_OVHD_ELEC_GEN_1_Button") == 0 then
       VC_OVHD_ELECGen1_on()
	else
       VC_OVHD_ELECGen1_off()
	end
end

--

function VC_OVHD_ELECGen2_on()
    if ipc.readLvar("VC_OVHD_ELEC_GEN_2_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: ELECGEN2")
    end
    DspShow ("GEN2", "on")
end

function VC_OVHD_ELECGen2_off()
    if ipc.readLvar("VC_OVHD_ELEC_GEN_2_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: ELECGEN2")
    end
    DspShow ("GEN2", "off")
end

function VC_OVHD_ELECGen2_toggle()
	if _tl("VC_OVHD_ELEC_GEN_2_Button", 0) then
       VC_OVHD_ELECGen2_on()
	else
       VC_OVHD_ELECGen2_off()
	end
end

--

function VC_OVHD_ELECAPUGEN_on()
    if ipc.readLvar("VC_OVHD_ELEC_APU_GEN_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: ELECAPUGEN")
    end
    DspShow ("APUG", "on")
end

function VC_OVHD_ELECAPUGEN_off()
    if ipc.readLvar("VC_OVHD_ELEC_APU_GEN_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: ELECAPUGEN")
    end
    DspShow ("APUG", "off")
end

function VC_OVHD_ELECAPUGEN_toggle()
	if _tl("VC_OVHD_ELEC_APU_GEN_Button", 0) then
       VC_OVHD_ELECAPUGEN_on()
	else
       VC_OVHD_ELECAPUGEN_off()
	end
end

--

function VC_OVHD_ELECComm_on()
    if ipc.readLvar("VC_OVHD_ELEC_COMM_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: ELECCOMM")
    end
    DspShow ("COMM", "on")
end

function VC_OVHD_ELECComm_off()
    if ipc.readLvar("VC_OVHD_ELEC_COMM_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: ELECCOMM")
    end
    DspShow ("COMM", "off")
end

function VC_OVHD_ELECComm_toggle()
	if _tl("VC_OVHD_ELEC_COMM_Button", 0) then
       VC_OVHD_ELECComm_on()
	else
       VC_OVHD_ELECComm_off()
	end
end
--

function VC_OVHD_ELECGalyCab_on()
    if ipc.readLvar("VC_OVHD_ELEC_COMM_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: ELECGALYCAB")
    end
    DspShow ("GALY", "on")
end

function VC_OVHD_ELECGalyCab_off()
    if ipc.readLvar("VC_OVHD_ELEC_COMM_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: ELECGALYCAB")
    end
    DspShow ("GALY", "off")
end

function VC_OVHD_ELECGalyCab_toggle()
	if _tl("VC_OVHD_ELEC_COMM_Button", 0) then
       VC_OVHD_ELECGalyCab_on()
	else
       VC_OVHD_ELECGalyCab_off()
	end
end



-- ## Overhead APU ###############

function VC_OVHD_APU_Master_on()
    if ipc.readLvar("VC_OVHD_APU_Master_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: APUMaster")
        DspShow ("APUM", "on")
    end
end

function VC_OVHD_APU_Master_off()
    if ipc.readLvar("VC_OVHD_APU_Master_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: APUMaster")
        DspShow ("APUM", "off")
    end
end

function VC_OVHD_APU_Master_toggle()
	if _tl("VC_OVHD_APU_Master_Button", 0) then
       VC_OVHD_APU_Master_on()
	else
       VC_OVHD_APU_Master_off()
	end
end

--

function VC_OVHD_APU_Start_on()
    if ipc.readLvar("VC_OVHD_APU_Start_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: APUStart")
    DspShow ("APUS", "on")
    end
end

--

function VC_OVHD_APU_Bleed_on()
    if ipc.readLvar("VC_OVHD_AC_Eng_APU_Bleed_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: APUBleed")
    end
    DspShow ("APUB", "on")
end

function VC_OVHD_APU_Bleed_off()
    if ipc.readLvar("VC_OVHD_AC_Eng_APU_Bleed_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: APUBleed")
    end
    DspShow ("APUB", "off")
end

function VC_OVHD_APU_Bleed_toggle()
	if _tl("VC_OVHD_AC_Eng_APU_Bleed_Button", 0) then
       VC_OVHD_APU_Bleed_on()
	else
       VC_OVHD_APU_Bleed_off()
	end
end

-- ## Overhead ANTI ICE ###############

-- $$ Anti Ice WING

function VC_OVHD_AI_Wing_on()
    if ipc.readLvar("VC_OVHD_AI_Wing_Anti_Ice_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: AICEWing")
    end
    DspShow ("Wing", "on")
end

function VC_OVHD_AI_Wing_off()
    if ipc.readLvar("VC_OVHD_AI_Wing_Anti_Ice_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: AICEWing")
    end
    DspShow ("Wing", "off")
end

function VC_OVHD_AI_Wing_toggle()
	if _tl("VC_OVHD_AI_Wing_Anti_Ice_Button", 0) then
       VC_OVHD_AI_Wing_on()
	else
       VC_OVHD_AI_Wing_off()
	end
end

-- $$ Anti Ice ENGINES

function VC_OVHD_AI_Eng_1_on()
    if ipc.readLvar("VC_OVHD_AI_Eng_1_Anti_Ice_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: AICEEng1")
    end
    DspShow ("Eng1", "on")
end

function VC_OVHD_AI_Eng_1_off()
    if ipc.readLvar("VC_OVHD_AI_Eng_1_Anti_Ice_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: AICEEng1")
    end
    DspShow ("Eng1", "off")
end

function VC_OVHD_AI_Eng_1_toggle()
	if _tl("VC_OVHD_AI_Eng_1_Anti_Ice_Button", 0) then
       VC_OVHD_AI_Eng_1_on()
	else
       VC_OVHD_AI_Eng_1_off()
	end
end

--

function VC_OVHD_AI_Eng_2_on()
    if ipc.readLvar("VC_OVHD_AI_Eng_2_Anti_Ice_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: AICEEng2")
    end
    DspShow ("Eng2", "on")
end

function VC_OVHD_AI_Eng_2_off()
    if ipc.readLvar("VC_OVHD_AI_Eng_2_Anti_Ice_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: AICEEng2")
    end
    DspShow ("Eng2", "off")
end

function VC_OVHD_AI_Eng_2_toggle()
	if _tl("VC_OVHD_AI_Eng_2_Anti_Ice_Button", 0) then
       VC_OVHD_AI_Eng_2_on()
	else
       VC_OVHD_AI_Eng_2_off()
	end
end

function VC_OVHD_AI_Eng_both_on ()
    VC_OVHD_AI_Eng_1_on()
    VC_OVHD_AI_Eng_2_on()
end

function VC_OVHD_AI_Eng_both_off ()
    VC_OVHD_AI_Eng_1_off()
    VC_OVHD_AI_Eng_2_off()
end

function VC_OVHD_AI_Eng_both_toggle ()
    VC_OVHD_AI_Eng_1_toggle()
    VC_OVHD_AI_Eng_2_toggle()
end

-- $$ Anti Ice ALL

function VC_OVHD_AI_All_on()
    VC_OVHD_AI_Wing_on()
    VC_OVHD_AI_Eng_1_on()
    VC_OVHD_AI_Eng_2_on()
end

function VC_OVHD_AI_All_off()
    VC_OVHD_AI_Wing_off()
    VC_OVHD_AI_Eng_1_off()
    VC_OVHD_AI_Eng_2_off()
end

function VC_OVHD_AI_All_toggle()
    VC_OVHD_AI_Wing_toggle()
    VC_OVHD_AI_Eng_1_toggle()
    VC_OVHD_AI_Eng_2_toggle()
end

-- $$ Probe and Window

function VC_Probe_Window_Heat_on()
    if ipc.readLvar("VC_OVHD_Probe_Window_Heat_Button") == 0 then
        ipc.macro("FSLA3XX_MAIN: AICEwindow")
    end
    DspShow ("Wdow", "on")
end

function VC_Probe_Window_Heat_off()
    if ipc.readLvar("VC_OVHD_Probe_Window_Heat_Button") ~= 0 then
        ipc.macro("FSLA3XX_MAIN: AICEwindow")
    end
    DspShow ("Wdow", "off")
end

function VC_Probe_Window_Heat_toggle()
	if _tl("VC_OVHD_Probe_Window_Heat_Button", 0) then
       VC_Probe_Window_Heat_on()
	else
       VC_Probe_Window_Heat_off()
	end
end

-- ## External lights ###############

-- $$ strobe

function VC_OVHD_EXTLT_Strobe_show ()
    ipc.sleep(20)
    local SwVar = "VC_OVHD_EXTLT_Strobe_Switch"
    SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "auto"
    elseif SLT == 20 then SLTtxt = "on"
    end
    DspShow ("STRB", SLTtxt)
end

function VC_OVHD_EXTLT_Strobe_auto ()
    local SwVar = "VC_OVHD_EXTLT_Strobe_Switch"
    local VarInc = 72472
    local VarDec = 72471
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_EXTLT_Strobe_show ()
end

function VC_OVHD_EXTLT_Strobe_on ()
    local SwVar = "VC_OVHD_EXTLT_Strobe_Switch"
    local VarInc = 72472
    local VarDec = 72471
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_EXTLT_Strobe_show ()
end

function VC_OVHD_EXTLT_Strobe_off ()
    local SwVar = "VC_OVHD_EXTLT_Strobe_Switch"
    local VarInc = 72472
    local VarDec = 72471
    SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_EXTLT_Strobe_show ()
end

function VC_OVHD_EXTLT_Strobe_toggle ()
    local SwVar = "VC_OVHD_EXTLT_Strobe_Switch"
    local VarInc = 72472
    local VarDec = 72471
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_EXTLT_Strobe_show ()
end

-- $$ beacon

function VC_OVHD_EXTLT_Beacon_show ()
    ipc.sleep(20)
    local SwVar = "VC_OVHD_EXTLT_Beacon_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "on"
    end
    DspShow ("BCN", SLTtxt)
end

function VC_OVHD_EXTLT_Beacon_on ()
    local SwVar = "VC_OVHD_EXTLT_Beacon_Switch"
    local VarTogg = 72476
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarTogg)
    end
    VC_OVHD_EXTLT_Beacon_show ()
end

function VC_OVHD_EXTLT_Beacon_off ()
    local SwVar = "VC_OVHD_EXTLT_Beacon_Switch"
    local VarTogg = 72476
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarTogg)
    end
    VC_OVHD_EXTLT_Beacon_show ()
end

function VC_OVHD_EXTLT_Beacon_toggle ()
    local SwVar = "VC_OVHD_EXTLT_Beacon_Switch"
    local VarTogg = 72476
    ipc.control(FSL, VarTogg)
    VC_OVHD_EXTLT_Beacon_show ()
end

-- $$ wing

function VC_OVHD_EXTLT_Wing_show ()
    ipc.sleep(20)
    local SwVar = "VC_OVHD_EXTLT_Wing_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "on"
    end
    DspShow ("WING", SLTtxt)
end


function VC_OVHD_EXTLT_Wing_on ()
    local SwVar = "VC_OVHD_EXTLT_Wing_Switch"
    local VarTogg = 72481
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarTogg)
    end
    VC_OVHD_EXTLT_Wing_show ()
end

function VC_OVHD_EXTLT_Wing_off ()
    local SwVar = "VC_OVHD_EXTLT_Wing_Switch"
    local VarTogg = 72481
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarTogg)
    end
    VC_OVHD_EXTLT_Wing_show ()
end

function VC_OVHD_EXTLT_Wing_toggle ()
    SwVar = "VC_OVHD_EXTLT_Wing_Switch"
    VarTogg = 72481
        ipc.control(FSL, VarTogg)
    VC_OVHD_EXTLT_Wing_show ()
end

-- $$ Nav Logo

function VC_OVHD_EXTLT_NavLogo_show ()
    ipc.sleep(20)
    local SwVar = "VC_OVHD_EXTLT_NavLogo_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "nav"
    elseif SLT == 20 then SLTtxt = "logo"
    end
    DspShow ("NAV", SLTtxt)
end

function VC_OVHD_EXTLT_NavLogo_nav ()
    local SwVar = "VC_OVHD_EXTLT_NavLogo_Switch"
    local VarInc = 72487
    local VarDec = 72486
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_EXTLT_NavLogo_show ()
end

function VC_OVHD_EXTLT_NavLogo_logo ()
    local SwVar = "VC_OVHD_EXTLT_NavLogo_Switch"
    local VarInc = 72487
    local VarDec = 72486
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_EXTLT_NavLogo_show ()
end

function VC_OVHD_EXTLT_NavLogo_off ()
    local SwVar = "VC_OVHD_EXTLT_NavLogo_Switch"
    local VarInc = 72487
    local VarDec = 72486
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_EXTLT_NavLogo_show ()
end

function VC_OVHD_EXTLT_NavLogo_toggle ()
    local SwVar = "VC_OVHD_EXTLT_NavLogo_Switch"
    local VarInc = 72487
    local VarDec = 72486
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_EXTLT_NavLogo_show ()
end

-- $$ RWY lights

function VC_OVHD_EXTLT_RwyTurnoff_on ()
    local SwVar = "VC_OVHD_EXTLT_RwyTurnoff_Switch"
    local VarTogg = 72491
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarTogg)
        ipc.sleep(20)
    end
    VC_OVHD_EXTLT_RwyTurnoff_show ()
end

function VC_OVHD_EXTLT_RwyTurnoff_off ()
    local SwVar = "VC_OVHD_EXTLT_RwyTurnoff_Switch"
    local VarTogg = 72491
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarTogg)
        ipc.sleep(20)
    end
    VC_OVHD_EXTLT_RwyTurnoff_show ()
end

function VC_OVHD_EXTLT_RwyTurnoff_toggle ()
    local SwVar = "VC_OVHD_EXTLT_RwyTurnoff_Switch"
    local VarTogg = 72491
    ipc.control(FSL, VarTogg)
    ipc.sleep(20)
    VC_OVHD_EXTLT_RwyTurnoff_show ()
end

function VC_OVHD_EXTLT_RwyTurnoff_show ()
    ipc.sleep(20)
    local SwVar = "VC_OVHD_EXTLT_RwyTurnoff_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "on"
    end
    DspShow ("RWY", SLTtxt)
end

-- $$ LL left

function VC_OVHD_EXTLT_Land_L_show ()
    ipc.sleep(20)
    local SwVar = "VC_OVHD_EXTLT_Land_L_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "retr"
    elseif SLT == 10 then SLTtxt = "off"
    elseif SLT == 20 then SLTtxt = "on"
    end
    DspShow ("LL L", SLTtxt)
end

function VC_OVHD_EXTLT_Land_L_off ()
    local SwVar = "VC_OVHD_EXTLT_Land_L_Switch"
    local VarInc = 72497
    local VarDec = 72496
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Land_L_show ()
end

function VC_OVHD_EXTLT_Land_L_on ()

    local SwVar = "VC_OVHD_EXTLT_Land_L_Switch"
    local VarInc = 72497
    local VarDec = 72496
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Land_L_show ()
end

function VC_OVHD_EXTLT_Land_L_retr ()
    local SwVar = "VC_OVHD_EXTLT_Land_L_Switch"
    local VarInc = 72497
    local VarDec = 72496
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Land_L_show ()
end

function VC_OVHD_EXTLT_Land_L_cycle ()
    local SwVar = "VC_OVHD_EXTLT_Land_L_Switch"
    local VarInc = 72497
    local VarDec = 72496
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Land_L_show ()
end

function VC_OVHD_EXTLT_Land_L_toggle ()
    local SwVar = "VC_OVHD_EXTLT_Land_L_Switch"
    local VarInc = 72497
    local VarDec = 72496
    local SLT = ipc.readLvar(SwVar)
    if SLT > 0 then
        VC_OVHD_EXTLT_Land_L_retr ()
    else
        VC_OVHD_EXTLT_Land_L_on ()
    end
    ipc.sleep(20)
end

-- $$ LL right

function VC_OVHD_EXTLT_Land_R_show ()
    ipc.sleep(20)
    local SwVar = "VC_OVHD_EXTLT_Land_R_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "retr"
    elseif SLT == 10 then SLTtxt = "off"
    elseif SLT == 20 then SLTtxt = "on"
    end
    DspShow ("LL R", SLTtxt)
end

function VC_OVHD_EXTLT_Land_R_off ()
    local SwVar = "VC_OVHD_EXTLT_Land_R_Switch"
    local VarInc = 72507
    local VarDec = 72506
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Land_R_show ()
end

function VC_OVHD_EXTLT_Land_R_on ()
    local SwVar = "VC_OVHD_EXTLT_Land_R_Switch"
    local VarInc = 72507
    local VarDec = 72506
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Land_R_show ()
end

function VC_OVHD_EXTLT_Land_R_retr ()
    local SwVar = "VC_OVHD_EXTLT_Land_R_Switch"
    local VarInc = 72507
    local VarDec = 72506
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Land_R_show ()
end

function VC_OVHD_EXTLT_Land_R_cycle ()
    local SwVar = "VC_OVHD_EXTLT_Land_R_Switch"
    local VarInc = 72507
    local VarDec = 72506
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Land_R_show ()
end

function VC_OVHD_EXTLT_Land_R_toggle ()
    local SwVar = "VC_OVHD_EXTLT_Land_R_Switch"
    local VarInc = 72507
    local VarDec = 72506
    local SLT = ipc.readLvar(SwVar)
    if SLT > 0 then
        VC_OVHD_EXTLT_Land_R_retr ()
    else
        VC_OVHD_EXTLT_Land_R_on ()
    end
    ipc.sleep(20)
end

-- $$ LL Both

function VC_OVHD_EXTLT_LL_Both_off ()
    VC_OVHD_EXTLT_Land_L_off ()
    VC_OVHD_EXTLT_Land_R_off ()
end

function VC_OVHD_EXTLT_LL_Both_on ()
    VC_OVHD_EXTLT_Land_L_on ()
    VC_OVHD_EXTLT_Land_R_on ()
end

function VC_OVHD_EXTLT_LL_Both_retr ()
    VC_OVHD_EXTLT_Land_L_retr ()
    VC_OVHD_EXTLT_Land_R_retr ()
end

function VC_OVHD_EXTLT_LL_Both_toggle ()
    VC_OVHD_EXTLT_Land_L_toggle ()
    VC_OVHD_EXTLT_Land_R_toggle ()
end

function VC_OVHD_EXTLT_LL_Both_cycle ()
    VC_OVHD_EXTLT_Land_L_cycle ()
    VC_OVHD_EXTLT_Land_R_cycle ()
end

-- $$ Nose light

function VC_OVHD_EXTLT_Nose_off ()
    local SwVar = "VC_OVHD_EXTLT_Nose_Switch"
    local VarInc = 72512
    local VarDec = 72511
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Nose_show ()
end

function VC_OVHD_EXTLT_Nose_taxi ()
    local SwVar = "VC_OVHD_EXTLT_Nose_Switch"
    local VarInc = 72512
    local VarDec = 72511
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Nose_show ()
end

function VC_OVHD_EXTLT_Nose_takeoff ()
    local SwVar = "VC_OVHD_EXTLT_Nose_Switch"
    local VarInc = 72512
    local VarDec = 72511
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Nose_show ()
end

function VC_OVHD_EXTLT_Nose_on ()
    local SwVar = "VC_OVHD_EXTLT_Nose_Switch"
    local VarInc = 72512
    local VarDec = 72511
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Nose_show ()
end

function VC_OVHD_EXTLT_Nose_toggle ()
    local SwVar = "VC_OVHD_EXTLT_Nose_Switch"
    local VarInc = 72512
    local VarDec = 72511
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        VC_OVHD_EXTLT_Nose_on ()
    else
        VC_OVHD_EXTLT_Nose_off ()
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Nose_show ()
end

function VC_OVHD_EXTLT_Nose_cycle ()
    local SwVar = "VC_OVHD_EXTLT_Nose_Switch"
    local VarInc = 72512
    local VarDec = 72511
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    ipc.sleep(20)
    VC_OVHD_EXTLT_Nose_show ()
end

function VC_OVHD_EXTLT_Nose_show ()
    ipc.sleep(20)
    local SwVar = "VC_OVHD_EXTLT_Nose_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "taxi"
    elseif SLT == 20 then SLTtxt = "on"
    end
    DspShow ("NOSE", SLTtxt)
end

-- $$ All Taxi Lights

function VC_OVHD_EXTLT_Taxi_off()
    VC_OVHD_EXTLT_RwyTurnoff_off()
    VC_OVHD_EXTLT_Nose_off()
end

function VC_OVHD_EXTLT_Taxi_on()
    VC_OVHD_EXTLT_RwyTurnoff_on()
    VC_OVHD_EXTLT_Nose_on()
end

function VC_OVHD_EXTLT_Taxi_taxi()
    VC_OVHD_EXTLT_RwyTurnoff_on()
    VC_OVHD_EXTLT_Nose_taxi()
end

function VC_OVHD_EXTLT_Taxi_takeoff()
    VC_OVHD_EXTLT_RwyTurnoff_off()
    VC_OVHD_EXTLT_Nose_on()
end

-- ## Internal Lights ################

-- $$ Capt Map Table Integral

function GSLD_TABLE_CAPT_inc ()
    ipc.control(FSL, 71292)
    DspShow('GSLD','inc')
end

function GSLD_TABLE_CAPT_dec ()
    ipc.control(FSL, 71291)
    DspShow('GSLD','dec')
end

-- $$ FO Map Table Integral

function GSLD_TABLE_FO_inc ()
    ipc.control(FSL, 71299)
    DspShow('GSLD','inc')
end

function GSLD_TABLE_FO_dec ()
    ipc.control(FSL, 71298)
    DspShow('GSLD','dec')
end

-- $$ Glareshield Integral

function GSLD_PANEL_DIMM_L_inc ()
    ipc.control(FSL, 71278) -- v.244+ (v.243 71282)
    DspShow('GSLD','inc')
end

function GSLD_PANEL_DIMM_L_dec ()
    ipc.control(FSL, 71277) ---- v.244+ (v.243 71283)
    DspShow('GSLD','dec')
end

function GSLD_PANEL_DIMM_R_inc ()
    ipc.control(FSL, 71285)
    DspShow('GSLD','inc')
end

function GSLD_PANEL_DIMM_R_dec ()
    ipc.control(FSL, 71284)
    DspShow('GSLD','dec')
end

-- $$ FCU Display backlight

function GSLD_BACKLIGHT_inc ()
    ipc.control(FSL, 71289)
    DspShow('BLGT','inc')
end

function GSLD_BACKLIGHT_dec ()
    ipc.control(FSL, 71290)
    DspShow('BLGT','dec')
end

-- $$ Overhead Integral

function VC_OVHD_INTLT_Integ_Lt_Knob_inc ()
    ipc.control(FSL, 72528)
    DspShow('OVHD','inc')
end

function VC_OVHD_INTLT_Integ_Lt_Knob_dec ()
    ipc.control(FSL, 72529)
    DspShow('OVHD','dec')
end

-- $$ Pedestal Integral

function VC_PED_INTEG_LT_MainPnl_Knob_inc ()
    ipc.control(FSL, 78193) -- v.244+ (v.243 78134)
	DspShow('PED', 'inc')
end

function VC_PED_INTEG_LT_MainPnl_Knob_dec ()
    ipc.control(FSL, 78194) -- v.244+ (v.243 78133)
    DspShow('PED','dec')
end

-- $$ All Integral Lights

function ALL_PANEL_INTEG_LT_inc ()
    ipc.control(FSL, 71278) -- v.244+ (v.243 71282) -- GSLD_integral
    ipc.control(FSL, 72528) -- VC_OVHD_INTLT_Integ_Lt_Knob
    ipc.control(FSL, 78193) -- v.244+ (v.243 78134) -- VC_PED_INTEG_LT_MainPnl_Knob
    DspShow ("INTG", "inc")
end

function ALL_PANEL_INTEG_LT_dec ()
    ipc.control(FSL, 71277) -- v.244+ (v.243 71283) -- GSLD_integral
    ipc.control(FSL, 72529) -- VC_OVHD_INTLT_Integ_Lt_Knob
    ipc.control(FSL, 78194) -- v.244+ (v.243 78133) -- VC_PED_INTEG_LT_MainPnl_Knob
    DspShow ("INTG", "dec")
end

-- $$ Main Panel Flood

function Flood_MainPnl_inc ()
   ipc.control(FSL, 78186) -- v.244+ (v.243 78127)
   DspShow('FldM', 'inc')
end

function Flood_MainPnl_dec ()
   ipc.control(FSL, 78187) -- v.244+ (v.243 78126)
   DspShow('FldM', 'dec')
end

-- $$ Pedestal Flood

function Flood_Ped_inc ()
   ipc.control(FSL, 78197) -- v.244+ (v.243 78141)
   DspShow('FldP', 'inc')
end

function Flood_Ped_dec ()
   ipc.control(FSL, 78196) -- v.244+ (v.243 78140)
   DspShow('FldP', 'dec')
end

-- $$ Flood All

function Flood_ALL_inc ()
   ipc.control(FSL, 78186) -- v.244+ (v.243 78127) -- Flood_MainPnl_inc ()
   ipc.control(FSL, 78197) -- v.244+ (v.243 78141) -- Flood_Ped_inc ()
   ipc.control(FSL, 71296) -- MapLight_All_inc ()
   ipc.control(FSL, 71303)
   DspShow('FldA', 'inc')
end

function Flood_ALL_dec ()
   ipc.control(FSL, 78187) -- v.244+ (v.243 78126) -- Flood_MainPnl_dec ()
   ipc.control(FSL, 78196) -- v.244+ (v.243 78140) -- Flood_Ped_dec ()
   ipc.control(FSL, 71297) -- MapLight_Capt_dec ()
   ipc.control(FSL, 71304) -- MapLight_FO_dec ()
   DspShow('FldA', 'dec')
end

-- $$ Dome

function VC_OVHD_INTLT_Dome_dim ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_Dome_Switch")
    local VarInc = 72537
    local VarDec = 72536
    if DomeLT == 0 then
        ipc.control(FSL, 72537)
    elseif DomeLT == 20 then
        ipc.control(FSL, 72536)
    end
    DspShow ("DOME", "dim")
end

function VC_OVHD_INTLT_Dome_brt ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_Dome_Switch")
    local VarInc = 72537
    if DomeLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.control(FSL, VarInc)
    elseif DomeLT == 10 then
        ipc.control(FSL, VarInc)
    end
    DspShow ("DOME", "brt")
end

function VC_OVHD_INTLT_Dome_off ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_Dome_Switch")
    local VarDec = 72536
    if DomeLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.control(FSL, VarDec)
    elseif DomeLT == 10 then
        ipc.control(FSL, VarDec)
    end
    DspShow ("DOME", "off")
end

function VC_OVHD_INTLT_Dome_toggle ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_Dome_Switch")
    local VarInc = 72537
    local VarDec = 72536
    if DomeLT ~= 20 then
        VC_OVHD_INTLT_Dome_brt ()
    else
        VC_OVHD_INTLT_Dome_dim ()
    end
    DspShow ("DOME", "lght")
end

function VC_OVHD_INTLT_Dome_cycle ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_Dome_Switch")
    local VarInc = 72537
    local VarDec = 72536
    if DomeLT < 20 then
        ipc.control(FSL, VarInc)
    else
        VC_OVHD_INTLT_Dome_off ()
    end
    DspShow ("DOME", "lght")
end

-- ## Capt Displays

-- $$ Capt PFD

function CPT_PFD_BRT_Knob_inc ()
    local CPFD = math.floor((ipc.readLvar("VC_MIP_CPT_DU_PNL_PFD_BRT_Knob")/270)*100)
    ipc.control(FSL, 75023) -- CPT_PFD_BRT_Knob_inc
    DspShow ("PFDL", CPFD.."%", "PFD L", CPFD.."%")
end

function CPT_PFD_BRT_Knob_dec ()
    local CPFD = math.floor((ipc.readLvar("VC_MIP_CPT_DU_PNL_PFD_BRT_Knob")/270)*100)
    ipc.control(FSL, 75022) -- CPT_ND_BRT_Knob_dec
    DspShow ("PFDL", CPFD.."%", "PFD L", CPFD.."%")
end

function CPT_PFD_BRT_Knob_high ()
    local DispLvar = "VC_MIP_CPT_DU_PNL_PFD_BRT_Knob"
    local DspDec = 75022
    local DspInc = 75023
    local DimDispTrgt = (DimDispPzthigh/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
end

function CPT_PFD_BRT_Knob_med ()
    local DispLvar = "VC_MIP_CPT_DU_PNL_PFD_BRT_Knob"
    local DspDec = 75022
    local DspInc = 75023
    local DimDispTrgt = (DimDispPzt/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
end

function CPT_PFD_BRT_Knob_low ()
    local DispLvar = "VC_MIP_CPT_DU_PNL_PFD_BRT_Knob"
    local DspDec = 75022
    local DspInc = 75023
    local DimDispTrgt = (DimDispPztlow/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
end

-- $$ Capt ND

function CPT_ND_BRT_Knob_inc ()
    local CND = math.floor((ipc.readLvar("VC_MIP_CPT_DU_PNL_ND_BRT_Knob")/270)*100)
    ipc.control(FSL, 75005) --CPT_ND_BRT_Knob_inc
    DspShow ("ND L", CND.."%", "ND L", CND.."%")
end

function CPT_ND_BRT_Knob_dec ()
    local CND = math.floor((ipc.readLvar("VC_MIP_CPT_DU_PNL_ND_BRT_Knob")/270)*100)
    ipc.control(FSL, 75004) --CPT_ND_BRT_Knob_dec
    DspShow ("ND L", CND.."%", "ND L", CND.."%")
end

function CPT_ND_BRT_Knob_high ()
    local DispLvar = "VC_MIP_CPT_DU_PNL_ND_BRT_Knob"
    local DspDec = 75004
    local DspInc = 75005
    local DimDispTrgt = (DimDispPzthigh/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ND L', 'high')
end

function CPT_ND_BRT_Knob_med ()
    local DispLvar = "VC_MIP_CPT_DU_PNL_ND_BRT_Knob"
    local DspDec = 75004
    local DspInc = 75005
    local DimDispTrgt = (DimDispPzt/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ND L', 'med')
end

function CPT_ND_BRT_Knob_low ()
    local DispLvar = "VC_MIP_CPT_DU_PNL_ND_BRT_Knob"
    local DspDec = 75004
    local DspInc = 75005
    local DimDispTrgt = (DimDispPztlow/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ND L', 'low')
end

-- $$ Capt Weather Radar

function CPT_WX_BRT_Knob_inc ()
    local CWX = math.floor((ipc.readLvar("VC_MIP_CPT_DU_PNL_WX_BRT_Knob")/270)*100)
    ipc.control(FSL, 75012) --CPT_WX_BRT_Knob_inc
    DspShow ("WX L", CWX.."%", "WX L", CWX.."%")
end

function CPT_WX_BRT_Knob_dec ()
    local CWX = math.floor((ipc.readLvar("VC_MIP_CPT_DU_PNL_WX_BRT_Knob")/270)*100)
    ipc.control(FSL, 75011) --CPT_WX_BRT_Knob_dec
    DspShow ("WX L", CWX.."%", "WX L", CWX.."%")
end

function CPT_WX_BRT_Knob_high ()
    local DispLvar = "VC_MIP_CPT_DU_PNL_WX_BRT_Knob"
    local DspDec = 75011
    local DspInc = 75012
    local DimDispTrgt = (DimDispPzthigh/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('WX L', 'high')
end

function CPT_WX_BRT_Knob_med ()
    local DispLvar = "VC_MIP_CPT_DU_PNL_WX_BRT_Knob"
    local DspDec = 75011
    local DspInc = 75012
    local DimDispTrgt = (DimDispPzt/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('WX L', 'med')
end

function CPT_WX_BRT_Knob_low ()
    local DispLvar = "VC_MIP_CPT_DU_PNL_WX_BRT_Knob"
    local DspDec = 75011
    local DspInc = 75012
    local DimDispTrgt = (DimDispPztlow/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('WX L', 'low')
end

-- $$ Centre Display Upper

function PED_ECP_UP_BRT_Knob_inc ()
    local MUP = math.floor((ipc.readLvar("VC_PED_ECP_UP_DSP_LT_Knob")/270)*100)
    ipc.control(FSL, 77021)  --PED_ECP_UP_BRT_Knob_inc
    DspShow ("ECP^", MUP.."%", "ECP up", MUP.."%")
end

function PED_ECP_UP_BRT_Knob_dec ()
    local MUP = math.floor((ipc.readLvar("VC_PED_ECP_UP_DSP_LT_Knob")/270)*100)
    ipc.control(FSL, 77020) -- PED_ECP_UP_BRT_Knob_dec
    DspShow ("ECP^", MUP.."%", "ECP up", MUP.."%")
end

function PED_ECP_UP_BRT_Knob_high ()
    local DispLvar = "VC_PED_ECP_UP_DSP_LT_Knob"
    local DspDec = 77020
    local DspInc = 77021
    local DimDispTrgt = (DimDispPzthigh/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ECP^', 'high')
end

function PED_ECP_UP_BRT_Knob_med ()
    ipc.sleep(10)
    local DispLvar = "VC_PED_ECP_UP_DSP_LT_Knob"
    local DspDec = 77020
    local DspInc = 77021
    local DimDispTrgt = (DimDispPzt/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ECP^', 'med')
end

function PED_ECP_UP_BRT_Knob_low ()
    local DispLvar = "VC_PED_ECP_UP_DSP_LT_Knob"
    local DspDec = 77020
    local DspInc = 77021
    local DimDispTrgt = (DimDispPztlow/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ECP^', 'low')
end

-- $$ Centre Display Lower

function PED_ECP_LOW_BRT_Knob_inc ()
    local MLW = math.floor((ipc.readLvar("VC_PED_ECP_LR_DSP_LT_Knob")/270)*100)
    ipc.control(FSL, 77028) --PED_ECP_LOW_BRT_Knob_inc
    DspShow ("ECPv", MLW.."%", "ECP low", MLW.."%")
end

function PED_ECP_LOW_BRT_Knob_dec ()
    local MLW = math.floor((ipc.readLvar("VC_PED_ECP_LR_DSP_LT_Knob")/270)*100)
    ipc.control(FSL, 77027) --PED_ECP_LOW_BRT_Knob_dec
    DspShow ("ECPv", MLW.."%", "ECP low", MLW.."%")
end

function PED_ECP_LOW_BRT_Knob_high ()
    local DispLvar = "VC_PED_ECP_LR_DSP_LT_Knob"
    local DspDec = 77027
    local DspInc = 77028
    local DimDispTrgt = (DimDispPzthigh/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ECPv', 'high')
end

function PED_ECP_LOW_BRT_Knob_med ()
    local DispLvar = "VC_PED_ECP_LR_DSP_LT_Knob"
    local DspDec = 77027
    local DspInc = 77028
    local DimDispTrgt = (DimDispPzt/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ECPv', 'med')
end

function PED_ECP_LOW_BRT_Knob_low ()
    local DispLvar = "VC_PED_ECP_LR_DSP_LT_Knob"
    local DspDec = 77027
    local DspInc = 77028
    local DimDispTrgt = (DimDispPztlow/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ECPv', 'low')
end

-- ## FO Displays

-- $$ FO PFD

function FO_DU_PNL_PFD_BRT_Knob_inc ()
    local RPFD = math.floor((ipc.readLvar("VC_MIP_FO_DU_PNL_PFD_BRT_Knob")/270)*100)
    ipc.control(FSL, 75067) --FO_DU_PNL_PFD_BRT_Knob_inc
    DspShow ("RPFD", RPFD.."%", "PFD R", RPFD.."%")
end

function FO_DU_PNL_PFD_BRT_Knob_dec ()
    local RPFD = math.floor((ipc.readLvar("VC_MIP_FO_DU_PNL_PFD_BRT_Knob")/270)*100)
    ipc.control(FSL, 75066) --FO_DU_PNL_PFD_BRT_Knob_dec
    DspShow ("RPFD", RPFD.."%", "PFD R", RPFD.."%")
end

function FO_DU_PNL_PFD_BRT_Knob_high ()
    local DispLvar = "VC_MIP_FO_DU_PNL_PFD_BRT_Knob"
    local DspDec = 75066
    local DspInc = 75067
    local DimDispTrgt = (DimDispPzthigh/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('RPFD', 'high')
end

function FO_DU_PNL_PFD_BRT_Knob_med ()
    local DispLvar = "VC_MIP_FO_DU_PNL_PFD_BRT_Knob"
    local DspDec = 75066
    local DspInc = 75067
    local DimDispTrgt = (DimDispPzt/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('RPFD', 'med')
end

function FO_DU_PNL_PFD_BRT_Knob_low ()
    local DispLvar = "VC_MIP_FO_DU_PNL_PFD_BRT_Knob"
    local DspDec = 75066
    local DspInc = 75067
    local DimDispTrgt = (DimDispPztlow/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('RPFD', 'low')
end

-- $$ FO ND

function FO_DU_PNL_ND_BRT_Knob_inc ()
    local RND = math.floor((ipc.readLvar("VC_MIP_FO_DU_PNL_ND_BRT_Knob")/270)*100)
    ipc.control(FSL, 75049) --FO_DU_PNL_ND_BRT_Knob_inc
    DspShow ("ND R", RND.."%", "ND R", RND.."%")
end

function FO_DU_PNL_ND_BRT_Knob_dec ()
    local RND = math.floor((ipc.readLvar("VC_MIP_FO_DU_PNL_ND_BRT_Knob")/270)*100)
    ipc.control(FSL, 75048) --FO_DU_PNL_ND_BRT_Knob_dec
    DspShow ("ND R", RND.."%", "ND R", RND.."%")
end

function FO_DU_PNL_ND_BRT_Knob_high ()
    local DispLvar = "VC_MIP_FO_DU_PNL_ND_BRT_Knob"
    local DspDec = 75048
    local DspInc = 75049
    local DimDispTrgt = (DimDispPzthigh/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ND R', 'high')
end

function FO_DU_PNL_ND_BRT_Knob_med ()
    local DispLvar = "VC_MIP_FO_DU_PNL_ND_BRT_Knob"
    local DspDec = 75048
    local DspInc = 75049
    local DimDispTrgt = (DimDispPzt/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ND R', 'med')
end

function FO_DU_PNL_ND_BRT_Knob_low ()
    local DispLvar = "VC_MIP_FO_DU_PNL_ND_BRT_Knob"
    local DspDec = 75048
    local DspInc = 75049
    local DimDispTrgt = (DimDispPztlow/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('ND R', 'low')
end

-- $$ FO Weather Radar

function FO_DU_PNL_WX_BRT_Knob_inc ()
    local RWX = math.floor((ipc.readLvar("VC_MIP_FO_DU_PNL_WX_BRT_Knob")/270)*100)
    ipc.control(FSL, 75056) --FO_DU_PNL_WX_BRT_Knob_inc
    DspShow ("WX R", RWX.."%", "WXR R", RWX.."%")
end

function FO_DU_PNL_WX_BRT_Knob_dec ()
    local RWX = math.floor((ipc.readLvar("VC_MIP_FO_DU_PNL_WX_BRT_Knob")/270)*100)
    ipc.control(FSL, 75055)  --FO_DU_PNL_WX_BRT_Knob_dec
    DspShow ("WX R", RWX .."%", "WXR R", RWX.."%")
end

function FO_DU_PNL_WX_BRT_Knob_high ()
    local DispLvar = "VC_MIP_FO_DU_PNL_WX_BRT_Knob"
    local DspDec = 75055
    local DspInc = 75056
    local DimDispTrgt = (DimDispPzthigh/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('WX R', 'high')
end

function FO_DU_PNL_WX_BRT_Knob_med ()
    local DispLvar = "VC_MIP_FO_DU_PNL_WX_BRT_Knob"
    local DspDec = 75055
    local DspInc = 75056
    local DimDispTrgt = (DimDispPzt/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('WX R', 'med')
end

function FO_DU_PNL_WX_BRT_Knob_low ()
    local DispLvar = "VC_MIP_FO_DU_PNL_WX_BRT_Knob"
    local DspDec = 75055
    local DspInc = 75056
    local DimDispTrgt = (DimDispPztlow/100)*270
    local DispCurr = ipc.readLvar(DispLvar)
    while DispCurr > DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspDec)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    while DispCurr < DimDispTrgt do
        ipc.sleep(10)
        ipc.control(FSL, DspInc)
        ipc.sleep(10)
        DispCurr = ipc.readLvar(DispLvar)
    end
    DspShow('WX R', 'high')
end

-- $$ All PFD/ND/ECP/WX Dimmer

function ALL_DISP_DIMM_inc ()
    ipc.control(FSL, 75023) -- CPT_PFD_BRT_Knob_inc
    ipc.control(FSL, 75005) --CPT_ND_BRT_Knob_inc
    ipc.control(FSL, 77021)  --PED_ECP_UP_BRT_Knob_inc
    ipc.control(FSL, 77028) --PED_ECP_LOW_BRT_Knob_inc
    ipc.control(FSL, 75067) --FO_DU_PNL_PFD_BRT_Knob_inc
    ipc.control(FSL, 75049) --FO_DU_PNL_ND_BRT_Knob_inc
    ipc.control(FSL, 75012) --CPT_WX_BRT_Knob_inc
    ipc.control(FSL, 75056) --FO_DU_PNL_WX_BRT_Knob_inc
    DspShow ("DU", "inc")
end

function ALL_DISP_DIMM_dec ()
    ipc.control(FSL, 75022) -- CPT_ND_BRT_Knob_dec
    ipc.control(FSL, 75004) --CPT_ND_BRT_Knob_dec
    ipc.control(FSL, 77020) -- PED_ECP_UP_BRT_Knob_dec
    ipc.control(FSL, 77027) --PED_ECP_LOW_BRT_Knob_dec
    ipc.control(FSL, 75066) --FO_DU_PNL_PFD_BRT_Knob_dec
    ipc.control(FSL, 75048) --FO_DU_PNL_ND_BRT_Knob_dec
    ipc.control(FSL, 75011) --CPT_WX_BRT_Knob_dec
    ipc.control(FSL, 75055)  --FO_DU_PNL_WX_BRT_Knob_dec
    DspShow ("DU", "dec")
end

function ALL_DISP_DIMM_high ()
	CPT_PFD_BRT_Knob_high ()
	CPT_ND_BRT_Knob_high ()
	PED_ECP_UP_BRT_Knob_high ()
	PED_ECP_LOW_BRT_Knob_high ()
	FO_DU_PNL_ND_BRT_Knob_high ()
	FO_DU_PNL_PFD_BRT_Knob_high ()
	CPT_WX_BRT_Knob_high ()
	FO_DU_PNL_WX_BRT_Knob_high ()
end

function ALL_DISP_DIMM_med ()
	CPT_PFD_BRT_Knob_med ()
	CPT_ND_BRT_Knob_med ()
	PED_ECP_UP_BRT_Knob_med ()
	PED_ECP_LOW_BRT_Knob_med ()
	FO_DU_PNL_ND_BRT_Knob_med ()
	FO_DU_PNL_PFD_BRT_Knob_med ()
	CPT_WX_BRT_Knob_med ()
	FO_DU_PNL_WX_BRT_Knob_med ()
end

function ALL_DISP_DIMM_low ()
	CPT_PFD_BRT_Knob_low ()
	CPT_ND_BRT_Knob_low ()
	PED_ECP_UP_BRT_Knob_low ()
	PED_ECP_LOW_BRT_Knob_low ()
	FO_DU_PNL_ND_BRT_Knob_low ()
	FO_DU_PNL_PFD_BRT_Knob_low ()
	CPT_WX_BRT_Knob_low ()
	FO_DU_PNL_WX_BRT_Knob_low ()
end

-- $$ All Displays Dimmer without WX

function ALL_DISP_NOT_WX_DIMM_inc ()
    ipc.control(FSL, 75023) -- CPT_PFD_BRT_Knob_inc
    ipc.control(FSL, 75005) --CPT_ND_BRT_Knob_inc
    ipc.control(FSL, 77021)  --PED_ECP_UP_BRT_Knob_inc
    ipc.control(FSL, 77028) --PED_ECP_LOW_BRT_Knob_inc
    ipc.control(FSL, 75067) --FO_DU_PNL_PFD_BRT_Knob_inc
    ipc.control(FSL, 75049) --FO_DU_PNL_ND_BRT_Knob_inc
    DspShow ("DU", "inc")
end

function ALL_DISP_NOT_WX_DIMM_dec ()
    ipc.control(FSL, 75022) -- CPT_ND_BRT_Knob_dec
    ipc.control(FSL, 75004) --CPT_ND_BRT_Knob_dec
    ipc.control(FSL, 77020) -- PED_ECP_UP_BRT_Knob_dec
    ipc.control(FSL, 77027) --PED_ECP_LOW_BRT_Knob_dec
    ipc.control(FSL, 75066) --FO_DU_PNL_PFD_BRT_Knob_dec
    ipc.control(FSL, 75048) --FO_DU_PNL_ND_BRT_Knob_dec
    DspShow ("DU", "dec")
end

function ALL_DISP_NOT_WX_DIMM_high ()
	CPT_PFD_BRT_Knob_high ()
	CPT_ND_BRT_Knob_high ()
	PED_ECP_UP_BRT_Knob_high ()
	PED_ECP_LOW_BRT_Knob_high ()
	FO_DU_PNL_ND_BRT_Knob_high ()
	FO_DU_PNL_PFD_BRT_Knob_high ()
	CPT_WX_BRT_Knob_high ()
	FO_DU_PNL_WX_BRT_Knob_high ()
end

function ALL_DISP_NOT_WX_DIMM_med ()
	CPT_PFD_BRT_Knob_med ()
	CPT_ND_BRT_Knob_med ()
	PED_ECP_UP_BRT_Knob_med ()
	PED_ECP_LOW_BRT_Knob_med ()
	FO_DU_PNL_ND_BRT_Knob_med ()
	FO_DU_PNL_PFD_BRT_Knob_med ()
end

function ALL_DISP_NOT_WX_DIMM_low ()
	CPT_PFD_BRT_Knob_low ()
	CPT_ND_BRT_Knob_low ()
	PED_ECP_UP_BRT_Knob_low ()
	PED_ECP_LOW_BRT_Knob_low ()
	FO_DU_PNL_ND_BRT_Knob_low ()
	FO_DU_PNL_PFD_BRT_Knob_low ()
end

-- $$ Display Dimmer just WX

function ALL_WX_DISP_DIMM_inc ()
    ipc.control(FSL, 75012) --CPT_WX_BRT_Knob_inc
    ipc.control(FSL, 75056) --FO_DU_PNL_WX_BRT_Knob_inc
    DspShow ("DUWX", "inc")
end

function ALL_WX_DISP_DIMM_dec ()
    ipc.control(FSL, 75011) --CPT_WX_BRT_Knob_dec
    ipc.control(FSL, 75055)  --FO_DU_PNL_WX_BRT_Knob_dec
    DspShow ("DUWX", "dec")
end

function ALL_WX_DISP_DIMM_high ()
	CPT_WX_BRT_Knob_high ()
	FO_DU_PNL_WX_BRT_Knob_high ()
end

function ALL_WX_DISP_DIMM_med ()
	CPT_WX_BRT_Knob_med ()
	FO_DU_PNL_WX_BRT_Knob_med ()
end

function ALL_WX_DISP_DIMM_low ()
	CPT_WX_BRT_Knob_low ()
	FO_DU_PNL_WX_BRT_Knob_low ()
end

-- ## PFD / ND Transfer ###################

function VC_MIP_CPT_PFDND_XFR ()
    ipc.control(FSL, 75018)
    ipc.sleep(150)
    ipc.control(FSL, 75020)
    DspShow('PFND', 'XFR')
end

function VC_MIP_FO_PFDND_XFR ()
    ipc.control(FSL, 75062)
    ipc.sleep(150)
    ipc.control(FSL, 75064)
    DspShow('PFND', 'XFR')
end

-- ## Miscellaneous Lights

-- $$ Standby Compass

function VC_OVHD_INTL_StbyCompass_show ()
    local SwVar = "VC_OVHD_INTLT_StbyCompass_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 20 then SLTtxt = "on"
    end
    DspShow ("COMP", SLTtxt)
end

function VC_OVHD_INTL_StbyCompass_on ()
    local SwVar = "VC_OVHD_INTLT_StbyCompass_Switch"
    local VarInc = 72531
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_INTL_StbyCompass_show ()
end

function VC_OVHD_INTL_StbyCompass_off ()
    local SwVar = "VC_OVHD_INTLT_StbyCompass_Switch"
    local VarDec = 72532
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_INTL_StbyCompass_show ()
end

function VC_OVHD_INTL_StbyCompass_toggle ()
    local SwVar = "VC_OVHD_INTLT_StbyCompass_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        VC_OVHD_INTL_StbyCompass_on()
    else
        VC_OVHD_INTL_StbyCompass_off()
    end
end

-- $$ Ann Light

function VC_OVHD_INTLT_AnnLt_brt ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_AnnLt_Switch")
    local VarInc = 72542
    local VarDec = 72541
    if DomeLT == 0 then
        ipc.control(FSL, VarInc)
    elseif DomeLT == 20 then
        ipc.control(FSL, VarDec)
    end
    DspShow ("ANLT", "dim")
end

function VC_OVHD_INTLT_AnnLt_test ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_AnnLt_Switch")
    local VarInc = 72542
    if DomeLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.control(FSL, VarInc)
    elseif DomeLT == 10 then
        ipc.control(FSL, VarInc)
    end
    DspShow ("ANLT", "brt")
end

function VC_OVHD_INTLT_AnnLt_dim ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_AnnLt_Switch")
    local VarDec = 72541
    if DomeLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.control(FSL, VarDec)
    elseif DomeLT == 10 then
        ipc.control(FSL, VarDec)
    end
    DspShow ("ANLT", "off")
end

function VC_OVHD_INTLT_AnnLt_toggle ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_AnnLt_Switch")
    if DomeLT == 0 then
        VC_OVHD_INTLT_AnnLt_brt()
    else
        VC_OVHD_INTLT_AnnLt_dim()
    end
end

function VC_OVHD_INTLT_AnnLt_cycle ()
    local DomeLT = ipc.readLvar("VC_OVHD_INTLT_AnnLt_Switch")
    local VarInc = 72542
    if DomeLT < 20 then
        ipc.control(FSL, VarInc)
    else
        VC_OVHD_INTLT_AnnLt_dim()
    end
end

-- $$ Capt Map Light

function MapLight_CAPT_inc ()
   ipc.control(FSL, 76055) --71296)
   DspShow('MapC', 'inc')
end

function MapLight_CAPT_dec ()
   ipc.control(FSL, 76054) --71297)
   DspShow('MapC', 'dec')
end

-- $$ FO Maplight

function MapLight_FO_inc ()
   ipc.control(FSL, 76066) --71303)
   DspShow('MapF', 'inc')
end

function MapLight_FO_dec ()
   ipc.control(FSL, 76065) --71304)
   DspShow('MapF', 'dec')
end

-- $$ Maplight Both
function MapLight_All_inc ()
   ipc.control(FSL, 76055) --71296) -- MapLight_Capt_inc ()
   ipc.control(FSL, 76066) --71303) -- MapLight_FO_inc ()
   DspShow('MapA', 'inc')
end

function MapLight_All_dec ()
   ipc.control(FSL, 76054) --71297) -- MapLight_Capt_dec ()
   ipc.control(FSL, 76065) --71304) -- MapLight_FO_dec ()
   DspShow('MapA', 'dec')
end

-- $$ Capt Reading Light

function ReadingLight_CAPT_toggle ()
   ipc.control(FSL, 76050)
   DspShow('RedC', 'togl')
end

function ReadingLight_CAPT_inc ()
   ipc.control(FSL, 76059)
   DspShow('RedC', inc)
end

function ReadingLight_CAPT_dec ()
   ipc.control(FSL, 76060)
   DspShow('RedC', 'dec')
end

-- $$ FO Reading Light

function ReadingLight_FO_toggle ()
   ipc.control(FSL, 76061)
   DspShow('RedF', 'on')
end

function ReadingLight_FO_inc ()
   ipc.control(FSL, 76070)
   DspShow('RedF', inc)
end

function ReadingLight_FO_dec ()
   ipc.control(FSL, 76071)
   DspShow('RedF', 'dec')
end

-- ## Signs ###############

-- $$ Seatbelt Signs

function VC_OVHD_SIGNS_SeatBelts_show ()
    local SwVar = "VC_OVHD_SIGNS_SeatBelts_Switch"
    _sleep(50)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 20 then SLTtxt = "on"
    end
    DspShow ("SEAT", SLTtxt)
end

function VC_OVHD_SIGNS_SeatBelts_on ()
    local SwVar = "VC_OVHD_SIGNS_SeatBelts_Switch"
    local VarInc = 72547
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_SIGNS_SeatBelts_show ()
end

function VC_OVHD_SIGNS_SeatBelts_off ()
    local SwVar = "VC_OVHD_SIGNS_SeatBelts_Switch"
    local VarDec = 72546
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_SIGNS_SeatBelts_show ()
end

function VC_OVHD_SIGNS_SeatBelts_toggle ()
    local SwVar = "VC_OVHD_SIGNS_SeatBelts_Switch"
    local SLT = ipc.readLvar(SwVar)
    local VarInc = 72546
    if SLT == 0 then
        VC_OVHD_SIGNS_SeatBelts_on()
    else
        VC_OVHD_SIGNS_SeatBelts_off()
    end
end

-- $$ No Smoking Signs

function VC_OVHD_SIGNS_NoSmoking_show ()
    local SwVar = "VC_OVHD_SIGNS_NoSmoking_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "auto"
    elseif SLT == 20 then SLTtxt = "on"
    end
    DspShow ("SMKE", SLTtxt)
end

function VC_OVHD_SIGNS_NoSmoking_auto ()
    local SwVar = "VC_OVHD_SIGNS_NoSmoking_Switch"
    local VarInc = 72552
    local VarDec = 72551
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_SIGNS_NoSmoking_show ()
end

function VC_OVHD_SIGNS_NoSmoking_on ()
    local SwVar = "VC_OVHD_SIGNS_NoSmoking_Switch"
    local VarInc = 72552
    local VarDec = 72551
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_SIGNS_NoSmoking_show ()
end

function VC_OVHD_SIGNS_NoSmoking_off ()
    local SwVar = "VC_OVHD_SIGNS_NoSmoking_Switch"
    local VarInc = 72552
    local VarDec = 72551
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_SIGNS_NoSmoking_show ()
end

function VC_OVHD_SIGNS_NoSmoking_toggle ()
    local SwVar = "VC_OVHD_SIGNS_NoSmoking_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        VC_OVHD_SIGNS_NoSmoking_auto()
    else
        VC_OVHD_SIGNS_NoSmoking_off()
    end
end

function VC_OVHD_SIGNS_NoSmoking_cycle ()
    local SwVar = "VC_OVHD_SIGNS_NoSmoking_Switch"
    local VarInc = 72552
    local VarDec = 72551
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_SIGNS_NoSmoking_show ()
end

-- $$ emer exit light

function VC_OVHD_SIGNS_EmerExitLight_show ()
    local SwVar = "VC_OVHD_SIGNS_EmerExitLight_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "arm"
    elseif SLT == 20 then SLTtxt = "on"
    end
    DspShow ("EMER", SLTtxt)
end

function VC_OVHD_SIGNS_EmerExitLight_arm ()
    local SwVar = "VC_OVHD_SIGNS_EmerExitLight_Switch"
    local VarInc = 72557
    local VarDec = 72556
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_SIGNS_EmerExitLight_show ()
end

function VC_OVHD_SIGNS_EmerExitLight_on ()
    local SwVar = "VC_OVHD_SIGNS_EmerExitLight_Switch"
    local VarInc = 72557
    local VarDec = 72556
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_SIGNS_EmerExitLight_show ()
end

function VC_OVHD_SIGNS_EmerExitLight_off ()
    local SwVar = "VC_OVHD_SIGNS_EmerExitLight_Switch"
    local VarInc = 72557
    local VarDec = 72556
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_SIGNS_EmerExitLight_show ()
end

function VC_OVHD_SIGNS_EmerExitLight_toggle ()
    local SwVar = "VC_OVHD_SIGNS_EmerExitLight_Switch"
    local VarInc = 72557
    local VarDec = 72556
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_SIGNS_EmerExitLight_show ()
end

-- $$ Signs All

function VC_OVHD_SIGNS_All_on()
    VC_OVHD_SIGNS_SeatBelts_on()
    VC_OVHD_SIGNS_NoSmoking_on()
    VC_OVHD_SIGNS_EmerExitLight_arm()
end

function VC_OVHD_SIGNS_All_off()
    VC_OVHD_SIGNS_SeatBelts_off()
    VC_OVHD_SIGNS_NoSmoking_on()
    VC_OVHD_SIGNS_EmerExitLight_off()
end

function VC_OVHD_SIGNS_All_toggle()
    local SwVar = "VC_OVHD_SIGNS_SeatBelts_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        VC_OVHD_SIGNS_All_on()
    else
        VC_OVHD_SIGNS_All_off()
    end
end

-- ## ADIRS ###############

-- $$ adr1

function VC_OVHD_ADR1_toggle ()
local text1 = "ADR1"
local text2 = "on"
local Lvar = "VC_OVHD_ADR_1_Button"
local mcro = "FSLA3XX_MAIN: ADR1"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- $$ adr2

function VC_OVHD_ADR2_toggle ()
local text1 = "ADR2"
local text2 = "on"
local Lvar = "VC_OVHD_ADR_2_Button"
local mcro = "FSLA3XX_MAIN: ADR2"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- $$ adr3

function VC_OVHD_ADR3_toggle ()
local text1 = "ADR3"
local text2 = "on"
local Lvar = "VC_OVHD_ADR_3_Button"
local mcro = "FSLA3XX_MAIN: ADR3"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- $$ adirs 1

function VC_OVHD_ADIRS_1_show ()
    ipc.sleep(10)
    local SwVar = "VC_OVHD_ADIRS_1_Knob"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "nav"
    elseif SLT == 20 then SLTtxt = "att"
    end
    DspShow ("IR 1", SLTtxt, "ADIRS 1", SLTtxt)
end

function VC_OVHD_ADIRS_1_off ()
    SwVar = "VC_OVHD_ADIRS_1_Knob"
    local VarInc = 72001
    local VarDec = 72000
    SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_ADIRS_1_show ()
end

function VC_OVHD_ADIRS_1_nav ()
    local SwVar = "VC_OVHD_ADIRS_1_Knob"
    local VarInc = 72001
    local VarDec = 72000
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_ADIRS_1_show ()
end

function VC_OVHD_ADIRS_1_att ()
    local SwVar = "VC_OVHD_ADIRS_1_Knob"
    local VarInc = 72001
    local VarDec = 72000
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_ADIRS_1_show ()
end

function VC_OVHD_ADIRS_1_cycle ()
    local SwVar = "VC_OVHD_ADIRS_1_Knob"
    local VarInc = 72001
    local VarDec = 72000
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_ADIRS_1_show ()
end

-- $$ adirs 2

function VC_OVHD_ADIRS_2_show ()
    ipc.sleep(10)
    local SwVar = "VC_OVHD_ADIRS_2_Knob"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "nav"
    elseif SLT == 20 then SLTtxt = "att"
    end
    DspShow ("IR 2", SLTtxt, "ADIRS 2", SLTtxt)
end

function VC_OVHD_ADIRS_2_off ()
    local SwVar = "VC_OVHD_ADIRS_2_Knob"
    local VarInc = 72006
    local VarDec = 72005
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_ADIRS_2_show ()
end

function VC_OVHD_ADIRS_2_nav ()
    local SwVar = "VC_OVHD_ADIRS_2_Knob"
    local VarInc = 72006
    local VarDec = 72005
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_ADIRS_2_show ()
end

function VC_OVHD_ADIRS_2_att ()
    local SwVar = "VC_OVHD_ADIRS_2_Knob"
    local VarInc = 72006
    local VarDec = 72005
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_ADIRS_2_show ()
end

function VC_OVHD_ADIRS_2_cycle ()
    local SwVar = "VC_OVHD_ADIRS_2_Knob"
    local VarInc = 72006
    local VarDec = 72005
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_ADIRS_2_show ()
end

-- $$ adirs 3

function VC_OVHD_ADIRS_3_show ()
    ipc.sleep(10)
    local SwVar = "VC_OVHD_ADIRS_3_Knob"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "nav"
    elseif SLT == 20 then SLTtxt = "att"
    end
    DspShow ("IR 3", SLTtxt, "ADIRS 3", SLTtxt)
end

function VC_OVHD_ADIRS_3_off ()
    local SwVar = "VC_OVHD_ADIRS_3_Knob"
    local VarInc = 72011
    local VarDec = 72010
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_ADIRS_3_show ()
end

function VC_OVHD_ADIRS_3_nav ()
    local SwVar = "VC_OVHD_ADIRS_3_Knob"
    local VarInc = 72011
    local VarDec = 72010
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_ADIRS_3_show ()
end

function VC_OVHD_ADIRS_3_att ()
    local SwVar = "VC_OVHD_ADIRS_3_Knob"
    local VarInc = 72011
    local VarDec = 72010
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_ADIRS_3_show ()
end

function VC_OVHD_ADIRS_3_cycle ()
    local SwVar = "VC_OVHD_ADIRS_3_Knob"
    local VarInc = 72011
    local VarDec = 72010
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_ADIRS_3_show ()
end

-- $$ All ADIRS

function VC_OVHD_ADIRS_ALL_off ()
    VC_OVHD_ADIRS_1_off ()
    _sleep(200, 500)
    VC_OVHD_ADIRS_3_off ()
    _sleep(200, 500)
    VC_OVHD_ADIRS_2_off ()
end

function VC_OVHD_ADIRS_ALL_nav ()
    VC_OVHD_ADIRS_1_nav ()
    _sleep(200, 500)
    VC_OVHD_ADIRS_3_nav ()
    _sleep(200, 500)
    VC_OVHD_ADIRS_2_nav ()
end

function VC_OVHD_ADIRS_ALL_att ()
    VC_OVHD_ADIRS_1_att ()
    _sleep(200, 500)
    VC_OVHD_ADIRS_3_att ()
    _sleep(200, 500)
    VC_OVHD_ADIRS_2_att ()
end

function VC_OVHD_ADIRS_ALL_cycle ()
    VC_OVHD_ADIRS_1_cycle ()
    _sleep(200, 500)
    VC_OVHD_ADIRS_3_cycle ()
    _sleep(200, 500)
    VC_OVHD_ADIRS_2_cycle ()
end

-- ## Overhead Cabin Pressure

function VC_OVHD_CABPRESS_MAN_VS_up ()
    ipc.control(FSL, 72448)
    ipc.sleep(150)
    ipc.control(FSL, 72450)
    DspShow('CABP', 'UP')
end

function VC_OVHD_CABPRESS_MAN_VS_dn ()
    ipc.control(FSL, 72447)
    ipc.sleep(150)
    ipc.control(FSL, 72449)
    DspShow('CABP', 'DOWN')
end

function VC_OVHD_CABPRESS_MODE_show ()
    ipc.sleep(10)
    local SwVar = "VC_OVHD_CABPRESS_Ldg_Elev_Knob"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "Auto"
    elseif SLT == 12 then SLTtxt = "-2"
    elseif SLT <= 7 then SLTtxt = "-1"
    elseif SLT <= 55 then SLTtxt = " 0"
    elseif SLT <= 73 then SLTtxt = " 1"
    elseif SLT <= 89 then SLTtxt = " 2"
    elseif SLT <= 107 then SLTtxt = " 3"
    elseif SLT <= 125 then SLTtxt = " 4"
    elseif SLT <= 145 then SLTtxt = " 5"
    elseif SLT <= 163 then SLTtxt = " 6"
    elseif SLT <= 183 then SLTtxt = " 7"
    elseif SLT <= 201 then SLTtxt = " 8"
    elseif SLT <= 221 then SLTtxt = " 9"
    elseif SLT <= 237 then SLTtxt = "10"
    elseif SLT <= 253 then SLTtxt = "11"
    elseif SLT <= 271 then SLTtxt = "12"
    elseif SLT <= 286 then SLTtxt = "13"
    elseif SLT <= 300 then SLTtxt = "14"
    end
    DspShow ("LDEL", SLTtxt, "ATT HDG", SLTtxt)
end

function VC_OVHD_CABPRESS_MODE_inc ()
    local SwVar = "VC_OVHD_CABPRESS_Ldg_Elev_Knob"
    local SLT = ipc.readLvar(SwVar)
    local VarInc = 72457
    local i
    _loggg('[A320] Cab Press inc ' .. SLT)
    if SLT > 296 then return end
    if SLT <= 296 then
        ipc.control(FSL, VarInc)
    end
    VC_OVHD_CABPRESS_MODE_show()
end

function VC_OVHD_CABPRESS_MODE_dec ()
    local SwVar = "VC_OVHD_CABPRESS_Ldg_Elev_Knob"
    local SLT = ipc.readLvar(SwVar)
    local VarDec = 72456
    local i
    _loggg('[A320] Cab Press dec ' .. SLT)
    if SLT == 0 then return end
    if SLT > 0 then
        ipc.control(FSL, VarDec)
    end
    VC_OVHD_CABPRESS_MODE_show()
end

-- ## Pedestal ECP SWITCHES ###############

-- $$ ECP Switching ATT HDG

function VC_PED_SWITCH_ATT_HDG_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_SWITCH_ATT_HDG_Knob"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "Capt"
    elseif SLT == 10 then SLTtxt = "Norm"
    elseif SLT == 20 then SLTtxt = "F/O"
    end
    DspShow ("AHDG", SLTtxt, "ATT HDG", SLTtxt)
end

function VC_PED_SWITCH_ATT_HDG_capt ()
    local SwVar = "VC_PED_SWITCH_ATT_HDG_Knob"
    local VarInc = 77001
    local VarDec = 77000
    local SLT = ipc.readLvar(SwVar)
    _loggg('[A320X] ATT HDG=' .. tostring(SLT))
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_ATT_HDG_show ()
end

function VC_PED_SWITCH_ATT_HDG_norm ()
    local SwVar = "VC_PED_SWITCH_ATT_HDG_Knob"
    local VarInc = 77001
    local VarDec = 77000
    local SLT = ipc.readLvar(SwVar)
    _loggg('[A320X] ATT HDG=' .. tostring(SLT))
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_ATT_HDG_show ()
end

function VC_PED_SWITCH_ATT_HDG_fo ()
    local SwVar = "VC_PED_SWITCH_ATT_HDG_Knob"
    local VarInc = 77001
    local VarDec = 77000
    local SLT = ipc.readLvar(SwVar)
    _loggg('[A320X] ATT HDG=' .. tostring(SLT))
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_SWITCH_ATT_HDG_show ()
end

function VC_PED_SWITCH_ATT_HDG_cycle ()
    local SwVar = "VC_PED_SWITCH_ATT_HDG_Knob"
    local VarInc = 77001
    local VarDec = 77000
    local SLT = ipc.readLvar(SwVar)
    _loggg('[A320X] ATT HDG=' .. tostring(SLT))
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_ATT_HDG_show ()
end

-- $$ ECP Switching AIR DATA

function VC_PED_SWITCH_AIR_DATA_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_SWITCH_AIR_DATA_Knob"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "Capt"
    elseif SLT == 10 then SLTtxt = "Norm"
    elseif SLT == 20 then SLTtxt = "F/O"
    end
    DspShow ("ADAT", SLTtxt, "AIR DATA", SLTtxt)
end

function VC_PED_SWITCH_AIR_DATA_capt ()
    local SwVar = "VC_PED_SWITCH_AIR_DATA_Knob"
    local VarInc = 77006
    local VarDec = 77005
    local SLT = ipc.readLvar(SwVar)
    _loggg('[A320X] ATT HDG=' .. tostring(SLT))
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_AIR_DATA_show ()
end

function VC_PED_SWITCH_AIR_DATA_norm ()
    local SwVar = "VC_PED_SWITCH_AIR_DATA_Knob"
    local VarInc = 77006
    local VarDec = 77005
    local SLT = ipc.readLvar(SwVar)
    _loggg('[A320X] AIR DATA=' .. tostring(SLT))
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_AIR_DATA_show ()
end

function VC_PED_SWITCH_AIR_DATA_fo ()
    local SwVar = "VC_PED_SWITCH_AIR_DATA_Knob"
    local VarInc = 77006
    local VarDec = 77005
    local SLT = ipc.readLvar(SwVar)
    _loggg('[A320X] AIR DATA=' .. tostring(SLT))
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_SWITCH_AIR_DATA_show ()
end

function VC_PED_SWITCH_AIR_DATA_cycle ()
    local SwVar = "VC_PED_SWITCH_AIR_DATA_Knob"
    local VarInc = 77006
    local VarDec = 77005
    local SLT = ipc.readLvar(SwVar)
    _loggg('[A320X] AIR DATA=' .. tostring(SLT))
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_AIR_DATA_show ()
end

-- $$ ECP Switching EIS DMC

function VC_PED_SWITCH_EIS_DMC_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_SWITCH_EIS_DMC_Knob"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "Capt"
    elseif SLT == 10 then SLTtxt = "Norm"
    elseif SLT == 20 then SLTtxt = "F/O"
    end
    DspShow ("EDMC", SLTtxt, "EIS DMC", SLTtxt)
end

function VC_PED_SWITCH_EIS_DMC_capt ()
    local SwVar = "VC_PED_SWITCH_EIS_DMC_Knob"
    local VarInc = 77011
    local VarDec = 77010
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_EIS_DMC_show ()
end

function VC_PED_SWITCH_EIS_DMC_norm ()
    local SwVar = "VC_PED_SWITCH_EIS_DMC_Knob"
    local VarInc = 77011
    local VarDec = 77010
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_EIS_DMC_show ()
end

function VC_PED_SWITCH_EIS_DMC_fo ()
    local SwVar = "VC_PED_SWITCH_EIS_DMC_Knob"
    local VarInc = 77011
    local VarDec = 77010
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_SWITCH_EIS_DMC_show ()
end

function VC_PED_SWITCH_EIS_DMC_cycle ()
    local SwVar = "VC_PED_SWITCH_EIS_DMC_Knob"
    local VarInc = 77011
    local VarDec = 77010
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_EIS_DMC_show ()
end

-- $$ ECP Switching ECAM ND

function VC_PED_SWITCH_ECAM_ND_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_SWITCH_ECAM_ND_Knob"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "Capt"
    elseif SLT == 10 then SLTtxt = "Norm"
    elseif SLT == 20 then SLTtxt = "F/O"
    end
    DspShow ("ECND", SLTtxt, "ECAM ND", SLTtxt)
end

function VC_PED_SWITCH_ECAM_ND_capt ()
    local SwVar = "VC_PED_SWITCH_ECAM_ND_Knob"
    local VarInc = 77016
    local VarDec = 77015
    SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_ECAM_ND_show ()
end

function VC_PED_SWITCH_ECAM_ND_norm ()
    local SwVar = "VC_PED_SWITCH_ECAM_ND_Knob"
    local VarInc = 77016
    local VarDec = 77015
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_ECAM_ND_show ()
end

function VC_PED_SWITCH_ECAM_ND_fo ()
    local SwVar = "VC_PED_SWITCH_ECAM_ND_Knob"
    local VarInc = 77016
    local VarDec = 77015
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_SWITCH_ECAM_ND_show ()
end

function VC_PED_SWITCH_ECAM_ND_cycle ()
    local SwVar = "VC_PED_SWITCH_ECAM_ND_Knob"
    local VarInc = 77016
    local VarDec = 77015
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_PED_SWITCH_ECAM_ND_show ()
end

-- $$ ECP buttons

function VC_PED_ECP_EMERCANC ()
    ipc.control(FSL, 77040)
    ipc.sleep(200)
    ipc.control(FSL, 77043)
    ipc.sleep(100)
    ipc.control(FSL, 77045)
    ipc.sleep(200)
    ipc.control(FSL, 77046)
    DspShow("EMER", "CANC")
end

function VC_PED_ECP_TOCFG () 
    ipc.control(FSL, 77034)
    ipc.sleep(50)
    ipc.control(FSL, 77036)
    DspShow ("TO", "CFG")
end

function VC_PED_ECP_ENG ()
    ipc.control(FSL, 77048)
    ipc.sleep(50)
    ipc.control(FSL, 77050)
    DspShow ("ECP", "ENG")
end

function VC_PED_ECP_BLEED ()
    ipc.control(FSL, 77053)
    ipc.sleep(50)
    ipc.control(FSL, 77055)
    DspShow ("ECP", "BLED", "ECP", "BLEED")
end

function VC_PED_ECP_PRESS ()
    ipc.control(FSL, 77058)
    ipc.sleep(50)
    ipc.control(FSL, 77060)
    DspShow ("ECP", "PRSS", "ECP", "PRESS")
end

function VC_PED_ECP_ELEC ()
    ipc.control(FSL, 77063)
    ipc.sleep(50)
    ipc.control(FSL, 77065)
    DspShow ("ECP", "ELEC", "ECP", "ELEC")
end

function VC_PED_ECP_HYD ()
    ipc.control(FSL, 77068)
    ipc.sleep(50)
    ipc.control(FSL, 77070)
    DspShow ("ECP", "HYD", "ECP", "HYD")
end

function VC_PED_ECP_FUEL ()
    ipc.control(FSL, 77073)
    ipc.sleep(50)
    ipc.control(FSL, 77075)
    DspShow ("ECP", "FUEL", "ECP", "FUEL")
end

function VC_PED_ECP_APU ()
    ipc.control(FSL, 77078)
    ipc.sleep(50)
    ipc.control(FSL, 77080)
    DspShow ("ECP", "APU", "ECP", "APU")
end

function VC_PED_ECP_COND ()
    ipc.control(FSL, 77083)
    ipc.sleep(50)
    ipc.control(FSL, 77085)
    DspShow ("ECP", "COND", "ECP", "COND")
end

function VC_PED_ECP_DOOR ()
    ipc.control(FSL, 77088)
    ipc.sleep(250)
    ipc.control(FSL, 77090)
    DspShow ("ECP", "DOOR", "ECP", "DOOR")
end

function VC_PED_ECP_WHEEL ()
    ipc.control(FSL, 77093)
    ipc.sleep(50)
    ipc.control(FSL, 77095)
    DspShow ("ECP", "WHEL", "ECP", "WHEEL")
end

function VC_PED_ECP_FCTL ()
    ipc.control(FSL, 77098)
    ipc.sleep(50)
    ipc.control(FSL, 77100)
    DspShow ("ECP", "FCTR", "ECP", "FCTRL")
end

function VC_PED_ECP_ALL ()
    ipc.control(FSL, 77103)
    ipc.sleep(50)
    ipc.control(FSL, 77105)
    DspShow ("ECP", "ALL", "ECP", "ALL")
end

function VC_PED_ECP_CLR ()
    ipc.control(FSL, 77108)
    ipc.sleep(50)
    ipc.control(FSL, 77110)
    DspShow ("ECP", "CLR", "ECP", "CLR")
end

function VC_PED_ECP_STS ()
    ipc.control(FSL, 77113)
    ipc.sleep(50)
    ipc.control(FSL, 77115)
    DspShow ("ECP", "STS", "ECP", "STS")
end

function VC_PED_ECP_RCL ()
    ipc.control(FSL, 77118)
    ipc.sleep(50)
    ipc.control(FSL, 77120)
    DspShow ("ECP", "RCL", "ECP", "RCL")
end

function VC_PED_ECP_SYS ()   -- covers mispelling
    VC_PED_ECP_STS()
end

-- ## Auto Brake and Brake Fan

function VC_MIP_BRAKES_ABRK_inc()
    FSL_ABRK_var = ipc.get("FSL_ABRK_var")
    if FSL_ABRK_var == nil then FSL_ABRK_var = 0 end
    if FSL_ABRK_var == 0 then
        VC_MIP_BRAKES_ABRK_LO_toggle()
        ipc.set("FSL_ABRK_var", 1)
    elseif FSL_ABRK_var == 1 then
        VC_MIP_BRAKES_ABRK_MED_toggle()
        ipc.set("FSL_ABRK_var", 2)
    elseif FSL_ABRK_var == 2 then
        VC_MIP_BRAKES_ABRK_MAX_toggle()
        ipc.set("FSL_ABRK_var", 3)
    elseif FSL_ABRK_var == 3 then
        VC_MIP_BRAKES_ABRK_MAX_toggle()
        ipc.set("FSL_ABRK_var", 0)
    end
end

function VC_MIP_BRAKES_ABRK_dec()
    FSL_ABRK_var = ipc.get("FSL_ABRK_var")
    if FSL_ABRK_var == nil then FSL_ABRK_var = 0 end
    if FSL_ABRK_var == 0 then
        VC_MIP_BRAKES_ABRK_MAX_toggle()
        ipc.set("FSL_ABRK_var", 3)
    elseif FSL_ABRK_var == 3 then
        VC_MIP_BRAKES_ABRK_MED_toggle()
        ipc.set("FSL_ABRK_var", 2)
    elseif FSL_ABRK_var == 2 then
        VC_MIP_BRAKES_ABRK_LO_toggle()
        ipc.set("FSL_ABRK_var", 1)
    elseif FSL_ABRK_var == 1 then
        VC_MIP_BRAKES_ABRK_LO_toggle()
        ipc.set("FSL_ABRK_var", 0)
    end
end

-- $$ Auto Brake Low

function VC_MIP_BRAKES_ABRK_LO_toggle()
local text1 = "ABRK"
local text2 = "LO"
local Lvar = "VC_MIP_BRAKES_AUTOBRK_LO_Button"
local mcro = "FSLA3XX_MAIN: ABRKLO"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- $$ Auto Brake Medium

function VC_MIP_BRAKES_ABRK_MED_toggle()
local text1 = "ABRK"
local text2 = "MED"
local Lvar = "VC_MIP_BRAKES_AUTOBRK_MED_Button"
local mcro = "FSLA3XX_MAIN: ABRKMED"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- $$ Auto Brake Max

function VC_MIP_BRAKES_ABRK_MAX_toggle()
local text1 = "ABRK"
local text2 = "MAX"
local Lvar = "VC_MIP_BRAKES_AUTOBRK_MAX_Button"
local mcro = "FSLA3XX_MAIN: ABRKHI"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- $$ Brakes Fan

function VC_MIP_BRAKES_FAN_on()
local lab = "BFAN"
local Lvar = "VC_MIP_BRAKES_FAN_Button"
local mcro = "FSLA3XX_MAIN: BRKFAN"
    if ipc.readLvar(Lvar) == 0 then
        ipc.macro(mcro, 3)
    end
    DspShow (lab, "on")
end

function VC_MIP_BRAKES_FAN_off()
local lab = "BFAN"
local Lvar = "VC_MIP_BRAKES_FAN_Button"
local mcro = "FSLA3XX_MAIN: BRKFAN"
    if ipc.readLvar(Lvar) ~= 0 then
        ipc.macro(mcro, 3)
    end
    DspShow (lab, "off")
end

function VC_MIP_BRAKES_FAN_toggle()
	if _tl("VC_MIP_BRAKES_FAN_Button", 0) then
       VC_MIP_BRAKES_FAN_on()
	else
       VC_MIP_BRAKES_FAN_off()
	end
end

-- ## Anti Skid and NW Steering

function VC_MIP_BRAKES_ASKID_on ()
    if ipc.readLvar('VC_MIP_BRAKES_ASKID_button') == 0 then
        ipc.control(FSL, 75171)
        DspShow('SKID', 'on')
    end
end

function VC_MIP_BRAKES_ASKID_off ()
    if ipc.readLvar('VC_MIP_BRAKES_ASKID_button') == 10 then
        ipc.control(FSL, 75172)
        DspShow('SKID', 'off')
    end
end

function VC_MIP_BRAKES_ASKID_toggle ()
    if ipc.readLvar('VC_MIP_BRAKES_ASKID_button') > 0 then
        VC_MIP_BRAKES_ASKID_off ()
    else
        VC_MIP_BRAKES_ASKID_on ()
    end
end

-- ## Trimming ###############################################

-- $$ Elevator Trim Wheel

function VC_PED_TRIM_WHEEL_show ()
    local TrimVar = ipc.readLvar("VC_PED_trim_wheel_ind")
    local TrimCG = (((TrimVar - 450)/100)*-1)+13.5
   if TrimCG < 0 then TrimCG = TrimCG*-1 TrimCGind = "dn" TrimCGinds = "d"
   elseif TrimCG >= 0 then TrimCGind = "up" TrimCGinds = "u"
   end
   DspShow ("Trim", TrimCGinds .. TrimCG, "  Trim", "  " .. TrimCGind .. " " .. TrimCG)
end

function VC_PED_TRIM_WHEEL_up ()
    ipc.control(FSL, 78376) -- v.244+ (v.243- 78315)
    VC_PED_TRIM_WHEEL_show ()
end

function VC_PED_TRIM_WHEEL_dn ()
    ipc.control(FSL, 78375) -- v.244+ (v.243- 78316)
    VC_PED_TRIM_WHEEL_show ()
end

-- $$ Rudder Trim

function VC_PED_RUD_TRIM_show ()
    local Lvar = 'VC_PED_RUD_TRIM_switch'
    local SLT = ipc.readLvar(Lvar)
    local SLTtext
    if SLT > 0 then
        SLTtext = 'right'
    elseif SLT < 0 then
        SLTtext = 'left'
    else
        SLTtext = 'off'
    end
    DspShow('RUDT', SLTtext)
end

function VC_PED_RUD_TRIM_left ()
    local Lvar = 'VC_PED_RUD_TRIM_switch'
    local SLT = ipc.readLvar(Lvar)
    local VarDec = 78257 -- v.244+ (v.243- 78201)
    local VarRel = 78259 -- v.244+ (v.243- 78203)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
        ipc.sleep(150)
        ipc.control(FSL, VarRel)
        VC_PED_RUD_TRIM_show()
    end
end

function VC_PED_RUD_TRIM_right ()
    local Lvar = 'VC_PED_RUD_TRIM_switch'
    local SLT = ipc.readLvar(Lvar)
    local VarDec = 78258 -- v.244+ (v.243- 78202)
    local VarRel = 78260 -- v.244+ (v.243- 78204)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
        ipc.sleep(150)
        ipc.control(FSL, VarRel)
        VC_PED_RUD_TRIM_show()
    end
end

function VC_PED_RUD_TRIM_RST ()
    local Lvar = 'VC_PED_RUD_TRIM_RST_Button'
    local SLT = ipc.readLvar(Lvar)
    local VarPress = 78262  -- v.244+ (v.243- 78206)
    local VarRel = 78264 -- v.244+ (v.243- 78208)
    ipc.control(FSL, VarPress)
    ipc.sleep(150)
    ipc.control(FSL, VarRel)
    VC_PED_RUD_TRIM_show()
end

-- ## Engine Master Sw and Ign ###############

-- $$ Engine Mode Switch

function VC_PED_ENG_MODE_show ()
    ipc.sleep(10)
    local EngMode = ipc.readLvar("VC_PED_ENG_MODE_Switch")
    if EngMode == 0 then EngModeTxt = "crnk"
    elseif EngMode == 10 then EngModeTxt = "norm"
    elseif EngMode == 20 then EngModeTxt = "strt"
    end
    DspShow ("Mode", EngModeTxt, "EngMode", EngModeTxt)
end

function VC_PED_ENG_MODE_norm ()
    local SwVar = "VC_PED_ENG_MODE_Switch"
    local VarInc = 78253 -- v.244+ (v.243- 78197)
    local VarDec = 78252 -- v.244+ (v.243- 78196)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ENG_MODE_show ()
end

function VC_PED_ENG_MODE_start ()
    local SwVar = "VC_PED_ENG_MODE_Switch"
    local VarInc = 78253 -- v.244+ (v.243- 78197)
    local VarDec = 78252 -- v.244+ (v.243- 78196)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_ENG_MODE_show ()
end

function VC_PED_ENG_MODE_crank ()
    local SwVar = "VC_PED_ENG_MODE_Switch"
    local VarInc = 78253 -- v.244+ (v.243- 78197)
    local VarDec = 78252 -- v.244+ (v.243- 78196)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ENG_MODE_show ()
end

function VC_PED_ENG_MODE_toggle ()
    local SwVar = "VC_PED_ENG_MODE_Switch"
    local VarInc = 78253 -- v.244+ (v.243- 78197)
    local VarDec = 78252 -- v.244+ (v.243- 78196)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
    else
        ipc.control(FSL, VarInc)
    end
    VC_PED_ENG_MODE_show ()
end

-- $$ Engine 1 Master Switch

function VC_PED_ENG_1_MSTR_Switch_on ()
    if ipc.readLvar("VC_PED_ENG_1_MSTR_Switch") < 30 then
        ipc.control(FSL, 78243) -- lift v.244+ (v.243- 78187) 
        _sleep(400,700)
        ipc.control(FSL, 78242) -- move v.244+ (v.243- 78186) 
        _sleep(400,700)
        ipc.control(FSL, 78245) -- down v.244+ (v.243- 78189) 
    end
end

function VC_PED_ENG_1_MSTR_Switch_off ()
    if ipc.readLvar("VC_PED_ENG_1_MSTR_Switch") > 0 then
        ipc.control(FSL, 78243) -- lift v.244+ (v.243- 78187) 
        _sleep(400,700)
        ipc.control(FSL, 78242) -- move v.244+ (v.243- 78186) 
        _sleep(400,700)
        ipc.control(FSL, 78245) -- down v.244+ (v.243- 78189) 
    end
end

function VC_PED_ENG_1_MSTR_Switch_toggle()
    if ipc.readLvar("VC_PED_ENG_1_MSTR_Switch") < 30 then
        VC_PED_ENG_1_MSTR_Switch_on()
    else
        VC_PED_ENG_1_MSTR_Switch_off()
    end
end

-- $$ Engine 2 Master Switch

function VC_PED_ENG_2_MSTR_Switch_on ()
    if ipc.readLvar("VC_PED_ENG_2_MSTR_Switch") < 30 then
        ipc.control(FSL, 78248) -- lift v.244+ (v.243- 78192) 
        _sleep(400,700)
        ipc.control(FSL, 78247) -- move v.244+ (v.243- 78191) 
        _sleep(400,700)
        ipc.control(FSL, 78250) -- down v.244+ (v.243- 78194) 
    end
end

function VC_PED_ENG_2_MSTR_Switch_off ()
    if ipc.readLvar("VC_PED_ENG_2_MSTR_Switch") > 0 then
        ipc.control(FSL, 78248) -- lift v.244+ (v.243- 78192) 
        _sleep(400,700)
        ipc.control(FSL, 78247) -- move v.244+ (v.243- 78191) 
        _sleep(400,700)
        ipc.control(FSL, 78250) -- down v.244+ (v.243- 78194) 
    end
end

function VC_PED_ENG_2_MSTR_Switch_toggle()
    if ipc.readLvar("VC_PED_ENG_2_MSTR_Switch") < 30 then
        VC_PED_ENG_2_MSTR_Switch_on()
    else
        VC_PED_ENG_2_MSTR_Switch_off()
    end
end

function VC_PED_ENG_MSTR_Both_on ()
    if ipc.readLvar("VC_PED_ENG_2_MSTR_Switch") < 30 then
        VC_PED_ENG_2_MSTR_Switch_on ()
        _sleep(400,700)
        VC_PED_ENG_1_MSTR_Switch_on ()
        _sleep(400,700)
    end
end

function VC_PED_ENG_MSTR_Both_off ()
    if ipc.readLvar("VC_PED_ENG_2_MSTR_Switch") > 0 then
        VC_PED_ENG_2_MSTR_Switch_off ()
        _sleep(400,700)
        VC_PED_ENG_1_MSTR_Switch_off ()
        _sleep(400,700)
    end
end

-- $$ PED Eng Thrust Reverser

function PED_Eng1_Rev_on()
    local Lvar = 'FSLA320_reverser_left'
    local val
    local i = 0
    local done = false
    if ipc.readLvar(Lvar) ~= 0 then return end
    while not done do
        i = i + 1
        val = ipc.readLvar(Lvar)
        --if val == 100 then done = true end
        if i > 4 then done = true end
        _loggg('val=' .. tostring(val) .. ' i='
            .. tostring(i) .. ' done=' .. tostring(done))
        ipc.control(65966,0)
        ipc.sleep(150)
    end
end

function PED_Eng1_Rev_off()
    local Lvar = 'FSLA320_reverser_left'
    local val
    local i = 0
    local done = false
    if ipc.readLvar(Lvar) == 0 then return end
    while not done do
        i = i + 1
        val = ipc.readLvar(Lvar)
        if val == 0 then done = true end
        if i > 3 then done = true end
        _loggg('val=' .. tostring(val) .. ' i='
            .. tostring(i) .. ' done=' .. tostring(done))
        ipc.control(65964,0)
        ipc.sleep(150)
    end
end

function PED_Eng2_Rev_on()
    local Lvar = 'FSLA320_reverser_right'
    local val
    local i = 0
    local done = false
    if ipc.readLvar(Lvar) ~= 0 then return end
    while not done do
        i = i + 1
        val = ipc.readLvar(Lvar)
        --if val == 100 then done = true end
        if i > 4 then done = true end
        _loggg('val=' .. tostring(val) .. ' i='
            .. tostring(i) .. ' done=' .. tostring(done))
        ipc.control(65971,0)
        ipc.sleep(150)
    end
end

function PED_Eng2_Rev_off()
    local Lvar = 'FSLA320_reverser_right'
    local val
    local i = 0
    local done = false
    if ipc.readLvar(Lvar) == 0 then return end
    while not done do
        i = i + 1
        val = ipc.readLvar(Lvar)
        if val == 0 then done = true end
        if i > 3 then done = true end
        _loggg('val=' .. tostring(val) .. ' i='
            .. tostring(i) .. ' done=' .. tostring(done))
        ipc.control(65969,0)
        ipc.sleep(150)
    end
end

-- $$ Auto Throttle Disconnect

function PED_ATHR_DISCONNECT ()
   ipc.control(65860, 1)  -- AUTO_THROTTLE_ARM
   DspShow('ATHR', 'disc')
end

-- ## Weather Radar ###############

-- $$ WX Radar Multiscan

function VC_PED_WXRadar_Multiscan_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_WXRadar_Multiscan_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "man"
    elseif SLT == 10 then SLTtxt = "auto"
    end
    DspShow ("SCAN", SLTtxt)
end

function VC_PED_WXRadar_Multiscan_auto ()
    local SwVar = "VC_PED_WXRadar_Multiscan_Switch"
    local VarTogg = 78204 -- v.244+ (v.243- 78147)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarTogg)
    end
    VC_PED_WXRadar_Multiscan_show ()
end

function VC_PED_WXRadar_Multiscan_man ()
    local SwVar = "VC_PED_WXRadar_Multiscan_Switch"
    local VarTogg = 78203 -- v.244+ (v.243- 78148)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarTogg)
    end
    VC_PED_WXRadar_Multiscan_show ()
end

function VC_PED_WXRadar_Multiscan_toggle ()
    local SwVar = "VC_PED_WXRadar_Multiscan_Switch"
	if _tl(SwVar, 0) then
       VC_PED_WXRadar_Multiscan_auto ()
	else
       VC_PED_WXRadar_Multiscan_man ()
	end

end

-- $$ WX Radar GCS

function VC_PED_WXRadar_GCS_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_WXRadar_GCS_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "auto"
    end
    DspShow ("GCS", SLTtxt)
end

function VC_PED_WXRadar_GCS_auto ()
    local SwVar = "VC_PED_WXRadar_GCS_Switch"
    local VarInc = 78219 -- v.244+ (v.243- 78164)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_WXRadar_GCS_show ()
end

function VC_PED_WXRadar_GCS_off ()
    local SwVar = "VC_PED_WXRadar_GCS_Switch"
    local VarDec = 78218 -- v.244+ (v.243- 78162)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_WXRadar_GCS_show ()
end

function VC_PED_WXRadar_GCS_toggle ()
    local SwVar = "VC_PED_WXRadar_GCS_Switch"
    local SLT = ipc.readLvar(SwVar)
	if SLT > 0 then
       VC_PED_WXRadar_GCS_off()
	else
       VC_PED_WXRadar_GCS_auto()
	end
end

-- $$ WX Radar PWS

function VC_PED_WXRadar_PWS_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_WXRadar_PWS_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "auto"
    end
    DspShow ("PWS", SLTtxt)
end

function VC_PED_WXRadar_PWS_auto ()
    local SwVar = "VC_PED_WXRadar_PWS_Switch"
    local VarInc = 78224 -- v.244+ (v.243- 78168) 
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_WXRadar_PWS_show ()
end

function VC_PED_WXRadar_PWS_off ()
    local SwVar = "VC_PED_WXRadar_PWS_Switch"
    local VarDec = 78223 -- v.244+ (v.243- 78167) 
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_WXRadar_PWS_show ()
end

function VC_PED_WXRadar_PWS_toggle ()
    SwVar = "VC_PED_WXRadar_PWS_Switch"
	if _tl(SwVar, 0) then
       VC_PED_WXRadar_PWS_auto ()
	else
       VC_PED_WXRadar_PWS_off ()
	end

end

-- $$ WX Radar SYS

function VC_PED_WXR_SYS_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_WXRadar_SYS_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "1"
    elseif SLT == 10 then SLTtxt = "off"
    elseif SLT == 20 then SLTtxt = "2"
    end
    DspShow ("SYS", SLTtxt)
end

function VC_PED_WXR_SYS_off ()
    local SwVar = "VC_PED_WXRadar_SYS_Switch"
    local VarInc = 78209 -- v.244+ (v.243- 78153) 
    local VarDec = 78208 -- v.244+ (v.243- 78152) 
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_WXR_SYS_show ()
end

function VC_PED_WXR_SYS_1 ()
    SwVar = "VC_PED_WXRadar_SYS_Switch"
    VarInc = 78209 -- v.244+ (v.243- 78153) 
    VarDec = 78208 -- v.244+ (v.243- 78152) 
    SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_PED_WXR_SYS_show ()
end

function VC_PED_WXR_SYS_2 ()
    local SwVar = "VC_PED_WXRadar_SYS_Switch"
    local VarInc = 78209 -- v.244+ (v.243- 78153) 
    local VarDec = 78208 -- v.244+ (v.243- 78152) 
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    end
    VC_PED_WXR_SYS_show ()
end

function VC_PED_WXR_SYS_1off_toggle ()
	if _tl("VC_PED_WXRadar_SYS_Switch", 0) then
       VC_PED_WXR_SYS_off ()
	else
       VC_PED_WXR_SYS_1 ()
	end
end

function VC_PED_WXR_SYS_2off_toggle ()
	if _tl("VC_PED_WXRadar_SYS_Switch", 20) then
       VC_PED_WXR_SYS_off ()
	else
       VC_PED_WXR_SYS_2 ()
	end
end

function VC_PED_WXR_SYS_cycle ()
local SwVar = "VC_PED_WXRadar_SYS_Switch"
	if _tl(SwVar, 0) then
        VC_PED_WXR_SYS_off()
    elseif _tl(SwVar, 10) then
        VC_PED_WXR_SYS_2()
    else
        VC_PED_WXR_SYS_1()
	end
end

function VC_WXR_PWSandSYS1_toggle ()
     VC_PED_WXR_SYS_1off_toggle ()
     VC_PED_WXRadar_PWS_toggle ()
end

-- $$ WXR Mode

function VC_PED_WXRadar_Mode_show ()
    local SwVar = "VC_PED_WXRadar_Mode_Switch"
    local SLT = ipc.readLvar(SwVar)
    ipc.sleep(200)
    if SLT == 0 then SLTtxt = "wx"
    elseif SLT == 10 then SLTtxt = "wx+t"
    elseif SLT == 20 then SLTtxt = "turb"
    elseif SLT == 30 then SLTtxt = "map"
    end
    DspShow ("WXR", SLTtxt, "WXR Mode", SLTtxt)
end

function VC_PED_WXRadar_Mode_wx ()
    local SwVar = "VC_PED_WXRadar_Mode_Switch"
    local VarInc = 78214 -- v.260+ (v.243- 78158)
    local VarDec = 78213 -- v.260+ (v.243- 78157)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 30 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_WXRadar_Mode_show ()
end

function VC_PED_WXRadar_Mode_wxt ()
    local SwVar = "VC_PED_WXRadar_Mode_Switch"
    local VarInc = 78214 -- v.260+ (v.243- 78158)
    local VarDec = 78213 -- v.260+ (v.243- 78157)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    elseif SLT == 30 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_PED_WXRadar_Mode_show ()
end

function VC_PED_WXRadar_Mode_turb ()
    local SwVar = "VC_PED_WXRadar_Mode_Switch"
    local VarInc = 78214 -- v.260+ (v.243- 78158)
    local VarDec = 78213 -- v.260+ (v.243- 78157)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 30 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_WXRadar_Mode_show ()
end

function VC_PED_WXRadar_Mode_map ()
    local SwVar = "VC_PED_WXRadar_Mode_Switch"
    local VarInc = 78214 -- v.260+ (v.243- 78158)
    local VarDec = 78213 -- v.260+ (v.243- 78157)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_WXRadar_Mode_show ()
end

function VC_PED_WXRadar_Mode_inc ()
    local SwVar = "VC_PED_WXRadar_Mode_Switch"
    local VarInc = 78214 -- v.260+ (v.243- 78158)
    local VarDec = 78213 -- v.260+ (v.243- 78157)
    local SLT = ipc.readLvar(SwVar)
    if SLT <= 30 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_WXRadar_Mode_show ()
end

function VC_PED_WXRadar_Mode_dec ()
    local SwVar = "VC_PED_WXRadar_Mode_Switch"
    local VarInc = 78214 -- v.260+ (v.243- 78158)
    local VarDec = 78213 -- v.260+ (v.243- 78157)
    local SLT = ipc.readLvar(SwVar)
    if SLT >= 0 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_WXRadar_Mode_show ()
end

function VC_PED_WXRadar_Mode_cycle ()
    local SwVar = "VC_PED_WXRadar_Mode_Switch"
    local VarInc = 78214 -- v.260+ (v.243- 78158)
    local VarDec = 78213 -- v.260+ (v.243- 78157)
    local SLT = ipc.readLvar(SwVar)
    if SLT < 30 then
        ipc.control(FSL, VarInc)
    else
        VC_PED_WXRadar_Mode_wx()
    end
    VC_PED_WXRadar_Mode_show ()
end

-- $$ WX Radar Gain

function VC_PED_WXRadar_Gain_show ()
    local SwVar = "VC_PED_WXRadar_Gain_Knob"
    local SLT = ipc.readLvar(SwVar)
    ipc.sleep(200)
    if SLT == 0 then SLTtxt = "min"
    elseif SLT == 30 then SLTtxt = "-12"
    elseif SLT == 60 then SLTtxt = "-9"
    elseif SLT == 90 then SLTtxt = "-6"
    elseif SLT == 120 then SLTtxt = "-3"
    elseif SLT == 150 then SLTtxt = "cal"
    elseif SLT == 180 then SLTtxt = "+4"
    elseif SLT == 210 then SLTtxt = "+8"
    elseif SLT == 240 then SLTtxt = "+12"
    elseif SLT == 270 then SLTtxt = "max"
    end
    DspShow ("Gain", SLTtxt, "WXR Gain", SLTtxt)
end

function VC_PED_WXRadar_Gain_inc ()
    ipc.control(FSL, 78229) -- v.260+ (v.243- 78173)
    VC_PED_WXRadar_Gain_show ()
end

function VC_PED_WXRadar_Gain_dec ()
    ipc.control(FSL, 78228) -- v.260+ (v.243- 78172)
    VC_PED_WXRadar_Gain_show ()
end

function VC_PED_WXRadar_Gain_cycle ()
    local SwVar = "VC_PED_WXRadar_Gain_Knob"
    local SLT = ipc.readLvar(SwVar)
    if SLT < 270 then
        ipc.control(FSL, 78229) -- v.260+ (v.243- 78173)
    else
        for i = 1, 9 do
            ipc.control(FSL, 78228) -- v.260+ (v.243- 78172)
        end
    end
    VC_PED_WXRadar_Gain_show()
end

-- ## Rear Pedestal ###############

-- $$ Parking Brake

function VC_PED_PARK_BRAKE_show ()
    local Lvar = 'VC_PED_PARK_BRAKE_switch'
    local SLT = ipc.readLvar(Lvar)
    local SLTtext
    if SLT > 70 then
        SLTtext = 'ON'
    else
        SLTtext = 'OFF'
    end
    DspShow('PARK', SLTtext)
end

function VC_PED_PARK_BRAKE_off ()
    local Lvar = 'VC_PED_PARK_BRAKE_switch'
    local SLT = ipc.readLvar(Lvar)
    local VarDec = 78267 -- v.260+ (v.243- 78211)
    if SLT == 100 then
        ipc.control(FSL, VarDec)
        ipc.sleep(200)
    end
    DspShow('PARK', 'off')
end

function VC_PED_PARK_BRAKE_on ()
    local Lvar = 'VC_PED_PARK_BRAKE_switch'
    local SLT = ipc.readLvar(Lvar)
    local VarInc = 78268 -- v.260+ (v.243- 78212)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(200)
    end
    DspShow('PARK', 'on')
end

function VC_PED_PARK_BRAKE_toggle ()
    local Lvar = 'VC_PED_PARK_BRAKE_switch'
    local SLT = ipc.readLvar(Lvar)
    if SLT > 50 then
         VC_PED_PARK_BRAKE_off()
    else
        VC_PED_PARK_BRAKE_on()
    end
end

-- $$ Speed Brake

function VC_PED_SPD_BRK_LEVER_show (up)
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local SLT = ipc.readLvar(Lvar)
    local SLTtext
    if up then
        if (SLT > 150) then SLTtxt = "FULL"
        elseif (SLT > 110) then SLTtxt = "3/4"
        elseif (SLT > 80) then SLTtxt = "1/2"
        elseif (SLT > 60) then SLTtxt = "1/4"
        elseif (SLT > 20) then SLTtxt = "RET"
        elseif (SLT > 10) then SLTtxt = "DISA"
        else SLTtxt = "ARM"
        end
    else
        if (SLT < 5) then SLTtxt = "ARM"
        elseif (SLT < 35) then SLTtxt = "DISA"
        elseif (SLT < 50) then SLTtxt = "RET"
        elseif (SLT < 80) then SLTtxt = "1/4"
        elseif (SLT < 120) then SLTtxt = "1/2"
        elseif (SLT < 160) then SLTtxt = "3/4"
        else SLTtxt = "FULL"
        end
    end
    DspShow ("SPDB", SLTtxt, "Spd Brake", SLTtxt)
end

function VC_PED_SPD_BRK_POS_inc ()
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local varInc = 78357 -- v.260+ (v.243- 78301)
    local done = false
    local SLT = ipc.readLvar(Lvar)
    if SLT == 180 then
        VC_PED_SPD_BRK_LEVER_show()
        return
    end
    ipc.control(FSL, varInc)
    ipc.sleep(400)
    VC_PED_SPD_BRK_LEVER_show(true)
end

function VC_PED_SPD_BRK_POS_dec ()
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local varDec = 78358 -- v.260+ (v.243- 78302)
    local done = false
    local SLT = ipc.readLvar(Lvar)
    if SLT == 0 then
        VC_PED_SPD_BRK_LEVER_show()
        return
    end
    ipc.control(FSL, varDec)
    ipc.sleep(400)
    VC_PED_SPD_BRK_LEVER_show(false)
end

function VC_PED_SPD_BRK_POS_max ()
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local varInc = 78357 -- v.260+ (v.243- 78301)
    local done = false
    local SLT = ipc.readLvar(Lvar)
    while (SLT < 180) do
        ipc.control(FSL, varInc)
        ipc.sleep(200)
        SLT = ipc.readLvar(Lvar)
    end
    ipc.sleep(400)
    VC_PED_SPD_BRK_LEVER_show(false)
end

function VC_PED_SPD_BRK_POS_3qtr ()
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local varInc = 78357 -- v.260+ (v.243- 78301)
    local varDec = 78358 -- v.260+ (v.243- 78302)
    local SLT = ipc.readLvar(Lvar)
    if SLT < 130 then
        while (SLT < 130) do
            ipc.control(FSL, varInc)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(true)
    else
        while (SLT > 130) do
            ipc.control(FSL, varDec)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(false)
    end
end

function VC_PED_SPD_BRK_POS_half ()
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local varInc = 78357 -- v.260+ (v.243- 78301)
    local varDec = 78358 -- v.260+ (v.243- 78302)
    local SLT = ipc.readLvar(Lvar)
    if SLT < 90 then
        while (SLT < 90) do
            ipc.control(FSL, varInc)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(true)
    else
        while (SLT > 90) do
            ipc.control(FSL, varDec)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(false)
    end
end

function VC_PED_SPD_BRK_POS_1qtr ()
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local varInc = 78357 -- v.260+ (v.243- 78301)
    local varDec = 78358 -- v.260+ (v.243- 78302)
    local SLT = ipc.readLvar(Lvar)
    if SLT < 70 then
        while (SLT < 70) do
            ipc.control(FSL, varInc)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(true)
    else
        while (SLT > 70) do
            ipc.control(FSL, varDec)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(false)
    end
end

function VC_PED_SPD_BRK_POS_ret ()
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local varInc = 78357 -- v.260+ (v.243- 78301)
    local varDec = 78358 -- v.260+ (v.243- 78302)
    local SLT = ipc.readLvar(Lvar)
    if SLT < 30 then
        while (SLT < 30) do
            ipc.control(FSL, varInc)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(true)
    else
        while (SLT > 30) do
            ipc.control(FSL, varDec)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(false)
    end
end

function VC_PED_SPD_BRK_POS_disarm ()
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local varInc = 78357 -- v.260+ (v.243- 78301)
    local varDec = 78358 -- v.260+ (v.243- 78302)
    local SLT = ipc.readLvar(Lvar)
    if SLT < 10 then
        while (SLT < 10) do
            ipc.control(FSL, varInc)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(true)
    else
        while (SLT > 10) do
            ipc.control(FSL, varDec)
            ipc.sleep(200)
            SLT = ipc.readLvar(Lvar)
        end
        ipc.sleep(400)
        VC_PED_SPD_BRK_LEVER_show(false)
    end
end

function VC_PED_SPD_BRK_POS_arm ()
    local Lvar = 'VC_PED_SPD_BRK_LEVER'
    local varDec = 78358 -- v.260+ (v.243- 78302)
    local SLT = ipc.readLvar(Lvar)
    while (SLT > 0) do
        ipc.control(FSL, varDec)
        ipc.sleep(200)
        SLT = ipc.readLvar(Lvar)
    end
    ipc.sleep(400)
    VC_PED_SPD_BRK_LEVER_show(false)
end

-- using FSX controls

function PED_Spoilers_arm ()
    ipc.control(66066)
    DspShow ("SPLR", "arm", "Spoiler", "arm")
end

function PED_Spoilers_disarm ()
    ipc.control(66067)
    DspShow ("SPLR", "darm", "Spoiler", "disarm")
end

function PED_Spoilers_arm_toggle ()
    ipc.control(65853)
end

-- $$ Cockpit Door

function VC_PED_COCKPIT_DOOR_show ()
    local Lvar = 'VC_PED_COCKPIT_DOOR_switch'
    local SLT = ipc.readLvar(Lvar)
    local SLTtext
    if SLT > 0 then
        SLTtext = 'UNLOCK'
    elseif SLT < 0 then
        SLTtext = 'LOCK'
    else
        SLTtext = 'OFF'
    end
    DspShow('DOOR', SLTtext)
end

function VC_PED_COCKPIT_DOOR_lock ()
    local Lvar = 'VC_PED_COCKPIT_DOOR_switch'
    local SLT = ipc.readLvar(Lvar)
    local VarDec = 78272 -- v.260+ (v.243- 78216)
    local VarRel = 78274 -- v.260+ (v.243- 78218)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
        ipc.sleep(250)
        ipc.control(FSL, VarRel)
        VC_PED_COCKPIT_DOOR_show()
    end
end

function VC_PED_COCKPIT_DOOR_unlock ()
    local Lvar = 'VC_PED_COCKPIT_DOOR_switch'
    local SLT = ipc.readLvar(Lvar)
    local VarDec = 78273 -- v.260+ (v.243- 78217)
    local VarRel = 78275 -- v.260+ (v.243- 78219)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
        ipc.sleep(250)
        ipc.control(FSL, VarRel)
        VC_PED_COCKPIT_DOOR_show()
    end
end

function VC_PED_LDG_GEAR_GRV_EXT_show ()
    local Lvar = 'VC_PED_LDG_GEAR_GRV_EXT_switch'
    local SLT = ipc.readLvar(Lvar)
    local SLTtext
    if SLT == 0 then
        SLTtext = 'up'
    elseif SLT == 1280 then
        SLTtext = 'down'
    else
        SLTtext = 'move'
    end
    DspShow('LGRV', SLTtext)
end

-- $$ Emerg Gravity Gear Lower

function VC_PED_LDG_GEAR_GRV_EXT_up ()
    local Lvar = 'VC_PED_LDG_GEAR_GRV_EXT_switch'
    local SLT = ipc.readLvar(Lvar)
    local VarDec = 78352 -- v.260+ (v.243- 78296)
    if (SLT ~= 0) --or A320_GRV_LDG_GEAR == 0
    then
        ipc.control(FSL, VarDec)
        A320_GRV_LDG_GEAR = 4
        _loggg('[A320] GRV EXT UP')
    end
end

function VC_PED_LDG_GEAR_GRV_EXT_dn ()
    local Lvar = 'VC_PED_LDG_GEAR_GRV_EXT_switch'
    local SLT = ipc.readLvar(Lvar)
    local VarInc = 78353 -- v.260+ (v.243- 78297)
    if (SLT ~= 1280) --and A320_GRV_LDG_GEAR == 0
    then
        ipc.control(FSL, VarInc)
        A320_GRV_LDG_GEAR = -4
        _loggg('[A320] GRV EXT DN')
    end
end

function VC_PED_LDG_GEAR_GRV_EXT_stop ()
    A320_GRV_LDG_GEAR = 0
    _loggg('[A320] GRV EXT STOP')
end

function VC_PED_LDG_GEAR_GRV_EXT_toggle ()
    local Lvar = 'VC_PED_LDG_GEAR_GRV_EXT_switch'
    local SLT = ipc.readLvar(Lvar)
    if SLT == 0 then
        VC_PED_LDG_GEAR_GRV_EXT_dn()
    else
        VC_PED_LDG_GEAR_GRV_EXT_up()
    end
end

-- called from timer - do not assign
function VC_PED_LDG_GEAR_GRV_EXT_move ()
    local Lvar = 'VC_PED_LDG_GEAR_GRV_EXT_switch'
    local SLT = ipc.readLvar(Lvar)
    local VarDec = 78352 -- v.260+ (v.243- 78296)
    local VarInc = 78353 -- v.260+ (v.243- 78297)
    _logggg('[A320] GRV EXT MOVE ' .. A320_GRV_LDG_GEAR
        .. ' POS=' .. SLT)
    if A320_GRV_LDG_GEAR ~= 0 then
        if  (SLT==0) or (SLT==1280) then
            A320_GRV_LDG_GEAR = 0
        elseif
            (SLT==100) or (SLT==460) or
            (SLT==820) or (SLT==1180)
        then
            if A320_GRV_LDG_GEAR > 0 then
                ipc.control(FSL, VarDec)
                ipc.sleep(100)
                VC_PED_PARK_BRAKE_show()
                A320_GRV_LDG_GEAR = A320_GRV_LDG_GEAR - 1
            else --if A320_GRV_LDG_GEAR > 0 then
                ipc.control(FSL, VarInc)
                ipc.sleep(100)
                VC_PED_PARK_BRAKE_show()
                A320_GRV_LDG_GEAR = A320_GRV_LDG_GEAR + 1
            end
        end
    end
end

-- ## ATC Transponder ###############

-- $$ XPNR On/Off

function VC_PED_ATCXPDR_ON_OFF_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_ATCXPDR_ON_OFF_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "stby"
    elseif SLT == 10 then SLTtxt = "auto"
    elseif SLT == 20 then SLTtxt = "on"
    end
    DspShow ("XPDR", SLTtxt, "ATC XPDR", SLTtxt)
end

function VC_PED_ATCXPDR_ON_OFF_stby ()
    local SwVar = "VC_PED_ATCXPDR_ON_OFF_Switch"
    local VarInc = 78278 -- v.260+ (v.243- 78222)
    local VarDec = 78277 -- v.260+ (v.243- 78221)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_ON_OFF_show ()
end

function VC_PED_ATCXPDR_ON_OFF_auto ()
    local SwVar = "VC_PED_ATCXPDR_ON_OFF_Switch"
    local VarInc = 78278 -- v.260+ (v.243- 78222)
    local VarDec = 78277 -- v.260+ (v.243- 78221)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_ON_OFF_show ()
end

function VC_PED_ATCXPDR_ON_OFF_on ()
    local SwVar = "VC_PED_ATCXPDR_ON_OFF_Switch"
    local VarInc = 78278 -- v.260+ (v.243- 78222)
    local VarDec = 78277 -- v.260+ (v.243- 78221)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_ATCXPDR_ON_OFF_show ()
end

function VC_PED_ATCXPDR_ON_OFF_toggle ()
    local SwVar = "VC_PED_ATCXPDR_ON_OFF_Switch"
    local VarInc = 78278 -- v.260+ (v.243- 78222)
    local VarDec = 78277 -- v.260+ (v.243- 78221)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_ON_OFF_show ()
end

function VC_PED_ATCXPDR_ON_OFF_cycle ()
    local SwVar = "VC_PED_ATCXPDR_ON_OFF_Switch"
    local VarInc = 78278 -- v.260+ (v.243- 78222)
    local VarDec = 78277 -- v.260+ (v.243- 78221)
    local SLT = ipc.readLvar(SwVar)
    if SLT < 10 then
        ipc.control(FSL, VarInc)
    elseif SLT < 20 then
        ipc.control(FSL, VarInc)
    else
        VC_PED_ATCXPDR_ON_OFF_stby ()
    end
    VC_PED_ATCXPDR_ON_OFF_show ()
end

-- $$ XPNR 1/2

function VC_PED_ATCXPDR_1_2_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_ATCXPDR_1_2_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "1"
    elseif SLT == 10 then SLTtxt = "2"
    end
    DspShow ("ATC", SLTtxt)
end

function VC_PED_ATCXPDR_1_2_on ()
    local SwVar = "VC_PED_ATCXPDR_1_2_Switch"
    local VarInc = 78283 -- v.260+ (v.243- 78227)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
    ipc.control(FSL, VarInc)
    end
    VC_PED_ATCXPDR_1_2_show ()
end

function VC_PED_ATCXPDR_1_2_off ()
    local SwVar = "VC_PED_ATCXPDR_1_2_Switch"
    local VarDec = 78282 -- v.260+ (v.243- 78226)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
    ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_1_2_show ()
end

function VC_PED_ATCXPDR_1_2_toggle ()
    local SwVar = "VC_PED_ATCXPDR_1_2_Switch"
    local VarTogg = 78282 -- v.260+ (v.243- 78226)
    ipc.control(FSL, VarTogg)
    VC_PED_ATCXPDR_1_2_show ()
end

-- $$ XPDR RPTG

function VC_PED_ATCXPDR_ALT_RPTG_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_ATCXPDR_ALT_RPTG_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "off"
    elseif SLT == 10 then SLTtxt = "on"
    end
    DspShow ("ALTR", SLTtxt, "ALT RPTG", SLTtxt)
end

function VC_PED_ATCXPDR_ALT_RPTG_on ()
    local SwVar = "VC_PED_ATCXPDR_ALT_RPTG_Switch"
    local VarInc= 78288 -- v.260+ (v.243- 78232)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_ATCXPDR_ALT_RPTG_show ()
end

function VC_PED_ATCXPDR_ALT_RPTG_off ()
    local SwVar = "VC_PED_ATCXPDR_ALT_RPTG_Switch"
    local VarDec = 78287 -- v.260+ (v.243- 78231)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_ALT_RPTG_show ()
end

function VC_PED_ATCXPDR_ALT_RPTG_toggle ()
    local SwVar = "VC_PED_ATCXPDR_ALT_RPTG_Switch"
    local VarTogg = 78287 -- v.260+ (v.243- 78231)
    ipc.control(FSL, VarTogg)
    VC_PED_ATCXPDR_ALT_RPTG_show ()
end

function VC_PED_XPDRRPTG_toggle ()
    VC_PED_ATCXPDR_ALT_RPTG_toggle ()
    VC_PED_ATCXPDR_ON_OFF_toggle ()
end

-- $$ XPNR THRT

function VC_PED_ATCXPDR_THRT_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_ATCXPDR_THRT_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "thrt"
    elseif SLT == 10 then SLTtxt = "all"
    elseif SLT == 20 then SLTtxt = "abv"
    elseif SLT == 30 then SLTtxt = "blw"
    end
    DspShow ("THRT", SLTtxt, "ATC THRT", SLTtxt)
end

function VC_PED_ATCXPDR_THRT_thrt ()
    local SwVar = "VC_PED_ATCXPDR_THRT_Switch"
    local VarInc = 78343 -- v.260+ (v.243- 78287)
    local VarDec = 78342 -- v.260+ (v.243- 78286)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 10 then
        ipc.control(FSL, VarDec)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 30 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_THRT_show ()
end

function VC_PED_ATCXPDR_THRT_all ()
    local SwVar = "VC_PED_ATCXPDR_THRT_Switch"
    local VarInc = 78343 -- v.260+ (v.243- 78287)
    local VarDec = 78342 -- v.260+ (v.243- 78286)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    elseif SLT == 30 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_THRT_show ()
end

function VC_PED_ATCXPDR_THRT_abv ()
    local SwVar = "VC_PED_ATCXPDR_THRT_Switch"
    local VarInc = 78343 -- v.260+ (v.243- 78287)
    local VarDec = 78342 -- v.260+ (v.243- 78286)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    elseif SLT == 30 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_THRT_show ()
end

function VC_PED_ATCXPDR_THRT_blw ()
    local SwVar = "VC_PED_ATCXPDR_THRT_Switch"
    local VarInc = 78343 -- v.260+ (v.243- 78287)
    local VarDec = 78342 -- v.260+ (v.243- 78286)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_ATCXPDR_THRT_show ()
end

function VC_PED_ATCXPDR_THRT_inc ()
    local SwVar = "VC_PED_ATCXPDR_THRT_Switch"
    local VarInc = 78343 -- v.260+ (v.243- 78287)
    local VarDec = 78342 -- v.260+ (v.243- 78286)
    local SLT = ipc.readLvar(SwVar)
    if SLT <= 30 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_ATCXPDR_THRT_show ()
end

function VC_PED_ATCXPDR_THRT_dec ()
    local SwVar = "VC_PED_ATCXPDR_THRT_Switch"
    local VarInc = 78343 -- v.260+ (v.243- 78287)
    local VarDec = 78342 -- v.260+ (v.243- 78286)
    local SLT = ipc.readLvar(SwVar)
    if SLT >= 0 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_THRT_show ()
end

function VC_PED_ATCXPDR_THRT_cycle ()
    local SwVar = "VC_PED_ATCXPDR_THRT_Switch"
    if ipc.readLvar(SwVar) < 30 then
        VC_PED_ATCXPDR_THRT_inc()
    else
        VC_PED_ATCXPDR_THRT_thrt ()
    end
end

-- $$ XPNR Mode

function VC_PED_ATCXPDR_MODE_show ()
    ipc.sleep(10)
    local SwVar = "VC_PED_ATCXPDR_MODE_Switch"
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then SLTtxt = "stby"
    elseif SLT == 10 then SLTtxt = "TA"
    elseif SLT == 20 then SLTtxt = "TARA"
    end
    DspShow ("XPDR", SLTtxt, "ATC XPDR", SLTtxt)
    if _MCP1() then
        DspShow ("TCAS", SLTtxt)
    else
        DspRadioShort(SLTtxt)
    end
end

function VC_PED_ATCXPDR_MODE_stby ()
    local SwVar = "VC_PED_ATCXPDR_MODE_Switch"
    local VarInc = 78348 -- v.260+ (v.243- 78292)
    local VarDec = 78347 -- v.260+ (v.243- 78291)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_MODE_show ()
end

function VC_PED_ATCXPDR_MODE_ta ()
    local SwVar = "VC_PED_ATCXPDR_MODE_Switch"
    local VarInc = 78348 -- v.260+ (v.243- 78292)
    local VarDec = 78347 -- v.260+ (v.243- 78291)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_MODE_show ()
end

function VC_PED_ATCXPDR_MODE_tara ()
    local SwVar = "VC_PED_ATCXPDR_MODE_Switch"
    local VarInc = 78348 -- v.260+ (v.243- 78292)
    local VarDec = 78347 -- v.260+ (v.243- 78291)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_ATCXPDR_MODE_show ()
end

function VC_PED_ATCXPDR_MODE_toggle ()
    local SwVar = "VC_PED_ATCXPDR_MODE_Switch"
    local VarInc = 78348 -- v.260+ (v.243- 78292)
    local VarDec = 78347 -- v.260+ (v.243- 78291)
    local SLT = ipc.readLvar(SwVar)
    if SLT == 0 then
        ipc.control(FSL, VarInc)
        ipc.sleep(10)
        ipc.control(FSL, VarInc)
    elseif SLT == 10 then
        ipc.control(FSL, VarDec)
    elseif SLT == 20 then
        ipc.control(FSL, VarDec)
        ipc.sleep(10)
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_MODE_show ()
end

function VC_PED_ATCXPDR_MODE_inc ()
    local SwVar = "VC_PED_ATCXPDR_MODE_Switch"
    local VarInc = 78348 -- v.260+ (v.243- 78292)
    local VarDec = 78347 -- v.260+ (v.243- 78291)
    local SLT = ipc.readLvar(SwVar)
    if SLT <= 20 then
        ipc.control(FSL, VarInc)
    end
    VC_PED_ATCXPDR_MODE_show ()
end

function VC_PED_ATCXPDR_MODE_dec ()
    local SwVar = "VC_PED_ATCXPDR_MODE_Switch"
    local VarInc = 78348 -- v.260+ (v.243- 78292)
    local VarDec = 78347 -- v.260+ (v.243- 78291)
    local SLT = ipc.readLvar(SwVar)
    if SLT >= 0 then
        ipc.control(FSL, VarDec)
    end
    VC_PED_ATCXPDR_MODE_show ()
end

-- $$ XNPR Buttons

function VC_PED_ATCXPDR_IDENT()
    ipc.control(FSL, 78337) -- v.260+ (v.243- 78281)
    DspShow('ATC', 'IDNT')
    ipc.sleep(150)
    ipc.control(FSL, 78339) -- v.260+ (v.243- 78283)
end

function VC_PED_ATCXPDR_BUT1()
    ipc.control(FSL, 78292)  -- v.260+ (v.243- 78236)
    DspShow('ATC', '1')
    ipc.sleep(150)
    ipc.control(FSL, 78294) -- v.260+ (v.243- 78238)
end

function VC_PED_ATCXPDR_BUT2()
    ipc.control(FSL, 78297) -- v.260+ (v.243- 78241)
    DspShow('ATC', '2')
    ipc.sleep(150)
    ipc.control(FSL, 78299) -- v.260+ (v.243- 78243)
end

function VC_PED_ATCXPDR_BUT3()
    ipc.control(FSL, 78302) -- v.260+ (v.243- 78246)
    DspShow('ATC', '3')
    ipc.sleep(150)
    ipc.control(FSL, 78304) -- v.260+ (v.243- 78248)
end

function VC_PED_ATCXPDR_BUT4()
    ipc.control(FSL, 78307) -- v.260+ (v.243- 78251)
    DspShow('ATC', '4')
    ipc.sleep(150)
    ipc.control(FSL, 78309) -- v.260+ (v.243- 78253)
end

function VC_PED_ATCXPDR_BUT5()
    ipc.control(FSL, 78312) -- v.260+ (v.243- 78256)
    DspShow('ATC', '5')
    ipc.sleep(150)
    ipc.control(FSL, 78314) -- v.260+ (v.243- 78258)
end

function VC_PED_ATCXPDR_BUT6()
    ipc.control(FSL, 78317) -- v.260+ (v.243- 78261)
    DspShow('ATC', '6')
    ipc.sleep(150)
    ipc.control(FSL, 78319) -- v.260+ (v.243- 78263)
end

function VC_PED_ATCXPDR_BUT7()
    ipc.control(FSL, 78322) -- v.260+ (v.243- 78266)
    DspShow('ATC', '7')
    ipc.sleep(150)
    ipc.control(FSL, 78324) -- v.260+ (v.243- 78268)
end

function VC_PED_ATCXPDR_BUT0()
    ipc.control(FSL, 78327) -- v.260+ (v.243- 78271)
    DspShow('ATC', '0')
    ipc.sleep(150)
    ipc.control(FSL, 78329) -- v.260+ (v.243- 78273)
end

function VC_PED_ATCXPDR_CLR()
    ipc.control(FSL, 78332) -- v.260+ (v.243- 78276)
    DspShow('ATC', 'CLR')
    ipc.sleep(150)
    ipc.control(FSL, 78334) -- v.260+ (v.243- 78278)
end

function VC_PED_ATCXPDR_ALLCLR()
    VC_PED_ATCXPDR_CLR()
    ipc.sleep(150)
    VC_PED_ATCXPDR_CLR()
end

function VC_PED_ATCXPDR_2200 ()
    VC_PED_ATCXPDR_ALLCLR()
    ipc.sleep(200)
    VC_PED_ATCXPDR_BUT2()
    ipc.sleep(200)
    VC_PED_ATCXPDR_BUT2()
    ipc.sleep(200)
    VC_PED_ATCXPDR_BUT0()
    ipc.sleep(200)
    VC_PED_ATCXPDR_BUT0()
    ipc.Sleep(200)
    DspShow("XPND", "2200")
end

-- $$ MCP XPND code change
function VC_PED_ATCXPDR_VCUpdate ()
    Default_XPND_init(true)
    VC_PED_ATCXPDR_ALLCLR()
    local num = 0
    for i = 1, 4 do
        num = string.sub(RADIOS_XPND_CODE, i, i)
        _loggg("XPNR=" .. i .. '-' .. RADIOS_XPND_CODE ..  '=' .. num)
        if num == '0' then
            VC_PED_ATCXPDR_BUT0()
        elseif num == '1' then
            VC_PED_ATCXPDR_BUT1()
        elseif num == '2' then
            VC_PED_ATCXPDR_BUT2()
        elseif num == '3' then
            VC_PED_ATCXPDR_BUT3()
        elseif num == '4' then
            VC_PED_ATCXPDR_BUT4()
        elseif num == '5' then
            VC_PED_ATCXPDR_BUT5()
        elseif num == '6' then
            VC_PED_ATCXPDR_BUT6()
        elseif num == '7' then
            VC_PED_ATCXPDR_BUT7()
        else
        end
    end
end


-- ## Pedestal Radios

-- $$ Radio 1 Capt

function VC_PED_RADIO_1_ON_OFF_show()
    local Lvar = 'VC_PED_RADIO_1_ON_OFF_Switch'
    local pos
    local val = ipc.readLvar(Lvar)
    if val == 0 then
        DspShow('Rad1','off')
    else
        DspShow('Rad1', 'on')
    end
end

function VC_PED_RADIO_1_ON_OFF_toggle ()
    ipc.control(FSL, 77594)
    ipc.sleep(100)
    VC_PED_RADIO_1_ON_OFF_show()
end

function VC_PED_RADIO_1_ON_OFF_on()
    local Lvar = 'VC_PED_RADIO_1_ON_OFF_Switch'
    local pos
    local val = ipc.readLvar(Lvar)
    if val == 0 then
        VC_PED_RADIO_1_ON_OFF_toggle()
    end
end

function VC_PED_RADIO_1_ON_OFF_off()
    local Lvar = 'VC_PED_RADIO_1_ON_OFF_Switch'
    local pos
    local val = ipc.readLvar(Lvar)
    if val == 10 then
        VC_PED_RADIO_1_ON_OFF_toggle()
    end
end

function VC_PED_RADIO_1_Inner_Knob_inc ()
    ipc.control(FSL, 77564)
end

function VC_PED_RADIO_1_Inner_Knob_dec ()
    ipc.control(FSL, 77565)
end

function VC_PED_RADIO_1_Outer_Knob_inc ()
    ipc.control(FSL, 77557)
end

function VC_PED_RADIO_1_Outer_Knob_dec ()
    ipc.control(FSL, 77558)
end

-- $$ Radio 2 FO

function VC_PED_RADIO_2_ON_OFF_show()
    local Lvar = 'VC_PED_RADIO_2_ON_OFF_Switch'
    local pos
    local val = ipc.readLvar(Lvar)
    if val == 0 then
        DspShow('Rad2','off')
    else
        DspShow('Rad2', 'on')
    end
end

function VC_PED_RADIO_2_ON_OFF_toggle ()
    ipc.control(FSL, 77675)
    ipc.sleep(100)
    VC_PED_RADIO_2_ON_OFF_show()
end

function VC_PED_RADIO_2_ON_OFF_on()
    local Lvar = 'VC_PED_RADIO_2_ON_OFF_Switch'
    local pos
    local val = ipc.readLvar(Lvar)
    if val == 0 then
        VC_PED_RADIO_2_ON_OFF_toggle()
    end
end

function VC_PED_RADIO_2_ON_OFF_off()
    local Lvar = 'VC_PED_RADIO_2_ON_OFF_Switch'
    local pos
    local val = ipc.readLvar(Lvar)
    if val == 10 then
        VC_PED_RADIO_2_ON_OFF_toggle()
    end
end

function VC_PED_RADIO_2_Inner_Knob_inc ()
    ipc.control(FSL, 77645)
end

function VC_PED_RADIO_2_Inner_Knob_dec ()
    ipc.control(FSL, 77646)
end

function VC_PED_RADIO_2_Outer_Knob_inc ()
    ipc.control(FSL, 77638)
end

function VC_PED_RADIO_2_Outer_Knob_dec ()
    ipc.control(FSL, 77639)
end

-- $$ XNPR Switch All at once

function VC_PED_ATCXPDR_ALL_on ()
    VC_PED_ATCXPDR_ON_OFF_auto ()
    VC_PED_ATCXPDR_ALT_RPTG_on ()
end

function VC_PED_ATCXPDR_ALL_off ()
    VC_PED_ATCXPDR_ON_OFF_stby ()
    VC_PED_ATCXPDR_ALT_RPTG_off ()
end

function VC_PED_ATCXPDR_ALL_toggle ()
    VC_PED_ATCXPDR_ON_OFF_toggle ()
    VC_PED_ATCXPDR_ALT_RPTG_toggle ()
end

-- ## Chrono

-- $$ Capt Chrono Start/Stop

function VC_GSHD_CP_CHRONO()
    ipc.control(FSL, 71158)
    DspShow('CHRN', 'But')
    ipc.sleep(150)
    ipc.control(FSL, 71160)
end

-- $$ FO Chrono Start/Stop

function VC_GSHD_FO_CHRONO()
    ipc.control(FSL, 71174)
    DspShow('CHRN', 'But')
    ipc.sleep(150)
    ipc.control(FSL, 71176)
end

-- $$ Chrono Buttons

function VC_MIP_CHRONO_RST()
    ipc.control(FSL, 75135)
    DspShow('CHRN', 'Rset')
    ipc.sleep(150)
    ipc.control(FSL, 75137)
end

function VC_MIP_CHRONO_START_STOP()
    ipc.control(FSL, 75139)
    DspShow('CHRN', 'StSp')
    ipc.sleep(150)
    ipc.control(FSL, 75141)
end

function VC_MIP_CHRONO_DATE_SET()
    ipc.control(FSL, 75143)
    DspShow('CHRN', 'Rset')
    ipc.sleep(150)
    ipc.control(FSL, 75145)
end

-- $$ Chrono GMT Selector Switch

function VC_MIP_CHRONO_GMT_SEL_dec()
    local Lvar = 'VC_MIP_CHRONO_GMT_SEL_Switch'
    local pos
    local val = 75147
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_MIP_CHRONO_GMT_SEL_inc()
    local Lvar = 'VC_MIP_CHRONO_GMT_SEL_Switch'
    local pos
    local val = 75148
    pos = ipc.readLvar(Lvar)
    if pos < 20 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_MIP_CHRONO_GMT_SEL_gps()
    local Lvar = 'VC_MIP_CHRONO_GMT_SEL_Switch'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        VC_MIP_CHRONO_GMT_SEL_dec()
        if pos > 10 then
            VC_MIP_CHRONO_GMT_SEL_dec()
        end
    end
    DspShow('CHRN', 'GPS')
end

function VC_MIP_CHRONO_GMT_SEL_int()
local Lvar = 'VC_MIP_CHRONO_GMT_SEL_Switch'
local pos
    pos = ipc.readLvar(Lvar)
    if pos > 10 then
        VC_MIP_CHRONO_GMT_SEL_dec()
    elseif pos < 10 then
        VC_MIP_CHRONO_GMT_SEL_inc()
    end
    DspShow('CHRN', 'INT')
end

function VC_MIP_CHRONO_GMT_SEL_set()
    local Lvar = 'VC_MIP_CHRONO_GMT_SEL_Switch'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos < 20 then
        VC_MIP_CHRONO_GMT_SEL_inc()
        if pos < 10 then
            VC_MIP_CHRONO_GMT_SEL_inc()
        end
    end
    DspShow('CHRN', 'SET')
end

function VC_MIP_CHRONO_GMT_SEL_cycle()
    local Lvar = 'VC_MIP_CHRONO_GMT_SEL_Switch'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos < 20 then
        VC_MIP_CHRONO_GMT_SEL_inc()
    else
        VC_MIP_CHRONO_GMT_SEL_gps()
    end
end

-- $$ Chrono Elapse Selector Switch

function VC_MIP_CHRONO_ELAPS_SEL_dec()
    local Lvar = 'VC_MIP_CHRONO_ELAPS_SEL_Switch'
    local pos
    local val = 75151
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_MIP_CHRONO_ELAPS_SEL_inc()
    local Lvar = 'VC_MIP_CHRONO_ELAPS_SEL_Switch'
    local pos
    local val = 75152
    pos = ipc.readLvar(Lvar)
    if pos < 20 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_MIP_CHRONO_ELAPS_SEL_run()
    local Lvar = 'VC_MIP_CHRONO_ELAPS_SEL_Switch'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        VC_MIP_CHRONO_ELAPS_SEL_dec()
        if pos > 10 then
            VC_MIP_CHRONO_ELAPS_SEL_dec()
        end
    end
    DspShow('CHRN', 'EPRN')
end

function VC_MIP_CHRONO_ELAPS_SEL_stop()
local Lvar = 'VC_MIP_CHRONO_ELAPS_SEL_Switch'
local pos
    pos = ipc.readLvar(Lvar)
    if pos > 10 then
        VC_MIP_CHRONO_ELAPS_SEL_dec()
    elseif pos < 10 then
        VC_MIP_CHRONO_ELAPS_SEL_inc()
    end
    DspShow('CHRN', 'EPSP')
end

function VC_MIP_CHRONO_ELAPS_SEL_reset()
    local Lvar = 'VC_MIP_CHRONO_ELAPS_SEL_Switch'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos < 20 then
        VC_MIP_CHRONO_ELAPS_SEL_inc()
        if pos < 10 then
            VC_MIP_CHRONO_ELAPS_SEL_inc()
        end
    end
    DspShow('CHRN', 'RSET')
end

function VC_MIP_CHRONO_ELAPS_SEL_toggle()
    local Lvar = 'VC_MIP_CHRONO_ELAPS_SEL_Switch'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos < 10 then
        VC_MIP_CHRONO_ELAPS_SEL_inc()
    else
        VC_MIP_CHRONO_ELAPS_SEL_run()
    end
end

function VC_MIP_CHRONO_ELAPS_SEL_cycle()
    local Lvar = 'VC_MIP_CHRONO_ELAPS_SEL_Switch'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos < 10 then
        VC_MIP_CHRONO_ELAPS_SEL_inc()
    elseif pos == 10 then
        VC_MIP_CHRONO_ELAPS_SEL_inc()
        ipc.sleep(150)
        VC_MIP_CHRONO_ELAPS_SEL_run()
    else
        VC_MIP_CHRONO_ELAPS_SEL_run()
    end
end

-- ## Standby Instruments

-- $$ Standby Artifical Horizon

function VC_ISIS_BUGS ()
    ipc.control(FSL, 75096)
    ipc.sleep(150)
    ipc.control(FSL, 75098)
    DspShow('ISIS', 'BUGS')
end

function VC_ISIS_LS ()
    ipc.control(FSL, 75100)
    ipc.sleep(150)
    ipc.control(FSL, 75102)
    DspShow ("ISIS", "LS")
end

function VC_ISIS_DIM_PLUS ()
    ipc.control(FSL, 75104)
    ipc.sleep(150)
    ipc.control(FSL, 75106)
    DspShow ("ISIS", "plus")
end

function VC_ISIS_DIM_MINUS ()
    ipc.control(FSL, 75108)
    ipc.sleep(150)
    ipc.control(FSL, 75110)
    DspShow ("ISIS", "mnus")
end

function VC_ISIS_RESET ()
    ipc.control(FSL, 75112)
    ipc.sleep(150)
    ipc.control(FSL, 75114)
    DspShow ("ISIS", "RSET")
end

function VC_ISIS_MODE_toggle ()
    ipc.control(FSL, 75116)
    ipc.sleep(150)
    ipc.control(FSL, 75118)
end

function VC_ISIS_KNOB_inc ()
    ipc.control(FSL, 75125)
    ipc.sleep(50)
    DspShow ("BARO", "inc")
end

function VC_ISIS_KNOB_dec ()
    ipc.control(FSL, 75126)
    ipc.sleep(50)
    DspShow ("BARO", "inc")
end

-- $$ DDRMI

function VC_MIP_DDRMI_VORADF_L_ADF()
    local Lvar = 'VC_MIP_DDRMI_VORADF_L_Switch'
    local pos
    local val = 75127
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_MIP_DDRMI_VORADF_L_VOR()
    local Lvar = 'VC_MIP_DDRMI_VORADF_L_Switch'
    local pos
    local val = 75128
    pos = ipc.readLvar(Lvar)
    if pos < 10 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_MIP_DDRMI_VORADF_R_ADF()
    local Lvar = 'VC_MIP_DDRMI_VORADF_R_Switch'
    local pos
    local val = 75132
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_MIP_DDRMI_VORADF_R_VOR()
    local Lvar = 'VC_MIP_DDRMI_VORADF_R_Switch'
    local pos
    local val = 75131
    pos = ipc.readLvar(Lvar)
    if pos < 10 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

-- ## Miscellaneous

-- $$ FIRE

function VC_OVHD_FIRE_ENG1_TEST_press()
    DspShow('FIRE', 'eng1')
    ipc.control(FSL, 72236)
    ipc.sleep(150)
end

function VC_OVHD_FIRE_ENG1_TEST_release()
    ipc.control(FSL, 72238)
    ipc.sleep(150)
end

function VC_OVHD_FIRE_ENG1_TEST()
    DspShow('FIRE', 'eng1')
    ipc.control(FSL, 72236)
    ipc.sleep(2500)
    ipc.control(FSL, 72238)
end

function VC_OVHD_FIRE_ENG2_TEST_press()
    DspShow('FIRE', 'eng2')
    ipc.control(FSL, 72240)
    ipc.sleep(150)
end

function VC_OVHD_FIRE_ENG2_TEST_release()
    ipc.control(FSL, 72242)
    ipc.sleep(150)
end

function VC_OVHD_FIRE_ENG2_TEST()
    DspShow('FIRE', 'eng2')
    ipc.control(FSL, 72240)
    ipc.sleep(2500)
    ipc.control(FSL, 72242)
end

function VC_OVHD_FIRE_APU_TEST_press()
    DspShow('FIRE', 'apu')
    ipc.control(FSL, 72244)
    ipc.sleep(150)
end

function VC_OVHD_FIRE_APU_TEST_release()
    ipc.control(FSL, 72246)
    ipc.sleep(150)
end

function VC_OVHD_FIRE_APU_TEST()
    DspShow('FIRE', 'apu')
    ipc.control(FSL, 72244)
    ipc.sleep(2500)
    ipc.control(FSL, 72246)
end

function VC_OVHD_FIRE_ALL_TEST_press()
    DspShow('FIRE', 'test')
    ipc.control(FSL, 72236)
    ipc.control(FSL, 72240)
    ipc.control(FSL, 72244)
end

function VC_OVHD_FIRE_ALL_TEST_release()
    ipc.control(FSL, 72238)
    ipc.control(FSL, 72242)
    ipc.control(FSL, 72246)
end

function VC_OVHD_FIRE_ALL_TEST()
    DspShow('FIRE', 'test')
    ipc.control(FSL, 72236)
    ipc.control(FSL, 72240)
    ipc.control(FSL, 72244)
    ipc.sleep(2500)
    ipc.control(FSL, 72238)
    ipc.control(FSL, 72242)
    ipc.control(FSL, 72246)
end

-- $$ RAT Manual On

function VC_OVHD_HYD_RAT_MAN_on()
    DspShow('RAT','on')
    ipc.control(FSL, 72253)
    ipc.sleep(50)
    ipc.control(FSL, 72256)
    ipc.sleep(500)
    ipc.control(FSL, 72258)
    ipc.sleep(50)
    ipc.control(FSL, 72259)
    ipc.sleep(50)
end

-- $$ Capt Wiper Left

function VC_OVHD_CP_WIPER_dec()
    local Lvar = 'VC_OVHD_WIPER_KNOB_LEFT_Knob'
    local pos
    local val = 72187
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_OVHD_CP_WIPER_inc()
    local Lvar = 'VC_OVHD_WIPER_KNOB_LEFT_Knob'
    local pos
    local val = 72188
    pos = ipc.readLvar(Lvar)
    if pos < 20 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_OVHD_CP_WIPER_off()
    local Lvar = 'VC_OVHD_WIPER_KNOB_LEFT_Knob'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        VC_OVHD_CP_WIPER_dec()
        if pos > 10 then
            VC_OVHD_CP_WIPER_dec()
        end
    end
    DspShow('WIPE', 'off')
end

function VC_OVHD_CP_WIPER_slow()
local Lvar = 'VC_OVHD_WIPER_KNOB_LEFT_Knob'
local pos
    pos = ipc.readLvar(Lvar)
    if pos > 10 then
        VC_OVHD_CP_WIPER_dec()
    elseif pos < 10 then
        VC_OVHD_CP_WIPER_inc()
    end
    DspShow('WIPE', 'slow')
end

function VC_OVHD_CP_WIPER_fast()
    local Lvar = 'VC_OVHD_WIPER_KNOB_LEFT_Knob'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos < 20 then
        VC_OVHD_CP_WIPER_inc()
        if pos < 10 then
            VC_OVHD_CP_WIPER_inc()
        end
    end
    DspShow('WIPE', 'fast')
end

function VC_OVHD_CP_WIPER_cycle()
    local Lvar = 'VC_OVHD_WIPER_KNOB_LEFT_Knob'
    local pos
    pos = ipc.readLvar(Lvar)
    if pos < 20 then
        VC_OVHD_CP_WIPER_inc()
    else
        VC_OVHD_CP_WIPER_off()
    end
end

-- $$ FO Wiper Right

function VC_OVHD_FO_WIPER_dec()
    local Lvar = 'VC_OVHD_WIPER_KNOB_RIGHT_Knob'
    local pos
    local val = 72946
    pos = ipc.readLvar(Lvar)
    if pos > 0 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_OVHD_FO_WIPER_inc()
    local Lvar = 'VC_OVHD_WIPER_KNOB_RIGHT_Knob'
    local pos
    local val = 72947
    pos = ipc.readLvar(Lvar)
    if pos < 20 then
        ipc.control(FSL, val)
        ipc.sleep(20)
    end
end

function VC_OVHD_FO_WIPER_off()
    local Lvar = 'VC_OVHD_WIPER_KNOB_RIGHT_Knob'
    local pos = ipc.readLvar(Lvar)
    if pos > 0 then
        VC_OVHD_FO_WIPER_dec()
        if pos > 10 then
            VC_OVHD_FO_WIPER_dec()
        end
    end
    DspShow('WIPE', 'off')
end

function VC_OVHD_FO_WIPER_slow()
    local Lvar = 'VC_OVHD_WIPER_KNOB_RIGHT_Knob'
    local pos = ipc.readLvar(Lvar)
    if pos > 10 then
        VC_OVHD_FO_WIPER_dec()
    elseif pos < 10 then
        VC_OVHD_FO_WIPER_inc()
    end
    DspShow('WIPE', 'slow')
end

function VC_OVHD_FO_WIPER_fast()
    local Lvar = 'VC_OVHD_WIPER_KNOB_RIGHT_Knob'
    local pos = ipc.readLvar(Lvar)
    if pos < 20 then
        VC_OVHD_FO_WIPER_inc()
        if pos < 10 then
            VC_OVHD_FO_WIPER_inc()
        end
    end
    DspShow('WIPE', 'fast')
end

function VC_OVHD_FO_WIPER_cycle()
    local Lvar = 'VC_OVHD_WIPER_KNOB_RIGHT_Knob'
    local pos = ipc.readLvar(Lvar)
    if pos < 20 then
        VC_OVHD_FO_WIPER_inc()
    else
        VC_OVHD_FO_WIPER_off()
    end
end

-- $$ Capt Wiper both

function VC_OVHD_BOTH_WIPER_dec()
    VC_OVHD_FO_WIPER_dec()
    _sleep(300,500)
    VC_OVHD_CP_WIPER_dec()
end

function VC_OVHD_BOTH_WIPER_inc()
    VC_OVHD_FO_WIPER_inc()
    _sleep(300,500)
    VC_OVHD_CP_WIPER_inc()
end

function VC_OVHD_BOTH_WIPER_off()
    VC_OVHD_FO_WIPER_off()
    _sleep(300,500)
    VC_OVHD_CP_WIPER_off()
end

function VC_OVHD_BOTH_WIPER_slow()
    VC_OVHD_FO_WIPER_slow()
    _sleep(300,500)
    VC_OVHD_CP_WIPER_slow()
end

function VC_OVHD_BOTH_WIPER_fast()
    VC_OVHD_FO_WIPER_fast()
    _sleep(300,500)
    VC_OVHD_CP_WIPER_fast()
end

function VC_OVHD_BOTH_WIPER_cycle()
    VC_OVHD_FO_WIPER_cycle()
    _sleep(300,500)
    VC_OVHD_CP_WIPER_cycle()
end

-- ## Pedestal ECAM

function VC_PED_ECAM_TOCONFIG_press()
local text1 = "ECAM"
local text2 = "T/O"
local Lvar = "VC_PED_ECP_TO_CONFIG_Button"
local mcro = "FSLA3XX_MAIN: ECAMTOCON"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_EMERGCANC_press()
local text1 = "ECAM"
local text2 = "CANC"
local Lvar = "VC_PED_ECP_EMER_CANC_Button"
local mcro = "FSLA3XX_MAIN: ECAMECAN"
local Lvar2 = "VC_PED_EMER_CANC_Guard"
local mcro2 = "FSLA3XX_MAIN: ECAMCANC"
local val = ipc.readLvar(Lvar2)
    if val == 0 then
        ipc.macro(mcro2, 1)
    end
    VC_Button_press(text1, text2, Lvar, mcro)
    ipc.sleep(100)
    ipc.macro(mcro2, 11)
end

function VC_PED_ECAM_CLR_press()
local text1 = "ECAM"
local text2 = "CLR"
local Lvar = "VC_PED_ECP_CLR_L_Button"
local mcro = "FSLA3XX_MAIN: ECAMCLRL"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_ENG_press()
local text1 = "ECAM"
local text2 = "ENG"
local Lvar = "VC_PED_ECP_ENG_Button"
local mcro = "FSLA3XX_MAIN: ECAMENG"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_BLEED_press()
local text1 = "ECAM"
local text2 = "BLED"
local Lvar = "VC_PED_ECP_BLEED_Button"
local mcro = "FSLA3XX_MAIN: ECAMBLEED"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_PRESS_press()
local text1 = "ECAM"
local text2 = "PRES"
local Lvar = "VC_PED_ECP_PRESS_Button"
local mcro = "FSLA3XX_MAIN: ECAMPRESS"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_ELEC_press()
local text1 = "ECAM"
local text2 = "ELEC"
local Lvar = "VC_PED_ECP_ELEC_Button"
local mcro = "FSLA3XX_MAIN: ECAMELEC"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_HYD_press()
local text1 = "ECAM"
local text2 = "HYD"
local Lvar = "VC_PED_ECP_HYD_Button"
local mcro = "FSLA3XX_MAIN: ECAMHYD"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_FUEL_press()
local text1 = "ECAM"
local text2 = "FUEL"
local Lvar = "VC_PED_ECP_FUEL_Button"
local mcro = "FSLA3XX_MAIN: ECAMFUEL"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_APU_press()
local text1 = "ECAM"
local text2 = "APU"
local Lvar = "VC_PED_ECP_APU_Button"
local mcro = "FSLA3XX_MAIN: ECAMAPU"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_COND_press()
local text1 = "ECAM"
local text2 = "COND"
local Lvar = "VC_PED_ECP_COND_Button"
local mcro = "FSLA3XX_MAIN: ECAMCOND"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_DOOR_press()
local text1 = "ECAM"
local text2 = "DOOR"
local Lvar = "VC_PED_ECP_DOOR_Button"
local mcro = "FSLA3XX_MAIN: ECAMDOOR"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_WHEEL_press()
local text1 = "ECAM"
local text2 = "WHEL"
local Lvar = "VC_PED_ECP_WHEEL_Button"
local mcro = "FSLA3XX_MAIN: ECAMWHEEL"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_FCTL_press()
local text1 = "ECAM"
local text2 = "FCTL"
local Lvar = "VC_PED_ECP_FCTL_Button"
local mcro = "FSLA3XX_MAIN: ECAMFCTL"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_ALL_press()
local text1 = "ECAM"
local text2 = "ALL"
local Lvar = "VC_PED_ECP_ALL_Button"
local mcro = "FSLA3XX_MAIN: ECAMALL"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_STS_press()
local text1 = "ECAM"
local text2 = "STS"
local Lvar = "VC_PED_ECP_STS_Button"
local mcro = "FSLA3XX_MAIN: ECAMSTS"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_ECAM_RCL_press()
local text1 = "ECAM"
local text2 = "RCL"
local Lvar = "VC_PED_ECP_RCL_Button"
local mcro = "FSLA3XX_MAIN: ECAMRCL"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- ## MCDU Left Modes

-- $$ MCDU Left BRT/DIM

function VC_PED_MDCU_L_KEY_BRT_press()
local text1 = "MCDU"
local text2 = "BRT"
local Lvar = "VC_PED_MCDU_L_KEY_BRT"
local mcro = "FSLA3XX_MAIN: CPMCDUBRT"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_BRT_hold()
local text1 = "MCDU"
local text2 = "BRT"
local Lvar = "VC_PED_MCDU_L_KEY_BRT"
local mcro = "FSLA3XX_MAIN: CPMCDUBRT"
    if ipc.readLvar(Lvar) == 0 then
        for i = 1, 20 do
        ipc.macro(mcro, 3)
        ipc.sleep(50)
        end
    end
    ipc.macro(mcro, 13)
end

function VC_PED_MDCU_L_KEY_DIM_press()
local text1 = "MCDU"
local text2 = "DIM"
local Lvar = "VC_PED_MCDU_L_KEY_DIM"
local mcro = "FSLA3XX_MAIN: CPMCDUDIM"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_DIM_hold()
local text1 = "MCDU"
local text2 = "DIM"
local Lvar = "VC_PED_MCDU_L_KEY_DIM"
local mcro = "FSLA3XX_MAIN: CPMCDUDIM"
    if ipc.readLvar(Lvar) == 0 then
        for i = 1, 20 do
        ipc.macro(mcro, 3)
        ipc.sleep(50)
        end
    end
    ipc.macro(mcro, 13)
end

-- $$ MCDU Left Functions

function VC_PED_MDCU_L_DIR_press()
local text1 = "MCDU"
local text2 = "DIR"
local Lvar = "VC_PED_MCDU_L_KEY_DIR"
local mcro = "FSLA3XX_MAIN: CPMCDUDIR"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_PROG_press()
local text1 = "MCDU"
local text2 = "PROG"
local Lvar = "VC_PED_MCDU_L_KEY_PROG"
local mcro = "FSLA3XX_MAIN: CPMCDUPROG"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_PERF_press()
local text1 = "MCDU"
local text2 = "PERF"
local Lvar = "VC_PED_MCDU_L_KEY_PERF"
local mcro = "FSLA3XX_MAIN: CPMCDUPERF"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_INIT_press()
local text1 = "MCDU"
local text2 = "INIT"
local Lvar = "VC_PED_MCDU_L_KEY_INIT"
local mcro = "FSLA3XX_MAIN: CPMCDUINIT"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_DATA_press()
local text1 = "MCDU"
local text2 = "DATA"
local Lvar = "VC_PED_MCDU_L_KEY_DATA"
local mcro = "FSLA3XX_MAIN: CPMCDUDATA"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_FPLN_press()
local text1 = "MCDU"
local text2 = "FPLN"
local Lvar = "VC_PED_MCDU_L_KEY_FPLN"
local mcro = "FSLA3XX_MAIN: CPMCDUFPLN"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_RADNAV_press()
local text1 = "MCDU"
local text2 = "RNAV"
local Lvar = "VC_PED_MCDU_L_KEY_RADNAV"
local mcro = "FSLA3XX_MAIN: CPMCDURADNAV"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_FUELPRED_press()
local text1 = "MCDU"
local text2 = "FUEL"
local Lvar = "VC_PED_MCDU_L_KEY_FUEL"
local mcro = "FSLA3XX_MAIN: CPMCDUFUELPRED"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_SECFPLN_press()
local text1 = "MCDU"
local text2 = "SEC"
local Lvar = "VC_PED_MCDU_L_KEY_SEC"
local mcro = "FSLA3XX_MAIN: CPMCDUSECFPLN"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_ATCCOMM_press()
local text1 = "MCDU"
local text2 = "AC"
local Lvar = "VC_PED_MCDU_L_KEY_ATC"
local mcro = "FSLA3XX_MAIN: CPMCDUATCCOMM"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_MENU_press()
local text1 = "MCDU"
local text2 = "MENU"
local Lvar = "VC_PED_MCDU_L_KEY_MENU"
local mcro = "FSLA3XX_MAIN: CPMCDUMENU"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_AIRPORT_press()
local text1 = "MCDU"
local text2 = "ARPT"
local Lvar = "VC_PED_MCDU_L_KEY_ARPT"
local mcro = "FSLA3XX_MAIN: CPMCDUAIRPORT"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- $$ MCDU Left Special Keys

function VC_PED_MDCU_L_KEY_SLASH_press()
local text1 = "MCDU"
local text2 = "SLSH"
local Lvar = "VC_PED_MCDU_L_KEY_SLASH"
local mcro = "FSLA3XX_MAIN: CPMCDUSLASH"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_SPACE_press()
local text1 = "MCDU"
local text2 = "SPC"
local Lvar = "VC_PED_MCDU_L_KEY_SPACE"
local mcro = "FSLA3XX_MAIN: CPMCDUSP"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_OVFY_press()
local text1 = "MCDU"
local text2 = "OVFY"
local Lvar = "VC_PED_MCDU_L_KEY_OVFY"
local mcro = "FSLA3XX_MAIN: CPMCDUOVFY"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_CLR_press()
local text1 = "MCDU"
local text2 = "CLR"
local Lvar = "VC_PED_MCDU_L_KEY_CLR"
local mcro = "FSLA3XX_MAIN: CPMCDUCLR"
    VC_Button_press(text1, text2, Lvar, mcro)
end


-- $$ MCDU Left Arrows

function VC_PED_MDCU_L_LEFT_press()
local text1 = "MCDU"
local text2 = "Left"
local Lvar = "VC_PED_MCDU_L_KEY_LEFT"
local mcro = "FSLA3XX_MAIN: CPMCDULARROW"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_RIGHT_press()
local text1 = "MCDU"
local text2 = "Rght"
local Lvar = "VC_PED_MCDU_L_KEY_RIGHT"
local mcro = "FSLA3XX_MAIN: CPMCDURARROW"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_UP_press()
local text1 = "MCDU"
local text2 = "Up"
local Lvar = "VC_PED_MCDU_L_KEY_UP"
local mcro = "FSLA3XX_MAIN: CPMCDUUPARROW"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_DOWN_press()
local text1 = "MCDU"
local text2 = "Up"
local Lvar = "VC_PED_MCDU_L_KEY_DOWN"
local mcro = "FSLA3XX_MAIN: CPMCDUDNARROW"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- ## MCDU Left Numbers

function VC_PED_MDCU_L_KEY_0_press()
local text1 = "MCDU"
local text2 = "0"
local Lvar = "VC_PED_MCDU_L_KEY_0"
local mcro = "FSLA3XX_MAIN: CPMCDU0"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_1_press()
local text1 = "MCDU"
local text2 = "1"
local Lvar = "VC_PED_MCDU_L_KEY_1"
local mcro = "FSLA3XX_MAIN: CPMCDU1"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_2_press()
local text1 = "MCDU"
local text2 = "2"
local Lvar = "VC_PED_MCDU_L_KEY_2"
local mcro = "FSLA3XX_MAIN: CPMCDU2"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_3_press()
local text1 = "MCDU"
local text2 = "3"
local Lvar = "VC_PED_MCDU_L_KEY_3"
local mcro = "FSLA3XX_MAIN: CPMCDU3"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_4_press()
local text1 = "MCDU"
local text2 = "4"
local Lvar = "VC_PED_MCDU_L_KEY_4"
local mcro = "FSLA3XX_MAIN: CPMCDU4"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_5_press()
local test = "5"
local Lvar = "VC_PED_MCDU_L_KEY_5"
local mcro = "FSLA3XX_MAIN: CPMCDU5"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_6_press()
local text1 = "MCDU"
local text2 = "6"
local Lvar = "VC_PED_MCDU_L_KEY_6"
local mcro = "FSLA3XX_MAIN: CPMCDU6"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_7_press()
local text1 = "MCDU"
local text2 = "7"
local Lvar = "VC_PED_MCDU_L_KEY_7"
local mcro = "FSLA3XX_MAIN: CPMCDU7"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_8_press()
local text1 = "MCDU"
local text2 = "8"
local Lvar = "VC_PED_MCDU_L_KEY_8"
local mcro = "FSLA3XX_MAIN: CPMCDU8"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_9_press()
local text1 = "MCDU"
local text2 = "9"
local Lvar = "VC_PED_MCDU_L_KEY_9"
local mcro = "FSLA3XX_MAIN: CPMCDU9"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_DOT_press()
local text1 = "MCDU"
local text2 = "DOT"
local Lvar = "VC_PED_MCDU_L_KEY_DOT"
local mcro = "FSLA3XX_MAIN: CPMCDUDOT"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_PLUSMINUS_press()
local text1 = "MCDU"
local text2 = "+/-"
local Lvar = "VC_PED_MCDU_L_KEY_PLUSMINUS"
local mcro = "FSLA3XX_MAIN: CPMCDUPLUSMIN"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- ## MCDU Left Letters

function VC_PED_MDCU_L_KEY_A_press()
local text1 = "MCDU"
local text2 = "A"
local Lvar = "VC_PED_MCDU_L_KEY_A"
local mcro = "FSLA3XX_MAIN: CPMCDUA"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_B_press()
local text1 = "MCDU"
local text2 = "A"
local Lvar = "VC_PED_MCDU_L_KEY_B"
local mcro = "FSLA3XX_MAIN: CPMCDUB"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_C_press()
local test = "C"
local Lvar = "VC_PED_MCDU_L_KEY_C"
local mcro = "FSLA3XX_MAIN: CPMCDUC"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_D_press()
local text1 = "MCDU"
local text2 = "D"
local Lvar = "VC_PED_MCDU_L_KEY_D"
local mcro = "FSLA3XX_MAIN: CPMCDUD"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_E_press()
local text1 = "MCDU"
local text2 = "E"
local Lvar = "VC_PED_MCDU_L_KEY_E"
local mcro = "FSLA3XX_MAIN: CPMCDUE"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_F_press()
local text1 = "MCDU"
local text2 = "F"
local Lvar = "VC_PED_MCDU_L_KEY_F"
local mcro = "FSLA3XX_MAIN: CPMCDUF"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_G_press()
local text1 = "MCDU"
local text2 = "G"
local Lvar = "VC_PED_MCDU_L_KEY_G"
local mcro = "FSLA3XX_MAIN: CPMCDUG"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_H_press()
local text1 = "MCDU"
local text2 = "H"
local Lvar = "VC_PED_MCDU_L_KEY_H"
local mcro = "FSLA3XX_MAIN: CPMCDUH"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_I_press()
local text1 = "MCDU"
local text2 = "I"
local Lvar = "VC_PED_MCDU_L_KEY_I"
local mcro = "FSLA3XX_MAIN: CPMCDUI"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_J_press()
local test = "J"
local Lvar = "VC_PED_MCDU_L_KEY_J"
local mcro = "FSLA3XX_MAIN: CPMCDUJ"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_K_press()
local text1 = "MCDU"
local text2 = "K"
local Lvar = "VC_PED_MCDU_L_KEY_K"
local mcro = "FSLA3XX_MAIN: CPMCDUK"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_L_press()
local text1 = "MCDU"
local text2 = "L"
local Lvar = "VC_PED_MCDU_L_KEY_L"
local mcro = "FSLA3XX_MAIN: CPMCDUL"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_M_press()
local text1 = "MCDU"
local text2 = "M"
local Lvar = "VC_PED_MCDU_L_KEY_M"
local mcro = "FSLA3XX_MAIN: CPMCDUM"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_N_press()
local text1 = "MCDU"
local text2 = "N"
local Lvar = "VC_PED_MCDU_L_KEY_N"
local mcro = "FSLA3XX_MAIN: CPMCDUN"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_O_press()
local text1 = "MCDU"
local text2 = "O"
local Lvar = "VC_PED_MCDU_L_KEY_O"
local mcro = "FSLA3XX_MAIN: CPMCDUO"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_P_press()
local text1 = "MCDU"
local text2 = "P"
local Lvar = "VC_PED_MCDU_L_KEY_P"
local mcro = "FSLA3XX_MAIN: CPMCDUP"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_Q_press()
local text1 = "MCDU"
local text2 = "Q"
local Lvar = "VC_PED_MCDU_L_KEY_Q"
local mcro = "FSLA3XX_MAIN: CPMCDUQ"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_R_press()
local text1 = "MCDU"
local text2 = "R"
local Lvar = "VC_PED_MCDU_L_KEY_R"
local mcro = "FSLA3XX_MAIN: CPMCDUR"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_S_press()
local text1 = "MCDU"
local text2 = "S"
local Lvar = "VC_PED_MCDU_L_KEY_S"
local mcro = "FSLA3XX_MAIN: CPMCDUS"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_T_press()
local test = "T"
local Lvar = "VC_PED_MCDU_L_KEY_T"
local mcro = "FSLA3XX_MAIN: CPMCDUT"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_U_press()
local text1 = "MCDU"
local text2 = "U"
local Lvar = "VC_PED_MCDU_L_KEY_U"
local mcro = "FSLA3XX_MAIN: CPMCDUU"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_V_press()
local test = "V"
local Lvar = "VC_PED_MCDU_L_KEY_V"
local mcro = "FSLA3XX_MAIN: CPMCDUV"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_W_press()
local text1 = "MCDU"
local text2 = "W"
local Lvar = "VC_PED_MCDU_L_KEY_W"
local mcro = "FSLA3XX_MAIN: CPMCDUW"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_X_press()
local text1 = "MCDU"
local text2 = "X"
local Lvar = "VC_PED_MCDU_L_KEY_X"
local mcro = "FSLA3XX_MAIN: CPMCDUX"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_Y_press()
local text1 = "MCDU"
local text2 = "Y"
local Lvar = "VC_PED_MCDU_L_KEY_Y"
local mcro = "FSLA3XX_MAIN: CPMCDUY"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_KEY_Z_press()
local text1 = "MCDU"
local text2 = "Z"
local Lvar = "VC_PED_MCDU_L_KEY_Z"
local mcro = "FSLA3XX_MAIN: CPMCDUZ"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- ## MCDU Left LSK Keys

function VC_PED_MDCU_L_L1_press()
local text1 = "MCDU"
local text2 = "L1"
local Lvar = "VC_PED_MCDU_L_LSK_L1"
local mcro = "FSLA3XX_MAIN: CPMCDUL1"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_L2_press()
local text1 = "MCDU"
local text2 = "L2"
local Lvar = "VC_PED_MCDU_L_LSK_L2"
local mcro = "FSLA3XX_MAIN: CPMCDUL2"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_L3_press()
local text1 = "MCDU"
local text2 = "L3"
local Lvar = "VC_PED_MCDU_L_LSK_L3"
local mcro = "FSLA3XX_MAIN: CPMCDUL3"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_L4_press()
local text1 = "MCDU"
local text2 = "L4"
local Lvar = "VC_PED_MCDU_L_LSK_L4"
local mcro = "FSLA3XX_MAIN: CPMCDUL4"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_L5_press()
local text1 = "MCDU"
local text2 = "L5"
local Lvar = "VC_PED_MCDU_L_LSK_L5"
local mcro = "FSLA3XX_MAIN: CPMCDUL5"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_L6_press()
local text1 = "MCDU"
local text2 = "L6"
local Lvar = "VC_PED_MCDU_L_LSK_L6"
local mcro = "FSLA3XX_MAIN: CPMCDUL6"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_R1_press()
local text1 = "MCDU"
local text2 = "R1"
local Lvar = "VC_PED_MCDU_L_LSK_R1"
local mcro = "FSLA3XX_MAIN: CPMCDUR1"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_R2_press()
local text1 = "MCDU"
local text2 = "R2"
local Lvar = "VC_PED_MCDU_L_LSK_R2"
local mcro = "FSLA3XX_MAIN: CPMCDUR2"
local val = ipc.readLvar(Lvar)
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_R3_press()
local text1 = "MCDU"
local text2 = "R3"
local Lvar = "VC_PED_MCDU_L_LSK_R3"
local mcro = "FSLA3XX_MAIN: CPMCDUR3"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_R4_press()
local text1 = "MCDU"
local text2 = "R4"
local Lvar = "VC_PED_MCDU_L_LSK_R4"
local mcro = "FSLA3XX_MAIN: CPMCDUR4"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_R5_press()
local text1 = "MCDU"
local text2 = "R5"
local Lvar = "VC_PED_MCDU_L_LSK_R5"
local mcro = "FSLA3XX_MAIN: CPMCDUR5"
    VC_Button_press(text1, text2, Lvar, mcro)
end

function VC_PED_MDCU_L_R6_press()
local text1 = "MCDU"
local text2 = "R6"
local Lvar = "VC_PED_MCDU_L_LSK_R6"
local mcro = "FSLA3XX_MAIN: CPMCDUR6"
    VC_Button_press(text1, text2, Lvar, mcro)
end

-- ## Module Functions - DO NOT USE

function VC_Button_press(txt1, txt2, var, mac)
    if (txt1 == nil) or (txt2 == nil) or
        (var == nil) or (mac == nil) then return end
    local val = ipc.readLvar(var)
    _loggg('Lvar = ' .. var .. ' = ' .. val)
    if ipc.readLvar(var) ~= 0 then
        ipc.macro(mac, 13)
        ipc.sleep(400)
    end
    if ipc.readLvar(var) == 0 then
        ipc.macro(mac, 3)
        ipc.sleep(400)
    end
    ipc.macro(mac, 13)
    DspShow (txt1, txt2)
end

-- $$ MCP XPND code update
function VC_PED_ATCXPDR_MCPUpdate ()
    -- called from event with 0x0354 changed in virtual cockpit
    trn_vfr_tmp = true
    Default_XPND_select()
end

--]]
-- ##############################################################################


