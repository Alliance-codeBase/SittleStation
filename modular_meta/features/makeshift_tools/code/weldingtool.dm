/obj/item/weldingtool/makeshift
	name = "makeshift welding tool"
	desc = "A MacGyver-style welder."
	icon = 'modular_meta/features/makeshift_tools/icons/improvised.dmi'
	icon_state = "welder_makeshift"
	toolspeed = 2
	max_fuel = 10
	starting_fuel = FALSE
	change_icons = FALSE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.5)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null

/obj/item/weldingtool/makeshift/switched_on(mob/user)
	..()
	if(welding && get_fuel() >= 1 && prob(2))
		var/datum/effect_system/reagents_explosion/e = new(get_turf(src), round(get_fuel() / 10, 1), 0, 0)
		to_chat(user, span_userdanger("Shoddy construction causes [src] to blow the fuck up!"))
		e.start()
		qdel(src)
		return
