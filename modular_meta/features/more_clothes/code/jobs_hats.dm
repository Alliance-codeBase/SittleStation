
/*
/datum/atom_skin/caphat/parade
	preview_name = ""
	new_icon = ''
	new_icon_state = ""
	new_worn_icon = ''
	new_worn_icon_state ""
*/



/obj/item/clothing/head/hats/caphat/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/caphat)

/datum/atom_skin/caphat
	abstract_type =  /datum/atom_skin/caphat
	change_base_icon_state = TRUE

/datum/atom_skin/caphat/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/head/hats.dmi'
	new_icon_state = "captain"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/head/hats.dmi'

/datum/atom_skin/caphat/default
	preview_name = "Default"
	new_icon = 'icons/obj/clothing/head/hats.dmi'
	new_icon_state = "captain"
	new_worn_icon = 'icons/mob/clothing/head/hats.dmi'

/datum/atom_skin/caphat/parade/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/head/hats.dmi'
	new_icon_state = "capcap"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/head/hats.dmi'

/datum/atom_skin/caphat/parade
	preview_name = "Default"
	new_icon = 'icons/obj/clothing/head/hats.dmi'
	new_icon_state = "capcap"
	new_worn_icon = 'icons/mob/clothing/head/hats.dmi'


/obj/item/clothing/head/hats/hopcap/setup_reskins()
	. = ..()
 	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hopcap)

/datum/atom_skin/hopcap
	abstract_type =  /datum/atom_skin/hopcap
	change_base_icon_state = TRUE

/datum/atom_skin/hopcap/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/head/hats.dmi'
	new_icon_state = "hopcap"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/head/hats.dmi'

/datum/atom_skin/hopcap/default
	preview_name = "Default"
	new_icon = 'icons/obj/clothing/head/hats.dmi'
	new_icon_state = "hopcap"
	new_worn_icon = 'icons/mob/clothing/head/hats.dmi'

/obj/item/clothing/head/hats/hos/cap/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hoscap)

/datum/atom_skin/hoscap
	abstract_type =  /datum/atom_skin/hoscap
	change_base_icon_state = TRUE

/datum/atom_skin/hoscap/old
	preview_name = "Old Fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/head/hats.dmi'
	new_icon_state = "hoscap"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/head/hats.dmi'

/datum/atom_skin/hoscap/default
	preview_name = "Default"
	new_icon = 'icons/obj/clothing/head/hats.dmi'
	new_icon_state = "hoscap"
	new_worn_icon = 'icons/mob/clothing/head/hats.dmi'

/obj/item/clothing/head/hats/warden/police/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/wardencap_police)

/datum/atom_skin/wardencap_police/default
	preview_name = "Default"
	new_icon = 'icons/obj/clothing/head/hats.dmi'
	new_icon_state = "policehelm"
	new_worn_icon = 'icons/mob/clothing/head/hats.dmi'

/datum/atom_skin/wardencap_police/old
	preview_name = "Old Fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/head/hats.dmi'
	new_icon_state = "policehelm"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/head/hats.dmi'

/obj/item/clothing/head/hats/warden/drill/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_drill)

/datum/atom_skin/warden_drill/old
	preview_name = "Old Fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/head/hats.dmi'
	new_icon_state = "wardendrill"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/head/hats.dmi'

/datum/atom_skin/warden_drill/default
	preview_name = "Default"
	new_icon = 'icons/obj/clothing/head/hats.dmi'
	new_icon_state = "wardendrill"
	new_worn_icon = 'icons/mob/clothing/head/hats.dmi'

