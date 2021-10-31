-- IVAO IVAP

-- will work ONLY with DEFAULT(!) IVAP shortcuts


function IVAO_ShowHide_toggle ()
	-- CTRL + F9
	ipc.keypress(120,2)
end

function IVAO_TCAS_toggle ()
	-- CTRL + F8
	ipc.keypress(119,2)
end

function IVAO_PushBack_toggle ()
	-- CTRL + F7
	ipc.keypress(118,2)
end

function IVAO_XPDR_toggle ()
	-- CTRL + F11
	ipc.keypress(122,2)
end

function IVAO_Squawk_toggle ()
	-- CTRL + F12
	ipc.keypress(123,2)
end


_log("[LIB]  IVAO library loaded...")
