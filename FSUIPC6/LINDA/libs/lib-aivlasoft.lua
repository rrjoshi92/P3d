-- AivlaSoft EFB

-- will work ONLY with DEFAULT(!) EFB shortcuts


function EFB_ON_SCREEN_MENU_show ()

	-- CTRL + SHIFT + F9
	ipc.keypressplus(120,11,4)
    DspShow ("Scrn", "menu", "EFB Scrn", "Menu on")

end

function EFB_ON_SCREEN_MENU_hide ()

	-- CTRL + SHIFT + F10
	ipc.keypressplus(121,11,4)
    DspShow ("Scrn", "menu", "EFB Scrn", "Menu off")
end


function EFB_DISPLAY_UNIT_tofront ()

	-- CTRL + SHIFT + F11
	ipc.keypressplus(122,11,4)
    DspShow ("DU", "frnt", "EFB DU", "to front")
end

function EFB_DISPLAY_UNIT_toback ()

	-- CTRL + SHIFT + F12
	ipc.keypressplus(123,11,4)
    DspShow ("DU", "back", "EFB DU", "to back")
end

function EFB_DISPLAY_UNIT_toggle ()

	if _t("EFBOSD") then
	
		EFB_DISPLAY_UNIT_tofront ()

	else
	
		EFB_DISPLAY_UNIT_toback ()
	
	end

end

function EFB_MOVING_MAP_toggle ()

	-- CTRL + SHIFT + M
	ipc.keypressplus(77,11,4)
    DspShow ("Map", "togg", "Mov Map", "toggle")
end

function EFB_COLOR_MODE_toggle ()

	-- CTRL + SHIFT + C
	ipc.keypressplus(67,11,4)
    DspShow ("Clr", "Mode", "Color", "Mode tgl")
end

function EFB_ZOOM_in ()

	-- CTRL + SHIFT + I
	ipc.keypressplus(73,11,4)
    DspShow ("Zoom", "in")
end

function EFB_ZOOM_out ()

	-- CTRL + SHIFT + O
	ipc.keypressplus(79,11,4)
    DspShow ("Zoom", "out")
end

function EFB_VIEW_left ()

	-- CTRL + SHIFT + L
	ipc.keypressplus(76,11,4)
    DspShow ("View", "L")
end

function EFB_VIEW_right ()

	-- CTRL + SHIFT + R
	ipc.keypressplus(82,11,4)
    DspShow ("View", "R")
end

function EFB_VIEW_up ()

	-- CTRL + SHIFT + U
	ipc.keypressplus(85,11,4)
    DspShow ("View", "U")
end

function EFB_VIEW_down ()

	-- CTRL + SHIFT + D
	ipc.keypressplus(68,11,4)
    DspShow ("View", "D")
end

function EFB_FREQ_GROUP_1 ()

	-- CTRL + SHIFT + NUM 1
	ipc.keypressplus(97,11,4)
    DspShow ("Freq", "1", "Freq", "Group 1")
end

function EFB_FREQ_GROUP_2 ()

	-- CTRL + SHIFT + NUM 2
	ipc.keypressplus(98,11,4)
    DspShow ("Freq", "2", "Freq", "Group 2")
end

function EFB_FREQ_GROUP_3 ()

	-- CTRL + SHIFT + NUM 3
	ipc.keypressplus(99,11,4)
    DspShow ("Freq", "3", "Freq", "Group 3")
end

function EFB_FREQ_GROUP_4 ()

	-- CTRL + SHIFT + NUM 4
	ipc.keypressplus(100,11,4)
    DspShow ("Freq", "4", "Freq", "Group 4")
end

function EFB_FREQ_GROUP_5 ()

	-- CTRL + SHIFT + NUM 5
	ipc.keypressplus(101,11,4)
    DspShow ("Freq", "5", "Freq", "Group 5")
end

_log("[LIB]  AivlaSoft library loaded...")
