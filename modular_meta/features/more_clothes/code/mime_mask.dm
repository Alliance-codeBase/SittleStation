/obj/item/clothing/mask/gas/mime
	icon = 'modular_meta/features/more_clothes/icons/items/masks.dmi'
	worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/mask.dmi'

/obj/item/clothing/mask/gas/mime/Initialize(mapload)
	.=..()
	mimemask_designs += list(
		"Joker" = image(icon = 'modular_meta/features/more_clothes/icons/items/masks.dmi', icon_state = "mimejoker")
		)
