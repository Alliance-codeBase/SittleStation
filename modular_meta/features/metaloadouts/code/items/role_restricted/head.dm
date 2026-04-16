/datum/loadout_item/head/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.head))
		.. ()
		return TRUE

/datum/loadout_item/head/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.head)
			LAZYADD(outfit.backpack_contents, outfit.head)
		outfit.head = item_path
	else
		outfit.head = item_path

/datum/loadout_item/head/constable
	name = "Constable Helmet"
	group = "Security Department Outfit"
	item_path = /obj/item/clothing/head/costume/constable
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_SECURITY_OFFICER_MEDICAL, JOB_SECURITY_OFFICER_ENGINEERING, JOB_SECURITY_OFFICER_SCIENCE, JOB_SECURITY_OFFICER_SUPPLY)

/datum/loadout_item/head/blueshirt
	name = "Blue Helmet"
	group = "Security Department Outfit"
	item_path = /obj/item/clothing/head/helmet/blueshirt
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_SECURITY_OFFICER_MEDICAL, JOB_SECURITY_OFFICER_ENGINEERING, JOB_SECURITY_OFFICER_SCIENCE, JOB_SECURITY_OFFICER_SUPPLY)
