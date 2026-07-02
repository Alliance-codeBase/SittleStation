/obj/item/wrench/makeshift
	name = "makeshift wrench"
	desc = "A crude, self-wrought wrench with common uses. Can be found in your hand."
	icon = 'modular_meta/features/makeshift_tools/icons/improvised.dmi'
	icon_state = "wrench_makeshift"
	toolspeed = 2
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null

/obj/item/wrench/makeshift/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(prob(5))
		to_chat(user, span_danger("[src] crumbles apart in your hands!"))
		qdel(src)
		return
