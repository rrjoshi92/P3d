-- RealityXP 

--[[
13  Enter 
16  Shift (needs shift value 9) 
17  Control (needs shift value 
10) 
18  Menu (needs shift value 72) 
19  Pause 
20  CapsLock 
27  Escape 
32  Space bar 
33  Page Up 
34  Page Down 
35  End 
36  Home 
37  Left arrow 
38  Up arrow 
39  Right arrow 
40  Down arrow 
44  PrintScreen 
45  Insert 
46  Delete 
48  0 on main keyboard 
49  1 on main keyboard 
50  2 on main keyboard 
51  3 on main keyboard 
52  4 on main keyboard 
53  5 on main keyboard 
54  6 on main keyboard 
55  7 on main keyboard 
56  8 on main keyboard 
57  9 on main keyboard 
65  A 
66  B 
67  C 
68  D 
69  E 
70  F 
71  G 
72  H 
73  I 
74  J 
75  K 
76  L 
77  M 
78  N 
79  O 
80  P 
81  Q 
82  R 
83  S 
84  T 
85  U 
86  V 
87  W 
88  X 
89  Y 
90  Z 
96  NumPad 0 (NumLock ON) 
97  NumPad 1 (NumLock ON) 
98  NumPad 2 (NumLock ON) 
99  NumPad 3 (NumLock ON) 
100  NumPad 4 (NumLock ON) 
101  NumPad 5 (NumLock ON) 
102  NumPad 6 (NumLock ON) 
103  NumPad 7 (NumLock ON) 
104  NumPad 8 (NumLock ON) 
105  NumPad 9 (NumLock ON) 
106  NumPad * 
107  NumPad + 
109  NumPad - 
110  NumPad . 
111  NumPad / 
112  F1 
113  F2 
114  F3 
115  F4 
116  F5 
117  F6 
118  F7 
119  F8 
120  F9 
121  F10 
122  F11 
123  F12 
124  F13 
125  F14 
126  F15 
127  F16 
128  F17 
129  F18 
130  F19 
131  F20 
132  F21 
133  F22 
134  F23 
135  NumPad Enter (or F24?) 
144  NumLock 
145  ScrollLock 
186  ; : Key* 
187  = + Key* 
188  , < Key* 
189  - _ Key* 
190  . > Key* 
191  / ? Key* 
192  ' @ Key* 
219  [ { Key* 
220  \ | Key* 
221  ] } Key* 
222  # ~ Key* 
223  ` ¬ ¦ Key* 


### SETTINGS INSIDE RXPGNS.ini ###################

Look here: c:\ProgramData\Reality XP\Common\settings\rxpgns.ini

530_CONTRAST_INC=CTRL+ALT+SHIFT+Q
530_CONTRAST_DEC=CTRL+ALT+SHIFT+A
530_CONTRAST_RESET=CTRL+ALT+SHIFT+Z
530_POW=CTRL+ALT+SHIFT+P
530_COMFLIP=CTRL+ALT+SHIFT+C
530_NAVFLIP=CTRL+ALT+SHIFT+N
530_CDI=CTRL+ALT+SHIFT+F1
530_OBS=CTRL+ALT+SHIFT+F2
530_MSG=CTRL+ALT+SHIFT+F3
530_FPL=CTRL+ALT+SHIFT+F4
530_PROC=CTRL+ALT+SHIFT+F5
530_NAV=CTRL+ALT+SHIFT+F6
530_DTO=CTRL+ALT+SHIFT+F7
530_MNU=CTRL+ALT+SHIFT+F8
530_CLR=CTRL+ALT+SHIFT+F9
530_ENT=CTRL+ALT+SHIFT+F10
530_RANGE_INC=CTRL+ALT+SHIFT+F11
530_RANGE_DEC=CTRL+ALT+SHIFT+F12
530_LKNOBO_L=CTRL+ALT+SHIFT+F13
530_LKNOBO_R=CTRL+ALT+SHIFT+F14
530_LKNOBI_L=CTRL+ALT+SHIFT+F15
530_LKNOBI_R=CTRL+ALT+SHIFT+F16
530_LKNOBPUSH=CTRL+ALT+SHIFT+F17
530_RKNOBO_L=CTRL+ALT+SHIFT+F18
530_RKNOBO_R=CTRL+ALT+SHIFT+F19
530_RKNOBI_L=CTRL+ALT+SHIFT+F20
530_RKNOBI_R=CTRL+ALT+SHIFT+F21
530_RKNOBPUSH=CTRL+ALT+SHIFT+F22
530_EXPORTFPL=CTRL+ALT+SHIFT+F23
530_SWAPRADIOS=CTRL+ALT+SHIFT+S

### SETTINGS INSIDE RXPWX500.ini ###################

WX5_BRT_INC=CTRL+SHIFT+WIN+F13
WX5_BRT_DEC=CTRL+SHIFT+WIN+F14
WX5_GAIN_INC=CTRL+SHIFT+WIN+F15
WX5_GAIN_DEC=CTRL+SHIFT+WIN+F16
WX5_NAV=CTRL+SHIFT+WIN+F17
WX5_SUBMODE_UP=CTRL+SHIFT+WIN+F18
WX5_SUBMODE_DN=CTRL+SHIFT+WIN+F19
WX5_RANGE_UP=CTRL+SHIFT+F13
WX5_RANGE_DN=CTRL+SHIFT+F14
WX5_HOLD=
WX5_TRACK_L=CTRL+SHIFT+F15
WX5_TRACK_R=CTRL+SHIFT+F16
WX5_MAIN_MODE_NEXT=CTRL+SHIFT+F17
WX5_MAIN_MODE_PREV=CTRL+SHIFT+F18
WX5_TILT_INC=CTRL+SHIFT+F19
WX5_TILT_DEC=CTRL+SHIFT+F20
WX5_TILT_ZERO=CTRL+SHIFT+F21
WX5_EASYMODE_TOGGLE=
WX5_VERTSTAB_TOGGLE=
WX5_POPUP_TOGGLE=CTRL+SHIFT+F22
WX5_POPUPALT_TOGGLE=

--]]  
  

-- ## GNS530 Buttons ###################
--[[
-function RXP_test ()

	_log ("RXP test")

	ipc.keypress(69,11)
	
	-- 11 ctrl + shift
	-- 17 alt + shift
	-- 18 alt + ctrl
	-- 19 alt + ctrl + shift

end
--]]
function RXP_530_CONTRAST_INC ()

	ipc.keypress(81,19)
	
	DspShow("R530", "Br+")

end

function RXP_530_CONTRAST_DEC ()

	ipc.keypress(65,19)

	DspShow("R530", "Br-")

end

function RXP_530_CONTRAST_RESET ()

	ipc.keypress(90,19)

	DspShow("R530", "Br 0")

end

function RXP_530_POW ()

	ipc.keypress(80,19)

	DspShow("R530", "Pwr")

end

function RXP_530_COMFLIP ()

	ipc.keypress(67,19)

	DspShow("R530", "ComF")

end

function RXP_530_NAVFLIP ()

	ipc.keypress(78,19)

	DspShow("R530", "NavF")

end

function RXP_530_CDI ()

	ipc.keypress(112,19)

	DspShow("R530", "CDI")

end

function RXP_530_OBS ()

	ipc.keypress(113,19)

	DspShow("R530", "OBS")

end

function RXP_530_MSG ()

	ipc.keypress(114,19)

	DspShow("R530", "MSG")

end

function RXP_530_FPL ()

	ipc.keypress(115,19)

	DspShow("R530", "FPL")

end

function RXP_530_PROC ()

	ipc.keypress(116,19)

	DspShow("R530", "PROC")

end

function RXP_530_NAV ()

	ipc.keypress(117,19)

	DspShow("R530", "VNAV")

end

function RXP_530_DTO ()

	ipc.keypress(118,19)

	DspShow("R530", "DEST")

end

function RXP_530_MNU ()

	ipc.keypress(119,19)

	DspShow("R530", "MENU")

end

function RXP_530_CLR ()

	ipc.keypress(120,19)

	DspShow("R530", "CLR")

end

function RXP_530_ENT ()

	ipc.keypress(121,19)

end

function RXP_530_EXPORTFPL ()

	ipc.keypress(134,19)

	DspShow("R530", "Expt")

end

function RXP_530_SWAPRADIOS ()

	ipc.keypress(83,19)

	DspShow("R530", "SWAP")

end

-- ## GNS530 KNOBS ###############

function RXP_530_RANGE_INC ()

	ipc.keypress(122,19)

	DspShow("R530", "Rng+")

end

function RXP_530_RANGE_DEC ()

	ipc.keypress(123,19)

	DspShow("R530", "Rng-")

end

function RXP_530_LKNOBO_L ()

	ipc.keypress(124,19)

	DspShow("R530", "LO-")

end

function RXP_530_LKNOBO_R ()

	ipc.keypress(125,19)

	DspShow("R530", "LO+")

end

function RXP_530_LKNOBI_L ()

	ipc.keypress(126,19)

	DspShow("R530", "LI-")

end

function RXP_530_LKNOBI_R ()

	ipc.keypress(127,19)

	DspShow("R530", "LI+")

end

function RXP_530_LKNOBPUSH ()

	ipc.keypress(128,19)

	DspShow("R530", "Lprs")

end

function RXP_530_RKNOBO_L ()

	ipc.keypress(129,19)

	DspShow("R530", "RO-")

end

function RXP_530_RKNOBO_R ()

	ipc.keypress(130,19)

	DspShow("R530", "RO+")

end

function RXP_530_RKNOBI_L ()

	ipc.keypress(131,19)

	DspShow("R530", "RI-")

end

function RXP_530_RKNOBI_R ()

	ipc.keypress(132,19)

	DspShow("R530", "RI+")

end

function RXP_530_RKNOBPUSH ()

	ipc.keypress(133,19)

	DspShow("R530", "Rprs")

end



-- ## WX500 ###################

function RXP_WX500_BRT_INC ()

	ipc.keypress(124,43)
	
	DspShow("WXR", "Brt+")

end

function RXP_WX500_BRT_DEC ()

	ipc.keypress(125,43)
	
	DspShow("WXR", "Brt-")

end

function RXP_WX500_GAIN_INC ()

	ipc.keypress(126,43)
	
	DspShow("WXR", "Gai+")

end

function RXP_WX500_GAIN_DEC ()

	ipc.keypress(127,43)
	
	DspShow("WXR", "Gai-")

end

function RXP_WX500_NAV ()

	ipc.keypress(128,43)
	
	DspShow("WXR", "NAV")

end


function RXP_WX500_SUBMODE_UP ()

	ipc.keypress(129,43)
	
	DspShow("WXR", "SUB+")

end

function RXP_WX500_SUBMODE_DN ()

	ipc.keypress(130,43)
	
	DspShow("WXR", "SUB-")

end


function RXP_WX500_RANGE_UP ()

	ipc.keypress(124,11)
	
	DspShow("WXR", "Rng+")

end

function RXP_WX500_RANGE_DN ()

	ipc.keypress(125,11)
	
	DspShow("WXR", "Rng-")

end

function RXP_WX500_TRACK_L ()

	ipc.keypress(126,11)
	
	DspShow("WXR", "TR L")

end

function RXP_WX500_TRACK_R ()

	ipc.keypress(127,11)
	
	DspShow("WXR", "TR R")

end


function RXP_WX500_MAIN_MODE_NEXT ()

	ipc.keypress(128,11)
	
	DspShow("WXR", "MOD+")

end

function RXP_WX500_MAIN_MODE_PREV ()

	ipc.keypress(129,11)
	
	DspShow("WXR", "MOD-")

end


function RXP_WX500_TILT_INC ()

	ipc.keypress(130,11)
	
	DspShow("WXR", "Til+")

end

function RXP_WX500_TILT_DEC ()

	ipc.keypress(131,11)
	
	DspShow("WXR", "Til-")

end


function RXP_WX500_TILT_ZERO ()

	ipc.keypress(132,11)
	
	DspShow("WXR", "Til0")

end

function RXP_WX500_POPUP_TOGGLE ()

	ipc.control(66506, 15500)
--	ipc.keypress(133,11)
	
	DspShow("WXR", "    ")

end



_log("[LIB]  RealityXP library loaded...")


