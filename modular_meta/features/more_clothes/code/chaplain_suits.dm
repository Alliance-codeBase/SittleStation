/obj/item/clothing/head/helmet/chaplain/penitent
	name = "Penitent 's helmet"
	desc = "Where is the blood coming from?"
	icon = 'modular_meta/features/more_clothes/icons/items/head/chaplain.dmi'
	worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/head/chaplain.dmi'
	icon_state = "penitent"
	inhand_icon_state = null

/obj/item/clothing/suit/chaplainsuit/armor/penitent_armor
	name = "Penitent 's armour"
	desc = "The wearer must suffer."
	icon = 'modular_meta/features/more_clothes/icons/items/suits/chaplain.dmi'
	worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/chaplain.dmi'
	icon_state = "penitent_armor"

// Give box for chap beacon
/obj/item/storage/box/holy/penitent
	name = "Last Penitent Kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/penitent_armor

/obj/item/storage/box/holy/penitent/PopulateContents()
	.=..()
	new /obj/item/clothing/suit/chaplainsuit/armor/penitent_armor(src)
	new /obj/item/clothing/head/helmet/chaplain/penitent(src)
