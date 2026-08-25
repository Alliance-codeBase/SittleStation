/datum/martial_art/judo
	name = "corporate judo"
	id = MARTIALART_CORPORATE_JUDO
	. = ..()
	UnregisterSignal(old_holder, COMSIG_HUMAN_PUNCHED)

/obj/item/clothing/gloves/kaza_ruk/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/martial_art_giver, /datum/martial_art/kaza_ruk)
