require("ipc")
require("event")
require("com")
function require () a = a end
dofile("C:\\Users\\Ravi\\Documents\\Prepar3D v5 Add-ons\\FSUIPC6\\linda\\system\\common.lua")
--  Aircraft: PMDG 747 V3
--  Version: 1.5
--  Date: Sept 2018
--  Author: Günter Steiner

-- ## System functions ##


----------------------------------------------------------------
----------------------------------------------------------------
PMDGBaseVariable = 69632
----------------------------------------------------------------
----------------------------------------------------------------






function TimeAccel_show ()

    TAccVar = ipc.readUW("0C1A")
    if TAccVar == 256 then TAccTxt = "norm"
    elseif TAccVar == 528 then TAccTxt = "2x"
    elseif TAccVar == 1024 then TAccTxt = "4x"
    elseif TAccVar == 2048 then TAccTxt = "8x"
    elseif TAccVar == 4096 then TAccTxt = "16x"
    end
    DspShow ("TAcc", TAccTxt)
end

function InitVars ()

    ipc.set("VSCHKL", 0) -- set VS CHKL switch to VS

    AutoDisplay = false
    -- uncomment to disable display
    -- AutopilotDisplayBlocked ()


     ipc.set("DispModeVar", 1) -- set Displays lower DU
     --DSP_ENG ()
     ipc.set("ChkListVar", 0)

    -- Engine selector init
    ipc.set("QEngSel", 0)

    -- floodlight mid setting
    floodmidvar = 85


    --- CDU Start Variable numbers (do not edit)
    CDULstartVar = 810

    CDURstartVar = 880
    EFBstartVar = 1700
    --CDUCstartVar = 653

    LongTxt1 = " "
    LongTxt2 = " "



end 


function GroundPower_show ()
    TPUS = ipc.readLvar("7X7X_TPU_S")
    TPUD = ipc.readLvar("7X7X_TPU_D")
    GPUS = ipc.readLvar("7X7X_GPU_S")
    GPUD = ipc.readLvar("7X7X_GPU_D")
    QGP = TPUS + TPUD + GPUS + GPUD

    if QGP > 0 then LongTxt1 = "PwrAvail" end
end





function PMDG_747_ALT_show ()
    Q_alt = (ipc.readLvar("PMDG_747_ALTwindow"))
    if Q_alt == nil then
        Q_alt = 10000
    else
        Q_alt = Q_alt/100
    end
    DspALT(Q_alt)
end

function PMDG_747_SPD_show ()
    Q_spd = ipc.readLvar("PMDG_747_SPDwindow")
    if Q_spd == nil then
        Q_spd = 200
    end
    if Q_spd >= 0 then
        DspSPD(Q_spd)
    else
        DspSPDs('   ')   -- blank spd window
    end
end



function PMDG_747_HDG_show ()
    Q_hdg = (ipc.readLvar("PMDG_747_HDGwindow"))
    if Q_hdg == nil then
        Q_hdg = 0
    else
        Q_hdg = Q_hdg
    end
    DspHDG(Q_hdg)
end

function PMDG_747_VS_show ()
    local VSvar
    ipc.sleep(10)
    VSVar = ipc.readUW(0x65A2)

    if VSVar >= 0 and VSVar < 10000 then VSDisp = VSVar
    elseif VSVar > 10000 then VSDisp = VSVar-65536
    end

   i = VSDisp
		if i > 0 then
			line = string.format("+%004d", i)

		elseif i == 0 then
            line = string.format(" 0000")

		elseif i < 0 then
			line = string.format("-%004d", i*(-1))
		end

        com.write(dev, "VVS" .. line, 8)
end





function AP_Modes_Disp ()

        -- FD status
        if ipc.readLvar("switch_550_74X") == 0 then
        DspFD(1)
        else
        DspFD(0)
        end

        -- AT status
        if ipc.readLvar("switch_551_74X") == 0 then
        DspAT(1)
        else
        DspAT(0)
        end



        QDispSPD = ipc.readUB(0x65C3)
        QDispFLCH = ipc.readUB(0x65C6)
        QDispLNAV = ipc.readUB(0x65C4)
        QDispVNAV = ipc.readUB(0x65C5)
        QDispTHR = ipc.readUB(0x65C2)
        QDispHDG = ipc.readUB(0x65C7)
        QDispVS = ipc.readUB(0x65C8)
        QDispALT = ipc.readUB(0x65C9)



        if QDispSPD == 1 and QDispFLCH == 0 and QDispTHR == 0 then
            DspSPD_AP_on ()
            --DspSPD_FLCH_off ()
            --DspSPD_N1_off ()
        elseif QDispSPD == 0 and QDispFLCH == 1 and QDispTHR == 0 then
            DspSPD_FLCH_on ()
            --DspSPD_AP_off ()
            --DspSPD_N1_off ()
        elseif QDispSPD == 0 and QDispFLCH == 0 and QDispTHR == 1 then
            DspSPD_N1_on ()
            --DspSPD_AP_off ()
            --DspSPD_FLCH_off ()
        elseif QDispSPD == 0 and QDispFLCH == 0 and QDispTHR == 0 then

            DspSPD_FLCH_off ()
        end

        --if QDispTHR == 1 then DspSPD_N1_on () elseif QDispTHR == 0 then DspSPD_N1_off () end

        if QDispLNAV == 1 then DspLNAV_on () elseif QDispLNAV == 0 then DspLNAV_off () end
        if QDispVNAV == 1 then DspVNAV_on () elseif QDispVNAV == 0 then DspVNAV_off () end
        if QDispHDG == 1 then DspHDG_AP_on () elseif QDispHDG == 0 then DspHDG_AP_off () end
        if QDispVS == 1 then DspVVS_AP_on () elseif QDispVS == 0 then DspVVS_AP_off () end
        if QDispALT == 1 then DspALT_AP_on () elseif QDispALT == 0 then DspALT_AP_off () end



end





function PMDG_Autobrake_show ()
    -- ABtxt
    ipc.sleep(50)
    ABvar = ipc.readUB(0x6c27)
    if ABvar == 0 then ABtxt = "RTO"
    elseif ABvar == 1 then ABtxt = "off"
    elseif ABvar == 2 then ABtxt = "DAr"
    elseif ABvar == 3 then ABtxt = "1"
    elseif ABvar == 4 then ABtxt = "2"
    elseif ABvar == 5 then ABtxt = "3"
    elseif ABvar == 6 then ABtxt = "4"
    elseif ABvar == 7 then ABtxt = "MAX"
    end
    DspShow ("ABrk", ABtxt)
end

function PMDG_Autobrake_timer ()
    -- ABtxt
    ipc.sleep(10)
    ABvar = ipc.readUB(0x6c27)
    if ABvar == 0 then ABtxt = "RTO"
    elseif ABvar == 1 then ABtxt = "off"
    elseif ABvar == 2 then ABtxt = "DAr"
    elseif ABvar == 3 then ABtxt = "1"
    elseif ABvar == 4 then ABtxt = "2"
    elseif ABvar == 5 then ABtxt = "3"
    elseif ABvar == 6 then ABtxt = "4"
    elseif ABvar == 7 then ABtxt = "MAX"
    end

end


function QFlaps_Lever_show ()
    --QFlapTxt
    QFlapVar = ipc.readUB("6611")
    if QFlapVar == 0 then QFlapTxt = "up" QFlapCPU = 0
    elseif QFlapVar == 1 then QFlapTxt = "01" QFlapCPU = 1
    elseif QFlapVar == 2 then QFlapTxt = "05" QFlapCPU = 5
    elseif QFlapVar == 3 then QFlapTxt = "10" QFlapCPU = 10
    elseif QFlapVar == 4 then QFlapTxt = "20" QFlapCPU = 20
    elseif QFlapVar == 5 then QFlapTxt = "25" QFlapCPU = 25
    elseif QFlapVar == 6 then QFlapTxt = "30" QFlapCPU = 30

    end

end




function ExtPwr_Show ()

    -- ExtPwr1Txt
    -- ExtPwr2Txt

    ExtPwrC1 = ipc.readUB(0x6467)
    ExtPwrC2 = ipc.readUB(0x6468)
    ExtPwrOn1 = ipc.readUB(0x6465)
    ExtPwrOn2 = ipc.readUB(0x6466)

    if ExtPwrC1 == 1 then ExtPwr1Txt = "a"
    elseif ExtPwrOn1 == 1 then ExtPwr1Txt = "^"
    else ExtPwr1Txt = "-" end

    if ExtPwrC2 == 1 then ExtPwr2Txt = "a"
    elseif ExtPwrOn2 == 1 then ExtPwr2Txt = "^"
    else ExtPwr2Txt = "-" end
end



function APU_Show ()
    --APU1Txt
    --APU2Txt

    -- APU state?
    APU_online = ipc.readLvar('switch_013_74X')
        if APU_online == 0 then APU_on = 0 else APU_on = 1 end
    APU1GenOn = ipc.readUB(0x6469)
    APU2GenOn = ipc.readUB(0x646A)
    APU1Av = ipc.readUB(0x646b)
    APU2Av = ipc.readUB(0x646c)

    if APU1Av == 0 and APU_on == 1 and APU1GenOn == 0 then APU1Txt = "o"
    elseif APU1Av == 1 then APU1Txt = "a"
    elseif APU1GenOn == 1 then APU1Txt = "^"
    else APU1Txt = "-" end

    if APU2Av == 0 and APU_on == 1 and APU2GenOn == 0 then APU2Txt = "o"
    elseif APU2Av == 1 then APU2Txt = "a"
    elseif APU2GenOn == 1 then APU2Txt = "^"
    else APU2Txt = "-" end
end


function AircraftModel_show ()
    --ACModtxt
    ACMod = ipc.readUB(0x6C79)
    if ACMod == 1 then ACModtxt = "-400"
    elseif ACMod == 2 then ACModtxt = "-400BCF"
    elseif ACMod == 3 then ACModtxt = "-400M"
    elseif ACMod == 4 then ACModtxt = "-400D"
    elseif ACMod == 5 then ACModtxt = "-400ER"
    elseif ACMod == 6 then ACModtxt = "-400F"
    elseif ACMod == 7 then ACModtxt = "-400ERF"
    elseif ACMod == 8 then ACModtxt = "-8I"
    elseif ACMod == 9 then ACModtxt = "-8F"
    end
    DspShow (ACMod, ACModtxt)
end


function B747_Elevator_Trim_show ()

    ElevVal = ipc.readUW(0x0BC2)
    if ElevVal >= 49000 then
    ElevVal = (ElevVal - 65487)
    end

    ElevTrimVar = (ElevVal*0.00074+3)
    DspShow("Elev", string.format("%2.1f", ElevTrimVar))

end


function Disp_744_inc ()
    DispVar = ipc.get("DispModeVar")

    if DispVar == 1 then DSP_STAT()
    elseif DispVar == 2 then DSP_ELEC()
    elseif DispVar == 3 then DSP_FUEL()
    elseif DispVar == 4 then DSP_AIR_ECS()
    elseif DispVar == 5 then DSP_HYD()
    elseif DispVar == 6 then DSP_DOOR()
    elseif DispVar == 7 then DSP_GEAR()
    elseif DispVar == 8 then DSP_ENG()
    end
end

function Disp_744_dec ()
    DispVar = ipc.get("DispModeVar")

    if DispVar == 1 then DSP_GEAR()
    elseif DispVar == 2 then DSP_ENG()
    elseif DispVar == 3 then DSP_STAT()
    elseif DispVar == 4 then DSP_ELEC()
    elseif DispVar == 5 then DSP_FUEL()
    elseif DispVar == 6 then DSP_AIR_ECS()
    elseif DispVar == 7 then DSP_HYD()
    elseif DispVar == 8 then DSP_DOOR()
    end
end


function Disp_748_inc ()
    DispVar = ipc.get("DispModeVar")

    if DispVar == 1 then DSP_STAT()
    elseif DispVar == 2 then DSP_ELEC()
    elseif DispVar == 3 then DSP_FUEL()
    elseif DispVar == 4 then DSP_AIR_ECS()
    elseif DispVar == 5 then DSP_FCTL()
    elseif DispVar == 9 then DSP_HYD()
    elseif DispVar == 6 then DSP_DOOR()
    elseif DispVar == 7 then DSP_GEAR()
    elseif DispVar == 8 then DSP_ENG()
    end
end

function Disp_748_dec ()
    DispVar = ipc.get("DispModeVar")

    if DispVar == 1 then DSP_GEAR()
    elseif DispVar == 2 then DSP_ENG()
    elseif DispVar == 3 then DSP_STAT()
    elseif DispVar == 4 then DSP_ELEC()
    elseif DispVar == 5 then DSP_FUEL()
    elseif DispVar == 9 then DSP_AIR_ECS()
    elseif DispVar == 6 then DSP_FCTL()
    elseif DispVar == 7 then DSP_HYD()
    elseif DispVar == 8 then DSP_DOOR()
    end
end


function Timer ()

GSX_door_automation ()


    AP_Modes_Disp ()

    -- Time Acceleration
    if ipc.readUW("0C1A") > 256 then TimeAccel_show () end

    PMDG_747_ALT_show ()
    PMDG_747_SPD_show ()
    PMDG_747_HDG_show ()
    PMDG_747_VS_show ()


    -- On Ground?
    OnGround = ipc.readUW("0366")

    --Engines running  CFlag
    CFlag1 = ipc.readUB(0x0894)
    CFlag2 = ipc.readUB(0x092c)
    CFlag3 = ipc.readUB(0x09c4)
    CFlag4 = ipc.readUB(0x0a5c)
    CFlag = CFlag1 + CFlag2 + CFlag3 + CFlag4

    -- Choks set?
    WheelCh = ipc.readLvar("NGXWheelChocks")

    -- Ext Pwr Connected?
    ExtPwrC1 = ipc.readUB(0x6467)
    ExtPwrC2 = ipc.readUB(0x6468)
    ExtPwrC = ExtPwrC1 + ExtPwrC2

    -- CDU  Flaps
    TOFlap = ipc.readUB(0x6C7D)
    LDFlap = ipc.readUB(0x6C81)

    -- CDU Data
    LDVRef = ipc.readUB(0x6C82)
    DtoTOD = math.floor(ipc.readFLT(0x6C8C))
    DtoDest = math.floor(ipc.readFLT(0x6C90))


    -- SpdBrake state
    SpdBrVar = ipc.readUB("6610")




    if OnGround == 1 and CFlag == 0 then   --engine off , on ground
        APU_Show ()
        ExtPwr_Show ()
            if WheelCh == 1 and APU_on == 0 or APU_on ~= 0 then  -- Ground Conn off
                LongTxt1 = "G1A  A2G"
                LongTxt2 =  ExtPwr1Txt .. " " .. APU1Txt .. "  " .. APU2Txt .. " " .. ExtPwr2Txt
            elseif WheelCh == 0 and APU_on == 0 then  -- Ground Conn off
                AircraftModel_show ()
                LongTxt1 = ACModtxt
                LongTxt2 = "Chks off"
            end

    elseif OnGround == 1 and CFlag ~= 0 then   -- engines running, on ground
        APU_Show ()
        QFlaps_Lever_show () --QFlapTxt
        PMDG_Autobrake_timer ()

        if APU_on == 0 then    --APU off
            if TOFlap ~= QFlapCPU and TOFlap ~= 0 and QFlapVar > 0 then                -- Flap and TO Flap Check, AB
                LongTxt1 = "F>"..TOFlap.." ABr"
                LongTxt2 = QFlapTxt .."   "..ABtxt
            else
                LongTxt1 = "FL ABr"
                LongTxt2 = QFlapTxt .." "..ABtxt
            end

        elseif APU_on == 1 then  -- APU on
            V2var = ipc.readUB("6C80")

            if TOFlap ~= QFlapCPU and V2var ~= 0 then               -- Flap and TO Flap Check, APU
                LongTxt1 = "F>"..TOFlap.." APU"
                LongTxt2 = QFlapTxt .."   "..APU1Txt.." "..APU2Txt
            else
                LongTxt1 = "FL APU"
                LongTxt2 = QFlapTxt .." "..APU1Txt.." "..APU2Txt
            end
        end

    elseif OnGround == 0 and CFlag ~= 0 then            --flying
            APU_Show ()
            QFlaps_Lever_show () --QFlapTxt
            PMDG_Autobrake_timer ()
            if APU_on == 0 and QFlapVar == 0 then -- APU off, Flaps up
                if DtoTOD < 30 and DtoTOD >= 5 then
                    LongTxt1 = "to T/D "
                    LongTxt2 = DtoTOD .. " NM"
                elseif DtoTOD < 5 and DtoTOD > 0 then
                    LongTxt1 = "MCP ALT!"
                    LongTxt2 = "T/D "..DtoTOD .. "NM"
                else
                    LongTxt1 = "to Dest"
                    if DtoDest == -1 then
                        LongTxt2 = "not set"
                    else
                        LongTxt2 = DtoDest .. " NM"
                    end
                end
            elseif APU_on == 0 and QFlapVar ~= 0 then -- APU off, Flaps lowered
                if QFlapCPU ~= LDFlap then
                    LongTxt1 = "FL>"..LDFlap .. " AB"
                    LongTxt2 = QFlapTxt.. "    " ..ABtxt
                elseif APU_on == 0 and QFlapVar >= 5 then -- APU off, Flaps full
                    LongTxt1 = "FL Vref"
                    LongTxt2 = QFlapTxt .." "..LDVRef
                else
                    LongTxt1 = "FL AB"
                    LongTxt2 = QFlapTxt .." "..ABtxt
                end

            elseif APU_on == 1 and QFlapVar >= 0 then -- APU on, Flaps lowered
                LongTxt1 = "FL APU"
                LongTxt2 = QFlapTxt .." "..APU1Txt.." "..APU2Txt
            elseif APU_on == 0 and QFlapVar >= 5 then -- APU off, Flaps full
                LongTxt1 = "FL Vref"
                LongTxt2 = QFlapTxt .." "..LDVRef
            end
    else
        AircraftModel_show ()
        LongTxt1 = ACModtxt
        LongTxt2 = " "
    end



    if _MCP2() then

    FLIGHT_INFO1 = LongTxt1
    FLIGHT_INFO2 = LongTxt2

    else

    FLIGHT_INFO1 = ShortTxt1
    FLIGHT_INFO2 = ShortTxt2

    end

end

-- ## AP TO disconnect ###############
function EVT_YOKE_L_AP_DISC_SWITCH ()
    ipc.control(PMDGBaseVariable + 1540, 1)
    DspShow ("AP", "disc")
end

function EVT_YOKE_R_AP_DISC_SWITCH ()
    ipc.control(PMDGBaseVariable + 1541, 1)
    DspShow ("AP", "disc")
end

function TOGA1_SWITCH ()
    ipc.control(PMDGBaseVariable + 962, 1)
    DspShow ("TO", "GA")
end

function AT1_DISENGAGE_SWITCH ()
    ipc.control(PMDGBaseVariable + 964, 1)
    DspShow ("AT1", "disc")
end

-- ## Master Warning/Caution ###############

function WARN_Reset ()
    ipc.control(PMDGBaseVariable + 509, 1)
    DspShow ("WARN", "rset")
end


-- ## Glareshield - MCP ###############

function MCP_FD_SWITCH_L_on ()
    ipc.control(PMDGBaseVariable + 550, 0)
    DspShow ("FD", "on")
end

function MCP_FD_SWITCH_L_off ()
    ipc.control(PMDGBaseVariable + 550, 1)
    DspShow ("FD", "off")
end

function MCP_FD_SWITCH_L_toggle ()
	if _tl("switch_550_74X", 100) then
        MCP_FD_SWITCH_L_on ()
	else
        MCP_FD_SWITCH_L_off ()
	end
end



function EVT_MCP_AT_ARM_SWITCH_on ()
    ipc.control(PMDGBaseVariable + 551, 0)
    DspShow ("ATHR", "on")
end

function EVT_MCP_AT_ARM_SWITCH_off ()
    ipc.control(PMDGBaseVariable + 551, 1)
    DspShow ("ATHR", "off")
end

function EVT_MCP_AT_ARM_SWITCH_toggle ()
	if _tl("switch_551_74X", 100) then
        EVT_MCP_AT_ARM_SWITCH_on ()
	else
        EVT_MCP_AT_ARM_SWITCH_off ()
	end
end


function MCP_THR_SWITCH ()
    ipc.control(PMDGBaseVariable + 552, 1)
    DspShow ("THR", " ")
end

function MCP_SPD_SWITCH ()
    ipc.control(PMDGBaseVariable + 553, 1)
    DspShow ("SPD", " ")
end

function MCP_IAS_MACH_SWITCH ()
    ipc.control(PMDGBaseVariable + 555, 1)
    DspShow ("IAS", "MACH")
end

function MCP_LNAV_SWITCH ()
    ipc.control(PMDGBaseVariable + 559, 1)
    DspShow ("LNAV", " ")
end

function MCP_VNAV_SWITCH ()
    ipc.control(PMDGBaseVariable + 560, 1)
    DspShow ("VNAV", " ")
end

function MCP_LVL_CHG_SWITCH ()
    ipc.control(PMDGBaseVariable + 561, 1)
    DspShow ("FLCH", " ")
end


function MCP_HDG_HOLD_SWITCH ()
    ipc.control(PMDGBaseVariable + 568, 1)
    DspShow ("HDG", "hold")
end

function MCP_VS_SWITCH ()
    ipc.control(PMDGBaseVariable + 575, 1)
    DspShow ("VS", " ")
end

function MCP_ALT_HOLD_SWITCH ()
    ipc.control(PMDGBaseVariable + 582, 1)
    DspShow ("ALT", "hold")
end

function MCP_APP_SWITCH ()
    ipc.control(PMDGBaseVariable + 583, 1)
    DspShow ("APP", " ")
end

function MCP_LOC_SWITCH ()
    ipc.control(PMDGBaseVariable + 584, 1)
    DspShow ("LOC", " ")
end

function MCP_AP_L_SWITCH ()
    ipc.control(PMDGBaseVariable + 585, 1)
    DspShow ("AP", "L")
end

function MCP_AP_C_SWITCH ()
    ipc.control(PMDGBaseVariable + 586, 1)
    DspShow ("AP", "C")
end

function MCP_AP_R_SWITCH ()
    ipc.control(PMDGBaseVariable + 587, 1)
    DspShow ("AP", "R")
end

function MCP_AP_All_SWITCH ()
    MCP_AP_L_SWITCH ()
    _sleep(100,200)
    MCP_AP_C_SWITCH ()
    _sleep(100,200)
    MCP_AP_R_SWITCH ()
end


function MCP_FD_SWITCH_R_on ()
    ipc.control(PMDGBaseVariable + 589, 0)
    DspShow ("FD", "on")
end

function MCP_FD_SWITCH_R_off ()
    ipc.control(PMDGBaseVariable + 589, 1)
    DspShow ("FD", "off")
end

function MCP_FD_SWITCH_R_toggle ()
	if _tl("switch_589_74X", 100) then
        MCP_FD_SWITCH_R_on ()
	else
        MCP_FD_SWITCH_R_off ()
	end
end

function MCP_FD_SWITCH_BOTH_on ()
    MCP_FD_SWITCH_L_on ()
    _sleep(100,200)
    MCP_FD_SWITCH_R_on ()
end

function MCP_FD_SWITCH_BOTH_off ()
    MCP_FD_SWITCH_L_off ()
    _sleep(100,200)
    MCP_FD_SWITCH_R_off ()
end

function MCP_FD_SWITCH_BOTH_toggle ()
    MCP_FD_SWITCH_L_toggle ()
    _sleep(100,200)
    MCP_FD_SWITCH_R_toggle ()
end


function MCP_DISENGAGE_BAR_on ()
    ipc.control(PMDGBaseVariable + 588, 0)
    DspShow ("FD", "on")
end

function MCP_DISENGAGE_BAR_off ()
    ipc.control(PMDGBaseVariable + 588, 1)
    DspShow ("FD", "off")
end

function MCP_DISENGAGE_BAR_toggle ()
	if _tl("switch_588_74X", 100) then
        MCP_DISENGAGE_BAR_on ()
	else
        MCP_DISENGAGE_BAR_off ()
	end
end

-- ## MCP Rotaries ###############

function MCP_SPEED_SELECTOR_inc ()
    ipc.control(PMDGBaseVariable + 554, 256)
    ipc.sleep(20)
    PMDG_747_SPD_show ()
end

function MCP_SPEED_SELECTOR_incfast ()
    local i
    for i = 1, 5 do
    ipc.control(PMDGBaseVariable + 554, 256)
    end
    ipc.sleep(20)
    PMDG_747_SPD_show ()
end


function MCP_SPEED_SELECTOR_dec ()
    ipc.control(PMDGBaseVariable + 554, 128)
    ipc.sleep(20)
    PMDG_747_SPD_show ()
end

function MCP_SPEED_SELECTOR_decfast ()
    local i
    for i = 1, 5 do
    ipc.control(PMDGBaseVariable + 554, 128)
    end
    ipc.sleep(20)
    PMDG_747_SPD_show ()
end

function MCP_SPEED_PUSH_SWITCH ()
    ipc.control(PMDGBaseVariable + 10554, 1)
    DspShow ("SPD", "push")
end

--

function MCP_HDG_SELECTOR_inc ()
    ipc.control(PMDGBaseVariable + 566, 256)
    ipc.sleep(20)
    PMDG_747_HDG_show ()
end

function MCP_HDG_SELECTOR_incfast ()
    local i
    for i = 1, 10 do
    ipc.control(PMDGBaseVariable + 566, 256)
    end
    ipc.sleep(20)
    PMDG_747_HDG_show ()
end


function MCP_HDG_SELECTOR_dec ()
    ipc.control(PMDGBaseVariable + 566, 128)
    ipc.sleep(20)
    PMDG_747_HDG_show ()
end

function MCP_HDG_SELECTOR_decfast ()
    local i
    for i = 1, 10 do
    ipc.control(PMDGBaseVariable + 566, 128)
    end
    ipc.sleep(20)
    PMDG_747_HDG_show ()
end

function MCP_HEADING_PUSH_SWITCH ()
    ipc.control(PMDGBaseVariable + 10566, 1)
    DspShow ("HDG", "push")
end

--



function MCP_ALT_SELECTOR_inc ()
    ipc.control(PMDGBaseVariable + 581, 256)
    ipc.sleep(20)
    PMDG_747_ALT_show ()
end

function MCP_ALT_SELECTOR_incfast ()
    local i
    for i = 1, 10 do
    ipc.control(PMDGBaseVariable + 581, 256)
    end
    ipc.sleep(20)
    PMDG_747_ALT_show ()
end


function MCP_ALT_SELECTOR_dec ()
    ipc.control(PMDGBaseVariable + 581, 128)
    ipc.sleep(20)
    PMDG_747_ALT_show ()
end

function MCP_ALT_SELECTOR_decfast ()
    local i
    for i = 1, 10 do
    ipc.control(PMDGBaseVariable + 581, 128)
    end
    ipc.sleep(20)
    PMDG_747_ALT_show ()
end

function MCP_ALT_PUSH_SWITCH ()
    ipc.control(PMDGBaseVariable + 10581, 1)
    DspShow ("ALT", "push")
end

--

function MCP_VS_SELECTOR_inc ()
    ipc.control(PMDGBaseVariable + 574, 128)
    ipc.sleep(20)
    PMDG_747_VS_show ()
end


function MCP_VS_SELECTOR_dec ()
    ipc.control(PMDGBaseVariable + 574, 256)
    ipc.sleep(20)
    PMDG_747_VS_show ()
end



-- ## EFIS Captain ###############

function EFIS_CPT_MINIMUMS_RST ()
    ipc.control(PMDGBaseVariable + 520,1)
    DspShow ("MIN", "RST")
end

function EFIS_CPT_MINIMUMS_inc ()
    ipc.control(PMDGBaseVariable + 521,256)
    DspShow ("MIN", "inc")
end


function EFIS_CPT_MINIMUMS_dec ()
    ipc.control(PMDGBaseVariable + 521,128)
    DspShow ("MIN", "dec")
end


function EFIS_CPT_RADIO_BARO_baro ()
    ipc.control(PMDGBaseVariable + 522,1)
    DspShow ("MIN", "baro")
end

function EFIS_CPT_RADIO_BARO_radio ()
    ipc.control(PMDGBaseVariable + 522,0)
    DspShow ("MIN", "rdio","MIN", "radio")
end

function EFIS_CPT_RADIO_BARO_toggle ()
	if _tl("switch_522_74X", 0) then
       EFIS_CPT_RADIO_BARO_baro ()
	else
       EFIS_CPT_RADIO_BARO_radio ()
	end
end

function EFIS_CPT_VOR_ADFVOR_L_vor ()
    ipc.control(PMDGBaseVariable + 523,0)
    DspShow ("VOR", "L")
end

function EFIS_CPT_VOR_ADFVOR_L_off ()
    ipc.control(PMDGBaseVariable + 523,1)
    DspShow ("off", "L")
end

function EFIS_CPT_VOR_ADFVOR_L_adf ()
    ipc.control(PMDGBaseVariable + 523,2)
    DspShow ("ADF", "L")
end

function EFIS_CPT_VOR_ADFVOR_L_inc ()
    VORADFL = ipc.readLvar("switch_523_74X")
    if VORADFL == 100 then
        EFIS_CPT_VOR_ADFVOR_L_off ()
    elseif VORADFL == 50 then
        EFIS_CPT_VOR_ADFVOR_L_vor ()
    end
end

function EFIS_CPT_VOR_ADFVOR_L_dec ()
    VORADFL = ipc.readLvar("switch_523_74X")
    if VORADFL == 0 then
        EFIS_CPT_VOR_ADFVOR_L_off ()
    elseif VORADFL == 50 then
        EFIS_CPT_VOR_ADFVOR_L_adf ()
    end
end

function EFIS_CPT_VOR_ADFVOR_L_toggle ()
    VORADFL = ipc.readLvar("switch_523_74X")
    if VORADFL == 100 then
        EFIS_CPT_VOR_ADFVOR_L_off ()
    elseif VORADFL == 50 then
        EFIS_CPT_VOR_ADFVOR_L_vor ()
    elseif VORADFL == 0 then
        EFIS_CPT_VOR_ADFVOR_L_adf ()
    end
end

---

function EFIS_CPT_VOR_ADFVOR_R_vor ()
    ipc.control(PMDGBaseVariable + 528,0)
    DspShow ("VOR", "R")
end

function EFIS_CPT_VOR_ADFVOR_R_off ()
    ipc.control(PMDGBaseVariable + 528,1)
    DspShow ("off", "R")
end

function EFIS_CPT_VOR_ADFVOR_R_adf ()
    ipc.control(PMDGBaseVariable + 528,2)
    DspShow ("ADF", "R")
end

function EFIS_CPT_VOR_ADFVOR_R_inc ()
    VORADFL = ipc.readLvar("switch_528_74X")
    if VORADFL == 100 then
        EFIS_CPT_VOR_ADFVOR_R_off ()
    elseif VORADFL == 50 then
        EFIS_CPT_VOR_ADFVOR_R_vor ()
    end
end

function EFIS_CPT_VOR_ADFVOR_R_dec ()
    VORADFL = ipc.readLvar("switch_528_74X")
    if VORADFL == 0 then
        EFIS_CPT_VOR_ADFVOR_R_off ()
    elseif VORADFL == 50 then
        EFIS_CPT_VOR_ADFVOR_R_adf ()
    end
end

function EFIS_CPT_VOR_ADFVOR_R_toggle ()
    VORADFL = ipc.readLvar("switch_528_74X")
    if VORADFL == 100 then
        EFIS_CPT_VOR_ADFVOR_R_off ()
    elseif VORADFL == 50 then
        EFIS_CPT_VOR_ADFVOR_R_vor ()
    elseif VORADFL == 0 then
        EFIS_CPT_VOR_ADFVOR_R_adf ()
    end
end

----

function EFIS_CPT_MODE_show ()
    ipc.sleep(10)
     CEfisMode = ipc.readLvar('switch_524_74X')
     if CEfisMode == 0 then CEfisModeTxt = "APP"
     elseif CEfisMode == 10 then CEfisModeTxt = "VOR"
     elseif CEfisMode == 20 then CEfisModeTxt = "MAP"
     elseif CEfisMode == 30 then CEfisModeTxt = "PLN"
     end
     DspShow ("Mode", CEfisModeTxt, "EFIS ", "MODE ".. CEfisModeTxt)
end

function EFIS_CPT_MAP_MODE_inc ()
    ipc.control(PMDGBaseVariable +524, 256)
    EFIS_CPT_MODE_show ()
end

function EFIS_CPT_MAP_MODE_dec ()
    ipc.control(PMDGBaseVariable +524, 128)
    EFIS_CPT_MODE_show ()
end

function EFIS_CPT_MODE_CTR ()
    ipc.control(PMDGBaseVariable  + 525,1)
    DspShow ("MODE", "CTR")
end

------------

function EFIS_CPT_RANGE_show ()
    ipc.sleep(10)
    acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"747-4",0,true) then

     CEfisRange = ipc.readLvar('switch_526_74X')
     if CEfisRange == 0 then CEfisRangeTxt = "5"
     elseif CEfisRange == 10 then CEfisRangeTxt = "10"
     elseif CEfisRange == 20 then CEfisRangeTxt = "20"
     elseif CEfisRange == 30 then CEfisRangeTxt = "40"
     elseif CEfisRange == 40 then CEfisRangeTxt = "80"
     elseif CEfisRange == 50 then CEfisRangeTxt = "160"
     elseif CEfisRange == 60 then CEfisRangeTxt = "320"
     elseif CEfisRange == 70 then CEfisRangeTxt = "640"
     end
     DspShow ("Rnge", CEfisRangeTxt, "EFIS RNGE", CEfisRangeTxt)

        elseif string.find(acftname,"747-8",0,true) then
    DspShow ("EFIS", "Rnge")
        end
end

function EFIS_CPT_RANGE_inc ()
    acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"747-4",0,true) then
            ipc.control(PMDGBaseVariable  + 526,256)
        elseif string.find(acftname,"747-8",0,true) then
            for i = 1,5,1 do
            ipc.control(PMDGBaseVariable  + 526,256)
            end
        end
    EFIS_CPT_RANGE_show ()
end

function EFIS_CPT_RANGE_dec ()
    acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"747-4",0,true) then
            ipc.control(PMDGBaseVariable  + 526,128)
        elseif string.find(acftname,"747-8",0,true) then
            for i = 1,5,1 do
            ipc.control(PMDGBaseVariable  + 526,128)
            end
        end
    EFIS_CPT_RANGE_show ()
end



function EFIS_CPT_RANGE_TFC ()
    ipc.control(PMDGBaseVariable  + 527,1)
    DspShow ("RNGE", "TFC")
end


function EFIS_CPT_BARO_IN_HPA_in ()
    ipc.control(PMDGBaseVariable  + 529,0)
    DspShow ("BARO", "in")
end

function EFIS_CPT_BARO_IN_HPA_hpa ()
    ipc.control(PMDGBaseVariable  + 529,1)
    DspShow ("BARO", "hpa")
end
function EFIS_CPT_BARO_IN_HPA_toggle ()
	if _tl("switch_529_74X", 100) then
       EFIS_CPT_BARO_IN_HPA_in ()
	else
       EFIS_CPT_BARO_IN_HPA_hpa ()
	end
end


function EFIS_CPT_BARO_inc ()
    ipc.control(PMDGBaseVariable  + 530,256)
    DspShow ("BARO", "inc")
end

function EFIS_CPT_BARO_dec ()
    ipc.control(PMDGBaseVariable  + 530,128)
    DspShow ("BARO", "dec")
end



function EFIS_CPT_BARO_STD ()
    ipc.control(PMDGBaseVariable  + 531,1)
    DspShow ("BARO", "STD")
end

function EFIS_CPT_MTRS ()
    ipc.control(PMDGBaseVariable  + 532,1)
    DspShow ("MTRS", " ")
end

function EFIS_CPT_FPV ()
    ipc.control(PMDGBaseVariable  + 533,1)
    DspShow ("FPV", " ")
end

-- $$ lower buttons

function EFIS_CPT_WXR ()
    ipc.control(PMDGBaseVariable  + 534,1)
    DspShow ("WXR", " ")
end

function EFIS_CPT_STA ()
    ipc.control(PMDGBaseVariable  + 535,1)
    DspShow ("STA", " ")
end

function EFIS_CPT_WPT ()
    ipc.control(PMDGBaseVariable  + 536,1)
    DspShow ("WPT", " ")
end

function EFIS_CPT_ARPT ()
    ipc.control(PMDGBaseVariable  + 537,1)
    DspShow ("ARPT", " ")
end

function EFIS_CPT_DATA ()
    ipc.control(PMDGBaseVariable  + 538,1)
    DspShow ("DATA", " ")
end

function EFIS_CPT_POS ()
    ipc.control(PMDGBaseVariable  + 539,1)
    DspShow ("POS", " ")
end

function EFIS_CPT_TERR ()
    ipc.control(PMDGBaseVariable  + 540,1)
    DspShow ("TERR", " ")
end


-- ## Glareshield - Display Select Panel ###############
function DSP_ENG ()
    ipc.control(PMDGBaseVariable  + 650,1)
    ipc.set("DispModeVar", 1)
    DspShow ("Disp", "ENG")
end


function DSP_STAT ()
    ipc.control(PMDGBaseVariable  + 651,1)
    ipc.set("DispModeVar", 2)

    DspShow ("Disp", "STAT")
end

function DSP_ELEC ()
    ipc.control(PMDGBaseVariable  + 652,1)
    ipc.set("DispModeVar", 3)
    DspShow ("Disp", "ELEC")
end

function DSP_FUEL ()
    ipc.control(PMDGBaseVariable  + 653,1)
    ipc.set("DispModeVar", 4)
    DspShow ("Disp", "FUEL")
end

function DSP_AIR_ECS ()
    ipc.control(PMDGBaseVariable  + 654,1)
    ipc.set("DispModeVar", 5)
    DspShow ("Disp", "AIR")
end

function DSP_HYD ()
    ipc.control(PMDGBaseVariable  + 655,1)
    ipc.set("DispModeVar", 6)
    DspShow ("Disp", "HYD")
end

function DSP_DOOR ()
    ipc.control(PMDGBaseVariable  + 656,1)
    ipc.set("DispModeVar", 7)
    DspShow ("Disp", "DOOR")
end

function DSP_GEAR ()
    ipc.control(PMDGBaseVariable  + 657,1)
    ipc.set("DispModeVar", 8)
    DspShow ("Disp", "GEAR")
end


function DSP_CANC ()
    ipc.control(PMDGBaseVariable  + 658,1)
    DspShow ("Disp", "CANC")
end

function DSP_RCL ()
    ipc.control(PMDGBaseVariable  + 659,1)
    DspShow ("Disp", "RCL")
end

function Disp_inc ()
        acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"747-4",0,true) then
            Disp_744_inc ()
        elseif string.find(acftname,"747-8",0,true) then
            Disp_748_inc ()
        end
end

function Disp_dec ()
        acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"747-4",0,true) then
            Disp_744_dec ()
        elseif string.find(acftname,"747-8",0,true) then
            Disp_748_dec ()
        end
end


------- $$ 747 - 800 only

function DSP_FCTL ()
    ipc.control(PMDGBaseVariable  + 663,1)
    acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"747-4",0,true) then
            DSP_STAT ()
        else
            ipc.set("DispModeVar", 9)
            DspShow ("Disp", "FCTL")
        end
end

function DSP_CHKL ()
    ipc.control(PMDGBaseVariable  + 665,1)
    ipc.set("ChkListVar", 1)
    DspShow ("Disp", "CHKL")
end

function DSP_NAV ()
    ipc.control(PMDGBaseVariable  + 667,1)
    ipc.set("DispModeVar", 11)
    DspShow ("Disp", "NAV")
end


function PMDG_Toggle_Chkl_Stat ()
     if ipc.get("ChkListVar") == 1 then
     ipc.set("ChkListVar", 0)
     DispVar = ipc.get("DispModeVar")
        if DispVar == 1 then DSP_ENG()
        elseif DispVar == 2 then DSP_STAT()
        elseif DispVar == 3 then DSP_ELEC()
        elseif DispVar == 4 then DSP_FUEL()
        elseif DispVar == 5 then DSP_AIR_ECS()
        elseif DispVar == 6 then DSP_HYD()
        elseif DispVar == 7 then DSP_DOOR()
        elseif DispVar == 8 then DSP_GEAR()
        elseif DispVar == 9 then DSP_FCTL()
        end
    else

     DSP_CHKL ()
     ipc.set("ChkListVar", 1)
     end
        DspShow ("CHKL", "")
end


-- ## Ext Light Switches LL ###############
-- $$ OUTBD

function LANDING_OUTBD_L_on ()
    ipc.control(PMDGBaseVariable + 222, 1)
    DspShow ("OUTB", "Lon", "OUTBD", "L on")
end

function LANDING_OUTBD_L_off ()
    ipc.control(PMDGBaseVariable + 222, 0)
    DspShow ("OUTB", "Loff", "OUTBD", "L off")
end

function LANDING_OUTBD_L_toggle ()
	if _tl("switch_222_74X", 0) then
       LANDING_OUTBD_L_on ()
	else
       LANDING_OUTBD_L_off ()
	end
end

function LANDING_OUTBD_R_on ()
    ipc.control(PMDGBaseVariable + 223, 1)
    DspShow ("OUTB", "Ron", "OUTBD", "R on")
end

function LANDING_OUTBD_R_off ()
    ipc.control(PMDGBaseVariable + 223, 0)
    DspShow ("OUTB", "Roff", "OUTBD", "R off")
end

function LANDING_OUTBD_R_toggle ()
	if _tl("switch_223_74X", 0) then
       LANDING_OUTBD_R_on ()
	else
       LANDING_OUTBD_R_off ()
	end
end

function LANDING_OUTBD_BOTH_on ()
    LANDING_OUTBD_L_on ()
    LANDING_OUTBD_R_on ()
end

function LANDING_OUTBD_BOTH_off ()
    LANDING_OUTBD_L_off ()
    LANDING_OUTBD_R_off ()
end

function LANDING_OUTBD_BOTH_toggle ()
    LANDING_OUTBD_L_toggle ()
    LANDING_OUTBD_R_toggle ()
end

-- $$ INBD

function LANDING_INBD_L_on ()
    ipc.control(PMDGBaseVariable + 224, 1)
    DspShow ("INBD", "Lon", "INBD", "L on")
end

function LANDING_INBD_L_off ()
    ipc.control(PMDGBaseVariable + 224, 0)
    DspShow ("INBD", "Loff", "INBD", "L off")
end

function LANDING_INBD_L_toggle ()
	if _tl("switch_224_74X", 0) then
       LANDING_INBD_L_on ()
	else
       LANDING_INBD_L_off ()
	end
end

function LANDING_INBD_R_on ()
    ipc.control(PMDGBaseVariable + 225, 1)
    DspShow ("INBD", "Ron", "INBD", "R on")
end

function LANDING_INBD_R_off ()
    ipc.control(PMDGBaseVariable + 225, 0)
    DspShow ("INBD", "Roff", "INBD", "R off")
end

function LANDING_INBD_R_toggle ()
	if _tl("switch_225_74X", 0) then
       LANDING_INBD_R_on ()
	else
       LANDING_INBD_R_off ()
	end
end

function LANDING_INBD_BOTH_on ()
    LANDING_INBD_L_on ()
    LANDING_INBD_R_on ()
end

function LANDING_INBD_BOTH_off ()
    LANDING_INBD_L_off ()
    LANDING_INBD_R_off ()
end

function LANDING_INBD_BOTH_toggle ()
    LANDING_INBD_L_toggle ()
    LANDING_INBD_R_toggle ()
end

function LANDING_ALL_on ()
    LANDING_OUTBD_BOTH_on ()
    _sleep(50,150)
    LANDING_INBD_BOTH_on ()
end

function LANDING_ALL_off ()
    LANDING_OUTBD_BOTH_off ()
    _sleep(50,150)
    LANDING_INBD_BOTH_off ()
end

function LANDING_ALL_toggle ()
    LANDING_OUTBD_BOTH_toggle ()
    _sleep(50,150)
    LANDING_INBD_BOTH_toggle ()
end




-- ## Ext Light Switches RWY Taxi ###############
-- $$ RWY TURNOFF

function RWY_L_TURNOFF_on ()
    ipc.control(PMDGBaseVariable + 226, 1)
    DspShow ("RWY", "Lon", "RWY TURN", "L on")
end

function RWY_L_TURNOFF_off ()
    ipc.control(PMDGBaseVariable + 226, 0)
    DspShow ("RWY", "Loff", "RWY TURN", "L off")
end

function RWY_L_TURNOFF_toggle ()
	if _tl("switch_226_74X", 0) then
       RWY_L_TURNOFF_on ()
	else
       RWY_L_TURNOFF_off ()
	end
end

function RWY_R_TURNOFF_on ()
    ipc.control(PMDGBaseVariable + 227, 1)
    DspShow ("RWY", "Ron", "RWY TURN", "R on")
end

function RWY_R_TURNOFF_off ()
    ipc.control(PMDGBaseVariable + 227, 0)
    DspShow ("RWY", "Roff", "RWY TURN", "R off")
end

function RWY_R_TURNOFF_toggle ()
	if _tl("switch_227_74X", 0) then
       RWY_R_TURNOFF_on ()
	else
       RWY_R_TURNOFF_off ()
	end
end

function  RWY_BOTH_TURNOFF_on ()
    RWY_L_TURNOFF_on ()
    RWY_R_TURNOFF_on ()
end

function  RWY_BOTH_TURNOFF_off ()
    RWY_L_TURNOFF_off ()
    RWY_R_TURNOFF_off ()
end

function RWY_BOTH_TURNOFF_toggle ()
    RWY_L_TURNOFF_toggle ()
    RWY_R_TURNOFF_toggle ()
end

-- $$ TAXI

function LIGHTS_TAXI_on ()
    ipc.control(PMDGBaseVariable + 228, 1)
    DspShow ("TAXI", "on")
end

function LIGHTS_TAXI_off ()
    ipc.control(PMDGBaseVariable + 228, 0)
    DspShow ("TAXI", "off")
end

function LIGHTS_TAXI_toggle ()
	if _tl("switch_228_74X", 0) then
       LIGHTS_TAXI_on ()
	else
       LIGHTS_TAXI_off ()
	end
end


function LL_INBD_BOTH_TAXI_toggle ()
    LANDING_INBD_L_toggle ()
    LANDING_INBD_R_toggle ()
    LIGHTS_TAXI_toggle ()
end

-- ## Ext Light Switches ETC ###############

function LIGHTS_BEACON_both ()
    ipc.control(PMDGBaseVariable + 230, 2)
    DspShow ("BCN", "both")
end

function LIGHTS_BEACON_off ()
    ipc.control(PMDGBaseVariable + 230, 1)
    DspShow ("BCN", "off")
end

function LIGHTS_BEACON_lower ()
    ipc.control(PMDGBaseVariable + 230, 0)
    DspShow ("BCN", "lwr")
end

function LIGHTS_BEACON_toggle ()
	if _tl("switch_230_74X", 50) then
       LIGHTS_BEACON_both ()
	else
       LIGHTS_BEACON_off ()
	end
end

function LIGHTS_NAV_on ()
    ipc.control(PMDGBaseVariable + 231, 1)
    DspShow ("NAV", "on")
end

function LIGHTS_NAV_off ()
    ipc.control(PMDGBaseVariable + 231, 0)
    DspShow ("NAV", "off")
end

function LIGHTS_NAV_toggle ()
	if _tl("switch_231_74X", 0) then
       LIGHTS_NAV_on ()
	else
       LIGHTS_NAV_off ()
	end
end


function LIGHTS_STRB_on ()
    ipc.control(PMDGBaseVariable + 232, 1)
    DspShow ("STRB", "on")
end

function LIGHTS_STRB_off ()
    ipc.control(PMDGBaseVariable + 232, 0)
    DspShow ("STRB", "off")
end

function LIGHTS_STRB_toggle ()
	if _tl("switch_232_74X", 0) then
       LIGHTS_STRB_on ()
	else
       LIGHTS_STRB_off ()
	end
end

function LIGHTS_WING_on ()
    ipc.control(PMDGBaseVariable + 233, 1)
    DspShow ("WING", "on")
end

function LIGHTS_WING_off ()
    ipc.control(PMDGBaseVariable + 233, 0)
    DspShow ("WING", "off")
end

function LIGHTS_WING_toggle ()
	if _tl("switch_233_74X", 0) then
       LIGHTS_WING_on ()
	else
       LIGHTS_WING_off ()
	end
end

function LIGHTS_LOGO_on ()
    ipc.control(PMDGBaseVariable + 234, 1)
    DspShow ("LOGO", "on")
end

function LIGHTS_LOGO_off ()
    ipc.control(PMDGBaseVariable + 234, 0)
    DspShow ("LOGO", "off")
end

function LIGHTS_LOGO_toggle ()
	if _tl("switch_234_74X", 0) then
       LIGHTS_LOGO_on ()
	else
       LIGHTS_LOGO_off ()
	end
end






-- ## Internal Light Switches ###############

function OH_LIGHTS_STORM_on ()
    ipc.control(PMDGBaseVariable + 210, 1)
    DspShow ("STRM", "on", "STORM", "on")
end

function OH_LIGHTS_STORM_off ()
    ipc.control(PMDGBaseVariable + 210, 0)
    DspShow ("STRM", "off", "STORM", "off")
end

function OH_LIGHTS_STORM_toggle ()
	if _tl("switch_210_74X", 0) then
       OH_LIGHTS_STORM_on ()
	else
       OH_LIGHTS_STORM_off ()
	end
end







function OH_DOME_SWITCH_off ()
        DomeVar = ipc.readLvar("switch_214_74X")
        if DomeVar > 0 and DomeVar < 289 then
        ipc.control(66587, 21401)
        elseif DomeVar > 290 then
        ipc.control(66587, 21401)
        ipc.sleep(2000)
        ipc.control(66587, 21401)
        end
        DspShow ("DOME", "off")
end

function OH_DOME_SWITCH_mid ()
        DomeVar = ipc.readLvar("switch_214_74X")
        if DomeVar >= 0 and DomeVar < 139 then
        ipc.control(66587, 21402)
        elseif DomeVar > 150 then
        ipc.control(66587, 21401)
        end
        DspShow ("DOME", "mid")
end

function OH_DOME_SWITCH_full ()
        DomeVar = ipc.readLvar("switch_214_74X")
        if DomeVar < 290 and DomeVar > 150 then
        ipc.control(66587, 21402)
        elseif DomeVar <= 150 then
        ipc.control(66587, 21402)
        ipc.sleep(2000)
        ipc.control(66587, 21402)
        end
        DspShow ("DOME", "full")

end


function OH_DOME_SWITCH_toggle ()
	if _tl("switch_214_74X", 0) then
       OH_DOME_SWITCH_mid ()
	else
       OH_DOME_SWITCH_off ()
	end
end





-- ## Internal Light Dimmers ###############
-- $$ LEFT_PANEL_LIGHT

function LEFT_PANEL_LIGHT_off ()
    ipc.control(PMDGBaseVariable + 505, 0)
end

function LEFT_PANEL_LIGHT_50 ()
    ipc.control(PMDGBaseVariable + 505, 150)
end

function LEFT_PANEL_LIGHT_100 ()
    ipc.control(PMDGBaseVariable + 505, 300)
end

function LEFT_PANEL_LIGHT_inc ()
    DimVar = ipc.readLvar("switch_505_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 505, DimVar)
end

function LEFT_PANEL_LIGHT_dec ()
    DimVar = ipc.readLvar("switch_505_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 505, DimVar)
end

-- $$ RIGHT_PANEL_LIGHT

function RIGHT_PANEL_LIGHT_off ()
    ipc.control(PMDGBaseVariable + 605, 0)
end

function RIGHT_PANEL_LIGHT_50 ()
    ipc.control(PMDGBaseVariable + 605, 150)
end

function RIGHT_PANEL_LIGHT_100 ()
    ipc.control(PMDGBaseVariable + 605, 300)
end

function RIGHT_PANEL_LIGHT_inc ()
    DimVar = ipc.readLvar("switch_605_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 605, DimVar)
end

function RIGHT_PANEL_LIGHT_dec ()
    DimVar = ipc.readLvar("switch_605_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 605, DimVar)
end


-- $$ ovhd dimmer

function OVHD_PANEL_DIM_off ()
    ipc.control(PMDGBaseVariable + 211, 0)
end

function OVHD_PANEL_DIM_50 ()
    ipc.control(PMDGBaseVariable + 211, 150)
end

function OVHD_PANEL_DIM_100 ()
    ipc.control(PMDGBaseVariable + 211, 300)
end

function OVHD_PANEL_DIM_inc ()
    DimVar = ipc.readLvar("switch_211_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 211, DimVar)
end

function OVHD_PANEL_DIM_dec ()
    DimVar = ipc.readLvar("switch_211_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 211, DimVar)
end


-- $$ Glareshield dimmer

function GLARESHIELD_DIM_off ()
    ipc.control(PMDGBaseVariable + 212, 0)
end

function GLARESHIELD_DIM_50 ()
    ipc.control(PMDGBaseVariable + 212, 150)
end

function GLARESHIELD_DIM_100 ()
    ipc.control(PMDGBaseVariable + 212, 300)
end

function GLARESHIELD_DIM_inc ()
    DimVar = ipc.readLvar("switch_212_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 212, DimVar)
end

function GLARESHIELD_DIM_dec ()
    DimVar = ipc.readLvar("switch_212_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 212, DimVar)
end

-- $$ Pdestal/Aisle dimmer

function PEDESTAL_DIM_off ()
    ipc.control(PMDGBaseVariable + 221, 0)
end

function PEDESTAL_DIM_50 ()
    ipc.control(PMDGBaseVariable + 221, 150)
end

function PEDESTAL_DIM_100 ()
    ipc.control(PMDGBaseVariable + 221, 300)
end

function PEDESTAL_DIM_inc ()
    DimVar = ipc.readLvar("switch_221_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 221, DimVar)
end

function PEDESTAL_DIM_dec ()
    DimVar = ipc.readLvar("switch_221_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 221, DimVar)
end

-- $$ All Dimmer

function Dimmer_ALL_off ()
    LEFT_PANEL_LIGHT_off ()
    RIGHT_PANEL_LIGHT_off ()
    OVHD_PANEL_DIM_off ()
    GLARESHIELD_DIM_off ()
    PEDESTAL_DIM_off ()
end

function Dimmer_ALL_50 ()
    LEFT_PANEL_LIGHT_50 ()
    RIGHT_PANEL_LIGHT_50 ()
    OVHD_PANEL_DIM_50 ()
    GLARESHIELD_DIM_50 ()
    PEDESTAL_DIM_50 ()
end

function Dimmer_ALL_100 ()
    LEFT_PANEL_LIGHT_100 ()
    RIGHT_PANEL_LIGHT_100 ()
    OVHD_PANEL_DIM_100 ()
    GLARESHIELD_DIM_100 ()
    PEDESTAL_DIM_100 ()
end

function Dimmer_ALL_toggle ()
	if _tl("switch_212_74X", 0) then
       Dimmer_ALL_50 ()
	else
       Dimmer_ALL_off ()
	end
end

function Dimmer_ALL_inc ()
    LEFT_PANEL_LIGHT_inc ()
    RIGHT_PANEL_LIGHT_inc ()
    OVHD_PANEL_DIM_inc ()
    GLARESHIELD_DIM_inc ()
    PEDESTAL_DIM_inc ()
end

function Dimmer_ALL_dec ()
    LEFT_PANEL_LIGHT_dec ()
    RIGHT_PANEL_LIGHT_dec ()
    OVHD_PANEL_DIM_dec ()
    GLARESHIELD_DIM_dec ()
    PEDESTAL_DIM_dec ()
end

-- ## Display Dimmer ###############

-- $$ LEFT_OUTBD_BRIGHT

function LEFT_OUTBD_BRIGHT_low ()
    ipc.control(PMDGBaseVariable + 500, 0)
end

function LEFT_OUTBD_BRIGHT_50 ()
    ipc.control(PMDGBaseVariable + 500, 150)
end

function LEFT_OUTBD_BRIGHT_100 ()
    ipc.control(PMDGBaseVariable + 500, 300)
end

function LEFT_OUTBD_BRIGHT_inc ()
    DimVar = ipc.readLvar("switch_500_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 500, DimVar)
end

function LEFT_OUTBD_BRIGHT_dec ()
    DimVar = ipc.readLvar("switch_500_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 500, DimVar)
end

-- $$ LEFT_INBD_BRIGHT

function LEFT_INBD_BRIGHT_low ()
    ipc.control(PMDGBaseVariable + 501, 0)
end

function LEFT_INBD_BRIGHT_50 ()
    ipc.control(PMDGBaseVariable + 501, 150)
end

function LEFT_INBD_BRIGHT_100 ()
    ipc.control(PMDGBaseVariable + 501, 300)
end

function LEFT_INBD_BRIGHT_inc ()
    DimVar = ipc.readLvar("switch_501_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 501, DimVar)
end

function LEFT_INBD_BRIGHT_dec ()
    DimVar = ipc.readLvar("switch_501_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 501, DimVar)
end

-- $$ RIGHT_OUTBD_BRIGHT

function RIGHT_OUTBD_BRIGHT_low ()
    ipc.control(PMDGBaseVariable + 600, 0)
end

function RIGHT_OUTBD_BRIGHT_50 ()
    ipc.control(PMDGBaseVariable + 600, 150)
end

function RIGHT_OUTBD_BRIGHT_100 ()
    ipc.control(PMDGBaseVariable + 600, 300)
end

function RIGHT_OUTBD_BRIGHT_inc ()
    DimVar = ipc.readLvar("switch_600_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 600, DimVar)
end

function RIGHT_OUTBD_BRIGHT_dec ()
    DimVar = ipc.readLvar("switch_600_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 600, DimVar)
end

-- $$ RIGHT_INBD_BRIGHT

function RIGHT_INBD_BRIGHT_low ()
    ipc.control(PMDGBaseVariable + 601, 0)
end

function RIGHT_INBD_BRIGHT_50 ()
    ipc.control(PMDGBaseVariable + 601, 150)
end

function RIGHT_INBD_BRIGHT_100 ()
    ipc.control(PMDGBaseVariable + 601, 300)
end

function RIGHT_INBD_BRIGHT_inc ()
    DimVar = ipc.readLvar("switch_601_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 601, DimVar)
end

function RIGHT_INBD_BRIGHT_dec ()
    DimVar = ipc.readLvar("switch_601_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 601, DimVar)
end

-- $$ FWD_UPPER_BRIGHT

function FWD_UPPER_BRIGHT_low ()
    ipc.control(PMDGBaseVariable + 730, 0)
end

function FWD_UPPER_BRIGHT_50 ()
    ipc.control(PMDGBaseVariable + 730, 150)
end

function FWD_UPPER_BRIGHT_100 ()
    ipc.control(PMDGBaseVariable + 730, 300)
end

function FWD_UPPER_BRIGHT_inc ()
    DimVar = ipc.readLvar("switch_730_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 730, DimVar)
end

function FWD_UPPER_BRIGHT_dec ()
    DimVar = ipc.readLvar("switch_730_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 730, DimVar)
end

-- $$ FWD_LOWER_BRIGHT

function FWD_LOWER_BRIGHT_low ()
    ipc.control(PMDGBaseVariable + 731, 0)
end

function FWD_LOWER_BRIGHT_50 ()
    ipc.control(PMDGBaseVariable + 731, 150)
end

function FWD_LOWER_BRIGHT_100 ()
    ipc.control(PMDGBaseVariable + 731, 300)
end

function FWD_LOWER_BRIGHT_inc ()
    DimVar = ipc.readLvar("switch_731_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 731, DimVar)
end

function FWD_LOWER_BRIGHT_dec ()
    DimVar = ipc.readLvar("switch_731_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 731, DimVar)
end

function ALL_DISPLAYS_low ()
    LEFT_OUTBD_BRIGHT_low ()
    LEFT_INBD_BRIGHT_low ()
    RIGHT_OUTBD_BRIGHT_low ()
    RIGHT_INBD_BRIGHT_low ()
    FWD_UPPER_BRIGHT_low ()
    FWD_LOWER_BRIGHT_low ()
end

function ALL_DISPLAYS_50 ()
    LEFT_OUTBD_BRIGHT_50 ()
    LEFT_INBD_BRIGHT_50 ()
    RIGHT_OUTBD_BRIGHT_50 ()
    RIGHT_INBD_BRIGHT_50 ()
    FWD_UPPER_BRIGHT_50 ()
    FWD_LOWER_BRIGHT_50 ()
end

function ALL_DISPLAYS_100 ()
    LEFT_OUTBD_BRIGHT_100 ()
    LEFT_INBD_BRIGHT_100 ()
    RIGHT_OUTBD_BRIGHT_100 ()
    RIGHT_INBD_BRIGHT_100 ()
    FWD_UPPER_BRIGHT_100 ()
    FWD_LOWER_BRIGHT_100 ()
end

function ALL_DISPLAYS_inc ()
    LEFT_OUTBD_BRIGHT_inc ()
    LEFT_INBD_BRIGHT_inc ()
    RIGHT_OUTBD_BRIGHT_inc ()
    RIGHT_INBD_BRIGHT_inc ()
    FWD_UPPER_BRIGHT_inc ()
    FWD_LOWER_BRIGHT_inc ()
end

function ALL_DISPLAYS_dec ()
    LEFT_OUTBD_BRIGHT_dec ()
    LEFT_INBD_BRIGHT_dec ()
    RIGHT_OUTBD_BRIGHT_dec ()
    RIGHT_INBD_BRIGHT_dec ()
    FWD_UPPER_BRIGHT_dec ()
    FWD_LOWER_BRIGHT_dec ()
end

-- ## Floodlights Dimmer ###############

-- $$ LEFT_FLOOD_LIGHT_CONTROL

function LEFT_FLOOD_LIGHT_off ()
    ipc.control(PMDGBaseVariable + 506, 0)
end

function LEFT_FLOOD_LIGHT_mid ()
    ipc.control(PMDGBaseVariable + 506, floodmidvar)
end

function LEFT_FLOOD_LIGHT_100 ()
    ipc.control(PMDGBaseVariable + 506, 300)
end

function LEFT_FLOOD_LIGHT_inc ()
    DimVar = ipc.readLvar("switch_506_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 506, DimVar)
end

function LEFT_FLOOD_LIGHT_dec ()
    DimVar = ipc.readLvar("switch_506_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 506, DimVar)
end


-- $$ RIGHT_FLOOD_LIGHT_CONTROL

function RIGHT_FLOOD_LIGHT_off ()
    ipc.control(PMDGBaseVariable + 606, 0)
end

function RIGHT_FLOOD_LIGHT_mid ()
    ipc.control(PMDGBaseVariable + 606, floodmidvar)
end

function RIGHT_FLOOD_LIGHT_100 ()
    ipc.control(PMDGBaseVariable + 606, 300)
end

function RIGHT_FLOOD_LIGHT_inc ()
    DimVar = ipc.readLvar("switch_606_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 606, DimVar)
end

function RIGHT_FLOOD_LIGHT_dec ()
    DimVar = ipc.readLvar("switch_606_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 606, DimVar)
end


-- $$ GS_FLOOD_LIGHT_CONTROL

function GS_FLOOD_LIGHT_off ()
    ipc.control(PMDGBaseVariable + 213, 0)
end

function GS_FLOOD_LIGHT_mid ()
    ipc.control(PMDGBaseVariable + 213, floodmidvar)
end

function GS_FLOOD_LIGHT_100 ()
    ipc.control(PMDGBaseVariable + 213, 300)
end

function GS_FLOOD_LIGHT_inc ()
    DimVar = ipc.readLvar("switch_213_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 213, DimVar)
end

function GS_FLOOD_LIGHT_dec ()
    DimVar = ipc.readLvar("switch_213_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 213, DimVar)
end



-- $$ AISLE_STAND_FLOOD_CONTROL

function AISLE_STAND_FLOOD_off ()
    ipc.control(PMDGBaseVariable + 220, 0)
end

function AISLE_STAND_FLOOD_mid ()
    ipc.control(PMDGBaseVariable + 220, floodmidvar)
end

function AISLE_STAND_FLOOD_100 ()
    ipc.control(PMDGBaseVariable + 220, 300)
end

function AISLE_STAND_FLOOD_inc ()
    DimVar = ipc.readLvar("switch_220_74X")

    if DimVar < 300 then
    DimVar = DimVar + 10
    else DimVar = 300
    end
    ipc.control(PMDGBaseVariable + 220, DimVar)
end

function AISLE_STAND_FLOOD_dec ()
    DimVar = ipc.readLvar("switch_220_74X")

    if DimVar > 0 then
    DimVar = DimVar - 10
    else DimVar = 0
    end
    ipc.control(PMDGBaseVariable + 220, DimVar)
end

function ALL_FLOOD_off ()
    LEFT_FLOOD_LIGHT_off ()
    RIGHT_FLOOD_LIGHT_off ()
    GS_FLOOD_LIGHT_off ()
    AISLE_STAND_FLOOD_off ()
end

function ALL_FLOOD_mid ()
    LEFT_FLOOD_LIGHT_mid ()
    RIGHT_FLOOD_LIGHT_mid ()
    GS_FLOOD_LIGHT_mid ()
    AISLE_STAND_FLOOD_mid ()
end

function ALL_FLOOD_100 ()
    LEFT_FLOOD_LIGHT_100 ()
    RIGHT_FLOOD_LIGHT_100 ()
    GS_FLOOD_LIGHT_100 ()
    AISLE_STAND_FLOOD_100 ()
end

function ALL_FLOOD_inc ()
    LEFT_FLOOD_LIGHT_inc ()
    RIGHT_FLOOD_LIGHT_inc ()
    GS_FLOOD_LIGHT_inc ()
    AISLE_STAND_FLOOD_inc ()
end

function ALL_FLOOD_dec ()
    LEFT_FLOOD_LIGHT_dec ()
    RIGHT_FLOOD_LIGHT_dec ()
    GS_FLOOD_LIGHT_dec ()
    AISLE_STAND_FLOOD_dec ()
end



-- ## Overhead IRS ###############

function EVT_OH_IRU_SELECTOR_L_show ()
    ipc.sleep(50)
    IRUL = ipc.readUB(0x6446)
    if IRUL == 0 then IRULtxt = "off" IRULtxtL = "off"
    elseif IRUL == 1 then IRULtxt = "algn" IRULtxtL = "align"
    elseif IRUL == 2 then IRULtxt = "nav" IRULtxtL = "nav"
    elseif IRUL == 3 then IRULtxt = "att" IRULtxtL = "att"
    end
    DspShow ("IRSL", IRULtxt, "IRSL", IRULtxtL)
end

function EVT_OH_IRU_SELECTOR_L_off ()
    ipc.control(PMDGBaseVariable + 5, 0)
    EVT_OH_IRU_SELECTOR_L_show ()
end

function EVT_OH_IRU_SELECTOR_L_align ()
    ipc.control(PMDGBaseVariable + 5, 1)
    EVT_OH_IRU_SELECTOR_L_show ()
end

function EVT_OH_IRU_SELECTOR_L_nav ()
    ipc.control(PMDGBaseVariable + 5, 2)
    EVT_OH_IRU_SELECTOR_L_show ()
end

function EVT_OH_IRU_SELECTOR_L_att ()
    ipc.control(PMDGBaseVariable + 5, 3)
    EVT_OH_IRU_SELECTOR_L_show ()
end

function EVT_OH_IRU_SELECTOR_L_inc ()
    ipc.control(PMDGBaseVariable + 5, 256)
    EVT_OH_IRU_SELECTOR_L_show ()
end

function EVT_OH_IRU_SELECTOR_L_dec ()
    ipc.control(PMDGBaseVariable + 5, 128)
    EVT_OH_IRU_SELECTOR_L_show ()
end

---

function EVT_OH_IRU_SELECTOR_C_show ()

    ipc.sleep(100)
    IRUC = ipc.readUB(0x6447)
    if IRUC == 0 then IRUCtxt = "off" IRUCtxtL = "off"
    elseif IRUC == 1 then IRUCtxt = "algn" IRUCtxtL = "align"
    elseif IRUC == 2 then IRUCtxt = "nav" IRUCtxtL = "nav"
    elseif IRUC == 3 then IRUCtxt = "att" IRUCtxtL = "att"
    end
    DspShow ("IRSC", IRUCtxt, "IRSC", IRUCtxtL)
end

function EVT_OH_IRU_SELECTOR_C_off ()
    ipc.control(PMDGBaseVariable + 6, 0)
     EVT_OH_IRU_SELECTOR_C_show ()
end

function EVT_OH_IRU_SELECTOR_C_align ()
    ipc.control(PMDGBaseVariable + 6, 1)

     EVT_OH_IRU_SELECTOR_C_show ()
end

function EVT_OH_IRU_SELECTOR_C_nav ()
    ipc.control(PMDGBaseVariable + 6, 2)
    EVT_OH_IRU_SELECTOR_C_show ()
end

function EVT_OH_IRU_SELECTOR_C_att ()
    ipc.control(PMDGBaseVariable + 6, 3)
    EVT_OH_IRU_SELECTOR_C_show ()
end

function EVT_OH_IRU_SELECTOR_C_inc ()
    ipc.control(PMDGBaseVariable + 6, 256)
    EVT_OH_IRU_SELECTOR_C_show ()
end

function EVT_OH_IRU_SELECTOR_C_dec ()
    ipc.control(PMDGBaseVariable + 6, 128)
    EVT_OH_IRU_SELECTOR_C_show ()
end

---

function EVT_OH_IRU_SELECTOR_R_show ()
    ipc.sleep(100)
    IRUR = ipc.readUB(0x6448)
    if IRUR == 0 then IRURtxt = "off" IRURtxtL = "off"
    elseif IRUR == 1 then IRURtxt = "algn" IRURtxtL = "align"
    elseif IRUR == 2 then IRURtxt = "nav" IRURtxtL = "nav"
    elseif IRUR == 3 then IRURtxt = "att" IRURtxtL = "att"
    end
    DspShow ("IRSR", IRURtxt, "IRSR", IRURtxtL)
end

function EVT_OH_IRU_SELECTOR_R_off ()
    ipc.control(PMDGBaseVariable + 7, 0)
    EVT_OH_IRU_SELECTOR_R_show ()
end

function EVT_OH_IRU_SELECTOR_R_align ()
    ipc.control(PMDGBaseVariable + 7, 1)
    EVT_OH_IRU_SELECTOR_R_show ()
end

function EVT_OH_IRU_SELECTOR_R_nav ()
    ipc.control(PMDGBaseVariable + 7, 2)
    EVT_OH_IRU_SELECTOR_R_show ()
end

function EVT_OH_IRU_SELECTOR_R_att ()
    ipc.control(PMDGBaseVariable + 7, 3)
    EVT_OH_IRU_SELECTOR_R_show ()
end

function EVT_OH_IRU_SELECTOR_R_inc ()
    ipc.control(PMDGBaseVariable + 7, 256)
    EVT_OH_IRU_SELECTOR_R_show ()
end

function EVT_OH_IRU_SELECTOR_R_dec ()
    ipc.control(PMDGBaseVariable + 7, 128)
    EVT_OH_IRU_SELECTOR_R_show ()
end


function EVT_OH_IRU_SELECTOR_ALL_off ()
    EVT_OH_IRU_SELECTOR_L_off ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_C_off ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_R_off ()
end

function EVT_OH_IRU_SELECTOR_ALL_align ()
    EVT_OH_IRU_SELECTOR_L_align ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_C_align ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_R_align ()
end

function EVT_OH_IRU_SELECTOR_ALL_nav ()
    EVT_OH_IRU_SELECTOR_L_nav ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_C_nav ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_R_nav ()
end

function EVT_OH_IRU_SELECTOR_ALL_att ()
    EVT_OH_IRU_SELECTOR_L_att ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_C_att ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_R_att ()
end

function EVT_OH_IRU_SELECTOR_ALL_inc ()
    EVT_OH_IRU_SELECTOR_L_inc ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_C_inc ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_R_inc ()
end

function EVT_OH_IRU_SELECTOR_ALL_dec ()
    EVT_OH_IRU_SELECTOR_L_dec ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_C_dec ()
    _sleep(150,250)
    EVT_OH_IRU_SELECTOR_R_dec ()
end

-- ## Overhead Electric ###############

function OH_ELEC_STBY_PWR_SWITCH_off ()
    ipc.control(PMDGBaseVariable + 10, 0)
    DspShow ("SPwr", "off", "Stby Pwr", "off")
end

function OH_ELEC_STBY_PWR_SWITCH_auto ()
    ipc.control(PMDGBaseVariable + 10, 1)
    DspShow ("SPwr", "auto", "Stby Pwr", "auto")
end

function OH_ELEC_STBY_PWR_SWITCH_bat ()
    ipc.control(PMDGBaseVariable + 10, 2)
    DspShow ("SPwr", "bat", "Stby Pwr", "bat")
end


function OH_ELEC_APU_SEL_SWITCH_off ()
    ipc.control(PMDGBaseVariable + 13, 0)
    DspShow ("APU", "off")
end

function OH_ELEC_APU_SEL_SWITCH_on ()
    ipc.control(PMDGBaseVariable + 13, 1)
    DspShow ("APU", "on")
end

function OH_ELEC_APU_SEL_SWITCH_start ()
    DispModeVar = ipc.get("DispModeVar")
    if DispModeVar ~= 2 then
    DSP_STAT()
    end
    ipc.set("APUvar", 1)
    ipc.control(PMDGBaseVariable + 13, 2)
    DspShow ("APU", "strt", "APU", "start")
    ipc.sleep(150)
    ipc.control(PMDGBaseVariable + 13, 1)
end




function OH_ELEC_BATTERY_SWITCHANDGUARD_on ()
    OH_ELEC_BATTERY_SWITCH_on ()
    _sleep(250, 500)
    OH_ELEC_BATTERY_GUARD_close ()
end

function OH_ELEC_BATTERY_SWITCHANDGUARD_off ()
    OH_ELEC_BATTERY_GUARD_open ()
    _sleep(250, 500)
    OH_ELEC_BATTERY_SWITCH_off ()
end

function OH_ELEC_BATTERY_SWITCHANDGUARD_toggle ()
    if _tl("switch_018_74X", 0) then
       OH_ELEC_BATTERY_SWITCHANDGUARD_on ()
	else
       OH_ELEC_BATTERY_SWITCHANDGUARD_off ()
	end
end


function OH_ELEC_BATTERY_SWITCH_on ()
    ipc.control(PMDGBaseVariable + 18, 1)
    DspShow ("Batt", "on")
end

function OH_ELEC_BATTERY_SWITCH_off ()
    ipc.control(PMDGBaseVariable + 18, 0)
    DspShow ("Batt", "off")
end

function OH_ELEC_BATTERY_SWITCH_toggle ()
	if _tl("switch_018_74X", 0) then
       OH_ELEC_BATTERY_SWITCH_on ()
	else
       OH_ELEC_BATTERY_SWITCH_off ()
	end
end


function OH_ELEC_BATTERY_GUARD_open ()
    ipc.control(PMDGBaseVariable + 10018, 1)
end

function OH_ELEC_BATTERY_GUARD_close ()
    ipc.control(PMDGBaseVariable + 10018, 0)
end

function OH_ELEC_BATTERY_GUARD_toggle ()
	if _tl("switch_10018_74X", 0) then
       OH_ELEC_BATTERY_GUARD_open ()
	else
       OH_ELEC_BATTERY_GUARD_close ()
	end
end

function OH_ELEC_EXT_PWR1_SWITCH_on ()
    ExtPwr1 = ipc.readUB(0x6465)
    if ExtPwr1 == 0 then
	ipc.control(PMDGBaseVariable + 14, 1)
	DspShow ("EXT", "PWR1", "EXT PWR", "1 on")
    end
end

function OH_ELEC_EXT_PWR1_SWITCH_off ()
    ExtPwr1 = ipc.readUB(0x6465)
    if ExtPwr1 == 1 then
	ipc.control(PMDGBaseVariable + 14, 1)
	DspShow ("EXT", "PWR1", "EXT PWR", "1 off")
    end
end

function OH_ELEC_EXT_PWR1_SWITCH_toggle ()
    ExtPwr1 = ipc.readUB(0x6465)
    if ExtPwr1 == 0 then
       OH_ELEC_EXT_PWR1_SWITCH_on ()
	else
       OH_ELEC_EXT_PWR1_SWITCH_off ()
	end
end

function OH_ELEC_EXT_PWR2_SWITCH_on ()
    ExtPwr2 = ipc.readUB(0x6466)
    if ExtPwr2 == 0 then
	ipc.control(PMDGBaseVariable + 15, 1)
	DspShow ("EXT", "PWR2", "EXT PWR", "2 on")
    end
end

function OH_ELEC_EXT_PWR2_SWITCH_off ()
    ExtPwr2 = ipc.readUB(0x6466)
    if ExtPwr2 == 1 then
	ipc.control(PMDGBaseVariable + 15, 1)
	DspShow ("EXT", "PWR2", "EXT PWR", "2 off")
    end
end

function OH_ELEC_EXT_PWR2_SWITCH_toggle ()
    ExtPwr2 = ipc.readUB(0x6466)
    if ExtPwr2 == 0 then
        OH_ELEC_EXT_PWR2_SWITCH_on ()
    else
        OH_ELEC_EXT_PWR2_SWITCH_off ()
    end
end

function OH_ELEC_EXT_PWR_SWITCH_BOTH_on ()
    OH_ELEC_EXT_PWR1_SWITCH_on ()
    _sleep(200,400)
    OH_ELEC_EXT_PWR2_SWITCH_on ()
end

function OH_ELEC_EXT_PWR_SWITCH_BOTH_off ()
    OH_ELEC_EXT_PWR1_SWITCH_off ()
    _sleep(200,400)
    OH_ELEC_EXT_PWR2_SWITCH_off ()
end

function OH_ELEC_EXT_PWR_SWITCH_BOTH_toggle ()
    OH_ELEC_EXT_PWR1_SWITCH_toggle ()
    _sleep(200,400)
    OH_ELEC_EXT_PWR2_SWITCH_toggle ()
end



function OH_ELEC_APU_GEN1_SWITCH_on ()
    APUPwr1 = ipc.readUB(0x646b)
    if APUPwr1 == 1 then
	ipc.control(PMDGBaseVariable + 16, 1)
	DspShow ("APU", "Gen1", "APU Gen1", "on")
    end
end

function OH_ELEC_APU_GEN1_SWITCH_off ()
    APUPwr1 = ipc.readUB(0x646b)
    if APUPwr1 == 0 then
	ipc.control(PMDGBaseVariable + 16, 1)
	DspShow ("APU", "Gen1", "APU Gen1", "off")
    end
end


function OH_ELEC_APU_GEN1_SWITCH_toggle ()
	if ipc.readUB(0x646b) == 1 then
       OH_ELEC_APU_GEN1_SWITCH_on ()
	else
       OH_ELEC_APU_GEN1_SWITCH_off ()
	end
end


function OH_ELEC_APU_GEN2_SWITCH_on ()
    APUPwr2 = ipc.readUB(0x646c)
    if APUPwr2 == 1 then
	ipc.control(PMDGBaseVariable + 17, 1)
 DspShow ("APU", "Gen2", "APU Gen2", "on")
    end
end

function OH_ELEC_APU_GEN2_SWITCH_off ()
    APUPwr2 = ipc.readUB(0x646c)
    if APUPwr2 == 0 then
	ipc.control(PMDGBaseVariable + 17, 1)
 DspShow ("APU", "Gen2", "APU Gen2", "off")
    end
end



function OH_ELEC_APU_GEN2_SWITCH_toggle ()
	if ipc.readUB(0x646c) == 1 then
       OH_ELEC_APU_GEN2_SWITCH_on ()
	else
       OH_ELEC_APU_GEN2_SWITCH_off ()
	end
end

function OH_ELEC_APU_GEN_SWITCH_BOTH_on ()
    OH_ELEC_APU_GEN1_SWITCH_on ()
    _sleep(200,400)
    OH_ELEC_APU_GEN2_SWITCH_on ()
end

function OH_ELEC_APU_GEN_SWITCH_BOTH_off ()
    OH_ELEC_APU_GEN1_SWITCH_off ()
    _sleep(200,400)
    OH_ELEC_APU_GEN2_SWITCH_off ()
end

function OH_ELEC_APU_GEN_SWITCH_BOTH_toggle ()
    OH_ELEC_APU_GEN1_SWITCH_toggle ()
    _sleep(200,400)
    OH_ELEC_APU_GEN2_SWITCH_toggle ()
end




-- ## Overhead - Hydraulic ###############

function OH_HYD_DEMAND1_aux ()
    ipc.control(PMDGBaseVariable + 48, 0)
    DspShow ("HYD1", "aux")
end

function OH_HYD_DEMAND1_off ()
    ipc.control(PMDGBaseVariable + 48, 1)
    DspShow ("HYD1", "off")
end

function OH_HYD_DEMAND1_auto ()
    ipc.control(PMDGBaseVariable + 48, 2)
    DspShow ("HYD1", "auto")
end

function OH_HYD_DEMAND1_on ()
    ipc.control(PMDGBaseVariable + 48, 3)
    DspShow ("HYD1", "on")
end

function OH_HYD_DEMAND1_toggle ()
	if _tl("switch_048_74X", 10) then
       OH_HYD_DEMAND1_auto ()
	else
       OH_HYD_DEMAND1_off ()
	end
end

--

function OH_HYD_DEMAND2_off ()
    ipc.control(PMDGBaseVariable + 49, 1)
    DspShow ("HYD2", "off")
end

function OH_HYD_DEMAND2_auto ()
    ipc.control(PMDGBaseVariable + 49, 2)
    DspShow ("HYD2", "auto")
end

function OH_HYD_DEMAND2_on ()
    ipc.control(PMDGBaseVariable + 49, 3)
    DspShow ("HYD2", "on")
end

function OH_HYD_DEMAND2_toggle ()
	if _tl("switch_049_74X", 10) then
       OH_HYD_DEMAND2_auto ()
	else
       OH_HYD_DEMAND2_off ()
	end
end

---


function OH_HYD_DEMAND3_off ()
    ipc.control(PMDGBaseVariable + 50, 1)
    DspShow ("HYD3", "off")
end

function OH_HYD_DEMAND3_auto ()
    ipc.control(PMDGBaseVariable + 50, 2)
    DspShow ("HYD3", "auto")
end

function OH_HYD_DEMAND3_on ()
    ipc.control(PMDGBaseVariable + 50, 3)
    DspShow ("HYD3", "on")
end

function OH_HYD_DEMAND3_toggle ()
	if _tl("switch_050_74X", 10) then
       OH_HYD_DEMAND3_auto ()
	else
       OH_HYD_DEMAND3_off ()
	end
end

----

function OH_HYD_DEMAND4_aux ()
    ipc.control(PMDGBaseVariable + 51, 0)
    DspShow ("HYD4", "aux")
end

function OH_HYD_DEMAND4_off ()
    ipc.control(PMDGBaseVariable + 51, 1)
    DspShow ("HYD4", "off")
end

function OH_HYD_DEMAND4_auto ()
    ipc.control(PMDGBaseVariable + 51, 2)
    DspShow ("HYD4", "auto")
end

function OH_HYD_DEMAND4_on ()
    ipc.control(PMDGBaseVariable + 51, 3)
    DspShow ("HYD4", "on")
end

function OH_HYD_DEMAND4_toggle ()
	if _tl("switch_051_74X", 10) then
       OH_HYD_DEMAND4_auto ()
	else
       OH_HYD_DEMAND4_off ()
	end
end

function OH_HYD_DEMAND_ALL_off ()
    OH_HYD_DEMAND1_off ()
    _sleep(100,200)
    OH_HYD_DEMAND2_off ()
    _sleep(100,200)
    OH_HYD_DEMAND3_off ()
    _sleep(100,200)
    OH_HYD_DEMAND4_off ()
end

function OH_HYD_DEMAND_ALL_auto ()
    OH_HYD_DEMAND1_auto ()
    _sleep(100,200)
    OH_HYD_DEMAND2_auto ()
    _sleep(100,200)
    OH_HYD_DEMAND3_auto ()
    _sleep(100,200)
    OH_HYD_DEMAND4_auto ()
end

function OH_HYD_DEMAND_ALL_on ()
    OH_HYD_DEMAND1_on ()
    _sleep(100,200)
    OH_HYD_DEMAND2_on ()
    _sleep(100,200)
    OH_HYD_DEMAND3_on ()
    _sleep(100,200)
    OH_HYD_DEMAND4_on ()
end

function OH_HYD_DEMAND_ALL_toggle ()
    OH_HYD_DEMAND1_toggle ()
    _sleep(100,200)
    OH_HYD_DEMAND2_toggle ()
    _sleep(100,200)
    OH_HYD_DEMAND3_toggle ()
    _sleep(100,200)
    OH_HYD_DEMAND4_toggle ()
end


-- ## Overhead - Engine control ###############

function OH_ENGINE_1_START_on ()
    DispModeVar = ipc.get("DispModeVar")
    if DispModeVar ~= 1 then
    DSP_ENG ()
    end
    ipc.control(PMDGBaseVariable + 91, 1)
    DspShow ("ENG1", "on")
end

function OH_ENGINE_1_START_off ()
    ipc.control(PMDGBaseVariable + 91, 0)
    DspShow ("ENG1", "off")
end

function OH_ENGINE_1_START_toggle ()
	if _tl("switch_091_74X", 0) then
       OH_ENGINE_1_START_on ()
	else
       OH_ENGINE_1_START_off ()
	end
end

--

function OH_ENGINE_2_START_on ()
    DispModeVar = ipc.get("DispModeVar")
    if DispModeVar ~= 1 then
    DSP_ENG ()
    end
    ipc.control(PMDGBaseVariable + 92, 1)
    DspShow ("ENG2", "on")
end

function OH_ENGINE_2_START_off ()
    ipc.control(PMDGBaseVariable + 92, 0)
    DspShow ("ENG2", "off")
end

function OH_ENGINE_2_START_toggle ()
	if _tl("switch_092_74X", 0) then
       OH_ENGINE_2_START_on ()
	else
       OH_ENGINE_2_START_off ()
	end
end

function OH_ENGINE_1and2_START_on ()

    OH_ENGINE_1_START_on ()
    _sleep(100,200)
    OH_ENGINE_2_START_on ()
end

function OH_ENGINE_1and2_START_off ()
    OH_ENGINE_1_START_off ()
    _sleep(100,200)
    OH_ENGINE_2_START_off ()
end
---

function OH_ENGINE_3_START_on ()
    DispModeVar = ipc.get("DispModeVar")
    if DispModeVar ~= 1 then
    DSP_ENG ()
    end
    ipc.control(PMDGBaseVariable + 93, 1)
    DspShow ("ENG3", "on")
end

function OH_ENGINE_3_START_off ()
    DispModeVar = ipc.get("DispModeVar")
    if DispModeVar ~= 1 then
    DSP_ENG ()
    end
    ipc.control(PMDGBaseVariable + 93, 0)
    DspShow ("ENG3", "off")
end

function OH_ENGINE_3_START_toggle ()
	if _tl("switch_093_74X", 0) then
       OH_ENGINE_3_START_on ()
	else
       OH_ENGINE_3_START_off ()
	end
end

----

function OH_ENGINE_4_START_on ()
    ipc.control(PMDGBaseVariable + 94, 1)
    DspShow ("ENG4", "on")
end

function OH_ENGINE_4_START_off ()
    ipc.control(PMDGBaseVariable + 94, 0)
    DspShow ("ENG4", "off")
end

function OH_ENGINE_4_START_toggle ()
	if _tl("switch_094_74X", 0) then
       OH_ENGINE_4_START_on ()
	else
       OH_ENGINE_4_START_off ()
	end
end


function OH_ENGINE_3and4_START_on ()
    OH_ENGINE_3_START_on ()
    _sleep(100,200)
    OH_ENGINE_4_START_on ()
end

function OH_ENGINE_3and4_START_off ()
    OH_ENGINE_3_START_off ()
    _sleep(100,200)
    OH_ENGINE_4_START_off ()
end

-- $$ Engine Selector

function Select_No_Eng ()
    ipc.set("QEngSel", 0)
    DspShow ("No", "Eng")
end

function Select_Eng1 ()
    ipc.set("QEngSel", 1)
    DspShow ("ENG1", "sel")
end

function Select_Eng2 ()
    ipc.set("QEngSel", 2)
    DspShow ("ENG2", "sel")
end

function Select_Eng3 ()
    ipc.set("QEngSel", 3)
    DspShow ("ENG3", "sel")
end

function Select_Eng4 ()
    ipc.set("QEngSel", 4)
    DspShow ("ENG4", "sel")
end

function Select_Eng12 ()
    ipc.set("QEngSel", 12)
    DspShow ("ENG4", "sel")
end

function Select_Eng34 ()
    ipc.set("QEngSel", 34)
    DspShow ("ENG4", "sel")
end

function Start_Selected_Eng ()
    SelectedEng = ipc.get("QEngSel")
    if SelectedEng == 1 then OH_ENGINE_1_START_on ()
    elseif SelectedEng == 2 then OH_ENGINE_2_START_on ()
    elseif SelectedEng == 3 then OH_ENGINE_3_START_on ()
    elseif SelectedEng == 4 then OH_ENGINE_4_START_on ()
    elseif SelectedEng == 12 then OH_ENGINE_1and2_START_on ()
    elseif SelectedEng == 34 then OH_ENGINE_3and4_START_on ()
    end
end



-- ## Overhead - FUEL Panel ###############
-- $$ Main 1

function OH_FUEL_PUMP_FWD_1_on ()
    ipc.control(PMDGBaseVariable + 116, 1)
    DspShow ("1FWD", "on", "FUEL 1", "FWD on")
end

function OH_FUEL_PUMP_FWD_1_off ()
    ipc.control(PMDGBaseVariable + 116, 0)
    DspShow ("1FWD", "off", "FUEL 1", "FWD off")
end

function OH_FUEL_PUMP_FWD_1_toggle ()
    if _tl("switch_116_74X", 0) then
       OH_FUEL_PUMP_FWD_1_on ()
	else
       OH_FUEL_PUMP_FWD_1_off ()
	end
end

function OH_FUEL_PUMP_AFT_1_on ()
    ipc.control(PMDGBaseVariable + 122, 1)
    DspShow ("1AFT", "on", "FUEL 1", "AFT on")
end

function OH_FUEL_PUMP_AFT_1_off ()
    ipc.control(PMDGBaseVariable + 122, 0)
    DspShow ("1AFT", "off", "FUEL 1", "AFT off")
end

function OH_FUEL_PUMP_AFT_1_toggle ()
    if _tl("switch_122_74X", 0) then
       OH_FUEL_PUMP_AFT_1_on ()
	else
       OH_FUEL_PUMP_AFT_1_off ()
	end
end

function OH_FUEL_PUMPS_1_on ()
    OH_FUEL_PUMP_FWD_1_on ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_1_on ()
end

function OH_FUEL_PUMPS_1_off ()
    OH_FUEL_PUMP_FWD_1_off ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_1_off ()
end

function OH_FUEL_PUMPS_1_toggle ()
    OH_FUEL_PUMP_FWD_1_toggle ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_1_toggle ()
end

-- $$ Main 2

function OH_FUEL_PUMP_FWD_2_on ()
    ipc.control(PMDGBaseVariable + 117, 1)
    DspShow ("2FWD", "on", "FUEL 2", "FWD on")
end

function OH_FUEL_PUMP_FWD_2_off ()
    ipc.control(PMDGBaseVariable + 117, 0)
    DspShow ("2FWD", "off", "FUEL 2", "FWD off")
end

function OH_FUEL_PUMP_FWD_2_toggle ()
    if _tl("switch_117_74X", 0) then
       OH_FUEL_PUMP_FWD_2_on ()
	else
       OH_FUEL_PUMP_FWD_2_off ()
	end
end

function OH_FUEL_PUMP_AFT_2_on ()
    ipc.control(PMDGBaseVariable + 123, 1)
    DspShow ("2AFT", "on", "FUEL 2", "AFT on")
end

function OH_FUEL_PUMP_AFT_2_off ()
    ipc.control(PMDGBaseVariable + 123, 0)
    DspShow ("2AFT", "off", "FUEL 2", "AFT off")
end

function OH_FUEL_PUMP_AFT_2_toggle ()
    if _tl("switch_123_74X", 0) then
       OH_FUEL_PUMP_AFT_2_on ()
	else
       OH_FUEL_PUMP_AFT_2_off ()
	end
end

function OH_FUEL_PUMPS_2_on ()
    OH_FUEL_PUMP_FWD_2_on ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_2_on ()
end

function OH_FUEL_PUMPS_2_off ()
    OH_FUEL_PUMP_FWD_2_off ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_2_off ()
end

function OH_FUEL_PUMPS_2_toggle ()
    OH_FUEL_PUMP_FWD_2_toggle ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_2_toggle ()
end

-- $$ Main 3

function OH_FUEL_PUMP_FWD_3_on ()
    ipc.control(PMDGBaseVariable + 118, 1)
    DspShow ("3FWD", "on", "FUEL 3", "FWD on")
end

function OH_FUEL_PUMP_FWD_3_off ()
    ipc.control(PMDGBaseVariable + 118, 0)
    DspShow ("3FWD", "off", "FUEL 3", "FWD off")
end

function OH_FUEL_PUMP_FWD_3_toggle ()
    if _tl("switch_118_74X", 0) then
       OH_FUEL_PUMP_FWD_3_on ()
	else
       OH_FUEL_PUMP_FWD_3_off ()
	end
end

function OH_FUEL_PUMP_AFT_3_on ()
    ipc.control(PMDGBaseVariable + 124, 1)
    DspShow ("3AFT", "on", "FUEL 3", "AFT on")
end

function OH_FUEL_PUMP_AFT_3_off ()
    ipc.control(PMDGBaseVariable + 124, 0)
    DspShow ("3AFT", "off", "FUEL 3", "AFT off")
end

function OH_FUEL_PUMP_AFT_3_toggle ()
    if _tl("switch_124_74X", 0) then
       OH_FUEL_PUMP_AFT_3_on ()
	else
       OH_FUEL_PUMP_AFT_3_off ()
	end
end

function OH_FUEL_PUMPS_3_on ()
    OH_FUEL_PUMP_FWD_3_on ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_3_on ()
end

function OH_FUEL_PUMPS_3_off ()
    OH_FUEL_PUMP_FWD_3_off ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_3_off ()
end

function OH_FUEL_PUMPS_3_toggle ()
    OH_FUEL_PUMP_FWD_3_toggle ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_3_toggle ()
end

-- $$ Main 4

function OH_FUEL_PUMP_FWD_4_on ()
    ipc.control(PMDGBaseVariable + 119, 1)
    DspShow ("4FWD", "on", "FUEL 4", "FWD on")
end

function OH_FUEL_PUMP_FWD_4_off ()
    ipc.control(PMDGBaseVariable + 119, 0)
    DspShow ("4FWD", "off", "FUEL 4", "FWD off")
end

function OH_FUEL_PUMP_FWD_4_toggle ()
    if _tl("switch_119_74X", 0) then
       OH_FUEL_PUMP_FWD_4_on ()
	else
       OH_FUEL_PUMP_FWD_4_off ()
	end
end

function OH_FUEL_PUMP_AFT_4_on ()
    ipc.control(PMDGBaseVariable + 125, 1)
    DspShow ("4AFT", "on", "FUEL 4", "AFT on")
end

function OH_FUEL_PUMP_AFT_4_off ()
    ipc.control(PMDGBaseVariable + 125, 0)
    DspShow ("4AFT", "off", "FUEL 4", "AFT off")
end

function OH_FUEL_PUMP_AFT_4_toggle ()
    if _tl("switch_125_74X", 0) then
       OH_FUEL_PUMP_AFT_4_on ()
	else
       OH_FUEL_PUMP_AFT_4_off ()
	end
end

function OH_FUEL_PUMPS_4_on ()
    OH_FUEL_PUMP_FWD_4_on ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_4_on ()
end

function OH_FUEL_PUMPS_4_off ()
    OH_FUEL_PUMP_FWD_4_off ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_4_off ()
end

function OH_FUEL_PUMPS_4_toggle ()
    OH_FUEL_PUMP_FWD_4_toggle ()
    _sleep(50,100)
    OH_FUEL_PUMP_AFT_4_toggle ()
end

-- $$ ALL Main

function OH_FUEL_PUMPS_MAIN_on ()
    OH_FUEL_PUMPS_1_on ()
    _sleep(50,100)
    OH_FUEL_PUMPS_2_on ()
    _sleep(50,100)
    OH_FUEL_PUMPS_3_on ()
    _sleep(50,100)
    OH_FUEL_PUMPS_4_on ()
end

function OH_FUEL_PUMPS_MAIN_off ()
    OH_FUEL_PUMPS_1_off ()
    _sleep(50,100)
    OH_FUEL_PUMPS_2_off ()
    _sleep(50,100)
    OH_FUEL_PUMPS_3_off ()
    _sleep(50,100)
    OH_FUEL_PUMPS_4_off ()
end

function OH_FUEL_PUMPS_MAIN_toggle ()
    OH_FUEL_PUMPS_1_toggle ()
    _sleep(50,100)
    OH_FUEL_PUMPS_2_toggle ()
    _sleep(50,100)
    OH_FUEL_PUMPS_3_toggle ()
    _sleep(50,100)
    OH_FUEL_PUMPS_4_toggle ()
end

-- ## Overhead Anti Ice ###############
-- $$ Window Anti Ice
function EVT_OH_ICE_WINDOW_HEAT_L_on ()
    ipc.control(PMDGBaseVariable + 141, 1)
    DspShow ("WICE", "L on")
end

function EVT_OH_ICE_WINDOW_HEAT_L_off ()
    ipc.control(PMDGBaseVariable + 141, 0)
    DspShow ("WICE", "Loff")
end

function EVT_OH_ICE_WINDOW_HEAT_L_toggle ()
	if _tl("switch_141_74X", 0) then
       EVT_OH_ICE_WINDOW_HEAT_L_on ()
	else
       EVT_OH_ICE_WINDOW_HEAT_L_off ()
	end
end


function EVT_OH_ICE_WINDOW_HEAT_R_on ()
    ipc.control(PMDGBaseVariable + 142, 1)
    DspShow ("WICE", "R on")
end

function EVT_OH_ICE_WINDOW_HEAT_R_off ()
    ipc.control(PMDGBaseVariable + 142, 0)
    DspShow ("WICE", "Roff")
end

function EVT_OH_ICE_WINDOW_HEAT_R_toggle ()
	if _tl("switch_142_74X", 0) then
       EVT_OH_ICE_WINDOW_HEAT_R_on ()
	else
       EVT_OH_ICE_WINDOW_HEAT_R_off ()
	end
end


function EVT_OH_ICE_WINDOW_HEAT_both_on ()
    EVT_OH_ICE_WINDOW_HEAT_L_on ()
    EVT_OH_ICE_WINDOW_HEAT_R_on ()
end

function EVT_OH_ICE_WINDOW_HEAT_both_off ()
    EVT_OH_ICE_WINDOW_HEAT_L_off ()
    EVT_OH_ICE_WINDOW_HEAT_R_off ()
end

function EVT_OH_ICE_WINDOW_HEAT_both_toggle ()
    EVT_OH_ICE_WINDOW_HEAT_L_toggle ()
    EVT_OH_ICE_WINDOW_HEAT_R_toggle ()
end


-- ## Overhead - Wipers ###############
-- $$ wiper L

function EVT_OH_WIPER_SWITCH_L_off ()
    ipc.control(PMDGBaseVariable + 136, 0)
    DspShow ("WIPL", "off")
end

function EVT_OH_WIPER_SWITCH_L_int ()
    ipc.control(PMDGBaseVariable + 136, 1)
    DspShow ("WIPL", "int")
end

function EVT_OH_WIPER_SWITCH_L_lo ()
    ipc.control(PMDGBaseVariable + 136, 2)
    DspShow ("WIPL", "lo")
end

function EVT_OH_WIPER_SWITCH_L_hi ()
    ipc.control(PMDGBaseVariable + 136, 3)
    DspShow ("WIPL", "hi")
end

function EVT_OH_WIPER_SWITCH_L_inc ()
    WIPL = ipc.readLvar("switch_136_74X")
    if WIPL == 0 then
        EVT_OH_WIPER_SWITCH_L_int ()
    elseif WIPL == 10 then
        EVT_OH_WIPER_SWITCH_L_lo ()
    elseif WIPL == 20 then
        EVT_OH_WIPER_SWITCH_L_hi ()
    end
end

function EVT_OH_WIPER_SWITCH_L_dec ()
    WIPL = ipc.readLvar("switch_136_74X")
    if WIPL == 30 then
        EVT_OH_WIPER_SWITCH_L_lo ()
    elseif WIPL == 20 then
        EVT_OH_WIPER_SWITCH_L_int ()
    elseif WIPL == 10 then
        EVT_OH_WIPER_SWITCH_L_off ()
    end
end

function EVT_OH_WIPER_SWITCH_L_toggle ()
	if _tl("switch_136_74X", 0) then
       EVT_OH_WIPER_SWITCH_L_lo ()
	else
       EVT_OH_WIPER_SWITCH_L_off ()
	end
end


-- $$ wiper R

function EVT_OH_WIPER_SWITCH_R_off ()
    ipc.control(PMDGBaseVariable + 139, 0)
    DspShow ("WIPR", "off")
end

function EVT_OH_WIPER_SWITCH_R_int ()
    ipc.control(PMDGBaseVariable + 139, 1)
    DspShow ("WIPR", "int")
end

function EVT_OH_WIPER_SWITCH_R_lo ()
    ipc.control(PMDGBaseVariable + 139, 2)
    DspShow ("WIPR", "lo")
end

function EVT_OH_WIPER_SWITCH_R_hi ()
    ipc.control(PMDGBaseVariable + 139, 3)
    DspShow ("WIPR", "hi")
end

function EVT_OH_WIPER_SWITCH_R_inc ()
    WIPL = ipc.readLvar("switch_139_74X")
    if WIPL == 0 then
        EVT_OH_WIPER_SWITCH_R_int ()
    elseif WIPL == 10 then
        EVT_OH_WIPER_SWITCH_R_lo ()
    elseif WIPL == 20 then
        EVT_OH_WIPER_SWITCH_R_hi ()
    end
end

function EVT_OH_WIPER_SWITCH_R_dec ()
    WIPL = ipc.readLvar("switch_139_74X")
    if WIPL == 30 then
        EVT_OH_WIPER_SWITCH_R_lo ()
    elseif WIPL == 20 then
        EVT_OH_WIPER_SWITCH_R_int ()
    elseif WIPL == 10 then
        EVT_OH_WIPER_SWITCH_R_off ()
    end
end

function EVT_OH_WIPER_SWITCH_R_toggle ()
	if _tl("switch_139_74X", 0) then
       EVT_OH_WIPER_SWITCH_R_lo ()
	else
       EVT_OH_WIPER_SWITCH_R_off ()
	end
end

-- $$ wiper both

function EVT_OH_WIPER_SWITCH_both_off ()
    EVT_OH_WIPER_SWITCH_L_off ()
    _sleep(200,400)
    EVT_OH_WIPER_SWITCH_R_off ()
end

function EVT_OH_WIPER_SWITCH_both_int ()
    EVT_OH_WIPER_SWITCH_L_int ()
    _sleep(200,400)
    EVT_OH_WIPER_SWITCH_R_int ()
end

function EVT_OH_WIPER_SWITCH_both_lo ()
    EVT_OH_WIPER_SWITCH_L_lo ()
    _sleep(200,400)
    EVT_OH_WIPER_SWITCH_R_lo ()
end

function EVT_OH_WIPER_SWITCH_both_hi ()
    EVT_OH_WIPER_SWITCH_L_hi ()
    _sleep(200,400)
    EVT_OH_WIPER_SWITCH_R_hi ()
end

function EVT_OH_WIPER_SWITCH_both_inc ()
    EVT_OH_WIPER_SWITCH_L_inc ()
    _sleep(200,400)
    EVT_OH_WIPER_SWITCH_R_inc ()
end

function EVT_OH_WIPER_SWITCH_both_dec ()
    EVT_OH_WIPER_SWITCH_L_dec ()
    _sleep(200,400)
    EVT_OH_WIPER_SWITCH_R_dec ()
end

-- ## Overhead Air Conditioning ###############

function OH_AIRCOND_PACK_SWITCH_L_off ()
    ipc.control(PMDGBaseVariable + 190, 0)
    DspShow ("PACK", "Loff", "PACK L", "off")
end

function OH_AIRCOND_PACK_SWITCH_L_norm ()
    ipc.control(PMDGBaseVariable + 190, 1)
    DspShow ("PACK", "Lnrm", "PACK L", "norm")
end

function OH_AIRCOND_PACK_SWITCH_L_a ()
    ipc.control(PMDGBaseVariable + 190, 2)
    DspShow ("PACK", "L A", "PACK L", "A")
end

function OH_AIRCOND_PACK_SWITCH_L_b ()
    ipc.control(PMDGBaseVariable + 190, 3)
    DspShow ("PACK", "L B", "PACK L", "B")
end


function OH_AIRCOND_PACK_SWITCH_L_toggle ()
	if _tl("switch_190_74X", 0) then
       OH_AIRCOND_PACK_SWITCH_L_norm ()
	else
       OH_AIRCOND_PACK_SWITCH_L_off ()
	end
end

--
function OH_AIRCOND_PACK_SWITCH_C_off ()
    ipc.control(PMDGBaseVariable + 192, 0)
    DspShow ("PACK", "Coff", "PACK C", "off")
end

function OH_AIRCOND_PACK_SWITCH_C_norm ()
    ipc.control(PMDGBaseVariable + 192, 1)
    DspShow ("PACK", "Cnrm", "PACK C", "norm")
end

function OH_AIRCOND_PACK_SWITCH_C_a ()
    ipc.control(PMDGBaseVariable + 192, 2)
    DspShow ("PACK", "C A", "PACK C", "A")
end

function OH_AIRCOND_PACK_SWITCH_C_b ()
    ipc.control(PMDGBaseVariable + 192, 3)
    DspShow ("PACK", "C B", "PACK C", "B")
end


function OH_AIRCOND_PACK_SWITCH_C_toggle ()
	if _tl("switch_192_74X", 0) then
       OH_AIRCOND_PACK_SWITCH_C_norm ()
	else
       OH_AIRCOND_PACK_SWITCH_C_off ()
	end
end
--

function OH_AIRCOND_PACK_SWITCH_R_off ()
    ipc.control(PMDGBaseVariable + 191, 0)
    DspShow ("PACK", "Roff", "PACK R", "off")
end

function OH_AIRCOND_PACK_SWITCH_R_norm ()
    ipc.control(PMDGBaseVariable + 191, 1)
    DspShow ("PACK", "Rnrm", "PACK R", "norm")
end

function OH_AIRCOND_PACK_SWITCH_R_a ()
    ipc.control(PMDGBaseVariable + 191, 2)
    DspShow ("PACK", "R A", "PACK R", "A")
end

function OH_AIRCOND_PACK_SWITCH_R_b ()
    ipc.control(PMDGBaseVariable + 191, 3)
    DspShow ("PACK", "R B", "PACK R", "B")
end


function OH_AIRCOND_PACK_SWITCH_R_toggle ()
	if _tl("switch_191_74X", 0) then
       OH_AIRCOND_PACK_SWITCH_R_norm ()
	else
       OH_AIRCOND_PACK_SWITCH_R_off ()
	end
end

--




function OH_AIRCOND_PACK_SWITCH_ALL_toggle ()
    OH_AIRCOND_PACK_SWITCH_L_toggle ()
    _sleep(100,200)
    OH_AIRCOND_PACK_SWITCH_C_toggle ()
    _sleep(100,200)
    OH_AIRCOND_PACK_SWITCH_R_toggle ()
end

function OH_AIRCOND_PACK_ALL_off ()
    OH_AIRCOND_PACK_SWITCH_L_off ()
    _sleep(100,200)
    OH_AIRCOND_PACK_SWITCH_C_off ()
    _sleep(100,200)
    OH_AIRCOND_PACK_SWITCH_R_off ()
end

function OH_AIRCOND_PACK_ALL_norm ()
    OH_AIRCOND_PACK_SWITCH_L_norm ()
    _sleep(100,200)
    OH_AIRCOND_PACK_SWITCH_C_norm ()
    _sleep(100,200)
    OH_AIRCOND_PACK_SWITCH_R_norm ()
end

-- ## Overhead MISC ###############

function EMER_LIGHT_SWITCHANDGUARD_on ()
    EMER_LIGHT_SWITCH_on ()
    _sleep(50, 100)
    EMER_LIGHT_GUARD_close ()
end

function EMER_LIGHT_SWITCHANDGUARD_off ()
    EMER_LIGHT_GUARD_open ()
    _sleep(250, 500)
    EMER_LIGHT_SWITCH_off ()
end

function EMER_LIGHT_SWITCHANDGUARD_toggle ()
    if _tl("switch_061_74X", 0) then
       EMER_LIGHT_SWITCHANDGUARD_on ()
	else
       EMER_LIGHT_SWITCHANDGUARD_off ()
	end
end


function EMER_LIGHT_SWITCH_on ()
    ipc.control(PMDGBaseVariable + 61, 1)
    DspShow ("EMER", "on")
end

function EMER_LIGHT_SWITCH_off ()
    ipc.control(PMDGBaseVariable + 61, 0)
    DspShow ("EMER", "off")
end

function EMER_LIGHT_SWITCH_toggle ()
	if _tl("switch_061_74X", 0) then
       EMER_LIGHT_SWITCH_on ()
	else
       EMER_LIGHT_SWITCH_off ()
	end
end


function EMER_LIGHT_GUARD_open ()
    ipc.control(PMDGBaseVariable + 10061, 1)
end

function EMER_LIGHT_GUARD_close ()
    ipc.control(PMDGBaseVariable + 10061, 0)
end

function EMER_LIGHT_GUARD_toggle ()
	if _tl("switch_10061_74X", 0) then
       EMER_LIGHT_GUARD_open ()
	else
       EMER_LIGHT_GUARD_close ()
	end
end

-- ## Gear ###############

function GEAR_LEVER_dn ()
   ipc.control(66587, 76801)
   DspShow ("Gear", "down")
end

function GEAR_LEVER_up ()
   ipc.control(66587, 76802)
   DspShow ("Gear", "up")
end


-- ## Trim ###############

function B747_Elevator_Trim_up ()

    ipc.control(65615)
    B747_Elevator_Trim_show ()
end

function B747_Elevator_Trim_dn ()

    ipc.control(65607)
    B747_Elevator_Trim_show ()
end


function B747_Elevator_Trim_upfast ()

    i = 0
    while i <= 4 do
    ipc.control(65615)
    i = i + 1
    end
    B747_Elevator_Trim_show ()
end

function B747_Elevator_Trim_dnfast ()

    i = 0
    while i <= 4 do
    ipc.control(65607)
    i = i + 1
    end
    B747_Elevator_Trim_show ()
end

-- ## 748 CHKL Cursor Control ###############

function CHKL_Cursor_inc ()
    ipc.control(66587, 99601)
end

function CHKL_Cursor_dec ()
    ipc.control(66587, 99602)
end

function CHKL_Cursor_sel ()
    ipc.control(66587, 99501)
    DspShow ("CHKL", "sel")
end


-- $$ MCP Combo VS CHKL Curser

function MCPVS_or_CHKLCur_switch ()
    VSCHKLstat = ipc.get("VSCHKL")
    acftname = ipc.readSTR("3D00", 35)
    if string.find(acftname,"747-8",0,true) then acftVar = 1 else acftVar = 0 end

    if VSCHKLstat == 0 and acftVar == 1 then
        ipc.set("VSCHKL", 1)
        DspShow ("set", "CHKL")
    else
        ipc.set("VSCHKL", 0)
        DspShow ("set", "VS")
    end
end


function MCP_VS_CHKL_SEL_inc ()
    VSCHKLstat = ipc.get("VSCHKL")
    if VSCHKLstat == 0 then
        MCP_VS_SELECTOR_inc ()
    elseif VSCHKLstat == 1 then
        CHKL_Cursor_inc ()
    end
end


function MCP_VS_CHKL_SEL_dec ()
    VSCHKLstat = ipc.get("VSCHKL")
    if VSCHKLstat == 0 then
        MCP_VS_SELECTOR_dec ()
    elseif VSCHKLstat == 1 then
        CHKL_Cursor_dec ()
    end
end

function MCP_VS_CHKL_switch ()
    VSCHKLstat = ipc.get("VSCHKL")
    if VSCHKLstat == 0 then
        MCP_VS_SWITCH ()
    elseif VSCHKLstat == 1 then
        CHKL_Cursor_sel ()
    end
end





-- ## Pedestal - Control Stand ###############

function Speedbrake_armed ()
    SPa = ipc.readUB(0x6610)
    if SPa == 0 then
    ipc.control(65853)
    DspShow ("SBrk", "arm", "SPDBrake", "armed")
    end
end

function Speedbrake_armoff ()
    SPa = ipc.readUB(0x6610)
    if SPa > 0 then
    ipc.control(65853)
    DspShow ("SBrk", "off", "SPDBrake", "off")
    end
end




function ENG1_FUEL_CTRL_SWITCH_run ()
    ipc.control(PMDGBaseVariable + 968, 0)
    DspShow ("ENG1", "run")
end

function ENG1_FUEL_CTRL_SWITCH_cutoff ()
    ipc.control(PMDGBaseVariable + 968, 1)
    DspShow ("ENG1", "cut", "ENG1", "cutoff")
end

function ENG1_FUEL_CTRL_SWITCH_toggle ()
	if _tl("switch_968_74X", 100) then
       ENG1_FUEL_CTRL_SWITCH_run ()
	else
       ENG1_FUEL_CTRL_SWITCH_cutoff ()
	end
end

--

function ENG2_FUEL_CTRL_SWITCH_run ()
    ipc.control(PMDGBaseVariable + 969, 0)
    DspShow ("ENG2", "run")
end

function ENG2_FUEL_CTRL_SWITCH_cutoff ()
    ipc.control(PMDGBaseVariable + 969, 1)
    DspShow ("ENG2", "cut", "ENG2", "cutoff")
end

function ENG2_FUEL_CTRL_SWITCH_toggle ()
	if _tl("switch_969_74X", 100) then
       ENG2_FUEL_CTRL_SWITCH_run ()
	else
       ENG2_FUEL_CTRL_SWITCH_cutoff ()
	end
end



function ENG3_FUEL_CTRL_SWITCH_run ()
    ipc.control(PMDGBaseVariable + 970, 0)
    DspShow ("ENG3", "run")
end

function ENG3_FUEL_CTRL_SWITCH_cutoff ()
    ipc.control(PMDGBaseVariable + 970, 1)
    DspShow ("ENG3", "cut", "ENG3", "cutoff")
end

function ENG3_FUEL_CTRL_SWITCH_toggle ()
	if _tl("switch_970_74X", 100) then
       ENG3_FUEL_CTRL_SWITCH_run ()
	else
       ENG3_FUEL_CTRL_SWITCH_cutoff ()
	end
end



function ENG4_FUEL_CTRL_SWITCH_run ()
    ipc.control(PMDGBaseVariable + 971, 0)
    DspShow ("ENG4", "run")
end

function ENG4_FUEL_CTRL_SWITCH_cutoff ()
    ipc.control(PMDGBaseVariable + 971, 1)
    DspShow ("ENG4", "cut", "ENG4", "cutoff")
end

function ENG4_FUEL_CTRL_SWITCH_toggle ()
	if _tl("switch_971_74X", 100) then
       ENG4_FUEL_CTRL_SWITCH_run ()
	else
       ENG4_FUEL_CTRL_SWITCH_cutoff ()
	end
end




-- ## Ped Autobrake Selector ###############



function Autobrake_rto ()
    ipc.control(PMDGBaseVariable + 1102, 0)
    PMDG_Autobrake_show ()
end

function Autobrake_off ()
    ipc.control(PMDGBaseVariable + 1102, 1)
    PMDG_Autobrake_show ()
end

function Autobrake_disarm ()
    ipc.control(PMDGBaseVariable + 1102, 2)
    PMDG_Autobrake_show ()
end

function Autobrake_1 ()
    ipc.control(PMDGBaseVariable + 1102, 3)
    PMDG_Autobrake_show ()
end

function Autobrake_2 ()
    ipc.control(PMDGBaseVariable + 1102, 4)
    PMDG_Autobrake_show ()
end

function Autobrake_3 ()
    ipc.control(PMDGBaseVariable + 1102, 5)
    PMDG_Autobrake_show ()
end

function Autobrake_4 ()
    ipc.control(PMDGBaseVariable + 1102, 6)
    PMDG_Autobrake_show ()
end

function Autobrake_max ()
    ipc.control(PMDGBaseVariable + 1102, 7)
    PMDG_Autobrake_show ()
end

function Autobrake_inc ()
    ipc.control(PMDGBaseVariable + 1102, 256)
    PMDG_Autobrake_show ()
end

function Autobrake_dec ()
    ipc.control(PMDGBaseVariable + 1102, 128)
    PMDG_Autobrake_show ()
end

-- ## Ped TCAS ###############

-- $$ TCAS Selector

function PMDG_TCAS_show ()
    ipc.sleep(10)
    TcasVar = ipc.readLvar("switch_1296_74X")
    acftname = ipc.readSTR("3D00", 35)
    if string.find(acftname,"747-4",0,true) then

    if TcasVar == 0 then TcasTxt = "STBY"
    elseif TcasVar == 10 then TcasTxt = "ALT"
    elseif TcasVar == 20 then TcasTxt = "XPDR"
    elseif TcasVar == 30 then TcasTxt = "TA"
    elseif TcasVar == 40 then TcasTxt = "TARA"
    end

    elseif string.find(acftname,"747-8",0,true) then

    if TcasVar == 0 then TcasTxt = "STBY"
    elseif TcasVar == 10 then TcasTxt = "XPDR"
    elseif TcasVar == 20 then TcasTxt = "TA"
    elseif TcasVar == 30 then TcasTxt = "TARA"
    elseif TcasVar == 40 then TcasTxt = "ALT"
    end

    end

    if _MCP1() then
            DspShow ("TCAS", TcasTxt)
        else
            DspRadioShort(TcasTxt)
    end
end


function TCAS_MODE_stby ()
	ipc.control(PMDGBaseVariable +1296,0)
    PMDG_TCAS_show ()
end

function TCAS_MODE_alt ()
	ipc.control(PMDGBaseVariable +1296,1)
    PMDG_TCAS_show ()
end

function TCAS_MODE_xpndr ()
	ipc.control(PMDGBaseVariable +1296,2)
    PMDG_TCAS_show ()
end

function TCAS_MODE_TA ()
	ipc.control(PMDGBaseVariable +1296,3)
    PMDG_TCAS_show ()
end

function TCAS_MODE_TARA ()
	ipc.control(PMDGBaseVariable +1296,4)
    PMDG_TCAS_show ()
end

function TCAS_MODE_inc ()
	ipc.control(PMDGBaseVariable +1296,256)
    PMDG_TCAS_show ()
end

function TCAS_MODE_dec ()
	ipc.control(PMDGBaseVariable +1296,128)
    PMDG_TCAS_show ()
end

function TCAS_TEST ()
	ipc.control(PMDGBaseVariable +1297,1)
    DspShow ("TCAS", "on", "TCAS", "on")

end

-- ## Signs ###############

function NoSmokingSelector_show ()
    ipc.sleep(10)
    NoSm = ipc.readLvar("switch_1100_74X")

    if NoSm == 0 then NoSmTxt = "off"
    elseif NoSm == 50 then NoSmTxt = "auto"
    elseif NoSm == 100 then NoSmTxt = "on"
    end
    DspShow ("Smok", NoSmTxt)
end


function NoSmokingSelector_off ()
    ipc.control(PMDGBaseVariable +1100,0)
    NoSmokingSelector_show ()
end

function NoSmokingSelector_auto ()
    ipc.control(PMDGBaseVariable +1100,1)
    NoSmokingSelector_show ()
end

function NoSmokingSelector_on ()
    ipc.control(PMDGBaseVariable +1100,2)
    NoSmokingSelector_show ()
end

function NoSmokingSelector_inc ()
    ipc.control(PMDGBaseVariable +1100,256)
    NoSmokingSelector_show ()
end

function NoSmokingSelector_dec ()
    ipc.control(PMDGBaseVariable +1100,128)
    NoSmokingSelector_show ()
end

function NoSmokingSelector_toggle ()
	if _tl("switch_1100_74X", 0) then
       NoSmokingSelector_auto ()
	else
       NoSmokingSelector_off ()
	end
end

--

function SeatBeltSelector_show ()
    ipc.sleep(10)
    SeatV = ipc.readLvar("switch_1101_74X")

    if SeatV == 0 then SeatVTxt = "off"
    elseif SeatV == 50 then SeatVTxt = "auto"
    elseif SeatV == 100 then SeatVTxt = "on"
    end
    DspShow ("Seat", SeatVTxt)
end


function SeatBeltSelector_off ()
    ipc.control(PMDGBaseVariable +1101,0)
    SeatBeltSelector_show ()
end

function SeatBeltSelector_auto ()
    ipc.control(PMDGBaseVariable +1101,1)
    SeatBeltSelector_show ()
end

function SeatBeltSelector_on ()
    ipc.control(PMDGBaseVariable +1101,2)
    SeatBeltSelector_show ()
end

function SeatBeltSelector_inc ()
    ipc.control(PMDGBaseVariable +1101,256)
    SeatBeltSelector_show ()
end

function SeatBeltSelector_dec ()
    ipc.control(PMDGBaseVariable +1101,128)
    SeatBeltSelector_show ()
end

function SeatBeltSelector_toggle ()
	if _tl("switch_1101_74X", 0) then
       SeatBeltSelector_auto ()
	else
       SeatBeltSelector_off ()
	end
end


-- ## Doors Left ###############


-- 1L
function DOOR_1L_open ()
    EXT1L = ipc.readUB(0x6C30)
    if EXT1L ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14011,1)
    DspShow ("1L", "open")

    end
end

function DOOR_1L_close ()
    EXT1L = ipc.readUB(0x6C30)
    if EXT1L == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14011,1)
    DspShow ("1L", "clse")
	end
end

function DOOR_1L_toggle ()
	if ipc.readUB(0x6C30) ~= 0 then
       DOOR_1L_open ()
	else
       DOOR_1L_close ()
	end
end

-- 2L

function DOOR_2L_open ()
    EXT2L = ipc.readUB(0x6C32)
    if EXT2L ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14013,1)
    DspShow ("2L", "open")
	end
end

function DOOR_2L_close ()
    EXT2L = ipc.readUB(0x6C32)
    if EXT2L == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14013,1)
    DspShow ("2L", "clse")
	end
end

function DOOR_2L_toggle ()
	if ipc.readUB(0x6C32) ~= 0 then
       DOOR_2L_open ()
	else
       DOOR_2L_close ()
	end
end

-- 3L

function DOOR_3L_open ()
    EXT3L = ipc.readUB(0x6C34)
    if EXT3L ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14015,1)
    DspShow ("3L", "open")
	end
end

function DOOR_3L_close ()
    EXT3L = ipc.readUB(0x6C34)
    if EXT3L == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14015,1)
    DspShow ("3L", "clse")
	end
end

function DOOR_3L_toggle ()
	if ipc.readUB(0x6C34) ~= 0 then
       DOOR_3L_open ()
	else
       DOOR_3L_close ()
	end
end

-- 4L

function DOOR_4L_open ()
    EXT4L = ipc.readUB(0x6C36)
    if EXT4L ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14017,1)
    DspShow ("4L", "open")
	end
end

function DOOR_4L_close ()
    EXT4L = ipc.readUB(0x6C36)
    if EXT4L == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14017,1)
    DspShow ("4L", "clse")
	end
end

function DOOR_4L_toggle ()
	if ipc.readUB(0x6C36) ~= 0 then
       DOOR_4L_open ()
	else
       DOOR_4L_close ()
	end
end

-- 5L

function DOOR_5L_open ()
    EXT5L = ipc.readUB(0x6C38)
    if EXT5L ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14019,1)
    DspShow ("5L", "open")
	end
end

function DOOR_5L_close ()
    EXT5L = ipc.readUB(0x6C38)
    if EXT5L == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14019,1)
    DspShow ("5L", "clse")
	end
end

function DOOR_5L_toggle ()
	if ipc.readUB(0x6C38) ~= 0 then
       DOOR_5L_open ()
	else
       DOOR_5L_close ()
	end
end

-- UPPER L

function DOOR_UPPER_L_open ()
    EXTUPPER_L = ipc.readUB(0x6C3A)
    if EXTUPPER_L ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14021,1)
    DspShow ("UP L", "open")
	end
end

function DOOR_UPPER_L_close ()
    EXTUPPER_L = ipc.readUB(0x6C3A)
    if EXTUPPER_L == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14021,1)
    DspShow ("UP L", "clse")
	end
end

function DOOR_UPPER_L_toggle ()
	if ipc.readUB(0x6C3A) ~= 0 then
       DOOR_UPPER_L_open ()
	else
       DOOR_UPPER_L_close ()
	end
end

function DOOR_ALL_L_open ()
    AircraftModel_show ()
    if ACMod == 2 or ACMod == 6 then      -- 2= 400BCF, 6 = 400F
        DOOR_1L_open ()
         _sleep(200,500)
        DOOR_5L_open ()

    else
    DOOR_1L_open ()
    _sleep(200,500)
    DOOR_2L_open ()
    _sleep(200,500)
    DOOR_3L_open ()
    _sleep(200,500)
    DOOR_4L_open ()
    _sleep(200,500)
    DOOR_5L_open ()
    end
end

function DOOR_ALL_L_close ()
    DOOR_1L_close ()
    _sleep(200,500)
    DOOR_2L_close ()
    _sleep(200,500)
    DOOR_3L_close ()
    _sleep(200,500)
    DOOR_4L_close ()
    _sleep(200,500)
    DOOR_5L_close ()
end

function DOOR_ALL_L_toggle ()
    DOOR_1L_toggle ()
    _sleep(200,500)
    DOOR_2L_toggle ()
    _sleep(200,500)
    DOOR_3L_toggle ()
    _sleep(200,500)
    DOOR_4L_toggle ()
    _sleep(200,500)
    DOOR_5L_toggle ()
end

-- GSX

function DOOR_GSX_L_open ()
    AircraftModel_show ()
    if ACMod == 2 or ACMod == 6 then      -- 2= 400BCF, 6 = 400F
        DOOR_1L_open ()


    else
    DOOR_1L_open ()
    _sleep(200,500)
    DOOR_2L_open ()
    _sleep(200,500)
    DOOR_5L_open ()
    end
end

function DOOR_GSX_L_close ()
    DOOR_1L_close ()
    _sleep(200,500)
    DOOR_2L_close ()
    _sleep(200,500)
    DOOR_5L_close ()
end

function DOOR_GSX_L_toggle ()
    DOOR_1L_toggle ()
    _sleep(200,500)
    DOOR_2L_toggle ()
    _sleep(200,500)
    DOOR_5L_toggle ()
end


-- ## Doors Right ###############

-- 1R
function DOOR_1R_open ()
    EXT1R = ipc.readUB(0x6C31)
    if EXT1R ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14012,1)
    DspShow ("1R", "open")
	end
end

function DOOR_1R_close ()
    EXT1R = ipc.readUB(0x6C31)
    if EXT1R == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14012,1)
    DspShow ("1R", "clse")
	end
end

function DOOR_1R_toggle ()
	if ipc.readUB(0x6C31) ~= 0 then
       DOOR_1R_open ()
	else
       DOOR_1R_close ()
	end
end

-- 2R

function DOOR_2R_open ()
    EXT2R = ipc.readUB(0x6C33)
    if EXT2R ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14014,1)
    DspShow ("2R", "open")
	end
end

function DOOR_2R_close ()
    EXT2R = ipc.readUB(0x6C33)
    if EXT2R == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14014,1)
    DspShow ("2R", "clse")
	end
end

function DOOR_2R_toggle ()
	if ipc.readUB(0x6C33) ~= 0 then
       DOOR_2R_open ()
	else
       DOOR_2R_close ()
	end
end

-- 3R

function DOOR_3R_open ()
    EXT3R = ipc.readUB(0x6C35)
    if EXT3R ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14016,1)
    DspShow ("3R", "open")
	end
end

function DOOR_3R_close ()
    EXT3R = ipc.readUB(0x6C35)
    if EXT3R == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14016,1)
    DspShow ("3R", "clse")
	end
end

function DOOR_3R_toggle ()
	if ipc.readUB(0x6C35) ~= 0 then
       DOOR_3R_open ()
	else
       DOOR_3R_close ()
	end
end

-- 4R

function DOOR_4R_open ()
    EXT4R = ipc.readUB(0x6C37)
    if EXT4R ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14018,1)
    DspShow ("4R", "open")
	end
end

function DOOR_4R_close ()
    EXT4R = ipc.readUB(0x6C37)
    if EXT4R == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14018,1)
    DspShow ("4R", "clse")
	end
end

function DOOR_4R_toggle ()
	if ipc.readUB(0x6C37) ~= 0 then
       DOOR_4R_open ()
	else
       DOOR_4R_close ()
	end
end

-- 5R

function DOOR_5R_open ()
    EXT5R = ipc.readUB(0x6C39)
    if EXT5R ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14020,1)
    DspShow ("5R", "open")
	end
end

function DOOR_5R_close ()
    EXT5R = ipc.readUB(0x6C39)
    if EXT5R == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14020,1)
    DspShow ("5R", "clse")
	end
end

function DOOR_5R_toggle ()
	if ipc.readUB(0x6C39) ~= 0 then
       DOOR_5R_open ()
	else
       DOOR_5R_close ()
	end
end


-- UPPER R

function DOOR_UPPER_R_open ()
    EXTUPPER_R = ipc.readUB(0x6C3B)
    if EXTUPPER_R ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14022,1)
    DspShow ("UP R", "open")
	end
end

function DOOR_UPPER_R_close ()
    EXTUPPER_R = ipc.readUB(0x6C3B)
    if EXTUPPER_R == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14022,1)
    DspShow ("UP R", "clse")
	end
end

function DOOR_UPPER_R_toggle ()
	if ipc.readUB(0x6C3B) ~= 0 then
       DOOR_UPPER_R_open ()
	else
       DOOR_UPPER_R_close ()
	end
end

function DOOR_ALL_R_open ()
    AircraftModel_show ()
    if ACMod == 2 or ACMod == 6 then      -- 2= 400BCF, 6 = 400F


    else
    DOOR_1R_open ()
    _sleep(200,500)
    DOOR_2R_open ()
    _sleep(200,500)
    DOOR_3R_open ()
    _sleep(200,500)
    DOOR_4R_open ()
    _sleep(200,500)
    DOOR_5R_open ()
    end
end

function DOOR_ALL_R_close ()
    DOOR_1R_close ()
    _sleep(200,500)
    DOOR_2R_close ()
    _sleep(200,500)
    DOOR_3R_close ()
    _sleep(200,500)
    DOOR_4R_close ()
    _sleep(200,500)
    DOOR_5R_close ()
end

function DOOR_ALL_R_toggle ()
    DOOR_1R_toggle ()
    _sleep(200,500)
    DOOR_2R_toggle ()
    _sleep(200,500)
    DOOR_3R_toggle ()
    _sleep(200,500)
    DOOR_4R_toggle ()
    _sleep(200,500)
    DOOR_5R_toggle ()
end

-- GSX

function DOOR_GSX_R_open ()
    AircraftModel_show ()
    if ACMod == 2 or ACMod == 6 then      -- 2= 400BCF, 6 = 400F


    else
    DOOR_1R_open ()
    _sleep(200,500)
    DOOR_5R_open ()
    end
end

function DOOR_GSX_R_close ()
    DOOR_1R_close ()
    _sleep(200,500)
    DOOR_5R_close ()
end

function DOOR_GSX_R_toggle ()
    DOOR_1R_toggle ()
    _sleep(200,500)
    DOOR_5R_toggle ()
end

-- ## Cargo ###############

-- Cargo FWD

function CARGO_FWD_open ()
    CRGFWD = ipc.readUB(0x6C3C)
    if CRGFWD ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14023,1)
    DspShow ("CFWD", "open")
	end
end

function CARGO_FWD_close ()
    CRGFWD = ipc.readUB(0x6C3C)
    if CRGFWD == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14023,1)
    DspShow ("CFWD", "clse")
	end
end

function CARGO_FWD_toggle ()
	if ipc.readUB(0x6C3C) ~= 0 then
       CARGO_FWD_open ()
	else
       CARGO_FWD_close ()
	end
end

-- Cargo AFT

function CARGO_AFT_open ()
    CRGAFT = ipc.readUB(0x6C3D)
    if CRGAFT ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14024,1)
    DspShow ("CAFT", "open")
	end
end

function CARGO_AFT_close ()
    CRGAFT = ipc.readUB(0x6C3D)
    if CRGAFT == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14024,1)
    DspShow ("CAFT", "clse")
	end
end

function CARGO_AFT_toggle ()
	if ipc.readUB(0x6C3D) ~= 0 then
       CARGO_AFT_open ()
	else
       CARGO_AFT_close ()
	end
end

-- Cargo BULK

function CARGO_BULK_open ()
    CRGBULK = ipc.readUB(0x6C3E)
    if CRGBULK ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14025,1)
    DspShow ("CBLK", "open")
	end
end

function CARGO_BULK_close ()
    CRGBULK = ipc.readUB(0x6C3E)
    if CRGBULK == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14025,1)
    DspShow ("CBLK", "clse")
	end
end

function CARGO_BULK_toggle ()
	if ipc.readUB(0x6C3E) ~= 0 then
       CARGO_BULK_open ()
	else
       CARGO_BULK_close ()
	end
end

-- Cargo SIDE

function CARGO_SIDE_open ()
    CRGSIDE = ipc.readUB(0x6C3F)
    if CRGSIDE ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14026,1)
    DspShow ("CSDE", "open")
	end
end

function CARGO_SIDE_close ()
    CRGSIDE = ipc.readUB(0x6C3F)
    if CRGSIDE == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14026,1)
    DspShow ("CSDE", "clse")
	end
end

function CARGO_SIDE_toggle ()
	if ipc.readUB(0x6C3F) ~= 0 then
       CARGO_SIDE_open ()
	else
       CARGO_SIDE_close ()
	end
end

-- Cargo NOSE

function CARGO_NOSE_open ()
    CRGNOSE = ipc.readUB(0x6C40)
    if CRGNOSE ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14027,1)
    DspShow ("CNSE", "open")
	end
end

function CARGO_NOSE_close ()
    CRGNOSE = ipc.readUB(0x6C40)
    if CRGNOSE == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14027,1)
    DspShow ("CNSE", "clse")
	end
end

function CARGO_NOSE_toggle ()
	if ipc.readUB(0x6C40) ~= 0 then
       CARGO_NOSE_open ()
	else
       CARGO_NOSE_close ()
	end
end

function CARGO_ALL_open ()
    AircraftModel_show ()
    if ACMod == 1 or ACMod == 4 or ACMod == 5 or ACMod == 7 then      -- 1 = 400, 4 = 400D, 5 = 400ER, 7 = 400ERF
        CARGO_FWD_open ()
        _sleep(200,500)
        CARGO_AFT_open ()
        _sleep(200,500)
        CARGO_BULK_open ()
    elseif ACMod == 2 or ACMod == 3 then      -- 2 = 400BCF, 3 = 300M
        CARGO_SIDE_open ()
        _sleep(200,500)
        CARGO_FWD_open ()
        _sleep(200,500)
        CARGO_AFT_open ()
        _sleep(200,500)
        CARGO_BULK_open ()
    else
    CARGO_SIDE_open ()
    _sleep(200,500)
    CARGO_FWD_open ()
    _sleep(200,500)
    CARGO_AFT_open ()
    _sleep(200,500)
    CARGO_BULK_open ()
    _sleep(200,500)
    CARGO_NOSE_open ()
    end
end

function CARGO_ALL_close ()
    CARGO_SIDE_close ()
    _sleep(200,500)
    CARGO_FWD_close ()
    _sleep(200,500)
    CARGO_AFT_close ()
    _sleep(200,500)
    CARGO_BULK_close ()
    _sleep(200,500)
    CARGO_NOSE_close ()
end

function CARGO_ALL_toggle ()
    CARGO_SIDE_toggle ()
    _sleep(200,500)
    CARGO_FWD_toggle ()
    _sleep(200,500)
    CARGO_AFT_toggle ()
    _sleep(200,500)
    CARGO_BULK_toggle ()
    _sleep(200,500)
    CARGO_NOSE_toggle ()
end




-- ## Service Doors ###############

-- Service M_ELEC

function SVC_M_ELEC_open ()
    CRGM_ELEC = ipc.readUB(0x6C41)
    if CRGM_ELEC ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14028,1)
    DspShow ("MELC", "open")
	end
end

function SVC_M_ELEC_close ()
    CRGM_ELEC = ipc.readUB(0x6C41)
    if CRGM_ELEC == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14028,1)
    DspShow ("MELC", "clse")
	end
end

function SVC_M_ELEC_toggle ()
	if ipc.readUB(0x6C41) ~= 0 then
       SVC_M_ELEC_open ()
	else
       SVC_M_ELEC_close ()
	end
end

-- Service C_ELEC

function SVC_C_ELEC_open ()
    CRGC_ELEC = ipc.readUB(0x6C42)
    if CRGC_ELEC ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14029,1)
    DspShow ("CELC", "open")
	end
end

function SVC_C_ELEC_close ()
    CRGC_ELEC = ipc.readUB(0x6C42)
    if CRGC_ELEC == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14029,1)
    DspShow ("CELC", "clse")
	end
end

function SVC_C_ELEC_toggle ()
	if ipc.readUB(0x6C42) ~= 0 then
       SVC_C_ELEC_open ()
	else
       SVC_C_ELEC_close ()
	end
end

function SVC_BOTH_ELEC_open ()
    SVC_M_ELEC_open ()
    _sleep(200,500)
    SVC_C_ELEC_open ()
end

function SVC_BOTH_ELEC_close ()
    SVC_M_ELEC_close ()
    _sleep(200,500)
    SVC_C_ELEC_close ()
end

function SVC_BOTH_ELEC_toggle ()
    SVC_M_ELEC_toggle ()
    _sleep(200,500)
    SVC_C_ELEC_toggle ()
end



-- Service FD_OVHD

function SVC_FD_OVHD_open ()
    CRGFD_OVHD = ipc.readUB(0x6C43)
    if CRGFD_OVHD ~= 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14030,1)
    DspShow ("OVHD", "open")
	end
end

function SVC_FD_OVHD_close ()
    CRGFD_OVHD = ipc.readUB(0x6C43)
    if CRGFD_OVHD == 0 then
    	DispModeVar = ipc.get("DispModeVar")
		if DispModeVar ~= 7 then
		DSP_DOOR ()
		end
    ipc.control(PMDGBaseVariable +14030,1)
    DspShow ("OVHD", "clse")
	end
end

function SVC_FD_OVHD_toggle ()
	if ipc.readUB(0x6C43) ~= 0 then
       SVC_FD_OVHD_open ()
	else
       SVC_FD_OVHD_close ()
	end
end



-- ## Captain's CDU ###############

-- Startvariable is CDULstartVar = 810
-- edit if necessary in function InitVars


function CDU_L_LSK1L()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 0, 1)
end

function CDU_L_LSK2L()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 1, 1)
end

function CDU_L_LSK3L()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 2, 1)
end

function CDU_L_LSK4L()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 3, 1)
end

function CDU_L_LSK5L()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 4, 1)
end

function CDU_L_LSK6L()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 5, 1)
end

function CDU_L_LSK1R()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 6, 1)
end

function CDU_L_LSK2R()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 7, 1)
end

function CDU_L_LSK3R()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 8, 1)
end

function CDU_L_LSK4R()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 9, 1)
end

function CDU_L_LSK5R()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 10, 1)
end

function CDU_L_LSK6R()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 11, 1)
end

------------------

function CDU_L_INITREF()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 12, 1)
end

function CDU_L_RTE()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 13, 1)
end

function CDU_L_DEPARR()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 14, 1)
end

function CDU_L_ATC()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 15, 1)
end

function CDU_L_VNAV()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 16, 1)
end

function CDU_L_FIX()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 17, 1)
end

function CDU_L_LEGS()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 18, 1)
end

function CDU_L_HOLD()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 19, 1)
end

function CDU_L_FMCCOMM()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 20, 1)
end

function CDU_L_PROG()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 21, 1)
end

function CDU_L_EXEC()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 22, 1)
end

function CDU_L_MENU()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 23, 1)
end

function CDU_L_NAVRAD()
       -- ipc.control(PMDGBaseVariable +CDULstartVar+ 23, 1)
end

function CDU_L_PREVPAGE()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 25, 1)
end

function CDU_L_NEXTPAGE()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 26, 1)
end

function CDU_L_1()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 27, 1)
end

function CDU_L_2()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 28, 1)
end

function CDU_L_3()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 29, 1)
end

function CDU_L_4()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 30, 1)
end

function CDU_L_5()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 31, 1)
end

function CDU_L_6()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 32, 1)
end

function CDU_L_7()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 33, 1)
end

function CDU_L_8()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 34, 1)
end

function CDU_L_9()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 35, 1)
end

function CDU_L_DOT()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 36, 1)
end

function CDU_L_0()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 37, 1)
end

------

function CDU_L_PLUSMIN()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 38, 1)
end

-----------

function CDU_L_A()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 39, 1)
end

function CDU_L_B()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 40, 1)
end

function CDU_L_C()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 41, 1)
end

function CDU_L_D()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 42, 1)
end

function CDU_L_E()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 43, 1)
end

function CDU_L_F()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 44, 1)
end

function CDU_L_G()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 45, 1)
end

function CDU_L_H()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 46, 1)
end

function CDU_L_I()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 47, 1)
end

function CDU_L_J()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 48, 1)
end

function CDU_L_K()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 49, 1)
end

function CDU_L_L()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 50, 1)
end

function CDU_L_M()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 51, 1)
end

function CDU_L_N()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 52, 1)
end

function CDU_L_O()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 53, 1)
end

function CDU_L_P()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 54, 1)
end

function CDU_L_Q()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 55, 1)
end

function CDU_L_R()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 56, 1)
end

function CDU_L_S()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 57, 1)
end

function CDU_L_T()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 58, 1)
end

function CDU_L_U()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 59, 1)
end

function CDU_L_V()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 60, 1)
end

function CDU_L_W()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 61, 1)
end

function CDU_L_X()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 62, 1)
end

function CDU_L_Y()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 63, 1)
end

function CDU_L_Z()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 64, 1)
end

function CDU_L_SPACE()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 65, 1)
end

function CDU_L_DEL()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 66, 1)
end

function CDU_L_SLASH()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 67, 1)
end

function CDU_L_CLR()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 68, 1)
end



function CDU_L_BRITENESS()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 69, 100)
end








-- ## Capt CDU Pages ###############

function CDU_L_Fuel()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK1L() -- Fuel

    DspShow ("CDU1", "Fuel")
end

function CDU_L_Payload()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK2L() -- Payload

    DspShow ("CDU1", "Payl")
end

function CDU_L_Doors()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK3L() -- Doors

    DspShow ("CDU1", "Door")
end

function CDU_L_Pushback()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK4L() -- Pushback

    DspShow ("CDU1", "Push")
end

function CDU_L_CabLights()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK5L() -- CabLights

    DspShow ("CDU1", "Lght")
end

function CDU_L_GroundConn()

    CDU_L_MENU()
    ipc.sleep(2500)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK1R() -- GroundConn

    DspShow ("CDU1", "Conn")
end

function CDU_L_SVehicles()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK2R() -- Service Vehicles

    DspShow ("CDU1", "Ops")
end

function CDU_L_GroundOperations()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK3R() -- GroundOperations

    DspShow ("CDU1", "GOps")
end

function CDU_L_GroundMaint()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK4R() -- GroundMaint

    DspShow ("CDU1", "Mtnc")
end


function CDU_L_AutoCruise()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK5R() -- AutoFlight

    DspShow ("CDU1", "ACrs")
end




-- ## Capt CDU Ground Connections ###############

function CDU_L_Wheel_Chocks_on ()
    if ipc.readLvar("NGXWheelChocks") == 0 then
    CDU_L_GroundConn()
    ipc.sleep(1000)
    CDU_L_LSK6R()
    end

    DspShow ("Chks", "on", "Chocks", "on")
end

function CDU_L_Wheel_Chocks_off ()
    if ipc.readLvar("NGXWheelChocks") == 1 then
    CDU_L_GroundConn()
    ipc.sleep(1000)
    CDU_L_LSK6R()
    end

    DspShow ("Chks", "off", "Chocks", "off")
end

function CDU_L_Wheel_Chocks_toggle ()
	if _tl("NGXWheelChocks", 0) then
       CDU_L_Wheel_Chocks_on ()
	else
      CDU_L_Wheel_Chocks_off ()
	end
end




function CDU_L_ExtPower_on ()
    DspShow ("GPwr", "on", "GPwr on", "wait")
    TPUS = ipc.readLvar("7X7X_TPU_S")
    TPUD = ipc.readLvar("7X7X_TPU_D")
    GPUS = ipc.readLvar("7X7X_GPU_S")
    GPUD = ipc.readLvar("7X7X_GPU_D")
    QGP = TPUS + TPUD + GPUS + GPUD
    if QGP == 0 then
        CDU_L_GroundConn()
        ipc.sleep(1000)
        CDU_L_LSK2L()
    end
    DspShow ("GPwr", "on", "GPwr on", "wait")

end

function CDU_L_ExtPower_off ()
    DspShow ("GPwr", "off", "GPwr off", "wait")
    TPUS = ipc.readLvar("7X7X_TPU_S")
    TPUD = ipc.readLvar("7X7X_TPU_D")
    GPUS = ipc.readLvar("7X7X_GPU_S")
    GPUD = ipc.readLvar("7X7X_GPU_D")
    QGP = TPUS + TPUD + GPUS + GPUD
    if QGP > 0 then
        CDU_L_GroundConn()
        ipc.sleep(1000)
        CDU_L_LSK2L()
    end
    DspShow ("GPwr", "off", "GPwr off", "wait")

end






---

-- ## FO's CDU ###############

-- Startvariable is CDURstartVar = 810
-- edit if necessary in function InitVars


function CDU_R_LSK1L()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 0, 1)
end

function CDU_R_LSK2L()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 1, 1)
end

function CDU_R_LSK3L()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 2, 1)
end

function CDU_R_LSK4L()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 3, 1)
end

function CDU_R_LSK5L()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 4, 1)
end

function CDU_R_LSK6L()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 5, 1)
end

function CDU_R_LSK1R()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 6, 1)
end

function CDU_R_LSK2R()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 7, 1)
end

function CDU_R_LSK3R()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 8, 1)
end

function CDU_R_LSK4R()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 9, 1)
end

function CDU_R_LSK5R()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 10, 1)
end

function CDU_R_LSK6R()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 11, 1)
end

------------------

function CDU_R_INITREF()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 12, 1)
end

function CDU_R_RTE()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 13, 1)
end

function CDU_R_DEPARR()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 14, 1)
end

function CDU_R_ATC()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 15, 1)
end

function CDU_R_VNAV()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 16, 1)
end

function CDU_R_FIX()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 17, 1)
end

function CDU_R_LEGS()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 18, 1)
end

function CDU_R_HOLD()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 19, 1)
end

function CDU_R_FMCCOMM()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 20, 1)
end

function CDU_R_PROG()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 21, 1)
end

function CDU_R_EXEC()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 22, 1)
end

function CDU_R_MENU()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 23, 1)
end

function CDU_R_NAVRAD()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 24, 1)
end

function CDU_R_PREVPAGE()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 25, 1)
end

function CDU_R_NEXTPAGE()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 26, 1)
end

function CDU_R_1()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 27, 1)
end

function CDU_R_2()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 28, 1)
end

function CDU_R_3()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 29, 1)
end

function CDU_R_4()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 30, 1)
end

function CDU_R_5()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 31, 1)
end

function CDU_R_6()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 32, 1)
end

function CDU_R_7()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 33, 1)
end

function CDU_R_8()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 34, 1)
end

function CDU_R_9()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 35, 1)
end

function CDU_R_DOT()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 36, 1)
end

function CDU_R_0()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 37, 1)
end

------

function CDU_R_PLUSMIN()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 38, 1)
end

-----------

function CDU_R_A()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 39, 1)
end

function CDU_R_B()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 40, 1)
end

function CDU_R_C()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 41, 1)
end

function CDU_R_D()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 42, 1)
end

function CDU_R_E()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 43, 1)
end

function CDU_R_F()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 44, 1)
end

function CDU_R_G()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 45, 1)
end

function CDU_R_H()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 46, 1)
end

function CDU_R_I()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 47, 1)
end

function CDU_R_J()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 48, 1)
end

function CDU_R_K()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 49, 1)
end

function CDU_R_L()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 50, 1)
end

function CDU_R_M()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 51, 1)
end

function CDU_R_N()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 52, 1)
end

function CDU_R_O()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 53, 1)
end

function CDU_R_P()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 54, 1)
end

function CDU_R_Q()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 55, 1)
end

function CDU_R_R()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 56, 1)
end

function CDU_R_S()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 57, 1)
end

function CDU_R_T()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 58, 1)
end

function CDU_R_U()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 59, 1)
end

function CDU_R_V()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 60, 1)
end

function CDU_R_W()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 61, 1)
end

function CDU_R_X()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 62, 1)
end

function CDU_R_Y()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 63, 1)
end

function CDU_R_Z()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 64, 1)
end

function CDU_R_SPACE()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 65, 1)
end

function CDU_R_DEL()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 66, 1)
end

function CDU_R_SLASH()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 67, 1)
end

function CDU_R_CLR()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 68, 1)
end



function CDU_R_BRITENESS()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 69, 100)
end








-- ## FO CDU Pages ###############

function CDU_R_Fuel()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK1L() -- Fuel

    DspShow ("CDU1", "Fuel")
end

function CDU_R_Payload()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK2L() -- Payload

    DspShow ("CDU1", "Payl")
end

function CDU_R_Doors()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK3L() -- Doors

    DspShow ("CDU1", "Door")
end

function CDU_R_Pushback()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK4L() -- Pushback

    DspShow ("CDU1", "Push")
end

function CDU_R_CabLights()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK5L() -- CabLights

    DspShow ("CDU1", "Lght")
end

function CDU_R_GroundConn()

    CDU_R_MENU()
    ipc.sleep(2500)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK1R() -- GroundConn

    DspShow ("CDU1", "Conn")
end

function CDU_R_SVehicles()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK2R() -- Service Vehicles

    DspShow ("CDU1", "Ops")
end

function CDU_R_GroundOperations()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK3R() -- GroundOperations

    DspShow ("CDU1", "GOps")
end

function CDU_R_GroundMaint()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK4R() -- GroundMaint

    DspShow ("CDU1", "Mtnc")
end


function CDU_R_AutoCruise()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK5R() -- AutoFlight

    DspShow ("CDU1", "ACrs")
end


-- ## EFB Keys ###############

-- Startvariable is EFBstartVar = 1700
-- edit if necessary in function InitVars


function EFB_L_MENU ()
        ipc.control(PMDGBaseVariable +EFBstartVar+0, 1)
end

function EFB_L_BACK ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 1, 1)
end

function EFB_L_PAGE_UP ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 2, 1)
end

function EFB_L_PAGE_DOWN ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 3, 1)
end

function EFB_L_XFR ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 4, 1)
end

function EFB_L_ENTER ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 5, 1)
end

function EFB_L_ZOOM_IN ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 6, 1)
end

function EFB_L_ZOOM_OUT ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 7, 1)
end

function EFB_L_ARROW_UP ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 8, 1)
end

function EFB_L_ARROW_DOWN ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 9, 1)
end

function EFB_L_ARROW_LEFT ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 10, 1)
end

function EFB_L_ARROW_RIGHT ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 11, 1)
end

function EFB_L_LSK_1L ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 12, 1)
end

function EFB_L_LSK_2L ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 13, 1)
end

function EFB_L_LSK_3L ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 14, 1)
end

function EFB_L_LSK_4L ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 15, 1)
end

function EFB_L_LSK_5L ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 16, 1)
end

function EFB_L_LSK_6L ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 17, 1)
end

function EFB_L_LSK_7L ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 18, 1)
end

function EFB_L_LSK_8L ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 19, 1)
end

function EFB_L_LSK_1R ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 20, 1)
end

function EFB_L_LSK_2R ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 21, 1)
end

function EFB_L_LSK_3R ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 22, 1)
end

function EFB_L_LSK_4R ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 23, 1)
end

function EFB_L_LSK_5R ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 24, 1)
end

function EFB_L_LSK_6R ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 25, 1)
end

function EFB_L_LSK_7R ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 26, 1)
end

function EFB_L_LSK_8R ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 27, 1)
end

function EFB_L_BRIGHTNESS ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 28, 1)
end

function EFB_L_POWER ()
	ipc.control(PMDGBaseVariable + EFBstartVar + 29, 1)
end





-- ## FO CDU Ground Connections ###############

function CDU_R_Wheel_Chocks_on ()
    if ipc.readLvar("NGXWheelChocks") == 0 then
    CDU_R_GroundConn()
    ipc.sleep(1000)
    CDU_R_LSK6R()
    end

    DspShow ("Chks", "on", "Chocks", "on")
end

function CDU_R_Wheel_Chocks_off ()
    if ipc.readLvar("NGXWheelChocks") == 1 then
    CDU_R_GroundConn()
    ipc.sleep(1000)
    CDU_R_LSK6R()
    end

    DspShow ("Chks", "off", "Chocks", "off")
end

function CDU_R_Wheel_Chocks_toggle ()
	if _tl("NGXWheelChocks", 0) then
       CDU_R_Wheel_Chocks_on ()
	else
      CDU_R_Wheel_Chocks_off ()
	end
end




function CDU_R_ExtPower_on ()
    DspShow ("GPwr", "on", "GPwr on", "wait")
    TPUS = ipc.readLvar("7X7X_TPU_S")
    TPUD = ipc.readLvar("7X7X_TPU_D")
    GPUS = ipc.readLvar("7X7X_GPU_S")
    GPUD = ipc.readLvar("7X7X_GPU_D")
    QGP = TPUS + TPUD + GPUS + GPUD
    if QGP == 0 then
        CDU_R_GroundConn()
        ipc.sleep(1000)
        CDU_R_LSK2L()
    end
    DspShow ("GPwr", "on", "GPwr on", "wait")

end

function CDU_R_ExtPower_off ()
    DspShow ("GPwr", "off", "GPwr off", "wait")
    TPUS = ipc.readLvar("7X7X_TPU_S")
    TPUD = ipc.readLvar("7X7X_TPU_D")
    GPUS = ipc.readLvar("7X7X_GPU_S")
    GPUD = ipc.readLvar("7X7X_GPU_D")
    QGP = TPUS + TPUD + GPUS + GPUD
    if QGP > 0 then
        CDU_R_GroundConn()
        ipc.sleep(1000)
        CDU_R_LSK2L()
    end
    DspShow ("GPwr", "off", "GPwr off", "wait")

end





