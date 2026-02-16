/obj/item/clothing/suit/armor/hos/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_armor, infinite = FALSE)

/datum/atom_skin/hos_armor
	abstract_type = /datum/atom_skin/hos_armor
	change_base_icon_state = TRUE

/datum/atom_skin/hos_armor/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "hos"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/datum/atom_skin/hos_armor/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/armor.dmi'
	new_icon_state = "hos"
	new_worn_icon = 'icons/mob/clothing/suits/armor.dmi'

/datum/atom_skin/hos_armor/trench
	preview_name = "Trench Cloak"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "trenchcloak"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/obj/item/clothing/suit/armor/hos/trenchcoat/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_trenchcoat, infinite = FALSE)

/datum/atom_skin/hos_trenchcoat
	abstract_type = /datum/atom_skin/hos_trenchcoat
	change_base_icon_state = TRUE

/datum/atom_skin/hos_trenchcoat/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "hostrench"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/datum/atom_skin/hos_trenchcoat/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/armor.dmi'
	new_icon_state = "hostrench"
	new_worn_icon = 'icons/mob/clothing/suits/armor.dmi'

/datum/atom_skin/hos_trenchcoat/trench
	preview_name = "Trench Cloak"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "trenchcloak"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/obj/item/clothing/suit/armor/hos/hos_formal/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_formal, infinite = FALSE)

/datum/atom_skin/hos_formal
	abstract_type = /datum/atom_skin/hos_formal
	change_base_icon_state = TRUE

/datum/atom_skin/hos_formal/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "hosformal"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/datum/atom_skin/hos_formal/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/armor.dmi'
	new_icon_state = "hosformal"
	new_worn_icon = 'icons/mob/clothing/suits/armor.dmi'

/datum/atom_skin/hos_formal/trench
	preview_name = "Trench Cloak"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "trenchcloak"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/*
Due to some stuff(particularly with it having alternative sprite when alt_clicked with reskins
it couldn't have been added as reskin variant to the
/obj/item/clothing/suit/armor/hos/hos_formal/ so, we're adding it as a separate item.
*/

/obj/item/clothing/suit/armor/hos/hos_formal/black
	name = "\improper Head of Security's parade jacket"
	icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	icon_state = "hosformal_black"
	worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/obj/item/clothing/suit/armor/hos/hos_formal/old // same applies here
	name = "\improper Head of Security's parade jacket"
	icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	icon_state = "hosformal"
	worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'
	worn_icon_state = "hosformal"

//HOS_GARMENT

/obj/item/storage/bag/garment/hos/PopulateContents()
	. = ..()
	new /obj/item/clothing/suit/armor/hos/hos_formal/black(src)
	new /obj/item/clothing/suit/armor/hos/hos_formal/old(src)

/obj/item/clothing/suit/armor/vest/warden/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_armor, infinite = FALSE)

/datum/atom_skin/warden_armor
	abstract_type = /datum/atom_skin/warden_armor
	change_base_icon_state = TRUE

/datum/atom_skin/warden_armor/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "warden_alt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/datum/atom_skin/warden_armor/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/armor.dmi'
	new_icon_state = "warden_alt"
	new_worn_icon = 'icons/mob/clothing/suits/armor.dmi'

/obj/item/clothing/suit/armor/vest/warden/alt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_armor_alt, infinite = FALSE)

/datum/atom_skin/warden_armor_alt
	abstract_type = /datum/atom_skin/warden_armor_alt
	change_base_icon_state = TRUE

/datum/atom_skin/warden_armor_alt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "warden_jacket"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/datum/atom_skin/warden_armor_alt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/armor.dmi'
	new_icon_state = "warden_jacket"
	new_worn_icon = 'icons/mob/clothing/suits/armor.dmi'

/obj/item/clothing/suit/armor/vest/leather/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/leather_armor, infinite = FALSE)

/datum/atom_skin/leather_armor
	abstract_type = /datum/atom_skin/leather_armor
	change_base_icon_state = TRUE

/datum/atom_skin/leather_armor/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "leathercoat-sec"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/datum/atom_skin/leather_armor/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/armor.dmi'
	new_icon_state = "leathercoat-sec"
	new_worn_icon = 'icons/mob/clothing/suits/armor.dmi'

/obj/item/clothing/suit/armor/vest/capcarapace/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/capcarapace_armor, infinite = FALSE)

/datum/atom_skin/capcarapace_armor
	abstract_type = /datum/atom_skin/capcarapace_armor
	change_base_icon_state = TRUE

/datum/atom_skin/capcarapace_armor/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "capcarapace"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/datum/atom_skin/capcarapace_armor/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/armor.dmi'
	new_icon_state = "capcarapace"
	new_worn_icon = 'icons/mob/clothing/suits/armor.dmi'

// we dont have reskins for syndicate captain armor vest
/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/setup_reskins()
	return

/obj/item/clothing/suit/armor/vest/capcarapace/captains_formal/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/captain_formal_armor, infinite = FALSE)

/datum/atom_skin/captain_formal_armor
	abstract_type = /datum/atom_skin/captain_formal_armor
	change_base_icon_state = TRUE

/datum/atom_skin/captain_formal_armor/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/suits/armor.dmi'
	new_icon_state = "capformal"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/armor.dmi'

/datum/atom_skin/captain_formal_armor/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/suits/armor.dmi'
	new_icon_state = "capformal"
	new_worn_icon = 'icons/mob/clothing/suits/armor.dmi'
