-- A2A Map

function A2A_MAP_toggle ()

	ipc.control(65910)

end



function A2A_MAP_Rings_inc ()

	LVarSet = "LayerRangeRings"

	cur = ipc.readLvar(LVarSet)
	if cur == 0 then
	val = 2
	elseif cur == 2 then
	val = 5
	elseif cur == 5 then
	val = 10
	elseif cur == 10 then
	val = 20
	elseif cur == 20 then
	val = 0
	end
	
	ipc.writeLvar(LVarSet, val)
	A2AMap_Rings_show ()
end


function A2A_MAP_Rings_dec ()

	LVarSet = "LayerRangeRings"

	cur = ipc.readLvar(LVarSet)
	if cur == 2 then
	val = 0
	elseif cur == 5 then
	val = 2
	elseif cur == 10 then
	val = 5
	elseif cur == 20 then
	val = 10
	elseif cur == 0 then
	val = 20
	end
	
	ipc.writeLvar(LVarSet, val)
	A2AMap_Rings_show ()
end

function A2AMap_Rings_show ()

	LVarSet = "LayerRangeRings"

	curZoom = ipc.readLvar(LVarSet)

	DspShow("Ring", curZoom)
end



function A2A_MAP_Range_out ()

	LVarSet = "map_ZoomFactor"

	curZoom = ipc.readLvar(LVarSet)
	if curZoom <= 10 then
	mult = 1
	elseif curZoom <= 30 then
	mult = 5
	elseif curZoom <= 50 then
	mult = 10
	elseif curZoom <= 100 then
	mult = 15
	elseif curZoom <= 500 then
	mult = 50
	end
	
	ipc.writeLvar(LVarSet, curZoom+mult)
		A2AMap_Range_show ()

end

function A2A_MAP_Range_in ()

	LVarSet = "map_ZoomFactor"



	curZoom = ipc.readLvar(LVarSet)
	if curZoom <= 10 then
	mult = 1
	elseif curZoom <= 30 then
	mult = 5
	elseif curZoom <= 50 then
	mult = 10
	elseif curZoom <= 100 then
	mult = 15
	elseif curZoom <= 500 then
	mult = 50
	end
	
	ipc.writeLvar(LVarSet, curZoom-mult)
	A2AMap_Range_show ()

end



function A2AMap_Range_show ()

	LVarSet = "map_ZoomFactor"

	curZoom = ipc.readLvar(LVarSet)

	DspShow("Rnge", curZoom)
end


function A2A_MAP_Compass_toggle ()

	LVarSet = "L:LayerCompass"
	val = 0

   	if ipc.readLvar(LVarSet) == 0 then
   	val = 1
    	end

  	ipc.writeLvar(LVarSet, val)
end




function A2A_MAP_Terrain_toggle ()

	LVarSet = "LayerTerrain"
	val = 0

   	if ipc.readLvar(LVarSet) == 0 then
   	val = 1
    	end

  	ipc.writeLvar(LVarSet, val)
end


function A2A_MAP_Airspace_toggle ()


	LVarSet = "LayerAirspaces"
	val = 0

   	if ipc.readLvar(LVarSet) == 0 then
   	val = 1
    	end

  	ipc.writeLvar(LVarSet, val)
end


function A2A_MAP_Airports_toggle ()


	LVarSet = "LayerAirports"
	i = ipc.readLvar(LVarSet)
	val = 0
	if i <= 3 then
	val = i+1
	ipc.sleep(10)
	end

	ipc.writeLvar(LVarSet, val)

end



function A2A_MAP_VORs_toggle ()

	LVarSet = "LayerVORs"
	i = ipc.readLvar(LVarSet)
	val = 0
	if i <= 2 then
	val = i+1
	ipc.sleep(10)
	end

	ipc.writeLvar(LVarSet, val)

end


function A2A_MAP_NDBs_toggle ()


	LVarSet = "LayerNDBs"
	i = ipc.readLvar(LVarSet)
	val = 0
	if i <= 2 then
	val = i+1
	ipc.sleep(10)
	end

	ipc.writeLvar(LVarSet, val)

end


function A2A_MAP_VORNDB_toggle ()


	LVarSet = "LayerNDBs"
	LVarSet2 = "LayerVORs"

	i = ipc.readLvar(LVarSet)
	i2 = ipc.readLvar(LVarSet2)
	val = 0
	val2 = 0
	if i <= 2 then
	val = i+1
	ipc.sleep(10)
	end
	if i2 <= 2 then
	val2 = i2+1
	ipc.sleep(10)
	end

	ipc.writeLvar(LVarSet, val)
	ipc.writeLvar(LVarSet2, val2)

end



function A2A_MAP_LowAWY_toggle ()

	LVarSet = "LayerLowAirways"
	i = ipc.readLvar(LVarSet)
	val = 0
	if i <= 2 then
	val = i+1
	ipc.sleep(10)
	end

	ipc.writeLvar(LVarSet, val)
end


function A2A_MAP_HighAWY_toggle ()


	LVarSet = "LayerHighAirways"
	i = ipc.readLvar(LVarSet)
	val = 0
	if i <= 1 then
	val = i+1
	ipc.sleep(10)
	end

	ipc.writeLvar(LVarSet, val)

end

function A2A_MAP_ILS_toggle ()

	LVarSet = "LayerILSs"
	val = 0

   	if ipc.readLvar(LVarSet) == 0 then
   	val = 1
    	end

  	ipc.writeLvar(LVarSet, val)
end


function A2A_MAP_FIXes_toggle ()


	LVarSet = "LayerIntersections"
	i = ipc.readLvar(LVarSet)
	val = 0
	if i <= 1 then
	val = i+1
	ipc.sleep(10)
	end

	ipc.writeLvar(LVarSet, val)

end


function A2A_MAP_FPlan_toggle ()


	LVarSet = "LayerRoute"
	val = 0

   	if ipc.readLvar(LVarSet) == 0 then
   	val = 1
    	end

  	ipc.writeLvar(LVarSet, val)
	
end


_log("[LIB]  A2A MAP library loaded...")
