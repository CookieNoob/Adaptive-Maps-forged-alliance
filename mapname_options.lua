options ={

{
	default = 1,
	label = "Dynamic Spawn Of Resources",
	help = "Determine which mexes & hydros should be spawned.",
	key = 'dynamic_spawn',
	pref = 'dynamic_spawn',
	values = {
		{ text = "mirror slots", help = "Spawn resources for player & mirror slot.", key = 1, },
		{ text = "used slots", help = "Spawn resources for player on used slots.", key = 2, },
		{ text = "2v2 setup", help = "Don't adjust for player & spawn resources for 2v2.", key = 3, },
		{ text = "4v4 setup", help = "Don't adjust for player & spawn resources for 4v4.", key = 4, },
		{ text = "6v6 setup", help = "Don't adjust for player & spawn resources for 6v6.", key = 5, },
		{ text = "8v8 setup", help = "Don't adjust for player & spawn resources for maximum player count.", key = 6, },
	},
},

{
	default = 1,
	label = "Crazyrush",
	help = "Activate different types of crazyrush* for the spawned mexes. *Building a mex on a mass point will always create new adjacent mass points to build on.",
	key = 'crazyrush_mexes',
	pref = 'crazyrush_mexes',
	values = {
		{ text = "disabled", help = "No crazyrush.", key = 1, },
		{ text = "crazyrush forward mexes", help = "Activate crazyrush only for the center mexes. All other mexes will behave normally.", key = 2, },
		{ text = "crazyrush 1 core mex", help = "Activate crazyrush & spawn only 1 core mex per active slot.", key = 3, },
		{ text = "crazyrush", help = "Activate crazyrush for all spawned mexes.", key = 4, },
	},
},

{
	default = 1,
	label = "Number Of Core Mexes",
	help = "Spawn 3 or 4 core mexes.",
	key = 'core_mexes',
	pref = 'core_mexes',
	values = {
		--maximum on top because of despawn order
		{ text = "4", help = "Spawn 4 core mexes.", key = 1, },
		{ text = "3", help = "Spawn 3 core mexes.", key = 2, },
	},
},

{
	default = 2,
	label = "Extra Mexes",
	help = "Spawn additional mexes.",
	key = 'extra_mexes',
	pref = 'extra_mexes',
	values = {
		--maximum on top because of despawn order
		{ text = "X", help = "Add X extra mexes.", key = 1, },
		{ text = "0", help = "No extra mexes.", key = 2, },
	},
},

{
	default = 2,
	label = "Civilian Base",
	help = "Spawn civilian base in the middle of the map.",
	key = 'optional_civilian_base',
	pref = 'optional_civilian_base',
	values = {
		{ text = "disabled", help = "No civilian base.", key = 1, },
		{ text = "wreckage", help = "Spawn civilian base wreckage.", key = 2, },
		{ text = "operational", help = "Spawn operational civilian base.", key = 3, },
	},
},

{
	default = 2,
	label = "Civilian Defenses",
	help = "Spawn civilian defenses at the middle.",
	key = 'optional_civilian_defenses',
	pref = 'optional_civilian_defenses',
	values = {
		{ text = "disabled", help = "No civilian defenses.", key = 1, },
		{ text = "T1 wrecks (PD+AA)", help = "Spawn civilian T1 PD & AA wrecks. Includes T1 Radar, T1 Power Generator & Energy Storage.", key = 2, },
		{ text = "T2 wrecks (PD+TMD)", help = "Spawn civilian T2 PD & TMD wrecks in addition to T1.", key = 3, },
		{ text = "T3 wrecks (PD+AA)", help = "Spawn civilian T3 PD & AA wrecks in addition to T1 & T2.", key = 4, },
		{ text = "T1 operational (PD+AA)", help = "Spawn operational civilian T1 PD & AA. Includes T1 Radar, T1 Power Generator & Energy Storage.", key = 5, },
		{ text = "T2 operational (PD+TMD)", help = "Spawn operational civilian T2 PD & TMD in addition to T1.", key = 6, },
		{ text = "T3 operational (PD+AA)", help = "Spawn operational civilian T3 PD & AA in addition to T1 & T2.", key = 7, },
	},
},

{
	default = 2,
	label = "Wreckage",
	help = "Scale amount of unit wrecks.",
	key = 'optional_wreckage',
	pref = 'optional_wreckage',
	values = {
		{ text = "disabled", help = "No land/air wrecks.", key = 1, },
		{ text = "T1 wrecks", help = "Add T1 wrecks.", key = 2, },
		{ text = "T2 wrecks", help = "Add T2 wrecks to T1.", key = 3, },
		{ text = "T3 wrecks", help = "Add T3 wrecks to T1 & T2.", key = 4, },
		{ text = "T4 wreck", help = "Add Ythotha wreck to T1, T2 & T3.", key = 5, },
	},
},

{
	default = 2,
	label = "Naval Wreckage",
	help = "Scale amount of naval unit wrecks.",
	key = 'optional_naval_wreckage',
	pref = 'optional_naval_wreckage',
	values = {
		{ text = "disabled", help = "No naval wrecks.", key = 1, },
		{ text = "T1 wrecks", help = "Add 8 T1 Frigate wrecks.", key = 2, },
		{ text = "T2 wrecks", help = "Add 8 T2 Destroyer wrecks to T1.", key = 3, },
		{ text = "T3 wrecks", help = "Add 2 T3 Battleship wrecks to T1 & T2.", key = 4, },
	},
},

{
	default = 5,
	label = "Natural Reclaim Values",
	help = "Change mass & energy values of rock & tree props.",
	key = 'naturalReclaimModifier',
	pref = 'naturalReclaimModifier',
	--not defined via adaptive script, just determine value via key
	values = {
		{ text = "300 percent", help = "Mass & energy values are 3 times higher.", key = 3, },
		{ text = "200 percent", help = "Mass & energy values are 2 times higher.", key = 2, },
		{ text = "150 percent", help = "Mass & energy values are 1.5 times higher.", key = 1.5, },
		{ text = "125 percent", help = "Mass & energy values are 1.25 times higher.", key = 1.25, },
		{ text = "100 percent", help = "Don't change the mass & energy values.", key = 1, },
		{ text = "75 percent", help = "Mass & energy values are 0.75 times lower.", key = 0.75, },
		{ text = "50 percent", help = "Mass & energy values are 0.5 times lower.", key = 0.5, },
		{ text = "25 percent", help = "Mass & energy values are 0.25 times lower.", key = 0.25, },
		{ text = "0 percent", help = "Remove Mass & energy values from rock & tree props.", key = 0, },
	},
},

{
	default = 1,
	label = "Regrowing Trees",
	help = "Regrow reclaimed/destroyed trees when other trees are nearby. Regrow is faster if more trees are close.",
	key = 'TreeRegrowSpeed',
	pref = 'TreeRegrowSpeed',
	values = {
		{ text = "disabled", help = "No regrowing trees.", key = 1, },
		{ text = "fast", help = "Regrow trees faster.", key = 2, },
		{ text = "enabled", help = "Regrow trees.", key = 3, },
		{ text = "slow", help = "Regrow trees slower.", key = 4, },
	},
},

{
	default = 1,
	label = "Jamming",
	help = "Add Seraphim jamming crystal to map center, to create false radar signals.",
	key = 'jamming',
	pref = 'jamming',
	values = {
		{ text = "disabled", help = "No jamming.", key = 1, },
		{ text = "enabled", help = "Add a jamming crystal.", key = 2, },
	},
},
};
