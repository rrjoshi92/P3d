-- FS2Crew Library
-- Added with LINDA 2.5
-- Dec 2014

-- This Library provides functions to control FS2Crew.

-- NOTE: The call to Soft Mute must be assigned to OnPress and OnRepeat
--       when used with a button eg. press-to-touch.

-- ## Common functions ############################################

-- opens main panel - Aerosoft Airbus
function FS2Crew_MainPanel ()
    ipc.control(66297, 0)
end

-- ## Voice Control ##############################################

-- toggles Hard Mute
function FS2Crew_HardMute ()
    ipc.control(66317, 0)
end

-- activates Soft Mute (see note)
function FS2Crew_SoftMute ()
    ipc.control(66287, 0)
end

-- ## Button Control ##############################################

-- main button
function FS2Crew_MainButton ()
    ipc.control(66317,0)
end

-- secondary button
function FS2Crew_SecButton ()
    ipc.control(66287,0)
end


_log("[LIB]  FS2Crew library loaded...")
