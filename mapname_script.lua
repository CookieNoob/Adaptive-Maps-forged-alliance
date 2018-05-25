------------------------------------------------------------------------
----- Script by CookieNoob and KeyBlue (modified by svenni_badbwoi)-----
------------------------------------------------------------------------
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local Tables = import('/maps/mapfolder/mapname_tables.lua')

--enter maximum possible player count
local maxPlayerOnMap = 16

--IMPORT: options.lua settings
--chosen key or default key
--resources
local dynamic_spawn = ScenarioInfo.Options.dynamic_spawn or 1
local crazyrush_mexes = ScenarioInfo.Options.crazyrush_mexes or 1
local extra_hydros = ScenarioInfo.Options.extra_hydros or 1
local extra_mexes = ScenarioInfo.Options.extra_mexes or 1
local middle_mexes = ScenarioInfo.Options.middle_mexes or 1
local side_mexes = ScenarioInfo.Options.side_mexes or 1
local underwater_mexes = ScenarioInfo.Options.underwater_mexes or 1
local island_mexes = ScenarioInfo.Options.island_mexes or 1
local expansion_mexes = ScenarioInfo.Options.expansion_mexes or 1
local core_mexes = ScenarioInfo.Options.core_mexes or 1
local extra_base_mexes = ScenarioInfo.Options.extra_base_mexes or 1
local top_side_mexes = ScenarioInfo.Options.top_side_mexes or 1
local bottom_side_mexes = ScenarioInfo.Options.bottom_side_mexes or 1
--units
local optional_wreckage = ScenarioInfo.Options.optional_wreckage or 1
local optional_naval_wreckage = ScenarioInfo.Options.optional_naval_wreckage or 1
local optional_wreckage_middle = ScenarioInfo.Options.optional_wreckage_middle or 1
local optional_adaptive_faction_wreckage = ScenarioInfo.Options.optional_adaptive_faction_wreckage or 1
local optional_civilian_base = ScenarioInfo.Options.optional_civilian_base or 1
local optional_civilian_defenses = ScenarioInfo.Options.optional_civilian_defenses or 1
local jamming = ScenarioInfo.Options.jamming or 1

--stuff for crazyrush script
local currentResSpot = 0
local generatedMass = {}
local checkedExtractor = {}
local MexList ={}

--stuff for expansion script
local spawnedMassSpots={}
local spawnedMexNumber = 0
local expand_map = ScenarioInfo.Options.expand_map or 1 --works with 1, but default/key = 2 in options

--stuff for tree script
local InitialListTrees = {}
local TreeRegrowSpeed = ScenarioInfo.Options.TreeRegrowSpeed or 1 --default = 5 leads to key = 1
math.randomseed(1)


------------------------------------------------------------------------
----- Initialization Part ----------------------------------------------
------------------------------------------------------------------------
--OnPopulate
function OnPopulate()
    LOG("ADAPTIVE: OnPopulate")
    ScenarioUtils.InitializeArmies();
    OptionalUnits();
end

--OnStart
function OnStart()
    LOG("ADAPTIVE: OnStart")
    
    --activate the map expansion code
    --ScenarioFramework.SetPlayableArea('AREA_4' , false)
    if(Expand_StartupCheck()) then
        ForkThread(Expand_MapExpandConditions)
    end
    
    --set color for civilians
    --SetArmyColor('ARMY_17',245,203,150)
    
    --can be used to notify about intentionally uneven mexes on the map, e.g. "Adaptive Wonder Open"
    ForkThread(showmessage)
    
    ForkThread(startCrazyrushLoop)
    
    ForkThread(startGrowingTreesLoop)
    
    ForkThread(gatherFeedback)
end

--Crazyrush
function startCrazyrushLoop()
    --wait to fix bug with civi mex wrecks activating crazyrush
    WaitSeconds(1)
    
    --activate forward_crazyrush_mexes
    if crazyrush_mexes == 2 then
        LOG("ADAPTIVE: activate Forward Crazyrush Mexes")
        ForkThread(Crazyrush_checkMassPoint, false)
        
    --activate crazyrush 1 mex
    elseif crazyrush_mexes == 3 then
        LOG("ADAPTIVE: activate Crazyrush 1 Mex")
        ForkThread(Crazyrush_checkMassPoint, true)
        
     --activate crazyrush
    elseif crazyrush_mexes == 4 then
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

--Startmessage
function gatherFeedback()
    WaitSeconds(10)
    BroadcastMSG('If you discover any map-related bugs, pls tell the map author. Thx.',  -- message
                 16,                                                             -- fontsize
                 'd0d0d0',                                                       -- color
                 5,                                                             -- duration
                 'center')                                                       -- position
end


------------------------------------------------------------------------
----- Optional Units (civilians, reclaim, jamming, ...) ----------------
------------------------------------------------------------------------
--call from OnPopulate to prevent despawning map-decal glitch (map-decal disappeared, when optional structures (probably due to decal) and a certain amount of unit footprint/track-decals were spawned)
function OptionalUnits()
    LOG("ADAPTIVE: Optional Units:")
    LOG("ADAPTIVE: optional_wreckage = ", optional_wreckage)
    LOG("ADAPTIVE: optional_naval_wreckage = ", optional_naval_wreckage)
    LOG("ADAPTIVE: optional_wreckage_middle = ", optional_wreckage_middle)
    LOG("ADAPTIVE: optional_adaptive_faction_wreckage = ", optional_adaptive_faction_wreckage)
    LOG("ADAPTIVE: optional_civilian_base = ", optional_civilian_base)
    LOG("ADAPTIVE: optional_civilian_defenses = ", optional_civilian_defenses)
    LOG("ADAPTIVE: jamming = ", jamming)

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
    
    --Middle Wreckage
    if optional_wreckage_middle > 1 then
        for midreclaim = 2, optional_wreckage_middle do
            ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Middle_'..midreclaim, true)
        end
    end
    
    --Adaptive Faction Wreckage
    if(optional_adaptive_faction_wreckage > 1) then
        AddFactionReclaimBack(optional_adaptive_faction_wreckage)
    end
    
    --Civilian Base (only)
    --spawn wreckage
    if(optional_civilian_base == 2) then
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Base_2', true)
    --spawn operational
    elseif(optional_civilian_base == 3) then
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Base_2', false)
    end
    
    --Civilian Defenses (only)    
    --spawn wreckage
    if(optional_civilian_defenses == 2) then
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_2', true)
    elseif(optional_civilian_defenses == 3) then
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_2', true)
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_3', true)
    elseif(optional_civilian_defenses == 4) then
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_2', true)
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_3', true)
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defenses_4', true)
    --spawn operational
    --needs to include radar, power and e-storage to work properly
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
    
--[[    --remove Civilian Base and Civilian Defenses if player spwans in civilian base
    if(optional_civilian_base > 1) then
        local spawncivs = true
        for m = 13, 14 do
            armystring = "ARMY_" .. m
            for _, army in ListArmies() do
                if( army == armystring) then
                    LOG("ADAPTIVE: found player in civilian base. remove civilians")
                    spawncivs = false
                end
            end
        end
        if(spawncivs) then
            ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Base', false)
            ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Civilian_Defences_'.. optional_civilian_base, false)
        end
    end]]
    
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
    LOG("ADAPTIVE: extra_hydros = ", extra_hydros)
    LOG("ADAPTIVE: extra_mexes = ", extra_mexes)
    LOG("ADAPTIVE: middle_mexes = ", middle_mexes)
    LOG("ADAPTIVE: side_mexes = ", side_mexes)
    LOG("ADAPTIVE: underwater_mexes = ", underwater_mexes)
    LOG("ADAPTIVE: island_mexes = ", island_mexes)
    LOG("ADAPTIVE: expansion_mexes = ", expansion_mexes)
    LOG("ADAPTIVE: core_mexes = ", core_mexes)
    LOG("ADAPTIVE: extra_base_mexes = ", extra_base_mexes)
    LOG("ADAPTIVE: top_side_mexes = ", top_side_mexes)
    LOG("ADAPTIVE: bottom_side_mexes = ", bottom_side_mexes)
    
    --get map markers
    local markers = ScenarioUtils.GetMarkers();

    --IMPORT: table.lua content (player bound resources + additional resources)
    --it is sorted in such a way that the first line corresponds to player one, the second to player 2 and so on...
    local spwnMexArmy = Tables.spwnMexArmy or {}
    local spwnHydroArmy = Tables.spwnHydroArmy or {}
    local extraHydros = Tables.extraHydros or {}
    local extraMexes = Tables.extraMexes or {}
    local middleMexes = Tables.middleMexes or {}
    local sideMexes = Tables.sideMexes or {}
    local underwaterMexes = Tables.underwaterMexes or {}
    local islandMexes = Tables.islandMexes or {}
    local expansionMexes = Tables.expansionMexes or {}
    local coreMexes = Tables.coreMexes or {}
    local extraBaseMexes = Tables.extraBaseMexes or {}
    local topSideMexes = Tables.topSideMexes or {}
    local bottomSideMexes = Tables.bottomSideMexes or {}
    local forwardCrazyrushMexes = Tables.forwardCrazyrushMexes or {}
    local crazyrushOneMexes = Tables.crazyrushOneMexes or {}

    --find out if there are spots that do not have a mirror
    --in that case store the pair in the list with false
    local numberOfNotPresentArmies = 1
    
    --check which army isnt there
    local Notpresentarmies = {}
    local ArmyList = ListArmies()
    
    --spawn mexes on closed spots if requested
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
        
    --no mirror = no resources
    elseif dynamic_spawn == 3 then
        for m = 1, (maxPlayerOnMap/2) do
            local army1 = (2*m - 1)
            local army2 = (2*m)
            local army1String = "ARMY_" .. army1
            local army2String = "ARMY_" .. army2

            local here = 0;
            for number, army in ArmyList do
                if( army == army1String or army == army2String ) then
                    here = here + 1;
                end
            end

            if here < 2 then
                Notpresentarmies[numberOfNotPresentArmies] = army1;
                numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
                Notpresentarmies[numberOfNotPresentArmies] = army2;
                numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
            end
        end
        
    --FIX SETUP FOR X PLAYER
    --2v2 setup armys 1 - 4 (remove 5 - maxPlayerOnMap)
    elseif(dynamic_spawn == 4) then
        for m = 5, maxPlayerOnMap do
            Notpresentarmies[numberOfNotPresentArmies] = m;
            numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
        end
        
    --4v4 setup, armys 1 - 8 (remove 9 - maxPlayerOnMap)
    elseif(dynamic_spawn == 5) then
        for m = 9, maxPlayerOnMap do
            Notpresentarmies[numberOfNotPresentArmies] = m;
            numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
        end
        
    --6v6 setup, army 1 - 12 (remove 13 - maxPlayerOnMap)
    elseif(dynamic_spawn == 6) then
        for m = 13, maxPlayerOnMap do
            Notpresentarmies[numberOfNotPresentArmies] = m;
            numberOfNotPresentArmies = numberOfNotPresentArmies + 1;
        end
        
    --8v8 setup, armies 1 - maxPlayerOnMap (remove none)
    elseif(dynamic_spawn == 7) then
        Notpresentarmies = {};
    end

    --SPAWN RESOURCES
    --(marker=Mex)
    for name, tblData in pairs(markers) do
    
        --only spawn resources (obviously)
        if (not tblData.resource) then
            doit = false;
        else
            -- standard resources, spawn it
            doit = true;
            
            --FalseIfInList = REMOVE/DONT SPAWN MARKER IN LIST
            --remove the spawn when a player is not present, loop over all not present armies and check if the marker for the current mex/hydro is corresponds to one of those in the list
            for _ ,armynumber in Notpresentarmies do
                --loop over all markers of mexes in the table of the row of the missing army
                doit=FalseIfInList(name, spwnMexArmy[armynumber], MassString, doit);
                doit=FalseIfInList(name, spwnHydroArmy[armynumber], HydroString, doit);
            end

            for e = extra_hydros, table.getn(extraHydros) do
                doit=FalseIfInList(name, extraHydros[e], HydroString, doit);
            end
            
            for e = extra_mexes, table.getn(extraMexes) do
                doit=FalseIfInList(name, extraMexes[e], MassString, doit);
            end
            
            for e = middle_mexes, table.getn(middleMexes) do
                doit=FalseIfInList(name, middleMexes[e], MassString, doit);
            end
            
            for e = side_mexes, table.getn(sideMexes) do
                doit=FalseIfInList(name, sideMexes[e], MassString, doit);
            end
            
            for e = underwater_mexes, table.getn(underwaterMexes) do
                doit=FalseIfInList(name, underwaterMexes[e], MassString, doit);
            end
            
            for e = island_mexes, table.getn(islandMexes) do
                doit=FalseIfInList(name, islandMexes[e], MassString, doit);
            end
            
            for e = expansion_mexes, table.getn(expansionMexes) do
                doit=FalseIfInList(name, expansionMexes[e], MassString, doit);
            end
            
            for e = core_mexes, table.getn(coreMexes) do
                doit=FalseIfInList(name, coreMexes[e], MassString, doit);
            end
            
            for e = extra_base_mexes, table.getn(extraBaseMexes) do
                doit=FalseIfInList(name, extraBaseMexes[e], MassString, doit)
            end
            
            for e = top_side_mexes, table.getn(topSideMexes) do
                doit=FalseIfInList(name, topSideMexes[e], MassString, doit)
            end
            
            for e = bottom_side_mexes, table.getn(bottomSideMexes) do
                doit=FalseIfInList(name, bottomSideMexes[e], MassString, doit)
            end
            
            --FalseIfNotInList = ONLY USE MARKER IN LIST
            --use only "crazyrushOneMexes"
            if crazyrush_mexes == 3 then
                doit = FalseIfNotInList(name, crazyrushOneMexes, MassString, doit);
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
    --check type of resource and set parameters
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
    
    --create the resource
    CreateResourceDeposit(restype, Position[1], Position[2], Position[3], size/2);
    
    --create the resource graphic on the map
    if spawnhpr then
        CreatePropHPR(bp, Position[1], Position[2], Position[3], Random(0,360), 0, 0);
    end
    --create the resource icon on the map
    CreateSplat(
        Position,                # Position
        0,                       # Heading (rotation)
        albedo,                  # Texture name for albedo
        size, size,              # SizeX/Z
        lod,                     # LOD
        0,                       # Duration (0 == does not expire)
        -1,                      # Army (-1 == not owned by any single army)
        0                        # Fidelity
    );
end


------------------------------------------------------------------------
----- Message part -----------------------------------------------------
------------------------------------------------------------------------
function showmessage()
    local message = ''
    local sendmessage = false

    if bottom_side_mexes != top_side_mexes then
        message = message .. 'There is a difference in the number of mexes between the bottom left corner and the top right corner.'

        for k = 1, 4 do
            local counter = 0
            for _, army in ListArmies() do
                --adjust these pairs! They are correct on wonder but maybe not on this map!
                if ((army == 'ARMY_'..(2+k) ) or (army == 'ARMY_'..(11-k))) then
                    counter = counter + 1
                end
            end
            if(counter == 1) then
                sendmessage = true
                break;
            end
--[[        if(IsAllied('ARMY_'.. (2+k), 'ARMY_'.. (11-k) )) then
                sendmessage = true
                break
            end ]]--
        end
        for k = 1, 2 do
            local counter = 0
            for _, army in ListArmies() do
                --adjust these pairs! They are correct on wonder but maybe not on this map!
                if ((army == 'ARMY_'..(11+2*k) ) or (army == 'ARMY_'..(18-2*k))) then
                    counter = counter + 1
                end
            end
            if(counter == 1) then
                sendmessage = true
                break;
            end
--[[        if(IsAllied('ARMY_'.. (11+2*k), 'ARMY_'.. (18-2*k) )) then
                sendmessage = true
                break
            end ]]--
        end
    end

    if(sendmessage) then
        WaitSeconds(7)
        BroadcastMSG(message, 20, 'ff0000', 15, 'center')
    end
--        local countDownDialog = SimDialogue.Create(LOC('There is a difference in the number of mexes between bot and top'), {'Ok'})
--        countDownDialog.OnButtonPressed = function(self, info)
--            countDownDialog:Destroy()
--        end

end

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
----- Expansion part ---------------------------------------------------
------------------------------------------------------------------------
-- Expansion script adapted from Primus_Alpha by Super, Ithilis_Quo and Speed2
function Expand_MapExpandConditions()
    if(expand_map < 7) then
        ScenarioFramework.CreateTimerTrigger(Expand_MapExpand, 60*5*(expand_map-2), true)
    end
    if(expand_map >= 7 ) then
        local MexToBuild = Expand_CountMexMarkersInArea('AREA_1') * 0.1* (expand_map + 1)
        while not ScenarioInfo.MapAlreadyExpanded do
            local curMexies = 0
            for _, brain in ArmyBrains do
                curMexies = curMexies + table.getn(ScenarioFramework.GetCatUnitsInArea(categories.MASSEXTRACTION, 'AREA_1', brain))
            end
            if curMexies > MexToBuild then
                if not ScenarioInfo.MapAlreadyExpanded then
                    Expand_MapExpand()
                end
                break
            end
            WaitSeconds(5)
        end
    end
end

function Expand_MapExpand()
    if ScenarioInfo.MapAlreadyExpanded == false then
        ScenarioInfo.MapAlreadyExpanded = true
        ScenarioFramework.SetPlayableArea('AREA_1' , false)
    end
end

function Expand_CountMexMarkersInArea(area)
    local rect = ScenarioUtils.AreaToRect(area)
    local mexNum = 0
    for markerName, markerTable in Scenario.MasterChain['_MASTERCHAIN_'].Markers do
        if markerTable.type =='Mass' then
            for m = 1, spawnedMexNumber do
                if markerName == spawnedMassSpots[m] then
                    if ScenarioUtils.InRect(markerTable.position, rect) then
                        mexNum = mexNum + 1
                    end
                end
            end
        end
    end
    return mexNum
end

function Expand_StartupCheck()
    --check if a player is outside of the starting area and expand the map in that case
    ScenarioInfo.MapAlreadyExpanded = false
    LOG("ADAPTIVE: Activate map expansion script. expand_map = ", expand_map)

    --[[for m = 13, 14 do
        armystring = "ARMY_" .. m
        for _, army in ListArmies() do
            if army == armystring then
                LOG("ADAPTIVE: found player outside of playable region. Expand map")
                Expand_MapExpand()
                return false
            end
        end
    end]]
    if expand_map == 1 then
        return false
    end
    if expand_map == 2 then
        Expand_MapExpand()
        return false
    end
    return true
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


------------------------------------------------------------------------
------Faction dependent reclaim-----------------------------------------
------------------------------------------------------------------------
function AddFactionReclaimBack(optional_adaptive_faction_wreckage)
    local SpawnReclaimArmy7 = false
    local SpawnReclaimArmy8 = false
    local armyTable = ListArmies()
    for _, army in armyTable do
        if( army == "ARMY_7") then
            if(GetArmyBrain(army):GetFactionIndex() == 1 or GetArmyBrain(army):GetFactionIndex() == 2) then
                SpawnReclaimArmy7 = true
                ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Top_UEF_2', true)
                if(optional_adaptive_faction_wreckage == 3) then
                    ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Top_UEF_3', true)
                end
            else
                SpawnReclaimArmy7 = true
                ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Top_Cybran_2', true)
                if(optional_adaptive_faction_wreckage == 3) then
                    ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Top_Cybran_3', true)
                end
            end
        end
        if( army == "ARMY_8") then
            if(GetArmyBrain(army):GetFactionIndex() == 1 or GetArmyBrain(army):GetFactionIndex() == 2) then
                SpawnReclaimArmy8 = true
                ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Bot_UEF_2', true)
                if(optional_adaptive_faction_wreckage == 3) then
                    ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Bot_UEF_3', true)
                end
            else
                SpawnReclaimArmy8 = true
                ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Bot_Cybran_2', true)
                if(optional_adaptive_faction_wreckage == 3) then
                    ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Bot_Cybran_3', true)
                end
            end
        end
    end
    if(SpawnReclaimArmy8 and not SpawnReclaimArmy7) then
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Top_Cybran_2', true)
        if(optional_adaptive_faction_wreckage == 3) then
            ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Top_Cybran_3', true)
        end
    elseif (not SpawnReclaimArmy8 and SpawnReclaimArmy7) then
        ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Bot_UEF_2', true)
        if(optional_adaptive_faction_wreckage == 3) then
            ScenarioUtils.CreateArmyGroup('ARMY_17', 'Optional_Wreckage_Back_Bot_UEF_3', true)
        end
    end
end
