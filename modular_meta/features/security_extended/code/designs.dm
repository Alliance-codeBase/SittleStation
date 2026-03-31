/datum/design/powerpack
	id = "powerpack"
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
	build_path = /obj/item/ammo_box/magazine/recharge
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/powerpack/stun
	id = "powerpackstun"
	name = "Stun type Power Pack (Nonlethal)"
	build_type = PROTOLATHE | AWAY_LATHE
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1,
	)
	build_path = /obj/item/ammo_box/magazine/recharge/stun
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/powerpack/scatter
	id = "powerpackscatter"
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
	build_path = /obj/item/ammo_box/magazine/recharge/scatter
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/techweb_node/energy_rifle_tierone
	id = TECHWEB_NODE_ENERGY_RIFLE_TIERONE
	display_name = "Energy Rifle prentice: Tier 1"
	description = "Guys where we gonna get ammo?"
	prereq_ids = list(TECHWEB_NODE_RIOT_SUPRESSION, TECHWEB_NODE_PARTS_UPG)
	design_ids = list(
		"powerpack",
		"powerpackstun",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/energy_rifle_tiertwo
	id = TECHWEB_NODE_ENERGY_RIFLE_TIETWO
	display_name = "Energy Rifle enjoyer: Tier 2"
	description = "Thats the stuff."
	prereq_ids = list(TECHWEB_NODE_ENERGY_RIFLE_TIERONE, TECHWEB_NODE_PARTS_BLUESPACE)
	design_ids = list(
		"powerpackscatter",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)
