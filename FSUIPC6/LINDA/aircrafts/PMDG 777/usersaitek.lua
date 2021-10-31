-- Dummy user functions file
-- ===========================

-- This file is loaded right after main actions.lua script loaded.
-- You can use this file to:
-- 1. Override any functions or settings in main script
-- 2. Execute any desired startup sequence for this aircraft (i.e. your own c&d state macro)
-- 3. ... use your imagination

-- This file will not be replaced on the aircraft module update, so all of your modifications
-- will remain active. Best practice from this moment is DO NOT MAKE ANY CHANGES in original
-- actions.lua file. Make all the modifications HERE.

-- insert your code below here:

ALT_prev = 0
HDG_prev = 0
SPD_prev = 0
VVS_prev = 0

-- ## System Functions
function AircraftTimer10Hz()
    PMDG_AP_ALT_show()
    PMDG_AP_VS_show()
    PMDG_AP_SPD_show()
    PMDG_AP_HDG_show()
    PMDG_AP_AP_btn()
    PMDG_AP_HDG_btn()
    PMDG_AP_NAV_btn()
    PMDG_AP_IAS_btn()
    PMDG_AP_ALT_btn()
    PMDG_AP_VS_btn()
    PMDG_AP_APR_btn()
    PMDG_AP_REV_btn()
end

-- ## Multi Panel Functions
function SAI_MULTI_inc (mode)
    if isAvionicsOn () then
        if mode == nil or mode < 0 or mode > 4 then return end

        if (mode == 0) then  -- ALT
            PMDG_AP_ALT_inc()
        elseif (mode == 1) then -- VS
            PMDG_AP_VS_inc()
        elseif (mode == 2) then -- SPD
            PMDG_AP_SPD_inc()
        elseif (mode == 3) then -- HDG
            PMDG_AP_HDG_inc()
        end
    end
end

function SAI_MULTI_dec (mode)
    if isAvionicsOn () then
        if mode == nil or mode < 0 or mode > 4 then return end

        if (mode == 0) then  -- ALT
            PMDG_AP_ALT_dec()
        elseif (mode == 1) then -- VS
            PMDG_AP_VS_dec()
        elseif (mode == 2) then -- SPD
            PMDG_AP_SPD_dec()
        elseif (mode == 3) then -- HDG
            PMDG_AP_HDG_dec()
        end
    end
end

-- ## Radio Panel Functions

function SAI_RADIO1_toggle ()
end

function SAI_RADIO2_toggle ()
end

function SAI_RADIO_MHz_inc (mode)
	if isAvionicsOn () then
    	if mode == nil or mode < 0 or mode > 6 then return end
        if mode ~= 5 and mode ~= 6 then

        elseif mode == 6 then
            EFIS_CPT_BARO_inc()
        end
	end
end

function SAI_RADIO_MHz_dec (mode)
	if isAvionicsOn () then
    	if mode == nil or mode < 0 or mode > 6 then return end
        if mode ~= 5 and mode ~= 6 then

        elseif mode == 6 then
            EFIS_CPT_BARO_dec()
        end
	end
end

function SAI_RADIO_kHz_inc (mode)
end

function SAI_RADIO_kHz_dec (mode)
end

-- ## PMDG Autopilot Show/Sync functions

function PMDG_AP_ALT_show ()            --Display ALT--
    local alt
    local ngx_alt = ipc.readLvar("L:ngx_ALTwindow")
    if ALT_prev ~= ngx_alt then
        if ngx_alt == nil then ngx_alt = 0 end
        alt = math.floor((ngx_alt/3.2808399)*65536 + 0.5)
        ipc.writeUD(0x07D4, alt)
        ipc.sleep(50)
        _loggg('[P777] ALT = ' .. ngx_alt .. '=' .. alt)
        DspALT(round(ngx_alt/100))
        ALT_prev = ngx_alt
    end
end

function PMDG_AP_VS_show ()                --Display VS--
    local ngx_vvs = ipc.readLvar("L:ngx_VSwindow")
    if VVS_prev ~= ngx_vvs then
        if ngx_vvs == nil then ngx_vvs = 0 end
        ipc.writeSW(0x07F2, ngx_vvs)
        ipc.sleep(50)
        DspVVS(ngx_vvs)
        VVS_prev = ngx_vvs
    end
end
function PMDG_AP_SPD_show ()            --Display IAS--
    local ngx_spd = ipc.readLvar("L:ngx_SPDwindow")
    if SPD_prev ~= ngx_spd then
        if ngx_spd == nil or ngx_spd < 0 then ngx_spd = 0 end
        ipc.writeUW(0x07E2, ngx_spd)
        ipc.sleep(50)
        DspSPD(ngx_spd)
        SPD_prev = ngx_spd
    end
end
function PMDG_AP_HDG_show ()            --Display HDG--
    local ngx_hdg = ipc.readLvar("L:ngx_HDGwindow")
    local hdg
    if HDG_prev ~= ngx_hdg then
        if ngx_hdg == nil then ngx_hdg = 0 end
        hdg = round(ngx_hdg / 360 * 65536)
        _loggg('[P777] HDG = ' .. ngx_hdg .. '=' .. hdg)
        ipc.writeUW(0x07CC, hdg)
        ipc.sleep(50)
        DspHDG(ngx_hdg)
        HDG_prev = ngx_hdg
    end
end

function PMDG_AP_AP_btn ()
    if ipc.readLvar("L:ngx_MCP_CMDA") == 1 then
        ipc.writeUW(0x07BC, 1)
    else
        ipc.writeUW(0x07BC, 0)
    end
    ipc.sleep(50)
end
function PMDG_AP_HDG_btn ()
    if ipc.readLvar("L:ngx_MCP_HdgSel") == 1 then
        ipc.writeUW(0x07C8, 1)
    else
        ipc.writeUW(0x07C8, 0)
    end
    ipc.sleep(50)
end
function PMDG_AP_NAV_btn ()
    if ipc.readLvar("L:ngx_MCP_LNav") == 1 then
        ipc.writeUW(0x07C8, 1)
    else
        ipc.writeUW(0x07C8, 0)
    end
    ipc.sleep(50)
end
function PMDG_AP_IAS_btn ()
    if ipc.readLvar("L:ngx_MCP_Speed") == 1 then
        ipc.writeUW(0x07DC, 1)
    else
        ipc.writeUW(0x07DC, 0)
    end
    ipc.sleep(50)
end
function PMDG_AP_ALT_btn ()
    if ipc.readLvar("L:ngx_MCP_LvlChg") == 1 then
        ipc.writeUW(0x07D0, 1)
    else
        ipc.writeUW(0x07D0, 0)
    end
    ipc.sleep(50)
end
function PMDG_AP_VS_btn ()
    if ipc.readLvar("L:ngx_MCP_VS") == 1 then
        ipc.writeUW(0x07EC, 1)
    else
        ipc.writeUW(0x07EC, 0)
    end
    ipc.sleep(50)
end
function PMDG_AP_APR_btn ()
    if ipc.readLvar("L:ngx_MCP_App") == 1 then
        ipc.writeUW(0x0800, 1)
    else
        ipc.writeUW(0x0800, 0)
    end
    ipc.sleep(50)
end
function PMDG_AP_REV_btn ()
    if ipc.readLvar("L:ngx_MCP_VORLock") == 1 then
        ipc.writeUW(0x07C4, 1)
    else
        ipc.writeUW(0x07C4, 0)
    end
    ipc.sleep(50)
end

-- Just a message in console
_log("[USER] User's modifications script is loaded...")
