------------------------------------------------------------------------
----- Script by CookieNoob and KeyBlue (modified by svenni_badbwoi)-----
------------------------------------------------------------------------
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local Tables = import('/maps/mapfolder/mapname_tables.lua')

--enter maximum possible player count
local maxPlayerOnMap = 16

--import options.lua settings: chosen key or default key
local dynamic_spawn = ScenarioInfo.Options.dynamic_spawn or 1
local crazyrush_mexes = ScenarioInfo.Options.crazyrush_mexes or 1
local core_mexes = ScenarioInfo.Options.core_mexes or 1
local extra_mexes = ScenarioInfo.Options.extra_mexes or 2
local optional_civilian_base = ScenarioInfo.Options.optional_civilian_base or 2
local optional_civilian_defenses = ScenarioInfo.Options.optional_civilian_defenses or 2
local optional_wreckage = ScenarioInfo.Options.optional_wreckage or 2
local optional_naval_wreckage = ScenarioInfo.Options.optional_naval_wreckage or 2
local jamming = ScenarioInfo.Options.jamming or 1

--stuff for crazyrush script
local currentResSpot = 0
local generatedMass = {}
local checkedExtractor = {}
local MexList ={}

--stuff for tree script
local InitialListTrees = {}
local TreeRegrowSpeed = ScenarioInfo.Options.TreeRegrowSpeed or 1
math.randomseed(1)

--stuff for expansion script
local spawnedMassSpots={}
local spawnedMexNumber = 0
local expandmap = ScenarioInfo.Options.expandmap or 1


------------------------------------------------------------------------
----- Initialization Part ----------------------------------------------
------------------------------------------------------------------------
--OnPopulate
function OnPopulate()
	LOG("ADAPTIVE: OnPopulate")
	ScenarioUtils.InitializeArmies();
	OptionalUnits();
end

--Crazyrush
function startCrazyrushLoop()
	--wait to fix bug with civilian mex wrecks activating crazyrush
	WaitSeconds(1)
	
	--activate forward_crazyrush_mexes
	if crazyrush_mexes == 2  then
		LOG("ADAPTIVE: activate Forward Crazyrush Mexes")
		ForkThread(Crazyrush_checkMassPoint, false)
		
	--activate crazyrush 1 mex
	elseif crazyrush_mexes == 3  then
		LOG("ADAPTIVE: activate Crazyrush 1 Mex")
		ForkThread(Crazyrush_checkMassPoint, true)
		
	 --activate crazyrush
	elseif crazyrush_mexes == 4  then
		LOG("ADAPTIVE: activate Crazyrush")
		ForkThread(Crazyrush_checkMassPoint, true)
	end
end

--Regrowing Trees
function startGrowingTreesLoop()

	--activate fast regrowing trees
	if TreeRegrowSpeed == 2 then
		LOG("ADAPTIVE: activate fast regrowing Trees")
		ForkThread(Tree_StartGrowingTrees)
		
	--activate regrowing trees
	elseif TreeRegrowSpeed == 3 then
		LOG("ADAPTIVE: activate regrowing Trees")
		ForkThread(Tree_StartGrowingTrees)
		
	--activate slow regrowing trees
	elseif TreeRegrowSpeed == 4 then
		LOG("ADAPTIVE: activate slow regrowing Trees")
		ForkThread(Tree_StartGrowingTrees)
	end
end

--OnStart
function OnStart()
	LOG("ADAPTIVE: OnStart")
	
	--SetArmyColor('ARMY_17',245,203,150)
	
	startGrowingTreesLoop()
	
	ForkThread(startCrazyrushLoop)
	
	ForkThread(gatherFeedback)
end

--Startmessage
function gatherFeedback()
	WaitSeconds(10)
	LOG("ADAPTIVE: gatherFeedback")
	BroadcastMSG(
		'If you see any bugs with the map, plz tell CookieNoob. Thx.',	-- message
		16,								-- fontsize
		'd0d0d0',							-- color
		5,								-- duration
		'center')							-- position
end


------------------------------------------------------------------------
----- Optional Units (civilians, reclaim, jamming, ...) ----------------
------------------------------------------------------------------------
--call from OnPopulate to prevent despawning map-decal glitch (map-decal disappeared, when optional structures (probably due to attached decal) and a certain amount of unit footprint/track-decals were spawned)
function OptionalUnits()
	LOG("ADAPTIVE: Optional Units:")
	LOG("ADAPTIVE: optional_civilian_base = ", optional_civilian_base)
	LOG("ADAPTIVE: optional_civilian_defenses = ", optional_civilian_defenses)
	LOG("ADAPTIVE: optional_wreckage = ", optional_wreckage)
	LOG("ADAPTIVE: optional_naval_wreckage = ", optional_naval_wreckage)
	LOG("ADAPTIVE: jamming = ", jamming)

	--civilian base
	if(optional_civilian_base == 2) then
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Base_2', true)
	elseif(optional_civilian_base == 3) then
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Base_2', false)
	end
	
	-- civilian defenses
	if(optional_civilian_defenses == 2) then
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_2', true)
	elseif(optional_civilian_defenses == 3) then
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_2', true)
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_3', true)
	elseif(optional_civilian_defenses == 4) then
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_2', true)
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_3', true)
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_4', true)
	elseif(optional_civilian_defenses == 5) then
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_2', false)
	elseif(optional_civilian_defenses == 6) then
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_2', false)
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_3', false)
	elseif(optional_civilian_defenses == 7) then
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_2', false)
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_3', false)
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_4', false)
	end
	
	--Land Wreckage
	if optional_wreckage > 1 then
		for w = 2, optional_wreckage do
			ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_' .. w, true)
		end
	end
	
	--Naval Wreckage
	if optional_naval_wreckage > 1 then
		for n = 2, optional_naval_wreckage do
			ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Naval_'..n, true)
		end
	end
	
	--Jamming
	if jamming == 2 then
		ScenarioUtils.CreateArmyGroup('ARMY_17', 'Jamming', false)
	end
end


------------------------------------------------------------------------
----- Create Resources -------------------------------------------------
------------------------------------------------------------------------
function ScenarioUtils.CreateResources()
	LOG("ADAPTIVE: Create Resources:")
	LOG("ADAPTIVE: dynamic_spawn = ", dynamic_spawn)
	LOG("ADAPTIVE: crazyrush_mexes = ", crazyrush_mexes)
	LOG("ADAPTIVE: core_mexes = ", core_mexes)
	LOG("ADAPTIVE: extra_mexes = ", extra_mexes)
	
	-- get map markers
	local markers = ScenarioUtils.GetMarkers();
	
	-- import table.lua content: player bound resources + additional options ...
	-- it is sorted in such a way that the first line corresponds to player one, the second to player 2 and so on...
	local spwnMexArmy = Tables.spwnMexArmy or {}
	local spwnHydroArmy = Tables.spwnHydroArmy or {}
	local coreMexes = Tables.coreMexes or {}
	local extraMexes = Tables.extraMexes or {}
	local crazyrushOneMexes = Tables.crazyrushOneMexes or {}
	local forwardCrazyrushMexes = Tables.forwardCrazyrushMexes or {}
	
	-- find out if there are spots that do not have a mirror
	-- in that case store the pair in the list with false
	local numberOfNotPresentArmies = 1
	
	-- check which army isnt there
	local Notpresentarmies = {}
	local ArmyList = ListArmies()
	
	-- spawn mexes on closed spots if requested
	for j, spawnmex in ScenarioInfo.Options.SpawnMex or {} do
		if spawnmex then
			ArmyList[table.getn(ArmyList) + 1] = 'ARMY_' .. j
		end
	end
	
	--DYNAMIC SPAWN OF RESOURCES
	--mirror slots
	if dynamic_spawn == 1 then
		for m = 1, (maxPlayerOnMap/2) do
			local army1 = (2*m - 1)
			local army2 = (2*m)
			local army1String = "ARMY_" .. army1
			local army2String = "ARMY_" .. army2
			
			--compare 2 armys and find mirrored armys
			local found_Army1 = false
			local found_Army2 = false
			for number, army in ArmyList do
				if army == army1String then
					found_Army1 = true
				elseif army == army2String then
					found_Army2 = true
				end
			end
			if found_Army1 == false and found_Army2 == false then
				Notpresentarmies[numberOfNotPresentArmies] = army1;
				numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
				Notpresentarmies[numberOfNotPresentArmies] = army2;
				numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
			end
		end
		
	--used slot
	elseif dynamic_spawn == 2 then
		for armyIndex = 1, maxPlayerOnMap do
			local armyStringA = "ARMY_" .. armyIndex
			local foundArmyOnTheField = false
			for _, armyStringB in ArmyList do
				if( armyStringA == armyStringB ) then
					foundArmyOnTheField = true
					break
				end
			end
			if ( not foundArmyOnTheField ) then
				Notpresentarmies[numberOfNotPresentArmies] = armyIndex;
				numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
			end
		end
		
	--FIX SETUP FOR X PLAYER
	--2v2 setup - armys 1-4 (remove 5-16)
	elseif(dynamic_spawn == 3) then
		for m = 5, 16 do
			Notpresentarmies[numberOfNotPresentArmies] = m;
			numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
		end
		
	--4v4 setup - armys 1-8 (remove 9-16)
	elseif(dynamic_spawn == 4) then
		for m = 9,16 do
			Notpresentarmies[numberOfNotPresentArmies] = m;
			numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
		end
		
	--6v6 setup - army 1-12 (remove 13-16)
	elseif(dynamic_spawn == 5) then
		for m = 13, 16 do
			Notpresentarmies[numberOfNotPresentArmies] = m;
			numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
		end
		
	--8v8 setup - all armies (remove none)
	elseif(dynamic_spawn == 6) then
		Notpresentarmies = {};
	end
	
	--SPAWN RESOURCES
	--(marker=Mex)
	for name, tblData in pairs(markers) do
	
		-- only spawn resources (obviously)
		if (not tblData.resource) then
			doit = false;
		else
			-- standard resources, spawn it
			doit = true;
			
			--FalseIfInList = REMOVE/DONT SPAWN MARKER IN LIST
			-- remove the spawn when a player is not present, loop over all not present armies and check if the marker for the current mex/hydro is corresponds to one of those in the list
			for _ ,armynumber in Notpresentarmies do
				-- loop over all markers of mexes in the table of the row of the missing army
				doit=FalseIfInList(name, spwnMexArmy[armynumber], MassString, doit);
				doit=FalseIfInList(name, spwnHydroArmy[armynumber], HydroString, doit);
			end
			
			--remove "coreMexes"
			for e = 1, core_mexes - 1  do
				doit=FalseIfInList(name, coreMexes[e], MassString, doit);
				--LOG("ADAPTIVE: removing coreMexes")
			end
			
			--remove "extraMexes"
			for e = 1, extra_mexes - 1  do
				doit=FalseIfInList(name, extraMexes[e], MassString, doit);
				--LOG("ADAPTIVE: removing extraMexes")
			end
			
			--FalseIfNotInList = ONLY USE MARKER IN LIST
			--use only "crazyrushOneMexes"
			if crazyrush_mexes == 3 then
				doit = FalseIfNotInList(name, crazyrushOneMexes, MassString, doit);
				--LOG("ADAPTIVE: only crazyrushOneMexes")
			end
		end
		
		if (doit) then
			if(tblData.type == 'Mass') then
				spawnedMexNumber = spawnedMexNumber + 1
				spawnedMassSpots[spawnedMexNumber] = name
			end
			
			--enable 'forwardCrazyrushMexes'
			if crazyrush_mexes == 2 and FalseIfNotInList(name, forwardCrazyrushMexes, MassString, true) then
				spawnresource(tblData.position,tblData.type, false)
			else
				spawnresource(tblData.position,tblData.type, true)
			end
		end
	end
end

function MassString(_mexname)
	if type(_mexname) == 'string' then
		return "Mass " .. _mexname;
	end
	
	if(_mexname > 9) then
		return "Mass " .. _mexname;
	else
		return "Mass 0" .. _mexname;
	end
end

function HydroString(_hydroname)
	if type(_hydroname) == 'string' then
		return "Hydrocarbon " .. _hydroname;
	end
	
	if(_hydroname > 9) then
		return "Hydrocarbon " .. _hydroname;
	else
		return "Hydrocarbon 0" .. _hydroname;
	end
end

function FalseIfInList(name,list, string_function, _doit)
	for k = 1, table.getn(list) do
		if(name == (string_function(list[k]))) then
			return false
		end
	end
	return _doit;
end

function FalseIfNotInList(name, list, string_function, _doit)
	for k = 1, table.getn(list) do
		if(name == (string_function(list[k]))) then
			return _doit
		end
	end
	return false
end

function spawnresource(Position,restype, spawnhpr)
	-- check type of resource and set parameters
	local bp, albedo, size, lod;
	if restype == "Mass" then
		albedo = "/env/common/splats/mass_marker.dds";
		bp = "/env/common/props/massDeposit01_prop.bp";
		size = 2;
		lod = 100;
	else
		albedo = "/env/common/splats/hydrocarbon_marker.dds";
		bp = "/env/common/props/hydrocarbonDeposit01_prop.bp";
		size = 6;
		lod = 200;
	end
	
	-- create the resource
	CreateResourceDeposit(restype,	Position[1], Position[2], Position[3], size/2);
	
	-- create the resource graphic on the map
	if spawnhpr then
		CreatePropHPR(bp, Position[1], Position[2], Position[3], Random(0,360), 0, 0);
	end
	-- create the resource icon on the map
	CreateSplat(
		Position,				# Position
		0,					# Heading (rotation)
		albedo,					# Texture name for albedo
		size, size,				# SizeX/Z
		lod,					# LOD
		0,					# Duration (0 == does not expire)
		-1,					# army (-1 == not owned by any single army)
		0					# ???
	);
end


------------------------------------------------------------------------
----- Message part -----------------------------------------------------
------------------------------------------------------------------------
function BroadcastMSG(message, fontsize, RGBColor, duration, location)
----------------------------------------
-- broadcast a text message to players
-- possible locations = lefttop, leftcenter, leftbottom,  righttop, rightcenter, rightbottom, rightbottom, centertop, center, centerbottom
----------------------------------------
	PrintText(message, fontsize, 'ff' .. RGBColor, duration , location) ;
end


------------------------------------------------------------------------
----- Crazyrush part ---------------------------------------------------
------------------------------------------------------------------------
function Crazyrush_checkMassPoint(AllOrList)
	if(AllOrList) then
		while(true)do
			local units = GetUnitsInRect({x0 = 0, x1 = ScenarioInfo.size[1], y0 = 0, y1 = ScenarioInfo.size[2]})
			if(units~=nil)then
				for i,unit in units do
					if(EntityCategoryContains(categories.MASSEXTRACTION,unit))then
						posx = unit:GetPosition()[1]
						posy = unit:GetPosition()[3]
						if(not Crazyrush_alreadyCheckedExtractor(posx, posy))then
							Crazyrush_GenerateResourcesMarker(posx - 2, posy)
							Crazyrush_GenerateResourcesMarker(posx + 2, posy)
							Crazyrush_GenerateResourcesMarker(posx, posy - 2)
							Crazyrush_GenerateResourcesMarker(posx, posy + 2)
							WaitSeconds( 0.001 )
						end
					end
				end
			end
			WaitSeconds( 1 )
		end
	else
		local forwardCrazyrushMexes = Tables.forwardCrazyrushMexes or {}
		if(table.getn(forwardCrazyrushMexes)== 0) then
			return 0
		else
			for marker,markerpointer in pairs(ScenarioUtils.GetMarkers()) do
				if FalseIfNotInList(marker, forwardCrazyrushMexes, MassString, true) then
					MexList[table.getn(MexList) + 1]= {markerpointer.position[1], markerpointer.position[3]}
					CreatePropHPR('/env/common/props/hydrocarbonDeposit01_prop.bp', markerpointer.position[1],
								  GetTerrainHeight(markerpointer.position[1], markerpointer.position[3]),
								  markerpointer.position[3], Random(0,360), 0, 0)
				end
			end
			while(true) do
				for _, marker in MexList do
					local units = GetUnitsInRect({x0 = marker[1] - 0.2, x1 = marker[1] + 0.2, y0 = marker[2] - 0.2, y1 = marker[2] + 0.2}) or {}
					for _,unit in units or {} do
						if EntityCategoryContains(categories.MASSEXTRACTION, unit) then
							posx = unit:GetPosition()[1]
							posy = unit:GetPosition()[3]
							if(posx == marker[1] and posy == marker[2] ) then
								if(not Crazyrush_alreadyCheckedExtractor(posx, posy))then
									Crazyrush_GenerateResourcesMarker(posx - 2, posy)
									Crazyrush_GenerateResourcesMarker(posx + 2, posy)
									Crazyrush_GenerateResourcesMarker(posx, posy - 2)
									Crazyrush_GenerateResourcesMarker(posx, posy + 2)
									WaitSeconds( 0.001 )
								end
							end
						end
					end
				end
				WaitSeconds( 1 )
			end
		end
	end
end

function Crazyrush_alreadyCheckedExtractor(x,y)
	local foundIt = false
	if(checkedExtractor[x]==nil)then
		checkedExtractor[x]={}
		checkedExtractor[x][y] = true
	else
		if(checkedExtractor[x][y]==nil)then
			checkedExtractor[x][y] = true
		else
			foundIt = true
		end
	end
	return foundIt
end

function Crazyrush_GenerateResourcesMarker(x, y)
	local foundIt = false
	if(generatedMass[x]==nil)then
		generatedMass[x]={}
		generatedMass[x][y] = true
	else
		if(generatedMass[x][y]==nil)then
			generatedMass[x][y] = true
		else
			foundIt = true
		end
	end
	
	if(not foundIt)then
		tmptable = {x, y}
		table.insert(generatedMass, tmptable)
		marker =
		{
			['Mass '..(300 + currentResSpot)] =
			{
				['type'] = STRING( 'Mass' ),
				['position'] = VECTOR3( x, GetTerrainHeight(x,y), y ),
				['orientation'] = VECTOR3( 0.00, 0.00, 0.00 ),
				['size'] = FLOAT( 1.00 ),
				['resource'] = BOOLEAN( true ),
				['amount'] = FLOAT( 100.00 ),
				['color'] = STRING( 'ff808080' ),
				['editorIcon'] = STRING( '/textures/editor/marker_mass.bmp' ),
				['prop'] = STRING( '/env/common/props/markers/M_Mass_prop.bp' ),
			},
		}
		currentResSpot = currentResSpot + 1
		Crazyrush_CreateResources(marker)
		MexList[table.getn(MexList)+1] = tmptable
	end
end

function Crazyrush_CreateResources(markers)
	--local markers = GetMarkers()
	for i, tblData in pairs(markers) do
		if tblData.resource then
			spawnresource(tblData.position, tblData.type, true)
		end
	end
end


------------------------------------------------------------------------
----- Respawning trees--------------------------------------------------
------------------------------------------------------------------------
function Tree_StartGrowingTrees()
	local SQRTnumberofareas = 1
	if(ScenarioInfo.size[1]>300) then
		SQRTnumberofareas = 4
	elseif(ScenarioInfo.size[1]>600) then
		SQRTnumberofareas = 8
	elseif(ScenarioInfo.size[1]>1200) then
		SQRTnumberofareas = 16
	end
	local m = 0
	local firstIndex = 1
	for i = 0, SQRTnumberofareas - 1 do
		for j = 0, SQRTnumberofareas - 1 do
			m = m + 1
			local Tree_Area = {
				["x0"] = ScenarioInfo.size[1]/SQRTnumberofareas*i,
				["y0"] = ScenarioInfo.size[2]/SQRTnumberofareas*j,
				["x1"] = ScenarioInfo.size[1]/SQRTnumberofareas*(i+1),
				["y1"] = ScenarioInfo.size[2]/SQRTnumberofareas*(j+1),
			}
			local numberTreeInArea = Tree_InitializeTrees(Tree_Area, InitialListTrees, firstIndex)
			if(numberTreeInArea > 0) then
				ForkThread(Tree_RegrowTrees, InitialListTrees, m, firstIndex, firstIndex + numberTreeInArea - 1)
				firstIndex = firstIndex + numberTreeInArea
			end
		end
	end
	LOG("ADAPTIVE: Tree script finished initialization, total number of trees = ", firstIndex)
end

function Tree_InitializeTrees(area, list, firstIndex)
	local i = firstIndex
	for _, r in GetReclaimablesInRect(area) or {} do
		if (string.find(r:GetBlueprint().BlueprintId, "tree" )) then
			local storethetree = {  r:GetBlueprint().BlueprintId,
									r:GetPosition()['x'],
									r:GetPosition()['y'],
									r:GetPosition()['z']
								 }
			list[i] = storethetree
			i = i + 1
		end
	end
	LOG("ADAPTIVE: Trees initialized, number in this area = ", i - firstIndex)
	return i - firstIndex
end

function Tree_RegrowTrees(listoftrees, m, firstIndex, lastIndex)
	WaitSeconds(m + 10)
	while( true ) do
		Tree_NextCycle(listoftrees, firstIndex, lastIndex)
	end
end

function Tree_NextCycle(listoftrees, firstIndex, lastIndex)
	local numberToRespawn = 0
	local RespawnOnNextCycle = {}
	local MissingTrees = false
	for i = firstIndex, lastIndex do
		local respawnprop = Tree_CheckIfReclaimed(listoftrees[i])
		if(respawnprop > 0) then
			MissingTrees = true
			if(math.random() < respawnprop/30/TreeRegrowSpeed) then
				numberToRespawn = numberToRespawn + 1
				RespawnOnNextCycle[numberToRespawn] = i
			end
		end
	end
	WaitSeconds(30)
	if(not MissingTrees) then
		WaitSeconds(110/TreeRegrowSpeed)
	end
	for i, _ in RespawnOnNextCycle or {} do
		CreateProp( VECTOR3( listoftrees[RespawnOnNextCycle[i]][2],
							 listoftrees[RespawnOnNextCycle[i]][3],
							 listoftrees[RespawnOnNextCycle[i]][4] ),
					listoftrees[RespawnOnNextCycle[i]][1])
	end
end

function Tree_CheckIfReclaimed(tree)
	local NumberOfCloseTrees = 0
	
	local area1 = {
		["x0"] = tree[2] - 0.05,
		["y0"] = tree[4] - 0.05,
		["x1"] = tree[2] + 0.05,
		["y1"] = tree[4] + 0.05,
	}
	for _, t in GetReclaimablesInRect(area1) or {} do
		if(string.find(t:GetBlueprint().BlueprintId, "tree" )) then
			if(tree[2] == t:GetPosition()['x']) then
				if(tree[4] == t:GetPosition()['z']) then
					if(tree[1] == t:GetBlueprint().BlueprintId) then
						return  - 1
					end
				end
			end
		end
	end
	
	local area2 = {
		["x0"] = tree[2] - 1.5,
		["y0"] = tree[4] - 1.5,
		["x1"] = tree[2] + 1.5,
		["y1"] = tree[4] + 1.5,
	}
	for _, t in GetReclaimablesInRect(area2) or {} do
		if(string.find(t:GetBlueprint().BlueprintId, "tree" )) then
			NumberOfCloseTrees = NumberOfCloseTrees + 1
		end
		if(NumberOfCloseTrees > 20) then
			return - 1
		end
	end
	if NumberOfCloseTrees > 10 then
		return 20- NumberOfCloseTrees
	else
		return NumberOfCloseTrees
	end
end
