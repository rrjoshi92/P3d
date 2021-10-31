-- PMDG 777
-- module Version 1.5
-- Nov 2019
-- Guenter Steiner, Emile Bax


-- ## Test ###############

function test ()
    --ipc.control(90055, 131072)
    --ipc.writeLvar("OH_ELEC_GRD_PWR_SEC_SWITCH", 1)
    --xyzvar = ipc.readLvar("OH_ELEC_GRD_PWR_SEC_SWITCH", 1)
    --ipc.control(PMDGBaseVariable+14011, 1)
    -- ipc.writeUB("6443", 1)
    ipc.control(PMDGBaseVariable +5, 0)

    DspShow ("test", xyzvar)
end



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

function PMDG_AP_SPD_show ()
    ngx_spd = ipc.readLvar("L:ngx_SPDwindow")
    if ngx_spd == nil then
        ngx_spd = 100
    end
    if ngx_spd >= 0 then
        DspSPD(ngx_spd)
    else
        DspSPDs('   ')   -- blank spd window
    end
end

function PMDG_AP_ALT_show ()
    ngx_alt = (ipc.readLvar("L:ngx_ALTwindow"))
    if ngx_alt == nil then
        ngx_alt = 10000
    else
        ngx_alt = ngx_alt/100
    end
    DspALT(ngx_alt)
end

function PMDG_AP_VS_show ()
    local vvs
    ipc.sleep(50)
    ngx_vvs = ipc.readLvar("L:ngx_VSwindow")
    if ngx_vvs == nil or ngx_vvs <= -20000 then
        ngx_vvs = "0000"
        vvs = 0
    else
        vvs = ngx_vvs
    end

    if _MCP1()  then
        local val = tostring(math.abs(vvs / 10))
        while string.len(val) < 3 do val = '0' .. val end
        if vvs == 0 then
            val = ' 00 '
        elseif vvs > 0 then
            val = '+' .. val
        else
            val = '-' .. val
        end
        DspShow (" VS ", val)
    else
        DspVVSs(ngx_vvs)
    end
end

-- ## System functions ##


function InitVars ()

    --[[
    -- GSX
    ipc.set("GSXTanker", 0)
    ipc.set("GSXBoard", 0)
    ipc.set("GSXDeboard", 0)
    ipc.set("CatManCount1", 0)
    ipc.set("CatManCount2", 0)
    ipc.set("CatPhase1", 0)
    ipc.set("CatPhase2", 0)
    GSXRefuelTestTxt = 0
    --]]

    --- CDU Start Variable numbers (do not edit)
    CDULstartVar = 328
    CDURstartVar = 401
    CDUCstartVar = 653

    CDU_R_MENU()
    CDU_C_MENU()

    ipc.set("DispModeVar", 1)
    ipc.set("DispListVar", 1)
    ipc.set("ChkListVar", 0)
    EFIS_CPT_BARO_hpa ()

    FLTALTvar = 100
    CABALTvar = 150

    mcp_crs_mode = 1
    mcp_hdg_mode = 1

    -- uncomment to disable display
    -- AutopilotDisplayBlocked ()
    -- SPD_CRS_replace = true

    AutoDisplay = false

    ngx_fd_state = -1
    ngx_at_state = -1

    ngx_flaps = ''
    ngx_flaps_cur = 0
    ngx_flaps_prev = -1
    ngx_flaps_sw_cur = 0
    ngx_flaps_sw_prev = -1

    ngx_gears = ''
    ngx_gears_cur = 0
    ngx_gears_prev = -1

    ngx_spd = 0
    ngx_hdg = 0
    ngx_alt = 0
    vvs = 0

    ngx_cmda = '_'
    ngx_cmdb = '_'
    ngx_cwsa = '_'
    ngx_cwsb = '_'

    ngx_vor = '_'
    ngx_app = '_'

    ngx_lnav = '_'
    ngx_vnav = '_'

    -- AP states
    ngx_MCP_Speed = 0
    ngx_MCP_N1 = 0
    ngx_MCP_LvlChg = 0

    ngx_MCP_VNav = 0
    ngx_MCP_LNav = 0

    ngx_MCP_HdgSel = 0
    ngx_MCP_AltHold = 0

    ngx_MCP_CMDA = 0
    ngx_MCP_CMDB = 0
    ngx_MCP_CWSA = 0
    ngx_MCP_CWSB = 0

    ngx_MCP_VORLock = 0
    ngx_MCP_App = 0

    ngx_MCP_VS = 0


    OBS1 = ipc.readLvar("L:ngx_CRSwindowL")
    OBS2 = ipc.readLvar("L:ngx_CRSwindowR")
    OnGround = ipc.readUW("0366")
    flaps_sw = ipc.readLvar('switch_507_a')


    -- Panel lights
    ipc.control(PMDGBaseVariable +2850, 0)
    ipc.control(PMDGBaseVariable +3220, 0)
    ipc.control(PMDGBaseVariable +2101, 0)

    FldIOVar = 50 --<-- set for initial brightness of panel lights


end

function InitDsp ()

    PMDG_AP_SPD_show ()

    PMDG_AP_HDG_show ()

    PMDG_AP_ALT_show ()

    PMDG_AP_VS_show ()

end



function Timer ()

    -- GSX_door_automation ()  --- comment or delete to disable



    PMDG_AP_VS_show ()

    PMDG_AP_ALT_show ()

    PMDG_AP_HDG_show ()

    PMDG_AP_SPD_show ()

    -- FD
    if ipc.readLvar('switch_202_a') ~= pmdg_fd_state then

        pmdg_fd_state = ipc.readLvar('switch_202_a')

        if pmdg_fd_state == 100 then

            DspFD(0)

        else

            DspFD(1)

        end

    end

    -- AT

        pmdg_at_state1 = ipc.readLvar('switch_204_a')
        pmdg_at_state2 = ipc.readLvar('switch_205_a')
        pmdg_at_state = pmdg_at_state1 + pmdg_at_state2

        if pmdg_at_state == 200 then

            DspAT(0)
        else
            DspAT(1)
        end




    --if OnGround == 1 and flaps_sw == 0 then
    --    PMDG_FLIGHT_INFO ()

    --elseif ipc.get("DSPmode") == 1 then

        -- show autopilot info
    --    PMDG_AP_INFO ()

    --else

    -- show flaps/gears info
    PMDG_FLIGHT_INFO ()

    --end


    -- AP MODES INDICATION --
    PMDG_AP_MODES_UPDATE ()

    -- Time Acceleration
    if ipc.readUW("0C1A") > 256 then TimeAccel_show () end

    Doors_show ()


end



function PMDG_FLIGHT_INFO ()

    -- FLAPS positions and movement
    local flaps_state1, flaps_state2, flaps_sw

    flaps_state1 = ' '
    flaps_state2 = ' '
    ngx_flaps_cur = ipc.readLvar('NGXLeftInbdTrailFlaps')
    flaps_sw = ipc.readLvar('switch_507_a')

    if flaps_sw == 0 then

        ngx_flaps = '00'

    elseif flaps_sw == 10 then

        ngx_flaps = '01'

    elseif flaps_sw == 20 then

        ngx_flaps = '05'

    elseif flaps_sw == 30 then

        ngx_flaps = '15'

    elseif flaps_sw == 40 then

        ngx_flaps = '20'

    elseif flaps_sw == 50 then

        ngx_flaps = '25'

    elseif flaps_sw == 60 then

        ngx_flaps = '30'


    end

    if ngx_flaps_cur > ngx_flaps_prev then

        flaps_state1 = ' '
        flaps_state2 = '>'

    elseif ngx_flaps_cur < ngx_flaps_prev then

        flaps_state1 = '<'
        flaps_state2 = ' '

    end

    ngx_flaps_prev = ipc.readLvar('NGXLeftInbdTrailFlaps')


    -- GEARS positions and movement
    local gears_state
    gears_state = ipc.readLvar('switch_295_a')
    if gears_state == 0 then

        ngx_gears = "UP"

    elseif gears_state == 100 then

        ngx_gears = "DN"

    end


    -- APU on?
    local APU_state
    APU_state = ipc.readLvar('7X7XAPUInlet')



    if APU_state == 0 then

        LongTxt1 = ' FL  GR'
        LongTxt2 = flaps_state1 .. ngx_flaps .. flaps_state2 .. ' ' .. ngx_gears

        ShortTxt1 = "F:" .. ngx_flaps
        ShortTxt2 = "G:" .. ngx_gears

     elseif APU_state > 10 then

        LongTxt1 = 'FL GR AP'
        LongTxt2 = ngx_flaps .. ' ' .. ngx_gears .. " U!"

        ShortTxt1 = "F:" .. ngx_flaps
        ShortTxt2 = "G:" .. ngx_gears



    end


    if _MCP2() then

    FLIGHT_INFO1 = LongTxt1
    FLIGHT_INFO2 = LongTxt2

    else

    FLIGHT_INFO1 = ShortTxt1
    FLIGHT_INFO2 = ShortTxt2

    end





end



function PMDG_AP_MODES_UPDATE ()

    -- if _MCP1 () then return end

    if (ipc.readLvar("L:ngx_MCP_Speed") ~= ngx_MCP_Speed
       or ipc.readLvar("L:ngx_MCP_N1") ~= ngx_MCP_N1)
       and not (ipc.readLvar("L:ngx_MCP_LvlChg") == 1)  then

        ngx_MCP_Speed = ipc.readLvar("L:ngx_MCP_Speed")
        ngx_MCP_N1 = ipc.readLvar("L:ngx_MCP_N1")

        if ngx_MCP_N1 == 1 then

            DspSPD_N1_on ()

        else

            DspSPD_N1_off ()

            if ngx_MCP_Speed == 1 then

                DspSPD_AP_on ()

            else

                DspSPD_AP_off ()

            end

        end

    end

    -- LVL CHG
    if ipc.readLvar("L:ngx_MCP_LvlChg") ~= ngx_MCP_LvlChg then

        ngx_MCP_LvlChg = ipc.readLvar("L:ngx_MCP_LvlChg")
        ngx_MCP_Speed = ipc.readLvar("L:ngx_MCP_Speed")
        ngx_MCP_N1 = ipc.readLvar("L:ngx_MCP_N1")

        if ngx_MCP_LvlChg == 1 then

            DspSPD_FLCH_on ()

        else

            DspSPD_FLCH_off ()

            if ngx_MCP_N1 == 1 then

                DspSPD_N1_on ()

            else

                if ngx_MCP_Speed == 1 then

                    DspSPD_AP_on ()

                else

                    DspSPD_AP_off ()

                end

            end

        end

    end

    -- LNAV
    if ipc.readLvar("L:ngx_MCP_LNav") ~= ngx_MCP_LNav then

        ngx_MCP_LNav = ipc.readLvar("L:ngx_MCP_LNav")
        ngx_MCP_HdgSel = ipc.readLvar("L:ngx_MCP_HdgSel")

        if ngx_MCP_LNav == 1 then

            DspLNAV_on ()
            ngx_lnav = 'L'

        else

            ngx_lnav = '_'
            DspLNAV_off ()

        end

        if ngx_MCP_HdgSel == 1 then

            DspHDG_AP_on ()

        else

            DspHDG_AP_off ()

        end

    else

        -- HDG
        if ipc.readLvar("L:ngx_MCP_HdgSel") ~= ngx_MCP_HdgSel then

            ngx_MCP_HdgSel = ipc.readLvar("L:ngx_MCP_HdgSel")

            if ngx_MCP_HdgSel == 1 then

                DspHDG_AP_on ()

            else

                DspHDG_AP_off ()

            end

        end

    end

    -- VNAV
    if ipc.readLvar("L:ngx_MCP_VNav") ~= ngx_MCP_VNav then

        ngx_MCP_VNav = ipc.readLvar("L:ngx_MCP_VNav")
        ngx_MCP_AltHold = ipc.readLvar("L:ngx_MCP_AltHold")

        if ngx_MCP_VNav == 1 then

            DspVNAV_on ()
            ngx_vnav = 'V'

        else

            ngx_vnav = '_'
            DspVNAV_off ()
            if ngx_MCP_AltHold == 1 then

                DspALT_AP_on ()

            else

                DspALT_AP_off ()

            end

        end

    else

        -- ALT
        if ipc.readLvar("L:ngx_MCP_AltHold") ~= ngx_MCP_AltHold then

            ngx_MCP_AltHold = ipc.readLvar("L:ngx_MCP_AltHold")

            if ngx_MCP_AltHold == 1 then

                DspALT_AP_on ()

            else

                DspALT_AP_off ()

            end

        end

    end


    -- VS
    if ipc.readLvar("L:ngx_MCP_VS") ~= ngx_MCP_VS then

        ngx_MCP_VS = ipc.readLvar("L:ngx_MCP_VS")

        if ngx_MCP_VS == 1 then

            DspVVS_AP_on ()

        else

            DspVVS_AP_off ()

        end

    end

end

function Doors_show ()

    -- door show

    Door1L = ipc.readLvar("L:7X7XCabinDoor1L")
    Door1R = ipc.readLvar("L:7X7XCabinDoor1R")
    Door2L = ipc.readLvar("L:7X7XCabinDoor2L")
    Door2R = ipc.readLvar("L:7X7XCabinDoor2R")
    Door3L = ipc.readLvar("L:7X7XCabinDoor3L")
    Door3R = ipc.readLvar("L:7X7XCabinDoor3R")
    Door4L = ipc.readLvar("L:7X7XCabinDoor4L")
    Door4R = ipc.readLvar("L:7X7XCabinDoor4R")
    Door5L = ipc.readLvar("L:7X7XCabinDoor5L")
    Door5R = ipc.readLvar("L:7X7XCabinDoor5R")
    DoorFwdCargo = ipc.readLvar("L:7X7XforwardcargoDoor")
    DoorAftCargo = ipc.readLvar("L:7X7XaftcargoDoor")
    DoorMainCargo = ipc.readLvar("L:7X7XmaincargoDoor")
    DoorBulkCargo = ipc.readLvar("L:7X7XbulkcargoDoor")
    DoorFwdAvio = ipc.readLvar("L:7X7XavionicsDoor")
    DoorEE = ipc.readLvar("L:7X7XEEDoor")

    if Door1L > 0 and Door1L < 100 then
        DoorTxtLong = "DOOR 1 L"
        DoorTxtShrt = "1 L"
        DoorMove = round(Door1L)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if Door1R > 0 and Door1R < 100 then
        DoorTxtLong = "DOOR 1 R"
        DoorTxtShrt = "1 R"
        DoorMove = round(Door1R)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if Door2L > 0 and Door2L < 100 then
        DoorTxtLong = "DOOR 2 L"
        DoorTxtShrt = "2 L"
        DoorMove = round(Door2L)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if Door2R > 0 and Door2R < 100 then
        DoorTxtLong = "DOOR 2 R"
        DoorTxtShrt = "2 R"
        DoorMove = round(Door2R)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if Door3L > 0 and Door3L < 100 then
        DoorTxtLong = "DOOR 3 L"
        DoorTxtShrt = "3 L"
        DoorMove = round(Door3L)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if Door3R > 0 and Door3R < 100 then
        DoorTxtLong = "DOOR 3 R"
        DoorTxtShrt = "3 R"
        DoorMove = round(Door3R)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if Door4L > 0 and Door4L < 100 then
        DoorTxtLong = "DOOR 4 L"
        DoorTxtShrt = "4 L"
        DoorMove = round(Door4L)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if Door4R > 0 and Door4R < 100 then
        DoorTxtLong = "DOOR 4 R"
        DoorTxtShrt = "4 R"
        DoorMove = round(Door4R)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if Door5L > 0 and Door5L < 100 then
        DoorTxtLong = "DOOR 5 L"
        DoorTxtShrt = "5 L"
        DoorMove = round(Door5L)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if Door5R > 0 and Door5R < 100 then
        DoorTxtLong = "DOOR 5 R"
        DoorTxtShrt = "5 R"
        DoorMove = round(Door5R)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    ---------------------

    if DoorFwdCargo > 0 and DoorFwdCargo < 100 then
        DoorTxtLong = "FwdCargo"
        DoorTxtShrt = "FwdC"
        DoorMove = round(DoorFwdCargo)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if DoorAftCargo > 0 and DoorAftCargo < 100 then
        DoorTxtLong = "AftCargo"
        DoorTxtShrt = "AftC"
        DoorMove = round(DoorAftCargo)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if DoorMainCargo > 0 and DoorMainCargo < 100 then
        DoorTxtLong = "MainCrgo"
        DoorTxtShrt = "Main"
        DoorMove = round(DoorMainCargo)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    ----


    if DoorBulkCargo > 0 and DoorBulkCargo < 100 then
        DoorTxtLong = "Bulk"
        DoorTxtShrt = "Bulk"
        DoorMove = round(DoorBulkCargo)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if DoorFwdAvio > 0 and DoorFwdAvio < 100 then
        DoorTxtLong = "Fwd Avio"
        DoorTxtShrt = "Avio"
        DoorMove = round(DoorFwdAvio)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end

    if DoorEE > 0 and DoorEE < 100 then
        DoorTxtLong = "Door EE"
        DoorTxtShrt = "EE"
        DoorMove = round(DoorEE)

        if _MCP2() then
        FLIGHT_INFO1 = DoorTxtLong
        FLIGHT_INFO2 = DoorMove.. "%"
        else
        FLIGHT_INFO1 = DoorTxtShrt
        FLIGHT_INFO2 = DoorMove.. "%"
    end
    end



end



-- ## Autopilot Dials ###############

function  NGX_AP_CRSL_show ()

    ipc.sleep(50)
    OBS1 = ipc.readLvar("L:ngx_CRSwindowL")

    if _MCP1 then

        DspShow("CRSL", OBS1)

    else

        DspCRS(OBS1)

    end

end

function  NGX_AP_CRSR_show ()

    ipc.sleep(50)
    OBS2 = ipc.readLvar("L:ngx_CRSwindowR")

    if _MCP1 then

        DspShow("CRSR", OBS2)

    else

        DspCRS(OBS2)

    end

end


function PMDG_AP_CRSL_inc ()

    ipc.control(70008, 16384)

    NGX_AP_CRSL_show ()

end

function PMDG_AP_CRSL_incfast ()

    local i
    for i = 1, 4 do ipc.control(70008, 16384) end

    NGX_AP_CRSL_show ()

end

function PMDG_AP_CRSL_dec ()

    ipc.control(70008, 8192)

    NGX_AP_CRSL_show ()

end

function PMDG_AP_CRSL_decfast ()

    local i
    for i = 1, 4 do ipc.control(70008, 8192) end

    NGX_AP_CRSL_show ()

end

function PMDG_AP_CRSR_inc ()

    ipc.control(70041, 16384)

    NGX_AP_CRSR_show ()

end

function PMDG_AP_CRSR_incfast ()

    local i
    for i = 1, 4 do ipc.control(70041, 16384) end

    NGX_AP_CRSR_show ()

end

function PMDG_AP_CRSR_dec ()

    ipc.control(70041, 8192)

    NGX_AP_CRSR_show ()

end

function PMDG_AP_CRSR_decfast ()

    local i
    for i = 1, 4 do ipc.control(70041, 8192) end

    NGX_AP_CRSR_show ()

end

function PMDG_AP_CRS_LR_sync ()

    -- linking to the current DME selected
    mcp_crs_mode = RADIOS_SUBMODE

end

function PMDG_AP_CRS_LR_toggle ()

    -- toggling value form 1 to 2
    -- 1 - left CRS, 2 - right CRS

    if _MCP1 then

        -- manual toggling
        mcp_crs_mode = 3 - mcp_crs_mode

    else

        -- linking to the current DME selected
        mcp_crs_mode = RADIOS_SUBMODE

    end

    if _MCP1 then

        if mcp_crs_mode == 1 then

            DspShow('CRS', 'LEFT')

        else

            DspShow('CRS', 'RGHT')

        end

    end

end

function PMDG_AP_CRS_LR_inc ()

    if mcp_crs_mode == 1 then

        NGX_AP_CRSL_inc ()

    else

        NGX_AP_CRSR_inc ()

    end
end

function PMDG_AP_CRS_LR_incfast ()

    if mcp_crs_mode == 1 then

        NGX_AP_CRSL_incfast ()

    else

        NGX_AP_CRSR_incfast ()

    end
end

function PMDG_AP_CRS_LR_dec ()

    if mcp_crs_mode == 1 then

        NGX_AP_CRSL_dec ()

    else

        NGX_AP_CRSR_dec ()

    end
end

function PMDG_AP_CRS_LR_decfast ()

    if mcp_crs_mode == 1 then

        NGX_AP_CRSL_decfast ()

    else

        NGX_AP_CRSR_decfast ()

    end
end




function PMDG_AP_SPD_inc ()

    ipc.control(69842, 256)
    PMDG_AP_SPD_show ()

end

function PMDG_AP_SPD_incfast ()

    local i
    for i = 1, 5 do ipc.control(69842, 256) end

    PMDG_AP_SPD_show ()

end

function PMDG_AP_SPD_dec ()

    ipc.control(69842, 128)

    PMDG_AP_SPD_show ()

end

function PMDG_AP_SPD_decfast ()

    local i
    for i = 1, 5 do ipc.control(69842, 128) end

    PMDG_AP_SPD_show ()

end




function PMDG_AP_HDG_BANK_toggle ()

    -- toggling value form 1 to 2
    -- 1 - HDG, 2 - BANK
    mcp_hdg_mode = 3 - mcp_hdg_mode

    if mcp_hdg_mode == 1 then

        DspShow('HDG', '--')

    else

        PMDG_AP_BANK_show ()

    end

end

function PMDG_AP_HDG_inc ()

    if mcp_hdg_mode == 1 then

        ipc.control(71812, 256)

    else

        NGX_AP_BANK_inc ()

    end
    PMDG_AP_HDG_show ()
end

function PMDG_AP_HDG_incfast ()

    if mcp_hdg_mode == 1 then

        local i
        for i = 1, 5 do ipc.control(71812, 256) end

    else

        NGX_AP_BANK_inc ()

    end
    PMDG_AP_HDG_show ()
end

function PMDG_AP_HDG_dec ()

    if mcp_hdg_mode == 1 then

        ipc.control(71812, 128)


    else

        NGX_AP_BANK_dec ()

    end
    PMDG_AP_HDG_show ()
end

function PMDG_AP_HDG_decfast ()

    if mcp_hdg_mode == 1 then

        local i
        for i = 1, 5 do ipc.control(71812, 128) end

    else

        NGX_AP_BANK_dec ()

    end
    PMDG_AP_HDG_show ()
end

function PMDG_AP_HDG_show ()

    ipc.sleep(10)
    ngx_hdg = ipc.readLvar("L:ngx_HDGwindow")
    DspHDG(ngx_hdg)

end

function PMDG_AP_BANK_show ()

    if ipc.readLvar('switch_2181_a') == 0 then

        DspShow ("BANK", "auto")

    elseif ipc.readLvar('switch_2181_a') == 10 then

        DspShow ("BANK", " 5")

    elseif ipc.readLvar('switch_2181_a') == 20 then

        DspShow ("BANK", " 10")

    elseif ipc.readLvar('switch_2181_a') == 30 then

        DspShow ("BANK", " 15")

    elseif ipc.readLvar('switch_2181_a') == 40 then

        DspShow ("BANK", " 20")

    elseif ipc.readLvar('switch_2181_a') == 50 then

        DspShow ("BANK", " 25")

    end

end

function PMDG_AP_BANK_inc ()

    ipc.control(71813, 256)
    PMDG_AP_BANK_show ()

end

function PMDG_AP_BANK_dec ()

    ipc.control(71813, 128)
    PMDG_AP_BANK_show ()

end

function PMDG_AP_ALT_inc ()

    ipc.control(71882, 256)
    PMDG_AP_ALT_show ()

end

function PMDG_AP_ALT_incfast ()

    local i
    for i = 1, 5 do ipc.control(71882, 256) end
    PMDG_AP_ALT_show ()

end

function PMDG_AP_ALT_dec ()

    ipc.control(71882, 128)
    PMDG_AP_ALT_show ()

end

function PMDG_AP_ALT_decfast ()

    local i
    for i = 1, 5 do ipc.control(71882, 128) end
    PMDG_AP_ALT_show ()

end




function PMDG_AP_VS_inc ()


    ipc.control(69854, 128)
    PMDG_AP_VS_show ()

end

function PMDG_AP_VS_dec ()

    ipc.control(69854, 256)
    PMDG_AP_VS_show ()

end






-- ## AP Buttons ###############

function PMDG_AP_FD1_on ()

    if ipc.readLvar('switch_202_a') == 100 then
    ipc.control(69834, 64)
    end
    DspShow ("FD1", "on")
end

function PMDG_AP_FD1_off ()

    if ipc.readLvar('switch_202_a') == 0 then
    ipc.control(69834, 64)
    end
    DspShow ("FD1", "off")
end

function PMDG_AP_FD1_toggle ()
	if _tl("switch_202_a", 100) then
       PMDG_AP_FD1_on ()
	else
       PMDG_AP_FD1_off ()
	end
end

---

function PMDG_AP_FD2_on ()

    if ipc.readLvar('switch_230_a') == 100 then
    ipc.control(69862, 64)
    end
    DspShow ("FD2", "on")
end

function PMDG_AP_FD2_off ()

    if ipc.readLvar('switch_230_a') == 0 then
    ipc.control(69862, 64)
    end
    DspShow ("FD2", "off")
end

function PMDG_AP_FD2_toggle ()
	if _tl("switch_230_a", 100) then
       PMDG_AP_FD2_on ()
	else
       PMDG_AP_FD2_off ()
	end
end

---

function PMDG_AP_both_FD_on ()
    PMDG_AP_FD1_on ()
    ipc.sleep(30)
    PMDG_AP_FD2_on ()
end

function PMDG_AP_both_FD_off ()
    PMDG_AP_FD1_off ()
    ipc.sleep(30)
    PMDG_AP_FD2_off ()
end

function PMDG_AP_both_FD_toggle ()
    PMDG_AP_FD1_toggle ()
    ipc.sleep(30)
    PMDG_AP_FD2_toggle ()
end

--

function PMDG_AP_AT1_on ()

    if ipc.readLvar('switch_204_a') == 100 then
    ipc.control(69836, 64)
    end
    DspShow ("AT1", "on")
end

function PMDG_AP_AT1_off ()

    if ipc.readLvar('switch_204_a') == 0 then
    ipc.control(69836, 64)
    end
    DspShow ("AT1", "off")
end

function PMDG_AP_AT1_toggle ()
	if _tl("switch_204_a", 100) then
       PMDG_AP_AT1_on ()
	else
       PMDG_AP_AT1_off ()
	end
end

--

function PMDG_AP_AT2_on ()

    if ipc.readLvar('switch_205_a') == 100 then
    ipc.control(69837, 64)
    end
    DspShow ("AT2", "on")
end

function PMDG_AP_AT2_off ()

    if ipc.readLvar('switch_205_a') == 0 then
    ipc.control(69837, 64)
    end
    DspShow ("AT2", "off")
end

function PMDG_AP_AT2_toggle ()
	if _tl("switch_205_a", 100) then
       PMDG_AP_AT2_on ()
	else
       PMDG_AP_AT2_off ()
	end
end


---

function PMDG_AP_both_AT_on ()
    PMDG_AP_AT1_on ()
    --ipc.sleep(30)
    PMDG_AP_AT2_on ()
end

function PMDG_AP_both_AT_off ()
    PMDG_AP_AT1_off ()
    --ipc.sleep(30)
    PMDG_AP_AT2_off ()
end

function PMDG_AP_both_AT_toggle ()
    PMDG_AP_AT1_toggle ()
    --ipc.sleep(30)
    PMDG_AP_AT2_toggle ()
end

----------

function PMDG_AP_TOGA ()
    ipc.control(65861, 536870912)
    DspShow ("TO", "GA")
end
--------

function PMDG_AP_L ()
    ipc.control(69835, 1)
    DspShow ("AP", "L")
end

function PMDG_AP_R ()
    ipc.control(69861, 1)
    DspShow ("AP", "R")
end

function PMDG_CLB_CON ()
    ipc.control(69838, 1)
    DspShow ("CLB", "CON")
end

function PMDG_AT ()
    ipc.control(69839, 1)
    DspShow ("A/T", "")
end

function PMDG_LNAV ()
    ipc.control(69843, 1)
    DspShow ("LNAV", "")
end

function PMDG_VNAV ()
    ipc.control(69844, 1)
    DspShow ("VNAV", "")
end

function PMDG_FLCH ()
    ipc.control(69845, 1)
    DspShow ("FLCH", "")
end

function PMDG_HDG_HOLD ()
    ipc.control(69851, 1)
    DspShow ("HDG", "HOLD")
end

function PMDG_VS_FPA ()
    ipc.control(69855, 1)
    DspShow ("VS", "FPA")
end

function PMDG_ALT_HOLD ()
    ipc.control(69858, 1)
    DspShow ("ALT", "HOLD")
end

function PMDG_LOC ()
    ipc.control(69859, 1)
    DspShow ("LOC", "")
end

function PMDG_APP ()
    ipc.control(69860, 1)
    DspShow ("APP", "")
end

function PMDG_Push_SPD ()
    ipc.control(71732, 1)
    DspShow ("SPD", "sel")
end

function PMDG_Push_HDG ()
    ipc.control(69850, 1)
    DspShow ("HDG", "sel")
end

function PMDG_Push_ALT ()
    ipc.control(71883, 1)
    DspShow ("ALT", "sel")
end



function PMDG_AP_Disengage_Bar_on ()

    if ipc.readLvar('switch_214_a') == 100 then
    ipc.control(69846, 64)
    end
    DspShow ("AP", "on")
end

function PMDG_AP_Disengage_Bar_off ()

    if ipc.readLvar('switch_214_a') == 0 then
    ipc.control(69846, 64)
    end
    DspShow ("AP", "off")
end

function PMDG_AP_Disengage_Bar_toggle ()
	if _tl("switch_214_a", 100) then
       PMDG_AP_Disengage_Bar_on ()
	else
       PMDG_AP_Disengage_Bar_off ()
	end
end


function PMDG_AP_Disengage ()
    ipc.control(65580, 536870912)
    DspShow ("AP", "soft")
end

function PMDG_AT_Disengage ()
    ipc.control(65860, 536870912)
    DspShow ("AT", "soft")
end


 -- ## Overhead Hydraulic #############
function DEMAND_ELEC1_on ()
	if ipc.readLvar("switch_35_a") ~= 100 then
	ipc.control(PMDGBaseVariable +35, 2)
	DspShow ("ELC1", "on", "HYD ELC1", "on")
	end
end

function DEMAND_ELEC1_auto ()
	if ipc.readLvar("switch_35_a") ~= 50 then
	ipc.control(PMDGBaseVariable +35, 1)
	DspShow ("ELC1", "auto", "HYD ELC1", "auto")
	end
end

function DEMAND_ELEC1_off ()
	if ipc.readLvar("switch_35_a") > 0 then
	ipc.control(PMDGBaseVariable +35, 0)
	DspShow ("ELC1", "off", "HYD ELC1", "off")
	end
end

function DEMAND_ELEC1_toggle ()
	if _tl("switch_35_a", 0) then
      DEMAND_ELEC1_auto ()
	else
      DEMAND_ELEC1_off ()
	end
end

function DEMAND_ELEC2_on ()
	if ipc.readLvar("switch_38_a") ~= 100 then
	ipc.control(PMDGBaseVariable +38, 2)
	DspShow ("ELC2", "on", "HYD ELC2", "on")
	end
end

function DEMAND_ELEC2_auto ()
	if ipc.readLvar("switch_38_a") ~= 50 then
	ipc.control(PMDGBaseVariable +38, 1)
	DspShow ("ELC2", "auto", "HYD ELC2", "auto")
	end
end

function DEMAND_ELEC2_off ()
	if ipc.readLvar("switch_38_a") > 0 then
	ipc.control(PMDGBaseVariable +38, 0)
	DspShow ("ELC2", "off", "HYD ELC2", "off")
	end
end

function DEMAND_ELEC2_toggle ()
	if _tl("switch_38_a", 0) then
      DEMAND_ELEC2_auto ()
	else
      DEMAND_ELEC2_off ()
	end
end


function C1_AIR_on ()
	if ipc.readLvar("switch_36_a") ~= 100 then
	ipc.control(PMDGBaseVariable +36, 2)
	DspShow ("AIR1", "on", "C1_AIR", "on")
	end
end

function C1_AIR_auto ()
	if ipc.readLvar("switch_36_a") ~= 50 then
	ipc.control(PMDGBaseVariable +36, 1)
	DspShow ("AIR1", "auto", "C1_AIR", "auto")
	end
end

function C1_AIR_off ()
	if ipc.readLvar("switch_36_a") > 0 then
	ipc.control(PMDGBaseVariable +36, 0)
	DspShow ("AIR1", "off", "C1_AIR", "off")
	end
end

function C1_AIR_toggle ()
	if _tl("switch_36_a", 0) then
      C1_AIR_auto ()
	else
      C1_AIR_off ()
	end
end


function C2_AIR_on ()
	if ipc.readLvar("switch_37_a") ~= 100 then
	ipc.control(PMDGBaseVariable +37, 2)
	DspShow ("AIR2", "on", "C2_AIR", "on")
	end
end

function C2_AIR_auto ()
	if ipc.readLvar("switch_37_a") ~= 50 then
	ipc.control(PMDGBaseVariable +37, 1)
	DspShow ("AIR2", "auto", "C2_AIR", "auto")
	end
end

function C2_AIR_off ()
	if ipc.readLvar("switch_37_a") > 0 then
	ipc.control(PMDGBaseVariable +37, 0)
	DspShow ("AIR2", "off", "C2_AIR", "off")
	end
end

function C2_AIR_toggle ()
	if _tl("switch_37_a", 0) then
      C2_AIR_auto ()
	else
      C2_AIR_off ()
	end
end






function HYDR_ENG1_on ()
	ipc.control(PMDGBaseVariable +39, 1)
	DspShow ("HYD1", "on", "HYDR", "ENG1 on")
end

function HYDR_ENG1_off ()
	ipc.control(PMDGBaseVariable +39, 0)
	DspShow ("HYD1", "off", "HYDR", "ENG1 off")
end

function HYDR_ENG1_toggle ()
	if _tl("switch_39_a", 0) then
       HYDR_ENG1_on ()
	else
       HYDR_ENG1_off ()
	end
end

---

function HYDR_ELECC1_on ()
	ipc.control(PMDGBaseVariable +40, 1)
	DspShow ("ELC1", "on", "HYDR", "EL C1 on")
end

function HYDR_ELECC1_off ()
	ipc.control(PMDGBaseVariable +40, 0)
	DspShow ("ELC1", "off", "HYDR", "EL C1 off")
end

function HYDR_ELECC1_toggle ()
	if _tl("switch_40_a", 0) then
       HYDR_ELECC1_on ()
	else
       HYDR_ELECC1_off ()
	end
end

---

function HYDR_ELECC2_on ()
	ipc.control(PMDGBaseVariable +41, 1)
	DspShow ("ELC2", "on", "HYDR", "EL C2 on")
end

function HYDR_ELECC2_off ()
	ipc.control(PMDGBaseVariable +41, 0)
	DspShow ("ELC2", "off", "HYDR", "EL C2 off")
end

function HYDR_ELECC2_toggle ()
	if _tl("switch_41_a", 0) then
       HYDR_ELECC2_on ()
	else
       HYDR_ELECC2_off ()
	end
end

function HYDR_ENG2_on ()
	ipc.control(PMDGBaseVariable +42, 1)
	DspShow ("HYD2", "on", "HYDR", "ENG2 on")
end

function HYDR_ENG2_off ()
	ipc.control(PMDGBaseVariable +42, 0)
	DspShow ("HYD2", "off", "HYDR", "ENG2 off")
end

function HYDR_ENG2_toggle ()
	if _tl("switch_42_a", 0) then
       HYDR_ENG2_on ()
	else
       HYDR_ENG2_off ()
	end
end

-----

function HYDR_ENG1_Both_on ()
    DEMAND_ELEC1_auto ()
    _sleep(100,200)
    HYDR_ENG1_on ()
end

function HYDR_ENG1_Both_off ()
    DEMAND_ELEC1_off ()
    _sleep(100,200)
    HYDR_ENG1_off ()
end

-----

function HYDR_ELECC1_Both_on ()
    C1_AIR_auto ()
    _sleep(100,200)
    HYDR_ELECC1_on ()
end

function HYDR_ELECC1_Both_off ()
    C1_AIR_off ()
    _sleep(100,200)
    HYDR_ELECC1_off ()
end

-----

function HYDR_ELECC2_Both_on ()
    C2_AIR_auto ()
    _sleep(100,200)
    HYDR_ELECC2_on ()
end

function HYDR_ELECC2_Both_off ()
    C2_AIR_off ()
    _sleep(100,200)
    HYDR_ELECC2_off ()
end


-----

function HYDR_ENG2_Both_on ()
    DEMAND_ELEC2_auto ()
    _sleep(100,200)
    HYDR_ENG2_on ()
end

function HYDR_ENG2_Both_off ()
    DEMAND_ELEC2_off ()
    _sleep(100,200)
    HYDR_ENG2_off ()
end





-- function ELEC1_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +40, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function ELEC1_off ()
	-- if ipc.readLvar("switch_02_a") > 0 then
	-- ipc.control(PMDGBaseVariable +40, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function ELEC1_toggle ()

-- end



-- function ELEC2_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +41, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function ELEC2_off ()
	-- if ipc.readLvar("switch_02_a") > 0 then
	-- ipc.control(PMDGBaseVariable +41, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function ELEC2_toggle ()

-- end



-- function ENG2_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +42, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function ENG2_off ()
	-- if ipc.readLvar("switch_02_a") > 0 then
	-- ipc.control(PMDGBaseVariable +42, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function ENG2_toggle ()

-- end



-- function RAM_AIR_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +43, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function RAM_AIR_off ()
	-- if ipc.readLvar("switch_02_a") > 0 then
	-- ipc.control(PMDGBaseVariable +43, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function RAM_AIR_toggle ()

-- end


-- function RAM_AIR_COVER_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +44, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function RAM_AIR_COVER_off ()
	-- if ipc.readLvar("switch_02_a") > 0 then
	-- ipc.control(PMDGBaseVariable +44, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function RAM_AIR_COVER_toggle ()

-- end



 -- ## Overhead - Electric  ###############
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



function APU_SEL_SWITCH_off ()
	if ipc.readLvar("switch_03_a") ~= 0 then
	ipc.control(PMDGBaseVariable + 3, 0)
	DspShow ("APU", "off", "APU", "off")
	end
end

function APU_SEL_SWITCH_on ()
	if ipc.readLvar("switch_03_a") ~= 50 then
	ipc.control(PMDGBaseVariable + 3, 1)
	DspShow ("APU", "on", "APU", "on")
	end
end

function APU_SEL_SWITCH_start ()
	if ipc.readLvar("switch_03_a") ~= 100 then
	ipc.control(PMDGBaseVariable + 3, 2)
	DspShow ("APU", "strt", "APU", "start")
	end
end

-----

function GRD_PWR_SEC_SWITCH_on ()
    ExtPwr2 = ipc.readUW(0x6449)
    if ExtPwr2 == 0 or ExtPwr2 == 256 then
	ipc.control(PMDGBaseVariable + 7, 1)
	DspShow ("EXT", "PWR2", "2nd on", "EXT PWR")
    end
end

function GRD_PWR_SEC_SWITCH_off ()
    ExtPwr2 = ipc.readUW(0x6449)
    if ExtPwr2 == 1 or ExtPwr2 == 257 then
	ipc.control(PMDGBaseVariable + 7, 1)
	DspShow ("EXT", "PWR2", "2nd off", "EXT PWR")
    end
end

function GRD_PWR_SEC_SWITCH_toggle ()
	if ipc.readLvar("switch_07_a") == 0 then
	ipc.control(PMDGBaseVariable + 7, 1)
	DspShow ("EXT", "PWR2", "Second", "EXT PWR")
	end
end

function GRD_PWR_PRIM_SWITCH_on ()
    ExtPwr1 = ipc.readUW(0x6449)
    if ExtPwr1 == 0 or ExtPwr1 == 1 then
	ipc.control(PMDGBaseVariable + 8, 1)
	DspShow ("EXT", "PWR1", "1st on", "EXT PWR")
    end
end

function GRD_PWR_PRIM_SWITCH_off ()
    ExtPwr1 = ipc.readUW(0x6449)
    if ExtPwr1 == 256 or ExtPwr1 == 257 then
	ipc.control(PMDGBaseVariable + 8, 1)
	DspShow ("EXT", "PWR1", "1st off", "EXT PWR")
    end
end

function GRD_PWR_PRIM_SWITCH_toggle ()
	if ipc.readLvar("switch_08_a") == 0 then
	ipc.control(PMDGBaseVariable + 8, 1)
	DspShow ("EXT", "PWR1", "primary", "EXT PWR")
	end
end

function GRD_POWER_Both_on ()
    GRD_PWR_SEC_SWITCH_on ()
    _sleep(100,150)
    GRD_PWR_PRIM_SWITCH_on ()
end

function GRD_POWER_Both_off ()
    GRD_PWR_SEC_SWITCH_off ()
    _sleep(100,150)
    GRD_PWR_PRIM_SWITCH_off ()
end

function GRD_POWER_Both_toggle ()
    GRD_PWR_SEC_SWITCH_toggle ()
    _sleep(100,150)
    GRD_PWR_PRIM_SWITCH_toggle ()
end


-- $$ Bus Ties

function L_BUS_TIE_on ()

    ipc.control(PMDGBaseVariable +5, 1)
    DspShow ("LBus", "on")
end

function L_BUS_TIE_off ()

    ipc.control(PMDGBaseVariable +5, 0)
    DspShow ("LBus", "off")
end

function L_BUS_TIE_toggle ()
	if _tl("switch_05_a", 0) then
       L_BUS_TIE_on ()
	else
       L_BUS_TIE_off ()
	end
end


--

function R_BUS_TIE_on ()

    ipc.control(PMDGBaseVariable +6, 1)
    DspShow ("RBus", "on")
end

function R_BUS_TIE_off ()

    ipc.control(PMDGBaseVariable +6, 0)
    DspShow ("RBus", "off")
end

function R_BUS_TIE_toggle ()
	if _tl("switch_06_a", 0) then
       R_BUS_TIE_on ()
	else
       R_BUS_TIE_off ()
	end
end



-- function GEN1_SWITCH_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable + 9, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function GEN2_SWITCH_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +10, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function BACKUP_GEN1_SWITCH_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +11, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function BACKUP_GEN2_SWITCH_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +12, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function DISCONNECT1_SWITCH_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +13, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end


-- function DISCONNECT1_GUARD ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +14, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end


-- function DISCONNECT2_SWITCH_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +15, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end


-- function DISCONNECT2_GUARD ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +16, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end


-- function IFE ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +17, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function CAB_UTIL ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +18, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end


-- function STBY_PWR_SWITCH_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +81, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function STBY_PWR_GUARD ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +82, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function TOWING_PWR_SWITCH_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +15, 10)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function TOWING_PWR_GUARD ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +15, 11)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function GND_TEST_SWITCH_on ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +15, 12)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function GND_TEST_GUARD ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +15, 13)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- ## Overhead External Lights ###############


function LANDING_L_on ()
	if ipc.readLvar("switch_22_a") == 0 then
	ipc.control(PMDGBaseVariable +22, 1)
	DspShow ("LL L", "on", "LandLight", "left on")
	end
end

function LANDING_L_off ()
	if ipc.readLvar("switch_22_a") == 100 then
	ipc.control(PMDGBaseVariable +22, 0)
	DspShow ("LL L", "off", "LandLight", "left off")
	end
end

function LANDING_L_toggle ()
	if _tl("switch_22_a", 0) then
      LANDING_L_on ()
	else
      LANDING_L_off ()
	end
end



---

function LANDING_NOSE_on ()
	if ipc.readLvar("switch_23_a") == 0 then
	ipc.control(PMDGBaseVariable +23, 1)
	DspShow ("NOSE", "on", "NoseLight", "on")
	end
end

function LANDING_NOSE_off ()
	if ipc.readLvar("switch_23_a") == 100 then
	ipc.control(PMDGBaseVariable +23, 0)
	DspShow ("NOSE", "off", "NoseLight", "off")
	end
end

function LANDING_NOSE_toggle ()
	if _tl("switch_23_a", 0) then
      LANDING_NOSE_on ()
	else
      LANDING_NOSE_off ()
	end
end


---

function LANDING_R_on ()
	if ipc.readLvar("switch_24_a") == 0 then
	ipc.control(PMDGBaseVariable +24, 1)
	DspShow ("LL R", "on", "LandLight", "right on")
	end
end

function LANDING_R_off ()
	if ipc.readLvar("switch_24_a") == 100 then
	ipc.control(PMDGBaseVariable +24, 0)
	DspShow ("LL R", "off", "LandLight", "right off")
	end
end

function LANDING_R_toggle ()
	if _tl("switch_24_a", 0) then
      LANDING_R_on ()
	else
      LANDING_R_off ()
	end
end

function LANDING_L_R_on ()
    LANDING_R_on ()
    _sleep(100,200)
    LANDING_L_on ()
end

function LANDING_L_R_off ()
    LANDING_R_off ()
    _sleep(100,200)
    LANDING_L_off ()
end

function LANDING_L_R_toggle ()
    LANDING_R_toggle ()
    _sleep(100,200)
    LANDING_L_toggle ()
end


---------


function LANDING_LIGHTS_on ()
    LANDING_R_on ()
    _sleep(100,200)
    LANDING_NOSE_on ()
    _sleep(100,200)
    LANDING_L_on ()
end

function LANDING_LIGHTS_off ()
    LANDING_R_off ()
    _sleep(100,200)
    LANDING_NOSE_off ()
    _sleep(100,200)
    LANDING_L_off ()
end

function LANDING_LIGHTS_toggle ()
    LANDING_R_toggle ()
    _sleep(100,200)
    LANDING_NOSE_toggle ()
    _sleep(100,200)
    LANDING_L_toggle ()
end

--

function L_TURNOFF_on ()
	if ipc.readLvar("switch_119_a") == 0 then
	ipc.control(PMDGBaseVariable +119, 1)
	DspShow ("TURN", "L on", "TURNOFF", "left on")
	end
end

function L_TURNOFF_off ()
	if ipc.readLvar("switch_119_a") == 100 then
	ipc.control(PMDGBaseVariable +119, 0)
	DspShow ("TURN", "L off", "TURNOFF", "left off")
	end
end

function L_TURNOFF_toggle ()
	if _tl("switch_119_a", 0) then
       L_TURNOFF_on ()
	else
       L_TURNOFF_off ()
	end
end

function R_TURNOFF_on ()
	if ipc.readLvar("switch_120_a") == 0 then
	ipc.control(PMDGBaseVariable +120, 1)
 DspShow ("TURN", "R on", "TURNOFF", "right on")
	end
end

function R_TURNOFF_off ()
	if ipc.readLvar("switch_120_a") == 100 then
	ipc.control(PMDGBaseVariable +120, 0)
 DspShow ("TURN", "R off", "TURNOFF", "right off")
	end
end

function R_TURNOFF_toggle ()
	if _tl("switch_120_a", 0) then
       R_TURNOFF_on ()
	else
       R_TURNOFF_off ()
	end
end




function R_L_TURNOFF_on ()
    L_TURNOFF_on ()
    _sleep(100,200)
    R_TURNOFF_on ()
end

function R_L_TURNOFF_off ()
    L_TURNOFF_off ()
    _sleep(100,200)
    R_TURNOFF_off ()
end

function R_L_TURNOFF_toggle ()
    L_TURNOFF_toggle ()
    _sleep(100,200)
    R_TURNOFF_toggle ()
end


function PMDG_Taxi_on ()
	if ipc.readLvar("switch_121_a") == 0 then
	ipc.control(PMDGBaseVariable +121, 1)
	DspShow ("Taxi", "on", "TaxiLight", "on")
	end
end

function PMDG_Taxi_off ()
	if ipc.readLvar("switch_121_a") == 100 then
	ipc.control(PMDGBaseVariable +121, 0)
	DspShow ("Taxi", "off", "TaxiLight", "off")
	end
end

function PMDG_Taxi_toggle ()
	if _tl("switch_121_a", 0) then
       PMDG_Taxi_on ()
	else
       PMDG_Taxi_off ()
	end
end


function PMDG_Strobe_on ()
    if ipc.readLvar('switch_122_a') == 0 then
    ipc.control(69754, 64)
    end
    DspShow ("Strb", "on")
end

function PMDG_Strobe_off ()
    if ipc.readLvar('switch_122_a') == 100 then
    ipc.control(69754, 64)
    end
    DspShow ("Strb", "off")
end

function PMDG_Strobe_toggle ()
	if _tl("switch_122_a", 0) then
       PMDG_Strobe_on ()
	else
       PMDG_Strobe_off ()
	end
end

--

function PMDG_BCN_on ()
    if ipc.readLvar('switch_114_a') == 0 then
    ipc.control(69746, 64)
    end
    DspShow ("BCN", "on")
end

function PMDG_BCN_off ()
    if ipc.readLvar('switch_114_a') == 100 then
    ipc.control(69746, 64)
    end
    DspShow ("BCN", "off")
end

function PMDG_BCN_toggle ()
	if _tl("switch_114_a", 0) then
       PMDG_BCN_on ()
	else
       PMDG_BCN_off ()
	end
end

--

function PMDG_NAV_on ()
    if ipc.readLvar('switch_115_a') == 0 then
    ipc.control(69747, 64)
    end
    DspShow ("NAV", "on")
end

function PMDG_NAV_off ()
    if ipc.readLvar('switch_115_a') == 100 then
    ipc.control(69747, 64)
    end
    DspShow ("NAV", "off")
end

function PMDG_NAV_toggle ()
	if _tl("switch_115_a", 0) then
       PMDG_NAV_on ()
	else
       PMDG_NAV_off ()
	end
end

--

function PMDG_Logo_on ()
    if ipc.readLvar('switch_116_a') == 0 then
    ipc.control(69748, 64)
    end
    DspShow ("Logo", "on")
end

function PMDG_Logo_off ()
    if ipc.readLvar('switch_116_a') == 100 then
    ipc.control(69748, 64)
    end
    DspShow ("Logo", "off")
end

function PMDG_Logo_toggle ()
	if _tl("switch_116_a", 0) then
       PMDG_Logo_on ()
	else
       PMDG_Logo_off ()
	end
end

--

function PMDG_Wing_on ()
    if ipc.readLvar('switch_117_a') == 0 then
    ipc.control(69749, 64)
    end
    DspShow ("Wing", "on")
end

function PMDG_Wing_off ()
    if ipc.readLvar('switch_117_a') == 100 then
    ipc.control(69749, 64)
    end
    DspShow ("Wing", "off")
end

function PMDG_Wing_toggle ()
	if _tl("switch_117_a", 0) then
       PMDG_Wing_on ()
	else
       PMDG_Wing_off ()
	end
end




-- ## Overhead Internal Lights ###############


function PANEL_LIGHT_CONTROL_inc ()
	PnlLgt = ipc.readLvar("switch_25_a")
    PnLgtTxt = round(PnlLgt/3)
    if PnlLgt >= 295 then PnlLgt = 295 end
    ipc.control(PMDGBaseVariable +25, PnlLgt + 5)
    DspShow ("Pnl", PnLgtTxt .."%", "OVHD PNL", PnLgtTxt .."%")
end

function PANEL_LIGHT_CONTROL_incfast ()
	PnlLgt = ipc.readLvar("switch_25_a")
    PnLgtTxt = round(PnlLgt/3)
    if PnlLgt >= 280 then PnlLgt = 280 end
    ipc.control(PMDGBaseVariable +25, PnlLgt + 20)
    DspShow ("Pnl", PnLgtTxt .."%", "OVHD PNL", PnLgtTxt .."%")
end

function PANEL_LIGHT_CONTROL_dec ()
	PnlLgt = ipc.readLvar("switch_25_a")
    PnLgtTxt = round(PnlLgt/3)
    if PnlLgt <= 5 then PnlLgt = 5 end
    ipc.control(PMDGBaseVariable +25, PnlLgt - 5)
    DspShow ("Pnl", PnLgtTxt .."%", "OVHD PNL", PnLgtTxt .."%")
end

function PANEL_LIGHT_CONTROL_decfast ()
	PnlLgt = ipc.readLvar("switch_25_a")
    PnLgtTxt = round(PnlLgt/3)
    if PnlLgt <= 20 then PnlLgt = 20 end
    ipc.control(PMDGBaseVariable +25, PnlLgt - 20)
    DspShow ("Pnl", PnLgtTxt .."%", "OVHD PNL", PnLgtTxt .."%")
end

function PANEL_LIGHT_CONTROL_off ()

    ipc.control(PMDGBaseVariable +25, 0)
    PnlLgt = ipc.readLvar("switch_25_a")
    PnLgtTxt = round(PnlLgt/3)
    DspShow ("Pnl", PnLgtTxt .."%", "OVHD PNL", PnLgtTxt .."%")
end

function PANEL_LIGHT_CONTROL_on ()

    ipc.control(PMDGBaseVariable +25, FldIOVar)
    PnlLgt = ipc.readLvar("switch_25_a")
    PnLgtTxt = round(PnlLgt/3)
    DspShow ("Pnl", PnLgtTxt .."%", "OVHD PNL", PnLgtTxt .."%")
end

        ---------------------


function CB_LIGHT_CONTROL_inc ()
    CBLgt = ipc.readLvar("switch_25_b")
    CBLgtTxt = round(CBLgt/3)
    if CBLgt >= 295 then CBLgt = 295 end
    ipc.control(PMDGBaseVariable +2501, CBLgt + 5)
    DspShow ("CB", CBLgtTxt .."%", "OVHD CB", CBLgtTxt .."%")
end

function CB_LIGHT_CONTROL_incfast ()
    CBLgt = ipc.readLvar("switch_25_b")
    CBLgtTxt = round(CBLgt/3)
    if CBLgt >= 280 then CBLgt = 280 end
    ipc.control(PMDGBaseVariable +2501, CBLgt + 20)

    DspShow ("CB", CBLgtTxt .."%", "OVHD CB", CBLgtTxt .."%")
end

function CB_LIGHT_CONTROL_dec ()
    CBLgt = ipc.readLvar("switch_25_b")
    CBLgtTxt = round(CBLgt/3)
    if CBLgt <= 5 then CBLgt = 5 end
    ipc.control(PMDGBaseVariable +2501, CBLgt - 5)
    DspShow ("CB", CBLgtTxt .."%", "OVHD CB", CBLgtTxt .."%")
end

function CB_LIGHT_CONTROL_decfast ()
    CBLgt = ipc.readLvar("switch_25_b")
    CBLgtTxt = round(CBLgt/3)
    if CBLgt <= 20 then CBLgt = 20 end
    ipc.control(PMDGBaseVariable +2501, CBLgt - 20)
    ipc.sleep(10)
    DspShow ("CB", CBLgtTxt .."%", "OVHD CB", CBLgtTxt .."%")
end

function CB_LIGHT_CONTROL_off ()

    ipc.control(PMDGBaseVariable +2501, 0)
    CBLgt = ipc.readLvar("switch_25_b")
    CBLgtTxt = round(CBLgt/3)
    DspShow ("CB", CBLgtTxt .."%", "OVHD CB", CBLgtTxt .."%")
end

function CB_LIGHT_CONTROL_on ()

    ipc.control(PMDGBaseVariable +2501, FldIOVar)
    CBLgt = ipc.readLvar("switch_25_b")
    CBLgtTxt = round(CBLgt/3)
    DspShow ("CB", CBLgtTxt .."%", "OVHD CB", CBLgtTxt .."%")
end


----------------------

function GS_LIGHT_CONTROL_inc ()
    GSLgt = ipc.readLvar("switch_21_a")
    GSLgtTxt = round(GSLgt/3)
    if GSLgt >= 295 then GSLgt = 295 end
    ipc.control(PMDGBaseVariable +21, GSLgt + 5)
    DspShow ("GS", GSLgtTxt .."%", "OVHD GS", GSLgtTxt .."%")
end

function GS_LIGHT_CONTROL_incfast ()
    GSLgt = ipc.readLvar("switch_21_a")
    GSLgtTxt = round(GSLgt/3)
    if GSLgt >= 280 then GSLgt = 280 end
    ipc.control(PMDGBaseVariable +21, GSLgt + 20)

    DspShow ("GS", GSLgtTxt .."%", "OVHD GS", GSLgtTxt .."%")
end

function GS_LIGHT_CONTROL_dec ()
    GSLgt = ipc.readLvar("switch_21_a")
    GSLgtTxt = round(GSLgt/3)
    if GSLgt <= 5 then GSLgt = 5 end
    ipc.control(PMDGBaseVariable +21, GSLgt - 5)
    DspShow ("GS", GSLgtTxt .."%", "OVHD GS", GSLgtTxt .."%")
end

function GS_LIGHT_CONTROL_decfast ()
    GSLgt = ipc.readLvar("switch_21_a")
    GSLgtTxt = round(GSLgt/3)
    if GSLgt <= 20 then GSLgt = 20 end
    ipc.control(PMDGBaseVariable +21, GSLgt - 20)
    ipc.sleep(10)
    DspShow ("GS", GSLgtTxt .."%", "OVHD GS", GSLgtTxt .."%")
end

function GS_LIGHT_CONTROL_off ()

    ipc.control(PMDGBaseVariable +21, 0)
    GSLgt = ipc.readLvar("switch_21_a")
    GSLgtTxt = round(GSLgt/3)
    DspShow ("GS", GSLgtTxt .."%", "OVHD GS", GSLgtTxt .."%")
end

function GS_LIGHT_CONTROL_on ()

    ipc.control(PMDGBaseVariable +21, FldIOVar)
    GSLgt = ipc.readLvar("switch_21_a")
    GSLgtTxt = round(GSLgt/3)
    DspShow ("GS", GSLgtTxt .."%", "OVHD GS", GSLgtTxt .."%")
end

----------------------
----------------------

function GSFlood_LIGHT_CONTROL_inc ()
    GSFLgt = ipc.readLvar("switch_21_b")
    GSFLgtTxt = round(GSFLgt/3)
    if GSFLgt >= 295 then GSFLgt = 295 end
    ipc.control(PMDGBaseVariable +2101, GSFLgt + 5)
    DspShow ("GS F", GSFLgtTxt .."%", "GS FLOOD", GSFLgtTxt .."%")
end

function GSFlood_LIGHT_CONTROL_incfast ()
    GSFLgt = ipc.readLvar("switch_21_b")
    GSFLgtTxt = round(GSFLgt/3)
    if GSFLgt >= 280 then GSFLgt = 280 end
    ipc.control(PMDGBaseVariable +2101, GSFLgt + 20)

    DspShow ("GS F", GSFLgtTxt .."%", "GS FLOOD", GSFLgtTxt .."%")
end

function GSFlood_LIGHT_CONTROL_dec ()
    GSFLgt = ipc.readLvar("switch_21_b")
    GSFLgtTxt = round(GSFLgt/3)
    if GSFLgt <= 5 then GSFLgt = 5 end
    ipc.control(PMDGBaseVariable +2101, GSFLgt - 5)
    DspShow ("GS F", GSFLgtTxt .."%", "GS FLOOD", GSFLgtTxt .."%")
end

function GSFlood_LIGHT_CONTROL_decfast ()
    GSFLgt = ipc.readLvar("switch_21_b")
    GSFLgtTxt = round(GSFLgt/3)
    if GSFLgt <= 20 then GSFLgt = 20 end
    ipc.control(PMDGBaseVariable +2101, GSFLgt - 20)
    ipc.sleep(10)
    DspShow ("GS F", GSFLgtTxt .."%", "GS FLOOD", GSFLgtTxt .."%")
end

function GSFlood_LIGHT_CONTROL_off ()

    ipc.control(PMDGBaseVariable +2101, 0)
    GSFLgt = ipc.readLvar("switch_21_b")
    GSFLgtTxt = round(GSFLgt/3)
    DspShow ("GS F", GSFLgtTxt .."%", "GS FLOOD", GSFLgtTxt .."%")
end

function GSFlood_LIGHT_CONTROL_on ()

    ipc.control(PMDGBaseVariable +2101, FldIOVar)
    GSFLgt = ipc.readLvar("switch_21_b")
    GSFLgtTxt = round(GSFLgt/3)
    DspShow ("GS F", GSFLgtTxt .."%", "GS FLOOD", GSFLgtTxt .."%")
end




function DOME_SWITCH_on ()
	if ipc.readLvar("switch_26_a") == 0 then
     ipc.control(69658, 64)
	DspShow ("DOME", "on")
	end
end



function DOME_SWITCH_off ()
   if ipc.readLvar("switch_26_a") > 0 then
     ipc.control(69658, 64)
	DspShow ("DOME", "off")
	end
end

function DOME_SWITCH_toggle ()
	if _tl("switch_26_a", 0) then
       DOME_SWITCH_on ()
	else
       DOME_SWITCH_off ()
	end
end


----------------------

function MASTER_BRIGHT_CONTROL_inc ()
    MBCLgt = ipc.readLvar("switch_28_a")
    MBCLgtTxt = round(MBCLgt/3)
    if MBCLgt >= 295 then MBCLgt = 295 end
    ipc.control(PMDGBaseVariable +28, MBCLgt + 5)
    DspShow ("BRGT", MBCLgtTxt .."%", "MSTR BRGT", MBCLgtTxt .."%")
end

function MASTER_BRIGHT_CONTROL_incfast ()
    MBCLgt = ipc.readLvar("switch_28_a")
    MBCLgtTxt = round(MBCLgt/3)
    if MBCLgt >= 280 then MBCLgt = 280 end
    ipc.control(PMDGBaseVariable +28, MBCLgt + 20)

    DspShow ("BRGT", MBCLgtTxt .."%", "MSTR BRGT", MBCLgtTxt .."%")
end

function MASTER_BRIGHT_CONTROL_dec ()
    MBCLgt = ipc.readLvar("switch_28_a")
    MBCLgtTxt = round(MBCLgt/3)
    if MBCLgt <= 5 then MBCLgt = 5 end
    ipc.control(PMDGBaseVariable +28, MBCLgt - 5)
    DspShow ("BRGT", MBCLgtTxt .."%", "MSTR BRGT", MBCLgtTxt .."%")
end

function MASTER_BRIGHT_CONTROL_decfast ()
    MBCLgt = ipc.readLvar("switch_28_a")
    MBCLgtTxt = round(MBCLgt/3)
    if MBCLgt <= 20 then MBCLgt = 20 end
    ipc.control(PMDGBaseVariable +28, MBCLgt - 20)
    ipc.sleep(10)
    DspShow ("BRGT", MBCLgtTxt .."%", "MSTR BRGT", MBCLgtTxt .."%")
end

function MASTER_BRIGHT_CONTROL_off ()

    ipc.control(PMDGBaseVariable +28, 0)
    MBCLgt = ipc.readLvar("switch_28_a")
    MBCLgtTxt = round(MBCLgt/3)
    DspShow ("BRGT", MBCLgtTxt .."%", "MSTR BRGT", MBCLgtTxt .."%")
end

function MASTER_BRIGHT_CONTROL_on ()

    ipc.control(PMDGBaseVariable +28, FldIOVar)
    MBCLgt = ipc.readLvar("switch_28_a")
    MBCLgtTxt = round(MBCLgt/3)
    DspShow ("BRGT", MBCLgtTxt .."%", "MSTR BRGT", MBCLgtTxt .."%")
end


-- ## Panel other lights ###############

function FWD_LEFT_FLOOD_LIGHT_CONTROL_inc ()
    FLFLgt = ipc.readLvar("switch_3220_a")
    FLFLgtTxt = round(FLFLgt/3)
    if FLFLgt >= 295 then FLFLgt = 295 end
    ipc.control(PMDGBaseVariable +3220, FLFLgt + 5)
    DspShow ("GS F", FLFLgtTxt .."%", "GS FLOOD", FLFLgtTxt .."%")
end

function FWD_LEFT_FLOOD_LIGHT_CONTROL_incfast ()
    FLFLgt = ipc.readLvar("switch_3220_a")
    FLFLgtTxt = round(FLFLgt/3)
    if FLFLgt >= 280 then FLFLgt = 280 end
    ipc.control(PMDGBaseVariable +3220, FLFLgt + 20)

    DspShow ("GS F", FLFLgtTxt .."%", "GS FLOOD", FLFLgtTxt .."%")
end

function FWD_LEFT_FLOOD_LIGHT_CONTROL_dec ()
    FLFLgt = ipc.readLvar("switch_3220_a")
    FLFLgtTxt = round(FLFLgt/3)
    if FLFLgt <= 5 then FLFLgt = 5 end
    ipc.control(PMDGBaseVariable +3220, FLFLgt - 5)
    DspShow ("GS F", FLFLgtTxt .."%", "GS FLOOD", FLFLgtTxt .."%")
end

function FWD_LEFT_FLOOD_LIGHT_CONTROL_decfast ()
    FLFLgt = ipc.readLvar("switch_3220_a")
    FLFLgtTxt = round(FLFLgt/3)
    if FLFLgt <= 20 then FLFLgt = 20 end
    ipc.control(PMDGBaseVariable +3220, FLFLgt - 20)
    ipc.sleep(10)
    DspShow ("GS F", FLFLgtTxt .."%", "GS FLOOD", FLFLgtTxt .."%")
end

function FWD_LEFT_FLOOD_LIGHT_CONTROL_off ()

    ipc.control(PMDGBaseVariable +3220, 0)
    FLFLgt = ipc.readLvar("switch_3220_a")
    FLFLgtTxt = round(FLFLgt/3)
    DspShow ("GS F", FLFLgtTxt .."%", "GS FLOOD", FLFLgtTxt .."%")
end

function FWD_LEFT_FLOOD_LIGHT_CONTROL_on ()

    ipc.control(PMDGBaseVariable +3220, FldIOVar)
    FLFLgt = ipc.readLvar("switch_3220_a")
    FLFLgtTxt = round(FLFLgt/3)
    DspShow ("GS F", FLFLgtTxt .."%", "GS FLOOD", FLFLgtTxt .."%")
end


--
--

function FWD_RIGHT_FLOOD_LIGHT_CONTROL_inc ()
    FRFLgt = ipc.readLvar("switch_2850_a")
    FRFLgtTxt = round(FRFLgt/3)
    if FRFLgt >= 295 then FRFLgt = 295 end
    ipc.control(PMDGBaseVariable +2850, FRFLgt + 5)
    DspShow ("GS F", FRFLgtTxt .."%", "GS FLOOD", FRFLgtTxt .."%")
end

function FWD_RIGHT_FLOOD_LIGHT_CONTROL_incfast ()
    FRFLgt = ipc.readLvar("switch_2850_a")
    FRFLgtTxt = round(FRFLgt/3)
    if FRFLgt >= 280 then FRFLgt = 280 end
    ipc.control(PMDGBaseVariable +2850, FRFLgt + 20)

    DspShow ("GS F", FRFLgtTxt .."%", "GS FLOOD", FRFLgtTxt .."%")
end

function FWD_RIGHT_FLOOD_LIGHT_CONTROL_dec ()
    FRFLgt = ipc.readLvar("switch_2850_a")
    FRFLgtTxt = round(FRFLgt/3)
    if FRFLgt <= 5 then FRFLgt = 5 end
    ipc.control(PMDGBaseVariable +2850, FRFLgt - 5)
    DspShow ("GS F", FRFLgtTxt .."%", "GS FLOOD", FRFLgtTxt .."%")
end

function FWD_RIGHT_FLOOD_LIGHT_CONTROL_decfast ()
    FRFLgt = ipc.readLvar("switch_2850_a")
    FRFLgtTxt = round(FRFLgt/3)
    if FRFLgt <= 20 then FRFLgt = 20 end
    ipc.control(PMDGBaseVariable +2850, FRFLgt - 20)
    ipc.sleep(10)
    DspShow ("GS F", FRFLgtTxt .."%", "GS FLOOD", FRFLgtTxt .."%")
end

function FWD_RIGHT_FLOOD_LIGHT_CONTROL_off ()

    ipc.control(PMDGBaseVariable +2850, 0)
    FRFLgt = ipc.readLvar("switch_2850_a")
    FRFLgtTxt = round(FRFLgt/3)
    DspShow ("GS F", FRFLgtTxt .."%", "GS FLOOD", FRFLgtTxt .."%")
end

function FWD_RIGHT_FLOOD_LIGHT_CONTROL_on ()

    ipc.control(PMDGBaseVariable +2850, FldIOVar)
    FRFLgt = ipc.readLvar("switch_2850_a")
    FRFLgtTxt = round(FRFLgt/3)
    DspShow ("GS F", FRFLgtTxt .."%", "GS FLOOD", FRFLgtTxt .."%")
end

--
--
--

function PED_FLOOD_LIGHT_CONTROL_inc ()
    PedFLgt = ipc.readLvar("switch_737_a")
    PedFLgtTxt = round(PedFLgt/3)
    if PedFLgt >= 295 then PedFLgt = 295 end
    ipc.control(PMDGBaseVariable +737, PedFLgt + 5)
    DspShow ("GS F", PedFLgtTxt .."%", "GS FLOOD", PedFLgtTxt .."%")
end

function PED_FLOOD_LIGHT_CONTROL_incfast ()
    PedFLgt = ipc.readLvar("switch_737_a")
    PedFLgtTxt = round(PedFLgt/3)
    if PedFLgt >= 280 then PedFLgt = 280 end
    ipc.control(PMDGBaseVariable +737, PedFLgt + 20)

    DspShow ("GS F", PedFLgtTxt .."%", "GS FLOOD", PedFLgtTxt .."%")
end

function PED_FLOOD_LIGHT_CONTROL_dec ()
    PedFLgt = ipc.readLvar("switch_737_a")
    PedFLgtTxt = round(PedFLgt/3)
    if PedFLgt <= 5 then PedFLgt = 5 end
    ipc.control(PMDGBaseVariable +737, PedFLgt - 5)
    DspShow ("GS F", PedFLgtTxt .."%", "GS FLOOD", PedFLgtTxt .."%")
end

function PED_FLOOD_LIGHT_CONTROL_decfast ()
    PedFLgt = ipc.readLvar("switch_737_a")
    PedFLgtTxt = round(PedFLgt/3)
    if PedFLgt <= 20 then PedFLgt = 20 end
    ipc.control(PMDGBaseVariable +737, PedFLgt - 20)
    ipc.sleep(10)
    DspShow ("GS F", PedFLgtTxt .."%", "GS FLOOD", PedFLgtTxt .."%")
end

function PED_FLOOD_LIGHT_CONTROL_off ()

    ipc.control(PMDGBaseVariable +737, 0)
    PedFLgt = ipc.readLvar("switch_737_a")
    PedFLgtTxt = round(PedFLgt/3)
    DspShow ("GS F", PedFLgtTxt .."%", "GS FLOOD", PedFLgtTxt .."%")
end

function PED_FLOOD_LIGHT_CONTROL_on ()

    ipc.control(PMDGBaseVariable +737, FldIOVar)
    PedFLgt = ipc.readLvar("switch_737_a")
    PedFLgtTxt = round(PedFLgt/3)
    DspShow ("GS F", PedFLgtTxt .."%", "GS FLOOD", PedFLgtTxt .."%")
end

function ALL_PANEL_FLOOD_LIGHTS_inc ()
    FWD_LEFT_FLOOD_LIGHT_CONTROL_inc ()
    FWD_RIGHT_FLOOD_LIGHT_CONTROL_inc ()
    GSFlood_LIGHT_CONTROL_inc ()
    PED_FLOOD_LIGHT_CONTROL_inc ()
end

function ALL_PANEL_FLOOD_LIGHTS_incfast ()
    FWD_LEFT_FLOOD_LIGHT_CONTROL_incfast ()
    FWD_RIGHT_FLOOD_LIGHT_CONTROL_incfast ()
    GSFlood_LIGHT_CONTROL_incfast ()
    PED_FLOOD_LIGHT_CONTROL_incfast ()
end

function ALL_PANEL_FLOOD_LIGHTS_dec ()
    FWD_LEFT_FLOOD_LIGHT_CONTROL_dec ()
    FWD_RIGHT_FLOOD_LIGHT_CONTROL_dec ()
    GSFlood_LIGHT_CONTROL_dec ()
    PED_FLOOD_LIGHT_CONTROL_dec ()
end

function ALL_PANEL_FLOOD_LIGHTS_decfast ()
    FWD_LEFT_FLOOD_LIGHT_CONTROL_decfast ()
    FWD_RIGHT_FLOOD_LIGHT_CONTROL_decfast ()
    GSFlood_LIGHT_CONTROL_decfast ()
    PED_FLOOD_LIGHT_CONTROL_decfast ()
end

function ALL_PANEL_FLOOD_LIGHTS_on ()
    FWD_LEFT_FLOOD_LIGHT_CONTROL_on ()
    FWD_RIGHT_FLOOD_LIGHT_CONTROL_on ()
    GSFlood_LIGHT_CONTROL_on ()
    PED_FLOOD_LIGHT_CONTROL_on ()
end

function ALL_PANEL_FLOOD_LIGHTS_off ()
    FWD_LEFT_FLOOD_LIGHT_CONTROL_off ()
    FWD_RIGHT_FLOOD_LIGHT_CONTROL_off ()
    GSFlood_LIGHT_CONTROL_off ()
    PED_FLOOD_LIGHT_CONTROL_off ()
end




 -- ## Overhead - Miscellaneous


function EMER_EXIT_LIGHT_SWITCH_arm ()
    EMER_EXIT_LIGHT_GUARD_open ()
    _sleep(100,150)
	if ipc.readLvar("switch_49_a") ~= 50 then
	ipc.control(PMDGBaseVariable +49, 1)
	DspShow ("EMER", "arm", "EMER LGT", "arm")
	end
    _sleep(100,150)
    EMER_EXIT_LIGHT_GUARD_close ()
end

function EMER_EXIT_LIGHT_SWITCH_on ()
    EMER_EXIT_LIGHT_GUARD_open ()
    _sleep(200,300)
	if ipc.readLvar("switch_49_a") ~= 100 then
	ipc.control(PMDGBaseVariable +49, 2)
	DspShow ("EMER", "on", "EMER LGT", "on")
	end
end

function EMER_EXIT_LIGHT_SWITCH_off ()
    EMER_EXIT_LIGHT_GUARD_open ()
    _sleep(200,300)
	if ipc.readLvar("switch_49_a") ~= 0 then
	ipc.control(PMDGBaseVariable +49, 0)
	DspShow ("EMER", "off", "EMER LGT", "off")
	end
end

function EMER_EXIT_LIGHT_GUARD_open ()
	if ipc.readLvar("switch_50_a") == 0 then
	ipc.control(PMDGBaseVariable +50, 1)
	end
end

function EMER_EXIT_LIGHT_GUARD_close ()
	if ipc.readLvar("switch_50_a") == 100 then
	ipc.control(PMDGBaseVariable +50, 0)
	end
end


------------

function SMOKING_ELECTRONICS_show ()
   SmokEle = ipc.readLvar("NoSmokeElectronics")
   SmokEleSw = ipc.readLvar("switch_29_a")

   if SmokEle == 0 then
        SmokEleTxtLong = "NO SMKNG"
        SmokEleTxtShort = "SMOK"
   elseif SmokEle == 1 then
        SmokEleTxtLong = "NO ELEC"
        SmokEleTxtShort = "ELEC"
    elseif SmokEle == 2 then
        SmokEleTxtLong = "INOP"
        SmokEleTxtShort = "INOP"
   end

   if SmokEleSw == 0 then
        SmokEleSwTxt = "off"
   elseif SmokEleSw == 50 then
        SmokEleSwTxt = "auto"
   elseif SmokEleSw == 100 then
        SmokEleSwTxt = "on"
   end
   DspShow (SmokEleTxtShort, SmokEleSwTxt, SmokEleTxtLong, SmokEleSwTxt)
end



function NO_SMOKING_LIGHT_SWITCH_off ()
    ipc.control(PMDGBaseVariable +29, 0)
    SMOKING_ELECTRONICS_show ()
end

function NO_SMOKING_LIGHT_SWITCH_auto ()
	ipc.control(PMDGBaseVariable +29, 1)
    SMOKING_ELECTRONICS_show ()
end

function NO_SMOKING_LIGHT_SWITCH_on ()
	ipc.control(PMDGBaseVariable +29, 2)
    SMOKING_ELECTRONICS_show ()
end

----

function FASTEN_BELTS_LIGHT_SWITCH_off ()
    ipc.control(PMDGBaseVariable +30, 0)
    DspShow ("SEAT", "off", "SEATBELT", "off")
end

function FASTEN_BELTS_LIGHT_SWITCH_auto ()
	ipc.control(PMDGBaseVariable +30, 1)
    DspShow ("SEAT", "auto", "SEATBELT", "auto")
end

function FASTEN_BELTS_LIGHT_SWITCH_on ()
	ipc.control(PMDGBaseVariable +30, 2)
    DspShow ("SEAT", "on", "SEATBELT", "on")
end





-- ## Overhead - FUEL Panel


-- function JETTISON_NOZZLE_L ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +97, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function JETTISON_NOZZLE_L_GUARD ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +98, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function JETTISON_NOZZLE_R ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +99, 1)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function JETTISON_NOZZLE_R_GUARD ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +10, 10)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function TO_REMAIN_ROTATE ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +10, 11)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end

-- function TO_REMAIN_PULL ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +10, 1100)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end


-- function JETTISON_ARM ()
	-- if ipc.readLvar("switch_02_a") == 0 then
	-- ipc.control(PMDGBaseVariable +10, 12)
	-- DspShow (" ", "on", " ", "on")
	-- end
-- end


--- FWD pumps

function PUMP_1_FORWARD_on ()
	if ipc.readLvar("switch_103_a") == 0 then
	ipc.control(PMDGBaseVariable + 103, 1)
	DspShow ("LFwd", "on", "PMP1 FWD", "on")
	end
end

function PUMP_1_FORWARD_off ()
	if ipc.readLvar("switch_103_a") == 100 then
	ipc.control(PMDGBaseVariable + 103, 0)
	DspShow ("LFwd", "off", "PMP1 FWD", "off")
	end
end

function PUMP_1_FORWARD_toggle ()
	if _tl("switch_103_a", 0) then
       PUMP_1_FORWARD_on ()
	else
       PUMP_1_FORWARD_off ()
	end
end



function PUMP_2_FORWARD_on ()
	if ipc.readLvar("switch_104_a") == 0 then
	ipc.control(PMDGBaseVariable + 104, 1)
	DspShow ("RFwd", "on", "PMP2 FWD", "on")
	end
end

function PUMP_2_FORWARD_off ()
	if ipc.readLvar("switch_104_a") == 100 then
	ipc.control(PMDGBaseVariable + 104, 0)
	DspShow ("RFwd", "off", "PMP2 FWD", "off")
	end
end

function PUMP_2_FORWARD_toggle ()
	if _tl("switch_104_a", 0) then
       PUMP_2_FORWARD_on ()
	else
       PUMP_2_FORWARD_off ()
	end
end

function FWD_PUMPS_on ()
    PUMP_1_FORWARD_on ()
    _sleep(50,100)
    PUMP_2_FORWARD_on ()
end

function FWD_PUMPS_off ()
    PUMP_1_FORWARD_off ()
    _sleep(50,100)
    PUMP_2_FORWARD_off ()
end

function FWD_PUMPS_toggle ()
    PUMP_1_FORWARD_toggle ()
    _sleep(50,100)
    PUMP_2_FORWARD_toggle ()
end




-- afterwards pumps

function PUMP_1_AFT_on ()
	if ipc.readLvar("switch_105_a") == 0 then
	ipc.control(PMDGBaseVariable + 105, 1)
	DspShow ("LAft", "on", "PMP1 AFT", "on")
	end
end

function PUMP_1_AFT_off ()
	if ipc.readLvar("switch_105_a") == 100 then
	ipc.control(PMDGBaseVariable + 105, 0)
	DspShow ("LAft", "off", "PMP1 AFT", "off")
	end
end

function PUMP_1_AFT_toggle ()
	if _tl("switch_105_a", 0) then
       PUMP_1_AFT_on ()
	else
       PUMP_1_AFT_off ()
	end
end



function PUMP_2_AFT_on ()
	if ipc.readLvar("switch_106_a") == 0 then
	ipc.control(PMDGBaseVariable + 106, 1)
	DspShow ("RAft", "on", "PMP2 AFT", "on")
	end
end

function PUMP_2_AFT_off ()
	if ipc.readLvar("switch_106_a") == 100 then
	ipc.control(PMDGBaseVariable + 106, 0)
	DspShow ("RAft", "off", "PMP2 AFT", "off")
	end
end

function PUMP_2_AFT_toggle ()
	if _tl("switch_106_a", 0) then
       PUMP_2_AFT_on ()
	else
       PUMP_2_AFT_off ()
	end
end

function AFTERWARDS_PUMPS_on ()
    PUMP_1_AFT_on ()
    _sleep(50,100)
    PUMP_2_AFT_on ()
end

function AFTERWARDS_PUMPS_off ()
    PUMP_1_AFT_off ()
    _sleep(50,100)
    PUMP_2_AFT_off ()
end

function AFTERWARDS_PUMPS_toggle ()
    PUMP_1_AFT_toggle ()
    _sleep(50,100)
    PUMP_2_AFT_toggle ()
end




-- crossfeed pumps

function CROSSFEED_FORWARD_on ()
	if ipc.readLvar("switch_107_a") == 0 then
	ipc.control(PMDGBaseVariable +107, 1)
	DspShow ("CFwd", "on", "CrossFWD", "on")
	end
end

function CROSSFEED_FORWARD_off ()
	if ipc.readLvar("switch_107_a") == 100 then
	ipc.control(PMDGBaseVariable +107, 0)
	DspShow ("CFwd", "off", "CrossFWD", "off")
	end
end

function CROSSFEED_FORWARD_toggle ()
	if _tl("switch_107_a", 0) then
       CROSSFEED_FORWARD_on ()
	else
       CROSSFEED_FORWARD_off ()
	end
end



function CROSSFEED_AFT_on ()
	if ipc.readLvar("switch_108_a") == 0 then
	ipc.control(PMDGBaseVariable +108, 1)
	DspShow ("CAft", "on", "CrossAFT", "on")
	end
end

function CROSSFEED_AFT_off ()
	if ipc.readLvar("switch_108_a") == 100 then
	ipc.control(PMDGBaseVariable +108, 0)
	DspShow ("CAft", "off", "CrossAFT", "off")
	end
end

function CROSSFEED_AFT_toggle ()
	if _tl("switch_108_a", 0) then
       CROSSFEED_AFT_on ()
	else
       CROSSFEED_AFT_off ()
	end
end

function CROSSFEED_PUMPS_on ()
    CROSSFEED_FORWARD_on ()
    _sleep(50,100)
    CROSSFEED_AFT_on ()
end

function CROSSFEED_PUMPS_off ()
    CROSSFEED_FORWARD_off ()
    _sleep(50,100)
    CROSSFEED_AFT_off ()
end

function CROSSFEED_PUMPS_toggle ()
    CROSSFEED_FORWARD_toggle ()
    _sleep(50,100)
    CROSSFEED_AFT_toggle ()
end


-- left pumps

function LEFT_PUMPS_on ()
    PUMP_1_FORWARD_on ()
    _sleep(50,100)
    PUMP_1_AFT_on ()
end

function LEFT_PUMPS_off ()
    PUMP_1_FORWARD_off ()
    _sleep(50,100)
    PUMP_1_AFT_off ()
end

function LEFT_PUMPS_toggle ()
    PUMP_1_FORWARD_toggle ()
    _sleep(50,100)
    PUMP_1_AFT_toggle ()
end

-- right pumps

function RIGHT_PUMPS_on ()
    PUMP_2_FORWARD_on ()
    _sleep(50,100)
    PUMP_2_AFT_on ()
end

function RIGHT_PUMPS_off ()
    PUMP_2_FORWARD_off ()
    _sleep(50,100)
    PUMP_2_AFT_off ()
end

function RIGHT_PUMPS_toggle ()
    PUMP_2_FORWARD_toggle ()
    _sleep(50,100)
    PUMP_2_AFT_toggle ()
end


-- center pumps

function PUMP_L_CENTER_on ()
	if ipc.readLvar("switch_109_a") == 0 then
	ipc.control(PMDGBaseVariable +109, 1)
	DspShow ("LCnt", "on", "L Center", "on")
	end
end

function PUMP_L_CENTER_off ()
	if ipc.readLvar("switch_109_a") == 100 then
	ipc.control(PMDGBaseVariable +109, 0)
	DspShow ("LCnt", "off", "L Center", "off")
	end
end

function PUMP_L_CENTER_toggle ()
	if _tl("switch_109_a", 0) then
       PUMP_L_CENTER_on ()
	else
       PUMP_L_CENTER_off ()
	end
end



function PUMP_R_CENTER_on ()
	if ipc.readLvar("switch_110_a") == 0 then
	ipc.control(PMDGBaseVariable +110, 1)
	DspShow ("RCnt", "on", "R Center", "on")
	end
end

function PUMP_R_CENTER_off ()
	if ipc.readLvar("switch_110_a") == 100 then
	ipc.control(PMDGBaseVariable +110, 0)
	DspShow ("RCnt", "off", "R Center", "off")
	end
end

function PUMP_R_CENTER_toggle ()
	if _tl("switch_110_a", 0) then
       PUMP_R_CENTER_on ()
	else
       PUMP_R_CENTER_off ()
	end
end

function PUMPS_CENTER_on ()
    PUMP_L_CENTER_on ()
    _sleep(50,100)
    PUMP_R_CENTER_on ()
end

function PUMPS_CENTER_off ()
    PUMP_L_CENTER_off ()
    _sleep(50,100)
    PUMP_R_CENTER_off ()
end

function PUMPS_CENTER_toggle ()
    PUMP_L_CENTER_toggle ()
    _sleep(50,100)
    PUMP_R_CENTER_toggle ()
end





--function PUMP_AUX_on ()
--	if ipc.readLvar("switch_1037_a") == 0 then
--	ipc.control(PMDGBaseVariable +1037, 0)
--	DspShow (" ", "on", " ", "on")
--	end
--end


-- ## Anti Ice ###############

function OH_ICE_WING_ANTIICE_on ()
    ipc.control(PMDGBaseVariable +111, 2)
    DspShow ("WING", "on", "WING ICE", "on")
end

function OH_ICE_WING_ANTIICE_auto ()
    ipc.control(PMDGBaseVariable +111, 1)
    DspShow ("WING", "auto", "WING ICE", "auto")
end

function OH_ICE_WING_ANTIICE_off ()
    ipc.control(PMDGBaseVariable +111, 0)
    DspShow ("WING", "off", "WING ICE", "off")
end

function OH_ICE_WING_ANTIICE_toggle ()
	if _tl("switch_111_a", 50) then
       OH_ICE_WING_ANTIICE_on ()
	else
       OH_ICE_WING_ANTIICE_auto ()
	end
end

function OH_ICE_WING_ANTIICE_inc ()
    WingAI = ipc.readLvar("switch_111_a")

    if WingAI == 0 then WingAIvar = 1 WingAItxt = "auto"
    elseif WingAI == 50 then WingAIvar = 2 WingAItxt = "on"
    end

    ipc.control(PMDGBaseVariable +111, WingAIvar)
    DspShow ("WING", WingAItxt, "WING ICE", WingAItxt)
end

function OH_ICE_WING_ANTIICE_dec ()
    WingAI = ipc.readLvar("switch_111_a")

    if WingAI == 100 then WingAIvar = 1 WingAItxt = "auto"
    elseif WingAI == 50 then WingAIvar = 0 WingAItxt = "off"
    end

    ipc.control(PMDGBaseVariable +111, WingAIvar)
    DspShow ("WING", WingAItxt, "WING ICE", WingAItxt)
end

----

function OH_ICE_ENGINE_ANTIICE_L_on ()
    ipc.control(PMDGBaseVariable +112, 2)
    DspShow ("ENG1", "on", "ENG1 ICE", "on")
end

function OH_ICE_ENGINE_ANTIICE_L_auto ()
    ipc.control(PMDGBaseVariable +112, 1)
    DspShow ("ENG1", "auto", "ENG1 ICE", "auto")
end

function OH_ICE_ENGINE_ANTIICE_L_off ()
    ipc.control(PMDGBaseVariable +112, 0)
    DspShow ("ENG1", "off", "ENG1 ICE", "off")
end

function OH_ICE_ENGINE_ANTIICE_L_toggle ()
	if _tl("switch_112_a", 50) then
       OH_ICE_ENGINE_ANTIICE_L_on ()
	else
       OH_ICE_ENGINE_ANTIICE_L_auto ()
	end
end

function OH_ICE_ENGINE_ANTIICE_L_inc ()
    Eng1AI = ipc.readLvar("switch_112_a")

    if Eng1AI == 0 then Eng1AIvar = 1 Eng1AItxt = "auto"
    elseif Eng1AI == 50 then Eng1AIvar = 2 Eng1AItxt = "on"
    end

    ipc.control(PMDGBaseVariable +112, Eng1AIvar)
    DspShow ("ENG1", Eng1AItxt, "ENG1 ICE", Eng1AItxt)
end

function OH_ICE_ENGINE_ANTIICE_L_dec ()
    Eng1AI = ipc.readLvar("switch_112_a")

    if Eng1AI == 100 then Eng1AIvar = 1 Eng1AItxt = "auto"
    elseif Eng1AI == 50 then Eng1AIvar = 0 Eng1AItxt = "off"
    end

    ipc.control(PMDGBaseVariable +112, Eng1AIvar)
    DspShow ("ENG1", Eng1AItxt, "ENG1 ICE", Eng1AItxt)
end


---
----

function OH_ICE_ENGINE_ANTIICE_R_on ()
    ipc.control(PMDGBaseVariable +113, 2)
    DspShow ("ENG2", "on", "ENG2 ICE", "on")
end

function OH_ICE_ENGINE_ANTIICE_R_auto ()
    ipc.control(PMDGBaseVariable +113, 1)
    DspShow ("ENG2", "auto", "ENG2 ICE", "auto")
end

function OH_ICE_ENGINE_ANTIICE_R_off ()
    ipc.control(PMDGBaseVariable +113, 0)
    DspShow ("ENG2", "off", "ENG2 ICE", "off")
end

function OH_ICE_ENGINE_ANTIICE_R_toggle ()
	if _tl("switch_113_a", 50) then
       OH_ICE_ENGINE_ANTIICE_R_on ()
	else
       OH_ICE_ENGINE_ANTIICE_R_auto ()
	end
end

function OH_ICE_ENGINE_ANTIICE_R_inc ()
    Eng2AI = ipc.readLvar("switch_113_a")

    if Eng2AI == 0 then Eng2AIvar = 1 Eng2AItxt = "auto"
    elseif Eng2AI == 50 then Eng2AIvar = 2 Eng2AItxt = "on"
    end

    ipc.control(PMDGBaseVariable +113, Eng2AIvar)
    DspShow ("ENG2", Eng2AItxt, "ENG2 ICE", Eng2AItxt)
end

function OH_ICE_ENGINE_ANTIICE_R_dec ()
    Eng2AI = ipc.readLvar("switch_113_a")

    if Eng2AI == 100 then Eng2AIvar = 1 Eng2AItxt = "auto"
    elseif Eng2AI == 50 then Eng2AIvar = 0 Eng2AItxt = "off"
    end

    ipc.control(PMDGBaseVariable +113, Eng2AIvar)
    DspShow ("ENG2", Eng2AItxt, "ENG2 ICE", Eng2AItxt)
end

function OH_ICE_ENGINE_ANTIICE_on ()
    OH_ICE_ENGINE_ANTIICE_L_on ()
    _sleep(100,200)
    OH_ICE_ENGINE_ANTIICE_R_on ()
end

function OH_ICE_ENGINE_ANTIICE_auto ()
    OH_ICE_ENGINE_ANTIICE_L_auto ()
    _sleep(100,200)
    OH_ICE_ENGINE_ANTIICE_R_auto ()
end

function OH_ICE_ENGINE_ANTIICE_off ()
    OH_ICE_ENGINE_ANTIICE_L_off ()
    _sleep(100,200)
    OH_ICE_ENGINE_ANTIICE_R_off ()
end

function OH_ICE_ENGINE_ANTIICE_inc ()
    OH_ICE_ENGINE_ANTIICE_L_inc ()
    _sleep(100,200)
    OH_ICE_ENGINE_ANTIICE_R_inc ()
end

function OH_ICE_ENGINE_ANTIICE_dec ()
    OH_ICE_ENGINE_ANTIICE_L_dec ()
    _sleep(100,200)
    OH_ICE_ENGINE_ANTIICE_R_dec ()
end


 -- ## Overhead - Engine control
--[[
function L_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +90, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function L_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +91, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function R_SWITCH_on ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +92, 1)
	DspShow (" ", "on", " ", "on")
	end
end

function R_GUARD ()
	if ipc.readLvar("switch_02_a") == 0 then
	ipc.control(PMDGBaseVariable +93, 1)
	DspShow (" ", "on", " ", "on")
	end
end
--]]

function ENGINE_L_START_start ()
	if ipc.readLvar("switch_94_a") == 100 then
	ipc.control(PMDGBaseVariable +94, 0)
	DspShow ("LEng", "strt", "L STRT", "strt")
	end
end

function ENGINE_L_START_norm ()
	if ipc.readLvar("switch_94_a") == 0 then
	ipc.control(PMDGBaseVariable +94, 1)
	DspShow ("LEng", "norm", "L STRT", "norm")
	end
end

function ENGINE_L_START_toggle ()
	if _tl("switch_94_a", 100) then
       ENGINE_L_START_start ()
	else
       ENGINE_L_START_norm ()
	end
end


function ENGINE_R_START_start ()
	if ipc.readLvar("switch_95_a") == 100 then
	ipc.control(PMDGBaseVariable +95, 0)
	DspShow ("REng", "strt", "R STRT", "strt")
	end
end

function ENGINE_R_START_norm ()
	if ipc.readLvar("switch_95_a") == 0 then
	ipc.control(PMDGBaseVariable +95, 1)
	DspShow ("REng", "norm", "R STRT", "norm")
	end
end

function ENGINE_R_START_toggle ()
	if _tl("switch_95_a", 100) then
       ENGINE_R_START_start ()
	else
       ENGINE_R_START_norm ()
	end
end


--function ENGINE_AUTOSTART ()
--	if ipc.readLvar("switch_02_a") == 0 then
--	ipc.control(PMDGBaseVariable +96, 1)
--	DspShow (" ", "on", " ", "on")
--	end
--end


-- ## Overhead Air ###############


function AIRCOND_PACK_SWITCH_L_on ()
	if ipc.readLvar("switch_135_a") == 0 then
	ipc.control(PMDGBaseVariable +135, 1)
	DspShow ("PACK", "L on", "PACK L", "on")
	end
end

function AIRCOND_PACK_SWITCH_L_off ()
	if ipc.readLvar("switch_135_a") == 100 then
	ipc.control(PMDGBaseVariable +135, 0)
	DspShow ("PACK", "Loff", "PACK L", "off")
	end
end

function AIRCOND_PACK_SWITCH_L_toggle ()
	if _tl("switch_135_a", 0) then
      AIRCOND_PACK_SWITCH_L_on ()
	else
      AIRCOND_PACK_SWITCH_L_off ()
	end
end


----

function AIRCOND_PACK_SWITCH_R_on ()
	if ipc.readLvar("switch_136_a") == 0 then
	ipc.control(PMDGBaseVariable +136, 1)
	DspShow ("PACK", "R on", "PACK R", "on")
	end
end

function AIRCOND_PACK_SWITCH_R_off ()
	if ipc.readLvar("switch_136_a") == 100 then
	ipc.control(PMDGBaseVariable +136, 0)
	DspShow ("PACK", "Roff", "PACK R", "off")
	end
end

function AIRCOND_PACK_SWITCH_R_toggle ()
	if _tl("switch_136_a", 0) then
      AIRCOND_PACK_SWITCH_R_on ()
	else
      AIRCOND_PACK_SWITCH_R_off ()
	end
end



function AIRCOND_PACK_SWITCH_Both_on ()
    AIRCOND_PACK_SWITCH_L_on ()
    _sleep(100,150)
    AIRCOND_PACK_SWITCH_R_on ()
end

function AIRCOND_PACK_SWITCH_Both_off ()
    AIRCOND_PACK_SWITCH_L_off ()
    _sleep(100,150)
    AIRCOND_PACK_SWITCH_R_off ()
end




 -- ## Glareshield - EFIS Captain

function EFIS_CPT_MINIMUMS_baro ()
	ipc.control(PMDGBaseVariable +181, 1)
	DspShow ("MIN", "baro", "EFIS MIN", "baro")
end

function EFIS_CPT_MINIMUMS_radio ()
	ipc.control(PMDGBaseVariable +181, 0)
    DspShow ("MIN", "rdio", "EFIS MIN", "radio")
end

function EFIS_CPT_MINIMUMS_RAD_BARO_toggle ()
    if ipc.readLvar('switch_181_a') == 0 then
    EFIS_CPT_MINIMUMS_baro ()
    elseif ipc.readLvar('switch_181_a') == 100 then
    EFIS_CPT_MINIMUMS_radio ()
    end
end



--function EFIS_CPT_MINIMUMS_stop ()
--	ipc.control(PMDGBaseVariable +182, 1)
--	DspShow (" ", "on", " ", "on")
--end

function EFIS_CPT_MINIMUMS_inc ()
	ipc.control(PMDGBaseVariable +182, 256)
    DspShow ("MIN", "inc", "EFIS MIN", "inc")
end

function EFIS_CPT_MINIMUMS_dec ()
	ipc.control(PMDGBaseVariable +182, 128)
	DspShow ("MIN", "dec", "EFIS MIN", "dec")
end

function EFIS_CPT_MINIMUMS_rst ()
	ipc.control(PMDGBaseVariable +183, 1)
    DspShow ("MIN", "rst", "EFIS MIN", "rst")
end

function EFIS_CPT_VOR_ADF_L_vor ()
	ipc.control(PMDGBaseVariable +184, 0)
	DspShow ("VOR", "L", "EFIS", "VOR L")
end

function EFIS_CPT_VOR_ADF_L_off ()
	ipc.control(PMDGBaseVariable +184, 1)
	DspShow ("L", "OFF", "VOR/ADF", "L OFF")
end

function EFIS_CPT_VOR_ADF_L_adf ()
	ipc.control(PMDGBaseVariable +184, 2)
	DspShow ("ADF", "L", "EFIS", "ADF L")
end

function EFIS_CPT_VOR_ADF_L_inc ()
    if ipc.readLvar('switch_184_a') == 100 then
    EFIS_CPT_VOR_ADF_L_off ()
    elseif ipc.readLvar('switch_184_a') == 50 then
    EFIS_CPT_VOR_ADF_L_vor ()
    end
end

function EFIS_CPT_VOR_ADF_L_dec ()
    if ipc.readLvar('switch_184_a') == 0 then
    EFIS_CPT_VOR_ADF_L_off ()
    elseif ipc.readLvar('switch_184_a') == 50 then
    EFIS_CPT_VOR_ADF_L_adf ()
    end
end


function EFIS_CPT_MAP_MODE_show ()
    ipc.sleep(10)
     CEfisMode = ipc.readLvar('switch_185_a')
     if CEfisMode == 0 then CEfisModeTxt = "APP"
     elseif CEfisMode == 10 then CEfisModeTxt = "VOR"
     elseif CEfisMode == 20 then CEfisModeTxt = "MAP"
     elseif CEfisMode == 30 then CEfisModeTxt = "PLN"
     end
     DspShow ("Mode", CEfisModeTxt, "EFIS ", "MODE ".. CEfisModeTxt)
end

function EFIS_CPT_MAP_MODE_inc ()
    ipc.control(PMDGBaseVariable +185, 256)
    EFIS_CPT_MAP_MODE_show ()
end

function EFIS_CPT_MAP_MODE_dec ()
    ipc.control(PMDGBaseVariable +185, 128)
    EFIS_CPT_MAP_MODE_show ()
end

function EFIS_CPT_MAP_MODE_ctr ()
    ipc.control(PMDGBaseVariable +186, 1)
    DspShow ("Mode", "Ctr", "EFIS ", "MODE CTR")
end


--------

function EFIS_CPT_RANGE_show ()
    ipc.sleep(10)
     CEfisRange = ipc.readLvar('switch_187_a')
     if CEfisRange == 0 then CEfisRangeTxt = "10"
     elseif CEfisRange == 10 then CEfisRangeTxt = "20"
     elseif CEfisRange == 20 then CEfisRangeTxt = "40"
     elseif CEfisRange == 30 then CEfisRangeTxt = "80"
     elseif CEfisRange == 40 then CEfisRangeTxt = "160"
     elseif CEfisRange == 50 then CEfisRangeTxt = "320"
     elseif CEfisRange == 60 then CEfisRangeTxt = "640"

     end
     DspShow ("Rnge", CEfisRangeTxt, "EFIS RNGE", CEfisRangeTxt)
end

function EFIS_CPT_RANGE_inc ()
    ipc.control(69819, 256)
    EFIS_CPT_RANGE_show ()
end

function EFIS_CPT_RANGE_dec ()
    ipc.control(69819, 128)
    EFIS_CPT_RANGE_show ()
end


function EFIS_CPT_RANGE_TFC ()
	ipc.control(PMDGBaseVariable +188, 1)
	DspShow ("Rnge", "TFC", "EFIS RNGE", "TFC")
end

-------------------

function EFIS_CPT_VOR_ADF_R_vor ()
	ipc.control(PMDGBaseVariable +189, 0)
 DspShow ("VOR", "R", "EFIS", "VOR R")
end

function EFIS_CPT_VOR_ADF_R_off ()
	ipc.control(PMDGBaseVariable +189, 1)
    DspShow ("R", "OFF", "VOR/ADF", "R OFF")
end

function EFIS_CPT_VOR_ADF_R_adf ()
	ipc.control(PMDGBaseVariable +189, 2)
    DspShow ("ADF", "R", "EFIS", "ADF R")
end

function EFIS_CPT_VOR_ADF_R_inc ()
    if ipc.readLvar('switch_189_a') == 100 then
    EFIS_CPT_VOR_ADF_R_off ()
    elseif ipc.readLvar('switch_189_a') == 50 then
    EFIS_CPT_VOR_ADF_R_vor ()
    end
end

function EFIS_CPT_VOR_ADF_R_dec ()
    if ipc.readLvar('switch_189_a') == 0 then
    EFIS_CPT_VOR_ADF_R_off ()
    elseif ipc.readLvar('switch_189_a') == 50 then
    EFIS_CPT_VOR_ADF_R_adf ()
    end
end


function EFIS_CPT_BARO_in ()
	ipc.control(PMDGBaseVariable +190, 0)
	DspShow ("BARO", "in", " BARO", "in")
end

function EFIS_CPT_BARO_hpa ()
	ipc.control(PMDGBaseVariable +190, 1)
	DspShow ("BARO", "hpa", "BARO", "hpa")
end

function EFIS_CPT_BARO_IN_HPA_toggle ()
    if ipc.readLvar('switch_190_a') == 100 then
    EFIS_CPT_BARO_in ()
    elseif ipc.readLvar('switch_190_a') == 0 then
    EFIS_CPT_BARO_hpa ()
    end
end


function EFIS_CPT_BARO_inc ()
    ipc.control(PMDGBaseVariable +191, 256)
    DspShow ("BARO", "inc", "BARO", "inc")
end

function EFIS_CPT_BARO_dec ()
    ipc.control(PMDGBaseVariable +191, 128)
    DspShow ("BARO", "inc", "BARO", "inc")
end

function EFIS_CPT_BARO_STD ()
	ipc.control(PMDGBaseVariable +192, 1)
	DspShow ("BARO", "std", "BARO", "std")
end



function EFIS_CPT_FPV ()
	ipc.control(PMDGBaseVariable +193, 1)
	DspShow ("EFIS", "FPV")
end

function EFIS_CPT_MTRS ()
	ipc.control(PMDGBaseVariable +194, 1)
 DspShow ("EFIS", "MTRS")
end



function EFIS_CPT_WXR ()
	ipc.control(PMDGBaseVariable +195, 1)
	DspShow ("EFIS", "WXR", "EFIS", "WXR")
end

function EFIS_CPT_STA ()
	ipc.control(PMDGBaseVariable +196, 1)
 DspShow ("EFIS", "STA", "EFIS", "STA")
end

function EFIS_CPT_WPT ()
	ipc.control(PMDGBaseVariable +197, 1)
 DspShow ("EFIS", "WPT", "EFIS", "WPT")
end

function EFIS_CPT_ARPT ()
	ipc.control(PMDGBaseVariable +198, 1)
 DspShow ("EFIS", "ARPT", "EFIS", "ARPT")
end

function EFIS_CPT_DATA ()
	ipc.control(PMDGBaseVariable +199, 1)
 DspShow ("EFIS", "DATA", "EFIS", "DATA")
end

function EFIS_CPT_POS ()
	ipc.control(PMDGBaseVariable +200, 1)
 DspShow ("EFIS", "POS", "EFIS", "POS")
end

function EFIS_CPT_TERR ()
	ipc.control(PMDGBaseVariable +201, 1)
 DspShow ("EFIS", "TERR", "EFIS", "TERR")

end

-- ## Glareshield - Display Select Panel ###############

function PMDG_Select_L_Inbnd ()
     ipc.control(69863, 1)
    DspShow ("Left", "Ibnd")
end

function PMDG_Select_R_Inbnd ()
     ipc.control(69864, 1)
    DspShow ("Rght", "Ibnd")
end

function PMDG_Select_Lwr_Ctr ()
     ipc.control(69865, 1)
    DspShow ("Lwr", "Ctr")
end

--

function PMDG_Disp_inc ()
    DispVar = ipc.get("DispModeVar")
    --if DispVar == 0 then PMDG_Disp_Eng ()
    if DispVar == 1 then PMDG_Disp_Stat ()
    elseif DispVar == 2 then PMDG_Disp_Elec ()
    elseif DispVar == 3 then PMDG_Disp_Hyd ()
    elseif DispVar == 4 then PMDG_Disp_Fuel ()
    elseif DispVar == 5 then PMDG_Disp_Air ()
    elseif DispVar == 6 then PMDG_Disp_Door ()
    elseif DispVar == 7 then PMDG_Disp_Gear ()
    elseif DispVar == 8 then PMDG_Disp_Fctl ()

    elseif DispVar == 9 then PMDG_Disp_Eng ()
    end
end

function PMDG_Disp_dec ()
    DispVar = ipc.get("DispModeVar")
    if DispVar == 2 then PMDG_Disp_Eng ()
    elseif DispVar == 3 then PMDG_Disp_Stat ()
    elseif DispVar == 4 then PMDG_Disp_Elec ()
    elseif DispVar == 5 then PMDG_Disp_Hyd ()
    elseif DispVar == 6 then PMDG_Disp_Fuel ()
    elseif DispVar == 7 then PMDG_Disp_Air ()
    elseif DispVar == 8 then PMDG_Disp_Door ()
    elseif DispVar == 9 then PMDG_Disp_Gear ()
    --elseif DispVar == 0 then PMDG_Disp_Fctl ()

    elseif DispVar == 1 then PMDG_Disp_Fctl ()
    end
end



function PMDG_Disp_Eng ()
     ipc.control(69866, 1)
     ipc.set("DispModeVar", 1)
    DspShow ("ENG", "")
end

function PMDG_Disp_Stat ()
     ipc.control(69867, 1)
     ipc.set("DispModeVar", 2)
    DspShow ("STAT", "")
end

function PMDG_Disp_Elec ()
     ipc.control(69868, 1)
     ipc.set("DispModeVar", 3)
    DspShow ("ELEC", "")
end

function PMDG_Disp_Hyd ()
     ipc.control(69869, 1)
     ipc.set("DispModeVar", 4)
    DspShow ("HYD", "")
end

function PMDG_Disp_Fuel ()
     ipc.control(69870, 1)
     ipc.set("DispModeVar", 5)
    DspShow ("FUEL", "")
end

function PMDG_Disp_Air ()
     ipc.control(69871, 1)
     ipc.set("DispModeVar", 6)
    DspShow ("AIR", "")
end

function PMDG_Disp_Door ()
     ipc.control(69872, 1)
     ipc.set("DispModeVar", 7)
    DspShow ("DOOR", "")
end

function PMDG_Disp_Gear ()
     ipc.control(69873, 1)
     ipc.set("DispModeVar", 8)
    DspShow ("GEAR", "")
end

function PMDG_Disp_Fctl ()
     ipc.control(69874, 1)
     ipc.set("DispModeVar", 9)
    DspShow ("FCTL", "")
end

function PMDG_Disp_Cam ()
     ipc.control(69875, 1)
    DspShow ("CAM", "")
end

--

function PMDG_DispList_inc ()
    DispLVar = ipc.get("DispListVar")

    if DispLVar == 1 then PMDG_Disp_Comm ()
    elseif DispLVar == 2 then PMDG_Disp_Nav ()

    elseif DispLVar == 3 then PMDG_Disp_Chkl ()
    end
end

function PMDG_DispList_dec ()
    DispLVar = ipc.get("DispListVar")
    if DispLVar == 2 then PMDG_Disp_Chkl ()
    elseif DispLVar == 3 then PMDG_Disp_Comm ()

    elseif DispLVar == 1 then PMDG_Disp_Nav ()
    end
end

function PMDG_Disp_Chkl ()
     ipc.control(69876, 1)
     ipc.set("DispListVar", 1)
    DspShow ("CHKL", "")
end


function PMDG_Disp_Comm ()
     ipc.control(69877, 1)
     ipc.set("DispListVar", 2)
    DspShow ("COMM", "")
end

function PMDG_Disp_Nav ()
     ipc.control(69878, 1)
     ipc.set("DispListVar", 3)
    DspShow ("NAV", "")
end

function PMDG_Disp_CancRcl ()
     ipc.control(69879, 1)
    DspShow ("CANC", "RCL")
end

----

function PMDG_Toggle_Chkl_Stat ()
     if ipc.get("ChkListVar") == 1 then
     ipc.set("ChkListVar", 0)

        DispVar = ipc.get("DispModeVar")
        if DispVar == 1 then PMDG_Disp_Eng ()
        elseif DispVar == 2 then PMDG_Disp_Stat ()
        elseif DispVar == 3 then PMDG_Disp_Elec ()
        elseif DispVar == 4 then PMDG_Disp_Hyd ()
        elseif DispVar == 5 then PMDG_Disp_Fuel ()
        elseif DispVar == 6 then PMDG_Disp_Air ()
        elseif DispVar == 7 then PMDG_Disp_Door ()
        elseif DispVar == 8 then PMDG_Disp_Gear ()
        elseif DispVar == 9 then PMDG_Disp_Fctl ()
        end
    else

     ipc.control(69876, 1)
     ipc.set("DispListVar", 1)
     ipc.set("ChkListVar", 1)
     end
    DspShow ("CHKL", "")
end



-- ## Forward Panel - Autobrakes ###############

function PMDG_Autobrake_show ()
    ipc.sleep(10)
    ABvar = ipc.readLvar('switch_292_a')
    if ABvar == 0 then ABtxt = "RTO"
    elseif ABvar == 10 then ABtxt = "off"
    elseif ABvar == 20 then ABtxt = "DArm"
    elseif ABvar == 30 then ABtxt = "1"
    elseif ABvar == 40 then ABtxt = "2"
    elseif ABvar == 50 then ABtxt = "3"
    elseif ABvar == 60 then ABtxt = "4"
    elseif ABvar == 70 then ABtxt = "MAX"
    end
    DspShow ("ABrk", ABtxt, "AUTOBRKE", ABtxt )
end

function PMDG_Autobrake_inc ()

    ipc.control(69924, 256)
    PMDG_Autobrake_show ()
end

function PMDG_Autobrake_dec ()

    ipc.control(69924, 128)
    PMDG_Autobrake_show ()
end

function ABS_AUTOBRAKE_SELECTOR_rto ()
	ipc.control(PMDGBaseVariable +292, 0)
    PMDG_Autobrake_show ()
end

function ABS_AUTOBRAKE_SELECTOR_off ()
	ipc.control(PMDGBaseVariable +292, 1)
    PMDG_Autobrake_show ()
end

function ABS_AUTOBRAKE_SELECTOR_disarm ()
	ipc.control(PMDGBaseVariable +292, 2)
    PMDG_Autobrake_show ()
end

function ABS_AUTOBRAKE_SELECTOR_1 ()
	ipc.control(PMDGBaseVariable +292, 3)
    PMDG_Autobrake_show ()
end

function ABS_AUTOBRAKE_SELECTOR_2 ()
	ipc.control(PMDGBaseVariable +292, 4)
    PMDG_Autobrake_show ()
end

function ABS_AUTOBRAKE_SELECTOR_3 ()
	ipc.control(PMDGBaseVariable +292, 5)
    PMDG_Autobrake_show ()
end

function ABS_AUTOBRAKE_SELECTOR_4 ()
	ipc.control(PMDGBaseVariable +292, 6)
    PMDG_Autobrake_show ()
end

function ABS_AUTOBRAKE_SELECTOR_max ()
	ipc.control(PMDGBaseVariable +292, 7)
    PMDG_Autobrake_show ()
end





 -- ## Pedestal - Fuel Control

function ENG1_START_LEVER_run ()
	if ipc.readLvar("switch_520_a") == 100 then
	ipc.control(PMDGBaseVariable +520, 0)
	DspShow ("ENG1", "run", "FUEL ENG1", "run")
	end
end

function ENG1_START_LEVER_cutoff ()
	if ipc.readLvar("switch_520_a") == 0 then
	ipc.control(PMDGBaseVariable +520, 1)
	DspShow ("ENG1", "run", "FUEL ENG1", "cutoff")
	end
end

function ENG1_START_LEVER_toggle ()
	if _tl("switch_520_a", 100) then
       ENG1_START_LEVER_run ()
	else
       ENG1_START_LEVER_cutoff ()
	end
end

function ENG2_START_LEVER_run ()
	if ipc.readLvar("switch_521_a") == 100 then
	ipc.control(PMDGBaseVariable +521, 0)
 DspShow ("ENG2", "run", "FUEL ENG2", "run")
	end
end

function ENG2_START_LEVER_cutoff ()
	if ipc.readLvar("switch_521_a") == 0 then
	ipc.control(PMDGBaseVariable +521, 1)
 DspShow ("ENG2", "off", "FUEL ENG2", "cutoff")
	end
end

function ENG2_START_LEVER_toggle ()
	if _tl("switch_521_a", 100) then
       ENG2_START_LEVER_run ()
	else
       ENG2_START_LEVER_cutoff ()
	end
end

-- ## Pedestal - Control Stand ###############



function ALT_PITCH_TRIM_show ()
    ipc.sleep(10)
    PitchVar = ipc.readLvar("NGXHStabTrim")+1
    PitchVarRound = (PitchVar*0.15)-(math.floor(PitchVar*0.15))

    if PitchVarRound >= 0 and PitchVarRound < 0.15 then
    PitchVarRoundTxt = "00"
    elseif PitchVarRound >= 0.16 and PitchVarRound < 0.35 then
    PitchVarRoundTxt = "25"
    elseif PitchVarRound >= 0.36 and PitchVarRound < 0.65 then
    PitchVarRoundTxt = "50"
    elseif PitchVarRound >= 0.66 and PitchVarRound < 0.85 then
    PitchVarRoundTxt = "75"
    elseif PitchVarRound >= 0.86 and PitchVarRound < 0.99 then
    PitchVarRoundTxt = "00"

    end
    DspShow ("TRIM", math.floor(PitchVar*0.15).. "." .. PitchVarRoundTxt)
end



function ALT_PITCH_TRIM_LEVER_neutral ()
	ipc.control(PMDGBaseVariable +496, 1)
    ALT_PITCH_TRIM_show ()
end

function ALT_PITCH_TRIM_LEVER_up ()
	ipc.control(PMDGBaseVariable +496, 2)
    ALT_PITCH_TRIM_show ()
end

function ALT_PITCH_TRIM_LEVER_down ()
	ipc.control(PMDGBaseVariable +496, 0)
    ALT_PITCH_TRIM_show ()
end


function PMDG_Spoilers_arm ()
    if ipc.readLvar("switch_498_a") < 100 then
    ipc.control(74614, 536870912)
    end
    DspShow ("Splr", "arm")
end

function PMDG_Spoilers_disarm ()
    if ipc.readLvar("switch_498_a") > 0 then
    ipc.control(74614, 536870912)
    end
    DspShow ("Splr", "off")
end





 -- ## Pedestal - Aft Aisle - WX RADAR panel
function WXR_L_TFR ()
	if ipc.readLvar("switch_576_a") == 0 then
	ipc.control(PMDGBaseVariable +576,1)
	DspShow ("WXR", "TFR")
	end
end

function WXR_L_WX ()
	if ipc.readLvar("switch_577_a") == 0 then
	ipc.control(PMDGBaseVariable +577,1)
	DspShow ("WXR", "WX")
	end
end

function WXR_L_WX_T ()
	if ipc.readLvar("switch_578_a") == 0 then
	ipc.control(PMDGBaseVariable +578, 1)
	DspShow ("WXR", "WX+T")
	end
end

function WXR_L_MAP ()
	if ipc.readLvar("switch_579_a") == 0 then
	ipc.control(PMDGBaseVariable +579,1)
	DspShow ("WXR", "MAP")
	end
end

function WXR_L_GC ()
	if ipc.readLvar("switch_580_a") == 0 then
	ipc.control(PMDGBaseVariable +580,1)
	DspShow ("WXR", "GC")
	end
end

function WXR_AUTO ()
	if ipc.readLvar("switch_583_a") == 0 then
	ipc.control(PMDGBaseVariable +583,1)
	DspShow ("WXR", "AUTO")
	end
end

function WXR_L_R ()
	if ipc.readLvar("switch_584_a") == 0 then
	ipc.control(PMDGBaseVariable +584,1)
	DspShow ("WXR", "L-R")
	end
end

function WXR_TEST ()
	if ipc.readLvar("switch_585_a") == 0 then
	ipc.control(PMDGBaseVariable +585,1)
	DspShow ("WXR", "TEST")
	end
end

function WXR_R_TFR ()
	if ipc.readLvar("switch_588_a") == 0 then
	ipc.control(PMDGBaseVariable +588,1)
	DspShow ("WXR", "TFR", "WXR R", "TFR")
	end
end

function WXR_R_WX ()
	if ipc.readLvar("switch_589_a") == 0 then
	ipc.control(PMDGBaseVariable +589,1)
	DspShow ("WXR", "WX", "WXR R", "WX")
	end
end

function WXR_R_WX_T ()
	if ipc.readLvar("switch_590_a") == 0 then
	ipc.control(PMDGBaseVariable +590,1)
	DspShow ("WXR", "WX-T", "WXR R", "WX-T")
	end
end

function WXR_R_MAP ()
	if ipc.readLvar("switch_591_a") == 0 then
	ipc.control(PMDGBaseVariable +591,1)
	DspShow ("WXR", "MAP", "WXR R", "MAP")
	end
end

function WXR_R_GC ()
	if ipc.readLvar("switch_592_a") == 0 then
	ipc.control(PMDGBaseVariable +592,1)
	DspShow ("WXR", "GC", "WXR R", "GC")
	end
end



function WXR_L_TILT_CONTROL_inc ()
	WXRLtilt = ipc.readLvar("switch_581_a")
    if WXRLtilt == 21 then WXRLtilt = 21 end
    ipc.control(PMDGBaseVariable +581, WXRLtilt+1)

	DspShow ("TILT", "inc", "WXR TILT", "inc")
end

function WXR_L_TILT_CONTROL_dec ()
	WXRLtilt = ipc.readLvar("switch_581_a")
    if WXRLtilt == 0 then WXRLtilt = 0 end
    ipc.control(PMDGBaseVariable +581, WXRLtilt-1)

	DspShow ("TILT", "inc", "WXR TILT", "inc")
end

---

function WXR_L_GAIN_CONTROL_inc ()
	WXRLGAIN = ipc.readLvar("switch_582_a")
    if WXRLGAIN == 21 then WXRLGAIN = 21 end
    ipc.control(PMDGBaseVariable +582, WXRLGAIN+1)

	DspShow ("GAIN", "inc", "WXR GAIN", "inc")
end

function WXR_L_GAIN_CONTROL_dec ()
	WXRLGAIN = ipc.readLvar("switch_582_a")
    if WXRLGAIN == 0 then WXRLGAIN = 0 end
    ipc.control(PMDGBaseVariable +582, WXRLGAIN-1)

	DspShow ("GAIN", "inc", "WXR GAIN", "inc")
end

---
function WXR_R_TILT_CONTROL_inc ()
	WXRLtilt = ipc.readLvar("switch_586_a")
    if WXRLtilt == 21 then WXRLtilt = 21 end
    ipc.control(PMDGBaseVariable +586, WXRLtilt+1)

	DspShow ("TILT", "inc", "WXR TILT", "inc")
end

function WXR_R_TILT_CONTROL_dec ()
	WXRLtilt = ipc.readLvar("switch_586_a")
    if WXRLtilt == 0 then WXRLtilt = 0 end
    ipc.control(PMDGBaseVariable +586, WXRLtilt-1)

	DspShow ("TILT", "inc", "WXR TILT", "inc")
end

----

function WXR_R_GAIN_CONTROL_inc ()
	WXRLGAIN = ipc.readLvar("switch_587_a")
    if WXRLGAIN == 21 then WXRLGAIN = 21 end
    ipc.control(PMDGBaseVariable +587, WXRLGAIN+1)

	DspShow ("GAIN", "inc", "WXR GAIN", "inc")
end

function WXR_R_GAIN_CONTROL_dec ()
	WXRLGAIN = ipc.readLvar("switch_587_a")
    if WXRLGAIN == 0 then WXRLGAIN = 0 end
    ipc.control(PMDGBaseVariable +587, WXRLGAIN-1)

	DspShow ("GAIN", "inc", "WXR GAIN", "inc")
end

-- ## Pedestal - Aft Aisle Stand - TCAS panel

function TCAS_ALTSOURCE_altn ()
	if ipc.readLvar("switch_743_a") == 0 then
	ipc.control(PMDGBaseVariable +743,1)
	DspShow ("TCAS", "altn", "TCAS SRCE", "altn")
	end
end

function TCAS_ALTSOURCE_norm ()
	if ipc.readLvar("switch_743_a") == 100 then
	ipc.control(PMDGBaseVariable +743,0)
	DspShow ("TCAS", "norm", "TCAS SRCE", "norm")
	end
end

function TCAS_ALTSOURCE_toggle ()
	if _tl("switch_743_a", 0) then
       TCAS_ALTSOURCE_altn ()
	else
       TCAS_ALTSOURCE_norm ()
	end
end


function TCAS_IDENT ()
	if ipc.readLvar("switch_746_a") == 0 then
	ipc.control(PMDGBaseVariable +746,1)
 DspShow ("TCAS", "ident", "TCAS", "ident")
	end
end

function PMDG_TCAS_show ()
    ipc.sleep(10)
    TcasVar = ipc.readLvar("switch_749_a")

    if TcasVar == 0 then TcasTxt = "STBY"
    elseif TcasVar == 10 then TcasTxt = "ALT"
    elseif TcasVar == 20 then TcasTxt = "XPDR"
    elseif TcasVar == 30 then TcasTxt = "TA"
    elseif TcasVar == 40 then TcasTxt = "TARA"

    end

    if _MCP1() then
            DspShow ("TCAS", TcasTxt)
        else
            DspRadioShort(TcasTxt)
        end
end


function TCAS_MODE_stby ()
	ipc.control(PMDGBaseVariable +749,0)
    PMDG_TCAS_show ()
end

function TCAS_MODE_alt ()
	ipc.control(PMDGBaseVariable +749,1)
    PMDG_TCAS_show ()
end

function TCAS_MODE_xpndr ()
	ipc.control(PMDGBaseVariable +749,2)
    PMDG_TCAS_show ()
end

function TCAS_MODE_TA ()
	ipc.control(PMDGBaseVariable +749,3)
    PMDG_TCAS_show ()
end

function TCAS_MODE_TARA ()
	ipc.control(PMDGBaseVariable +749,4)
    PMDG_TCAS_show ()
end

function TCAS_TEST ()
	if ipc.readLvar("switch_7491_a") == 0 then
	ipc.control(PMDGBaseVariable +7491,1)
 DspShow ("TCAS", "on", "TCAS", "on")
	end
end

function TCAS_XPNDR_R ()
	if ipc.readLvar("switch_751_a") == 0 then
	ipc.control(PMDGBaseVariable +751,1)
 DspShow ("XPDR", "R", "XPDNR", "R")
	end
end

function TCAS_XPNDR_L ()
	if ipc.readLvar("switch_751_a") == 100 then
	ipc.control(PMDGBaseVariable +751,0)
 DspShow ("XPDR", "L", "XPDNR", "L")
	end
end

function TCAS_XPNDR_toggle ()
	if _tl("switch_751_a", 0) then
       TCAS_XPNDR_R ()
	else
       TCAS_XPNDR_L ()
	end
end


function PMDG_TCAS_inc ()
     ipc.control(70381, 256)
    PMDG_TCAS_show ()
end

function PMDG_TCAS_dec ()
     ipc.control(70381, 128)
    PMDG_TCAS_show ()
end







-- ## Warnings ###############

function PMDG_MasterWarn_Capt ()
    ipc.control(69809, 64)
    DspShow ("Mstr", "Warn")
end

function PMDG_MasterWarn_FO ()
    ipc.control(69904, 64)
    DspShow ("Mstr", "Warn")
end

function PMDG_GS_Inhibit ()
    ipc.control(69935, 64)
    DspShow ("G/S", "Inhb")
end


-- ## Clock ###############

function clock ()

    ipc.control(PMDGBaseVariable +165, 1)

    DspShow ("clck", " ", "Clock", "")
end

-- ## ADIRU ###############

function ADIRU_SWITCH_on ()
	ipc.control(PMDGBaseVariable +59, 1)
	DspShow ("ADRU", "on", "ADIRU", "on")
end

function ADIRU_SWITCH_off ()
	ipc.control(PMDGBaseVariable +59, 0)
	DspShow ("ADRU", "off", "ADIRU", "off")
end

function ADIRU_SWITCH_toggle ()
	if _tl("switch_59_a", 0) then
       ADIRU_SWITCH_on ()
	else
       ADIRU_SWITCH_off ()
	end
end







-- ## Doors Left ###############

function L_Entry_1L_open ()
    if ipc.readLvar("L:7X7XCabinDoor1L") == 0 then
    ipc.control(PMDGBaseVariable+14011)
    DspShow ("1 L", "open", "DOOR 1 L", "opening")
    end
end

function L_Entry_1L_close ()
    if ipc.readLvar("L:7X7XCabinDoor1L") == 100 then
    ipc.control(PMDGBaseVariable+14011)
    DspShow ("1 L", "clse", "DOOR 1 L", "closing")
    end
end

function L_Entry_1L_toggle ()
	if _tl("7X7XCabinDoor1L", 0) then
       L_Entry_1L_open ()
	else
       L_Entry_1L_close ()
	end
end

------------------

function L_Entry_2L_open ()
    if ipc.readLvar("L:7X7XCabinDoor2L") == 0 then
    ipc.control(PMDGBaseVariable+14013)
    DspShow ("2 L", "open", "DOOR 2 L", "opening")
    end
end

function L_Entry_2L_close ()
    if ipc.readLvar("L:7X7XCabinDoor2L") == 100 then
    ipc.control(PMDGBaseVariable+14013)
    DspShow ("2 L", "clse", "DOOR 2 L", "closing")
    end
end

function L_Entry_2L_toggle ()
	if _tl("7X7XCabinDoor2L", 0) then
       L_Entry_2L_open ()
	else
       L_Entry_2L_close ()
	end
end


------------------

function L_Entry_3L_open ()
    if ipc.readLvar("L:7X7XCabinDoor3L") == 0 then
    ipc.control(PMDGBaseVariable+14015)
    DspShow ("3 L", "open", "DOOR 3 L", "opening")
    end
end

function L_Entry_3L_close ()
    if ipc.readLvar("L:7X7XCabinDoor3L") == 100 then
    ipc.control(PMDGBaseVariable+14015)
    DspShow ("3 L", "clse", "DOOR 3 L", "closing")
    end
end

function L_Entry_3L_toggle ()
	if _tl("7X7XCabinDoor3L", 0) then
       L_Entry_3L_open ()
	else
       L_Entry_3L_close ()
	end
end

------------------

function L_Entry_4L_open ()
    if ipc.readLvar("L:7X7XCabinDoor4L") == 0 then
    ipc.control(PMDGBaseVariable+14017)
    DspShow ("4 L", "open", "DOOR 4 L", "opening")
    end
end

function L_Entry_4L_close ()
    if ipc.readLvar("L:7X7XCabinDoor4L") == 100 then
    ipc.control(PMDGBaseVariable+14017)
    DspShow ("4 L", "clse", "DOOR 4 L", "closing")
    end
end

function L_Entry_4L_toggle ()
	if _tl("7X7XCabinDoor4L", 0) then
       L_Entry_4L_open ()
	else
       L_Entry_4L_close ()
	end
end


------------------

function L_Entry_5L_open ()
    if ipc.readLvar("L:7X7XCabinDoor5L") == 0 then
    ipc.control(PMDGBaseVariable+14019)
    DspShow ("5 L", "open", "DOOR 5 L", "opening")
    end
end

function L_Entry_5L_close ()
    if ipc.readLvar("L:7X7XCabinDoor5L") == 100 then
    ipc.control(PMDGBaseVariable+14019)
    DspShow ("5 L", "clse", "DOOR 5 L", "closing")
    end
end

function L_Entry_5L_toggle ()
	if _tl("7X7XCabinDoor5L", 0) then
       L_Entry_5L_open ()
	else
       L_Entry_5L_close ()
	end
end

function L_Entries_All_open ()
    L_Entry_1L_open ()
    _sleep(200,1500)
    L_Entry_2L_open ()
    _sleep(200,1500)
    L_Entry_3L_open ()
    _sleep(200,1500)
    L_Entry_4L_open ()
    _sleep(200,1500)
    L_Entry_5L_open ()
end

function L_Entries_All_close ()
    L_Entry_1L_close ()
    _sleep(200,1500)
    L_Entry_2L_close ()
    _sleep(200,1500)
    L_Entry_3L_close ()
    _sleep(200,1500)
    L_Entry_4L_close ()
    _sleep(200,1500)
    L_Entry_5L_close ()
end

function L_Entries_All_toggle ()
    L_Entry_1L_toggle ()
    _sleep(200,1500)
    L_Entry_2L_toggle ()
    _sleep(200,1500)
    L_Entry_3L_toggle ()
    _sleep(200,1500)
    L_Entry_4L_toggle ()
    _sleep(200,1500)
    L_Entry_5L_toggle ()
end



function L_Entries_GSX_open ()

    acftname = ipc.readSTR("3D00", 35)
    if string.find(acftname,"PMDG 777-2",0,true) then
    L_Entry_1L_open ()
    _sleep(200,1500)
    L_Entry_2L_open ()
    _sleep(200,1500)
    L_Entry_4L_open ()

    elseif string.find(acftname,"777F",0,true) then
    L_Entry_1L_open ()


    elseif string.find(acftname,"PMDG 777-3",0,true) then
    L_Entry_1L_open ()
    _sleep(200,1500)
    L_Entry_2L_open ()
    _sleep(200,1500)
    L_Entry_5L_open ()
    end
end

function L_Entries_GSX_close ()

    acftname = ipc.readSTR("3D00", 35)
    if string.find(acftname,"PMDG 777-2",0,true) then
    L_Entry_1L_close ()
    _sleep(200,1500)
    L_Entry_2L_close ()
    _sleep(200,1500)
    L_Entry_4L_close ()

    elseif string.find(acftname,"777F",0,true) then
    L_Entry_1L_close ()


    elseif string.find(acftname,"PMDG 777-3",0,true) then
    L_Entry_1L_close ()
    _sleep(200,1500)
    L_Entry_2L_close ()
    _sleep(200,1500)
    L_Entry_5L_close ()
    end

end

function L_Entries_GSX_toggle ()

    acftname = ipc.readSTR("3D00", 35)
    if string.find(acftname,"PMDG 777-2",0,true) then
    L_Entry_1L_toggle ()
    _sleep(200,1500)
    L_Entry_2L_toggle ()
    _sleep(200,1500)
    L_Entry_4L_toggle ()

    elseif string.find(acftname,"777F",0,true) then
    L_Entry_1L_toggle ()


    elseif string.find(acftname,"PMDG 777-3",0,true) then
    L_Entry_1L_toggle ()
    _sleep(200,1500)
    L_Entry_2L_toggle ()
    _sleep(200,1500)
    L_Entry_5L_toggle ()
    end

end

-------------------------------------------
-------------------------------------------

-- ## Doors right ###############

function R_Entry_1R_open ()
    if ipc.readLvar("L:7X7XCabinDoor1R") == 0 then
    ipc.control(PMDGBaseVariable+14012)
    DspShow ("1 R", "open", "DOOR 1 R", "opening")
    end
end

function R_Entry_1R_close ()
    if ipc.readLvar("L:7X7XCabinDoor1R") == 100 then
    ipc.control(PMDGBaseVariable+14012)
    DspShow ("1 R", "clse", "DOOR 1 R", "closing")
    end
end

function R_Entry_1R_toggle ()
	if _tl("7X7XCabinDoor1R", 0) then
       R_Entry_1R_open ()
	else
       R_Entry_1R_close ()
	end
end

------------------

function R_Entry_2R_open ()
    if ipc.readLvar("L:7X7XCabinDoor2R") == 0 then
    ipc.control(PMDGBaseVariable+14014)
    DspShow ("2 R", "open", "DOOR 2 R", "opening")
    end
end

function R_Entry_2R_close ()
    if ipc.readLvar("L:7X7XCabinDoor2R") == 100 then
    ipc.control(PMDGBaseVariable+14014)
    DspShow ("2 R", "clse", "DOOR 2 R", "closing")
    end
end

function R_Entry_2R_toggle ()
	if _tl("7X7XCabinDoor2R", 0) then
       R_Entry_2R_open ()
	else
       R_Entry_2R_close ()
	end
end


------------------

function R_Entry_3R_open ()
    if ipc.readLvar("L:7X7XCabinDoor3R") == 0 then
    ipc.control(PMDGBaseVariable+14016)
    DspShow ("3 R", "open", "DOOR 3 R", "opening")
    end
end

function R_Entry_3R_close ()
    if ipc.readLvar("L:7X7XCabinDoor3R") == 100 then
    ipc.control(PMDGBaseVariable+14016)
    DspShow ("3 R", "clse", "DOOR 3 R", "closing")
    end
end

function R_Entry_3R_toggle ()
	if _tl("7X7XCabinDoor3R", 0) then
       R_Entry_3R_open ()
	else
       R_Entry_3R_close ()
	end
end

------------------

function R_Entry_4R_open ()
    if ipc.readLvar("L:7X7XCabinDoor4R") == 0 then
    ipc.control(PMDGBaseVariable+14018)
    DspShow ("4 R", "open", "DOOR 4 R", "opening")
    end
end

function R_Entry_4R_close ()
    if ipc.readLvar("L:7X7XCabinDoor4R") == 100 then
    ipc.control(PMDGBaseVariable+14018)
    DspShow ("4 R", "clse", "DOOR 4 R", "closing")
    end
end

function R_Entry_4R_toggle ()
	if _tl("7X7XCabinDoor4R", 0) then
       R_Entry_4R_open ()
	else
       R_Entry_4R_close ()
	end
end


------------------

function R_Entry_5R_open ()
    if ipc.readLvar("L:7X7XCabinDoor5R") == 0 then
    ipc.control(PMDGBaseVariable+14020)
    DspShow ("5 R", "open", "DOOR 5 R", "opening")
    end
end

function R_Entry_5R_close ()
    if ipc.readLvar("L:7X7XCabinDoor5R") == 100 then
    ipc.control(PMDGBaseVariable+14020)
    DspShow ("5 R", "clse", "DOOR 5 R", "closing")
    end
end

function R_Entry_5R_toggle ()
	if _tl("7X7XCabinDoor5R", 0) then
       R_Entry_5R_open ()
	else
       R_Entry_5R_close ()
	end
end


function R_Entries_All_open ()
    R_Entry_1R_open ()
    _sleep(200,1500)
    R_Entry_2R_open ()
    _sleep(200,1500)
    R_Entry_3R_open ()
    _sleep(200,1500)
    R_Entry_4R_open ()
    _sleep(200,1500)
    R_Entry_5R_open ()
end

function R_Entries_All_close ()
    R_Entry_1R_close ()
    _sleep(200,1500)
    R_Entry_2R_close ()
    _sleep(200,1500)
    R_Entry_3R_close ()
    _sleep(200,1500)
    R_Entry_4R_close ()
    _sleep(200,1500)
    R_Entry_5R_close ()
end

function R_Entries_All_toggle ()
    R_Entry_1R_toggle ()
    _sleep(200,1500)
    R_Entry_2R_toggle ()
    _sleep(200,1500)
    R_Entry_3R_toggle ()
    _sleep(200,1500)
    R_Entry_4R_toggle ()
    _sleep(200,1500)
    R_Entry_5R_toggle ()
end



function R_Entries_GSX_open ()

    acftname = ipc.readSTR("3D00", 35)
    if string.find(acftname,"PMDG 777-2",0,true) then
    R_Entry_2R_open ()
    _sleep(200,1500)
    R_Entry_4R_open ()

    elseif string.find(acftname,"777F",0,true) then
    R_Entry_1R_open ()


    elseif string.find(acftname,"PMDG 777-3",0,true) then
    R_Entry_2R_open ()
    _sleep(200,1500)
    R_Entry_5R_open ()
    end

end

function R_Entries_GSX_close ()

    acftname = ipc.readSTR("3D00", 35)
    if string.find(acftname,"PMDG 777-2",0,true) then
    R_Entry_2R_close ()
    _sleep(200,1500)
    R_Entry_4R_close ()

    elseif string.find(acftname,"777F",0,true) then
    R_Entry_1R_close ()


    elseif string.find(acftname,"PMDG 777-3",0,true) then
    R_Entry_2R_close ()
    _sleep(200,1500)
    R_Entry_5R_close ()
    end

end

function R_Entries_GSX_toggle ()

    acftname = ipc.readSTR("3D00", 35)
    if string.find(acftname,"PMDG 777-2",0,true) then
    R_Entry_2R_toggle ()
    _sleep(200,1500)
    R_Entry_4R_toggle ()

    elseif string.find(acftname,"777F",0,true) then
    R_Entry_1R_toggle ()


    elseif string.find(acftname,"PMDG 777-3",0,true) then
    R_Entry_2R_toggle ()
    _sleep(200,1500)
    R_Entry_5R_toggle ()
    end

end


-- ## Cargo and Access ###############

--------- cargo --------------
------------------

function Cargo_FWD_open ()
    if ipc.readLvar("L:7X7XforwardcargoDoor") == 0 then
    ipc.control(PMDGBaseVariable+14021)
    DspShow ("Crgo", "fwd", "FwdCargo", "opening")
    end
end

function Cargo_FWD_close ()
    if ipc.readLvar("L:7X7XforwardcargoDoor") == 100 then
    ipc.control(PMDGBaseVariable+14021)
    DspShow ("Crgo", "fwd", "FwdCargo", "closing")
    end
end

function Cargo_FWD_toggle ()
	if _tl("7X7XforwardcargoDoor", 0) then
       Cargo_FWD_open ()
	else
       Cargo_FWD_close ()
	end
end

---

function Cargo_AFT_open ()
    if ipc.readLvar("L:7X7XaftcargoDoor") == 0 then
    ipc.control(PMDGBaseVariable+14022)
    DspShow ("Crgo", "aft", "AftCargo", "opening")
    end
end

function Cargo_AFT_close ()
    if ipc.readLvar("L:7X7XaftcargoDoor") == 100 then
    ipc.control(PMDGBaseVariable+14022)
    DspShow ("Crgo", "aft", "AftCargo", "closing")
    end
end

function Cargo_AFT_toggle ()
	if _tl("7X7XaftcargoDoor", 0) then
       Cargo_AFT_open ()
	else
       Cargo_AFT_close ()
	end
end


------
---

function Cargo_BULK_open ()
    if ipc.readLvar("L:7X7XbulkcargoDoor") == 0 then
    ipc.control(PMDGBaseVariable+14023)
    DspShow ("Bulk", "open", "Bulk", "opening")
    end
end

function Cargo_BULK_close ()
    if ipc.readLvar("L:7X7XbulkcargoDoor") == 100 then
    ipc.control(PMDGBaseVariable+14023)
    DspShow ("Bulk", "open", "Bulk", "closing")
    end
end

function Cargo_BULK_toggle ()
	if _tl("7X7XbulkcargoDoor", 0) then
       Cargo_BULK_open ()
	else
       Cargo_BULK_close ()
	end
end


---

function Cargo_MAIN_open ()
    if ipc.readLvar("L:7X7XmaincargoDoor") == 0 then
    ipc.control(PMDGBaseVariable+14024)
    DspShow ("Main", "open", "MainCrgo", "opening")
    end
end

function Cargo_MAIN_close ()
    if ipc.readLvar("L:7X7XmaincargoDoor") == 100 then
    ipc.control(PMDGBaseVariable+14024)
    DspShow ("Main", "clse", "MainCrgo", "closing")
    end
end

function Cargo_MAIN_toggle ()
	if _tl("7X7XmaincargoDoor", 0) then
       Cargo_MAIN_open ()
	else
       Cargo_MAIN_close ()
	end
end


function All_Cargo_open ()

    Cargo_MAIN_open ()
    _sleep(500,2000)
    Cargo_FWD_open ()
    _sleep(500,2000)
    Cargo_AFT_open ()
    _sleep(500,2000)
    Cargo_BULK_open ()

end

function All_Cargo_close ()

    Cargo_MAIN_close ()
    _sleep(500,2000)
    Cargo_FWD_close ()
    _sleep(500,2000)
    Cargo_AFT_close ()
    _sleep(500,2000)
    Cargo_BULK_close ()

end

function All_Cargo_toggle ()
    Cargo_MAIN_toggle ()
    _sleep(500,2000)
    Cargo_FWD_toggle ()
    _sleep(500,2000)
    Cargo_AFT_toggle ()
    _sleep(500,2000)
    Cargo_BULK_toggle ()


end




----
---

function Fwd_Access_open ()
    if ipc.readLvar("L:7X7XavionicsDoor") == 0 then
    ipc.control(PMDGBaseVariable+14025)
    DspShow ("Fwd", "Avio", "Fwd Avio", "opening")
    end
end

function Fwd_Access_close ()
    if ipc.readLvar("L:7X7XavionicsDoor") == 100 then
    ipc.control(PMDGBaseVariable+14025)
    DspShow ("Fwd", "Avio", "Fwd Avio", "closing")
    end
end

function Fwd_Access_toggle ()
	if _tl("7X7XavionicsDoor", 0) then
       Fwd_Access_open ()
	else
       Fwd_Access_close ()
	end
end

---

function Fwd_EE_open ()
    if ipc.readLvar("L:7X7XEEDoor") == 0 then
    ipc.control(PMDGBaseVariable+14026)
    DspShow ("EE", "open", "Door EE", "opening")
    end
end

function Fwd_EE_close ()
    if ipc.readLvar("L:7X7XEEDoor") == 100 then
    ipc.control(PMDGBaseVariable+14026)
    DspShow ("EE", "open", "Door EE", "closing")
    end
end

function Fwd_EE_toggle ()
	if _tl("7X7XEEDoor", 0) then
       Fwd_EE_open ()
	else
       Fwd_EE_close ()
	end
end


---------------------------















-- ## Captain's CDU ###############

-- Startvariable is CDULstartVar = 328
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

function CDU_L_ALTN()
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
        ipc.control(PMDGBaseVariable +4201, 1)
end

function CDU_L_PROG()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 20, 1)
end

function CDU_L_EXEC()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 21, 1)
end

function CDU_L_MENU()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 22, 1)
end

function CDU_L_NAVRAD()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 23, 1)
end

function CDU_L_PREVPAGE()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 24, 1)
end

function CDU_L_NEXTPAGE()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 25, 1)
end

function CDU_L_1()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 26, 1)
end

function CDU_L_2()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 27, 1)
end

function CDU_L_3()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 28, 1)
end

function CDU_L_4()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 29, 1)
end

function CDU_L_5()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 30, 1)
end

function CDU_L_6()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 31, 1)
end

function CDU_L_7()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 32, 1)
end

function CDU_L_8()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 33, 1)
end

function CDU_L_9()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 34, 1)
end

function CDU_L_PERIOD()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 35, 1)
end

function CDU_L_0()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 36, 1)
end

------

function CDU_L_PLUSMIN()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 37, 1)
end

-----------

function CDU_L_A()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 38, 1)
end

function CDU_L_B()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 39, 1)
end

function CDU_L_C()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 40, 1)
end

function CDU_L_D()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 41, 1)
end

function CDU_L_E()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 42, 1)
end

function CDU_L_F()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 43, 1)
end

function CDU_L_G()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 44, 1)
end

function CDU_L_H()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 45, 1)
end

function CDU_L_I()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 46, 1)
end

function CDU_L_J()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 47, 1)
end

function CDU_L_K()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 48, 1)
end

function CDU_L_L()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 49, 1)
end

function CDU_L_M()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 50, 1)
end

function CDU_L_N()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 51, 1)
end

function CDU_L_O()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 52, 1)
end

function CDU_L_P()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 53, 1)
end

function CDU_L_Q()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 54, 1)
end

function CDU_L_R()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 55, 1)
end

function CDU_L_S()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 56, 1)
end

function CDU_L_T()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 57, 1)
end

function CDU_L_U()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 58, 1)
end

function CDU_L_V()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 59, 1)
end

function CDU_L_W()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 60, 1)
end

function CDU_L_X()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 61, 1)
end

function CDU_L_Y()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 62, 1)
end

function CDU_L_Z()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 63, 1)
end

function CDU_L_SP()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 64, 1)
end

function CDU_L_DEL()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 65, 1)
end

function CDU_L_DIAGONAL()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 66, 1)
end

function CDU_L_CLR()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 67, 1)
end





function CDU_L_BRTMIN()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 72, 0)
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDULstartVar+ 72, 1)
end

function CDU_L_BRTPLUS()
        ipc.control(PMDGBaseVariable +CDULstartVar+ 72, 2)
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDULstartVar+ 72, 1)
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

function CDU_L_GroundConn()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK1R() -- GroundConn

    DspShow ("CDU1", "Conn")
end

function CDU_L_GroundOps()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK2R() -- GroundOps

    DspShow ("CDU1", "Ops")
end

function CDU_L_GroundMaint()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK3R() -- GroundMaint

    DspShow ("CDU1", "Mtnc")
end

function CDU_L_CabLights()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK4R() -- CabLights

    DspShow ("CDU1", "Lght")
end

function CDU_L_AutoFlight()

    CDU_L_MENU()
    ipc.sleep(20)
    CDU_L_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_L_LSK5R() -- AutoFlight

    DspShow ("CDU1", "Aflt")
end




-- ## Capt CDU Ground Connections ###############

function CDU_L_Wheel_Chocks_on ()
    if ipc.readLvar("NGXWheelChocks") == 0 then
    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK1L()
    end

    DspShow ("Chks", "on", "Chocks", "on")
end

function CDU_L_Wheel_Chocks_off ()
    if ipc.readLvar("NGXWheelChocks") == 1 then
    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK1L()
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



function CDU_L_PowerType_dual ()
    if ipc.readLvar("NGXGPU") == 0 and ipc.readLvar("7X7X_terminalpowerconnection") == 0 then
    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK2L()
    end
    DspShow ("PwrT", "dual", "PwerType", "dual")
end

function CDU_L_PowerType_single ()
    if ipc.readLvar("NGXGPU") == 1 then
    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK2L()
    end
    DspShow ("PwrT", "sgle", "PwerType", "single")
end

function CDU_L_PowerType_toggle ()
	if _tl("NGXGPU", 0) then
    CDU_L_PowerType_dual ()
	else
    CDU_L_PowerType_single ()
	end
end


function CDU_L_ExtPower_on ()
    if ipc.readLvar("NGXGPU") == 0 and ipc.readLvar("7X7X_terminalpowerconnection") == 0 then

    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK3L()

    DspShow ("GND", "Pwr", "GND PWR", "conn on")
    end
end

function CDU_L_ExtPower_off ()
    if ipc.readLvar("NGXGPU") == 1 or ipc.readLvar("7X7X_terminalpowerconnection") == 1 then

    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK3L()

    DspShow ("GND", "Pwr", "GND PWR", "conn off")
    end
end



function CDU_L_AirStart_on ()
    if ipc.readLvar("NGXAirStartCart") == 0 then
    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK4L()
    end
    DspShow ("AirS", "on", "Airstart", "Unit on")
end

function CDU_L_AirStart_off ()
    if ipc.readLvar("NGXAirStartCart") == 1 then
    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK4L()
    end
    DspShow ("AirS", "off", "Airstart", "Unit off")
end

function CDU_L_AirStart_toggle ()
	if _tl("NGXAirStartCart", 0) then
      CDU_L_AirStart_on ()
	else
      CDU_L_AirStart_off ()
	end
end

function CDU_L_AirCondition_on ()
    if ipc.readLvar("NGXGSU") == 0 then
    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK5L()
    end
    DspShow ("A/C", "on", "AirCond", "on")
end

function CDU_L_AirCondition_off ()
    if ipc.readLvar("NGXGSU") == 1 then
    CDU_L_GroundConn()
    ipc.sleep(20)
    CDU_L_LSK5L()
    end
    DspShow ("A/C", "off", "AirCond", "off")
end

function CDU_L_AirCondition_toggle ()
	if _tl("NGXGSU", 0) then
      CDU_L_AirCondition_on ()
	else
      CDU_L_AirCondition_off ()
	end

end

---






-- ## First Officer's CDU ###############

-- Startvariable is CDURstartVar = 401
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

function CDU_R_ALTN()
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
        ipc.control(PMDGBaseVariable +4201, 1)
end

function CDU_R_PROG()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 20, 1)
end

function CDU_R_EXEC()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 21, 1)
end

function CDU_R_MENU()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 22, 1)
end

function CDU_R_NAVRAD()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 23, 1)
end

function CDU_R_PREVPAGE()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 24, 1)
end

function CDU_R_NEXTPAGE()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 25, 1)
end

function CDU_R_1()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 26, 1)
end

function CDU_R_2()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 27, 1)
end

function CDU_R_3()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 28, 1)
end

function CDU_R_4()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 29, 1)
end

function CDU_R_5()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 30, 1)
end

function CDU_R_6()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 31, 1)
end

function CDU_R_7()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 32, 1)
end

function CDU_R_8()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 33, 1)
end

function CDU_R_9()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 34, 1)
end

function CDU_R_PERIOD()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 35, 1)
end

function CDU_R_0()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 36, 1)
end

------

function CDU_R_PLUSMIN()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 37, 1)
end

-----------

function CDU_R_A()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 38, 1)
end

function CDU_R_B()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 39, 1)
end

function CDU_R_C()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 40, 1)
end

function CDU_R_D()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 41, 1)
end

function CDU_R_E()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 42, 1)
end

function CDU_R_F()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 43, 1)
end

function CDU_R_G()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 44, 1)
end

function CDU_R_H()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 45, 1)
end

function CDU_R_I()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 46, 1)
end

function CDU_R_J()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 47, 1)
end

function CDU_R_K()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 48, 1)
end

function CDU_R_L()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 49, 1)
end

function CDU_R_M()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 50, 1)
end

function CDU_R_N()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 51, 1)
end

function CDU_R_O()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 52, 1)
end

function CDU_R_P()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 53, 1)
end

function CDU_R_Q()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 54, 1)
end

function CDU_R_R()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 55, 1)
end

function CDU_R_S()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 56, 1)
end

function CDU_R_T()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 57, 1)
end

function CDU_R_U()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 58, 1)
end

function CDU_R_V()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 59, 1)
end

function CDU_R_W()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 60, 1)
end

function CDU_R_X()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 61, 1)
end

function CDU_R_Y()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 62, 1)
end

function CDU_R_Z()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 63, 1)
end

function CDU_R_SP()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 64, 1)
end

function CDU_R_DEL()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 65, 1)
end

function CDU_R_DIAGONAL()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 66, 1)
end

function CDU_R_CLR()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 67, 1)
end





function CDU_R_BRTMIN()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 72, 0)
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDURstartVar+ 72, 1)
end

function CDU_R_BRTPLUS()
        ipc.control(PMDGBaseVariable +CDURstartVar+ 72, 2)
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDURstartVar+ 72, 1)
end



-- ## FO CDU Pages ###############

function CDU_R_Fuel()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK1L() -- Fuel

    DspShow ("CDU2", "Fuel")
end

function CDU_R_Payload()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK2L() -- Payload

    DspShow ("CDU2", "Payl")
end

function CDU_R_Doors()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK3L() -- Doors

    DspShow ("CDU2", "Door")
end

function CDU_R_Pushback()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK4L() -- Pushback

    DspShow ("CDU2", "Push")
end

function CDU_R_GroundConn()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK1R() -- GroundConn

    DspShow ("CDU2", "Conn")
end

function CDU_R_GroundOps()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK2R() -- GroundOps

    DspShow ("CDU2", "Ops")
end

function CDU_R_GroundMaint()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK3R() -- GroundMaint

    DspShow ("CDU2", "Mtnc")
end

function CDU_R_CabLights()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK4R() -- CabLights

    DspShow ("CDU2", "Lght")
end

function CDU_R_AutoFlight()

    CDU_R_MENU()
    ipc.sleep(20)
    CDU_R_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_R_LSK5R() -- AutoFlight

    DspShow ("CDU2", "Aflt")
end







-- ## FO CDU Ground Connections ###############

function CDU_R_Wheel_Chocks_on ()
    if ipc.readLvar("NGXWheelChocks") == 0 then
    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK1L()
    end

    DspShow ("Chks", "on", "Chocks", "on")
end

function CDU_R_Wheel_Chocks_off ()
    if ipc.readLvar("NGXWheelChocks") == 1 then
    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK1L()
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

---

function CDU_R_PowerType_dual ()
    if ipc.readLvar("NGXGPU") == 0 then
    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK2L()
    end
    DspShow ("PwrT", "dual", "PwerType", "dual")
end

function CDU_R_PowerType_single ()
    if ipc.readLvar("NGXGPU") == 1 then
    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK2L()
    end
    DspShow ("PwrT", "sgle", "PwerType", "single")
end

function CDU_R_PowerType_toggle ()
	if _tl("NGXGPU", 0) then
    CDU_R_PowerType_dual ()
	else
    CDU_R_PowerType_single ()
	end
end


---

function CDU_R_ExtPower_on ()
    if ipc.readLvar("NGXGPU") == 0 and ipc.readLvar("7X7X_terminalpowerconnection") == 0 then

    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK3L()

    DspShow ("GND", "Pwr", "GND PWR", "conn on")
    end
end

function CDU_R_ExtPower_off ()
    if ipc.readLvar("NGXGPU") == 1 or ipc.readLvar("7X7X_terminalpowerconnection") == 1 then

    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK3L()

    DspShow ("GND", "Pwr", "GND PWR", "conn off")
    end
end

function CDU_R_AirStart_on ()
    if ipc.readLvar("NGXAirStartCart") == 0 then
    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK4L()
    end
    DspShow ("AirS", "on", "Airstart", "Unit on")
end

function CDU_R_AirStart_off ()
    if ipc.readLvar("NGXAirStartCart") == 1 then
    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK4L()
    end
    DspShow ("AirS", "off", "Airstart", "Unit off")
end

function CDU_R_AirStart_toggle ()
	if _tl("NGXAirStartCart", 0) then
      CDU_R_AirStart_on ()
	else
      CDU_R_AirStart_off ()
	end
end

function CDU_R_AirCondition_on ()
    if ipc.readLvar("NGXGSU") == 0 then
    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK5L()
    end
    DspShow ("A/C", "on", "AirCond", "on")
end

function CDU_R_AirCondition_off ()
    if ipc.readLvar("NGXGSU") == 1 then
    CDU_R_GroundConn()
    ipc.sleep(20)
    CDU_R_LSK5L()
    end
    DspShow ("A/C", "off", "AirCond", "off")
end

function CDU_R_AirCondition_toggle ()
	if _tl("NGXGSU", 0) then
      CDU_R_AirCondition_on ()
	else
      CDU_R_AirCondition_off ()
	end

end

---

-- ## Center CDU ###############
-- Startvariable is CDUCstartVar = 653
-- edit if necessary in function InitVars

function CDU_C_LSK1L()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 0, 1)
end

function CDU_C_LSK2L()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 1, 1)
end

function CDU_C_LSK3L()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 2, 1)
end

function CDU_C_LSK4L()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 3, 1)
end

function CDU_C_LSK5L()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 4, 1)
end

function CDU_C_LSK6L()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 5, 1)
end

function CDU_C_LSK1R()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 6, 1)
end

function CDU_C_LSK2R()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 7, 1)
end

function CDU_C_LSK3R()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 8, 1)
end

function CDU_C_LSK4R()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 9, 1)
end

function CDU_C_LSK5R()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 10, 1)
end

function CDU_C_LSK6R()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 11, 1)
end

------------------

function CDU_C_INITREF()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 12, 1)
end

function CDU_C_RTE()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 13, 1)
end

function CDU_C_DEPARR()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 14, 1)
end

function CDU_C_ALTN()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 15, 1)
end

function CDU_C_VNAV()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 16, 1)
end

function CDU_C_FIX()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 17, 1)
end

function CDU_C_LEGS()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 18, 1)
end

function CDU_C_HOLD()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 19, 1)
end

function CDU_C_FMCCOMM()
        ipc.control(PMDGBaseVariable +4201, 1)
end

function CDU_C_PROG()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 20, 1)
end

function CDU_C_EXEC()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 21, 1)
end

function CDU_C_MENU()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 22, 0)
end

function CDU_C_NAVRAD()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 23, 1)
end

function CDU_C_PREVPAGE()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 24, 1)
end

function CDU_C_NEXTPAGE()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 25, 1)
end

function CDU_C_1()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 26, 1)
end

function CDU_C_2()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 27, 1)
end

function CDU_C_3()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 28, 1)
end

function CDU_C_4()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 29, 1)
end

function CDU_C_5()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 30, 1)
end

function CDU_C_6()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 31, 1)
end

function CDU_C_7()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 32, 1)
end

function CDU_C_8()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 33, 1)
end

function CDU_C_9()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 34, 1)
end

function CDU_C_PERIOD()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 35, 1)
end

function CDU_C_0()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 36, 1)
end

------

function CDU_C_PLUSMIN()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 37, 1)
end

-----------

function CDU_C_A()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 38, 1)
end

function CDU_C_B()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 39, 1)
end

function CDU_C_C()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 40, 1)
end

function CDU_C_D()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 41, 1)
end

function CDU_C_E()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 42, 1)
end

function CDU_C_F()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 43, 1)
end

function CDU_C_G()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 44, 1)
end

function CDU_C_H()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 45, 1)
end

function CDU_C_I()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 46, 1)
end

function CDU_C_J()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 47, 1)
end

function CDU_C_K()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 48, 1)
end

function CDU_C_L()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 49, 1)
end

function CDU_C_M()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 50, 1)
end

function CDU_C_N()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 51, 1)
end

function CDU_C_O()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 52, 1)
end

function CDU_C_P()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 53, 1)
end

function CDU_C_Q()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 54, 1)
end

function CDU_C_R()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 55, 1)
end

function CDU_C_S()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 56, 1)
end

function CDU_C_T()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 57, 1)
end

function CDU_C_U()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 58, 1)
end

function CDU_C_V()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 59, 1)
end

function CDU_C_W()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 60, 1)
end

function CDU_C_X()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 61, 1)
end

function CDU_C_Y()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 62, 1)
end

function CDU_C_Z()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 63, 1)
end

function CDU_C_SP()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 64, 1)
end

function CDU_C_DEL()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 65, 1)
end

function CDU_C_DIAGONAL()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 66, 1)
end

function CDU_C_CLR()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 67, 1)
end





function CDU_C_BRTMIN()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 72, 0)
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 72, 1)
end

function CDU_C_BRTPLUS()
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 72, 2)
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDUCstartVar+ 72, 1)
end



-- ## Center CDU Pages ###############

function CDU_C_Fuel()

    CDU_C_MENU()
    ipc.sleep(20)
    CDU_C_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_C_LSK1L() -- Fuel

    DspShow ("CDUc", "Fuel")
end

function CDU_C_Payload()

    CDU_C_MENU()
    ipc.sleep(20)
    CDU_C_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_C_LSK2L() -- Payload

    DspShow ("CDUc", "Payl")
end

function CDU_C_Doors()

    CDU_C_MENU()
    ipc.sleep(20)
    CDU_C_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_C_LSK3L() -- Doors

    DspShow ("CDUc", "Door")
end

function CDU_C_Pushback()

    CDU_C_MENU()
    ipc.sleep(20)
    CDU_C_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_C_LSK4L() -- Pushback

    DspShow ("CDUc", "Push")
end

function CDU_C_GroundConn()

    CDU_C_MENU()
    ipc.sleep(20)
    CDU_C_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_C_LSK1R() -- GroundConn

    DspShow ("CDUc", "Conn")
end

function CDU_C_GroundOps()

    CDU_C_MENU()
    ipc.sleep(20)
    CDU_C_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_C_LSK2R() -- GroundOps

    DspShow ("CDUc", "Ops")
end

function CDU_C_GroundMaint()

    CDU_C_MENU()
    ipc.sleep(20)
    CDU_C_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_C_LSK3R() -- GroundMaint

    DspShow ("CDUc", "Mtnc")
end

function CDU_C_CabLights()

    CDU_C_MENU()
    ipc.sleep(20)
    CDU_C_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_C_LSK4R() -- CabLights

    DspShow ("CDUc", "Lght")
end

function CDU_C_AutoFlight()

    CDU_C_MENU()
    ipc.sleep(20)
    CDU_C_LSK6R() -- FS Actions
    ipc.sleep(20)
    CDU_C_LSK5R() -- AutoFlight

    DspShow ("CDUc", "Aflt")
end







-- ## Center CDU Ground Connections ###############

function CDU_C_Wheel_Chocks_on ()
    if ipc.readLvar("NGXWheelChocks") == 0 then
    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK1L()
    end

    DspShow ("Chks", "on", "Chocks", "on")
end

function CDU_C_Wheel_Chocks_off ()
    if ipc.readLvar("NGXWheelChocks") == 1 then
    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK1L()
    end

    DspShow ("Chks", "off", "Chocks", "off")
end

function CDU_C_Wheel_Chocks_toggle ()
	if _tl("NGXWheelChocks", 0) then
       CDU_C_Wheel_Chocks_on ()
	else
      CDU_C_Wheel_Chocks_off ()
	end
end



function CDU_C_PowerType_dual ()
    if ipc.readLvar("NGXGPU") == 0 then
    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK2L()
    end
    DspShow ("PwrT", "dual", "PwerType", "dual")
end

function CDU_C_PowerType_single ()
    if ipc.readLvar("NGXGPU") == 1 then
    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK2L()
    end
    DspShow ("PwrT", "sgle", "PwerType", "single")
end

function CDU_C_PowerType_toggle ()
	if _tl("NGXGPU", 0) then
    CDU_C_PowerType_dual ()
	else
    CDU_C_PowerType_single ()
	end
end


function CDU_C_ExtPower_on ()
    if ipc.readLvar("NGXGPU") == 0 and ipc.readLvar("7X7X_terminalpowerconnection") == 0 then

    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK3L()

    DspShow ("GND", "Pwr", "GND PWR", "conn on")
    end
end

function CDU_C_ExtPower_off ()
    if ipc.readLvar("NGXGPU") == 1 or ipc.readLvar("7X7X_terminalpowerconnection") == 1 then

    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK3L()

    DspShow ("GND", "Pwr", "GND PWR", "conn off")
    end
end



function CDU_C_AirStart_on ()
    if ipc.readLvar("NGXAirStartCart") == 0 then
    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK4L()
    end
    DspShow ("AirS", "on", "Airstart", "Unit on")
end

function CDU_C_AirStart_off ()
    if ipc.readLvar("NGXAirStartCart") == 1 then
    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK4L()
    end
    DspShow ("AirS", "off", "Airstart", "Unit off")
end

function CDU_C_AirStart_toggle ()
	if _tl("NGXAirStartCart", 0) then
      CDU_C_AirStart_on ()
	else
      CDU_C_AirStart_off ()
	end
end

function CDU_C_AirCondition_on ()
    if ipc.readLvar("NGXGSU") == 0 then
    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK5L()
    end
    DspShow ("A/C", "on", "AirCond", "on")
end

function CDU_C_AirCondition_off ()
    if ipc.readLvar("NGXGSU") == 1 then
    CDU_C_GroundConn()
    ipc.sleep(20)
    CDU_C_LSK5L()
    end
    DspShow ("A/C", "off", "AirCond", "off")
end

function CDU_C_AirCondition_toggle ()
	if _tl("NGXGSU", 0) then
      CDU_C_AirCondition_on ()
	else
      CDU_C_AirCondition_off ()
	end

end

---











