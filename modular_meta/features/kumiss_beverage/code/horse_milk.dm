/mob/living/basic/pony
	var/milked_reagent = /datum/reagent/consumable/horse_milk

/mob/living/basic/pony/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/udder, reagent_produced_override = milked_reagent)


/datum/reagent/consumable/horse_milk
	name = "Horse milk"
	taste_description = "thin milk"
