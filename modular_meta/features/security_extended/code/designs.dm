/datum/design/powerpack
	name = "Power Pack (Lethal)"
	build_type = PROTOLATHE | AWAY_LATHE
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 6,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.25,
	)
	build_path = /obj/item/ammo_box/magazine/recharge/station
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/powerpack/stun
	name = "Stun type Power Pack (Nonlethal)"
	build_type = PROTOLATHE | AWAY_LATHE
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1,
	)
	build_path = /obj/item/ammo_box/magazine/recharge/station/stun
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/powerpack/scatter
	name = "Scatter type Power Pack (Pretty Lethal)"
	build_type = PROTOLATHE | AWAY_LATHE
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 8,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT * 1,
		/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.5,
	)
	build_path = /obj/item/ammo_box/magazine/recharge/station/scatter
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/techweb_node/energy_rifle_tierone
	display_name = "Energy Rifle prentice: Tier 1"
	description = "Guys where we gonna get ammo?"
	prerequisite_nodes = list(/datum/techweb_node/riot_supression, /datum/techweb_node/parts_adv)
	unlocked_designs = list(
		/datum/design/powerpack,
		/datum/design/powerpack/stun,
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/energy_rifle_tiertwo
	display_name = "Energy Rifle enjoyer: Tier 2"
	description = "Thats the stuff."
	prerequisite_nodes = list(/datum/techweb_node/energy_rifle_tierone, /datum/techweb_node/parts_bluespace)
	unlocked_designs = list(
		/datum/design/powerpack/scatter,
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)
