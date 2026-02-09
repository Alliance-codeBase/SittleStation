/obj/item/storage/belt/utility/makeshift
	name = "makeshift toolbelt"
	desc = "A shoddy holder of tools."
	icon = 'modular_meta/features/makeshift_tools/icons/belts.dmi'
	worn_icon = 'modular_meta/features/makeshift_tools/icons/belt.dmi'
	lefthand_file = 'modular_meta/features/makeshift_tools/icons/belt_lefthand.dmi'
	righthand_file = 'modular_meta/features/makeshift_tools/icons/belt_righthand.dmi'
	inhand_icon_state = "makeshiftbelt"
	worn_icon_state = "makeshiftbelt"
	icon_state = "makeshiftbelt"
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4.65, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.5)

/obj/item/storage/belt/utility/makeshift/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 6 //It's a very crappy belt
	atom_storage.max_total_storage = 16
