/datum/metacoinshop/listing
	var/id
	var/name
	var/desc
	var/price
	var/item_type
	var/listing_type = "item"
	var/icon
	var/icon_state

/// Is called after a successful purchase.
/datum/metacoinshop/listing/proc/on_bought(datum/metacoin_shop_controller/shop, target_ckey, mob/player_mob, client/player_client, balance_after, role_id = null)
	return TRUE
// here lies any additional logic you might want to add, mainly, I added it because I wanted to see a cool announcement when wycc's soul is bought

/datum/metacoinshop/listing/proc/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	return

// It's like the same ^^^ but you may edit variables of stuff in params, like human_spawned or item. e.g you may buy a baton, \
then have it variable edit'ed like so item.force = 25, potentially escaping any additional hardcode or unneeded bloat

/datum/metacoinshop/listing/proc/persistent_grant(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned, client/player_client)
	return
// it's persistenly repeated code on each round if the SSdb returns true whether something's been bought, use it for any effects on demand
// later on we'll add a preference flag to disable bought items on demand

/datum/metacoinshop/listing/preround

/*
/datum/metacoinshop/listing/preround/donut_box/on_bought(datum/metacoin_shop_controller/shop, target_ckey, mob/player_mob, client/player_client, balance_after, role_id = null)
	to_chat(player_mob, span_green("success! die!")) // no idea why's there mob/player mob in params, but it's there, it exists! and it matters!

/datum/metacoinshop/listing/preround/donut_box/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	to_chat(human_spawned, span_green("success!"))
	sleep(20)
	to_chat(human_spawned, span_red("die!"))
	sleep(10)
	human_spawned.gib()// DIE!

*/
/datum/metacoinshop/listing/preround/donut_box
	id = "donut_box"
	name = "Donut Box"
	desc = "A box of donuts... what else do you expect?"
	price = 50
	item_type = /obj/item/storage/fancy/donut_box

/datum/metacoinshop/listing/preround/spray_libital
	id = "spray_libital"
	name = "Libital Spray"
	desc = "An medigel full of libital, mainly used to treat bruises"
	price = 75
	item_type = /obj/item/reagent_containers/medigel/libital

/datum/metacoinshop/listing/preround/spray_auri
	id = "spray_auri"
	name = "Aiuri Spray"
	desc = "An medigel full of aiuri, mainly used to treat burns"
	price = 75
	item_type = /obj/item/reagent_containers/medigel/aiuri

/datum/metacoinshop/listing/preround/eva_kit
	id = "extra_vehicular"
	name = "Premium EVA-ready kit"
	desc = "Full-kit containing a bluespace-compressed jetpack, an oxygen tank, a suit, a helmet and a medkit! Gun included!"
	price = 300
	item_type = /obj/item/storage/box/eva_kit

/obj/item/storage/box/eva_kit
	name = "EVA kit"
	desc = "A sturdy looking box, label says \"it has everything needed for space exploration\""

/obj/item/storage/box/eva_kit/Initialize(mapload)
	.=..()
	var/obj/item/stack/medical/suture/suture = new/obj/item/stack/medical/suture(src)
	suture.amount = 10
	var/obj/item/stack/medical/mesh/mesh = new /obj/item/stack/medical/mesh(src)
	mesh.amount = 10
	var/obj/item/stock_parts/power_store/cell/high/cell = new /obj/item/stock_parts/power_store/cell/high(src)
	cell.charge = 10000 // the fuck is a cell unit? ten thousand I guess? because after test a hundred is turned to be 0.1%
	var/obj/item/tank/jetpack/jpack = new /obj/item/tank/jetpack(src)
	//get current gas
	var/datum/gas_mixture/gas = jpack.return_air() // bitch it's literally oxygen
	gas.assert_gas(jpack.gas_type)
	// quadruple it and give it to the next jetpack
	gas.gases[jpack.gas_type][MOLES] += ((24 * ONE_ATMOSPHERE) * jpack.volume / (R_IDEAL_GAS_EQUATION * T20C))
	jpack.desc += span_notice(" \n Though it definetly seems to have enlarged in proportions when I took it from the box..")
	new /obj/item/clothing/suit/space(src)
	new /obj/item/clothing/head/helmet/space(src)
	new /obj/item/tank/internals/oxygen(src)
	new /obj/item/storage/medkit/advanced(src)
	new /obj/item/storage/belt/utility/full(src)
	new /obj/item/knife/combat/survival(src)
	new /obj/item/gun/energy/e_gun/mini(src)
	new /obj/item/case_portable_recharger(src)
	new /obj/item/manual_cell_recharger(src)
	new /obj/item/stock_parts/servo/pico(src)
	new /obj/item/flashlight/seclite(src)

/datum/metacoinshop/listing/preround/self_surgery
	id = "surgery"
	name = "4U70-P3R4710N skillchip"
	desc = "A skillchip containing old Nanotrasen medical training protocols, which one could use to perform surgical operations on themselves. \
	This one is new, I'd say, \"almost pristine condition.\" It will be already implanted in your brain upon purchause and your arrival."
	price = 250
	item_type = /obj/item/skillchip/self_surgery
	listing_type = "other"

/datum/metacoinshop/listing/preround/self_surgery/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	var/obj/item/skillchip/skillchip = new item_type()
	human_spawned.implant_skillchip(skillchip)
	skillchip.try_activate_skillchip()

/datum/metacoinshop/listing/preround/antag_token
	id = "antag_token"
	name = "Antag Token"
	desc = "Guarantees one chosen antagonist role at roundstart."
	price = 650
	item_type = /obj/item/coin/antagtoken // to get the display icon of ours
	listing_type = "other"

/datum/metacoin_shop_listing
	parent_type = /datum/metacoinshop/listing

/datum/metacoinshop/antag_role
	var/id
	/// Displayed name.
	var/name
	/// Displayed description.
	var/desc
	/// as in code\modules\jobs\departments\departments.dm. Needed for UI sorting purpouses.
	var/ui_order = 100
/// Check dynamic.toml, put here your ruleset tag \
(The name of it, e.g ["Roundstart Traitor"]) Under no circumstances there shall be midround antag, or any other that spawns with unique loadout.
	var/ruleset_tag
	/// check code\__DEFINES\role_preferences.dm , when bought role is banned, then it will try to refund the metacoins.
	var/jobban_flag
	/// Your antag datum.
	var/antag_datum
	/// Defaulted value, if for some reason config is unavailable.
	var/default_min_pop = 0

/datum/metacoinshop/antag_role/traitor
	id = "traitor"
	name = "Traitor"
	ui_order = 10
	desc = "An unpaid debt. A score to be settled. Maybe you were just in the wrong \
	   	place at the wrong time. Whatever the reasons, you were selected to \
	   	infiltrate Space Station 13."
	ruleset_tag = "Roundstart Traitor"
	jobban_flag = ROLE_TRAITOR
	antag_datum = /datum/antagonist/traitor
	default_min_pop = 3

/datum/metacoinshop/antag_role/changeling
	id = "changeling"
	name = "Changeling"
	ui_order = 20
	desc = "A highly intelligent alien predator that is capable of altering their \
	shape to flawlessly resemble a human."
	ruleset_tag = "Roundstart Changeling"
	jobban_flag = ROLE_CHANGELING
	antag_datum = /datum/antagonist/changeling
	default_min_pop = 15

/datum/metacoinshop/antag_role/heretic
	id = "heretic"
	name = "Heretic"
	ui_order = 30
	desc = " Forgotten, devoured, gutted. Humanity has forgotten the eldritch forces \
	   	of decay, but the mansus veil has weakened. We will make them taste fear \
	   	again..."
	ruleset_tag = "Roundstart Heretics"
	jobban_flag = ROLE_HERETIC
	antag_datum = /datum/antagonist/heretic
	default_min_pop = 30

/datum/metacoinshop/antag_role/spy
	id = "spy"
	name = "Spy"
	ui_order = 40
	desc = "Your mission, should you choose to accept it: Infiltrate Space Station 13. \
	Disguise yourself as a member of their crew and steal vital equipment. \
	Should you be caught or killed, your employer will disavow any knowledge of your actions. Good luck agent. \
	Complete Spy Bounties to earn rewards from your employer. Use these rewards to sow chaos and mischief!"
	ruleset_tag = "Roundstart Spies"
	jobban_flag = ROLE_SPY
	antag_datum = /datum/antagonist/spy
	default_min_pop = 5
