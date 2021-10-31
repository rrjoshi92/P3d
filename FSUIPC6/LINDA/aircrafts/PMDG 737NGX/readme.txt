------------------------------------------------------------------------
 LINDA Module
------------------------------------------------------------------------
 Aircraft: PMDG 737 NGX
  Version: 4.15
     Date: Feb 2020
   Author: Artem/Guenter/Michel/Andrew
------------------------------------------------------------------------

See PMDG 737NGX-Functions.txt for details of available functions
NOTE - Some functions names may have changed for consistency

4.14 --> 4.15
Changed ident.lua to allow module to coexist with PMDG 737NGUu

4.12 --> 4.13
Changed ident.lua for allow module to coexist with PMDG 737NGXu

4.11 --> 4.12
changed GSX door automation. You have to use GSX Lib now!
fixed typo and added seat/signs toggle, thanks RAZERZ

4.10 --> 4.11
added direct functions for EFIS ND mode and range

4.9 --> 4.10
fixed Ground Power on/off switch selection

4.8 --> 4.9
fixed Weather Radar panel button controls
fixed MCP display for WX RDR gain and tilt decrement (4.9b)

4.7 --> 4.8
some fixes
reworked Ground connections (on/off/toggle) (users have to assign them new)

added GSX Door function
you can disable the GSX door function by uncommenting the function GSX_Door_Service () inside the timer function

4.6 --> 4.7
fixed issue with CVR and Cabin Seat Lights

4.5 --> 4.6
fixed display of Flap and Gear position on ground
added Cockpit Voice Recorder button functions (NGX_CVR_test and NGX_CVR_erase) 

4.4 --> 4.5
fixed incorrect rotation of EFIS ND Mode knob

4.3 --> 4.4
fixed FO's CRS knob functions
fixed issue with responsiveness of SPD, HDG, ALT and V/S knob functions
fixed Speed Reference display error (NGX_SPDREF_MODE_show)
fixed Speed Reference cycle display (NGX_SPDREF_MODE_cycle)
added Speed Reference value display (no MCP panels)
fixed NGX_LIGHTS_toggle function 'nil' error

4.2 --> 4.3
added MFD Selector buttons (NGX_MFD_SELECTOR_sys, eng & c/r)
added Speed Reference selector and knob
	(see NGX_SPDREF_show, _calc, _inc, _dec, _cycle, _set, _auto,
	_v1, _vr, _wt, _vref & _arrow and NGX_SPDREF_inc & _dec)
added N1 Set selector and knob
	(see NGX_N1SET_MODE_show, _calc, _inc, _dec, _cycle, _2, _1,
	auto & _both, and NGX_N1SET_inc & _dec)
added Fuel Flow Rate switch (NGX_FUELFLOW_reset & _used)
updated Lights switch (NGX_LIGHTS_dim, _bright, _test, _TEST_toggle,
	_cycle & _toggle)
added AP/AT Disengage switch (NGX_AP_TEST_DISENGAGE_1, _ 2 & _off)
added Inertial Reference System (IRS) knob position functions
	(see NGX_IRS_both_off, _align, _nav & _att)
shortened Air Temperature Source function names
	(see NGX_AIRTEMP_show, _inc, _dec, _cycle, _SCnt, _SFwd,
	_SAft, _CFwd, _CAft, _PckL & _PckR)
added Trim Air toggle function (NGX_TRIMAIR_toggle)
added All Warnings Cancellation

4.1 --> 4.2
fixed Capt's EFIS MINS and BARO modes

3.4 --> 4.1
updated for LINDA 2.7
updated code for many functions and reformatted for readability
split NGX_APU_Start_or_ShowEGT into 2 separate functions
	NGX_APU_ShowEGT and NGX_APU_Start
improved FLight Altitude & Landing Altitude synchronization
added Flight Altitude functions (NGX_FLTINC_incfast & _decfast)
added Landing Altitude functions (NGX_LandALT_incfast & _decfast)
added new Air Temperature Control Overhead Panel functions
	(see NGX_AIRTEMP_SOURCE_show, _inc, _dec, _cycle, _SCnt, _SFwd,
	_SAft, _CFwd, _CAft, _PckL & _PckR)
added Engine Start Knob functions (NGX_ENGx_START_inc, _dec & _cycle)
added new Bus Transfer functions (NGX_BYS_TRANS_off, _on & _Auto)
fixed Door opening functions
fixed button animation

3.3 --> 3.4
added Panel DUs Display states single selection
added AC / DC Display states single selection
changed/improved Doors
added GSX Fuel Service opens FMC

3.2 --> 3.3
added Whiskey Compass light
added LIGHT_PANEL_ALL
added WXR
APU ready announcement in MCP Display

3.1 -> 3.2
Added extra DSPshow lines

3.0 —> 3.1
Fixes for DME/CRS

2.1 --> 3.0
Updated for LINDA 2.5

2.0 --> 2.1
Updated for LINDA 2.1
Added XPDR modes

2.0 added "fixed" values for internal lights
added FO EFIS and toggler to switch between Capt and FO EFIS

1.8 --> 1.9
added ALT Horn cutout
added rotaries for DC and AC display

1.7 --> 1.8
ground connections functions
Added cabin cooling currently only with trim air

1.6 --> 1.7
CDU commands
door commands

1.5 --> 1.6

Wipers
Autobrake modified

1.4 --> 1.5

Yaw Damper spelling corrected
NGX_SPOILER_detent spelling corrected

NGX_SIGNS_SEAT_on
NGX_SIGNS_SEAT_auto
NGX_SIGNS_SEAT_off

NGX_SIGNS_CHIME_on
NGX_SIGNS_CHIME_toggle
NGX_SIGNS_CHIME_off

IRS

NGX_GRD_PWR_on ()
NGX_GRD_PWR_off ()

NGX_IGN_left ()
NGX_IGN_both ()
NGX_IGN_right ()

ANTI-ICE

-------------------

changed for 1.4:

--Removed:
HGS_toggle_swCam2 ()

--Newly added (in alphabetic sequence):

APU_off ()
APU_on ()

EMER_lights_armed ()
EMER_lights_off ()
EMER_lights_on ()

ENG1_START_CONT ()

ENG1_START_FLT ()
ENG1_START_FLT ()
ENG1_START_GRD ()

ENG1_START_OFF ()

ENG2_START_CONT ()

ENG2_START_GRD ()

ENG2_START_OFF ()

FLTALT_dec ()
FLTALT_inc ()

HGS_down ()
HGS_up ()

HYD_A_Elec2_off ()
HYD_A_Elec2_on ()
HYD_A_Elec2_toggle ()
HYD_A_Eng1_off ()
HYD_A_Eng1_on ()
HYD_A_Eng1_toggle ()
HYD_B_Elec1_off ()
HYD_B_Elec1_on ()
HYD_B_Elec1_toggle ()
HYD_B_Eng2_off ()
HYD_B_Eng2_on ()
HYD_B_Eng2_toggle ()
HYD_ELEC_Both_off ()
HYD_ELEC_Both_on ()
HYD_ELEC_Both_toggle ()
HYD_ENG_Both_off ()
HYD_ENG_Both_on ()
HYD_ENG_Both_toggle ()

LandALT_dec ()
LandALT_inc ()

PROBE_HEAT_BOTH_off ()
PROBE_HEAT_BOTH_on ()
PROBE_HEAT_BOTH_toggle ()
PROBE_HEAT_L_off ()
PROBE_HEAT_L_on ()
PROBE_HEAT_L_toggle ()
PROBE_HEAT_R_off ()
PROBE_HEAT_R_on ()
PROBE_HEAT_R_toggle ()

RecircANDIsol_auto ()
RecircANDIsol_off ()

W_HEAT_ALL_LEFT_off ()
W_HEAT_ALL_LEFT_on ()
W_HEAT_ALL_LEFT_toggle ()
W_HEAT_ALL_off ()
W_HEAT_ALL_on ()
W_HEAT_ALL_RIGHT_off ()
W_HEAT_ALL_RIGHT_on ()
W_HEAT_ALL_RIGHT_toggle ()
W_HEAT_ALL_toggle ()
W_HEAT_L_FWD_off ()
W_HEAT_L_FWD_on ()
W_HEAT_L_FWD_toggle ()
W_HEAT_L_SIDE_off ()
W_HEAT_L_SIDE_on ()
W_HEAT_L_SIDE_toggle ()
W_HEAT_R_FWD_off ()
W_HEAT_R_FWD_on ()
W_HEAT_R_FWD_toggle ()
W_HEAT_R_SIDE_off ()
W_HEAT_R_SIDE_on ()
W_HEAT_R_SIDE_toggle ()
W_HEAT_TEST_off ()
W_HEAT_TEST_ovht ()
W_HEAT_TEST_pwr ()

YAW_DUMPER_off ()
YAW_DUMPER_on ()
YAW_DUMPER_toggle ()
