/obj/item/crowbar/makeshift
	name = "makeshift crowbar"
	desc = "A crude, self-wrought crowbar. Heavy."
	icon = 'modular_meta/features/makeshift_tools/icons/improvised.dmi'
	icon_state = "crowbar_makeshift"
	worn_icon_state = "crowbar"
	force = 12 //same as large crowbar, but bulkier and slower
	w_class = WEIGHT_CLASS_BULKY
	toolspeed = 2
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null

/obj/item/crowbar/makeshift/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(prob(5))
		to_chat(user, span_danger("[src] crumbles apart in your hands!"))
		qdel(src)
		return
