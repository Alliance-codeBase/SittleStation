/datum/storage/security_belt/judo
	max_slots = 3
	open_sound = 'sound/items/handling/holster_open.ogg'
	open_sound_vary = TRUE
	rustle_sound = null

/obj/item/storage/belt/security/judo
	name = "corporate judo belt"
	desc = "disciplined path of shitcurity"
	icon_state = "security"
	inhand_icon_state = "security" //Could likely use a better one.
	worn_icon_state = "security"
	content_overlays = FALSE
	storage_type = /datum/storage/security_belt/judo

/obj/item/storage/belt/security/judo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/martial_art_giver, /datum/martial_art/judo)
