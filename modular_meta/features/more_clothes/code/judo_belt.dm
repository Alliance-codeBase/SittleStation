/obj/item/storage/belt/security/judo
	name = "corporate judo belt"
	desc = "disciplined path of shitcurity"
	icon_state = "security"
	inhand_icon_state = "security"//Could likely use a better one.
	worn_icon_state = "security"
	content_overlays = FALSE
	storage_type = /datum/storage/security_belt
	AddComponent(/datum/component/martial_art_giver, /datum/martial_art/kaza_ruk)
