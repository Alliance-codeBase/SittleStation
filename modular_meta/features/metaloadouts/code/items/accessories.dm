/datum/loadout_item/accessory/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.accessory)
			LAZYADD(outfit.backpack_contents, outfit.accessory)
		outfit.accessory = item_path
	else
		outfit.accessory = item_path
