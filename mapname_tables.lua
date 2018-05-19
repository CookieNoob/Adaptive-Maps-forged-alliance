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



--SCALING OPTIONS
--exampleMexes = {{'c'},{'b'},{'a'}},       --exampleMexes = {{'a'}}
	--option key=1 (e=0): spawn a+b+c           --option key=1 (e=0): spawn a
	--option key=2 (e=1): spawn a+b, c off		  --option key=2 (e=1): a off
	--option key=3 (e=2): spawn a, b+c off
	--option key=4 (e=3): a+b+c off
	
--add core mexes (refers to spwnMexArmy)
coreMexes = {{}}

--add extra mexes
extraMexes = {{}}


--CRAZYRUSH OPTIONS
--determine forward crazy rush mexes
forwardCrazyrushMexes = {}

--only use these mexes/resources for crazy rush 1 mex (refers to spwnMexArmy)
crazyrushOneMexes = {}
