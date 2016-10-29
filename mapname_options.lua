options ={

{
	default = 1,
	label = "dynamic spawn of mexes",
	help = "Enable the mex spawn algorithm to adjust the map to the player count",
	key = 'automex',
	pref = 'automex',
	values = {
		{ text = "enabled", help = "map adjust automatically for the playercount", key = 1, },
		{ text = "disabled - 4v4 mex", help = "Map will not adjust for players and will spawn the mexes of the four usual players and their expansions. Use the spots 1-8", key = 2, },
		{ text = "disabled - all mex", help = "Map will not adjust for players and will spawn the all mexes", key = 3, },
		{ text = "enabled - crazyrush 1 mex", help = "Map will activate the crazyrush script and spawn 1 starting mex for all players.", key = 6, },
		{ text = "enabled - crazyrush", help = "Map will activate the crazyrush script.", key = 7, },
        
	},
},

{
	default = 1,
	label = "regrowing trees",
	help = "Regrow reclaimed trees slowly when there are still other trees around. If there are more trees close, the faster they regrow.",
	key = 'tree',
	pref = 'tree',
	values = {
		{ text = "disabled", help = "Dont regrow trees.", key = 1, },
		{ text = "enabled", help = "Regrow trees.", key = 2, },
	},
},

{
	default = 1,
	label = "dynamic spawn - mirror spots",
	help = "Only spawn ressources when mirror spots are taken",
	key = 'mirrormex',
	pref = 'mirrormex',
	values = {
		{ text = "disabled", help = "Spawn mex for players that dont have a mirror. The empty mirror spot will also spawn its mex.", key = 1, },
		{ text = "enabled", help = "Only spawn mex/hydro when opposing spot is also taken. This option is not recommended, however it can make uneven matches fairer.", key = 2, },

	},
},
--[[
{
	default = 1,
	label = "Civilian Base",
	help = "Spawn a civilian base in the middle.",
	key = 'optional_civilian_base',
	pref = 'optional_civilian_base',
	values = {
		{ text = "enabled - t1 defences", help = "Spawn the usual civilian base in the middle with some t1 point defences.", key = 2, },
		{ text = "enabled - something", help = "Spawns something xD dunno what exactly.", key = 3, },        
        { text = "disabled", help = "Spawn no civilians.", key = 1, },
    },
},


{
	default = 1,
	label = "additional hydros",
	help = "additional hydros on side hills",
	key = 'hydroplus',
	pref = 'hydroplus',
	values = {
		{ text = "disabled", help = "Only spawn a hydro for the air players.", key = 1, },
		{ text = "enabled", help = "Spawn a hydro for every player.", key = 2, },
	},
},

{
	default = 4,
	label = "additional middlemex",
	help = "additional middlemex",
	key = 'middlemex',
	pref = 'middlemex',
	values = {
		{ text = "enabled - more mex", help = "Spawn 6 additional mexes in the middle.", key = 1, },
		{ text = "enabled", help = "Spawn 4 additional mexes in the middle.", key = 2, },
		{ text = "enabled - less mex", help = "Spawn 2 additional mexes in the middle.", key = 3, },
        { text = "disabled", help = "Spawn no additional mexes in the middle.", key = 4, }
    },
},

{
	default = 3,
	label = "additional sidemex",
	help = "additional sidemex",
	key = 'sidemex',
	pref = 'sidemex',
	values = {
		{ text = "enabled - more mex", help = "Spawn 4 additional mexes on each side near the coast.", key = 1, },
		{ text = "enabled", help = "Spawn 2 additional mexes on each side near the coast.", key = 2, },
        { text = "disabled", help = "Spawn no additional mexes on the side.", key = 3, },
    },
},

{
	default = 4,
	label = "additional underwatermex",
	help = "additional sidemex in the water around the islands.",
	key = 'sidemex',
	pref = 'sidemex',
	values = {
		{ text = "enabled - much more mex", help = "Spawn 5 additional mexes in the water around the islands.", key = 1, },
		{ text = "enabled - more mex", help = "Spawn 4 additional mexes in the water around the islands.", key = 2, },
		{ text = "enabled", help = "Spawn 3 additional mexes in the water around the islands.", key = 3, },
		{ text = "enabled - fewer mex", help = "Spawn 2 additional mexes in the water around the islands.", key = 4, },
		{ text = "enabled - very few mex", help = "Spawn 1 additional mexes in the water around the islands.", key = 5, },
        { text = "disabled", help = "Spawn no additional mexes in the water around the islands.", key = 6, },
    },
},

{
	default = 2,
	label = "expand map area",
	help = "Determines how long the playable area is restricted to the middle area of the map. This option is takes only affect when no island spots or beach spots are taken (spots 7-12).",
	key = 'expandmap',
	pref = 'expandmap',
	values = {
		{ text = "no expansion", help = "Map stays restricted to the middle region.", key = 1, },
		{ text = "start expanded", help = "Map starts fully expanded.", key = 2, },
		{ text = "5 min", help = "Expansion after 5 minutes.", key = 3, },
		{ text = "10 min", help = "Expansion after 10 minutes.", key = 4, },
		{ text = "15 min", help = "Expansion after 5 minutes.", key = 5, },
		{ text = "20 min", help = "Expansion after 10 minutes.", key = 6, },
		{ text = "80 percent of mexes", help = "Expansion when 80 percent of the mexes are build.", key = 7, },
		{ text = "90 percent of mexes", help = "Expansion when 90 percent of the mexes are build.", key = 8, },
	},
},


{
	default = 1,
	label = "additional reclaim",
	help = "add groups of wrecks to the map",
	key = 'optional_reclaim',
	pref = 'optional_reclaim',
	values = {
		{ text = "no reclaim", help = "Do not add additional reclaim in the middle of the map", key = 1, },
		{ text = "some reclaim", help = "Add some frigates to the beaches of the map.", key = 2, },
		{ text = "more reclaim", help = "Add some destroyers to the map.", key = 3, },
		{ text = "destro+frigates", help = "Add some frigates and destroyers to the map.", key = 4, },
	},
},

{
	default = 1,
	label = "additional reclaim - side",
	help = "add wrecks to the side of the map",
	key = 'optional_reclaim_side',
	pref = 'optional_reclaim_side',
	values = {
		{ text = "no reclaim", help = "Do not add additional reclaim on the sides.", key = 1, },
		{ text = "battleship", help = "Add one battleship to the side cliff.", key = 2, },
	},
},
{
	default = 1,
	label = "additional reclaim - middle",
	help = "add wrecks to the middle of the map",
	key = 'optional_reclaim_middle',
	pref = 'optional_reclaim_middle',
	values = {
		{ text = "no reclaim", help = "Do not add additional reclaim on the sides.", key = 1, },
		{ text = "missileship", help = "Add a missileship to the middle of the map.", key = 2, },
	},
},
]]--

};