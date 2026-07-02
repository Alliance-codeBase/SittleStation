// оверайды

/obj/item/clothing/shoes/sneakers/rainbow
	desc = "Very colorful shoes."

/obj/item/clothing/accessory/pride // actually patriotic
	name = "patriotic pin"
	desc = "A Nanotrasen holographic pin to show off your patriotic."
	icon = 'modular_meta/tweaks/lgbt_removal/icons/pins.dmi'
	worn_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins_clothing.dmi'
	icon_state = "flag_russ"
	worn_icon_state = "flag_russ"

/obj/item/clothing/accessory/pride/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/patriotic_pin, infinite = FALSE)

/datum/atom_skin/patriotic_pin
	abstract_type = /datum/atom_skin/patriotic_pin
	change_base_icon_state = TRUE

/datum/atom_skin/patriotic_pin/russian
	preview_name = "Russian flag"
	new_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins.dmi'
	new_icon_state = "flag_russ"
	new_worn_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins_clothing.dmi'

/datum/atom_skin/patriotic_pin/imperial
	preview_name = "Imperial flag"
	new_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins.dmi'
	new_icon_state = "flag_imper"
	new_worn_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins_clothing.dmi'

/datum/atom_skin/patriotic_pin/china
	preview_name = "China flag"
	new_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins.dmi'
	new_icon_state = "flag_china"
	new_worn_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins_clothing.dmi'

/datum/atom_skin/patriotic_pin/german
	preview_name = "German flag"
	new_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins.dmi'
	new_icon_state = "flag_germ"
	new_worn_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins_clothing.dmi'

/datum/atom_skin/patriotic_pin/serbian
	preview_name = "Serbian flag"
	new_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins.dmi'
	new_icon_state = "flag_serb"
	new_worn_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins_clothing.dmi'

/datum/atom_skin/patriotic_pin/kazakh
	preview_name = "Kazakh flag"
	new_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins.dmi'
	new_icon_state = "flag_kaz"
	new_worn_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins_clothing.dmi'

/datum/atom_skin/patriotic_pin/iranian
	preview_name = "Iranian flag"
	new_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins.dmi'
	new_icon_state = "flag_iran"
	new_worn_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins_clothing.dmi'

/datum/atom_skin/patriotic_pin/cuban
	preview_name = "Cuban Pete"
	new_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins.dmi'
	new_icon_state = "flag_cuba"
	new_worn_icon = 'modular_meta/tweaks/lgbt_removal/icons/pins_clothing.dmi'

/datum/loadout_item/accessory/pride
	name = "Patriotic Pin"
