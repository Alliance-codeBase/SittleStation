// оверайды

/obj/item/clothing/shoes/sneakers/rainbow
	desc = "Very colorful shoes."

/obj/item/clothing/accessory/pride // actually patriotic
	name = "patriotic pin"
	desc = "A Nanotrasen holographic pin to show off your patriotic."
	icon = 'modular_meta/features/lgbt_removal/icons/pins.dmi'
	worn_icon = 'modular_meta/features/lgbt_removal/icons/pins_clothing.dmi'
	icon_state = "flag_russ"
	unique_reskin = list(
		"Russian flag" = "flag_russ",
		"Imperial flag" = "flag_imper",
		"China flag" = "flag_china",
		"German flag" = "flag_germ",
		"Serbian flag" = "flag_serb",
		"Kazakh flag" = "flag_kaz",
		"Iranian flag" = "flag_iran",
		"Cuban Pete" = "flag_cuba",
	)

/datum/loadout_item/accessory/pride
	name = "Patriotic Pin"
