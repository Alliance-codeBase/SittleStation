#define TRAITOR_POPULATION_EXTREME_LOWPOP 10
//uplink_items time access override

// dangerous
/datum/uplink_item/dangerous/doublesword
	progression_minimum = 0 MINUTES


// device_tools
/datum/uplink_item/device_tools/hacked_module
	progression_minimum = 0 MINUTES

/datum/uplink_item/device_tools/singularity_beacon
	progression_minimum = 0 MINUTES

/datum/uplink_item/device_tools/powersink
	progression_minimum = 0 MINUTES


// explosive
/datum/uplink_item/explosives/syndicate_minibomb
	progression_minimum = 0 MINUTES

/datum/uplink_item/explosives/syndicate_bomb
	progression_minimum = 0 MINUTES

// job
/datum/uplink_item/role_restricted/clown_bomb
	progression_minimum = 0 MINUTES

/datum/uplink_item/role_restricted/spider_injector
	progression_minimum = 0 MINUTES

/datum/uplink_item/role_restricted/blastcannon
	progression_minimum = 0 MINUTES

/datum/uplink_item/role_restricted/reticence
	progression_minimum = 0 MINUTES


// stealthy
/datum/uplink_item/stealthy_weapons/martialarts
	progression_minimum = 0 MINUTES


// nukeops
/datum/uplink_item/stealthy_weapons/romerol_kit
	progression_minimum = 0 MINUTES


// stealthy_tools
/datum/uplink_item/stealthy_tools/telecomm_blackout
	progression_minimum = 0 MINUTES

/datum/uplink_item/stealthy_tools/blackout
	progression_minimum = 0 MINUTES

// population restricts
// to restrict his grace and allow for deswords, as well as martial arts to be bought from the uplink on lowpop shifts.

// kits
/datum/uplink_item/bundles_tc/contract_kit
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

// dangerous
/datum/uplink_item/dangerous/doublesword
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

// stealthy
/datum/uplink_item/stealthy_weapons/martialarts
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

/datum/uplink_item/stealthy_weapons/romerol_kit
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

// role_restricted
/datum/uplink_item/role_restricted/spider_injector
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

#undef TRAITOR_POPULATION_EXTREME_LOWPOP
