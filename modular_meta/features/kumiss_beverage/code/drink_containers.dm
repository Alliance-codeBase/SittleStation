// reagent containers for kumiss

/obj/item/reagent_containers/cup/glass/bottle/kumiss
	name = "kumiss bottle"
	desc = "Қымыыыыыыз."
	icon = 'modular_meta/features/kumiss_beverage/icons/bottle.dmi'
	icon_state = "kumiss"
	list_reagents = list(/datum/reagent/consumable/kumiss = 100)
	drink_type = DAIRY

// TODO: нужно будет потом добавить иконки "в руках"

/datum/glass_style/drinking_glass/kumiss
	required_drink_type = /datum/reagent/consumable/kumiss
	name = "glass of kumiss"
	desc = "A glass of kumiss."
	icon = 'modular_meta/features/kumiss_beverage/icons/drinks.dmi'
	icon_state = "kumiss"
