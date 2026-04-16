/datum/loadout_item/accessory/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.accessory)
			LAZYADD(outfit.backpack_contents, outfit.accessory)
		outfit.accessory = item_path
	else
		outfit.accessory = item_path

/datum/loadout_item/accessory/qm_cloak
	name = "QM Cloak"
	group = "Command Outfit"
	item_path = /obj/item/clothing/neck/cloak/qm
	restricted_roles = list(JOB_QUARTERMASTER)

/datum/loadout_item/accessory/hos_cloak
	name = "HOS Cloak"
	group = "Command Outfit"
	item_path = /obj/item/clothing/neck/cloak/hos
	restricted_roles = list(JOB_HEAD_OF_SECURITY)

/datum/loadout_item/accessory/cmo_cloak
	name = "CMO Cloak"
	group = "Command Outfit"
	item_path = /obj/item/clothing/neck/cloak/cmo
	restricted_roles = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/loadout_item/accessory/ce_cloak
	name = "CE Cloak"
	group = "Command Outfit"
	item_path = /obj/item/clothing/neck/cloak/ce
	restricted_roles = list(JOB_CHIEF_ENGINEER)

/datum/loadout_item/accessory/rd_cloak
	name = "RD Cloak"
	group = "Command Outfit"
	item_path = /obj/item/clothing/neck/cloak/rd
	restricted_roles = list(JOB_RESEARCH_DIRECTOR)

/datum/loadout_item/accessory/cap_cloak
	name = "Captain Cloak"
	group = "Command Outfit"
	item_path = /obj/item/clothing/neck/cloak/cap
	restricted_roles = list(JOB_CAPTAIN)

/datum/loadout_item/accessory/hop_cloak
	name = "HOP Cloak"
	group = "Command Outfit"
	item_path = /obj/item/clothing/neck/cloak/hop
	restricted_roles = list(JOB_HEAD_OF_PERSONNEL)
