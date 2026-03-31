/datum/lazy_template/deathmatch/the_permabrig
	name = "The Permabrig"
	desc = "A recreation of ProtoBoxStation Permabrig."
	max_players = 8
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/prisoner)
	map_name = "protobox_permabrig"
	key = "protobox_permabrig"

/datum/lazy_template/deathmatch/byodm
	name = "Build Your Own Death Match"
	desc = "Modificated version of BYOS."
	max_players = 8
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/assistant)
	map_name = "BYODM"
	key = "BYODM"

/datum/lazy_template/deathmatch/middle_east
	name = "Middle East Showdown"
	desc = "Fight for N(a)T(o) or Arabic-Syndicate organization, whatever you choiced, fight everyone. \
	Redactors will go insane."
	max_players = 18
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/t_mid_east,
		/datum/outfit/deathmatch_loadout/ct_mid_east,
	)
	map_name = "middle_east_showdown"
	key = "middle_east_showdown"

/* /datum/lazy_template/deathmatch/kamurocho //recycle unit
	name = "Kamurochō"
	desc = "I Receive You."
	max_players = 8
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/dragon_of_dojima,
		/datum/outfit/deathmatch_loadout/mad_dog_of_shimano,
	)
	map_name = "kamurocho"
	key = "kamurocho" */

/datum/lazy_template/deathmatch/island_operation
	name = "Island Operation"
	desc = "Infiltrate to 'Einstein' Island and defuse bomb."
	max_players = 10
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/ct_mid_east,
	)
	map_name = "island_operation"
	key = "island_operation"

/datum/lazy_template/deathmatch/library
	name = "Library of Sanity"
	desc = "Silence. I'VE SAID SILENCE."
	max_players = 15
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/curator,
	)
	map_name = "library"
	key = "library"

/datum/lazy_template/deathmatch/nuthouse
	name = "Nuthouse"
	desc = "DurkaRP."
	max_players = 6
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/patient,
	)
	map_name = "nuthouse"
	key = "nuthouse"

datum/lazy_template/deathmatch/furiousmages
	name = "Wizard Proving Grounds"
	desc = "An arcane battlefield to determine the most powerful wizard."
	max_players = 16
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/fur_wizard,
		/datum/outfit/deathmatch_loadout/fur_wizard/fire,
		/datum/outfit/deathmatch_loadout/fur_wizard/lightning,
		/datum/outfit/deathmatch_loadout/fur_wizard/holy,
		/datum/outfit/deathmatch_loadout/fur_wizard/chaos,
		/datum/outfit/deathmatch_loadout/fur_wizard/bee,
		/datum/outfit/deathmatch_loadout/fur_chaplain,
	)
	map_name = "furious_mages"
	key = "furious_mages"

/datum/lazy_template/deathmatch/deep_space
	name = "Deep Space"
	desc = "A deep-space cargo shipping station has fallen under attack by a Syndicate boarding party."
	max_players = 8
	automatic_gameend_time = 15 MINUTES //its a pretty big map
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/cargo_spaceman,
		/datum/outfit/deathmatch_loadout/syndicate_spaceman,
		/datum/outfit/deathmatch_loadout/spacetider,
	)
	map_name = "deep_space"
	key = "deep_space"

/datum/lazy_template/deathmatch/waffle_corp
	name = "Waffle Corp Parking Lot"
	desc = "You're not a real Syndicate agent until you've killed a rival on this infamous battlefield."
	max_players = 12
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/syndicate,
		/datum/outfit/deathmatch_loadout/syndicate/cybersun,
		/datum/outfit/deathmatch_loadout/syndicate/donk,
		/datum/outfit/deathmatch_loadout/syndicate/gorlex,
		/datum/outfit/deathmatch_loadout/syndicate/waffle,
		)
	map_name = "waffle_corp"
	key = "waffle_corp"
