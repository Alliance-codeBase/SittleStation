/datum/atom_skin/captain_gloves
	abstract_type =  /datum/atom_skin/captain_gloves
	change_inhand_icon_state = TRUE
	change_base_icon_state = TRUE

/datum/atom_skin/captain_gloves/old
	new_name = "Vintage Captain's Gloves"
	new_icon = 'modular_meta/features/more_clothes/icons/items/gloves.dmi'
	new_icon_state = "captain"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/gloves.dmi'
	preview_name = "Old Captain's Gloves"

/datum/atom_skin/captain_gloves/default
	new_name = "captain's glove"
	new_icon = 'icons/obj/clothing/gloves.dmi'
	new_icon_state = "captain"
	new_worn_icon = 'icons/mob/clothing/hands.dmi'
	preview_name = "Default"

/obj/item/clothing/gloves/captain/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/captain_gloves, infinite = TRUE)
