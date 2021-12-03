-- QW787 Module --
-- Version 1.1
-- Andrew Gransden and Peter Harrison
-- Mar 2020

-- ## System functions ##

function InitVars ()

    -- uncomment to disable display
    -- AutopilotDisplayBlocked ()
    AutoDisplay = false
    QW_Menu = 0
    QW_ND = 0
    QW_NDFlag = 0

    event.Lvar('KEY_TOGGLE_FLIGHT_DIRECTOR', 100, 'QW_Key_FD')
end

function Timer()
    --DisplayAutopilotInfo()
    --DisplayFlightInfo()
    DisplayResync()
end 

function InitDsp()

end

function QW_Key_FD(val)
    _loggg('[Q787] FD Key operated' .. val)
end

-- ## Display Functions

function QW_DspSPD()
   	SyncBackSPD (0, ipc.readUW(0x07E2), true)
end

function QW_DspHDG()
	SyncBackHDG (0, ipc.readUW(0x07CC), true)
end

function QW_DspALT()
	SyncBackALT (0, ipc.readUD(0x07D4), true)
end

function QW_DspVS()
	SyncBackVVS (0, ipc.readUW(0x07F2), true)
end


-- ## AP Knobs

-- $$ AP Speed

function QW_AP_Spd_inc ()
local SPD = ipc.readUW(0x07E2)
    --ipc.control(65896, 0)
    SPD = SPD + 1
    ipc.control(66037, SPD)
    QW_DspSPD()
    QW_Switch_Rotary()
    ipc.sleep(10)
end

function QW_AP_Spd_incfast ()
local SPD = ipc.readUW(0x07E2)
    SPD = SPD + 5
    ipc.control(66037, SPD)
    QW_DspSPD()
    QW_Switch_Rotary()
    ipc.sleep(10)
end

function QW_AP_Spd_dec ()
local SPD = ipc.readUW(0x07E2)
    SPD = SPD - 1
    ipc.control(66037, SPD)
    QW_DspSPD()
    QW_Switch_Rotary()
    ipc.sleep(10)
end

function QW_AP_Spd_decfast ()
local SPD = ipc.readUW(0x07E2)
    SPD = SPD - 5
    ipc.control(66037, SPD)
    QW_DspSPD()
    QW_Switch_Rotary()
    ipc.sleep(10)
end

-- $$ AP Heading

function QW_AP_Hdg_inc ()
local HDG = ipc.readUW(0x07CC)
    HDG = round(HDG / 65536 * 360) + 1
    _loggg('[Q787] HDG+  = ' .. HDG)
    if HDG > 360 then
        HDG = 0
    end
    ipc.control(66042, HDG)
    QW_DspHDG()
    QW_Switch_Rotary()
    ipc.sleep(10)
end

function QW_AP_Hdg_incfast ()
local HDG = ipc.readUW(0x07CC)
    HDG = (HDG / 65536 * 360) + 5
    _loggg('[Q787] HDG++ = ' .. HDG)
    if HDG > 360 then
        HDG = 0
    end
    ipc.control(66042, HDG)
    QW_DspHDG()
    QW_Switch_Rotary()
    ipc.sleep(10)
end

function QW_AP_Hdg_dec ()
local HDG = ipc.readUW(0x07CC)
    HDG = round(HDG / 65536 * 360) - 1
    _loggg('[Q787] HDG-  = ' .. HDG)
    if HDG < 0 then
        HDG = 359
    end
    ipc.control(66042, HDG)
    QW_DspHDG()
    QW_Switch_Rotary()
    ipc.sleep(10)
end

function QW_AP_Hdg_decfast ()
local HDG = ipc.readUW(0x07CC)
    HDG = (HDG / 65536 * 360) - 5
    _loggg('[Q787] HDG-- = ' .. HDG)
    if HDG < 0 then
        HDG = 359
    end
    ipc.control(66042, HDG)
    QW_DspHDG()
    QW_Switch_Rotary()
    ipc.sleep(10)
end

-- $$ AP Altitude

function QW_AP_Alt_inc ()
local ALT = ipc.readUD(0x07D4)
local lvar = 'QW_MCP_ALT_AUTO_Knob'
local lval = ipc.readLvar(lvar)
    ALT = round(ALT / 65536 * 3.28084)
    if lval == 0 then
        ALT = ALT + 100
    else
        if ALT <= 0 then
            ALT = 1000
        else
            ALT = round(ALT / 1000 - 0.5) * 1000
            ALT = ALT + 1000
        end
    end
    ipc.control(66124, ALT)
    QW_DspALT()
    QW_Switch_Rotary()
end

function QW_AP_Alt_incfast ()
local ALT = ipc.readUD(0x07D4)
local lvar = 'QW_MCP_ALT_AUTO_Knob'
local lval = ipc.readLvar(lvar)
    ALT = round(ALT / 65536 * 3.28084)
    _loggg('[Q787] AP ALT = ' .. ALT)
    if lval == 0 then
        ALT = ALT + 500
    else
        if ALT <= 0 then
            ALT = 1000
        else
            ALT = round(ALT / 1000 - 0.5) * 1000
            ALT = ALT + 1000
        end
    end
    ipc.control(66124, ALT)
    QW_DspALT()
    QW_Switch_Rotary()
end

function QW_AP_Alt_dec ()
local ALT = ipc.readUD(0x07D4)
local lvar = 'QW_MCP_ALT_AUTO_Knob'
local lval = ipc.readLvar(lvar)
    ALT = round(ALT / 65536 * 3.28084)
    if lval == 0 then
        ALT = ALT - 100
    else
        ALT = round(ALT / 1000 - 0.5) * 1000
        ALT = ALT - 1000
    end
    ipc.control(66124, ALT)
    QW_DspALT()
    QW_Switch_Rotary()
end

function QW_AP_Alt_decfast ()
local ALT = ipc.readUD(0x07D4)
local lvar = 'QW_MCP_ALT_AUTO_Knob'
local lval = ipc.readLvar(lvar)
    ALT = round(ALT / 65536 * 3.28084)
    if lval == 0 then
        ALT = ALT - 500
    else
        ALT = round(ALT / 1000 - 0.5) * 1000
        ALT = ALT - 1000
    end
    ipc.control(66124, ALT)
    QW_DspALT()
    QW_Switch_Rotary()
end

-- $$ AP VS Wheel

function QW_AP_VS_down ()
local lvar = 'QW_MCP_VS_TRIMWHEEL_pos'
local lval = ipc.readLvar(lvar)
local VS = ipc.readSW(0x07F2)
    if (VS > -8000) then
        VS = VS - 100
        ipc.writeUW(0x07F2, VS)
        if lval > 0 then
            ipc.writeLvar(lvar, lval - 1)
        else
            ipc.writeLvar(lvar, 0)
        end
        DspShow('VS', 'down')
        QW_DspVS()
        QW_Switch_Rotary()
    end
end

function QW_AP_VS_up ()
local lvar = 'QW_MCP_VS_TRIMWHEEL_pos'
local lval = ipc.readLvar(lvar)
local VS = ipc.readSW(0x07F2)
    if VS < 6000 then
        VS = VS + 100
        ipc.writeUW(0x07F2, VS)
        if lval < 34 then
            ipc.writeLvar(lvar, lval + 1)
        else
            ipc.writeLvar(lvar, 0)
        end
        DspShow('VS', 'up')
        QW_DspVS()
        QW_Switch_Rotary()
    end
end

-- ## MCP panel Left to Right

-- $$ AP Master Switches

function QW_AP_MasterLeft_on ()
local lvar = 'QW_ap_master_l'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.control(65792, 0)
        --ipc.writeLvar(lvar, '1')
        DspShow('AP L', 'on')
        QW_Switch_Small()
    end
end

function QW_AP_MasterLeft_off ()
local lvar = 'QW_ap_master_l'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.control(65791, 0)
        --ipc.writeLvar(lvar, '0')
        DspShow('AP L', 'off')
        QW_Switch_Small()
    end
end

function QW_AP_MasterLeft_toggle ()
local lvar = 'QW_ap_master_l'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_AP_MasterLeft_off()
    else
        QW_AP_MasterLeft_on()
    end
end

-- $$ MCP FD left

function QW_MCP_L_FD_on ()
local lvar = 'QW_MCP_L_FD_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('FD L', 'on')
        QW_Switch_Large()
    end
end

function QW_MCP_L_FD_off ()
local lvar = 'QW_MCP_L_FD_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('FD L', 'off')
        QW_Switch_Large()
    end
end

function QW_MCP_L_FD_toggle ()
local lvar = 'QW_MCP_L_FD_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_MCP_L_FD_off()
    else
        QW_MCP_L_FD_on()
    end
end

-- $$ A/T ARM

function QW_AT_L_Arm_on ()
local lvar = 'at_armed_left'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('AT L', 'on')
        QW_Switch_Large()
    end
end

function QW_AT_L_Arm_off ()
local lvar = 'at_armed_left'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('AT L', 'off')
        QW_Switch_Large()
    end
end

function QW_AT_L_Arm_toggle ()
local lvar = 'at_armed_left'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_AT_L_Arm_off()
    else
        QW_AT_L_Arm_on()
    end
end

function QW_AT_R_Arm_on ()
local lvar = 'at_armed_right'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('AT R', 'on')
        QW_Switch_Large()
    end
end

function QW_AT_R_Arm_off ()
local lvar = 'at_armed_right'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('AT R', 'off')
        QW_Switch_Large()
    end
end

function QW_AT_R_Arm_toggle ()
local lvar = 'at_armed_right'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_AT_R_Arm_off()
    else
        QW_AT_R_Arm_on()
    end
end

function QW_AT_Both_Arm_on ()
    QW_AT_L_Arm_on()
    QW_AT_R_Arm_on()
end

function QW_AT_Both_Arm_off ()
    QW_AT_L_Arm_off()
    QW_AT_R_Arm_off()
end

function QW_AT_Both_Arm_toggle ()
    QW_AT_L_Arm_toggle()
    QW_AT_R_Arm_toggle()
end

-- $$ TOGA

function QW_MCP_TOGA_press ()
    ipc.control(65861, 0)
    DspShow('TOGA', 'pres')
    QW_Switch_Small()
end

-- $$ AP CLB/CON

function QW_MCP_CLB_CON_press ()
local lvar1 = 'QW_MCP_HDG_TRK_Button'
    --ipc.writeLvar(lvar1, '1')
    ipc.control(66711, 0)
    DspShow('CLBC', 'pres')
    QW_Switch_Small()
end

-- $$ AP A/T

function QW_MCP_AT_press ()
local lvar1 = 'AT_MODE'
    --ipc.writeLvar(lvar1, '1')
    ipc.control(65859, 0)
    DspShow('A/T', 'pres')
    QW_Switch_Small()
end

-- $$ AP IAS-MACH

function QW_MCP_IAS_MACH_press ()
local lvar1 = 'QW_MCP_IAS_MACH_Button'
    --ipc.writeLvar(lvar1, '1')
    ipc.control(65918, 0)
    DspShow('MACH', 'pres')
    QW_Switch_Small()
end

-- $$ AP VS-FPA

function QW_MCP_VS_FPA_press ()
local lvar1 = 'KEY_AP_ATT_HOLD_ON'
    --ipc.writeLvar(lvar1, '2')
    ipc.control(65804, 0)
    DspShow('VFPA', 'pres')
    QW_Switch_Small()
end

function QW_MCP_VS_FPA_select ()
local lvar1 = 'KEY_AP_PANEL_ALTITUDE_HOLD'
    --ipc.writeLvar(lvar1, '2')
    ipc.control(65799, 0)
    DspShow('VS', 'pres')
    QW_Switch_Small()
end

-- $$ AP SPD XFR

-- $$ AP NAV MODES LNAV/VNAV/FLCH

function QW_MCP_LNAV_press ()
local lvar1 = 'ap_lat_mode_clicked'
    --ipc.writeLvar(lvar1, '6')
    ipc.control(65729, 0)
    DspShow('LNAV', 'pres')
    QW_Switch_Small()
end

function QW_MCP_VNAV_press ()
local lvar1 = 'ap_vert_mode_clicked'
    --ipc.writeLvar(lvar1, '5')
    ipc.control(65727, 0)
    DspShow('LNAV', 'pres')
    QW_Switch_Small()
end

function QW_MCP_FLCH_press ()
local lvar1 = 'ap_vert_mode_clicked'
    --ipc.writeLvar(lvar1, '4')
    ipc.control(65722,0)
    DspShow('FLCH', 'pres')
    QW_Switch_Small()
end

-- $$ AP Master Disconnect

function QW_MCP_AP_Disengage_on ()
local lvar = 'ap_master_disconnect' --
local lvar2 = 'QW_MCP_AP_DISENGAGE_Bar'
local lval = ipc.readLvar(lvar)
    if lval2 ~= 0 then
        ipc.writeLvar(lvar, '0')
        ipc.writeLvar(lvar2, 0)
        DspShow('AP D', 'on')
        QW_Switch_Large()
    end
end

function QW_MCP_AP_Disengage_off ()
local lvar = 'ap_master_disconnect'
local lvar2 = 'QW_MCP_AP_DISENGAGE_Bar'
local lval = ipc.readLvar(lvar)
    if lval2 ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.writeLvar(lvar2, 1)
        DspShow('AP D', 'off')
        QW_Switch_Large()
    end
end

function QW_MCP_AP_Disengage_toggle ()
local lvar = 'QW_MCP_AP_DISENGAGE_Bar'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_MCP_AP_Disengage_off()
    else
        QW_MCP_AP_Disengage_on()
    end
end

-- $$ AP Heading/Track

function QW_MCP_HDG_TRK_hdg ()
local lvar = 'QW_MCP_HDG_TRK_Status'
local lvar2 = 'QW_MCP_HDG_TRK_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        --ipc.writeLvar(lvar2, '1')
        ipc.control(66106, 0)
        DspShow('H/T', 'hdg')
        QW_Switch_Small()
    end
end

function QW_MCP_HDG_TRK_trk ()
local lvar = 'QW_MCP_HDG_TRK_Status'
local lvar2 = 'QW_MCP_HDG_TRK_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        --ipc.writeLvar(lvar2, '1')
        ipc.control(66106, 0)
        DspShow('H/T', 'trk')
        QW_Switch_Small()
    end
end

function QW_MCP_HDG_TRK_toggle ()
local lvar = 'QW_MCP_HDG_TRK_Status'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_MCP_HDG_TRK_trk()
    else
        QW_MCP_HDG_TRK_hdg()
    end
end

-- $$ AP HDG XFR

-- $$ AP Bank Angle

function QW_MCP_BNK_LIMIT_inc ()
local lvar = 'QW_MCP_BNK_LIMIT_Knob'
local lval = ipc.readLvar(lvar)
    if lval < 6 then
        --ipc.writeLvar(lvar, lval + 1)
        ipc.control(66709, 0)
        QW_MCP_BANK_LIMIT_show ()
        QW_Switch_Rotary()
    end
    ipc.sleep(10)
end

function QW_MCP_BNK_LIMIT_dec ()
local lvar = 'QW_MCP_BNK_LIMIT_Knob'
local lval = ipc.readLvar(lvar)
    if lval > 0 then
        --ipc.writeLvar(lvar, lval - 1)
        ipc.control(66710, 0)
        QW_MCP_BANK_LIMIT_show ()
        QW_Switch_Rotary()
    end
    ipc.sleep(10)
end

function QW_MCP_BNK_LIMIT_cycle ()
local lvar = 'QW_MCP_BNK_LIMIT_Knob'
local lval = ipc.readLvar(lvar)
local i = 5
    if lval < i then
        QW_MCP_BNK_LIMIT_inc()
    else
        while i > 0 do
            QW_MCP_BNK_LIMIT_dec()
            i = i - 1
        end
    end
    ipc.sleep(10)
end

function QW_MCP_BANK_LIMIT_show ()
local lvar = 'QW_MCP_BNK_LIMIT_Knob'
local lval = ipc.readLvar(lvar)
local ltxt = '--'
    if lval == 0 then
        ltxt = 'auto'
    elseif lval == 1 then
        ltxt = '10'
    elseif lval == 2 then
        ltxt = '15'
    elseif lval == 3 then
        ltxt = '20'
    elseif lval == 4 then
        ltxt = '25'
    elseif lval == 5 then
        ltxt = '30'
    elseif lval == 6 then
        ltxt = 'limt'
    else
        ltaxt = 'err'
    end
    DspShow('BLIM', ltxt)
end

-- $$ AP HDG SEL / HOLD

function QW_MCP_HDG_SEL_press ()
local lvar = 'ap_lat_mode'
local lvar1 = 'ap_lat_mode_clicked'
    --ipc.writeLvar(lvar, 3)
    --ipc.writeLvar(lvar1, '0')
    ipc.control(65798, 0)
    DspShow('HSEL', 'pres')
    QW_Switch_Small()
end

function QW_MCP_HDG_HOLD_press ()
local lvar1 = 'ap_lat_mode'
    --ipc.writeLvar(lvar1, 2)
    ipc.control(65725, 0)
    DspShow('HHLD', 'pres')
    QW_Switch_Small()
end

-- $$ AP VS/FPA

function QW_MCP_VS_FPA_press ()
local lvar1 = 'ap_vert_mode_clicked'
    --ipc.writeLvar(lvar1, '2')
    ipc.control(65804, 0)
    DspShow('VFPA', 'pres')
    QW_Switch_Small()
end

-- $$ AP ALT Hold

function QW_MCP_ALT_INTV_press ()
local lvar1 = 'KEY_AP_ALT_HOLD_ON'
    ipc.control(65808, 0)
    --ipc.writeLvar(lvar1, '1')
    DspShow('ALTS', 'pres')
    QW_Switch_Small()
end

function QW_MCP_ALT_HOLD_press ()
local lvar = 'ap_vert_mode_clicked'
    ipc.writeLvar(lvar, '1')
    DspShow('ALTH', 'pres')
    QW_Switch_Small()
    --ipc.writeUW(0x07F2, 0)
end

-- $$ AP ALT Increment Auto-1000

function QW_MCP_ALT_AUTO_auto ()
local lvar = 'QW_MCP_ALT_AUTO_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('ALT', 'auto')
        QW_Switch_Small()
    end
end

function QW_MCP_ALT_AUTO_1000 ()
local lvar = 'QW_MCP_ALT_AUTO_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('ALT', '1000')
        QW_Switch_Small()
    end
end

function QW_MCP_ALT_AUTO_toggle ()
local lvar = 'QW_MCP_ALT_AUTO_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_MCP_ALT_AUTO_1000()
    else
        QW_MCP_ALT_AUTO_auto()
    end
end

-- $$ AP ALT Hold

function QW_MCP_ALT_SEL_press ()
local lvar1 = 'ap_vert_mode_clicked'
    ipc.control(65804, 0)
    --ipc.writeLvar(lvar1, '1')
    DspShow('ALTS', 'pres')
    QW_Switch_Small()
end

function QW_MCP_ALT_HOLD_press ()
local lvar1 = 'ap_vert_mode_clicked'
    ipc.control(65726, 0)
    --ipc.writeLvar(lvar1, '3')
    DspShow('ALTH', 'pres')
    QW_Switch_Small()
    --ipc.writeUW(0x07F2, 0)
end

-- $$ AP LOC/FAC + APP

function QW_MCP_LOC_press ()
local lvar1 = 'ap_lat_mode_armed'
local lvar2 = 'ap_lat_mode_clicked'
local lval = ipc.readLvar(lvar1)
    --Autopilot_LOC_hold()
    ipc.control(65723, 0)
    if lval ~= 7 then
        ipc.writeLvar(lvar2, '7')
        DspShow('LOC', 'on')
        QW_Switch_Small()
    else
        ipc.writeLvar(lvar2, '0')
        DspShow('LOC', 'off')
        QW_Switch_Small()
    end
end

function QW_MCP_APP_press ()
local lvar1 = 'ap_vert_mode_armed'
local lvar2 = 'ap_lat_mode_armed'
local lval = ipc.readLvar(lvar1)
    Autopilot_APR_hold()
    if lval == 0 or lval == nil then
        ipc.writeLvar(lvar1, 10)
        ipc.writeLvar(lvar2, 7)
        DspShow('APP', 'on')
        QW_Switch_Small()
    else
        ipc.writeLvar(lvar1, 0)
        ipc.writeLvar(lvar2, 0)
        DspShow('APP', 'off')
        QW_Switch_Small()
    end
end

-- $$ AP Master Right

function QW_AP_MasterRight_on ()
local lvar = 'QW_ap_master_r'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('AP R', 'on')
        QW_Switch_Large()
    end
end

function QW_AP_MasterRight_off ()
local lvar = 'QW_ap_master_r'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('AP L', 'off')
        QW_Switch_Large()
    end
end

function QW_AP_MasterRight_toggle ()
local lvar = 'QW_ap_master_r'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_AP_MasterRight_off()
    else
        QW_AP_MasterRight_on()
    end
end

-- $$ MCP FD Right

function QW_MCP_R_FD_on ()
local lvar = 'QW_MCP_R_FD_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('FD R', 'on')
        QW_Switch_Large()
    end
end

function QW_MCP_R_FD_off ()
local lvar = 'QW_MCP_R_FD_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('FD R', 'off')
        QW_Switch_Large()
    end
end

function QW_MCP_R_FD_toggle ()
local lvar = 'QW_MCP_R_FD_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_MCP_R_FD_off()
    else
        QW_MCP_R_FD_on()
    end
end

-- ## MCP Baro/ND panel

function QW_MCP_BARO_show ()
    Altimeter_BARO_show()
end

function QW_MCP_BARO_inc ()
    Altimeter_BARO_plus()
    QW_Switch_Rotary()
end

function QW_MCP_BARO_incfast ()
    Altimeter_BARO_plusfast()
    QW_Switch_Rotary()
end

function QW_MCP_BARO_dec ()
    Altimeter_BARO_minus()
    QW_Switch_Rotary()
end

function QW_MCP_BARO_decfast ()
    Altimeter_BARO_minusfast()
    QW_Switch_Rotary()
end

-- $$ MINS Knob

function QW_MCP_MINS_inc()
local lvar = 'QW_MCP_L_SEL_RB_Knob'
local lval = ipc.readLvar(lvar)
    if lval >= 18 then
        lval = -1
    end
    ipc.writeLvar(lvar, lval + 1)
    DspShow('MINS','inc')
    QW_Switch_Rotary()
    _sleep(10)
end

function QW_MCP_MINS_dec()
local lvar = 'QW_MCP_L_SEL_RB_Knob'
local lval = ipc.readLvar(lvar)
    if lval <= 0 then
        lval = 19
    end
    ipc.writeLvar(lvar, lval - 1)
    DspShow('MINS','dec')
    QW_Switch_Rotary()
    _sleep(10)
end

-- $$ MINS Radio/Baro

function QW_MCP_L_RadBaro_baro ()
local lvar = 'QW_MCP_L_RADIO_BARO_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('Mins', 'baro')
        QW_Switch_Rotary()
    end
end

function QW_MCP_L_RadBaro_radio ()
local lvar = 'QW_MCP_L_RADIO_BARO_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('Mins', 'rad')
        QW_Switch_Rotary()
    end
end

function QW_MCP_L_RadBaro_toggle ()
local lvar = 'QW_MCP_L_RADIO_BARO_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_MCP_L_RadBaro_radio()
    else
        QW_MCP_L_RadBaro_baro()
    end
end

-- $$ MINS RST

function QW_MCP_L_RST_press ()
lvar = 'QW_MCP_L_RB_RST_Button'
lval = ipc.readLvar(lvar)
    if lval == null then
        lval = -1
        ipc.macro("QW787: RST", 3)
    end
    _loggg('[B787] RST = ' .. lval)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('RST', 'off')
    else
        ipc.writeLvar(lvar, '1')
        DspShow('RST', 'on')
    end
    QW_Switch_Small()
end

-- $$ Baroset

function QW_MCP_L_BaroSet_In ()
local lvar = 'QW_MCP_L_BAROSET_Knob'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: STD", 3)
    end
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('Baro', 'in')
        QW_Switch_Large()
    end
end

function QW_MCP_L_BaroSet_HPa ()
local lvar = 'QW_MCP_L_BAROSET_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('Baro', 'hPa')
        QW_Switch_Large()
    end
end

function QW_MCP_L_BaroSet_toggle ()
local lvar = 'QW_MCP_L_BAROSET_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_MCP_L_BaroSet_HPa()
    else
        QW_MCP_L_BaroSet_In()
    end
end

-- $$ Baroset Standard

function QW_MCP_L_BaroStd_press ()
local lvar = 'QW_MCP_L_BRST_STD_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: STD", 3)
    end
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
    else
        ipc.writeLvar(lvar, '1')
    end
    DspShow('STD', 'pres')
    QW_Switch_Small()
end

-- $$ FPV

function QW_MCP_L_FPV_press ()
local lvar = 'QW_MCP_L_FPV_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: FPV", 3)
    end
    ipc.writeLvar(lvar, '1')
    DspShow('FPV', 'on')
    QW_Switch_Small()
end

-- $$ MTRS

function QW_MCP_L_MTRS_press ()
local lvar = 'QW_MCP_L_MTRS_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: MTRS", 3)
    end
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('MTRS', 'off')
        QW_Switch_Small()
    else
        ipc.writeLvar(lvar, '1')
        DspShow('MTRS', 'on')
        QW_Switch_Small()
    end
end

-- $$ ND Range

function QW_MCP_L_ND_Rng_inc ()
local lvar = 'QW_MCP_L_RANGE_Knob'
local lval = ipc.readLvar(lvar)
_loggg('[Q787] Rng inc  ' .. lval)
    if lval < 11 then
        ipc.writeLvar(lvar, lval + 1)
        QW_MCP_L_ND_Rng_show ()
        QW_Switch_Rotary()
    end
    ipc.sleep(10)
end

function QW_MCP_L_ND_Rng_dec ()
local lvar = 'QW_MCP_L_RANGE_Knob'
local lval = ipc.readLvar(lvar)
_loggg('[Q787] Rng dec  ' .. lval)
    if lval > 0 then
        ipc.writeLvar(lvar, lval - 1)
        QW_MCP_L_ND_Rng_show ()
        QW_Switch_Rotary()
    end
    ipc.sleep(10)
end

-- $$ ND Menu

function QW_MCP_L_NDMAP_inc ()
local lvar = 'QW_MCP_L_NDMAP_Knob'
local lval = ipc.readLvar(lvar)
    _loggg('[Q787] M_inc = ' .. lval .. '  - QW_Menu=' .. QW_Menu .. ' / QW_ND=' .. QW_ND .. ' / QW_Flag=' .. QW_NDFlag)
    if QW_NDFlag == 0 then
        if (QW_Menu == 1) and (QW_ND == 0) and (lval < 14) then
            _loggg('[Q787] menu ND0')
            ipc.writeLvar(lvar, lval + 1)
            QW_Switch_Rotary()
        elseif (QW_Menu == 1) and (QW_ND == 1) and (lval < 7) then
            _loggg('[Q787] menu ND1')
            ipc.writeLvar(lvar, lval + 1)
            QW_Switch_Rotary()
        elseif (lval < 2) then
            _loggg('[Q787] no menu')
            ipc.writeLvar(lvar, lval + 1)
            QW_Switch_Rotary()
        else
            _loggg('[Q787] no action')
        end
    else
        QW_NDFlag = 0
    end
    ipc.sleep(20)
    lval = ipc.readLvar(lvar)
    _loggg('[Q787] M_inc = ' .. lval .. '  - QW_Menu=' .. QW_Menu .. ' / QW_ND=' .. QW_ND .. ' / QW_Flag=' .. QW_NDFlag)
end

function QW_MCP_L_NDMAP_dec ()
local lvar = 'QW_MCP_L_NDMAP_Knob'
local lval = ipc.readLvar(lvar)
    _loggg('[Q787] M_dec = ' .. lval .. '  - QW_Menu=' .. QW_Menu .. ' / QW_ND=' .. QW_ND .. ' / QW_Flag=' .. QW_NDFlag)
    if QW_NDFlag == 0 then
        if lval > 0 then
            ipc.writeLvar(lvar, lval - 1)
            QW_Switch_Rotary()
        else
            ipc.writeLvar(lvar, 0)
            QW_Switch_Rotary()
        end
    else
        QW_NDFlag = 0
    end
    ipc.sleep(20)
    lval = ipc.readLvar(lvar)
    _loggg('[Q787] M_dec = ' .. lval .. '  - QW_Menu=' .. QW_Menu .. ' / QW_ND=' .. QW_ND .. ' / QW_Flag=' .. QW_NDFlag)
end

-- $$ ND Plan Menu

function QW_MCP_L_NDMAP_press ()
local lvar = 'QW_MCP_L_NDMAP_Knob_PUSH'
local lvar2 = 'QW_MCP_L_NDMAP_Knob'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: NDMAP", 3)
        QW_NDFlag = 1
        QW_Menu = 0
        QW_ND = 0
        _loggg('[Q787] NDMAP nil')
    end
    local lval2 = ipc.readLvar(lvar2)
    if lval == nil then lval = 0 end
    _loggg('[Q787] Mbeg = ' .. lval2 .. '  - QW_Menu=' .. QW_Menu .. ' / QW_ND=' .. QW_ND)
    QW_NDFlag = 1
    if lval2 == 0 then -- MAP mode
        ipc.writeLvar(lvar, 1)
        QW_Switch_Small()
        if QW_ND ~= 0 then
            QW_ND = 0
        end
        ipc.sleep(50)
    elseif lval2 == 1 then -- PLAN mode
        ipc.writeLvar(lvar, 1)
        QW_Switch_Small()
        if QW_ND ~= 1 then
            QW_ND = 1
        end
        ipc.sleep(50)
    elseif lval2 == 2 then -- MENU list
        ipc.writeLvar(lvar, 1)
        QW_Switch_Small()
        if QW_Menu == 1 then
            QW_Menu = 0
        else
            QW_Menu = 1
            ipc.writeLvar(lvar, 1)
        end
        lval2 = 2
        ipc.writeLvar(lvar2, lval2)
        ipc.sleep(50)
    elseif ((QW_ND == 0) and (lval2 == 14)) then
        ipc.writeLvar(lvar, 1)
        QW_Switch_Small()
        ipc.sleep(50)
        QW_Menu = 0
        lval2 = 2
        ipc.writeLvar(lvar2, lval2)
    elseif ((QW_ND == 1) and (lval2 == 7)) then
        ipc.writeLvar(lvar, 1)
        QW_Switch_Small()
        ipc.sleep(50)
        QW_Menu = 0
        lval2 = 2
        ipc.writeLvar(lvar2, lval2)
    else
        ipc.writeLvar(lvar, 1)
    end
    ipc.sleep(100)
    lval = ipc.readLvar(lvar)
    lval2 = ipc.readLvar(lvar2)
    if lval == nil then lval = 0 end
    _loggg('[Q787] Mend = ' .. lval2 .. '  - QW_Menu=' .. QW_Menu .. ' / QW_ND=' .. QW_ND)
end

-- $$ ND Menu Reset

function QW_MCP_L_NDMAP_reset ()
local lvar = 'QW_MCP_L_NDMAP_Knob_PUSH'
local lvar2 = 'QW_MCP_L_NDMAP_Knob'
local lval = ipc.readLvar(lvar)
local lval2 = ipc.readLvar(lvar2)
    QW_Menu = 0
    ipc.writeLvar(lvar2, lval2)
    QW_Switch_Small()
    if lval2 ~= 2 then ipc.writeLvar(lvar, 1) end
    _loggg('[Q787] MReset = ' .. lval2 .. '  - QW_Menu=' .. QW_Menu .. ' / QW_ND=' .. QW_ND)
end

-- $$ ND Range

function QW_MCP_L_ND_Rng_inc ()
local lvar = 'QW_MCP_L_RANGE_Knob'
local lval = ipc.readLvar(lvar)
_loggg('[Q787] Rng inc  ' .. lval)
    if lval < 11 then
        ipc.writeLvar(lvar, lval + 1)
        QW_MCP_L_ND_Rng_show ()
        QW_Switch_Rotary()
    end
    ipc.sleep(10)
end

function QW_MCP_L_ND_Rng_dec ()
local lvar = 'QW_MCP_L_RANGE_Knob'
local lval = ipc.readLvar(lvar)
_loggg('[Q787] Rng dec  ' .. lval)
    if lval > 0 then
        ipc.writeLvar(lvar, lval - 1)
        QW_MCP_L_ND_Rng_show ()
        QW_Switch_Rotary()
    end
    ipc.sleep(10)
end

function QW_MCP_L_ND_Rng_show ()
local lvar = 'QW_MCP_L_RANGE_Knob'
local lval = ipc.readLvar(lvar)
_loggg('[Q787] Rng Show = ' .. lval)
local ltxt = '--'
    if lval == 0 then
        ltxt = '0.5'
    elseif lval == 1 then
        ltxt = '1'
    elseif lval == 2 then
        ltxt = '2'
    elseif lval == 3 then
        ltxt = '5'
    elseif lval == 4 then
        ltxt = '10'
    elseif lval == 5 then
        ltxt = '20'
    elseif lval == 6 then
        ltxt = '40'
    elseif lval == 7 then
        ltxt = '80'
    elseif lval == 8 then
        ltxt = '160'
    elseif lval == 9 then
        ltxt = '320'
    elseif lval == 10 then
        ltxt = '640'
    elseif lval == 11 then
        ltxt = '1280'
    else
        ltaxt = 'err'
    end
    DspShow('NDRG', ltxt)
end

-- $$ ND Range CTR

function QW_MCP_L_NDRngCtr_press ()
local lvar = 'QW_MCP_L_RNG_CTR_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('CTR', 'pres')
        QW_Switch_Small()
    end
end

-- $$ ND WXR

function QW_MCP_L_WXR_press ()
local lvar = 'QW_MCP_L_WXR_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: WX", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('WXR', 'pres')
        QW_Switch_Small()
    end
end

-- $$ ND TFC

function QW_MCP_L_TFC_press ()
local lvar = 'QW_MCP_L_TFC_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: TFC", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('TFC', 'pres')
        QW_Switch_Small()
    end
end

-- $$ ND TERR

function QW_MCP_L_TERR_press ()
local lvar = 'QW_MCP_L_TERR_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: TERR", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('TERR', 'pres')
        QW_Switch_Small()
    end
end

-- ## MCP Warning Panel L

function QW_MCP_L_WARNING_press ()
local lvar = 'QW_MCP_L_WARNING_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('WARN', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_ACPT_press ()
local lvar = 'QW_MCP_L_ACPT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('ACPT', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_CANC_press ()
local lvar = 'QW_MCP_L_CANC_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('CANC', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_RJCT_press ()
local lvar = 'QW_MCP_L_CANC_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('RJCT', 'pres')
        QW_Switch_Small()
    end
end

-- ## MCP ND Options L

function QW_MCP_L_SYS_press ()
local lvar = 'QW_MCP_L_SYS_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: SYS", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('SYS', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_CDU_press ()
local lvar = 'QW_MCP_L_CDU_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: CDU", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('CDU', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_INFO_press ()
local lvar = 'QW_MCP_L_INFO_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: INFO", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('INFO', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_CHKL_press ()
local lvar = 'QW_MCP_L_CHKL_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: CHKL", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('CHKL', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_COMM_press ()
local lvar = 'QW_MCP_L_COMM_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: COMM", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('COMM', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_ND_press ()
local lvar = 'QW_MCP_L_ND_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: ND", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('ND', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_EICAS_press ()
local lvar = 'QW_MCP_L_EICAS_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: EICAS", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('EICAS', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_ENG_press ()
local lvar = 'QW_MCP_L_ENG_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: ENG", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('ENG', 'pres')
        QW_Switch_Small()
    end
end

function QW_MCP_L_CANRCL_press ()
local lvar = 'QW_MCP_L_CANRCL_Button'
local lval = ipc.readLvar(lvar)
    if lval == nil then
        ipc.macro("QW787: CANC", 3)
    end
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('CRCL', 'pres')
        QW_Switch_Small()
    end
end


-- ## Overhead 1 HUD & Wipers

function QW_HUD_DECLUT ()
local lvar = 'QW_Wheel_L_HUD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('WHUD', 'pres')
        QW_Switch_Small()
    else
        ipc.writeLvar(lvar, '0')
        DspShow('WHUD', 'pres')
        QW_Switch_Small()
    end
end

-- $$ Overhead HUD Left

function QW_HUD_Left_on ()
local lvar = 'QW_Left_Hud'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('HUDL', 'on')
        QW_Switch_Large()
    end
end

function QW_HUD_Left_off ()
local lvar = 'QW_Left_Hud'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('HUDL', 'off')
        QW_Switch_Large()
    end
end

function QW_HUD_Left_toggle ()
local lvar = 'QW_Left_Hud'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_HUD_Left_off()
    else
        QW_HUD_Left_on()
    end
end

-- $$ Overhead HUD Right

function QW_HUD_Right_on ()
local lvar = 'QW_Right_Hud'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('HUDR', 'on')
        QW_Switch_Large()
    end
end

function QW_HUD_Right_off ()
local lvar = 'QW_Right_Hud'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('HUDR', 'off')
        QW_Switch_Large()
    end
end

function QW_HUD_Right_toggle ()
local lvar = 'QW_Right_Hud'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_HUD_Right_off()
    else
        QW_HUD_Right_on()
    end
end

-- $$ Overhead Wipers L

-- ## Overhead Internal Lights

function QW_OH_EMER_LTS_SWITCH_off ()
local lvar = 'QW_OH_EMER_LTS_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~= -1 then
        ipc.writeLvar(lvar, '-1')
        DspShow('EMER LTS ', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_EMER_LTS_SWITCH_Armed()
local lvar = 'QW_OH_EMER_LTS_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('EMER LTS ', 'Armed')
        QW_Switch_Small()
    end
end

function QW_OH_EMER_LTS_SWITCH_on ()
local lvar = 'QW_OH_EMER_LTS_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~=1 then
        ipc.writeLvar(lvar, '1')
        DspShow('EMER LTS ', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_EMER_LTS_SWITCH_toggle ()
local lvar = 'QW_OH_EMER_LTS_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~= -1 then
        QW_OH_EMER_LTS_SWITCH_off()
    else
        QW_OH_EMER_LTS_SWITCH_Armed()
    end
end

function QW_OH_EMER_LTS_SWITCH_cyclepfc ()
local lvar = 'QW_OH_EMER_LTS_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval < 0 then
        QW_OH_EMER_LTS_SWITCH_Armed()
    elseif lval < 1 then
        QW_OH_EMER_LTS_SWITCH_on()
    else
        QW_OH_EMER_LTS_SWITCH_off()
    end
end

-- $$ Overhead Panel Light

function QW_OH_TEXT_on ()
local lvar = 'QW_OH_TEXT'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('TEXT', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_TEXT_off ()
local lvar = 'QW_OH_TEXT'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('TEXT', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_TEXT_toggle ()
local lvar = 'QW_OH_TEXT'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_TEXT_off()
    else
        QW_OH_TEXT_on()
    end
end

-- $$ Overhead Dome Light

function QW_OH_DOME_on ()
local lvar = 'QW_OH_DOME_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('DOME', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_DOME_off ()
local lvar = 'QW_OH_DOME_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('DOME', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_DOME_toggle ()
local lvar = 'QW_OH_DOME_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_DOME_off()
    else
        QW_OH_DOME_on()
    end
end

-- $$ Storm Light

function QW_OH_STORM_on ()
local lvar = 'QW_OH_STORM_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('LDGL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_STORM_off ()
local lvar = 'QW_OH_STORM_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('LDGL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_STORM_toggle ()
local lvar = 'QW_OH_STORM_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_STORM_off()
    else
        QW_OH_STORM_on()
    end
end

-- $$ Overhead Master Brightness

function QW_OH_MSTR_BRT_dec ()
local lvar = 'QW_OH_MSTR_BRGHT_Knob'
local lval = ipc.readLvar(lvar)
    if lval > 0 then
        ipc.writeLvar(lvar, lval - 1)
        DspShow('MBRT', 'dec')
        QW_Switch_Rotary()
    end
end

function QW_OH_MSTR_BRT_inc ()
local lvar = 'QW_OH_MSTR_BRGHT_Knob'
local lval = ipc.readLvar(lvar)
    if lval < 4 then
        ipc.writeLvar(lvar, lval + 1)
        DspShow('MBRT', 'inc')
        QW_Switch_Rotary()
    end
end

function QW_OH_MSTR_BRT_min ()
local lvar = 'QW_OH_MSTR_BRGHT_Knob'
local lval = ipc.readLvar(lvar)
    if lval > 0 then
        ipc.writeLvar(lvar, 0)
        DspShow('MBRT', 'min')
        QW_Switch_Rotary()
    end
end

function QW_OH_MSTR_BRT_max ()
local lvar = 'QW_OH_MSTR_BRGHT_Knob'
local lval = ipc.readLvar(lvar)
    if lval < 4 then
        ipc.writeLvar(lvar, 4)
        DspShow('MBRT', 'max')
        QW_Switch_Rotary()
    end
end


-- $$ Master Brightness Test Light

function QW_OH_MSTR_BRT_TEST_on ()
local lvar = 'QW_OH_MSTR_BRGHT_Knob'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('MTST', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_MSTR_BRT_TEST_off ()
local lvar = 'QW_OH_MSTR_BRGHT_Knob_TEST'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('MTST', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_MSTR_BRT_TEST_toggle ()
local lvar = 'QW_OH_MSTR_BRGHT_Knob_TEST'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_MSTR_BRT_TEST_off()
    else
        QW_OH_MSTR_BRT_TEST_on()
    end
end

-- ## Overhead External Lights

-- $$ Landing Left Light

function QW_OH_LDG_LEFT_on ()
local lvar = 'QW_OH_LDG_LEFT_Switch'
local lval = ipc.readLvar(lvar)
    _loggg('[Q787] QW_OH_LDG_LEFT_on ' .. lval)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('LDGL', 'on')
        QW_Switch_Large()
        ipc.sleep(300)
    end
end

function QW_OH_LDG_LEFT_off ()
local lvar = 'QW_OH_LDG_LEFT_Switch'
local lval = ipc.readLvar(lvar)
    _loggg('[Q787] QW_OH_LDG_LEFT_off ' .. lval)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('LDGL', 'off')
        QW_Switch_Large()
        ipc.sleep(300)
    end
end

function QW_OH_LDG_LEFT_toggle ()
local lvar = 'QW_OH_LDG_LEFT_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LDG_LEFT_off()
    else
        QW_OH_LDG_LEFT_on()
    end
end

-- $$ Landing Nose Light

function QW_OH_LDG_NOSE_on ()
local lvar = 'QW_OH_LDG_NSE_Switch'
local lval = ipc.readLvar(lvar)
    _loggg('[Q787] QW_OH_LDG_NOSE_on ' .. lval)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('LDGN', 'on')
        QW_Switch_Large()
        ipc.sleep(300)
    end
end

function QW_OH_LDG_NOSE_off ()
local lvar = 'QW_OH_LDG_NSE_Switch'
local lval = ipc.readLvar(lvar)
    _loggg('[Q787] QW_OH_LDG_NOSE_off ' .. lval)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('LDGN', 'off')
        QW_Switch_Large()
        ipc.sleep(300)
    end
end

function QW_OH_LDG_NOSE_toggle ()
local lvar = 'QW_OH_LDG_NSE_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LDG_NOSE_off()
    else
        QW_OH_LDG_NOSE_on()
    end
end

-- $$ Landing Right Light

function QW_OH_LDG_RIGHT_on ()
local lvar = 'QW_OH_LDG_RIGHT_Switch'
local lval = ipc.readLvar(lvar)
    _loggg('[Q787] QW_OH_LDG_RIGHT_on ' .. lval)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('LDGN', 'on')
        QW_Switch_Large()
        ipc.sleep(300)
    end
end

function QW_OH_LDG_RIGHT_off ()
local lvar = 'QW_OH_LDG_RIGHT_Switch'
local lval = ipc.readLvar(lvar)
    _loggg('[Q787] QW_OH_LDG_RIGHT_off ' .. lval)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('LDGN', 'off')
        QW_Switch_Large()
        ipc.sleep(300)
    end
end

function QW_OH_LDG_RIGHT_toggle ()
local lvar = 'QW_OH_LDG_RIGHT_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LDG_RIGHT_off()
    else
        QW_OH_LDG_RIGHT_on()
    end
end

-- $$ Landing Light All

function QW_OH_LDG_ALL_on ()
    QW_OH_LDG_LEFT_on()
    ipc.sleep(200)
    QW_OH_LDG_NOSE_on()
    ipc.sleep(200)
    QW_OH_LDG_RIGHT_on()
    ipc.sleep(200)
end

function QW_OH_LDG_ALL_off ()
    QW_OH_LDG_LEFT_off()
    ipc.sleep(200)
    QW_OH_LDG_NOSE_off()
    ipc.sleep(200)
    QW_OH_LDG_RIGHT_off()
    ipc.sleep(200)
end

function QW_OH_LDG_ALL_toggle ()
    QW_OH_LDG_LEFT_toggle()
    ipc.sleep(200)
    QW_OH_LDG_NOSE_toggle()
    ipc.sleep(200)
    QW_OH_LDG_RIGHT_toggle()
    ipc.sleep(200)
end

-- $$ Beacon Light

function QW_OH_LT_BEACON_on ()
local lvar = 'QW_OH_LT_BEACON_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('BCN', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_LT_BEACON_off ()
local lvar = 'QW_OH_LT_BEACON_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('BCN', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_LT_BEACON_toggle ()
local lvar = 'QW_OH_LT_BEACON_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LT_BEACON_off()
    else
        QW_OH_LT_BEACON_on()
    end
end

-- $$ Nav Light

function QW_OH_LT_NAV_on ()
local lvar = 'QW_OH_LT_NAV_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('NAV', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_LT_NAV_off ()
local lvar = 'QW_OH_LT_NAV_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('NAV', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_LT_NAV_toggle ()
local lvar = 'QW_OH_LT_NAV_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LT_NAV_off()
    else
        QW_OH_LT_NAV_on()
    end
end

-- $$ Logo Light

function QW_OH_LT_LOGO_on ()
local lvar = 'QW_OH_LT_LOGO_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('LOGO', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_LT_LOGO_off ()
local lvar = 'QW_OH_LT_LOGO_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('LOGO', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_LT_LOGO_toggle ()
local lvar = 'QW_OH_LT_LOGO_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LT_LOGO_off()
    else
        QW_OH_LT_LOGO_on()
    end
end

-- $$ Wing Light

function QW_OH_LT_WING_on ()
local lvar = 'QW_OH_LT_WING_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('WING', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_LT_WING_off ()
local lvar = 'QW_OH_LT_WING_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('WING', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_LT_WING_toggle ()
local lvar = 'QW_OH_LT_WING_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LT_WING_off()
    else
        QW_OH_LT_WING_on()
    end
end

-- $$ Runway L Light

function QW_OH_LT_L_RWYTF_on ()
local lvar = 'QW_OH_LT_L_RWYTF_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('RWYL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_LT_L_RWYTF_off ()
local lvar = 'QW_OH_LT_L_RWYTF_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('RWYL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_LT_L_RWYTF_toggle ()
local lvar = 'QW_OH_LT_L_RWYTF_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LT_L_RWYTF_off()
    else
        QW_OH_LT_L_RWYTF_on()
    end
end

-- $$ Runway R Light

function QW_OH_LT_R_RWYTF_on ()
local lvar = 'QW_OH_LT_R_RWYTF_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('RWYR', 'on')
        QW_Switch_Large()
    end
end

function QW_OH_LT_R_RWYTF_off ()
local lvar = 'QW_OH_LT_R_RWYTF_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('RWYR', 'off')
        QW_Switch_Large()
    end
end

function QW_OH_LT_R_RWYTF_toggle ()
local lvar = 'QW_OH_LT_R_RWYTF_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LT_R_RWYTF_off()
    else
        QW_OH_LT_R_RWYTF_on()
    end
end

-- $$ Runway Light Both

function QW_OH_LT_Both_RWYTF_on ()
    QW_OH_LT_L_RWYTF_on ()
    QW_OH_LT_R_RWYTF_on ()
end

function QW_OH_LT_Both_RWYTF_off ()
    QW_OH_LT_L_RWYTF_off ()
    QW_OH_LT_R_RWYTF_off ()
end

function QW_OH_LT_Both_RWYTF_toggle ()
    QW_OH_LT_L_RWYTF_toggle ()
    QW_OH_LT_R_RWYTF_toggle ()
end

-- $$ Taxi Light

function QW_OH_LT_TAXI_on ()
local lvar = 'QW_OH_LT_TAXI_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('TAXI', 'on')
        QW_Switch_Large()
    end
end

function QW_OH_LT_TAXI_off ()
local lvar = 'QW_OH_LT_TAXI_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('TAXI', 'off')
        QW_Switch_Large()
    end
end

function QW_OH_LT_TAXI_toggle ()
local lvar = 'QW_OH_LT_TAXI_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LT_TAXI_off()
    else
        QW_OH_LT_TAXI_on()
    end
end

-- $$ Strobe Light

function QW_OH_LT_STROBE_on ()
local lvar = 'QW_OH_LT_STROBE_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('STRB', 'on')
        QW_Switch_Large()
    end
end

function QW_OH_LT_STROBE_off ()
local lvar = 'QW_OH_LT_STROBE_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('STRB', 'off')
        QW_Switch_Large()
    end
end

function QW_OH_LT_STROBE_toggle ()
local lvar = 'QW_OH_LT_STROBE_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_LT_STROBE_off()
    else
        QW_OH_LT_STROBE_on()
    end
end

-- ## Overhead 1 Electical

-- $$ Battery

function QW_OH_ELE_BATT_on ()
local lvar = 'QW_OH_ELE_BAT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, 1)
        DspShow('BATT', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_ELE_BATT_off ()
local lvar = 'QW_OH_ELE_BAT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, 0)
        DspShow('BATT', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_ELE_BATT_toggle ()
local lvar = 'QW_OH_ELE_BAT_Button'
local lval = ipc.readLvar(lvar)
_loggg('[Q787] BATT toggle = ' .. lval)
    if lval ~= 0 then
        QW_OH_ELE_BATT_off()
    else
        QW_OH_ELE_BATT_on()
    end
end

-- $$ APU Start

function QW_OH_ELE_APU_off ()
local lvar = 'QW_OH_ELE_APU_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('APU', 'on')
        QW_Switch_Rotary()
    end
end

function QW_OH_ELE_APU_on ()
local lvar = 'QW_OH_ELE_APU_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('APU', 'on')
        QW_Switch_Rotary()
    end
end

function QW_OH_ELE_APU_start ()
local lvar = 'QW_OH_ELE_APU_Switch'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_OH_ELE_APU_on()
        ipc.sleep(500)
    end
    lval = ipc.readLvar(lvar)
    if lval ~= 2 and lval == 1 then
        ipc.writeLvar(lvar, '2')
        DspShow('APU', 'strt')
        QW_Switch_Rotary()
    end
end

function QW_OH_ELE_APU_toggle ()
local lvar = 'QW_OH_ELE_APU_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_ELE_APU_off()
    else
        QW_OH_ELE_APU_on()
    end
end

function QW_OH_ELE_APU_cycle ()
local lvar = 'QW_OH_ELE_APU_Switch'
local lvar2 = 'qw_apu_rpm'
local lval = ipc.readLvar(lvar)
local lval2 = ipc.readLvar(lvar2)
    if lval == 0 then
        QW_OH_ELE_APU_on()
    elseif lval == 1 then
        if lval2 < 90 then
            QW_OH_ELE_APU_start()
        else
            QW_OH_ELE_APU_off()
        end
    end
end

-- $$ IFE/Pass Seats

function QW_OH_PASS_SEATS_on ()
local lvar = 'QW_OH_PASS_SEATS_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('SEAT', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_PASS_SEATS_off ()
local lvar = 'QW_OH_PASS_SEATS_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('SEAT', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_PASS_SEATS_toggle ()
local lvar = 'QW_OH_PASS_SEATS_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_PASS_SEATS_off()
    else
        QW_OH_PASS_SEATS_on()
    end
end

-- $$ Cabin/Utility

function QW_OH_CAB_UTIL_on ()
local lvar = 'QW_OH_CAB_UTIL_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('UTIL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_CAB_UTIL_off ()
local lvar = 'QW_OH_CAB_UTIL_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('UTIL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_CAB_UTIL_toggle ()
local lvar = 'QW_OH_CAB_UTIL_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_CAB_UTIL_off()
    else
        QW_OH_CAB_UTIL_on()
    end
end

-- $$ APU Generators

function QW_OH_APU_GEN_BOTH_on ()
local lvar = 'QW_OH_APU_GEN_LEFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('APUL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_APU_GEN_BOTH_off ()
local lvar = 'QW_OH_APU_GEN_LEFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('APUL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_APU_GEN_BOTH_toggle ()
local lvar = 'QW_OH_APU_GEN_LEFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_APU_GEN_BOTH_off()
    else
        QW_OH_APU_GEN_BOTH_on()
    end
end

-- $$ Forward External Power

function QW_OH_FWDEXTPWR_BOTH_on ()
local lvar = 'QW_OH_FWDEXTPWR_LEFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('APUL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FWDEXTPWR_BOTH_off ()
local lvar = 'QW_OH_FWDEXTPWR_LEFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('APUL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FWDEXTPWR_BOTH_toggle ()
local lvar = 'QW_OH_FWDEXTPWR_LEFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FWDEXTPWR_BOTH_off()
    else
        QW_OH_FWDEXTPWR_BOTH_on()
    end
end

-- $$ Aft External Power

function QW_OH_AFTEXTPWR_on ()
local lvar = 'QW_OH_AFTEXTPWR_MAIN_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('APUL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_AFTEXTPWR_off ()
local lvar = 'QW_OH_AFTEXTPWR_MAIN_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('APUL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_AFTEXTPWR_toggle ()
local lvar = 'QW_OH_AFTEXTPWR_MAIN_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_AFTEXTPWR_off()
    else
        QW_OH_AFTEXTPWR_on()
    end
end

-- $$ Gen Control L1

function QW_OH_GENCTL_L1_on ()
local lvar = 'QW_OH_GENCTL_L1_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('GCL1', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_GENCTL_L1_off ()
local lvar = 'QW_OH_GENCTL_L1_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('GCL1', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_GENCTL_L1_toggle ()
local lvar = 'QW_OH_GENCTL_L1_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_GENCTL_L1_off()
    else
        QW_OH_GENCTL_L1_on()
    end
end

-- $$ Gen Control L2

function QW_OH_GENCTL_L2_on ()
local lvar = 'QW_OH_GENCTL_L2_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('GCL2', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_GENCTL_L2_off ()
local lvar = 'QW_OH_GENCTL_L2_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('GCL2', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_GENCTL_L2_toggle ()
local lvar = 'QW_OH_GENCTL_L2_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_GENCTL_L2_off()
    else
        QW_OH_GENCTL_L2_on()
    end
end

-- $$ Gen Control R1

function QW_OH_GENCTL_R1_on ()
local lvar = 'QW_OH_GENCTL_R1_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('GCR1', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_GENCTL_R1_off ()
local lvar = 'QW_OH_GENCTL_R1_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('GCR1', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_GENCTL_R1_toggle ()
local lvar = 'QW_OH_GENCTL_R1_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_GENCTL_R1_off()
    else
        QW_OH_GENCTL_R1_on()
    end
end

-- $$ Gen Control R2

function QW_OH_GENCTL_R2_on ()
local lvar = 'QW_OH_GENCTL_R2_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('GCR2', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_GENCTL_R2_off ()
local lvar = 'QW_OH_GENCTL_R2_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('GCR2', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_GENCTL_R2_toggle ()
local lvar = 'QW_OH_GENCTL_R2_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_GENCTL_R2_off()
    else
        QW_OH_GENCTL_R2_on()
    end
end

-- ## Overhead 1 Primary Flt Computers

function QW_OH_PFC_G_Switch_Auto ()
local lvar = 'QW_OH_PFC_G_Switch'
local lvar2 = 'QW_OH_PFC_Safety_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(200)
        ipc.writeLvar(lvar, '0')
        DspShow('PFC', 'Auto')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        ipc.sleep(200)
        QW_Switch_Small()
    end
end

function QW_OH_PFC_G_Switch_Disc ()
local lvar = 'QW_OH_PFC_G_Switch'
local lvar2 = 'QW_OH_PFC_Safety_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar, '1')
        DspShow('PFC', 'Disc')
        QW_Switch_Small()
    end
end

function QW_OH_PFC_G_Switch_toggle ()
local lvar = 'QW_OH_PFC_G_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_PFC_G_Switch_Auto()
    else
        QW_OH_PFC_G_Switch_Disc()
    end
end

-- ## Overhead 1 IRS

-- $$ IRS LEFT

function QW_OH_IRS_LEFT_Switch_on ()
local lvar = 'QW_OH_IRS_LEFT_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('IRSL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_IRS_LEFT_Switch_off ()
local lvar = 'QW_OH_IRS_LEFT_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('IRSL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_IRS_LEFT_Switch_toggle ()
local lvar = 'QW_OH_IRS_LEFT_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_OH_IRS_LEFT_Switch_on()
    else
        QW_OH_IRS_LEFT_Switch_off()
    end
end

-- $$ IRS RIGHT

function QW_OH_IRS_RIGHT_Switch_on ()
local lvar = 'QW_OH_IRS_RIGHT_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('IRSL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_IRS_RIGHT_Switch_off ()
local lvar = 'QW_OH_IRS_RIGHT_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('IRSL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_IRS_RIGHT_Switch_toggle ()
local lvar = 'QW_OH_IRS_RIGHT_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_OH_IRS_RIGHT_Switch_on()
    else
        QW_OH_IRS_RIGHT_Switch_off()
    end
end

-- ## Overhead 1 Flight Control Surfaces

-- ## Overhead 2 Pass Signs

function QW_OH_SEATB_SIGN_SWITCH_off ()
local lvar = 'QW_OH_SEATB_SIGN_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        if lval ~= 1 then
            QW_OH_SEATB_SIGN_SWITCH_auto()
        end
        ipc.writeLvar(lvar, '0')
        ipc.sleep(200)
        DspShow('BELT', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_SEATB_SIGN_SWITCH_auto ()
local lvar = 'QW_OH_SEATB_SIGN_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.sleep(200)
        DspShow('BELT', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_SEATB_SIGN_SWITCH_on ()
local lvar = 'QW_OH_SEATB_SIGN_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        if lval ~= 1 then
            QW_OH_SEATB_SIGN_SWITCH_auto()
        end
        ipc.writeLvar(lvar, '2')
        ipc.sleep(200)
        DspShow('BELT', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_SEATB_SIGN_SWITCH_cycle ()
local lvar = 'QW_OH_SEATB_heat_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_OH_SEATB_SIGN_SWITCH_auto ()
    elseif lval == 1 then
        QW_OH_SEATB_SIGN_SWITCH_on()
    else
        QW_OH_SEATB_SIGN_SWITCH_auto()
        ipc.sleep(50)
        QW_OH_SEATB_SIGN_SWITCH_off()
    end
end

-- ## Overhead 2 Hydraulics

-- $$ Ram Air Turbine (RAT)

function QW_OH_HYD_RAT_unlock ()
local lvar = 'QW_OH_HYD_RAT_Button'
local lvar2 = 'QW_OH_RAT_Guard_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(250)
        ipc.writeLvar(lvar, '2')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        QW_Switch_Small()
        DspShow('RAT', 'unlk')
    end
end

-- $$ Primary Hyd L Eng

function QW_OH_HYD_L_ENG_on ()
local lvar = 'QW_OH_HYD_L_ENG_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('HYDL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_HYD_L_ENG_off ()
local lvar = 'QW_OH_HYD_L_ENG_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('HYDL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_HYD_L_ENG_toggle ()
local lvar = 'QW_OH_HYD_L_ENG_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_HYD_L_ENG_off()
    else
        QW_OH_HYD_L_ENG_on()
    end
end

-- $$ Primary Hyd R Eng

function QW_OH_HYD_R_ENG_on ()
local lvar = 'QW_OH_HYD_R_ENG_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('HYDR', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_HYD_R_ENG_off ()
local lvar = 'QW_OH_HYD_R_ENG_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('HYDR', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_HYD_R_ENG_toggle ()
local lvar = 'QW_OH_HYD_R_ENG_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_HYD_R_ENG_off()
    else
        QW_OH_HYD_R_ENG_on()
    end
end

-- $$ ELEC HYD C1

function QW_OH_ELEC_C1_off ()
local lvar = 'QW_OH_ELEC_C1_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        if lval ~= 1 then
            QW_OH_ELEC_C1_auto()
        end
        ipc.writeLvar(lvar, '0')
        ipc.sleep(200)
        DspShow('ELC1', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_C1_auto ()
local lvar = 'QW_OH_ELEC_C1_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.sleep(200)
        DspShow('ELC1', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_C1_on ()
local lvar = 'QW_OH_ELEC_C1_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        if lval ~= 1 then
            QW_OH_ELEC_C1_auto()
        end
        ipc.writeLvar(lvar, '2')
        ipc.sleep(200)
        DspShow('ELC1', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_C1_cycle ()
local lvar = 'QW_OH_ELEC_C1_Switch'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_OH_ELEC_C1_auto()
        ipc.sleep(200)
    elseif lval == 1 then
        QW_OH_ELEC_C1_on()
        ipc.sleep(200)
    else
        QW_OH_ELEC_C1_auto()
        ipc.sleep(200)
        QW_OH_ELEC_C1_off()
    end
end

-- $$ ELEC HYD C2

function QW_OH_ELEC_C2_off ()
local lvar = 'QW_OH_ELEC_C2_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        if lval ~= 1 then
            QW_OH_ELEC_C2_auto()
        end
        ipc.writeLvar(lvar, '0')
        ipc.sleep(200)
        DspShow('ELC2', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_C2_auto ()
local lvar = 'QW_OH_ELEC_C2_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.sleep(200)
        DspShow('ELC2', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_C2_on ()
local lvar = 'QW_OH_ELEC_C2_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        if lval ~= 1 then
            QW_OH_ELEC_C2_auto()
        end
        ipc.writeLvar(lvar, '2')
        ipc.sleep(200)
        DspShow('ELC2', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_C2_cycle ()
local lvar = 'QW_OH_ELEC_C2_Switch'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_OH_ELEC_C2_auto()
        ipc.sleep(200)
    elseif lval == 1 then
        QW_OH_ELEC_C2_on()
        ipc.sleep(200)
    else
        QW_OH_ELEC_C2_auto()
        ipc.sleep(200)
        QW_OH_ELEC_C2_off()
    end
end

-- $$ ELEC L HYD

function QW_OH_ELEC_L_off ()
local lvar = 'QW_OH_ELEC_L_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        if lval ~= 1 then
            QW_OH_ELEC_C1_auto()
        end
        ipc.writeLvar(lvar, '0')
        ipc.sleep(200)
        DspShow('LELC', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_L_auto ()
local lvar = 'QW_OH_ELEC_L_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.sleep(200)
        DspShow('LELC', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_L_on ()
local lvar = 'QW_OH_ELEC_L_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        if lval ~= 1 then
            QW_OH_ELEC_C1_auto()
        end
        ipc.writeLvar(lvar, '2')
        ipc.sleep(200)
        DspShow('LELC', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_L_cycle ()
local lvar = 'QW_OH_ELEC_L_Switch'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_OH_ELEC_L_auto()
        ipc.sleep(200)
    elseif lval == 1 then
        QW_OH_ELEC_L_on()
        ipc.sleep(200)
    else
        QW_OH_ELEC_L_auto()
        ipc.sleep(200)
        QW_OH_ELEC_L_off()
    end
end

-- $$ ELEC R HYD

function QW_OH_ELEC_R_off ()
local lvar = 'QW_OH_ELEC_R_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        if lval ~= 1 then
            QW_OH_ELEC_R_auto()
        end
        ipc.writeLvar(lvar, '0')
        ipc.sleep(200)
        DspShow('RELC', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_R_auto ()
local lvar = 'QW_OH_ELEC_R_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.sleep(200)
        DspShow('RELC', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_R_on ()
local lvar = 'QW_OH_ELEC_R_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        if lval ~= 1 then
            QW_OH_ELEC_C2_auto()
        end
        ipc.writeLvar(lvar, '2')
        ipc.sleep(200)
        DspShow('RELC', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_ELEC_R_cycle ()
local lvar = 'QW_OH_ELEC_R_Switch'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_OH_ELEC_R_auto()
        ipc.sleep(200)
    elseif lval == 1 then
        QW_OH_ELEC_R_on()
        ipc.sleep(200)
    else
        QW_OH_ELEC_R_auto()
        ipc.sleep(200)
        QW_OH_ELEC_R_off()
    end
end

-- ## Overhead 2 Window Heat

-- $$ PRMY L FWD

function QW_OH_PRMY_L_FWD_on ()
local lvar = 'QW_OH_PRMY_L_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('PRMY', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_PRMY_L_FWD_off ()
local lvar = 'QW_OH_PRMY_L_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('PRMY', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_PRMY_L_FWD_toggle ()
local lvar = 'QW_OH_PRMY_L_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_OH_PRMY_L_FWD_on()
    else
        QW_OH_PRMY_L_FWD_off()
    end
end

-- $$ PRMY R FWD

function QW_OH_PRMY_R_FWD_on ()
local lvar = 'QW_OH_PRMY_R_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('PRMY', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_PRMY_R_FWD_off ()
local lvar = 'QW_OH_PRMY_R_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('PRMY', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_PRMY_R_FWD_toggle ()
local lvar = 'QW_OH_PRMY_R_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_OH_PRMY_R_FWD_on()
    else
        QW_OH_PRMY_R_FWD_off()
    end
end

-- $$ PRMY L SIDE

function QW_OH_PRMY_L_SIDE_on ()
local lvar = 'QW_OH_PRMY_L_SIDE_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('PRMY', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_PRMY_L_SIDE_off ()
local lvar = 'QW_OH_PRMY_L_SIDE_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('PRMY', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_PRMY_L_SIDE_toggle ()
local lvar = 'QW_OH_PRMY_L_SIDE_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_OH_PRMY_L_SIDE_on()
    else
        QW_OH_PRMY_L_SIDE_off()
    end
end

-- $$ PRMY R SIDE

function QW_OH_PRMY_R_SIDE_on ()
local lvar = 'QW_OH_PRMY_R_SIDE_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('PRMY', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_PRMY_R_SIDE_off ()
local lvar = 'QW_OH_PRMY_R_SIDE_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('PRMY', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_PRMY_R_SIDE_toggle ()
local lvar = 'QW_OH_PRMY_R_SIDE_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_OH_PRMY_R_SIDE_on()
    else
        QW_OH_PRMY_R_SIDE_off()
    end
end


-- $$ BACKUP L FWD

function QW_OH_WH_LFWD_on ()
local lvar = 'QW_OH_WH_LFWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('BACKUP', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_WH_LFWD_off ()
local lvar = 'QW_OH_WH_LFWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('BACKUP', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_WH_LFWD_toggle ()
local lvar = 'QW_OH_WH_LFWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_OH_WH_LFWD_on()
    else
        QW_OH_WH_LFWD_off()
    end
end

-- $$ BACKUP R FWD

function QW_OH_WH_RFWD_on ()
local lvar = 'QW_OH_WH_RFWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('BACKUP', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_WH_RFWD_off ()
local lvar = 'QW_OH_WH_RFWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('BACKUP', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_WH_RFWD_toggle ()
local lvar = 'QW_OH_WH_RFWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        QW_OH_WH_RFWD_on()
    else
        QW_OH_WH_RFWD_off()
    end
end

-- ## Overhead 2 Miscellaneous

-- ## Overhead 3 Anti-Ice

-- $$ Wing Anti-Ice

function QW_OH_WING_ANTICE_SWITCH_off ()
local lvar = 'QW_OH_WING_ANTICE_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        if lval ~= 1 then
            QW_OH_WING_ANTICE_SWITCH_auto()
        end
        ipc.writeLvar(lvar, '0')
        ipc.sleep(200)
        DspShow('WING', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_WING_ANTICE_SWITCH_auto ()
local lvar = 'QW_OH_WING_ANTICE_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.sleep(200)
        DspShow('WING', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_WING_ANTICE_SWITCH_on ()
local lvar = 'QW_OH_WING_ANTICE_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        if lval ~= 1 then
            QW_OH_WING_ANTICE_SWITCH_auto()
        end
        ipc.writeLvar(lvar, '2')
        ipc.sleep(200)
        DspShow('WgAI', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_WING_ANTICE_SWITCH_cycle ()
local lvar = 'QW_OH_WING_ANTICE_SWITCH'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
       QW_OH_WING_ANTICE_SWITCH_auto()
        ipc.sleep(200)
    elseif lval == 1 then
        QW_OH_WING_ANTICE_SWITCH_on()
        ipc.sleep(200)
    else
        QW_OH_WING_ANTICE_SWITCH_auto()
        ipc.sleep(50)
        QW_OH_WING_ANTICE_SWITCH_off()
    end
end

-- $$ Eng 1 Anti-Ice

function QW_OH_AI_L_ENG_Switch_off ()
local lvar = 'QW_OH_AI_L_ENG_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        if lval ~= 1 then
            QW_OH_AI_L_ENG_Switch_auto()
        end
        ipc.writeLvar(lvar, '0')
        ipc.sleep(200)
        DspShow('LENG', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_AI_ENG_L_Switch_auto ()
local lvar = 'QW_OH_AI_L_ENG_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.sleep(200)
        DspShow('LENG', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_AI_L_ENG_Switch_on ()
local lvar = 'QW_OH_AI_L_ENG_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        if lval ~= 1 then
            QW_OH_AI_L_ENG_Switch_auto()
        end
        ipc.writeLvar(lvar, '2')
        ipc.sleep(200)
        DspShow('LENG', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_AI_L_ENG_Switch_cycle ()
local lvar = 'QW_OH_AI_L_ENG_Switch'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
       QW_OH_AI_ENG_L_Switch_auto()
        ipc.sleep(200)
    elseif lval == 1 then
        QW_OH_AI_L_ENG_Switch_on()
        ipc.sleep(200)
    else
        QW_OH_AI_ENG_L_Switch_auto()
        ipc.sleep(200)
        QW_OH_AI_L_ENG_Switch_off()
    end
end

-- $$ Eng 2 Anti-Ice

function QW_OH_AI_R_ENG_Switch_off ()
local lvar = 'QW_OH_AI_R_ENG_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        if lval ~= 1 then
            QW_OH_AI_R_ENG_Switch_auto()
        end
        ipc.writeLvar(lvar, '0')
        ipc.sleep(200)
        DspShow('RENG', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_AI_R_ENG_Switch_auto ()
local lvar = 'QW_OH_AI_R_ENG_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.sleep(200)
        DspShow('RENG', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_AI_R_ENG_Switch_on ()
local lvar = 'QW_OH_AI_R_ENG_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        if lval ~= 1 then
            QW_OH_AI_R_ENG_Switch_auto()
        end
        ipc.writeLvar(lvar, '2')
        ipc.sleep(200)
        DspShow('RENG', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_AI_R_ENG_Switch_cycle ()
local lvar = 'QW_OH_AI_R_ENG_Switch'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_OH_AI_R_ENG_Switch_auto()
        ipc.sleep(200)
    elseif lval == 1 then
        QW_OH_AI_R_ENG_Switch_on()
        ipc.sleep(200)
    else
        QW_OH_AI_R_ENG_Switch_auto()
        ipc.sleep(50)
        QW_OH_AI_R_ENG_Switch_off()
    end
end

-- ## Overhead 3 Fuel

-- $$ Fuel Pump Left Forward

function QW_OH_FUEL_PUMP_L_FWD_on ()
local lvar = 'QW_OH_LPUMP_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('LFPF', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_L_FWD_off ()
local lvar = 'QW_OH_LPUMP_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('LFPF', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_L_FWD_toggle ()
local lvar = 'QW_OH_LPUMP_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_PUMP_L_FWD_off()
    else
        QW_OH_FUEL_PUMP_L_FWD_on()
    end
end

-- $$ Fuel Pump Left Aft

function QW_OH_FUEL_PUMP_L_AFT_on ()
local lvar = 'QW_OH_LPUMP_AFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('LFPA', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_L_AFT_off ()
local lvar = 'QW_OH_LPUMP_AFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('LFPA', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_L_AFT_toggle ()
local lvar = 'QW_OH_LPUMP_AFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_PUMP_L_AFT_off()
    else
        QW_OH_FUEL_PUMP_L_AFT_on()
    end
end

-- $$ Fuel Pump Right Forward

function QW_OH_FUEL_PUMP_R_FWD_on ()
local lvar = 'QW_OH_RPUMP_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('RFPF', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_R_FWD_off ()
local lvar = 'QW_OH_RPUMP_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('RFPF', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_R_FWD_toggle ()
local lvar = 'QW_OH_RPUMP_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_PUMP_R_FWD_off()
    else
        QW_OH_FUEL_PUMP_R_FWD_on()
    end
end

-- $$ Fuel Pump Right Aft

function QW_OH_FUEL_PUMP_R_AFT_on ()
local lvar = 'QW_OH_RPUMP_AFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('RFPA', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_R_AFT_off ()
local lvar = 'QW_OH_RPUMP_AFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('RFPA', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_R_AFT_toggle ()
local lvar = 'QW_OH_RPUMP_AFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_PUMP_R_AFT_off()
    else
        QW_OH_FUEL_PUMP_R_AFT_on()
    end
end

-- $$ Fuel Pump Left Centre

function QW_OH_FUEL_PUMP_L_CTR_on ()
local lvar = 'QW_OH_CNTRPUMP_L_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('CFBL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_L_CTR_off ()
local lvar = 'QW_OH_CNTRPUMP_L_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('CFBL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_L_CTR_toggle ()
local lvar = 'QW_OH_CNTRPUMP_L_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_PUMP_L_CTR_off()
    else
        QW_OH_FUEL_PUMP_L_CTR_on()
    end
end

-- $$ Fuel Pump Right Centre

function QW_OH_FUEL_PUMP_R_CTR_on ()
local lvar = 'QW_OH_CNTRPUMP_R_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('CFBL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_R_CTR_off ()
local lvar = 'QW_OH_CNTRPUMP_R_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('CFBL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_PUMP_R_CTR_toggle ()
local lvar = 'QW_OH_CNTRPUMP_R_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_PUMP_R_CTR_off()
    else
        QW_OH_FUEL_PUMP_R_CTR_on()
    end
end

-- $$ Fuel Pumps Centre Both

function QW_OH_FUEL_PUMP_ALL_CTR_on ()
    QW_OH_FUEL_PUMP_R_CTR_on ()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_L_CTR_on ()
    ipc.sleep(300)
end

function QW_OH_FUEL_PUMP_ALL_CTR_off ()
    QW_OH_FUEL_PUMP_R_CTR_off ()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_L_CTR_off ()
    ipc.sleep(300)
end

function QW_OH_FUEL_PUMP_ALL_CTR_toggle ()
    QW_OH_FUEL_PUMP_R_CTR_toggle ()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_L_CTR_toggle ()
    ipc.sleep(300)
end


-- $$ Fuel Pumps All

function QW_OH_FUEL_PUMP_ALL_on ()
    QW_OH_FUEL_PUMP_L_FWD_on()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_R_FWD_on()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_L_AFT_on()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_R_AFT_on()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_L_CTR_on()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_R_CTR_on()
    ipc.sleep(300)
end

function QW_OH_FUEL_PUMP_ALL_off ()
    QW_OH_FUEL_PUMP_L_FWD_off()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_R_FWD_off()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_L_AFT_off()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_R_AFT_off()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_L_CTR_off()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_R_CTR_off()
    ipc.sleep(300)
end

function QW_OH_FUEL_PUMP_ALL_toggle ()
    QW_OH_FUEL_PUMP_L_FWD_toggle()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_R_FWD_toggle()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_L_AFT_toggle()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_R_AFT_toggle()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_L_CTR_toggle()
    ipc.sleep(300)
    QW_OH_FUEL_PUMP_R_CTR_toggle()
    ipc.sleep(300)
end

-- $$ Fuel Balance

function QW_OH_FUELBALANCE_on ()
local lvar = 'QW_OH_FUEL_BALANCE_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('FBAL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUELBALANCE_off ()
local lvar = 'QW_OH_FUEL_BALANCE_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('FBAL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUELBALANCE_toggle ()
local lvar = 'QW_OH_FUEL_BALANCE_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUELBALANCE_off()
    else
        QW_OH_FUELBALANCE_on()
    end
end

-- $$ Fuel Crossfeed

function QW_OH_FUEL_CROSSFEED_on ()
local lvar = 'QW_OH_FUEL_CROSSFEED_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('XFED', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_CROSSFEED_off ()
local lvar = 'QW_OH_FUEL_CROSSFEED_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('XFED', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_CROSSFEED_toggle ()
local lvar = 'QW_OH_FUEL_CROSSFEED_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_CROSSFEED_off()
    else
        QW_OH_FUEL_CROSSFEED_on()
    end
end

-- ## Overhead 3 Fuel Jettison

-- $$ Fuel Jettison Nozzle L

function QW_OH_FUEL_JET_NZL_BOTH_on ()
local lvar = 'QW_OH_NZL_L_Button'
local lvar2 = 'QW_OH_NZL_L_Guard_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(250)
        ipc.writeLvar(lvar, '2')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        DspShow('NOZL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_JET_NZL_BOTH_off ()
local lvar = 'QW_OH_NZL_L_Button'
local lvar2 = 'QW_OH_NZL_L_Guard_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(250)
        ipc.writeLvar(lvar, '0')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        DspShow('NOZL', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_JET_NZL_BOTH_toggle ()
local lvar = 'QW_OH_NZL_L_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_JET_NZL_BOTH_off()
    else
        QW_OH_FUEL_JET_NZL_BOTH_on()
    end
end

-- $$ Fuel Pump Left Forward

function QW_OH_FUEL_ARM_on ()
local lvar = 'QW_OH_FUEL_ARM_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('FARM', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_ARM_off ()
local lvar = 'QW_OH_FUEL_ARM_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('FARM', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_ARM_toggle ()
local lvar = 'QW_OH_FUEL_ARM_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_ARM_off()
    else
        QW_OH_FUEL_ARM_on()
    end
end

-- $$ Fuel Jettison Mode

function QW_OH_FUEL_JET_MODE_on ()
local lvar = 'QW_OH_FUEL_REMAIN_MODE'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('FJMD', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_JET_MODE_off ()
local lvar = 'QW_OH_FUEL_REMAIN_MODE'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('FJMD', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_FUEL_JET_MODE_toggle ()
local lvar = 'QW_OH_FUEL_REMAIN_MODE'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_FUEL_JET_MODE_off()
    else
        QW_OH_FUEL_JET_MODE_on()
    end
end

-- $$ Fuel To Remain

function QW_AP_FUEL_REMAIN_dec ()
local lvar = 'QW_OH_FUEL_REMAIN_Knob'
local lval = ipc.readLvar(lvar)
    if lval > 0 then
        ipc.writeLvar(lvar, lval - 1)
        DspShow('FREM', 'dec')
        QW_Switch_Small()
    end
end

function QW_AP_FUEL_REMAIN_inc ()
local lvar = 'QW_OH_FUEL_REMAIN_Knob'
local lval = ipc.readLvar(lvar)
    if lval < 15 then
        ipc.writeLvar(lvar, lval + 1)
        DspShow('FREM', 'inc')
        QW_Switch_Small()
    end
end

-- ## Overhead 3 Engine

-- $$ Engine L Start

function QW_OH_ENG_L_START_norm ()
local lvar = 'QW_OH_ENG_L_START_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('ENG1', 'norm')
        QW_Switch_Small()
    end
end

function QW_OH_ENG_L_START_start ()
local lvar = 'QW_OH_ENG_L_START_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('ENG1', 'strt')
        QW_Switch_Small()
    end
end

function QW_OH_ENG_L_START_toggle ()
local lvar = 'QW_OH_ENG_L_START_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_ENG_L_START_start()
    else
        QW_OH_ENG_L_START_norm()
    end
end

-- $$ Engine R Start

function QW_OH_ENG_R_START_norm ()
local lvar = 'QW_OH_ENG_R_START_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('ENG2', 'norm')
        QW_Switch_Small()
    end
end

function QW_OH_ENG_R_START_start ()
local lvar = 'QW_OH_ENG_R_START_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('ENG2', 'strt')
        QW_Switch_Small()
    end
end

function QW_OH_ENG_R_START_toggle ()
local lvar = 'QW_OH_ENG_R_START_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_ENG_R_START_start()
    else
        QW_OH_ENG_R_START_norm()
    end
end

-- $$ EEC Mode L

function QW_OH_EEC_L_norm ()
local lvar = 'QW_OH_ECC_L_Button'
local lvar2 = 'QW_OH_ECC_L_Guard_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(250)
        ipc.writeLvar(lvar, '1')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        DspShow('ECCL', 'norm')
        QW_Switch_Small()
    end
end

function QW_OH_EEC_L_altn ()
local lvar = 'QW_OH_ECC_L_Button'
local lvar2 = 'QW_OH_ECC_L_Guard_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(250)
        ipc.writeLvar(lvar, '0')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        DspShow('EECL', 'altn')
        QW_Switch_Small()
    end
end

function QW_OH_EEC_L_toggle ()
local lvar = 'QW_OH_ECC_L_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_EEC_L_altn()
    else
        QW_OH_EEC_L_norm()
    end
end

-- $$ EEC Mode R

function QW_OH_EEC_R_norm ()
local lvar = 'QW_OH_ECC_R_Button'
local lvar2 = 'QW_OH_ECC_R_Guard_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(250)
        ipc.writeLvar(lvar, '1')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        DspShow('ECCR', 'norm')
        QW_Switch_Small()
    end
end

function QW_OH_EEC_R_altn ()
local lvar = 'QW_OH_ECC_R_Button'
local lvar2 = 'QW_OH_ECC_R_Guard_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(250)
        ipc.writeLvar(lvar, '0')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        DspShow('EECR', 'altn')
        QW_Switch_Small()
    end
end

function QW_OH_EEC_R_toggle ()
local lvar = 'QW_OH_ECC_R_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_EEC_R_altn()
    else
        QW_OH_EEC_R_norm()
    end
end

-- ## Overhead 3 Cargo Fire

-- ## Overhead 3 Miscellaneous

-- ## Overhead 4 Pressurization

-- ## Overhead 4 Air Conditioning

-- $$ Equip Cooling Fwd

function QW_OH_EQPCOOL_FWD_auto ()
local lvar = 'QW_OH_EQPCOOL_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('EQCF', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_EQPCOOL_FWD_ovrd ()
local lvar = 'QW_OH_EQPCOOL_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('EQCF', 'ovrd')
        QW_Switch_Small()
    end
end

function QW_OH_EQPCOOL_FWD_toggle ()
local lvar = 'QW_OH_EQPCOOL_FWD_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_EQPCOOL_FWD_ovrd()
    else
        QW_OH_EQPCOOL_FWD_auto()
    end
end

-- $$ Equip Cooling Aft

function QW_OH_EQPCOOL_AFT_auto ()
local lvar = 'QW_OH_EQPCOOL_AFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('EQCA', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_EQPCOOL_AFT_ovrd ()
local lvar = 'QW_OH_EQPCOOL_AFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('EQCA', 'ovrd')
        QW_Switch_Small()
    end
end

function QW_OH_EQPCOOL_AFT_toggle ()
local lvar = 'QW_OH_EQPCOOL_AFT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_EQPCOOL_AFT_ovrd()
    else
        QW_OH_EQPCOOL_AFT_auto()
    end
end

-- $$ Recirc Fans Upper

function QW_OH_RECIRC_UPP_on ()
local lvar = 'QW_OH_RECIRC_UPP_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('RFUP', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_RECIRC_UPP_off ()
local lvar = 'QW_OH_RECIRC_UPP_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('RFUP', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_RECIRC_UPP_toggle ()
local lvar = 'QW_OH_RECIRC_UPP_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_RECIRC_UPP_off()
    else
        QW_OH_RECIRC_UPP_on()
    end
end

-- $$ Recirc Fans Lower

function QW_OH_RECIRC_LOW_on ()
local lvar = 'QW_OH_RECIRC_LOW_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('RFLW', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_RECIRC_LOW_off ()
local lvar = 'QW_OH_RECIRC_LOW_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('RFLW', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_RECIRC_LOW_toggle ()
local lvar = 'QW_OH_RECIRC_LOW_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_RECIRC_LOW_off()
    else
        QW_OH_RECIRC_LOW_on()
    end
end

-- $$ Flt Deck Temp

function QW_OH_FLTDK_Temp_dec ()
local lvar = 'QW_OH_FLTDK_Temp_Switch'
local lval = ipc.readLvar(lvar)
    if lval > 0 then
        ipc.writeLvar(lvar, lval - 1)
        DspShow('FDTP', 'dec')
        QW_Switch_Small()
    end
end

function QW_OH_FLTDK_Temp_inc ()
local lvar = 'QW_OH_FLTDK_Temp_Switch'
local lval = ipc.readLvar(lvar)
    if lval < 6 then
        ipc.writeLvar(lvar, lval + 1)
        DspShow('FDTP', 'inc')
        QW_Switch_Small()
    end
end

-- $$ Air Cond Reset

function QW_OH_AC_RESET ()
local lvar = 'QW_OH_AC_RESET_Button'
    ipc.writeLvar(lvar, '1')
    ipc.sleep(200)
    ipc.writeLvar(lvar, '0')
    DspShow('ACON', 'rst')
        QW_Switch_Small()
end

-- $$ Cabin Temp

function QW_OH_CABIN_Temp_dec ()
local lvar = 'QW_OH_CABIN_Temp_Switch'
local lval = ipc.readLvar(lvar)
    if lval > 0 then
        ipc.writeLvar(lvar, lval - 1)
        DspShow('CBTP', 'dec')
        QW_Switch_Rotary()
    end
end

function QW_OH_CABIN_Temp_inc ()
local lvar = 'QW_OH_CABIN_Temp_Switch'
local lval = ipc.readLvar(lvar)
    if lval < 6 then
        ipc.writeLvar(lvar, lval + 1)
        DspShow('CBTP', 'inc')
        QW_Switch_Rotary()
    end
end

-- $$ AC L Pack

function QW_OH_AC_LPACK_auto ()
local lvar = 'QW_OH_AC_LPACK_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('PCKL', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_AC_LPACK_off ()
local lvar = 'QW_OH_AC_LPACK_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('PCKL', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_AC_LPACK_toggle ()
local lvar = 'QW_OH_AC_LPACK_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_AC_LPACK_off()
    else
        QW_OH_AC_LPACK_auto()
    end
end

-- $$ AC R Pack

function QW_OH_AC_RPACK_auto ()
local lvar = 'QW_OH_AC_RPACK_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('PCKR', 'auto')
        QW_Switch_Small()
    end
end

function QW_OH_AC_RPACK_off ()
local lvar = 'QW_OH_AC_RPACK_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('PCKR', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_AC_RPACK_toggle ()
local lvar = 'QW_OH_AC_RPACK_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_AC_RPACK_off()
    else
        QW_OH_AC_RPACK_auto()
    end
end

-- $$ Trim Air L

function QW_OH_TRIMAIR_L_on ()
local lvar = 'QW_OH_TRIMAIR_L_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('TRML', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_TRIMAIR_L_off ()
local lvar = 'QW_OH_TRIMAIR_L_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('TRML', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_TRIMAIR_L_toggle ()
local lvar = 'QW_OH_TRIMAIR_L_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_TRIMAIR_L_off()
    else
        QW_OH_TRIMAIR_L_on()
    end
end

-- $$ Trim Air R

function QW_OH_TRIMAIR_R_on ()
local lvar = 'QW_OH_TRIMAIR_R_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        DspShow('TRMR', 'on')
        QW_Switch_Small()
    end
end

function QW_OH_TRIMAIR_R_off ()
local lvar = 'QW_OH_TRIMAIR_R_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, '0')
        DspShow('TRMR', 'off')
        QW_Switch_Small()
    end
end

function QW_OH_TRIMAIR_R_toggle ()
local lvar = 'QW_OH_TRIMAIR_R_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_TRIMAIR_R_off()
    else
        QW_OH_TRIMAIR_R_on()
    end
end

-- $$ Ventilation

function QW_OH_VENT_norm ()
local lvar = 'QW_OH_AC_VENT_Button'
local lvar2 = 'QW_OH_VENT_Guard_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(250)
        ipc.writeLvar(lvar, '1')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        DspShow('VENT', 'norm')
        QW_Switch_Small()
    end
end

function QW_OH_VENT_altn ()
local lvar = 'QW_OH_AC_VENT_Button'
local lvar2 = 'QW_OH_VENT_Guard_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar2, '1')
        QW_Switch_Small()
        ipc.sleep(250)
        ipc.writeLvar(lvar, '0')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        DspShow('VENT', 'altn')
        QW_Switch_Small()
    end
end

function QW_OH_VENT_toggle ()
local lvar = 'QW_OH_AC_VENT_Button'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        QW_OH_VENT_altn()
    else
        QW_OH_VENT_norm()
    end
end

-- ## Overhead 4 Cargo Temp

-- ## Pedestal

-- $$ Fuel Control L

function QW_Fuel_Control_L_on ()
local QW_Fuel1 = ipc.readUW('0890')
    if QW_Fuel1 == 0 then
        ipc.control(65983, 0)
        QW_Switch_Large()
    end
end

function QW_Fuel_Control_L_off ()
local QW_Fuel1 = ipc.readUW('0890')
    if QW_Fuel1 ~= 0 then
        ipc.control(65987, 0)
        QW_Switch_Large()
    end
end

function QW_Fuel_Control_L_toggle ()
local QW_Fuel1 = ipc.readUW('0890')
    if QW_Fuel1 == 0 then
        QW_Fuel_Control_L_on()
    else
        QW_Fuel_Control_L_off()
    end
end

-- $$ Fuel Control R

function QW_Fuel_Control_R_on ()
    local QW_Fuel2 = ipc.readUW('0928')
    if QW_Fuel2 == 0 then
        ipc.control(65988, 0)
        QW_Switch_Large()
    end
end

function QW_Fuel_Control_R_off ()
local QW_Fuel2 = ipc.readUW('0928')
    if QW_Fuel2 ~= 0 then
        ipc.control(65992, 0)
        QW_Switch_Large()
    end
end

function QW_Fuel_Control_R_toggle ()
local QW_Fuel2 = ipc.readUW('0928')
    if QW_Fuel2 == 0 then
        QW_Fuel_Control_R_on()
    else
        QW_Fuel_Control_R_off()
    end
end

-- ## Aircraft Controls

-- $$ Autobrake

function auto_brake_switch_rto ()
local lvar =  'auto_brake_switch'
local lval = ipc.readLvar(lvar)
    if lval ~= -1 then
        ipc.writeLvar(lvar, '-1')
        ipc.sleep(200)
        DspShow('ABRK', 'auto')
        QW_Switch_Small()
    end
end

function auto_brake_switch_off ()
local lvar = 'auto_brake_switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        if lval ~= 1 then
           -- auto_brake_switch_off()
        end
        ipc.writeLvar(lvar, '0')
        ipc.sleep(200)
        DspShow('ABRK', 'off')
        QW_Switch_Small()
    end
end

function auto_brake_switch_disarm()
local lvar = 'auto_brake_switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, '1')
        ipc.sleep(200)
        DspShow('ABRK', 'darm')
        QW_Switch_Small()
    end
end

function auto_brake_switch_1()
local lvar =  'auto_brake_switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        ipc.writeLvar(lvar, '2')
        ipc.sleep(200)
        DspShow('ABRK','2')
        QW_Switch_Small()
    end
end

function auto_brake_switch_2()
local lvar =  'auto_brake_switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 3 then
        ipc.writeLvar(lvar, '3')
        ipc.sleep(200)
        DspShow('ABRK','2')
        QW_Switch_Small()
    end
end

function auto_brake_switch_3()
local lvar =  'auto_brake_switch'
local lval = ipc.readLvar(lvar)
    if lval ~=4 then
        ipc.writeLvar(lvar, '4')
        ipc.sleep(200)
        DspShow('ABRK','3')
        QW_Switch_Small()
    end
end

function auto_brake_switch_4()
local lvar =  'auto_brake_switch'
local lval = ipc.readLvar(lvar)
    if lval ~=5 then
        ipc.writeLvar(lvar, '5')
        ipc.sleep(200)
        DspShow('ABRK','4')
        QW_Switch_Small()
    end
end

function auto_brake_switch_Max_Auto()
local lvar =  'auto_brake_switch'
local lval = ipc.readLvar(lvar)
    if lval ~=6 then
        ipc.writeLvar(lvar, '6')
        ipc.sleep(200)
        DspShow('ABRK', 'max')
        QW_Switch_Small()
    end
end

-- $$ Landing Gear

function QW_Gear_down ()
    Gears_down()
    QW_Switch_Large()
end

function QW_Gear_up ()
    Gears_up()
    QW_Switch_Large()
end

-- $$ Flaps

function QW_Flaps_down ()
    Flaps_down()
    QW_Switch_Large()
end

function QW_Flaps_up ()
    Flaps_up()
    QW_Switch_Large()
end

function QW_Flaps_inc ()
    Flaps_incr()
    QW_Switch_Large()
end

function QW_Flaps_dec ()
    Flaps_decr()
    QW_Switch_Large()
end

-- $$ Alternate Flaps

function QW_PED_ALTFLAPS_on ()
local lvar = 'QW_THQ_Altn_flaps_button'
local lvar2 = 'QW_PED_ALTFLAPS_Guard_Switch'
local lval = ipc.readLvar(lvar)
local lval2 = ipc.readLvar(lvar2)
    if lval == 0 then
        if lvar2 ~= 0 then
            ipc.writeLvar(lvar2, '1')
            QW_Switch_Small()
            ipc.sleep(250)
        end
        ipc.writeLvar(lvar, '1')
        QW_Switch_Large()
        ipc.sleep(250)
        ipc.writeLvar(lvar2, '0')
        QW_Switch_Small()
        DspShow('AFlps', 'on')
    end
end

function QW_PED_ALTFLAPS_off ()
local lvar = 'QW_THQ_Altn_flaps_button'
local lvar2 = 'QW_PED_ALTFLAPS_Guard_Switch'
local lval = ipc.readLvar(lvar)
local lval2 = ipc.readLvar(lvar2)
    if lval ~= 0 then
        if lvar2 ~= 0 then
            ipc.writeLvar(lvar2, '1')
            QW_Switch_Small()
            ipc.sleep(250)
        end
        ipc.writeLvar(lvar, '0')
        QW_Switch_Large()
        ipc.sleep(250)
        ipc.writeLvar(lvar2, '0')
        QW_Switch_Small()
        DspShow('AFlps', 'off')
    end
end

function QW_PED_ALTFLAPS_toggle ()
local lvar = 'QW_THQ_Altn_flaps_button'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_PED_ALTFLAPS_on()
    else
        QW_PED_ALTFLAPS_off()
    end
end

function QW_PED_ALTFLAPS_retract ()
local lvar = 'QW_THQ_Altn_flpas_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 0 then
        ipc.writeLvar(lvar, 0)
        QW_Switch_Rotary()
        ipc.sleep(500)
        ipc.writeLvar(lvar, 1)
        QW_Switch_Rotary()
    end
end

function QW_PED_ALTFLAPS_centre ()
local lvar = 'QW_THQ_Altn_flpas_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 1 then
        ipc.writeLvar(lvar, 1)
        QW_Switch_Rotary()
    end
end

function QW_PED_ALTFLAPS_extend ()
local lvar = 'QW_THQ_Altn_flpas_Switch'
local lval = ipc.readLvar(lvar)
    if lval ~= 2 then
        ipc.writeLvar(lvar, 2)
        QW_Switch_Rotary()
        ipc.sleep(500)
        ipc.writeLvar(lvar, 1)
        QW_Switch_Rotary()
    end
end

-- $$ Parking Brake

function QW_Parking_Brake_on ()
local QW_Brakes = ipc.readUW('0BC8')
    if QW_Brakes == 0 then
        QW_Parking_Brake_toggle()
    end
end
function QW_Parking_Brake_off ()
local QW_Brakes = ipc.readUW('0BC8')
    if QW_Brakes ~= 0 then
        QW_Parking_Brake_toggle()
    end
end

function QW_Parking_Brake_toggle ()
    Brakes_PARKING ()
    QW_Switch_Large()
end

-- $$ Alternate Pitch Trim - no available


-- $$ Stabilizer Cutoff

function QW_PED_STAB_L2_norm ()
local lvar = 'QW_THQ_Stab_Norm_L2'
local lvar2 = 'QW_PED_STAB_L2_Safety_Switch'
local lval = ipc.readLvar(lvar)
local lval2 = ipc.readLvar(lvar2)
    if lval ~= 0 then
        if lval2 == 0 then
            ipc.writeLvar(lvar2, '1')
            QW_Switch_Large()
            ipc.sleep(250)
        end
        ipc.writeLvar(lvar, '0')
        QW_Switch_Large()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        QW_Switch_Large()
        DspShow('Stab', 'L2Nm')
    end
end

function QW_PED_STAB_L2_cutoff ()
local lvar = 'QW_THQ_Stab_Norm_L2'
local lvar2 = 'QW_PED_STAB_L2_Safety_Switch'
local lval = ipc.readLvar(lvar)
local lval2 = ipc.readLvar(lvar2)
    if lval == 0 then
        if lvar2 ~= 0 then
            ipc.writeLvar(lvar2, '1')
            QW_Switch_Large()
            ipc.sleep(250)
        end
        ipc.writeLvar(lvar, '1')
        QW_Switch_Large()
        DspShow('Stab', 'L2CO')
    end
end

function QW_PED_STAB_R2_norm ()
local lvar = 'QW_THQ_Stab_Norm_R2'
local lvar2 = 'QW_PED_STAB_R2_Safety_Switch'
local lval = ipc.readLvar(lvar)
local lval2 = ipc.readLvar(lvar2)
    if lval ~= 0 then
        if lval2 == 0 then
            ipc.writeLvar(lvar2, '1')
            QW_Switch_Large()
            ipc.sleep(250)
        end
        ipc.writeLvar(lvar, '0')
        QW_Switch_Large()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        QW_Switch_Large()
        DspShow('Stab', 'R2Nm')
    end
end

function QW_PED_STAB_L2_toggle ()
local lvar = 'QW_THQ_Stab_Norm_L2'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_PED_STAB_L2_cutoff()
    else
        QW_PED_STAB_L2_norm()
    end
end

function QW_PED_STAB_R2_cutoff ()
local lvar = 'QW_THQ_Stab_Norm_R2'
local lvar2 = 'QW_PED_STAB_R2_Safety_Switch'
local lval = ipc.readLvar(lvar)
local lval2 = ipc.readLvar(lvar2)
    if lval == 0 then
        if lvar2 ~= 0 then
            ipc.writeLvar(lvar2, '1')
            QW_Switch_Large()
            ipc.sleep(250)
        end
        ipc.writeLvar(lvar, '1')
        QW_Switch_Large()
        DspShow('Stab', 'R2CO')
    end
end

function QW_PED_STAB_R2_toggle ()
local lvar = 'QW_THQ_Stab_Norm_R2'
local lval = ipc.readLvar(lvar)
    if lval == 0 then
        QW_PED_STAB_R2_cutoff()
    else
        QW_PED_STAB_R2_norm()
    end
end

function QW_PED_STAB_Both_cutoff()
    QW_PED_STAB_L2_cutoff()
    QW_PED_STAB_R2_cutoff()
end

function QW_PED_STAB_Both_norm()
    QW_PED_STAB_L2_norm()
    QW_PED_STAB_R2_norm()
end

function QW_PED_STAB_Both_toggle()
    QW_PED_STAB_L2_toggle()
    QW_PED_STAB_R2_toggle()
end

-- ## Aft Pedestal

-- $$ Transponder

function QW_AFT_XPDR_show()
local lvar = 'QW_AFT_Transponder_Knob'
local lval = ipc.readLvar(lvar)
local txt
    if lval == 0 then
        txt = 'stby'
    elseif lval == 1 then
        txt = 'alt'
    elseif lval == 2 then
        txt = 'xdpr'
    elseif lval == 3 then
        txt = 'ta'
    elseif lval == 4 then
        txt = 'tara'
    else
        txt = 'err'
    end
    DspShow('XPDR', txt)
end

function QW_AFT_XPDR_inc()
local lvar = 'QW_AFT_Transponder_Knob'
local lval = ipc.readLvar(lvar)
    if lval < 4 then
        ipc.writeLvar(lvar, lval + 1)
        QW_Switch_Rotary()
        QW_AFT_XPDR_show()
    end
end

function QW_AFT_XPDR_dec()
local lvar = 'QW_AFT_Transponder_Knob'
local lval = ipc.readLvar(lvar)
    if lval > 0 then
        ipc.writeLvar(lvar, lval - 1)
        QW_Switch_Rotary()
        QW_AFT_XPDR_show()
    end
end

function QW_AFT_XPDR_move(tgt)
local lvar = 'QW_AFT_Transponder_Knob'
local lval = ipc.readLvar(lvar)
    if lval > tgt then
        for i = lval - 1, tgt, -1 do
            QW_AFT_XPDR_dec()
        end
    elseif lval < tgt then
        for i = lval + 1, tgt, 1 do
            QW_AFT_XPDR_inc()
        end
    end
end

function QW_AFT_XPDR_cycle()
local lvar = 'QW_AFT_Transponder_Knob'
local lval = ipc.readLvar(lvar)
    if lval < 4 then
        QW_AFT_XPDR_inc()
    else
        QW_AFT_XPDR_stby()
    end
end

function QW_AFT_XPDR_stby()
    QW_AFT_XPDR_move(0)
end

function QW_AFT_XPDR_alt()
    QW_AFT_XPDR_move(1)
end

function QW_AFT_XPDR_xpdr()
    QW_AFT_XPDR_move(2)
end

function QW_AFT_XPDR_ta()
    QW_AFT_XPDR_move(3)
end

function QW_AFT_XPDR_tara()
    QW_AFT_XPDR_move(4)
end

-- $$ G/S Inhibit

function QW_AFT_GS_inhibit_toggle ()
local lvar = 'QW_AFT_GS_inhibit_Button'
local lval = ipc.readLvar(lvar)
    ipc.writeLvar(lvar, 1)
    QW_Switch_Small()
    ipc.sleep(200)
    ipc.writeLvar(lvar, 0)
    QW_Switch_Small()
    DspShow('GSin', 'press')
end

-- $$ Aural Cancel

function QW_AFT_AURAL_Cancel ()
local lvar = 'QW_AFT_AURAL_Canc_Button'
local lvar2 = 'QW_AFT_AURAL_CANCEL_Guarded_Switch'
local lval = ipc.readLvar(lvar)
local lval2 = ipc.readLvar(lvar2)
    if lval == 0 then
        if lval2 == 0 then
            ipc.writeLvar(lvar2, '1')
            QW_Switch_Small()
            ipc.sleep(250)
        end
        ipc.writeLvar(lvar, '0')
        QW_Switch_Small()
        ipc.sleep(500)
        ipc.writeLvar(lvar2, '0')
        QW_Switch_Small()
        DspShow('AURL', 'press')
    end
end

-- ## System - DO NOT ASSIGN

function QW_Switch_Small ()
local Lwav = "switch_small"
    Sounds(Lwav, true, 30)
end

function QW_Switch_Large ()
local Lwav = "switch_large"
    Sounds(Lwav, true, 30)
end

function QW_Switch_Rotary ()
local Lwav = "switch_rotary"
    Sounds(Lwav, true, 30)
end


