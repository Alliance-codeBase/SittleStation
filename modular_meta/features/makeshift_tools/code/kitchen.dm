/obj/item/knife/kitchen/makeshift
	name = "makeshift knife"
	icon_state = "knife_makeshift"
	icon = 'modular_meta/features/makeshift_tools/icons/improvised.dmi'
	desc = "A flimsy, poorly made replica of a classic cooking utensil."
	force = 8
	throwforce = 8
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.6, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1)

/obj/item/knife/kitchen/makeshift/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(prob(5))
		to_chat(user, span_danger("[src] crumbles apart in your hands!"))
		qdel(src)
		return
