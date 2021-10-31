-- LINDA GSX Library  1.3 

-- ## sys functions - do not assign###############
-- ##  ###############
-- currently supported planes:
-- PMDG 747, 777, NGX
-- Majestic Dash 8
-- Leonardo Maddog X

-----------------------------------------------------------------------
function GSX_door_automation ()
    if ipc.readLvar("FSDT_VAR_EnginesStopped") == 1 then
        GSX_door_automation_run ()
    end
end



function GSX_door_automation_run ()

    GSX_GetGSXVariables ()
    GSX_SetAcftVariables ()
    -- GSX_Test_Display ()   -- just for testing
    GSX_Ready_Display ()

    -- $$ Pax loading ---------------------------------------------------------

    if GSXPaxVar == 5 or GSXPaxDebVar == 4 then
        if GSXPax1 ~= nil then
            if GSXPax1 > 0 then Pax1OpenAction () end
        end
        if GSXPax2 ~= nil then
            if GSXPax2 > 0 then Pax2OpenAction () end
        end
        if GSXPax3 ~= nil then
            if GSXPax3 > 0 then Pax3OpenAction () end
        end
        if GSXPax4 ~= nil then
            if GSXPax4 > 0 then Pax4OpenAction () end
        end
        if GSXPax5 ~= nil then
            if GSXPax5 > 0 then Pax5OpenAction () end
        end
    end

    if GSXPaxVar == 6 then
        Pax1CloseAction ()
        _sleep(500, 1500)
        Pax2CloseAction ()
        _sleep(500, 1500)
        Pax3CloseAction ()
        _sleep(500, 1500)
        Pax4CloseAction ()
        _sleep(500, 1500)
        Pax5CloseAction ()
    end


    -- reset wrong exit state variables to zero
    if GSXPaxVar == 1 or GSXPaxVar == 6 then
            ipc.writeLvar("FSDT_GSX_AIRCRAFT_EXIT_1_TOGGLE", 0)
            ipc.writeLvar("FSDT_GSX_AIRCRAFT_EXIT_2_TOGGLE", 0)
            ipc.writeLvar("FSDT_GSX_AIRCRAFT_EXIT_3_TOGGLE", 0)
            ipc.writeLvar("FSDT_GSX_AIRCRAFT_EXIT_4_TOGGLE", 0)
            ipc.writeLvar("FSDT_GSX_AIRCRAFT_EXIT_5_TOGGLE", 0)
            ipc.writeLvar("FSDT_GSX_AIRCRAFT_CARGO_1_TOGGLE", 0)
	        ipc.writeLvar("FSDT_GSX_AIRCRAFT_CARGO_2_TOGGLE", 0)
	        ipc.writeLvar("FSDT_GSX_AIRCRAFT_CARGO_3_TOGGLE", 0)
            ipc.writeLvar("FSDT_GSX_BOARDING_CARGO_PERCENT", 0)

    end


    -- $$ Catering ---------------------------------------------------------

    if GSXCatStat == 5 then

        if GSXTimeDiff == nil then GSXTimeDiff = 0 end

         if GSXCat1 ~= nil then
            if GSXCat1 > 0 and GSXTimeDiff < 10 then Service1OpenAction () end
         end
         if GSXCat2 ~= nil then
            if GSXCat2 > 0 and GSXTimeDiff < 10 then Service2OpenAction () end
         end

        GSXTime2 = math.floor(ipc.readDBL("04A8"))
        GSXTimeDiff = GSXTime2 - GSXTime

        if GSXCat1 ~= nil then
            if GSXCat1 > 0 then
                if GSXTimeDiff >= 25 then
                Service1CloseAction ()
                end
            end
         end

         if GSXCat2 ~= nil then
            if GSXCat2 > 0 then
                if GSXTimeDiff >= 25 then
                Service2CloseAction ()
                end
            end
         end
    end

     -- reset wrong exit state variables to zero
    if GSXCatStat == 1 or GSXCatStat == 6 then
            ipc.writeLvar("FSDT_GSX_AIRCRAFT_SERVICE_1_TOGGLE", 0)
            ipc.writeLvar("FSDT_GSX_AIRCRAFT_SERVICE_2_TOGGLE", 0)
            GSXTime = math.floor(ipc.readDBL("04A8"))
            GSXTime2 = math.floor(ipc.readDBL("04A8"))
            GSXTimeDiff = GSXTime2 - GSXTime
    end

    -- $$ Cargo ---------------------------------------------------------
    if GSXCargo1 ~= nil then
        if GSXCargo1 > 0 then Cargo1OpenAction () end
    end
    if GSXCargo2 ~= nil then
        if GSXCargo2 > 0 then Cargo2OpenAction () end
    end
    if GSXCargo3 ~= nil then
        if GSXCargo3 > 0 then Cargo3OpenAction () end
    end

    if GSXCargoPct == 100 and GSXPaxVar == 6 then
        Cargo1CloseAction ()
        _sleep(500, 1500)
        Cargo2CloseAction ()
        _sleep(500, 1500)
        Cargo3CloseAction ()

    end

end

function GSX_GetGSXVariables ()

    -- Pax --------------------------------------------------------------------
	GSXPaxVar = ipc.readLvar("FSDT_GSX_BOARDING_STATE")
    GSXPaxDebVar = ipc.readLvar("FSDT_GSX_DEBOARDING_STATE")


    GSXPax1 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_1_TOGGLE")
    GSXPax2 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_2_TOGGLE")
    GSXPax3 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_3_TOGGLE")
    GSXPax4 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_4_TOGGLE")
    GSXPax5 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_5_TOGGLE")

	-- Cargo --------------------------------------------------------------------
	GSXCargoStat = ipc.readLvar("FSDT_GSX_BOARDING_CARGO")
	GSXCargoPct = ipc.readLvar("FSDT_GSX_BOARDING_CARGO_PERCENT")
	GSXCargo1 = ipc.readLvar("FSDT_GSX_AIRCRAFT_CARGO_1_TOGGLE")
	GSXCargo2 = ipc.readLvar("FSDT_GSX_AIRCRAFT_CARGO_2_TOGGLE")
	GSXCargo3 = ipc.readLvar("FSDT_GSX_AIRCRAFT_CARGO_3_TOGGLE")

	-- Catering --------------------------------------------------------------------
    GSXCatStat = ipc.readLvar("FSDT_GSX_CATERING_STATE")
    GSXCat1 = ipc.readLvar("FSDT_GSX_AIRCRAFT_SERVICE_1_TOGGLE")
    GSXCat2 = ipc.readLvar("FSDT_GSX_AIRCRAFT_SERVICE_2_TOGGLE")



end

function GSX_SetAcftVariables ()

    acftname = ipc.readSTR("3D00", 35)


        if string.find(acftname,"PMDG 737",0,true) or string.find(acftname,"Boeing 737",0,true) then
         GSX_PMDG_737 ()
         AddonName ="PMDG 737"
        elseif string.find(acftname,"MJC8Q",0,true) then
         GSX_MJC8Q ()
         AddonName ="MJC8Q"
        elseif string.find(acftname,"PMDG 747",0,true) then
         GSX_PMDG_747 ()
         AddonName ="PMDG 747"
         elseif string.find(acftname,"PMDG 777",0,true) then
         GSX_PMDG_777 ()
         AddonName ="PMDG 777"
         elseif string.find(acftname,"Maddog",0,true) then
         GSX_Maddog ()
         AddonName ="Maddog"
         else AddonName = "unknown / Error"

        end

end



function GSX_Test_Display ()
    acftname = ipc.readSTR("3D00", 35)
    if string.find(acftname,AddonName,0,true) then AddonNameTxt = AddonName
    else AddonNameTxt = "nil"
    end

	-- Pax --------------------------------------------------------------------
    GSXPaxVar = ipc.readLvar("FSDT_GSX_BOARDING_STATE")
    GSXPaxDebVar = ipc.readLvar("FSDT_GSX_DEBOARDING_STATE")


    GSXPax1 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_1_TOGGLE")
    GSXPax2 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_2_TOGGLE")
    GSXPax3 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_3_TOGGLE")
    GSXPax4 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_4_TOGGLE")
    GSXPax5 = ipc.readLvar("FSDT_GSX_AIRCRAFT_EXIT_5_TOGGLE")


	if GSXPaxVar == nil then GSXPaxVarTxt = "nil" else GSXPaxVarTxt = GSXPaxVar end
    if GSXPaxDebVar == nil then GSXPaxDebVarTxt = "nil" else GSXPaxDebVarTxt = GSXPaxDebVar end

	if GSXPax5 == nil then GSXPax5Txt = "nil" else GSXPax5Txt = GSXPax5 end
    if GSXPax4 == nil then GSXPax4Txt = "nil" else GSXPax4Txt = GSXPax4 end
    if GSXPax3 == nil then GSXPax3Txt = "nil" else GSXPax3Txt = GSXPax3 end
    if GSXPax2 == nil then GSXPax2Txt = "nil" else GSXPax2Txt = GSXPax2 end
    if GSXPax1 == nil then GSXPax1Txt = "nil" else GSXPax1Txt = GSXPax1 end


	-- Cargo --------------------------------------------------------------------
	GSXCargoStat = ipc.readLvar("FSDT_GSX_BOARDING_CARGO")
	GSXCargoPct = ipc.readLvar("FSDT_GSX_BOARDING_CARGO_PERCENT")
	GSXCargo1 = ipc.readLvar("FSDT_GSX_AIRCRAFT_CARGO_1_TOGGLE")
	GSXCargo2 = ipc.readLvar("FSDT_GSX_AIRCRAFT_CARGO_2_TOGGLE")
	GSXCargo3 = ipc.readLvar("FSDT_GSX_AIRCRAFT_CARGO_3_TOGGLE")

	if GSXCargoStat == nil then GSXCargoStatTxt = "nil" else GSXCargoStatTxt = GSXCargoStat end
	if GSXCargoPct == nil then GSXCargoPctTxt = "nil" else GSXCargoPctTxt = GSXCargoPct end

	if GSXCargo1 == nil then GSXCargo1Txt = "nil" else GSXCargo1Txt = GSXCargo1 end
    if GSXCargo2 == nil then GSXCargo2Txt = "nil" else GSXCargo2Txt = GSXCargo2 end
    if GSXCargo3 == nil then GSXCargo3Txt = "nil" else GSXCargo3Txt = GSXCargo3 end


	-- Catering --------------------------------------------------------------------
    GSXCatStat = ipc.readLvar("FSDT_GSX_CATERING_STATE")
    GSXCat1 = ipc.readLvar("FSDT_GSX_AIRCRAFT_SERVICE_1_TOGGLE")
    GSXCat2 = ipc.readLvar("FSDT_GSX_AIRCRAFT_SERVICE_2_TOGGLE")

	if GSXCatStat == nil then GSXCatStatTxt = "nil" else GSXCatStatTxt = GSXCatStat end

	if GSXCat1 == nil then GSXCat1Txt = "nil" else GSXCat1Txt = GSXCat1 end
	if GSXCat2 == nil then GSXCat2Txt = "nil" else GSXCat2Txt = GSXCat2 end

    if GSXTime == nil then GSXTimeTxt = "nil" else GSXTimeTxt = GSXTime end
    if GSXTime2 == nil then GSXTime2Txt = "nil" else GSXTime2Txt = GSXTime2 end
    if GSXTimeDiff == nil then GSXTimeDiffTxt = "nil" else GSXTimeDiffTxt = GSXTimeDiff end

    ipc.display("Zeit:   " .. GSXTimeTxt .. "\n" ..
                "Zeit2:   " .. GSXTime2Txt .. " Diff= " .. GSXTimeDiffTxt .. "\n\n" ..

                "Boarding:   " .. GSXPaxVarTxt .. "\n" ..
                "Door 1:      " .. GSXPax1Txt .. "\n"..
                "Door 2:      " .. GSXPax2Txt .. "\n"..
                "Door 3:      " .. GSXPax3Txt .. "\n"..
                "Door 4:      " .. GSXPax4Txt .. "\n"..
                "Door 5:      " .. GSXPax5Txt .. "\n\n" ..

                "Catering:     " .. GSXCatStatTxt .. "\n"..
                "ServDoor1:   " .. GSXCat1Txt .. "\n"..
                "ServDoor2:   " .. GSXCat2Txt .. "\n\n"..

                "CargoStat:    " .. GSXCargoStatTxt .. "\n"..
                "Cargo %:      " .. GSXCargoPctTxt .. "\n"..
				"CrgoDoor1:   " .. GSXCargo1Txt .. "\n"..
                "CrgoDoor2:   " .. GSXCargo2Txt .. "\n"..
                "CrgoDoor3:   " .. GSXCargo3Txt .. "\n\n" ..

                "Deboarding:   " .. GSXPaxDebVarTxt .. "\n\n" ..

                "ShortName:   " .. AddonNameTxt .. "\n" ..
                acftname )

end



function GSX_Ready_Display ()


    if ipc.get("GSXReady") == nil then ipc.set("GSXReady", 0) end

    if ipc.get("GSXReady") == 0 then
        acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,AddonName,0,true) then AddonNameTxt = AddonName
        else AddonNameTxt = "nil"
        end

        ipc.display("GSX door automation enabled \n\n" ..
                    "ShortName:   " .. AddonNameTxt .. "\n" ..
                    acftname )

        ipc.sleep(2000)
        ipc.set("GSXReady", 1)
    elseif ipc.get("GSXReady") == 1 then
        ipc.display("")
        ipc.set("GSXReady", 2)

    elseif ipc.get("GSXReady") == 2 then
    end

end



-- ## PMDG 737 ###############

function GSX_PMDG_737 ()
AddonName = "PMDG 737"

---------------------------------------------------------------------------------
-- $$ NGX PAX Doors
---------------------------------------------------------------------------------
	function Pax1OpenAction ()
    ----------------------------------------------------------- Pax Door 1 open
        if ipc.readLvar("L:NGXFwdLeftCabinDoor") == 0 then
    	ipc.control(PMDGBaseVar+14005)
    	DspShow ("1 L", "open", "DOOR 1 L", "opening")
        end
    ------------------------------------------------------------
    end

    function Pax2OpenAction ()
    ----------------------------------------------------------- Pax Door 2 open

    ------------------------------------------------------------
    end

    function Pax3OpenAction ()
    ----------------------------------------------------------- Pax Door 3 open

    ------------------------------------------------------------
    end

    function Pax4OpenAction ()
    ----------------------------------------------------------- Pax Door 4 open
        if ipc.readLvar("L:NGXAftLeftCabinDoor") == 0 then
    	ipc.control(PMDGBaseVar+14007)
    	DspShow ("2 L", "open", "DOOR 2 L", "opening")
        end
    ------------------------------------------------------------
    end

    function Pax5OpenAction ()
    ----------------------------------------------------------- Pax Door 5 open

    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

    function Pax1CloseAction ()
    ----------------------------------------------------------- Pax Door 1 close
        if ipc.readLvar("L:NGXFwdLeftCabinDoor") == 100 then
    	ipc.control(PMDGBaseVar+14005)
    	DspShow ("1 L", "close", "DOOR 1 L", "closing")
        end
    ------------------------------------------------------------
    end

    function Pax2CloseAction ()
    ----------------------------------------------------------- Pax Door 2 close

    ------------------------------------------------------------
    end

    function Pax3CloseAction ()
    ----------------------------------------------------------- Pax Door 3 close

    ------------------------------------------------------------
    end

    function Pax4CloseAction ()
    ----------------------------------------------------------- Pax Door 4 close
        if ipc.readLvar("L:NGXAftLeftCabinDoor") == 100 then
    	ipc.control(PMDGBaseVar+14007)
    	DspShow ("2 L", "close", "DOOR 2 L", "closing")
        end
    ------------------------------------------------------------
    end

    function Pax5CloseAction ()
    ----------------------------------------------------------- Pax Door 5 close

    ------------------------------------------------------------
    end





---------------------------------------------------------------------------------
-- $$ NGX Cargo Doors
---------------------------------------------------------------------------------


	function Cargo1OpenAction ()
    ----------------------------------------------------------- Cargo Door 1 open
        if ipc.readLvar("L:NGXFwdCargoDoor") == 0 then
    	ipc.control(PMDGBaseVar+14013)
    	DspShow ("Crg1", "open", "CARGO FWD", "opening")
        end
    ------------------------------------------------------------
    end

    	function Cargo2OpenAction ()
    ----------------------------------------------------------- Cargo Door 2 open
        if ipc.readLvar("L:NGXAftCargoDoor") == 0 then
    	ipc.control(PMDGBaseVar+14014)
    	DspShow ("Crg2", "open", "CARGO AFT", "opening")
        end
    ------------------------------------------------------------
    end

    	function Cargo3OpenAction ()
    ----------------------------------------------------------- Cargo Door 3 open

    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

	function Cargo1CloseAction ()
    ----------------------------------------------------------- Cargo Door 1 open
        if ipc.readLvar("L:NGXFwdCargoDoor") == 100 then
    	ipc.control(PMDGBaseVar+14013)
    	DspShow ("Crg1", "close", "CARGO FWD", "closing")
        end
    ------------------------------------------------------------
    end

    	function Cargo2CloseAction ()
    ----------------------------------------------------------- Cargo Door 2 open
        if ipc.readLvar("L:NGXAftCargoDoor") == 100 then
    	ipc.control(PMDGBaseVar+14014)
    	DspShow ("Crg2", "close", "CARGO AFT", "closing")
        end
    ------------------------------------------------------------
    end

    	function Cargo3CloseAction ()
    ----------------------------------------------------------- Cargo Door 3 open

    ------------------------------------------------------------
    end



---------------------------------------------------------------------------------
-- $$ NGX Service Doors
---------------------------------------------------------------------------------


	function Service1OpenAction ()
    ----------------------------------------------------------- Service Door 1 open
        if ipc.readLvar("L:NGXFwdRightCabinDoor") == 0 then
    	ipc.control(PMDGBaseVar+14006)
    	DspShow ("1 R", "open", "DOOR 1 R", "opening")
        end
    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

    function Service2OpenAction ()
    ----------------------------------------------------------- Service Door 2 open
        if ipc.readLvar("L:NGXAftRightCabinDoor") == 0 then
    	ipc.control(PMDGBaseVar+14008)
    	DspShow ("2 R", "open", "DOOR 2 R", "opening")
        end
    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

---------------------------------------------------------------------------------
-- $$ -

	function Service1CloseAction ()
    ----------------------------------------------------------- Service Door 1 Close
        if ipc.readLvar("L:NGXFwdRightCabinDoor") == 100 then
        ipc.control(PMDGBaseVar+14006)
        DspShow ("1 R", "close", "DOOR 1 R", "closing")
        end
    ------------------------------------------------------------
    end

    function Service2CloseAction ()
    ----------------------------------------------------------- Service Door 2 open
        if ipc.readLvar("L:NGXAftRightCabinDoor") == 100 then
    	ipc.control(PMDGBaseVar+14008)
    	DspShow ("2 R", "close", "DOOR 2 R", "closing")
        end
    ------------------------------------------------------------
    end


end



-- ## MJC8Q ###############

function GSX_MJC8Q ()
AddonName = "MJC8Q"

---------------------------------------------------------------------------------
-- $$ MJC8Q PAX Doors
---------------------------------------------------------------------------------
	function Pax1OpenAction ()
    ----------------------------------------------------------- Pax Door 1 open
        MJCdoor = ipc.readUB(0x3367)
        if MJCdoor ~= 1 and MJCdoor ~= 3 and MJCdoor ~= 5 and MJCdoor ~= 9 then
        ipc.control(66389)
        ipc.control(65538)
        end
        DspShow ("FwdL", "open", "FWD L", "open")
    ------------------------------------------------------------
    end

    function Pax2OpenAction ()
    ----------------------------------------------------------- Pax Door 2 open

    ------------------------------------------------------------
    end

    function Pax3OpenAction ()
    ----------------------------------------------------------- Pax Door 3 open

    ------------------------------------------------------------
    end

    function Pax4OpenAction ()
    ----------------------------------------------------------- Pax Door 4 open
         MJCdoor = ipc.readUB(0x3367)
        if MJCdoor ~= 4 and MJCdoor ~= 5 and MJCdoor ~= 6 and MJCdoor ~= 12 then
        ipc.control(66389)
        ipc.control(65540)
        end
        DspShow ("AftL", "open", "AFT L", "open")
    ------------------------------------------------------------
    end

    function Pax5OpenAction ()
    ----------------------------------------------------------- Pax Door 5 open

    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

    function Pax1CloseAction ()
    ----------------------------------------------------------- Pax Door 1 close
        MJCdoor = ipc.readUB(0x3367)
        if MJCdoor == 1 or MJCdoor == 3 or MJCdoor == 5 or MJCdoor == 9 then
        ipc.control(66389)
        ipc.control(65538)
        end
        DspShow ("FwdL", "clse", "FWD L", "close")
    ------------------------------------------------------------
    end

    function Pax2CloseAction ()
    ----------------------------------------------------------- Pax Door 2 close

    ------------------------------------------------------------
    end

    function Pax3CloseAction ()
    ----------------------------------------------------------- Pax Door 3 close

    ------------------------------------------------------------
    end

    function Pax4CloseAction ()
    ----------------------------------------------------------- Pax Door 4 close
        MJCdoor = ipc.readUB(0x3367)
        if MJCdoor == 4 or MJCdoor == 5 or MJCdoor == 6 or MJCdoor == 12 then
        ipc.control(66389)
        ipc.control(65540)
        end
        DspShow ("AftL", "clse", "AFT L", "close")
    ------------------------------------------------------------
    end

    function Pax5CloseAction ()
    ----------------------------------------------------------- Pax Door 5 close

    ------------------------------------------------------------
    end





---------------------------------------------------------------------------------
-- $$ MJC8Q Cargo Doors
---------------------------------------------------------------------------------


	function Cargo1OpenAction ()
    ----------------------------------------------------------- Cargo Door 1 open

    ------------------------------------------------------------
    end

    	function Cargo2OpenAction ()
    ----------------------------------------------------------- Cargo Door 2 open
        MJCdoor = ipc.readUB(0x3367)
        if MJCdoor ~= 2 and MJCdoor ~= 3 and MJCdoor ~= 6 and MJCdoor ~= 10 then
        ipc.control(66389)
        ipc.control(65539)
        end
        DspShow ("Crgo", "open", "Cargo", "open")
    ------------------------------------------------------------
    end

    	function Cargo3OpenAction ()
    ----------------------------------------------------------- Cargo Door 3 open

    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

	function Cargo1CloseAction ()
    ----------------------------------------------------------- Cargo Door 1 open

    ------------------------------------------------------------
    end

    	function Cargo2CloseAction ()
    ----------------------------------------------------------- Cargo Door 2 open
        MJCdoor = ipc.readUB(0x3367)
        if MJCdoor == 2 or MJCdoor == 3 or MJCdoor == 6 or MJCdoor == 10 then
        ipc.control(66389)
        ipc.control(65539)
        end
        DspShow ("Crgo", "clse", "Cargo", "close")
    ------------------------------------------------------------
    end

    	function Cargo3CloseAction ()
    ----------------------------------------------------------- Cargo Door 3 open

    ------------------------------------------------------------
    end



---------------------------------------------------------------------------------
-- $$ MJC8Q Service Doors
---------------------------------------------------------------------------------


	function Service1OpenAction ()
    ----------------------------------------------------------- Service Door 1 open

    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

    function Service2OpenAction ()
    ----------------------------------------------------------- Service Door 2 open
        MJCdoor = ipc.readUB(0x3367)
        if MJCdoor ~= 8 and MJCdoor ~= 9 and MJCdoor ~= 10 and MJCdoor ~= 12 then
        ipc.control(66389)
        ipc.control(65541)
        end
        DspShow ("Rght", "open", "Doors R", "open")
    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

---------------------------------------------------------------------------------
-- $$ -

	function Service1CloseAction ()
    ----------------------------------------------------------- Service Door 1 Close

    ------------------------------------------------------------
    end

    function Service2CloseAction ()
    ----------------------------------------------------------- Service Door 2 open
        MJCdoor = ipc.readUB(0x3367)
        if MJCdoor == 8 or MJCdoor == 9 or MJCdoor == 10 or MJCdoor == 12 then
        ipc.control(66389)
        ipc.control(65541)
        end
        DspShow ("Rght", "clse", "Doors R", "close")
    ------------------------------------------------------------
    end


end



-- ## PMDG 747 ###############

function GSX_PMDG_747 ()
AddonName = "PMDG 747"

---------------------------------------------------------------------------------
-- $$ PMDG_747 PAX Doors
---------------------------------------------------------------------------------
	function Pax1OpenAction ()
    ----------------------------------------------------------- Pax Door 1 open
       EXT1L = ipc.readUB(0x6C30)
            if EXT1L ~= 0 then
            ipc.control(PMDGBaseVariable +14011,1)
            DspShow ("1L", "open")
        end
    ------------------------------------------------------------
    end

    function Pax2OpenAction ()
    ----------------------------------------------------------- Pax Door 2 open
            EXT2L = ipc.readUB(0x6C32)
            if EXT2L ~= 0 then
            ipc.control(PMDGBaseVariable +14013,1)
            DspShow ("2L", "open")
        end
    ------------------------------------------------------------
    end

    function Pax3OpenAction ()
    ----------------------------------------------------------- Pax Door 3 open
            EXT4L = ipc.readUB(0x6C36)
            if EXT4L ~= 0 then
            ipc.control(PMDGBaseVariable +14017,1)
            DspShow ("4L", "open")
        end
    ------------------------------------------------------------
    end

    function Pax4OpenAction ()
    ----------------------------------------------------------- Pax Door 4 open
            EXT5L = ipc.readUB(0x6C38)
            if EXT5L ~= 0 then
            ipc.control(PMDGBaseVariable +14019,1)
            DspShow ("5L", "open")
        end
    ------------------------------------------------------------
    end

    function Pax5OpenAction ()
    ----------------------------------------------------------- Pax Door 5 open

    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

    function Pax1CloseAction ()
    ----------------------------------------------------------- Pax Door 1 close
        EXT1L = ipc.readUB(0x6C30)
            if EXT1L == 0 then
            ipc.control(PMDGBaseVariable +14011,1)
            DspShow ("1L", "clse")
        end
    ------------------------------------------------------------
    end

    function Pax2CloseAction ()
    ----------------------------------------------------------- Pax Door 2 close
         EXT2L = ipc.readUB(0x6C32)
            if EXT2L == 0 then
            ipc.control(PMDGBaseVariable +14013,1)
            DspShow ("2L", "clse")
        end
    ------------------------------------------------------------
    end

    function Pax3CloseAction ()
    ----------------------------------------------------------- Pax Door 3 close
            EXT4L = ipc.readUB(0x6C36)
            if EXT4L == 0 then
            ipc.control(PMDGBaseVariable +14017,1)
            DspShow ("4L", "clse")
        end
    ------------------------------------------------------------
    end

    function Pax4CloseAction ()
    ----------------------------------------------------------- Pax Door 4 close
             EXT5L = ipc.readUB(0x6C38)
            if EXT5L == 0 then
            ipc.control(PMDGBaseVariable +14019,1)
            DspShow ("5L", "clse")
        end
    ------------------------------------------------------------
    end

    function Pax5CloseAction ()
    ----------------------------------------------------------- Pax Door 5 close

    ------------------------------------------------------------
    end





---------------------------------------------------------------------------------
-- $$ PMDG_747 Cargo Doors
---------------------------------------------------------------------------------


	function Cargo1OpenAction ()
    ----------------------------------------------------------- Cargo Door 1 open
        CRGFWD = ipc.readUB(0x6C3C)
        if CRGFWD ~= 0 then
            ipc.control(PMDGBaseVariable +14023,1)
            DspShow ("CFWD", "open")
        end
    ------------------------------------------------------------
    end

    function Cargo2OpenAction ()
    ----------------------------------------------------------- Cargo Door 2 open
         CRGAFT = ipc.readUB(0x6C3D)
        if CRGAFT ~= 0 then
            ipc.control(PMDGBaseVariable +14024,1)
            DspShow ("CAFT", "open")
        end
    ------------------------------------------------------------
    end

    function Cargo3OpenAction ()
    ----------------------------------------------------------- Cargo Door 3 open
         CRGSIDE = ipc.readUB(0x6C3F)
        if CRGSIDE ~= 0 then
            ipc.control(PMDGBaseVariable +14026,1)
            DspShow ("CSDE", "open")
        end

        GSX_PMDG_400F_NOSECARGOLOADER ()
    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

	function Cargo1CloseAction ()
    ----------------------------------------------------------- Cargo Door 1 open
         CRGFWD = ipc.readUB(0x6C3C)
            if CRGFWD == 0 then
            ipc.control(PMDGBaseVariable +14023,1)
            DspShow ("CFWD", "clse")
        end
    ------------------------------------------------------------
    end

    	function Cargo2CloseAction ()
    ----------------------------------------------------------- Cargo Door 2 open
        CRGAFT = ipc.readUB(0x6C3D)
        if CRGAFT == 0 then
            ipc.control(PMDGBaseVariable +14024,1)
            DspShow ("CAFT", "clse")
        end
    ------------------------------------------------------------
    end

    function Cargo3CloseAction ()
    ----------------------------------------------------------- Cargo Door 3 open
         CRGSIDE = ipc.readUB(0x6C3F)
        if CRGSIDE == 0 then
            ipc.control(PMDGBaseVariable +14026,1)
            DspShow ("CSDE", "clse")
        end

        GSX_PMDG_400F_NOSECARGOLOADER ()
    ------------------------------------------------------------
    end


    function GSX_PMDG_400F_NOSECARGOLOADER ()
        CRGNOSE = ipc.readUB(0x6C40)
        if string.find(acftname,"PMDG 747-400F",0,true) then

            if CRGNOSE == 1 then
                ipc.control(PMDGBaseVariable +14027,1)
                DspShow ("CNSE", "open")

                        -- Nosecargoloader request
        ipc.control(PMDGBaseVariable +CDURstartVar+ 23, 1)  -- CDU R Menu
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDURstartVar+ 11, 1)  -- CDU R LSK 6R
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDURstartVar+ 7, 1)   -- CDU R LSK 2R
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDURstartVar+ 1, 1)   -- CDU R LSK 2L


            elseif CRGNOSE == 0 then
                ipc.control(PMDGBaseVariable +14027,1)
                DspShow ("CNSE", "clse")

                        -- Nosecargoloader request
        ipc.control(PMDGBaseVariable +CDURstartVar+ 23, 1)  -- CDU R Menu
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDURstartVar+ 11, 1)  -- CDU R LSK 6R
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDURstartVar+ 7, 1)   -- CDU R LSK 2R
        ipc.sleep(50)
        ipc.control(PMDGBaseVariable +CDURstartVar+ 1, 1)   -- CDU R LSK 2L
            end

        end
    end


---------------------------------------------------------------------------------
-- $$ PMDG_747 Service Doors
---------------------------------------------------------------------------------


	function Service1OpenAction ()
    ----------------------------------------------------------- Service Door 1 open
        EXT1R = ipc.readUB(0x6C31)
        if EXT1R ~= 0 then
        ipc.control(PMDGBaseVariable +14012,1)
        DspShow ("1R", "open")
        end
    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

    function Service2OpenAction ()
    ----------------------------------------------------------- Service Door 2 open
         EXT5R = ipc.readUB(0x6C39)
        if EXT5R ~= 0 then
        ipc.control(PMDGBaseVariable +14020,1)
        DspShow ("5R", "open")
	    end
    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

---------------------------------------------------------------------------------
-- $$ -

	function Service1CloseAction ()
    ----------------------------------------------------------- Service Door 1 Close
        EXT1R = ipc.readUB(0x6C31)
        if EXT1R == 0 then
        ipc.control(PMDGBaseVariable +14012,1)
        DspShow ("1R", "clse")
        end
    ------------------------------------------------------------
    end

    function Service2CloseAction ()
    ----------------------------------------------------------- Service Door 2 open
         EXT5R = ipc.readUB(0x6C39)
        if EXT5R == 0 then
        ipc.control(PMDGBaseVariable +14020,1)
        DspShow ("5R", "clse")
        end
    ------------------------------------------------------------
    end

end



--------------------------------------------
--------------------------------------------

-- ## PMDG 777 ###############

function GSX_PMDG_777 ()
AddonName = "PMDG 777"

---------------------------------------------------------------------------------
-- $$ PMDG 777 PAX Doors
---------------------------------------------------------------------------------
	function Pax1OpenAction ()
    ----------------------------------------------------------- Pax Door 1 open
        if ipc.readLvar("L:7X7XCabinDoor1L") == 0 then
        ipc.control(PMDGBaseVariable+14011)
        DspShow ("1 L", "open", "DOOR 1 L", "opening")
        end
    ------------------------------------------------------------
    end

    function Pax2OpenAction ()
    ----------------------------------------------------------- Pax Door 2 open
        if ipc.readLvar("L:7X7XCabinDoor2L") == 0 then
        ipc.control(PMDGBaseVariable+14013)
        DspShow ("2 L", "open", "DOOR 2 L", "opening")
        end
    ------------------------------------------------------------
    end

    function Pax3OpenAction ()
    ----------------------------------------------------------- Pax Door 3 open
         if ipc.readLvar("L:7X7XCabinDoor3L") == 0 then
        ipc.control(PMDGBaseVariable+14015)
        DspShow ("3 L", "open", "DOOR 3 L", "opening")
        end
    ------------------------------------------------------------
    end

    function Pax4OpenAction ()
    ----------------------------------------------------------- Pax Door 4 open
        acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"PMDG 777-2",0,true) then
            if ipc.readLvar("L:7X7XCabinDoor4L") == 0 then
            ipc.control(PMDGBaseVariable+14017)
            DspShow ("4 L", "open", "DOOR 4 L", "opening")
            end

        elseif string.find(acftname,"PMDG 777-3",0,true) then
            if ipc.readLvar("L:7X7XCabinDoor5L") == 0 then
            ipc.control(PMDGBaseVariable+14019)
            DspShow ("5 L", "open", "DOOR 5 L", "opening")
            end
        end
    ------------------------------------------------------------
    end

    function Pax5OpenAction ()
    ----------------------------------------------------------- Pax Door 5 open
          if ipc.readLvar("L:7X7XCabinDoor5L") == 0 then
        ipc.control(PMDGBaseVariable+14019)
        DspShow ("5 L", "open", "DOOR 5 L", "opening")
        end
    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

    function Pax1CloseAction ()
    ----------------------------------------------------------- Pax Door 1 close
         if ipc.readLvar("L:7X7XCabinDoor1L") == 100 then
        ipc.control(PMDGBaseVariable+14011)
        DspShow ("1 L", "clse", "DOOR 1 L", "closing")
        end
    ------------------------------------------------------------
    end

    function Pax2CloseAction ()
    ----------------------------------------------------------- Pax Door 2 close
         if ipc.readLvar("L:7X7XCabinDoor2L") == 100 then
        ipc.control(PMDGBaseVariable+14013)
        DspShow ("2 L", "clse", "DOOR 2 L", "closing")
        end
    ------------------------------------------------------------
    end

    function Pax3CloseAction ()
    ----------------------------------------------------------- Pax Door 3 close
        if ipc.readLvar("L:7X7XCabinDoor3L") == 100 then
        ipc.control(PMDGBaseVariable+14015)
        DspShow ("3 L", "clse", "DOOR 3 L", "closing")
        end
    ------------------------------------------------------------
    end

    function Pax4CloseAction ()
    ----------------------------------------------------------- Pax Door 4 close
        acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"PMDG 777-2",0,true) then
            if ipc.readLvar("L:7X7XCabinDoor4L") == 100 then
            ipc.control(PMDGBaseVariable+14017)
            DspShow ("4 L", "clse", "DOOR 4 L", "closing")
            end

        elseif string.find(acftname,"PMDG 777-3",0,true) then
            if ipc.readLvar("L:7X7XCabinDoor5L") == 100 then
            ipc.control(PMDGBaseVariable+14019)
            DspShow ("5 L", "clse", "DOOR 5 L", "closing")
            end
        end
    ------------------------------------------------------------
    end

    function Pax5CloseAction ()
    ----------------------------------------------------------- Pax Door 5 close
        if ipc.readLvar("L:7X7XCabinDoor5L") == 100 then
        ipc.control(PMDGBaseVariable+14019)
        DspShow ("5 L", "clse", "DOOR 5 L", "closing")
        end
    ------------------------------------------------------------
    end





---------------------------------------------------------------------------------
-- $$ PMDG 777 Cargo Doors
---------------------------------------------------------------------------------


	function Cargo1OpenAction ()
    ----------------------------------------------------------- Cargo Door 1 open
         if ipc.readLvar("L:7X7XforwardcargoDoor") == 0 then
        ipc.control(PMDGBaseVariable+14021)
        DspShow ("Crgo", "fwd", "FwdCargo", "opening")
        end
    ------------------------------------------------------------
    end

    function Cargo2OpenAction ()
    ----------------------------------------------------------- Cargo Door 2 open
          if ipc.readLvar("L:7X7XaftcargoDoor") == 0 then
        ipc.control(PMDGBaseVariable+14022)
        DspShow ("Crgo", "aft", "AftCargo", "opening")
        end
    ------------------------------------------------------------
    end

    function Cargo3OpenAction ()
    ----------------------------------------------------------- Cargo Door 3 open
          if ipc.readLvar("L:7X7XmaincargoDoor") == 0 then
        ipc.control(PMDGBaseVariable+14024)
        DspShow ("Main", "open", "MainCrgo", "opening")
        end
    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

	function Cargo1CloseAction ()
    ----------------------------------------------------------- Cargo Door 1 open
        if ipc.readLvar("L:7X7XforwardcargoDoor") == 100 then
        ipc.control(PMDGBaseVariable+14021)
        DspShow ("Crgo", "fwd", "FwdCargo", "closing")
        end
    ------------------------------------------------------------
    end

    function Cargo2CloseAction ()
    ----------------------------------------------------------- Cargo Door 2 open
         if ipc.readLvar("L:7X7XaftcargoDoor") == 100 then
        ipc.control(PMDGBaseVariable+14022)
        DspShow ("Crgo", "aft", "AftCargo", "closing")
        end
    ------------------------------------------------------------
    end

    function Cargo3CloseAction ()
    ----------------------------------------------------------- Cargo Door 3 open
          if ipc.readLvar("L:7X7XmaincargoDoor") == 100 then
        ipc.control(PMDGBaseVariable+14024)
        DspShow ("Main", "clse", "MainCrgo", "closing")
        end
    ------------------------------------------------------------
    end



---------------------------------------------------------------------------------
-- $$ PMDG 777 Service Doors
---------------------------------------------------------------------------------


	function Service1OpenAction ()
    ----------------------------------------------------------- Service Door 1 open
       acftname = ipc.readSTR("3D00", 35)
       if string.find(acftname,"PMDG 777F",0,true) then
            if ipc.readLvar("L:7X7XCabinDoor1R") == 0 then
            ipc.control(PMDGBaseVariable+14012)
            DspShow ("1 R", "open", "DOOR 1 R", "opening")
            end
       else
            if ipc.readLvar("L:7X7XCabinDoor2R") == 0 then
            ipc.control(PMDGBaseVariable+14014)
            DspShow ("2 R", "open", "DOOR 2 R", "opening")
            end
       end
    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

    function Service2OpenAction ()
    ----------------------------------------------------------- Service Door 2 open
        acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"PMDG 777-2",0,true) then

            if ipc.readLvar("L:7X7XCabinDoor4R") == 0 then
            ipc.control(PMDGBaseVariable+14018)
            DspShow ("4 R", "open", "DOOR 4 R", "opening")
            end

        elseif string.find(acftname,"PMDG 777-3",0,true) then
            if ipc.readLvar("L:7X7XCabinDoor5R") == 0 then
            ipc.control(PMDGBaseVariable+14020)
            DspShow ("5 R", "open", "DOOR 5 R", "opening")
            end
        end
    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

---------------------------------------------------------------------------------
-- $$ -

	function Service1CloseAction ()
    ----------------------------------------------------------- Service Door 1 Close
        acftname = ipc.readSTR("3D00", 35)
       if string.find(acftname,"PMDG 777F",0,true) then
            if ipc.readLvar("L:7X7XCabinDoor1R") == 100 then
            ipc.control(PMDGBaseVariable+14012)
            DspShow ("1 R", "open", "DOOR 1 R", "closing")
            end
       else
            if ipc.readLvar("L:7X7XCabinDoor2R") == 100 then
                ipc.control(PMDGBaseVariable+14014)
                DspShow ("2 R", "clse", "DOOR 2 R", "closing")
            end
       end
    ------------------------------------------------------------
    end

    function Service2CloseAction ()
    ----------------------------------------------------------- Service Door 2 open
        acftname = ipc.readSTR("3D00", 35)
        if string.find(acftname,"PMDG 777-2",0,true) then

            if ipc.readLvar("L:7X7XCabinDoor4R") == 100 then
            ipc.control(PMDGBaseVariable+14018)
            DspShow ("4 R", "clse", "DOOR 4 R", "closing")
            end

        elseif string.find(acftname,"PMDG 777-3",0,true) then
            if ipc.readLvar("L:7X7XCabinDoor5R") == 100 then
            ipc.control(PMDGBaseVariable+14020)
            DspShow ("5 R", "clse", "DOOR 5 R", "closing")
            end
        end
    ------------------------------------------------------------
    end


end


--------------------------------------------
--------------------------------------------

-- ## Maddog ###############

function GSX_Maddog ()
AddonName = "Maddog"

---------------------------------------------------------------------------------
-- $$ Maddog PAX Doors
---------------------------------------------------------------------------------
	function Pax1OpenAction ()
    ----------------------------------------------------------- Pax Door 1 open
        ipc.sleep(50)
        MDX_DoorVar = ipc.readUB(0x3367)
        if MDX_DoorVar ~= 1 and MDX_DoorVar ~= 3 and MDX_DoorVar ~= 5 and MDX_DoorVar ~= 7 then
        ipc.control(69974, 1)
        DspShow ("1 L", "open")
        end
    ------------------------------------------------------------
    end

    function Pax2OpenAction ()
    ----------------------------------------------------------- Pax Door 2 open

    ------------------------------------------------------------
    end

    function Pax3OpenAction ()
    ----------------------------------------------------------- Pax Door 3 open

    ------------------------------------------------------------
    end

    function Pax4OpenAction ()
    ----------------------------------------------------------- Pax Door 4 open

    ------------------------------------------------------------
    end

    function Pax5OpenAction ()
    ----------------------------------------------------------- Pax Door 5 open

    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

    function Pax1CloseAction ()
    ----------------------------------------------------------- Pax Door 1 close
         ipc.sleep(50)
        MDX_DoorVar = ipc.readUB(0x3367)
        if MDX_DoorVar == 1 or MDX_DoorVar == 3 or MDX_DoorVar == 5 or MDX_DoorVar == 7 then
        ipc.control(69974, 1)
        DspShow ("1 L", "clse")
        end
    ------------------------------------------------------------
    end

    function Pax2CloseAction ()
    ----------------------------------------------------------- Pax Door 2 close

    ------------------------------------------------------------
    end

    function Pax3CloseAction ()
    ----------------------------------------------------------- Pax Door 3 close

    ------------------------------------------------------------
    end

    function Pax4CloseAction ()
    ----------------------------------------------------------- Pax Door 4 close

    ------------------------------------------------------------
    end

    function Pax5CloseAction ()
    ----------------------------------------------------------- Pax Door 5 close

    ------------------------------------------------------------
    end





---------------------------------------------------------------------------------
-- $$ Maddog Cargo Doors
---------------------------------------------------------------------------------


	function Cargo1OpenAction ()
    ----------------------------------------------------------- Cargo Door 1 open
          ipc.sleep(50)
        MDX_DoorVar = ipc.readUB(0x3367)
        if MDX_DoorVar ~= 4 and MDX_DoorVar ~= 5 and MDX_DoorVar ~= 6 and MDX_DoorVar ~= 7 then
        ipc.control(69974, 6)
        DspShow ("Cargo", "open")
        end
    ------------------------------------------------------------
    end

    function Cargo2OpenAction ()
    ----------------------------------------------------------- Cargo Door 2 open

    ------------------------------------------------------------
    end

    function Cargo3OpenAction ()
    ----------------------------------------------------------- Cargo Door 3 open

    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

	function Cargo1CloseAction ()
    ----------------------------------------------------------- Cargo Door 1 open
        ipc.sleep(50)
        MDX_DoorVar = ipc.readUB(0x3367)
        if MDX_DoorVar == 4 or MDX_DoorVar == 5 or MDX_DoorVar == 6 or MDX_DoorVar == 7 then
        ipc.control(69974, 6)
        DspShow ("Cargo", "clse")
        end
    ------------------------------------------------------------
    end

    function Cargo2CloseAction ()
    ----------------------------------------------------------- Cargo Door 2 open

    ------------------------------------------------------------
    end

    function Cargo3CloseAction ()
    ----------------------------------------------------------- Cargo Door 3 open

    ------------------------------------------------------------
    end



---------------------------------------------------------------------------------
-- $$ Maddog Service Doors
---------------------------------------------------------------------------------


	function Service1OpenAction ()
    ----------------------------------------------------------- Service Door 1 open
        ipc.sleep(50)
        MDX_DoorVar = ipc.readUB(0x3367)
        if MDX_DoorVar ~= 2 and MDX_DoorVar ~= 3 and MDX_DoorVar ~= 6 and MDX_DoorVar ~= 7 then
        ipc.control(69974, 5)
        DspShow ("Svce", "open")
        end
    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

    function Service2OpenAction ()
    ----------------------------------------------------------- Service Door 2 open

    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

---------------------------------------------------------------------------------
-- $$ -

	function Service1CloseAction ()
    ----------------------------------------------------------- Service Door 1 Close
        ipc.sleep(50)
        MDX_DoorVar = ipc.readUB(0x3367)
        if MDX_DoorVar == 2 or MDX_DoorVar == 3 or MDX_DoorVar == 6 or MDX_DoorVar == 7 then
        ipc.control(69974, 5)
        DspShow ("Svce", "clse")
        end
    ------------------------------------------------------------
    end

    function Service2CloseAction ()
    ----------------------------------------------------------- Service Door 2 open

    ------------------------------------------------------------
    end


end




--[[     Empty Template

--------------------------------------------
--------------------------------------------

-- ## xxxx ###############

function GSX_xxxx ()
AddonName = "xxxx"

---------------------------------------------------------------------------------
-- $$ xxxx PAX Doors
---------------------------------------------------------------------------------
	function Pax1OpenAction ()
    ----------------------------------------------------------- Pax Door 1 open

    ------------------------------------------------------------
    end

    function Pax2OpenAction ()
    ----------------------------------------------------------- Pax Door 2 open

    ------------------------------------------------------------
    end

    function Pax3OpenAction ()
    ----------------------------------------------------------- Pax Door 3 open

    ------------------------------------------------------------
    end

    function Pax4OpenAction ()
    ----------------------------------------------------------- Pax Door 4 open

    ------------------------------------------------------------
    end

    function Pax5OpenAction ()
    ----------------------------------------------------------- Pax Door 5 open

    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

    function Pax1CloseAction ()
    ----------------------------------------------------------- Pax Door 1 close

    ------------------------------------------------------------
    end

    function Pax2CloseAction ()
    ----------------------------------------------------------- Pax Door 2 close

    ------------------------------------------------------------
    end

    function Pax3CloseAction ()
    ----------------------------------------------------------- Pax Door 3 close

    ------------------------------------------------------------
    end

    function Pax4CloseAction ()
    ----------------------------------------------------------- Pax Door 4 close

    ------------------------------------------------------------
    end

    function Pax5CloseAction ()
    ----------------------------------------------------------- Pax Door 5 close

    ------------------------------------------------------------
    end





---------------------------------------------------------------------------------
-- $$ xxxx Cargo Doors
---------------------------------------------------------------------------------


	function Cargo1OpenAction ()
    ----------------------------------------------------------- Cargo Door 1 open

    ------------------------------------------------------------
    end

    function Cargo2OpenAction ()
    ----------------------------------------------------------- Cargo Door 2 open

    ------------------------------------------------------------
    end

    function Cargo3OpenAction ()
    ----------------------------------------------------------- Cargo Door 3 open

    ------------------------------------------------------------
    end

---------------------------------------------------------------------------------
-- $$ -

	function Cargo1CloseAction ()
    ----------------------------------------------------------- Cargo Door 1 open

    ------------------------------------------------------------
    end

    function Cargo2CloseAction ()
    ----------------------------------------------------------- Cargo Door 2 open

    ------------------------------------------------------------
    end

    function Cargo3CloseAction ()
    ----------------------------------------------------------- Cargo Door 3 open

    ------------------------------------------------------------
    end



---------------------------------------------------------------------------------
-- $$ xxxx Service Doors
---------------------------------------------------------------------------------


	function Service1OpenAction ()
    ----------------------------------------------------------- Service Door 1 open

    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

    function Service2OpenAction ()
    ----------------------------------------------------------- Service Door 2 open

    ------------------------------------------------------------
        GSXTime = math.floor(ipc.readDBL("04A8"))
    end

---------------------------------------------------------------------------------
-- $$ -

	function Service1CloseAction ()
    ----------------------------------------------------------- Service Door 1 Close

    ------------------------------------------------------------
    end

    function Service2CloseAction ()
    ----------------------------------------------------------- Service Door 2 open

    ------------------------------------------------------------
    end


end

--]]










_log("[LIB]  GSX library loaded...")

