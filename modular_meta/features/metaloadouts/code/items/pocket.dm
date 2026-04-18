/datum/loadout_item/pocket_items/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE) // these go in the backpack
	return FALSE

/datum/loadout_item/pocket_items/spraycan
	name = "Spraycan"
	ui_icon = 'modular_meta/features/metaloadouts/icons/crayons.dmi'
	ui_icon_state = "spraycan"
	item_path = /obj/item/toy/crayon/spraycan
