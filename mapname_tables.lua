-- table of which ressources belong to which player, it is sorted in such a way that the first line 
-- corresponds to player one, the second to player 2 and so on...







-- line number is 10 + armyumber for the mexes in the table
spwnMexArmy = {     {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {}}



-- line number is 30 + armyumber for the hydros in the table
spwnHydroArmy ={    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {},
                    {}}



-- GENERAL SCALING OPTIONS
-- exampleMexes = {{5,6},{3,4},{1,2}},        -- exampleMexes = {{'1,2'}}
-- exampleMexes = {{'c'},{'b'},{'a'}},        -- exampleMexes = {{'a'}}
    -- option key=1 (e=0): spawn a+b+c            -- option key=1 (e=0): spawn a
    -- option key=2 (e=1): spawn a+b, c off        -- option key=2 (e=1): a off
    -- option key=3 (e=2): spawn a, b+c off
    -- option key=4 (e=3): a+b+c off

-- add hydros to the map
additionalHydros = {{}}

-- add extra mexes to the map
extraMexes = {{}}

-- add mexes to certain map positions
middleMexes = {{},{}}
sideMexes = {{},{}}
underwaterMexes = {{},{}}
islandMexes ={{},{}}

-- STARTING BASE OPTIONS (refers to spwnMexArmy)
-- add core mexes 
coreMexes = {{}}

-- add mexes to starting base (further away from coreMexes)
baseMexes = {{}}

-- configure the amount of mexes on the expansion of the air player
expansionMexes = {{},{}}



-- CRAZYRUSH OPTIONS
-- determine forward crazy rush mexes
forwardCrazyrushMexes = {}

-- only use these mexes/resources (refers to spwnMexArmy)
crazyrushOneMexes = {}
