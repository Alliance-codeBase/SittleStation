/obj/item/screwdriver/makeshift
	name = "makeshift screwdriver"
	desc = "Crude driver of screws. A primitive way to screw things up."
	icon = 'modular_meta/features/makeshift_tools/icons/improvised.dmi'
	icon_state = "screwdriver_makeshift"
	toolspeed = 2
	random_color = FALSE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null

/obj/item/screwdriver/makeshift/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(prob(5))
		to_chat(user, span_danger("[src] crumbles apart in your hands!"))
		qdel(src)
		return
