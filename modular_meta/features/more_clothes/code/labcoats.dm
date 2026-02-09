/obj/item/clothing/suit/toggle/labcoat/cmo/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/labcoat_cmo, infinite = FALSE)

/datum/atom_skin/labcoat_cmo
	abstract_type = /datum/atom_skin/labcoat_cmo

/datum/atom_skin/labcoat_cmo/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/labcoat.dmi'
	new_icon_state = "labcoat_cmo"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/labcoat.dmi'

/datum/atom_skin/labcoat_cmo/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/labcoat.dmi'
	new_icon_state = "labcoat_cmo"
	new_worn_icon = 'icons/mob/clothing/suits/labcoat.dmi'

/obj/item/clothing/suit/toggle/labcoat/mad/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/labcoat_mad, infinite = FALSE)

/datum/atom_skin/labcoat_mad
	abstract_type = /datum/atom_skin/labcoat_mad

/datum/atom_skin/labcoat_mad/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/labcoat.dmi'
	new_icon_state = "labgreen"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/labcoat.dmi'

/datum/atom_skin/labcoat_mad/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/labcoat.dmi'
	new_icon_state = "labgreen"
	new_worn_icon = 'icons/mob/clothing/suits/labcoat.dmi'
