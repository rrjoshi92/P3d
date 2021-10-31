--  Aircraft: Aerosoft CRJ
--  Version: 1.7
--  Date: Jun 2020
--  Author: Andrew Gransden / Günter Steiner

-- ## System functions ##

function InitVars ()
    -- uncomment to disable display
    -- AutopilotDisplayBlocked ()
    ipc.set("DispModeVar", 1) -- set ECAM
end 

function ASCRJ_GPU_state ()
    GNDavail = ipc.readLvar("ASCRJ_ELEC_EXTPWR_AVAIL")
    GNDon = ipc.readLvar("ASCRJ_ELEC_EXTPWR_INUSE")

    if GNDavail == 0 and GNDon == 0 then
        LongTxt1 = "GPU off"
        ShortTxt1 = "---"
    elseif GNDavail == 1 and GNDon == 0 then
        LongTxt1 = "GPU conn"
        ShortTxt1 = "GPUc"
    elseif GNDavail == 0 and GNDon == 1 then
        LongTxt1 = "GPU use"
        ShortTxt1 = "GPUu"
    end
end

function ASCRJ_APU_state ()
    APUdoor = ipc.readLvar("APU_DOOR_POS")
    APUrunup = ipc.readLvar("ASCRJ_APU_STARTSTOP_START")
    APUavail = ipc.readLvar("ASCRJ_APU_STARTSTOP_AVAIL")

    if APUdoor == 0 then
        LongTxt2 = "APU off"
        ShortTxt2 = "---"
    elseif APUrunup == 1 and APUavail == 0 then
        LongTxt2 = "APU strt"
        ShortTxt2 = "APUs"
    elseif APUrunup == 0 and APUavail == 1 then
        LongTxt2 = "APU on"
        ShortTxt2 = "APUo"
    elseif APUdoor > 0 then
        LongTxt2 = "APU pwr"
        ShortTxt2 = "APUp"
    end

end

function Timer ()

    -- On Ground?
    OnGround = ipc.readUW("0366")

    --Engines running  CFlag
    CFlag1 = ipc.readUB(0x0894)
    CFlag2 = ipc.readUB(0x092c)

    CFlag = CFlag1 + CFlag2

    if OnGround == 1 and CFlag == 0 then
        ASCRJ_GPU_state ()
        ASCRJ_APU_state ()

        --elseif OnGround == 1 then
    else
        LongTxt1 = ""
        LongTxt2 = ""
        ShortTxt1 = ""
        ShortTxt2 = ""
    end

    if _MCP2() then
        FLIGHT_INFO1 = LongTxt1
        FLIGHT_INFO2 = LongTxt2
    else
        FLIGHT_INFO1 = ShortTxt1
        FLIGHT_INFO2 = ShortTxt2
    end

    ASCRJ_Display_Flt_Info()
end

function ASCRJ_Display_Flt_Info()
local SPDval = ipc.readLvar("ASCRJ_FCP_SPEED_INFO")
local HDGval = ipc.readLvar("ASCRJ_FCP_HDG_INFO")
local ALTval = ipc.readLvar("ASCRJ_FCP_ALT_INFO")
local VSval = ipc.readLvar("ASCRJ_FCP_WHEEL_INFO")

    DspSPD(SPDval)
    DspHDG(HDGval)
    DspALT(ALTval)
    if ALTval < 10000 then
        DspE(" \\\\\\")
    else
        DspE("0\\\\\\")
    end
    DspVVS(VSval)
end

function test()
local Lvar = "ASCRJ_FCP_SPEED_CHANGE"
local state = ipc.readLvar(Lvar)
--_loggg('[ACRJ] state = ' .. state)
    --if state == 0 then
    for i = 1, 10 do
        ipc.writeLvar(Lvar, -1)
        ipc.sleep(10)
    end
    --end
    DspShow("SPD", "on")
end

-- ## AP Knobs ###############

-- $$ Course 1

function ASCRJ_FCP_CRS1_inc ()
local Lvar1 = "ASCRJ_FCP_CRS1_SEL"
local Lvar2 = "ASCRJ_FCP_CRS1_CHANGE"
local Lval = ipc.readLvar(Lvar1)
    ipc.writeLvar(Lvar2, 1)
    ipc.writeLvar(Lvar1, Lval + 1)
    DspShow("CRS1", Lval + 1)
end

function ASCRJ_FCP_CRS1_incfast ()
local Lvar1 = "ASCRJ_FCP_CRS1_SEL"
local Lvar2 = "ASCRJ_FCP_CRS1_CHANGE"
local Lval = ipc.readLvar(Lvar1)
    ipc.writeLvar(Lvar2, 1)
    ipc.writeLvar(Lvar1, Lval + 10)
    DspShow("CRS1", Lval + 10)
end

function ASCRJ_FCP_CRS1_dec ()
local Lvar1 = "ASCRJ_FCP_CRS1_SEL"
local Lvar2 = "ASCRJ_FCP_CRS1_CHANGE"
local Lval = ipc.readLvar(Lvar1)
    ipc.writeLvar(Lvar2, -1)
    ipc.writeLvar(Lvar1, Lval - 1)
    DspShow("CRS1", Lval - 1)
end

function ASCRJ_FCP_CRS1_decfast ()
local Lvar1 = "ASCRJ_FCP_CRS1_SEL"
local Lvar2 = "ASCRJ_FCP_CRS1_CHANGE"
local Lval = ipc.readLvar(Lvar1)
    ipc.writeLvar(Lvar2, -1)
    ipc.writeLvar(Lvar1, Lval - 10)
    DspShow("CRS1", Lval - 10)
end

-- $$ Speed

function ASCRJ_FCP_SPEED_inc ()
local Lvar = "ASCRJ_FCP_SPEED_CHANGE"
    ipc.writeLvar(Lvar, 1)
    DspShow("SPD", "inc")
    ASCRJ_Display_Flt_Info()
end

function ASCRJ_FCP_SPEED_incfast ()
local Lvar = "ASCRJ_FCP_SPEED_CHANGE"
    ipc.writeLvar(Lvar, 5)
    DspShow("SPD", "inc")
    ASCRJ_Display_Flt_Info()
end

function ASCRJ_FCP_SPEED_dec ()
local Lvar = "ASCRJ_FCP_SPEED_CHANGE"
    ipc.writeLvar(Lvar, -1)
    DspShow("SPD", "dec")
    ASCRJ_Display_Flt_Info()
end

function ASCRJ_FCP_SPEED_decfast ()
local Lvar = "ASCRJ_FCP_SPEED_CHANGE"
    ipc.writeLvar(Lvar, -5)
    DspShow("SPD", "dec")
    ASCRJ_Display_Flt_Info()
end

-- $$ Heading

function ASCRJ_FCP_HDG_inc ()
local Lvar = "ASCRJ_FCP_HDG_CHANGE"
    ipc.writeLvar(Lvar, 1)
    DspShow("HDG", "inc")
    ASCRJ_Display_Flt_Info()
end

function ASCRJ_FCP_HDG_incfast ()
local Lvar = "ASCRJ_FCP_HDG_CHANGE"
    ipc.writeLvar(Lvar, 2)
    DspShow("HDG", "inc")
    ASCRJ_Display_Flt_Info()
end

function ASCRJ_FCP_HDG_dec ()
local Lvar = "ASCRJ_FCP_HDG_CHANGE"
    ipc.writeLvar(Lvar, -1)
    DspShow("HDG", "dec")
    ASCRJ_Display_Flt_Info()
end

function ASCRJ_FCP_HDG_decfast ()
local Lvar = "ASCRJ_FCP_HDG_CHANGE"
    ipc.writeLvar(Lvar, -2)
    DspShow("HDG", "dec")
    ASCRJ_Display_Flt_Info()
end

-- $$ Altitude

function ASCRJ_FCP_ALT_inc ()
local Lvar = "ASCRJ_FCP_ALT_CHANGE"
    ipc.writeLvar(Lvar, 1)
    DspShow("ALT", "inc")
    ASCRJ_Display_Flt_Info()
end

function ASCRJ_FCP_ALT_incfast ()
local Lvar = "ASCRJ_FCP_ALT_CHANGE"
    ipc.writeLvar(Lvar, 5)
    DspShow("ALT", "inc")
    ASCRJ_Display_Flt_Info()
end

function ASCRJ_FCP_ALT_dec ()
local Lvar = "ASCRJ_FCP_ALT_CHANGE"
    ipc.writeLvar(Lvar, -1)
    DspShow("ALT", "dec")
    ASCRJ_Display_Flt_Info()
end

function ASCRJ_FCP_ALT_decfast ()
local Lvar = "ASCRJ_FCP_ALT_CHANGE"
    ipc.writeLvar(Lvar, -5)
    DspShow("ALT", "dec")
    ASCRJ_Display_Flt_Info()
end

-- $$ VS

function ASCRJ_FCP_VS_inc ()
local Lvar = "ASCRJ_FCP_WHEEL_CHANGE"
    ipc.writeLvar(Lvar, -1)
    DspShow("VS", "inc")
end

function ASCRJ_FCP_VS_incfast ()
local Lvar = "ASCRJ_FCP_WHEEL_CHANGE"
    ipc.writeLvar(Lvar, -5)
    DspShow("VS", "inc")
end

function ASCRJ_FCP_VS_dec ()
local Lvar = "ASCRJ_FCP_WHEEL_CHANGE"
    ipc.writeLvar(Lvar, 1)
    DspShow("VS", "dec")
end

function ASCRJ_FCP_VS_decfast ()
local Lvar = "ASCRJ_FCP_WHEEL_CHANGE"
    ipc.writeLvar(Lvar, 5)
    DspShow("VS", "dec")
end

-- $$ Course 2

function ASCRJ_FCP_CRS2_inc ()
local Lvar = "ASCRJ_FCP_CRS2_CHANGE"
    ipc.writeLvar(Lvar, 1)
    DspShow("CRS2", "inc")
end

function ASCRJ_FCP_CRS2_incfast ()
local Lvar = "ASCRJ_FCP_CRS2_CHANGE"
    ipc.writeLvar(Lvar, 5)
    DspShow("CRS2", "inc")
end

function ASCRJ_FCP_CRS2_dec ()
local Lvar = "ASCRJ_FCP_CRS2_CHANGE"
    ipc.writeLvar(Lvar, -1)
    DspShow("CRS2", "dec")
end

function ASCRJ_FCP_CRS2_decfast ()
local Lvar = "ASCRJ_FCP_CRS2_CHANGE"
    ipc.writeLvar(Lvar, -5)
    DspShow("CRS1", "dec")
end

-- ## AP Buttons ###############

function ASCRJ_FCP_CRS1_DIRECT_press()
local Lvar = "ASCRJ_FCP_CRS1_DIRECT_BTN"
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(150)
    ipc.writeLvar(Lvar, 0)
    DspShow("CRS1", "push")
end

function ASCRJ_FCP_FD_toggle ()
local Lvar1 = "ASCRJ_FCP_FD1_BTN"
local Lvar2 = "ASCRJ_FCP_FD1"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    DspShow('FD', 'on')
end

function ASCRJ_FCP_AP_ENG ()
local Lvar1 = "ASCRJ_FCP_AP_ENG_BTN"
local Lvar2 = "ASCRJ_FCP_AP_ENG"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    DspShow('AP', 'eng')
end

function ASCRJ_FCP_AP_DISENG ()
local Lvar = "ASCRJ_FCP_AP_DISC"
    ipc.writeLvar(Lvar, -1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar, 0)
    DspShow('AP', 'dis')
end

function ASCRJ_FCP_XFR_toggle ()
local Lvar1 = "ASCRJ_FCP_XFR_BTN"
local Lvar2 = "ASCRJ_FCP_XFR"
local Lvar3 = "ASCRJ_FCP_XFR_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('XFR', 'on')
    else
        DspShow('XFR', 'off')
    end
end

function ASCRJ_FCP_TURB_toggle ()
local Lvar1 = "ASCRJ_FCP_TURB_BTN"
local Lvar2 = "ASCRJ_FCP_TURB"
local Lvar3 = "ASCRJ_FCP_TURB_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('TURB', 'on')
    else
        DspShow('TURB', 'off')
    end
end

function ASCRJ_FCP_SPEED_toggle ()
local Lvar1 = "ASCRJ_FCP_SPEED_BTN"
local Lvar2 = "ASCRJ_FCP_SPEED"
local Lvar3 = "ASCRJ_FCP_SPEED_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('SPD', 'on')
    else
        DspShow('SPD', 'off')
    end
end

function ASCRJ_FCP_IAS_MACH_toggle ()
local Lvar1 = "ASCRJ_FCP_IAS_MACH_BTN"
local Lvar2 = "ASCRJ_FCP_IAS_MACH"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('IASM', 'tog')
end

function ASCRJ_FCP_APPR_toggle ()
local Lvar1 = "ASCRJ_FCP_APPR_BTN"
local Lvar2 = "ASCRJ_FCP_APPR"
local Lvar3 = "ASCRJ_FCP_APPR_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('APPR', 'on')
    else
        DspShow('APPR', 'off')
    end
end

function ASCRJ_FCP_BC_toggle ()
local Lvar1 = "ASCRJ_FCP_BC_BTN"
local Lvar2 = "ASCRJ_FCP_BC"
local Lvar3 = "ASCRJ_FCP_BC_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('BC', 'on')
    else
        DspShow('BC', 'off')
    end
end

function ASCRJ_FCP_HDG_toggle ()
local Lvar1 = "ASCRJ_FCP_HDG_BTN"
local Lvar2 = "ASCRJ_FCP_HDG"
local Lvar3 = "ASCRJ_FCP_HDG_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('HDG', 'on')
    else
        DspShow('HDG', 'off')
    end
end

function ASCRJ_FCP_HDG_SYNC_toggle ()
local Lvar1 = "ASCRJ_FCP_HDG_SYNC_BTN"
local Lvar2 = "ASCRJ_FCP_HDG_SYNC"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('HDG', 'sync')
end

function ASCRJ_FCP_NAV_toggle ()
local Lvar1 = "ASCRJ_FCP_NAV_BTN"
local Lvar2 = "ASCRJ_FCP_NAV"
local Lvar3 = "ASCRJ_FCP_NAV_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('NAV', 'on')
    else
        DspShow('NAV', 'off')
    end
end

function ASCRJ_FCP_BANK_toggle ()
local Lvar1 = "ASCRJ_FCP_12BANK_BTN"
local Lvar2 = "ASCRJ_FCP_12BANK"
local Lvar3 = "ASCRJ_FCP_12BANK_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('BANK', 'on')
    else
        DspShow('BANK', 'off')
    end
end

function ASCRJ_FCP_ALT_toggle ()
local Lvar1 = "ASCRJ_FCP_ALT_BTN"
local Lvar2 = "ASCRJ_FCP_ALT"
local Lvar3 = "ASCRJ_FCP_ALT_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('NAV', 'on')
    else
        DspShow('NAV', 'off')
    end
end

function ASCRJ_FCP_ALT_CANCEL_press()
local Lvar = "ASCRJ_FCP_ALT_CANCEL_BTN"
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(150)
    ipc.writeLvar(Lvar, 0)
    DspShow("ALT", "canc")
end

function ASCRJ_FCP_VS_toggle ()
local Lvar1 = "ASCRJ_FCP_VS_BTN"
local Lvar2 = "ASCRJ_FCP_VS"
local Lvar3 = "ASCRJ_FCP_VS_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('VS', 'on')
    else
        DspShow('VS', 'off')
    end
end

function ASCRJ_FCP_VNAV_press ()
local Lvar1 = "ASCRJ_FCP_VNAV_BTN"
local Lvar2 = "ASCRJ_FCP_VNAV"
local Lvar3 = "ASCRJ_FCP_LED"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 1 then
        DspShow('VNAV', 'on')
    else
        DspShow('VNAV', 'off')
    end
end

function ASCRJ_FCP_CRS2_DIRECT_press()
local Lvar = "ASCRJ_FCP_CRS2_DIRECT_BTN"
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(150)
    ipc.writeLvar(Lvar, 0)
    DspShow("CRS2", "push")
end

function ASCRJ_FCP_FD2_toggle ()
local Lvar1 = "ASCRJ_FCP_FD2_BTN"
local Lvar2 = "ASCRJ_FCP_FD2"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    DspShow('FD 2', 'on')
end

-- $$ AP disconnect

function ASCRJ_YOKEC_APDISC_press()
local Lvar = "ASCRJ_YOKEC_APDISC_BTN"
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(150)
    ipc.writeLvar(Lvar, 0)
    DspShow("APDS", "push")
end

function ASCRJ_YOKEF_APDISC_press()
local Lvar = "ASCRJ_YOKEF_APDISC_BTN"
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(150)
    ipc.writeLvar(Lvar, 0)
    DspShow("APDS", "push")
end

-- ## Glareshield (Capt) ###############

-- $$ Spoiler Roll

function ASCRJ_GSC_ROLL_SPLR_toggle ()
local Lvar1 = "ASCRJ_GSC_ROLL_SPLR_BTN"
local Lvar2 = "ASCRJ_GSC_ROLL_SPLR"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('RollS', 'sel')
end

-- $$ Warning and Caution

function ASCRJ_GSC_MASTER_WARN_BTN_press ()
local Lvar1 = "ASCRJ_GSC_MASTER_WARN_BTN"
local Lvar2 = "ASCRJ_GSC_MASTER_WARN"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('WARN', 'canc')
end

function ASCRJ_GSC_MASTER_CAUT_BTN_press ()
local Lvar1 = "ASCRJ_GSC_MASTER_CAUT_BTN"
local Lvar2 = "ASCRJ_GSC_MASTER_CAUT"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('CAUT', 'canc')
end

-- $$ Stall

function ASCRJ_GSC_STALL_press ()
local Lvar1 = "ASCRJ_GSC_STALL_GUARD"
local Lvar2 = "ASCRJ_GSC_STALL_ANIM"
    ipc.writeLvar(Lvar1, 1)
    ipc.sleep(30)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(100)
    ipc.writeLvar(Lvar2, 0)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    DspShow('STALL', 'canc')
end


-- ## Flight Controls ###############

-- $$ flaps

function ASCRJ_FLAPS_show ()
local Lvar = "ASCRJ_FLAPS_SET"
local pos = ipc.readLvar(Lvar)
local postxt
    if pos ~= nil then
        _loggg('[ACRJ] flap = ' .. pos)
    else
        _loggg('[ACRJ] flap = nil')
        return
    end
    if pos == 0 then
        postxt = '0'
    elseif pos < 25 then
        postxt = '1'
    elseif pos < 45 then
        postxt = '8'
    elseif pos < 65 then
        postxt = '20'
    elseif pos < 85 then
        postxt = '30'
    elseif pos > 86 then
        postxt = '45'
    end
    DspShow ('Flap', postxt)
end

function ASCRJ_FLAPS_down ()
local Lvar = "ASCRJ_FLAPS_SET"
local pos = ipc.readLvar(Lvar)
local newpos
    if pos == 0 then
        newpos = 20
    elseif pos < 25 then
        newpos = 40
    elseif pos < 45 then
        newpos = 60
    elseif pos < 65 then
        newpos = 80
    elseif pos < 85 then
        newpos = 100
    else
        return
    end
    ipc.writeLvar(Lvar, newpos)
    ASCRJ_FLAPS_show()
end

function ASCRJ_FLAPS_up ()
local Lvar = "ASCRJ_FLAPS_SET"
local pos = ipc.readLvar(Lvar)
local newpos
    if pos > 85 then
        newpos = 80
    elseif pos > 65 then
        newpos = 60
    elseif pos > 45 then
        newpos = 40
    elseif pos > 25 then
        newpos = 20
    elseif pos > 10 then
        newpos = 0
    else
        return
    end
    ipc.writeLvar(Lvar, newpos)
    ASCRJ_FLAPS_show()
end

-- $$ Elevator Trim

function ASCRJ_YOKEC_TRIM1_down ()
local Lvar1 = 'ASCRJ_YOKEC_TRIM1'
local Lvar2 = 'ASCRJ_YOKEC_TRIM2'
    ipc.writeLvar(Lvar1, -1)
    ipc.writeLvar(Lvar2, -1)
    ipc.sleep(20)
    ipc.writeLvar(Lvar1, 0)
    ipc.writeLvar(Lvar2, 0)
    ipc.sleep(20)
    local val = ipc.readLvar('ASCRJ_ELEVTRIM') - 50
    --_loggg('Eval=' .. val)
    val = math.floor(val)
    DspShow('ETrm', val)
end

function ASCRJ_YOKEC_TRIM1_up ()
local Lvar1 = 'ASCRJ_YOKEC_TRIM1'
local Lvar2 = 'ASCRJ_YOKEC_TRIM2'
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(20)
    ipc.writeLvar(Lvar1, 0)
    ipc.writeLvar(Lvar2, 0)
    ipc.sleep(20)
    local val = ipc.readLvar('ASCRJ_ELEVTRIM') + 50
    --_loggg('Eval=' .. val)
    val = math.floor(val)
    DspShow('ETrm', val)
end

-- $$ Aileron Trim

function ASCRJ_TRIM_AIL_left ()
local Lvar = 'ASCRJ_TRIM_AIL_LWR'
    ipc.writeLvar(Lvar, -1)
    ipc.sleep(20)
    ipc.writeLvar(Lvar, 0)
    ipc.sleep(20)
    DspShow('ATrm', 'left')
end

function ASCRJ_TRIM_AIL_right ()
local Lvar = 'ASCRJ_TRIM_AIL_LWR'
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(20)
    ipc.writeLvar(Lvar, 0)
    ipc.sleep(20)
    DspShow('ATrm', 'rght')
end

-- $$ Rudder Trim

function ASCRJ_TRIM_RUD_left ()
local Lvar = 'ASCRJ_TRIM_RUD'
    ipc.writeLvar(Lvar, -1)
    ipc.sleep(20)
    ipc.writeLvar(Lvar, 0)
    ipc.sleep(20)
    DspShow('RTrm', 'left')
end

function ASCRJ_TRIM_ARUD_right ()
local Lvar = 'ASCRJ_TRIM_RUD'
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(20)
    ipc.writeLvar(Lvar, 0)
    ipc.sleep(20)
    DspShow('RTrm', 'up')
end

-- ## OVHD External Light ###############

-- $$ Landing

function ASCRJ_OVHD_EXTL_LDG_LEFT_on ()
local Lvar = "ASCRJ_OVHD_LDG_LEFT"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("LL-L", "on")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_LDG_LEFT_off ()
local Lvar = "ASCRJ_OVHD_LDG_LEFT"
local state = ipc.readLvar(Lvar)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("LL-L", "off")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_LDG_LEFT_toggle ()
local Lvar = "ASCRJ_OVHD_LDG_LEFT"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_EXTL_LDG_LEFT_on ()
    else
        ASCRJ_OVHD_EXTL_LDG_LEFT_off ()
    end
end

function ASCRJ_OVHD_EXTL_LDG_NOSE_on ()
local Lvar = "ASCRJ_OVHD_LDG_NOSE"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("LL-N", "on")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_LDG_NOSE_off ()
local Lvar = "ASCRJ_OVHD_LDG_NOSE"
local state = ipc.readLvar(Lvar)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("LL-N", "off")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_LDG_NOSE_toggle ()
local Lvar = "ASCRJ_OVHD_LDG_NOSE"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_EXTL_LDG_NOSE_on ()
    else
        ASCRJ_OVHD_EXTL_LDG_NOSE_off ()
    end
end

function ASCRJ_OVHD_EXTL_LDG_RIGHT_on ()
local Lvar = "ASCRJ_OVHD_LDG_RIGHT"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("LL-R", "on")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_LDG_RIGHT_off ()
local Lvar = "ASCRJ_OVHD_LDG_RIGHT"
local state = ipc.readLvar(Lvar)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("LL-R", "off")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_LDG_RIGHT_toggle ()
local Lvar = "ASCRJ_OVHD_LDG_RIGHT"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_EXTL_LDG_RIGHT_on ()
    else
        ASCRJ_OVHD_EXTL_LDG_RIGHT_off ()
    end
end

function ASCRJ_OVHD_EXTL_LAND_ALL_on ()
    ASCRJ_OVHD_EXTL_LDG_LEFT_on()
    ASCRJ_OVHD_EXTL_LDG_NOSE_on()
    ASCRJ_OVHD_EXTL_LDG_RIGHT_on()
end

function ASCRJ_OVHD_EXTL_LAND_ALL_off ()
    ASCRJ_OVHD_EXTL_LDG_LEFT_off()
    ASCRJ_OVHD_EXTL_LDG_NOSE_off()
    ASCRJ_OVHD_EXTL_LDG_RIGHT_off()
end

function ASCRJ_OVHD_EXTL_LAND_ALL_toggle ()
    ASCRJ_OVHD_EXTL_LDG_LEFT_toggle()
    ASCRJ_OVHD_EXTL_LDG_NOSE_toggle()
    ASCRJ_OVHD_EXTL_LDG_RIGHT_toggle()
end

-- $$ Taxi

function ASCRJ_OVHD_EXTL_TAXI_on ()
local Lvar = "ASCRJ_OVHD_TAXI"
local state = ipc.readLvar(Lvar)
    _loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("TAXI", "on")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_TAXI_off ()
local Lvar = "ASCRJ_OVHD_TAXI"
local state = ipc.readLvar(Lvar)
    _loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("taxi", "off")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_TAXI_toggle ()
local Lvar = "ASCRJ_OVHD_TAXI"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_EXTL_TAXI_on ()
    else
        ASCRJ_OVHD_EXTL_TAXI_off ()
    end
end

-- $$ Nav

function ASCRJ_OVHD_EXTL_NAV_on ()
local Lvar = "ASCRJ_EXTL_NAV"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("NAV", "on")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_NAV_off ()
local Lvar = "ASCRJ_EXTL_NAV"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("NAV", "off")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_NAV_toggle ()
local Lvar = "ASCRJ_EXTL_NAV"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_EXTL_NAV_on ()
    else
        ASCRJ_OVHD_EXTL_NAV_off ()
    end
end

-- $$ Beacon

function ASCRJ_OVHD_EXTL_BEACON_on()
local Lvar = "ASCRJ_EXTL_BEACON"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("BCN", "on")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_BEACON_off ()
local Lvar = "ASCRJ_EXTL_BEACON"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("BCN", "off")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_BEACON_toggle ()
local Lvar = "ASCRJ_EXTL_BEACON"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_EXTL_BEACON_on ()
    else
        ASCRJ_OVHD_EXTL_BEACON_off ()
    end
end

-- $$ Strobe

function ASCRJ_OVHD_EXTL_STROBE_on ()
local Lvar = "ASCRJ_EXTL_STROBE"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("STRB", "on")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_STROBE_off ()
local Lvar = "ASCRJ_EXTL_STROBE"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("STRB", "off")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_STROBE_toggle ()
local Lvar = "ASCRJ_EXTL_STROBE"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_EXTL_STROBE_on ()
    else
        ASCRJ_OVHD_EXTL_STROBE_off ()
    end
end

-- $$ Logo

function ASCRJ_OVHD_EXTL_LOGO_on ()
local Lvar = "ASCRJ_EXTL_LOGO"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("LOGO", "on")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_LOGO_off ()
local Lvar = "ASCRJ_EXTL_LOGO"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("STRB", "off")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_LOGO_toggle ()
local Lvar = "ASCRJ_EXTL_LOGO"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_EXTL_LOGO_on ()
    else
        ASCRJ_OVHD_EXTL_LOGO_off ()
    end
end

-- $$ Wing

function ASCRJ_OVHD_EXTL_WING_on ()
local Lvar = "ASCRJ_EXTL_WING"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("LOGO", "on")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_WING_off ()
local Lvar = "ASCRJ_EXTL_WING"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("LOGO", "off")
    ipc.sleep(20)
end

function ASCRJ_OVHD_EXTL_WING_toggle ()
local Lvar = "ASCRJ_EXTL_WING"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_EXTL_WING_on ()
    else
        ASCRJ_OVHD_EXTL_WING_off ()
    end
end

-- $$ All

function ASCRJ_OVHD_EXTL_ALL_on ()
    ASCRJ_OVHD_EXTL_NAV_on()
    ASCRJ_OVHD_EXTL_BEACON_on()
    ASCRJ_OVHD_EXTL_STROBE_on()
    ASCRJ_OVHD_EXTL_LOGO_on()
    ASCRJ_OVHD_EXTL_WING_on()
end

function ASCRJ_OVHD_EXTL_ALL_off ()
    ASCRJ_OVHD_EXTL_NAV_off()
    ASCRJ_OVHD_EXTL_BEACON_off()
    ASCRJ_OVHD_EXTL_STROBE_off()
    ASCRJ_OVHD_EXTL_LOGO_off()
    ASCRJ_OVHD_EXTL_WING_off()
end

function ASCRJ_OVHD_EXTL_ALL_toggle ()
    ASCRJ_OVHD_EXTL_NAV_toggle()
    ASCRJ_OVHD_EXTL_BEACON_toggle()
    ASCRJ_OVHD_EXTL_STROBE_toggle()
    ASCRJ_OVHD_EXTL_LOGO_toggle()
    ASCRJ_OVHD_EXTL_WING_toggle()
end

-- ## Internal Lighting

-- $$ Overhead NO Smoking

function ASCRJ_OVHD_NOSMOKING_on ()
local Lvar = "ASCRJ_OVHD_NO_SMOKING"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 2 then
        ipc.writeLvar(Lvar, 2)
    end
    ASCRJ_OVHD_NOSMOKING_show()
end

function ASCRJ_OVHD_NOSMOKING_off ()
local Lvar = "ASCRJ_OVHD_NO_SMOKING"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    ASCRJ_OVHD_NOSMOKING_show()
end

function ASCRJ_OVHD_NOSMOKING_auto ()
local Lvar = "ASCRJ_OVHD_NO_SMOKING"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    ASCRJ_OVHD_NOSMOKING_show()
end

function ASCRJ_OVHD_NOSMOKING_inc ()
local Lvar = "ASCRJ_OVHD_NO_SMOKING"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state < 2 then
        ipc.writeLvar(Lvar, state + 1)
    end
    ASCRJ_OVHD_SEATBELT_show()
end

function ASCRJ_OVHD_NOSMOKING_dec ()
local Lvar = "ASCRJ_OVHD_NO_SMOKING"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state > 0 then
        ipc.writeLvar(Lvar, state - 1)
    end
    ASCRJ_OVHD_SEATBELT_show()
end

function ASCRJ_OVHD_NOSMOKING_cycle ()
local Lvar = "ASCRJ_OVHD_NO_SMOKING"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state < 2 then
        ASCRJ_OVHD_NOSMOKING_inc()
    else
        ASCRJ_OVHD_NOSMOKING_dec()
        ASCRJ_OVHD_NOSMOKING_dec()
    end
    ASCRJ_OVHD_NOSMOKING_show()
end

function ASCRJ_OVHD_NOSMOKING_show ()
local Lvar = "ASCRJ_OVHD_NO_SMOKING"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        txt = "auto"
    elseif state == 1 then
        txt = "off"
    else
        txt = "on"
    end
    DspShow("NOSK", txt)
    ipc.sleep(20)
end

function ASCRJ_OVHD_NOSMOKING_toggle ()
local Lvar = "ASCRJ_OVHD_NO_SMOKING"
local state = ipc.readLvar(Lvar)
    if state ~= 1 then
        ASCRJ_OVHD_NOSMOKING_off ()
    else
        ASCRJ_OVHD_NOSMOKING_on ()
    end
end

-- $$ Passenger Seat Belt

function ASCRJ_OVHD_SEATBELT_on ()
local Lvar = "ASCRJ_OVHD_SEAT_BELTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 2 then
        ipc.writeLvar(Lvar, 2)
    end
    ASCRJ_OVHD_SEATBELT_show()
end

function ASCRJ_OVHD_SEATBELT_off ()
local Lvar = "ASCRJ_OVHD_SEAT_BELTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    ASCRJ_OVHD_SEATBELT_show()
end

function ASCRJ_OVHD_SEATBELT_auto ()
local Lvar = "ASCRJ_OVHD_SEAT_BELTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    ASCRJ_OVHD_SEATBELT_show()
end

function ASCRJ_OVHD_SEATBELT_inc ()
local Lvar = "ASCRJ_OVHD_SEAT_BELTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state < 2 then
        ipc.writeLvar(Lvar, state + 1)
    end
    ASCRJ_OVHD_SEATBELT_show()
end

function ASCRJ_OVHD_SEATBELT_dec ()
local Lvar = "ASCRJ_OVHD_SEAT_BELTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state > 0 then
        ipc.writeLvar(Lvar, state - 1)
    end
    ASCRJ_OVHD_SEATBELT_show()
end

function ASCRJ_OVHD_SEATBELT_cycle ()
local Lvar = "ASCRJ_OVHD_SEAT_BELTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state < 2 then
        ASCRJ_OVHD_SEATBELT_inc()
    else
        ASCRJ_OVHD_SEATBELT_dec()
        ASCRJ_OVHD_SEATBELT_dec()
    end
    ASCRJ_OVHD_SEATBELT_show ()
end

function ASCRJ_OVHD_SEATBELT_toggle ()
local Lvar = "ASCRJ_OVHD_SEAT_BELTS"
local state = ipc.readLvar(Lvar)
    if state ~= 1 then
        ASCRJ_OVHD_SEATBELT_off ()
    else
        ASCRJ_OVHD_SEATBELT_on ()
    end
end

function ASCRJ_OVHD_SEATBELT_show ()
local Lvar = "ASCRJ_OVHD_SEAT_BELTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        txt = "auto"
    elseif state == 1 then
        txt = "off"
    else
        txt = "on"
    end
    DspShow("BELT", txt)
    ipc.sleep(20)
end

-- $$ Emergency Lights

function ASCRJ_OVHD_EMERGLTS_on ()
local Lvar = "ASCRJ_OVHD_EMER_LTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 2 then
        ipc.writeLvar(Lvar, 2)
    end
    ASCRJ_OVHD_EMERGLTS_show()
end

function ASCRJ_OVHD_EMERGLTS_off ()
local Lvar = "ASCRJ_OVHD_EMER_LTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    ASCRJ_OVHD_EMERGLTS_show()
end

function ASCRJ_OVHD_EMERGLTS_arm ()
local Lvar = "ASCRJ_OVHD_EMER_LTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    ASCRJ_OVHD_EMERGLTS_show()
end

function ASCRJ_OVHD_EMERGLTS_inc ()
local Lvar = "ASCRJ_OVHD_EMER_LTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state < 2 then
        ipc.writeLvar(Lvar, state + 1)
    end
    ASCRJ_OVHD_EMERGLTS_show()
end

function ASCRJ_OVHD_EMERGLTS_dec ()
local Lvar = "ASCRJ_OVHD_EMER_LTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state > 0 then
        ipc.writeLvar(Lvar, state - 1)
    end
    ASCRJ_OVHD_EMERGLTS_show()
end

function ASCRJ_OVHD_EMERGLTS_cycle ()
local Lvar = "ASCRJ_OVHD_EMER_LTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state < 2 then
        ASCRJ_OVHD_EMERGLTS_inc()
    else
        ASCRJ_OVHD_EMERGLTS_dec()
        ASCRJ_OVHD_EMERGLTS_dec()
    end
    ASCRJ_OVHD_EMERGLTS_show()
end

function ASCRJ_OVHD_EMERGLTS_toggle ()
local Lvar = "ASCRJ_OVHD_EMER_LTS"
local state = ipc.readLvar(Lvar)
    if state ~= 1 then
        ASCRJ_OVHD_EMERGLTS_off ()
    else
        ASCRJ_OVHD_EMERGLTS_on ()
    end
end

function ASCRJ_OVHD_EMERGLTS_show ()
local Lvar = "ASCRJ_OVHD_EMER_LTS"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        txt = "auto"
    elseif state == 1 then
        txt = "off"
    else
        txt = "on"
    end
    DspShow("EMER", txt)
    ipc.sleep(20)
end

-- $$ Overhead Dome

function ASCRJ_OVHD_DOME_on ()
local Lvar = "ASCRJ_INTL_DOME"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("DOME", "on")
end

function ASCRJ_OVHD_DOME_off ()
local Lvar = "ASCRJ_INTL_DOME"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("DOME", "off")
end

function ASCRJ_LSP_FLOOR_toggle ()
local Lvar = "ASCRJ_INTL_DOME"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_OVHD_DOME_on ()
    else
        ASCRJ_OVHD_DOME_off ()
    end
end

-- $$ LSP Lighting

function ASCRJ_LSP_DSPL_inc ()
local Lvar = "ASCRJ_LSP_DSPL"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("Dspl", "inc")
end

function ASCRJ_LSP_DSPL_dec ()
local Lvar = "ASCRJ_LSP_DSPL"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("Dspl", "dec")
end

function ASCRJ_LSP_INTEG_inc ()
local Lvar = "ASCRJ_LSP_INTEG"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("IntL", "inc")
end

function ASCRJ_LSP_INTEG_dec ()
local Lvar = "ASCRJ_LSP_INTEG"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("IntL", "dec")
end

function ASCRJ_LSP_FLOOD_inc ()
local Lvar = "ASCRJ_LSP_FLOOD"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("FldL", "inc")
end

function ASCRJ_LSP_FLOOD_dec ()
local Lvar = "ASCRJ_LSP_FLOOD"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("FldL", "dec")
end

function ASCRJ_LSP_FLOOR_on ()
local Lvar = "ASCRJ_LSP_FLOOR"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("FlrL", "on")
end

function ASCRJ_LSP_FLOOR_off ()
local Lvar = "ASCRJ_LSP_FLOOR"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("FlrL", "off")
end

function ASCRJ_LSP_FLOOR_toggle ()
local Lvar = "ASCRJ_LSP_FLOOR"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_LSP_FLOOR_on ()
    else
        ASCRJ_LSP_FLOOR_off ()
    end
end

-- $$ RSP Lighting

function ASCRJ_RSP_DSPL_inc ()
local Lvar = "ASCRJ_RSP_DSPL"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("Dspl", "inc")
end

function ASCRJ_RSP_DSPL_dec ()
local Lvar = "ASCRJ_RSP_DSPL"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("Dspl", "dec")
end

function ASCRJ_RSP_INTEG_inc ()
local Lvar = "ASCRJ_RSP_INTEG"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("IntL", "inc")
end

function ASCRJ_RSP_INTEG_dec ()
local Lvar = "ASCRJ_RSP_INTEG"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("IntL", "dec")
end

function ASCRJ_RSP_FLOOD_inc ()
local Lvar = "ASCRJ_RSP_FLOOD"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("FldL", "inc")
end

function ASCRJ_RSP_FLOOD_dec ()
local Lvar = "ASCRJ_LSP_FLOOD"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("FldL", "dec")
end

function ASCRJ_RSP_FLOOR_on ()
local Lvar = "ASCRJ_RSP_FLOOR"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("FlrL", "on")
end

function ASCRJ_RSP_FLOOR_off ()
local Lvar = "ASCRJ_RSP_FLOOR"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("FlrL", "off")
end

function ASCRJ_RSP_FLOOR_toggle ()
local Lvar = "ASCRJ_RSP_FLOOR"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_RSP_FLOOR_on ()
    else
        ASCRJ_RSP_FLOOR_off ()
    end
end

-- $$ Ped Lighting

--DSPL
function ASCRJ_INTL_DSPL_BRT_inc ()
local Lvar = "ASCRJ_INTL_DSPL_BRT"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("DSPL", "inc")
end

function ASCRJ_INTL_DSPL_BRT_dec ()
local Lvar = "ASCRJ_INTL_DSPL_BRT"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("DSPL", "dec")
end

--INTEG
function ASCRJ_INTL_INTEG_BRT_inc ()
local Lvar = "ASCRJ_INTL_INTEG_BRT"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("INTG", "inc")
end

function ASCRJ_INTL_INTEG_BRT_dec ()
local Lvar = "ASCRJ_INTL_INTEG_BRT"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("INTG", "dec")
end

--FLOOD
function ASCRJ_INTL_FLOOD_BRT_inc ()
local Lvar = "ASCRJ_INTL_FLOOD_BRT"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("FLOD", "inc")
end

function ASCRJ_INTL_FLOOD_BRT_dec ()
local Lvar = "ASCRJ_INTL_FLOOD_BRT"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("FLOD", "dec")
end

--PED SPOTS
function ASCRJ_DM_LT_CPT_inc ()
local Lvar = "ASCRJ64_DM_LT_CPT"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("DML", "inc")
end

function ASCRJ_DM_LT_CPT_dec ()
local Lvar = "ASCRJ64_DM_LT_CPT"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("DM L", "dec")
end

function ASCRJ_DM_LT_FO_inc ()
local Lvar = "ASCRJ64_DM_LT_FO"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("DML", "inc")
end

function ASCRJ_DM_LT_FO_dec ()
local Lvar = "ASCRJ64_DM_LT_FO"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("DM L", "dec")
end

--CB PANEL
function ASCRJ_INTL_CB_PNL_BRT_inc ()
local Lvar = "ASCRJ_INTL_CB_PNL_BRT"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("CB P", "inc")
end

function ASCRJ_INTL_CB_PNL_BRT_dec ()
local Lvar = "ASCRJ_INTL_CB_PNL_BRT"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("CB P", "dec")
end

-- $$ Overhead Integral

function ASCRJ_INTL_OVHD_inc ()
local Lvar = "ASCRJ_INTL_OVHD"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    DspShow("INTG", "inc")
end

function ASCRJ_INTL_OVHD_dec ()
local Lvar = "ASCRJ_INTL_OVHD"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    DspShow("INTG", "dec")
end

function ASCRJ_INTL_OVHD_off ()
local Lvar = "ASCRJ_INTL_OVHD"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("INTG", "off")
end

function ASCRJ_INTL_OVHD_med ()
local Lvar = "ASCRJ_INTL_OVHD"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 12 then
        ipc.writeLvar(Lvar, 12)
    end
    DspShow("INTG", "med")
end

function ASCRJ_INTL_OVHD_max ()
local Lvar = "ASCRJ_INTL_OVHD"
local Lval = ipc.readLvar(Lvar)
    if Lval < 25 then
        ipc.writeLvar(Lvar, 25)
    end
    DspShow("INTG", "max")
end

function ASCRJ_INTL_OVHD_cycle ()
local Lvar = "ASCRJ_INTL_OVHD"
local Lval = ipc.readLvar(Lvar)
    if Lval == 0 then
        ASCRJ_INTL_OVHD_med ()
    elseif Lval == 12 then
        ASCRJ_INTL_OVHD_max ()
    else
        ASCRJ_INTL_OVHD_off ()
    end
end

-- $$ All Panel Lights

function ASCRJ_ALL_DSPL_inc ()
    ASCRJ_LSP_DSPL_inc()
    ASCRJ_RSP_DSPL_inc()
    ASCRJ_INTL_DSPL_BRT_inc()
end

function ASCRJ_ALL_DSPL_dec ()
    ASCRJ_LSP_DSPL_dec()
    ASCRJ_RSP_DSPL_dec()
    ASCRJ_INTL_DSPL_BRT_dec()
end

function ASCRJ_ALL_INTEG_inc ()
    ASCRJ_LSP_INTEG_inc()
    ASCRJ_RSP_INTEG_inc()
    ASCRJ_INTL_OVHD_inc()
    ASCRJ_INTL_INTEG_BRT_inc()
end

function ASCRJ_ALL_INTEG_dec ()
    ASCRJ_LSP_INTEG_dec()
    ASCRJ_RSP_INTEG_dec()
    ASCRJ_INTL_OVHD_dec()
    ASCRJ_INTL_INTEG_BRT_dec()
end

function ASCRJ_ALL_FLOOD_inc ()
    ASCRJ_LSP_FLOOD_inc()
    ASCRJ_RSP_FLOOD_inc()
    ASCRJ_INTL_FLOOD_BRT_inc()
    ASCRJ_DM_LT_CPT_inc ()
    ASCRJ_DM_LT_FO_inc()
end

function ASCRJ_ALL_FLOOD_dec ()
    ASCRJ_LSP_FLOOD_dec()
    ASCRJ_RSP_FLOOD_dec()
    ASCRJ_INTL_FLOOD_BRT_dec()
    ASCRJ_DM_LT_CPT_dec ()
    ASCRJ_DM_LT_FO_dec()
end

-- ## Left Services Panel

-- $$ Bearing

function ASCRJ_LSP_BRG1_show()
local Lvar = "ASCRJ_LSP_BRG1_INFO"
local Lval = ipc.readLvar(Lvar)
    _loggg('[ACRJ] brg1 = ' .. tostring(Lval))
    local src = Lval
    if src == 0 then srctxt = 'off'
    elseif src == 1 then srctxt = 'VOR1'
    elseif src == 2 then srctxt = 'ADF1'
    elseif src == 3 then srctxt = 'FMS1'
    end
    DspShow('BRG1', srctxt)
end

function ASCRJ_LSP_BRG2_show()
local Lvar = "ASCRJ_LSP_BRG2_INFO"
local Lval = ipc.readLvar(Lvar)
    _loggg('[ACRJ] brg2 = ' .. tostring(Lval))
    local src = Lval
    if src == 0 then srctxt = 'off'
    elseif src == 1 then srctxt = 'VOR2'
    elseif src == 2 then srctxt = 'ADF2'
    elseif src == 3 then srctxt = 'FMS2'
    end
    DspShow('BRG2', srctxt)
end

function ASCRJ_LSP_BRG1_cycle ()
local Lvar1 = "ASCRJ_LSP_BRG1_BTN"
local Lvar2 = "ASCRJ_LSP_BRG1"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    ASCRJ_LSP_BRG1_show()
end

function ASCRJ_LSP_BRG2_cycle ()
local Lvar1 = "ASCRJ_LSP_BRG2_BTN"
local Lvar2 = "ASCRJ_LSP_BRG2"
local Lvar3 = "ASCRJ_LSP_BRG2_INFO"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    ASCRJ_LSP_BRG2_show()
end

-- $$ LSP Nav Source

function ASCRJ_LSP_NAVSRC_INFO_show(Lval, up)
    if Lval == nil then Lval = 2 end
    _loggg('[ACRJ] nav src = ' .. tostring(Lval))
    local src = Lval
    if (Lval < 4 and up == true) then
        src = Lval + 1
    elseif (Lval == 4 and up == true) then
        src = 0
    elseif (Lval > 0 and up == false) then
        src = Lval - 1
    elseif (Lval == 0 and up == false) then
        src = 4
    end
    if src == 0 then srctxt = 'FMS1'
    elseif src == 1 then srctxt = 'VOR1'
    elseif src == 2 then srctxt = 'off'
    elseif src == 3 then srctxt = 'VOR2'
    elseif src == 4 then srctxt = 'FMS2'
    end
    DspShow('NavS', srctxt)
end

function ASCRJ_LSP_NAV_SOURCE_CHANGE_inc ()
local Lvar1 = "ASCRJ_LSP_NAV_SOURCE_CHANGE"
local Lvar2 = "ASCRJ_LSP_NAVSRC_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, 1)
    ASCRJ_LSP_NAVSRC_INFO_show(state, true)
end

function ASCRJ_LSP_NAV_SOURCE_CHANGE_dec ()
local Lvar1 = "ASCRJ_LSP_NAV_SOURCE_CHANGE"
local Lvar2 = "ASCRJ_LSP_NAVSRC_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, -1)
    ASCRJ_LSP_NAVSRC_INFO_show(state, false)
end

-- $$ LSP Range

function ASCRJ_LSP_RANGE_INFO_show(Lval, up)
    if Lval == nil then Lval = 0 end
    _loggg('[ACRJ] range = ' .. tostring(Lval))
    local rng = Lval
    if (Lval < 640 and up == true) then
        rng = (Lval * 2)
    elseif (Lval > 10 and up == false) then
        rng = Lval / 2
    end
    DspShow('RNG', rng)
end

function ASCRJ_LSP_RANGE_CHANGE_inc ()
local Lvar1 = "ASCRJ_LSP_RANGE_CHANGE"
local Lvar2 = "ASCRJ_LSP_RANGE_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, 1)
    ASCRJ_LSP_RANGE_INFO_show(state, true)
end

function ASCRJ_LSP_RANGE_CHANGE_dec ()
local Lvar1 = "ASCRJ_LSP_RANGE_CHANGE"
local Lvar2 = "ASCRJ_LSP_RANGE_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, -1)
    ASCRJ_LSP_RANGE_INFO_show(state, false)
end

-- $$ LSP Format

function ASCRJ_LSP_FORMAT_INFO_show(Lval, up)
    if Lval == nil then Lval = 0 end
    _loggg('[ACRJ] format = ' .. tostring(Lval))
    local fmt = Lval
    if (Lval < 5 and up == true) then
        fmt = Lval --+ 1
    elseif (Lval > 0 and up == false) then
        fmt = Lval --- 1
    end
    DspShow('Frmt', fmt)
end

function ASCRJ_LSP_FORMAT_CHANGE_inc ()
local Lvar1 = "ASCRJ_LSP_FORMAT_CHANGE"
local Lvar2 = "ASCRJ_LSP_FORMAT_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, 1)
    ASCRJ_LSP_FORMAT_INFO_show(state, true)
end

function ASCRJ_LSP_FORMAT_CHANGE_dec ()
local Lvar1 = "ASCRJ_LSP_FORMAT_CHANGE"
local Lvar2 = "ASCRJ_LSP_FORMAT_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, -1)
    ASCRJ_LSP_FORMAT_INFO_show(state, false)
end

-- $$ Radar/Terrain

function ASCRJ_LSP_RDR_toggle ()
local Lvar1 = "ASCRJ_LSP_RDR_BTN"
local Lvar2 = "ASCRJ_LSP_RDR"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('RDR', 'togg')
end

function ASCRJ_LSP_TERR_toggle ()
local Lvar1 = "ASCRJ_LSP_TERR_BTN"
local Lvar2 = "ASCRJ_LSP_TERR"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('TFC', 'togg')
end

-- $$ Speed Refs

function ASCRJ_LSP_SEL_cycle ()
local Lvar1 = "ASCRJ_LSP_SEL_BTN"
local Lvar2 = "ASCRJ_LSP_SEL"
local Lvar3 = "ASCRJ_LSP_REFSPD_INFO"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)

    local Lval3 = ipc.readLvar(Lvar3)

    if Lval3 == 1 then lbl = 'V1'
    elseif Lval3 == 2 then lbl = 'VRef'
    elseif Lval3 == 3 then lbl = 'V2'
    elseif Lval3 == 4 then lbl = 'VT'
    else lbl = 'err'
    end
    DspShow('SpdS', lbl)
end

function ASCRJ_LSP_SPEED_SEL_show()
local Lvar1 = "ASCRJ_LSP_SPEED_SEL"
local Lvar2 = "ASCRJ_LSP_REFSPD_INFO"
local Lval1 = ipc.readLvar(Lvar1)
local Lval2 = ipc.readLvar(Lvar2)
local txt = 'err'
    _loggg('[ACRJ] RefSpd = ' .. Lval2 .. ' Spd = ' .. Lval1 / 2)
    if Lval2 == 1 then lbl = 'V1'
    elseif Lval2 == 2 then lbl = 'VR'
    elseif Lval2 == 3 then lbl = 'V2'
    elseif Lval2 == 4 then lbl = 'VT'
    else lbl = 'err'
    end

    txt = math.floor(Lval1 / 2)

    DspShow('SRef', lbl) --, txt)
end

function ASCRJ_LSP_SPEED_SEL_inc ()
local Lvar1 = "ASCRJ_LSP_SPEED_SEL_CHANGE"
local Lvar2 = "ASCRJ_LSP_SPEED_SEL"
local Lvar3 = "ASCRJ_LSP_REFSPD_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, 1)

    Lval3 = ipc.readLvar(Lvar3)
    if Lval3 == 1 then lbl = 'V1'
    elseif Lval3 == 2 then lbl = 'VR'
    elseif Lval3 == 3 then lbl = 'V2'
    elseif Lval3 == 4 then lbl = 'VT'
    else lbl = 'tgt'
    end
    DspShow(lbl, 'inc')
end

function ASCRJ_LSP_SPEED_SEL_dec ()
local Lvar1 = "ASCRJ_LSP_SPEED_SEL_CHANGE"
local Lvar2 = "ASCRJ_LSP_SPEED_SEL"
local Lvar3 = "ASCRJ_LSP_REFSPD_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, -1)

    Lval3 = ipc.readLvar(Lvar3)
    if Lval3 == 1 then lbl = 'V1'
    elseif Lval3 == 2 then lbl = 'VR'
    elseif Lval3 == 3 then lbl = 'V2'
    elseif Lval3 == 4 then lbl = 'VT'
    else lbl = 'tgt'
    end
    DspShow(lbl, 'dec')
end

function ASCRJ_LSP_SPEED_MODE_vspd ()
local Lvar1 = "ASCRJ_LSP_SPEED_MODE"
local Lvar2 = "ASCRJ_LSP_REFSPD_INFO"
local state = ipc.readLvar(Lvar2)
    if state == 0 then
        ipc.writeLvar(Lvar1, 1)
    end
    DspShow('SRef', 'vspd')
end

function ASCRJ_LSP_SPEED_MODE_vtgt ()
local Lvar1 = "ASCRJ_LSP_SPEED_MODE"
local Lvar2 = "ASCRJ_LSP_REFSPD_INFO"
local state = ipc.readLvar(Lvar2)
    if state > 0 then
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('SRef', 'tgt')
end

function ASCRJ_LSP_SPEED_MODE_toggle ()
local Lvar1 = "ASCRJ_LSP_SPEED_MODE"
local Lvar2 = "ASCRJ_LSP_REFSPD_INFO"
local state = ipc.readLvar(Lvar2)
    if state == 0 then
        ASCRJ_LSP_SPEED_MODE_vspd ()
    else
        ASCRJ_LSP_SPEED_MODE_vtgt ()
    end
end

function ASCRJ_LSP_SPEED_SET ()
local Lvar1 = "ASCRJ_LSP_SPEED_SET_BTN"
local Lvar2 = "ASCRJ_LSP_SPEED_SET"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(100)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('RSpd', 'set')
end

-- $$ Radar Altimeter / DH-MDA

function ASCRJ_LSP_HEIGHT_SET()
local Lvar1 = "ASCRJ_LSP_HEIGHT_SET_BTN"
local Lvar2 = "ASCRJ_LSP_HEIGHT_SET"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(100)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('DH/A', 'set')
end

function ASCRJ_LSP_HEIGHT_MODE_MDA ()
local Lvar1 = "ASCRJ_LSP_HEIGHT_MODE"
local state = ipc.readLvar(Lvar1)
    if state == 0 then
        ipc.writeLvar(Lvar1, 1)
    end
    DspShow('DH/A', 'mda')
end

function ASCRJ_LSP_HEIGHT_MODE_DH ()
local Lvar1 = "ASCRJ_LSP_HEIGHT_MODE"
local state = ipc.readLvar(Lvar1)
    if state > 0 then
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('DH/A', 'dh')
end

function ASCRJ_LSP_HEIGHT_MODE_toggle ()
local Lvar1 = "ASCRJ_LSP_HEIGHT_MODE"
local state = ipc.readLvar(Lvar1)
    if state == 0 then
        ASCRJ_LSP_HEIGHT_MODE_MDA ()
    else
        ASCRJ_LSP_HEIGHT_MODE_DH ()
    end
end

function ASCRJ_LSP_RA_TEST ()
local Lvar1 = "ASCRJ_LSP_RA_TEST_BTN"
local Lvar2 = "ASCRJ_LSP_RDR"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(1500)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('RA', 'test')
end

-- $$ Baro

function ASCRJ_LSP_BARO_VALUE_show()
local Lvar1 = "ASCRJ_LSP_BARO_VALUE"
local Lvar2 = "ASCRJ_LSP_BARO_INFO"
local Lval1 = ipc.readLvar(Lvar1)
local Lval2 = ipc.readLvar(Lvar2)
local txt = 'err'
    if Lval2 == 0 then
        txt = math.floor(Lval1)
    else
        txt = string.format("%2.2f", Lval1)
    end

    DspShow('Baro', txt)
end

function ASCRJ_LSP_BARO_inHg ()
local Lvar1 = "ASCRJ_LSP_HPA_IN_BTN"
local Lvar2 = "ASCRJ_LSP_HPA_IN"
local Lvar3 ="ASCRJ_LSP_BARO_INFO"
    ipc.writeLvar(Lvar2, 1)
    if ipc.readLvar(Lvar3) < 1 then
        DspShow('Baro', 'HPa')
    else
        DspShow('Baro', 'inHg')
    end
end

function ASCRJ_LSP_BARO_HPa ()
local Lvar1 = "ASCRJ_LSP_HPA_IN_BTN"
local Lvar2 = "ASCRJ_LSP_HPA_IN"
local Lvar3 ="ASCRJ_LSP_BARO_INFO"
    ipc.writeLvar(Lvar2, -1)
    if ipc.readLvar(Lvar3) < 1 then
        DspShow('Baro', 'HPa')
    else
        DspShow('Baro', 'inHg')
    end
end

function ASCRJ_LSP_HPA_IN_toggle ()
local Lvar1 = "ASCRJ_LSP_HPA_IN_BTN"
local Lvar2 = "ASCRJ_LSP_HPA_IN"
local Lvar3 ="ASCRJ_LSP_BARO_INFO"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) < 1 then
        DspShow('Baro', 'HPa')
    else
        DspShow('Baro', 'inHg')
    end
end

function ASCRJ_LSP_BARO_STD_toggle ()
local Lvar1 = "ASCRJ_LSP_BARO_STD_BTN"
local Lvar2 = "ASCRJ_LSP_BARO_STD"
local Lvar3 ="ASCRJ_LSP_BARO_INFO"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 10 then
        DspShow('Baro', 'std')
    else
        DspShow('Baro', 'qnh')
    end
end

function ASCRJ_LSP_BARO_CHANGE_inc ()
local Lvar1 = "ASCRJ_LSP_BARO_CHANGE"
local Lvar2 = "ASCRJ_LSP_BARO_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, 1)
    ASCRJ_LSP_BARO_VALUE_show()
end

function ASCRJ_LSP_BARO_CHANGE_dec ()
local Lvar1 = "ASCRJ_LSP_BARO_CHANGE"
local Lvar2 = "ASCRJ_LSP_BARO_INFO"
local state = ipc.readLvar(Lvar2)
    ipc.writeLvar(Lvar1, -1)
    ASCRJ_LSP_BARO_VALUE_show()
end

-- $$ LSP Nosewheel Steering Arm

function ASCRJ_LSP_NW_STEER_on ()
local Lvar = "ASCRJ_LSP_NW_STEER"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("NWS", "on")
end

function ASCRJ_LSP_NW_STEER_off ()
local Lvar = "ASCRJ_LSP_NW_STEER"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("NSW", "off")
end

function ASCRJ_LSP_NW_STEER_toggle ()
local Lvar = "ASCRJ_LSP_NW_STEER"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_LSP_NW_STEER_on ()
    else
        ASCRJ_LSP_NW_STEER_off ()
    end
end

-- $$ LSP Wiper

function ASCRJ_LSP_WIPER_show()
local Lvar1 = "ASCRJ_LSP_WIPER"
local Lval1 = ipc.readLvar(Lvar1)
    if Lval1 == 0 then lbl = 'park'
    elseif Lval1 == 2 then lbl = 'int'
    elseif Lval1 == 3 then lbl = 'slow'
    elseif Lval1 == 4 then lbl = 'fast'
    else lbl = 'err'
    end
    DspShow('LWip', lbl)
end

function ASCRJ_LSP_WIPER_inc ()
local Lvar1 = "ASCRJ_LSP_WIPER"
local state = ipc.readLvar(Lvar1)
    if state < 3 then
        ipc.writeLvar(Lvar1, state + 1)
    end
    ASCRJ_LSP_WIPER_show()
end

function ASCRJ_LSP_WIPER_dec ()
local Lvar1 = "ASCRJ_LSP_WIPER"
local state = ipc.readLvar(Lvar1)
    if state > 0 then
        ipc.writeLvar(Lvar1, state - 1)
    end
    ASCRJ_LSP_WIPER_show()
end

function ASCRJ_LSP_WIPER_park ()
local Lvar1 = "ASCRJ_LSP_WIPER"
local state = ipc.readLvar(Lvar1)
    if state ~= 0 then
        ipc.writeLvar(Lvar1, 0)
    end
    ASCRJ_LSP_WIPER_show()
end

function ASCRJ_LSP_WIPER_int ()
local Lvar1 = "ASCRJ_LSP_WIPER"
local state = ipc.readLvar(Lvar1)
    if state ~= 1 then
        ipc.writeLvar(Lvar1, 1)
    end
    ASCRJ_LSP_WIPER_show()
end

function ASCRJ_LSP_WIPER_slow ()
local Lvar1 = "ASCRJ_LSP_WIPER"
local state = ipc.readLvar(Lvar1)
    if state ~= 2 then
        ipc.writeLvar(Lvar1, 2)
    end
    ASCRJ_LSP_WIPER_show()
end

function ASCRJ_LSP_WIPER_fast ()
local Lvar1 = "ASCRJ_LSP_WIPER"
local state = ipc.readLvar(Lvar1)
    if state ~= 3 then
        ipc.writeLvar(Lvar1, 3)
    end
    ASCRJ_LSP_WIPER_show()
end

-- $$ Stall Stick Pusher

function ASCRJ_LSP_STICK_PUSHER_on ()
local Lvar = "ASCRJ_LSP_STICK_PUSHER"
local state = ipc.readLvar(Lvar)
    --_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("FlrL", "on")
end

function ASCRJ_LSP_STICK_PUSHER_off ()
local Lvar = "ASCRJ_LSP_STICK_PUSHER"
local state = ipc.readLvar(Lvar)
    --_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("FlrL", "off")
end

function ASCRJ_LSP_STICK_PUSHER_toggle ()
local Lvar = "ASCRJ_LSP_STICK_PUSHER"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_LSP_STICK_PUSHER_on ()
    else
        ASCRJ_LSP_STICK_PUSHER_off ()
    end
end

-- ## OVHD Head Up Display (HUD)

function ASCRJ_HGS_HUD_on ()
local Lvar = "ASCRJ_HGS_COMBINER_SET"
local state = ipc.readLvar(Lvar)
    --_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("HUD", "on")
end

function ASCRJ_HGS_HUD_off ()
local Lvar = "ASCRJ_HGS_COMBINER_SET"
local state = ipc.readLvar(Lvar)
    --_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("HUD", "off")
end

function ASCRJ_HGS_HUD_toggle ()
local Lvar = "ASCRJ_HGS_COMBINER_SET"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_HGS_HUD_on ()
    else
        ASCRJ_HGS_HUD_off ()
    end
end

-- ## OVHD Electrical Power ###############

-- $$ Batt and DC

function ASCRJ_ELEC_BATTMASTER_on ()
local Lvar = "ASCRJ_ELEC_BATTMASTER"
local state = ipc.readLvar(Lvar)
    --_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("BATT", "on")
end

function ASCRJ_ELEC_BATTMASTER_off ()
local Lvar = "ASCRJ_ELEC_BATTMASTER"
local state = ipc.readLvar(Lvar)
    --_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("BATT", "off")
end

function ASCRJ_ELEC_BATTMASTER_toggle ()
local Lvar = "ASCRJ_ELEC_BATTMASTER"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_ELEC_BATTMASTER_on ()
    else
        ASCRJ_ELEC_BATTMASTER_off ()
    end
end

function ASCRJ_ELEC_DCSERVICE_on ()
local Lvar = "ASCRJ_ELEC_DCSERVICE"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("DC", "on")
end

function ASCRJ_ELEC_DCSERVICE_off ()
local Lvar = "ASCRJ_ELEC_DCSERVICE"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("DC", "off")
end

function ASCRJ_ELEC_DCSERVICE_toggle ()
local Lvar = "ASCRJ_ELEC_DCSERVICE"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_ELEC_DCSERVICE_on ()
    else
        ASCRJ_ELEC_DCSERVICE_off ()
    end
end

-- $$ Generators

function ASCRJ_ELEC_GEN1_on ()
local Lvar = "ASCRJ_ELEC_GEN1"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("GEN1", "on")
end

function ASCRJ_ELEC_GEN1_off ()
local Lvar = "ASCRJ_ELEC_GEN1"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("GEN1", "off")
end

function ASCRJ_ELEC_GEN1_toggle ()
local Lvar = "ASCRJ_ELEC_GEN1"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_ELEC_GEN1_on ()
    else
        ASCRJ_ELEC_GEN1_off ()
    end
end

function ASCRJ_ELEC_GEN2_on ()
local Lvar = "ASCRJ_ELEC_GEN2"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("GEN2", "on")
end

function ASCRJ_ELEC_GEN2_off ()
local Lvar = "ASCRJ_ELEC_GEN2"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("GEN2", "off")
end

function ASCRJ_ELEC_GEN2_toggle ()
local Lvar = "ASCRJ_ELEC_GEN2"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_ELEC_GEN2_on ()
    else
        ASCRJ_ELEC_GEN2_off ()
    end
end

-- $$ APU Gen

function ASCRJ_ELEC_APUGEN_on ()
local Lvar = "ASCRJ_ELEC_APUGEN"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("AGen", "on", "APU GEN", "on")
end

function ASCRJ_ELEC_APUGEN_off ()
local Lvar = "ASCRJ_ELEC_APUGEN"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("AGen", "off", "APU GEN", "off")
end

function ASCRJ_ELEC_APUGEN_toggle ()
local Lvar = "ASCRJ_ELEC_APUGEN"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_ELEC_APUGEN_on ()
    else
        ASCRJ_ELEC_APUGEN_off ()
    end
end

-- $$ AC Ext PWR

function ASCRJ_ELEC_EXTPWR_on ()
local Lvar = "ASCRJ_ELEC_EXTPWR"
--local Lvar = "ASCRJ_ELEC_GPU"
local Lvar1 = "ASCRJ_ELEC_EXTPWR_ANIM"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
        ipc.writeLvar(Lvar1, 5)
        ipc.sleep(100)
        ipc.writeLvar(Lvar1, 3)
    end
    DspShow("ExtP", "on")
end

function ASCRJ_ELEC_EXTPWR_off ()
--local Lvar = "ASCRJ_ELEC_GPU"
local Lvar = "ASCRJ_ELEC_EXTPWR"
local Lvar1 = "ASCRJ_ELEC_EXTPWR_ANIM"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
        ipc.writeLvar(Lvar1, 5)
        ipc.sleep(100)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow("ExtP", "off")
end

function ASCRJ_ELEC_EXTPWR_toggleThe  ()
local Lvar = "ASCRJ_ELEC_EXTPWR"
--local Lvar = "ASCRJ_ELEC_GPU"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_ELEC_EXTPWR_on ()
    else
        ASCRJ_ELEC_EXTPWR_off ()
    end
end

-- ## OVHD FUEL PUMPS ###############

function ASCRJ_FUEL_PUMP_L_on ()
local Lvar = "ASCRJ_FUEL_PUMP_L"
local Lvar1 = "ASCRJ_FUEL_PUMP_L_ANIM"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
        ipc.writeLvar(Lvar1, 5)
        ipc.sleep(100)
        ipc.writeLvar(Lvar1, 3)
    end
    DspShow("PUMP", "L on")
end

function ASCRJ_FUEL_PUMP_L_off ()
local Lvar = "ASCRJ_FUEL_PUMP_L"
local Lvar1 = "ASCRJ_FUEL_PUMP_L_ANIM"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
        ipc.writeLvar(Lvar1, 5)
        ipc.sleep(100)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow("PUMP", "Loff")
end

function ASCRJ_FUEL_PUMP_L_toggle ()
local Lvar = "ASCRJ_FUEL_PUMP_L"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_FUEL_PUMP_L_on ()
    else
        ASCRJ_FUEL_PUMP_L_off ()
    end
end

--

function ASCRJ_FUEL_PUMP_R_on ()
local Lvar = "ASCRJ_FUEL_PUMP_R"
local Lvar1 = "ASCRJ_FUEL_PUMP_R_ANIM"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
        ipc.writeLvar(Lvar1, 5)
        ipc.sleep(100)
        ipc.writeLvar(Lvar1, 3)
    end
    DspShow("PUMP", "R on")
end

function ASCRJ_FUEL_PUMP_R_off ()
local Lvar = "ASCRJ_FUEL_PUMP_R"
local Lvar1 = "ASCRJ_FUEL_PUMP_R_ANIM"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
        ipc.writeLvar(Lvar1, 5)
        ipc.sleep(100)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow("PUMP", "Roff")
end

function ASCRJ_FUEL_PUMP_R_toggle ()
local Lvar = "ASCRJ_FUEL_PUMP_R"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_FUEL_PUMP_R_on ()
    else
        ASCRJ_FUEL_PUMP_R_off ()
    end
end

-- ## OVHD Bleed Air ###############

-- $$ Bleed Cross

function ASCRJ_AIR_CROSS_BLEED_left ()
    ipc.writeLvar("ASCRJ_AIR_CROSS_BLEED", 0)
    DspShow ("CRSS", "BLDl", "CRSS", "BLEED L")
end

function ASCRJ_AIR_CROSS_BLEED_normal ()
    ipc.writeLvar("ASCRJ_AIR_CROSS_BLEED", 1)
    DspShow ("CRSS", "BLDn", "CRSS", "BLEED N")
end

function ASCRJ_AIR_CROSS_BLEED_right ()
    ipc.writeLvar("ASCRJ_AIR_CROSS_BLEED", 2)
    DspShow ("CRSS", "BLDr", "CRSS", "BLEED R")
end

-- $$ Bleed valves

function ASCRJ_AIR_BLEED_VALVES_clsd ()
    ipc.writeLvar("ASCRJ_AIR_BLEED_VALVES", 0)
    DspShow ("BVLV", "clsd", "BLEEDVLV", "closed")
end

function ASCRJ_AIR_BLEED_VALVES_auto ()
    ipc.writeLvar("ASCRJ_AIR_BLEED_VALVES", 1)
    DspShow ("BVLV", "auto", "BLEEDVLV", "auto")
end

function ASCRJ_AIR_BLEED_VALVES_manual ()
    ipc.writeLvar("ASCRJ_AIR_BLEED_VALVES", 2)
    DspShow ("BVLV", "man", "BLEEDVLV", "manual")
end

-- $$ Bleed Isol

function ASCRJ_AIR_BLEED_SOURCE_ISOL_open ()
    ipc.writeLvar("ASCRJ_AIR_BLEED_SOURCE_ISOL", 0)
    DspShow ("ISOL", "open")
end

function ASCRJ_AIR_BLEED_SOURCE_ISOL_clsd ()
    ipc.writeLvar("ASCRJ_AIR_BLEED_SOURCE_ISOL", 1)
    DspShow ("ISOL", "clsd")
end

function ASCRJ_AIR_BLEED_SOURCE_ISOL_toggle ()
	if _tl("ASCRJ_AIR_BLEED_SOURCE_ISOL", 0) then
      ASCRJ_AIR_BLEED_SOURCE_ISOL_clsd ()
	else
      ASCRJ_AIR_BLEED_SOURCE_ISOL_open ()
	end
end

-- $$ Bleed Source

function ASCRJ_AIR_BLEED_SOURCE_both ()
    ipc.writeLvar("ASCRJ_AIR_BLEED_SOURCE", 0)
    DspShow ("SRCE", "both")
end

function ASCRJ_AIR_BLEED_SOURCE_EngR ()
    ipc.writeLvar("ASCRJ_AIR_BLEED_SOURCE", 1)
    DspShow ("SRCE", "EngR")
end

function ASCRJ_AIR_BLEED_SOURCE_apu ()
    ipc.writeLvar("ASCRJ_AIR_BLEED_SOURCE", 2)
    DspShow ("SRCE", "apu")
end

function ASCRJ_AIR_BLEED_SOURCE_EngL ()
    ipc.writeLvar("ASCRJ_AIR_BLEED_SOURCE", 3)
    DspShow ("SRCE", "EngL")
end

-- ## OVHD APU ###############

-- $$ OVHD APU Power and Fuel

function ASCRJ_APU_PWRFUEL_on ()
local Lvar1 = "ASCRJ_APU_PWRFUEL_BTN"
local Lvar2 = "APU_DOOR_POS"

local state = ipc.readLvar(Lvar2)
_loggg('[ACRJ] state = ' .. state)
    if state == 0 then
        ipc.writeLvar(Lvar1, 1)
        ipc.writeLvar("ASCRJ_APU_PWRFUEL", 1)
        ipc.sleep(100)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow("APUf", "on", "APU PWR", "on")
end

function ASCRJ_APU_PWRFUEL_off ()
local Lvar1 = "ASCRJ_APU_PWRFUEL_BTN"
local Lvar2 = "APU_DOOR_POS"

local state = ipc.readLvar(Lvar2)
_loggg('[ACRJ] state = ' .. state)
    if state > 0 then
        ipc.writeLvar(Lvar1, 1)
        ipc.writeLvar("ASCRJ_APU_PWRFUEL", 1)
        ipc.sleep(100)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow("APUf", "off", "APU PWR", "off")
end

function ASCRJ_APU_PWRFUEL_toggle ()
	if _tl("APU_DOOR_POS", 0) then
       ASCRJ_APU_PWRFUEL_on ()
	else
       ASCRJ_APU_PWRFUEL_off ()
	end
end

-- $$ OVHD APU Start

function ASCRJ_APU_START_on ()
    APUrunup = ipc.readLvar("ASCRJ_APU_STARTSTOP_START")
    APUavail = ipc.readLvar("ASCRJ_APU_STARTSTOP_AVAIL")
    ipc.sleep(10)
    if APUrunup == 0 and APUavail == 0 then
        ipc.writeLvar("ASCRJ_APU_STARTSTOP", 1)
    end
    DspShow ("APU", "strt")
end

function ASCRJ_APU_START_off ()
    APUrunup = ipc.readLvar("ASCRJ_APU_STARTSTOP_START")
    APUavail = ipc.readLvar("ASCRJ_APU_STARTSTOP_AVAIL")
    ipc.sleep(10)
    if APUrunup == 1 or APUavail == 1 then
        ipc.writeLvar("ASCRJ_APU_STARTSTOP", 0)
    end
    DspShow ("APU", "stop")
end

function ASCRJ_APU_START_toggle ()
    if _tl("ASCRJ_APU_STARTSTOP_AVAIL", 0) then
        ASCRJ_APU_START_on ()
	else
        ASCRJ_APU_START_off ()
	end
end


-- ## Engine Start ###############

function ASCRJ_ENGS_START_L_press ()
local Lvar = "ASCRJ_ENGS_START_L_BTN"
local Lvar2 = "ASCRJ_ENGS_START_L"
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar, 0)
    DspShow("ENG", "1str", "ENG 1", "start")
end

function ASCRJ_ENGS_START_R_press ()
local Lvar = "ASCRJ_ENGS_START_R_BTN"
local Lvar2 = "ASCRJ_ENGS_START_R"
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar, 0)
    DspShow("ENG", "2str", "ENG 2", "start")
end

function ASCRJ_ENGS_STOP_L_press ()
local Lvar = "ASCRJ_ENGS_STOP_L_BTN"
local Lvar2 = "ASCRJ_ENGS_STOP_L"
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar, 0)
    DspShow("ENG", "1stp", "ENG 1", "stop")
end

function ASCRJ_ENGS_STOP_R_press ()
local Lvar = "ASCRJ_ENGS_STOP_R_BTN"
local Lvar2 = "ASCRJ_ENGS_STOP_R"
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(50)
    ipc.writeLvar(Lvar, 0)
    DspShow("ENG", "2stp", "ENG 2", "stop")
end

function ASCRJ_ENGS_START_both_press ()
    ASCRJ_ENGS_START_L_press()
    ipc.sleep(100)
    ASCRJ_ENGS_START_R_press()
end

function ASCRJ_ENGS_STOP_both_press ()
    ASCRJ_ENGS_STOP_L_press()
    ipc.sleep(100)
    ASCRJ_ENGS_STOP_R_press()
end

-- ## OVHD Hydraulic ###############

-- $$ Hyd 1

function ASCRJ_HYDR_PUMP_1_on ()
local Lvar = "ASCRJ_HYDR_PUMP_1"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("HYD", "1 on", "HYD 1", "on")
end

function ASCRJ_HYDR_PUMP_1_off ()
local Lvar = "ASCRJ_HYDR_PUMP_1"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("HYD", "1 off", "HYD 1", "off")
end

function ASCRJ_HYDR_PUMP_1_auto ()
local Lvar = "ASCRJ_HYDR_PUMP_1"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 2 then
        ipc.writeLvar(Lvar, 2)
    end
    DspShow("HYD", "1aut", "HYD 1", "auto")
end

function ASCRJ_HYDR_PUMP_1_toggle ()
local Lvar = "ASCRJ_HYDR_PUMP_1"
local state = ipc.readLvar(Lvar)
    if state == 1 then
        ASCRJ_HYDR_PUMP_1_auto ()
    else
        ASCRJ_HYDR_PUMP_1_off ()
    end
end


-- $$ Hyd 3A

function ASCRJ_HYDR_PUMP_3A_auto ()
local Lvar = "ASCRJ_HYDR_PUMP_3A"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("HYD", "3Aon", "HYD 3A", "on")
end

function ASCRJ_HYDR_PUMP_3A_off ()
local Lvar = "ASCRJ_HYDR_PUMP_3A"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("HYD", "3Aoff", "HYD 3A", "off")
end


function ASCRJ_HYDR_PUMP_3A_toggle ()
local Lvar = "ASCRJ_HYDR_PUMP_3A"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_HYDR_PUMP_3A_auto ()
    else
        ASCRJ_HYDR_PUMP_3A_off ()
    end
end

-- $$ Hyd 3B

function ASCRJ_HYDR_PUMP_3B_on ()
local Lvar = "ASCRJ_HYDR_PUMP_3B"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("HYD", "3Bon", "HYD 3B", "on")
end

function ASCRJ_HYDR_PUMP_3B_off ()
local Lvar = "ASCRJ_HYDR_PUMP_3B"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("HYD", "3Boff", "HYD 3B", "off")
end

function ASCRJ_HYDR_PUMP_3B_auto ()
local Lvar = "ASCRJ_HYDR_PUMP_3B"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 2 then
        ipc.writeLvar(Lvar, 2)
    end
    DspShow("HYD", "3Baut", "HYD 3B", "auto")
end

function ASCRJ_HYDR_PUMP_3B_toggle ()
local Lvar = "ASCRJ_HYDR_PUMP_3B"
local state = ipc.readLvar(Lvar)
    if state == 1 then
        ASCRJ_HYDR_PUMP_3B_auto ()
    else
        ASCRJ_HYDR_PUMP_3B_off ()
    end
end

-- $$ Hyd 2

function ASCRJ_HYDR_PUMP_2_on ()
local Lvar = "ASCRJ_HYDR_PUMP_2"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("HYD", "2 on", "HYD 2", "on")
end

function ASCRJ_HYDR_PUMP_2_off ()
local Lvar = "ASCRJ_HYDR_PUMP_2"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("HYD", "2 off", "HYD 2", "off")
end

function ASCRJ_HYDR_PUMP_2_auto ()
local Lvar = "ASCRJ_HYDR_PUMP_2"
local state = ipc.readLvar(Lvar)
_loggg('[ACRJ] state = ' .. state)
    if state ~= 2 then
        ipc.writeLvar(Lvar, 2)
    end
    DspShow("HYD", "2aut", "HYD 2", "auto")
end

function ASCRJ_HYDR_PUMP_2_toggle ()
local Lvar = "ASCRJ_HYDR_PUMP_2"
local state = ipc.readLvar(Lvar)
    if state == 1 then
        ASCRJ_HYDR_PUMP_2_auto ()
    else
        ASCRJ_HYDR_PUMP_2_off ()
    end
end

-- ## FWD Pedestal ############

-- $$ BTMS Overheat Warning Reset

function ASCRJ_GEAR_BTMS_RESET_press ()
local Lvar1 = "ASCRJ_GEAR_BTMS_RESET_BTN"
local Lvar2 = "ASCRJ_GEAR_BTMS_RESET"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('BTMS', 'rset', 'BTMS OVHT', 'warn reset')
end

-- $$ Horn Mute

function ASCRJ_GEAR_HORN_MUTE_on ()
local Lvar1 = "ASCRJ_GEAR_HORN_MUTE_GUARD"
local Lvar2 = "ASCRJ_GEAR_HORN_MUTE_ANIM"
local Lvar3 = "ASCRJ_GEAR_HORN_MUTE"
local Lvar4 = "ASCRJ_GEAR_HORN_MUTE_ON"
    if ipc.readLvar(Lvar4) ~= 1 then
        ipc.writeLvar(Lvar1, 1)
        ipc.sleep(30)
        ipc.writeLvar(Lvar3, 1)
        ipc.sleep(100)
        ipc.writeLvar(Lvar2, 0)
        ipc.sleep(50)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('HPSH', 'on', 'HIGH PWR', 'sched on')
end

function ASCRJ_GEAR_HORN_MUTE_off ()
local Lvar1 = "ASCRJ_GEAR_HORN_MUTE_GUARD"
local Lvar2 = "ASCRJ_GEAR_HORN_MUTE_ANIM"
local Lvar3 = "ASCRJ_GEAR_HORN_MUTE"
local Lvar4 = "ASCRJ_GEAR_HORN_MUTE_ON"
    if ipc.readLvar(Lvar4) ~= 0 then
        ipc.writeLvar(Lvar1, 1)
        ipc.sleep(30)
        ipc.writeLvar(Lvar3, 0)
        ipc.sleep(100)
        ipc.writeLvar(Lvar2, 0)
        ipc.sleep(50)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('HPSH', 'off', 'HIGH PWR', 'sched off')
end

function ASCRJ_GEAR_HORN_MUTE_toggle()
local Lvar4 = "ASCRJ_ENG_HPSCHED_ON"
    if ipc.readLvar(Lvar4) ~= 1 then
       ASCRJ_GEAR_HORN_MUTE_on()
    else
       ASCRJ_GEAR_HORN_MUTE_off()
    end
end



-- $$ Anti Skid

function ASCRJ_GEAR_ANTISKID_arm ()
local Lvar = "ASCRJ_GEAR_ANTISKID_ARM"
local state = ipc.readLvar(Lvar)
    if state ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("SKID", "arm", "Anti Skid", "arm")
end


function ASCRJ_GEAR_ANTISKID_off ()
local Lvar = "ASCRJ_GEAR_ANTISKID_ARM"
local state = ipc.readLvar(Lvar)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("SKID", "off", "Anti Skid", "off")
end

function ASCRJ_GEAR_ANTISKID_toggle ()
local Lvar = "ASCRJ_GEAR_ANTISKID_ARM"
local state = ipc.readLvar(Lvar)
    if state ~= 1 then
        ASCRJ_GEAR_ANTISKID_off()
    else
        ASCRJ_GEAR_ANTISKID_arm()
    end
end

-- $$ MLG Bay Overheat Test

function ASCRJ_GEAR_MLG_test ()
local Lvar = "ASCRJ_GEAR_MLG_TEST"
local state = ipc.readLvar(Lvar)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
        ipc.sleep(250)
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("OVHT", "test", "MLG OVHT", "test")
end

function ASCRJ_GEAR_TEST_FAIL_test ()
local Lvar = "ASCRJ_GEAR_TEST_FAIL_TEST"
local state = ipc.readLvar(Lvar)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
        ipc.sleep(250)
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("WARN", "fail", "WARN FAIL", "test")
end

-- $$ Engine Sync

function ASCRJ_ENG_SYNC_show()
local Lvar = "ASCRJ_ENG_SYNC"
local Lval = ipc.readLvar(Lvar)
    if Lval == 0 then txt = '1'
    elseif Lval == 1 then txt = 'off'
    else txt = '2'
    end
    DspShow("Sync", txt, "Eng Sync", txt)
end

function ASCRJ_ENG_SYNC_off()
local Lvar = "ASCRJ_ENG_SYNC"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    ASCRJ_ENG_SYNC_show()
end

function ASCRJ_ENG_SYNC_one()
local Lvar = "ASCRJ_ENG_SYNC"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    ASCRJ_ENG_SYNC_show()
end

function ASCRJ_ENG_SYNC_two()
local Lvar = "ASCRJ_ENG_SYNC"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 2 then
        ipc.writeLvar(Lvar, 2)
    end
    ASCRJ_ENG_SYNC_show()
end

function ASCRJ_ENG_SYNC_inc()
local Lvar = "ASCRJ_ENG_SYNC"
local Lval = ipc.readLvar(Lvar)
    if Lval < 2 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    ASCRJ_ENG_SYNC_show()
end

function ASCRJ_ENG_SYNC_dec()
local Lvar = "ASCRJ_ENG_SYNC"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    ASCRJ_ENG_SYNC_show()
end

function ASCRJ_ENG_SYNC_cycle()
local Lvar = "ASCRJ_ENG_SYNC"
local Lval = ipc.readLvar(Lvar)
    if Lval < 2 then
        ASCRJ_ENG_SYNC_inc()
    else
        ASCRJ_ENG_SYNC_one ()
    end
end

-- $$ Engine High Power Schedule

function ASCRJ_ENG_HPSCHED_on ()
local Lvar1 = "ASCRJ_ENG_HPSCHED_GUARD"
local Lvar2 = "ASCRJ_ENG_HPSCHED_ANIM"
local Lvar3 = "ASCRJ_ENG_HPSCHED"
local Lvar4 = "ASCRJ_ENG_HPSCHED_ON"
    if ipc.readLvar(Lvar4) ~= 1 then
        ipc.writeLvar(Lvar1, 1)
        ipc.sleep(30)
        ipc.writeLvar(Lvar3, 1)
        ipc.sleep(100)
        ipc.writeLvar(Lvar2, 0)
        ipc.sleep(50)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('HPSH', 'on', 'HIGH PWR', 'sched on')
end

function ASCRJ_ENG_HPSCHED_off ()
local Lvar1 = "ASCRJ_ENG_HPSCHED_GUARD"
local Lvar2 = "ASCRJ_ENG_HPSCHED_ANIM"
local Lvar3 = "ASCRJ_ENG_HPSCHED"
local Lvar4 = "ASCRJ_ENG_HPSCHED_ON"
    if ipc.readLvar(Lvar4) ~= 0 then
        ipc.writeLvar(Lvar1, 1)
        ipc.sleep(30)
        ipc.writeLvar(Lvar3, 0)
        ipc.sleep(100)
        ipc.writeLvar(Lvar2, 0)
        ipc.sleep(50)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('HPSH', 'off', 'HIGH PWR', 'sched off')
end

function ASCRJ_ENG_HPSCHED_toggle()
local Lvar4 = "ASCRJ_ENG_HPSCHED_ON"
    if ipc.readLvar(Lvar4) ~= 1 then
       ASCRJ_ENG_HPSCHED_on()
    else
       ASCRJ_ENG_HPSCHED_off()
    end
end

-- $$ Ground Proximity Override

function ASCRJ_GPWS_TERR_on ()
local Lvar1 = "ASCRJ_GPWS_TERR_GUARD"
local Lvar2 = "ASCRJ_GPWS_TERR_ANIM"
local Lvar3 = "ASCRJ_GPWS_TERR"
    if ipc.readLvar(Lvar3) ~= 1 then
        ipc.writeLvar(Lvar1, 1)
        ipc.sleep(30)
        ipc.writeLvar(Lvar3, 1)
        ipc.sleep(100)
        ipc.writeLvar(Lvar2, 0)
        ipc.sleep(50)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('TERR', 'on', 'GPWS TERR', 'override')
end

function ASCRJ_GPWS_TERR_off ()
local Lvar1 = "ASCRJ_GPWS_TERR_GUARD"
local Lvar2 = "ASCRJ_GPWS_TERR_ANIM"
local Lvar3 = "ASCRJ_GPWS_TERR"
    if ipc.readLvar(Lvar3) ~= 0 then
        ipc.writeLvar(Lvar1, 1)
        ipc.sleep(30)
        ipc.writeLvar(Lvar3, 0)
        ipc.sleep(100)
        ipc.writeLvar(Lvar2, 0)
        ipc.sleep(50)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('TERR', 'off', 'GPWS TERR', 'off')
end

function ASCRJ_GPWS_TERR_toggle()
local Lvar4 = "ASCRJ_GPWS_TERR"
    if ipc.readLvar(Lvar4) ~= 1 then
       ASCRJ_GPWS_TERR_on()
    else
       ASCRJ_GPWS_TERR_off()
    end
end

function ASCRJ_GPWS_FLAP_on ()
local Lvar1 = "ASCRJ_GPWS_FLAP_GUARD"
local Lvar2 = "ASCRJ_GPWS_FLAP_ANIM"
local Lvar3 = "ASCRJ_GPWS_FLAP"
    if ipc.readLvar(Lvar3) ~= 1 then
        ipc.writeLvar(Lvar1, 1)
        ipc.sleep(30)
        ipc.writeLvar(Lvar3, 1)
        ipc.sleep(100)
        ipc.writeLvar(Lvar2, 0)
        ipc.sleep(50)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('FLAP', 'on', 'GPWS FLAP', 'override')
end

function ASCRJ_GPWS_FLAP_off ()
local Lvar1 = "ASCRJ_GPWS_FLAP_GUARD"
local Lvar2 = "ASCRJ_GPWS_FLAP_ANIM"
local Lvar3 = "ASCRJ_GPWS_FLAP"
    if ipc.readLvar(Lvar3) ~= 0 then
        ipc.writeLvar(Lvar1, 1)
        ipc.sleep(30)
        ipc.writeLvar(Lvar3, 0)
        ipc.sleep(100)
        ipc.writeLvar(Lvar2, 0)
        ipc.sleep(50)
        ipc.writeLvar(Lvar1, 0)
    end
    DspShow('FLAP', 'off', 'GPWS FLAP', 'off')
end

function ASCRJ_GPWS_FLAP_toggle()
local Lvar4 = "ASCRJ_GPWS_FLAP"
    if ipc.readLvar(Lvar4) ~= 1 then
       ASCRJ_GPWS_FLAP_on()
    else
       ASCRJ_GPWS_FLAP_off()
    end
end

-- $$ Lamp Test

function ASCRJ_ENG_LAMPTEST_show()
local Lvar = "ASCRJ_ENG_LAMPTEST"
local Lval = ipc.readLvar(Lvar)
    if Lval == 0 then txt = '1'
    elseif Lval == 1 then txt = 'off'
    else txt = '2'
    end
    DspShow("LAMP", txt, "LAMP TEST", txt)
end

function ASCRJ_ENG_LAMPTEST_off()
local Lvar = "ASCRJ_ENG_LAMPTEST"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    ASCRJ_ENG_LAMPTEST_show()
end

function ASCRJ_ENG_LAMPTEST_one()
local Lvar = "ASCRJ_ENG_LAMPTEST"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    ASCRJ_ENG_LAMPTEST_show()
end

function ASCRJ_ENG_LAMPTEST_two()
local Lvar = "ASCRJ_ENG_LAMPTEST"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 2 then
        ipc.writeLvar(Lvar, 2)
    end
    ASCRJ_ENG_LAMPTEST_show()
end

function ASCRJ_ENG_LAMPTEST_inc()
local Lvar = "ASCRJ_ENG_LAMPTEST"
local Lval = ipc.readLvar(Lvar)
    if Lval < 2 then
        ipc.writeLvar(Lvar, Lval + 1)
    end
    ASCRJ_ENG_LAMPTEST_show()
end

function ASCRJ_ENG_LAMPTEST_dec()
local Lvar = "ASCRJ_ENG_LAMPTEST"
local Lval = ipc.readLvar(Lvar)
    if Lval > 0 then
        ipc.writeLvar(Lvar, Lval - 1)
    end
    ASCRJ_ENG_LAMPTEST_show()
end

function ASCRJ_ENG_LAMPTEST_cycle()
local Lvar = "ASCRJ_ENG_LAMPTEST"
local Lval = ipc.readLvar(Lvar)
    if Lval < 2 then
        ASCRJ_ENG_LAMPTEST_inc()
    else
        ASCRJ_ENG_LAMPTEST_one()
    end
end

-- $$ Eng Indicator Lights

function ASCRJ_ENG_INDLTS_show()
local Lvar = "ASCRJ_ENG_INDLTS"
local Lval = ipc.readLvar(Lvar)
    if Lval == 0 then txt = 'brt'
    elseif Lval == 1 then txt = 'dim'
    end
    DspShow("IndL", txt, "IND LTS", txt)
end

function ASCRJ_ENG_INDLTS_dim()
local Lvar = "ASCRJ_ENG_INDLTS"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    ASCRJ_ENG_INDLTS_show()
end

function ASCRJ_ENG_INDLTS_brt()
local Lvar = "ASCRJ_ENG_INDLTS"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    ASCRJ_ENG_INDLTS_show()
end

function ASCRJ_ENG_INDLTS_toggle()
local Lvar = "ASCRJ_ENG_INDLTS"
local Lval = ipc.readLvar(Lvar)
    if Lval ~= 1 then
        ASCRJ_ENG_INDLTS_dim()
    else
        ASCRJ_ENG_INDLTS_brt()
    end
end

-- $$ Mech Call Button

function ASCRJ_GPWS_MECH_BTN_press ()
local Lvar1 = "ASCRJ_GPWS_MECH_BTN"
local Lvar2 = "ASCRJ_GPWS_MECH"
local Lvar3 = "ASCRJ_GPWS_MECH_CALL"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 0 then
        DspShow('MECH', 'off')
    else
        DspShow('MECH', 'call')
    end
end


-- ## MID Pedestal ############

-- $$ Throttles

function ASCRJ_TQ_CUTOFF_1_idle ()
     ipc.writeLvar("ASCRJ_TQ_CUTOFF_1", 1)
     ipc.writeLvar("ASCRJ_TQ_CUTOFF_1", 0)
     ipc.sleep(50)
     ipc.writeLvar("ASCRJ_TQ_THROTTLE_1_POS", 400)
     DspShow ("TQ1", "idle")
end

function ASCRJ_TQ_CUTOFF_1_cutoff ()
     ipc.writeLvar("ASCRJ_TQ_CUTOFF_1", 1)
     ipc.writeLvar("ASCRJ_TQ_CUTOFF_1", 0)
     ipc.sleep(50)
     ipc.writeLvar("ASCRJ_TQ_THROTTLE_1_POS", 500)
     DspShow ("TQ1", "off")
end

function ASCRJ_TQ_CUTOFF_1_toggle ()
	if ipc.readLvar("ASCRJ_TQ_THROTTLE_1_POS") > 395 and
        ipc.readLvar("ASCRJ_TQ_THROTTLE_1_POS") <500 then

        ASCRJ_TQ_CUTOFF_1_cutoff ()
	else
       ASCRJ_TQ_CUTOFF_1_idle ()
	end
end

function ASCRJ_TQ_CUTOFF_2_idle ()
     ipc.writeLvar("ASCRJ_TQ_CUTOFF_2", 1)
     ipc.writeLvar("ASCRJ_TQ_CUTOFF_2", 0)
     ipc.sleep(50)
     ipc.writeLvar("ASCRJ_TQ_THROTTLE_2_POS", 400)
     DspShow ("TQ2", "idle")
end

function ASCRJ_TQ_CUTOFF_2_cutoff ()
     ipc.writeLvar("ASCRJ_TQ_CUTOFF_2", 1)
     ipc.writeLvar("ASCRJ_TQ_CUTOFF_2", 0)
     ipc.sleep(50)
     ipc.writeLvar("ASCRJ_TQ_THROTTLE_2_POS", 500)
     DspShow ("TQ2", "off")
end

function ASCRJ_TQ_CUTOFF_2_toggle ()
	if ipc.readLvar("ASCRJ_TQ_THROTTLE_2_POS") > 395 and
        ipc.readLvar("ASCRJ_TQ_THROTTLE_2_POS") <500 then

        ASCRJ_TQ_CUTOFF_2_cutoff ()
	else
       ASCRJ_TQ_CUTOFF_2_idle ()
	end
end

function ASCRJ_TQ_CUTOFF_both_idle ()
    ASCRJ_TQ_CUTOFF_1_idle ()
    ASCRJ_TQ_CUTOFF_2_idle ()
end

function ASCRJ_TQ_CUTOFF_both_cutoff ()
    ASCRJ_TQ_CUTOFF_1_cutoff ()
    ASCRJ_TQ_CUTOFF_2_cutoff ()
end

function ASCRJ_TQ_CUTOFF_both_toggle ()
    ASCRJ_TQ_CUTOFF_1_toggle ()
    ASCRJ_TQ_CUTOFF_2_toggle ()
end

-- $$ TOGA

function ASCRJ_TQ_TOGA_1_press ()
local Lvar1 = "ASCRJ_TQ_TOGA_1_BTN"
local Lvar2 = "ASCRJ_TQ_TOGA_1"
local state = ipc.readLvar(Lvar1)
    if state == 0 then
        ipc.writeLvar(Lvar1, 1)
        ipc.writeLvar(Lvar2, 1)
    end
    _sleep(200)
    ipc.writeLvar(Lvar1, 0)
    DspShow("TOGA", "push")
    ipc.sleep(20)
end

function ASCRJ_TQ_TOGA_1_on ()
local Lvar1 = "ASCRJ_TQ_TOGA_1_BTN"
local Lvar2 = "ASCRJ_TQ_TOGA_1"
local state = ipc.readLvar(Lvar1)
    if state == 0 then
        ipc.writeLvar(Lvar1, 1)
        ipc.writeLvar(Lvar2, 1)
    end
    DspShow("TOGA", "on")
    ipc.sleep(20)
end

function ASCRJ_TQ_TOGA_1_off ()
local Lvar1 = "ASCRJ_TQ_TOGA_1_BTN"
local Lvar2 = "ASCRJ_TQ_TOGA_1"
local state = ipc.readLvar(Lvar1)
    if state == 1 then
        ipc.writeLvar(Lvar1, 0)
        ipc.writeLvar(Lvar2, 0)
    end
    DspShow("TOGA", "off")
    ipc.sleep(20)
end

function ASCRJ_TQ_TOGA_1_toggle ()
local Lvar = "ASCRJ_TQ_TOGA_1_BTN"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_TQ_TOGA_1_on ()
    else
        ASCRJ_TQ_TOGA_1_off ()
    end
end

-- ## Thrust reverser

-- $$ Thrust Reverse Arm

function ASCRJ_TQ_REV1_MODE_on ()
local Lvar = "ASCRJ_TQ_REV1_MODE"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("Rev1", "on")
    ipc.sleep(20)
end

function ASCRJ_TQ_REV1_MODE_off ()
local Lvar = "ASCRJ_TQ_REV1_MODE"
local state = ipc.readLvar(Lvar)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("Rev1", "off")
    ipc.sleep(20)
end

function ASCRJ_TQ_REV1_MODE_toggle ()
local Lvar = "ASCRJ_TQ_REV1_MODE"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_TQ_REV1_MODE_on ()
    else
        ASCRJ_TQ_REV1_MODE_off ()
    end
end

function ASCRJ_TQ_REV2_MODE_on ()
local Lvar = "ASCRJ_TQ_REV2_MODE"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("Rev2", "on")
    ipc.sleep(20)
end

function ASCRJ_TQ_REV2_MODE_off ()
local Lvar = "ASCRJ_TQ_REV2_MODE"
local state = ipc.readLvar(Lvar)
    if state == 1 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("Rev2", "off")
    ipc.sleep(20)
end

function ASCRJ_TQ_REV2_MODE_toggle ()
local Lvar = "ASCRJ_TQ_REV2_MODE"
local state = ipc.readLvar(Lvar)
    if state == 0 then
        ASCRJ_TQ_REV2_MODE_on ()
    else
        ASCRJ_TQ_REV2_MODE_off ()
    end
end

function ASCRJ_TQ_REV_BOTH_MODE_on ()
    ASCRJ_TQ_REV1_MODE_on()
    ASCRJ_TQ_REV2_MODE_on()
end

function ASCRJ_TQ_REV_BOTH_MODE_off ()
    ASCRJ_TQ_REV1_MODE_off()
    ASCRJ_TQ_REV2_MODE_off()
end

function ASCRJ_TQ_REV_BOTH_MODE_toggle ()
    ASCRJ_TQ_REV1_MODE_toggle()
    ASCRJ_TQ_REV2_MODE_toggle()
end

-- $$ Spoilers

function ASCRJ_TQ_SPLR_MODE_man ()
local Lvar = "ASCRJ_TQ_SPLR_MODE"
local state = ipc.readLvar(Lvar)
    if state ~= 2 then
        ipc.writeLvar(Lvar, 2)
    end
    DspShow("SPLR", "man")
    ipc.sleep(20)
end

function ASCRJ_TQ_SPLR_MODE_auto ()
local Lvar = "ASCRJ_TQ_SPLR_MODE"
local state = ipc.readLvar(Lvar)
    if state ~= 1 then
        ipc.writeLvar(Lvar, 1)
    end
    DspShow("SPLR", "auto")
    ipc.sleep(20)
end

function ASCRJ_TQ_SPLR_MODE_disarm ()
local Lvar = "ASCRJ_TQ_SPLR_MODE"
local state = ipc.readLvar(Lvar)
    if state ~= 0 then
        ipc.writeLvar(Lvar, 0)
    end
    DspShow("SPLR", "disa")
    ipc.sleep(20)
end

function ASCRJ_TQ_SPLR_MODE_inc ()
local Lvar = "ASCRJ_TQ_SPLR_MODE"
local state = ipc.readLvar(Lvar)
    if state < 2 then
        ipc.writeLvar(Lvar, state + 1)
    end
    DspShow("SPLR", "inc")
    ipc.sleep(20)
end

function ASCRJ_TQ_SPLR_MODE_dec ()
local Lvar = "ASCRJ_TQ_SPLR_MODE"
local state = ipc.readLvar(Lvar)
    if state > 0 then
        ipc.writeLvar(Lvar, state - 1)
    end
    DspShow("SPLR", "dec")
    ipc.sleep(20)
end

-- ## AFT Pedestal ###############

-- $$ ECAM Display Modes

-- PRI
function ASCRJ_ECAM_PRI ()
    local LvarBTN = "ASCRJ_ECAM_PRI_BTN"
    local Lvar = "ASCRJ_ECAM_PRI"
    ipc.set("DispModeVar", 1)
    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "PRI")
end

-- STAT
function ASCRJ_ECAM_STAT ()
    local LvarBTN = "ASCRJ_ECAM_STAT_BTN"
    local Lvar = "ASCRJ_ECAM_STAT"
    ipc.set("DispModeVar", 2)
    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "STAT")
end

-- ECS
function ASCRJ_ECAM_ECS ()
    local LvarBTN = "ASCRJ_ECAM_ECS_BTN"
    local Lvar = "ASCRJ_ECAM_ECS"
    ipc.set("DispModeVar", 3)
    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "ECS")
end

-- HYD
function ASCRJ_ECAM_HYD ()
    local LvarBTN = "ASCRJ_ECAM_HYD_BTN"
    local Lvar = "ASCRJ_ECAM_HYD"
    ipc.set("DispModeVar", 4)
    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "HYD")
end

-- ELEC
function ASCRJ_ECAM_ELEC ()
    local LvarBTN = "ASCRJ_ECAM_ELEC_BTN"
    local Lvar = "ASCRJ_ECAM_ELEC"
    ipc.set("DispModeVar", 5)
    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "ELEC")
end

-- FUEL
function ASCRJ_ECAM_FUEL ()
    local LvarBTN = "ASCRJ_ECAM_FUEL_BTN"
    local Lvar = "ASCRJ_ECAM_FUEL"
    ipc.set("DispModeVar", 6)
    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "FUEL")
end

-- FCTL
function ASCRJ_ECAM_FCTL ()
    local LvarBTN = "ASCRJ_ECAM_FCTL_BTN"
    local Lvar = "ASCRJ_ECAM_FCTL"
    ipc.set("DispModeVar", 7)
    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "FCTL")
end

-- AICE
function ASCRJ_ECAM_AICE ()
    local LvarBTN = "ASCRJ_ECAM_AICE_BTN"
    local Lvar = "ASCRJ_ECAM_AICE"
    ipc.set("DispModeVar", 8)
    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "AICE")
end

-- DOORS
function ASCRJ_ECAM_DOORS ()
    local LvarBTN = "ASCRJ_ECAM_DOORS_BTN"
    local Lvar = "ASCRJ_ECAM_DOORS"
    ipc.set("DispModeVar", 9)
    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "DOORS")
end

-- $$ ECAM Display up/down

function ASCRJ_ECAM_inc ()
    DispVar = ipc.get("DispModeVar")
    if DispVar == 1 then ASCRJ_ECAM_STAT ()
    elseif DispVar == 2 then ASCRJ_ECAM_ECS ()
    elseif DispVar == 3 then ASCRJ_ECAM_HYD ()
    elseif DispVar == 4 then ASCRJ_ECAM_ELEC ()
    elseif DispVar == 5 then ASCRJ_ECAM_FUEL ()
    elseif DispVar == 6 then ASCRJ_ECAM_FCTL ()
    elseif DispVar == 7 then ASCRJ_ECAM_AICE ()
    elseif DispVar == 8 then ASCRJ_ECAM_DOORS ()
    elseif DispVar == 9 then ASCRJ_ECAM_PRI ()
    end
end

function ASCRJ_ECAM_dec ()
    DispVar = ipc.get("DispModeVar")
    if DispVar == 3 then ASCRJ_ECAM_STAT ()
    elseif DispVar == 4 then ASCRJ_ECAM_ECS ()
    elseif DispVar == 5 then ASCRJ_ECAM_HYD ()
    elseif DispVar == 6 then ASCRJ_ECAM_ELEC ()
    elseif DispVar == 7 then ASCRJ_ECAM_FUEL ()
    elseif DispVar == 8 then ASCRJ_ECAM_FCTL ()
    elseif DispVar == 9 then ASCRJ_ECAM_AICE ()
    elseif DispVar == 1 then ASCRJ_ECAM_DOORS ()
    elseif DispVar == 2 then ASCRJ_ECAM_PRI ()
    end
end

-- $$ ECAM rest

-- CAS
function ASCRJ_ECAM_CAS ()
    local LvarBTN = "ASCRJ_ECAM_CAS_BTN"
    local Lvar = "ASCRJ_ECAM_CAS"

    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "CAS")
end

-- MENU
function ASCRJ_ECAM_MENU ()
    local LvarBTN = "ASCRJ_ECAM_MENU_BTN"
    local Lvar = "ASCRJ_ECAM_MENU"

    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "MENU")
end

-- UP
function ASCRJ_ECAM_UP ()
    local LvarBTN = "ASCRJ_ECAM_UP_BTN"
    local Lvar = "ASCRJ_ECAM_UP"

    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "UP")
end

-- DOWN
function ASCRJ_ECAM_DOWN ()
    local LvarBTN = "ASCRJ_ECAM_DOWN_BTN"
    local Lvar = "ASCRJ_ECAM_DOWN"

    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "DOWN")
end


-- STEP
function ASCRJ_ECAM_STEP ()
    local LvarBTN = "ASCRJ_ECAM_STEP_BTN"
    local Lvar = "ASCRJ_ECAM_STEP"

    ipc.writeLvar(LvarBTN, 1)
    ipc.writeLvar(Lvar, 1)
    ipc.sleep(100)
    ipc.writeLvar(LvarBTN, 0)
    DspShow ("ECAM", "STEP")
end

-- $$ Yaw Damper

function ASCRJ_YD_DISC_press ()
local Lvar1 = "ASCRJ_YD_DISC_BTN"
local Lvar2 = "ASCRJ_YD_DISC"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('YAWD', 'disc', 'YAW DAMP', 'disconnect')
end

function ASCRJ_YD1_press ()
local Lvar1 = "ASCRJ_YD1_BTN"
local Lvar2 = "ASCRJ_YD1"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('YD 1', 'sel', 'YAW DAMP', 'Select 1')
end

function ASCRJ_YD2_press ()
local Lvar1 = "ASCRJ_YD2_BTN"
local Lvar2 = "ASCRJ_YD2"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    DspShow('YD 2', 'sel', 'YAW DAMP', 'Select 2')
end

-- $$ Cabin Call Buttons

function ASCRJ_CALLS_PA_press ()
local Lvar1 = "ASCRJ_CALLS_PA_BTN"
local Lvar2 = "ASCRJ_CALLS_PA"
local Lvar3 = "ASCRJ_CALLS_PA_ON"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 0 then
        DspShow('PA', 'off')
    else
        DspShow('P', 'call')
    end
end

function ASCRJ_CALLS_CHIME_press ()
local Lvar1 = "ASCRJ_CALLS_CHIME_BTN"
local Lvar2 = "ASCRJ_CALLS_CHIME"
local Lvar3 = "ASCRJ_CALLS_CHIME_ON"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 0 then
        DspShow('CHIM', 'off')
    else
        DspShow('CHIM', 'call')
    end
end

function ASCRJ_CALLS_CALL_press ()
local Lvar1 = "ASCRJ_CALLS_CALL_BTN"
local Lvar2 = "ASCRJ_CALLS_CALL"
local Lvar3 = "ASCRJ_CALLS_CALL_ON"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 0 then
        DspShow('CALL', 'off')
    else
        DspShow('CALL', 'call')
    end
end

function ASCRJ_CALLS_EMER_press ()
local Lvar1 = "ASCRJ_CALLS_EMER_BTN"
local Lvar2 = "ASCRJ_CALLS_EMER"
local Lvar3 = "ASCRJ_CALLS_EMER_ON"
    ipc.writeLvar(Lvar1, 1)
    ipc.writeLvar(Lvar2, 1)
    ipc.sleep(70)
    ipc.writeLvar(Lvar1, 0)
    ipc.sleep(20)
    if ipc.readLvar(Lvar3) == 0 then
        DspShow('EMER', 'off')
    else
        DspShow('EMER', 'call')
    end
end

-- $$ Parking Brake

function ASCRJ_ParkBrake_on ()
local Lvar = "ASCRJ_PARK_BRAKE"
    ipc.writeLvar(Lvar, 1)
    DspShow ("PARK", "on")
end

function ASCRJ_ParkBrake_off ()
local Lvar = "ASCRJ_PARK_BRAKE"
    ipc.writeLvar(Lvar, 0)
    DspShow ("PARK", "off")
end

function ASCRJ_ParkBrake_toggle ()
local Lvar = "ASCRJ_PARK_BRAKE"
    if ipc.readLvar(Lvar) == 0 then
        ASCRJ_ParkBrake_on()
    else
        ASCRJ_ParkBrake_off()
    end
end
