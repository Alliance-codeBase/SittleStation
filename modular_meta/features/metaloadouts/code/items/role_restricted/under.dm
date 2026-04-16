/datum/loadout_category/under
	category_name = "Jumpsuits and Skirts"
	category_ui_icon = FA_ICON_TSHIRT
	type_to_generate = /datum/loadout_item/under
	tab_order = /datum/loadout_category/suits::tab_order - 1

/datum/loadout_item/under
	abstract_type = /datum/loadout_item/under

/datum/loadout_item/under/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.uniform))
		.. ()
		return TRUE

/datum/loadout_item/under/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.uniform)
			LAZYADD(outfit.backpack_contents, outfit.uniform)
		outfit.uniform = item_path
	else
		outfit.uniform = item_path

//engineering
/datum/loadout_item/under/hazard
	name = "Engineer's Hazard Jumpsuit"
	group = "Engineering Department Outfit"
	item_path = /obj/item/clothing/under/rank/engineering/engineer/hazard
	restricted_roles = list(JOB_CHIEF_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN, JOB_STATION_ENGINEER)

//cargo
/datum/loadout_item/under/cargo_shorts
	name = "Cargo Technician's Shorts"
	group = "Cargo Department Outfit"
	item_path = /obj/item/clothing/under/rank/cargo/tech/alt
	restricted_roles = list(JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN, JOB_BITRUNNER)

/datum/loadout_item/under/cargo_skirt
	name = "Cargo Technician's Shortskirt"
	group = "Cargo Department Outfit"
	item_path = /obj/item/clothing/under/rank/cargo/tech/skirt/alt
	restricted_roles = list(JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN, JOB_BITRUNNER)

/datum/loadout_item/under/miner_suit
	name = "Shaft Miner's Jumpsuit"
	group = "Cargo Department Outfit"
	item_path = /obj/item/clothing/under/rank/cargo/miner
	restricted_roles = list(JOB_QUARTERMASTER, JOB_SHAFT_MINER)

//security
/datum/loadout_item/under/grey_secsuit
	name = "Grey Security Jumpsuit"
	group = "Security Department Outfit"
	item_path = /obj/item/clothing/under/rank/security/officer/grey
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_SECURITY_OFFICER_MEDICAL, JOB_SECURITY_OFFICER_ENGINEERING, JOB_SECURITY_OFFICER_SCIENCE, JOB_SECURITY_OFFICER_SUPPLY)

/datum/loadout_item/under/blueshirt
	name = "Blue Shirt and Tie"
	group = "Security Department Outfit"
	item_path = /obj/item/clothing/under/rank/security/officer/blueshirt
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_SECURITY_OFFICER_MEDICAL, JOB_SECURITY_OFFICER_ENGINEERING, JOB_SECURITY_OFFICER_SCIENCE, JOB_SECURITY_OFFICER_SUPPLY)

/datum/loadout_item/under/constable
	name = "Constable Outfit"
	group = "Security Department Outfit"
	item_path = /obj/item/clothing/under/rank/security/constable
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_SECURITY_OFFICER_MEDICAL, JOB_SECURITY_OFFICER_ENGINEERING, JOB_SECURITY_OFFICER_SCIENCE, JOB_SECURITY_OFFICER_SUPPLY)

