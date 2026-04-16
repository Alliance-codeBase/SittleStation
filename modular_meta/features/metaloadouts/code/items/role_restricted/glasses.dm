/datum/loadout_item/glasses/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.glasses))
		.. ()
		return TRUE

/datum/loadout_item/glasses/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.glasses)
			LAZYADD(outfit.backpack_contents, outfit.glasses)
		outfit.glasses = item_path
	else
		outfit.glasses = item_path
