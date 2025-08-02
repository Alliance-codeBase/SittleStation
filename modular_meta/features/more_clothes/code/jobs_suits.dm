// HEADS OF STAFF

// CAP

/obj/item/clothing/suit/captunic
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon = 'modular_meta/features/more_clothes/icons/items/suits/captain.dmi'
	worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/suits/captain.dmi'
	icon_state = "captunic"
	inhand_icon_state = "bio_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	allowed = list(/obj/item/disk, /obj/item/stamp, /obj/item/melee, /obj/item/storage/lockbox/medal, /obj/item/assembly/flash/handheld, /obj/item/storage/box/matches, /obj/item/lighter, /obj/item/cigarette, /obj/item/storage/fancy/cigarettes, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)

/obj/item/storage/bag/garment/captain/PopulateContents()
	.=..()
	new /obj/item/clothing/suit/captunic(src)

/obj/item/clothing/under/rank/captain
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/captain.dmi',
			RESKIN_ICON_STATE = "captain",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/captain.dmi',
			RESKIN_WORN_ICON_STATE = "captain",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/captain.dmi',
			RESKIN_ICON_STATE = "captain",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/captain.dmi',
			RESKIN_WORN_ICON_STATE = "captain",
		),
	)

/obj/item/clothing/under/rank/captain/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/captain.dmi',
			RESKIN_ICON_STATE = "captain_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/captain.dmi',
			RESKIN_WORN_ICON_STATE = "captain_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/captain.dmi',
			RESKIN_ICON_STATE = "captain_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/captain.dmi',
			RESKIN_WORN_ICON_STATE = "captain_skirt",
		),
	)

/obj/item/clothing/under/rank/captain/parade
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/captain.dmi',
			RESKIN_ICON_STATE = "captain_parade",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/captain.dmi',
			RESKIN_WORN_ICON_STATE = "captain_parade",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/captain.dmi',
			RESKIN_ICON_STATE = "captain_parade",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/captain.dmi',
			RESKIN_WORN_ICON_STATE = "captain_parade",
		),
	) 

// HOP

/obj/item/clothing/under/rank/civilian/head_of_personnel
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/hop.dmi',
			RESKIN_ICON_STATE = "hop",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/hop.dmi',
			RESKIN_WORN_ICON_STATE = "hop",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/civilian.dmi',
			RESKIN_ICON_STATE = "hop",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/civilian.dmi',
			RESKIN_WORN_ICON_STATE = "hop",
		),
	)

/obj/item/clothing/under/rank/civilian/head_of_personnel/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/hop.dmi',
			RESKIN_ICON_STATE = "hop_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/hop.dmi',
			RESKIN_WORN_ICON_STATE = "hop_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/civilian.dmi',
			RESKIN_ICON_STATE = "hop_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/civilian.dmi',
			RESKIN_WORN_ICON_STATE = "hop_skirt",
		),
	)

// RD

/obj/item/clothing/under/rank/rnd/research_director
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi',
			RESKIN_ICON_STATE = "director",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi',
			RESKIN_WORN_ICON_STATE = "director",
		),
		"Office fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi',
			RESKIN_ICON_STATE = "rdwhimsy",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi',
			RESKIN_WORN_ICON_STATE = "rdwhimsy",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "director",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "director",
		),
	)

/obj/item/clothing/under/rank/rnd/research_director/doctor_hilbert
	uses_advanced_reskins = FALSE
	unique_reskin = null

/obj/item/clothing/under/rank/rnd/research_director/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi',
			RESKIN_ICON_STATE = "director_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi',
			RESKIN_WORN_ICON_STATE = "director_skirt",
		),
		"Office fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi',
			RESKIN_ICON_STATE = "rdwhimsy_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi',
			RESKIN_WORN_ICON_STATE = "rdwhimsy_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "director_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "director_skirt",
		),
	)


/obj/item/clothing/under/rank/rnd/research_director/turtleneck
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi',
			RESKIN_ICON_STATE = "rdturtle",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi',
			RESKIN_WORN_ICON_STATE = "rdturtle",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "rdturtle",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "rdturtle",
		),
	)

/obj/item/clothing/under/rank/rnd/research_director/turtleneck/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi',
			RESKIN_ICON_STATE = "rdturtle_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi',
			RESKIN_WORN_ICON_STATE = "rdturtle_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "rdturtle_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "rdturtle_skirt",
		),
	)

// HOS

/obj/item/clothing/under/rank/security/head_of_security
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "rhos",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rhos",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "rhos",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rhos",
		),
	)

/obj/item/clothing/under/rank/security/head_of_security/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "rhos_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rhos_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "rhos_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rhos_skirt",
		),
	)

/obj/item/clothing/under/rank/security/head_of_security/grey
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "hos",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hos",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "hos",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hos",
		),
	)

/obj/item/clothing/under/rank/security/head_of_security/alt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "hosalt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hosalt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "hosalt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hosalt",
		),
	)

/obj/item/clothing/under/rank/security/head_of_security/alt/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "hosalt_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hosalt_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "hosalt_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hosalt_skirt",
		),
	)

/obj/item/clothing/under/rank/security/head_of_security/parade
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "hos_parade_male",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hos_parade_male",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "hos_parade_male",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hos_parade_male",
		),
	)

/obj/item/clothing/under/rank/security/head_of_security/parade/female
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "hos_parade_fem",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hos_parade_fem",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "hos_parade_fem",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hos_parade_fem",
		),
	)

/obj/item/clothing/under/rank/security/head_of_security/formal
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "hosblueclothes",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hosblueclothes",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "hosblueclothes",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "hosblueclothes",
		),
	)


// SUBORDINATE WORKERS

// SECURITY

/obj/item/clothing/under/rank/security/officer
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "rsecurity",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rsecurity",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "rsecurity",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rsecurity",
		),
	)

/obj/item/clothing/under/rank/security/officer/grey
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "security",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "security",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "security",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "security",
		),
	)

/obj/item/clothing/under/rank/security/officer/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "secskirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "secskirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "secskirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "secskirt",
		),
	)

/obj/item/clothing/under/rank/security/officer/blueshirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "blueshift",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "blueshift",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "blueshift",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "blueshift",
		),
	)

/obj/item/clothing/under/rank/security/officer/formal
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "officerblueclothes",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "officerblueclothes",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "officerblueclothes",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "officerblueclothes",
		),
	)


// WARDEN

/obj/item/clothing/under/rank/security/warden
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "rwarden",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rwarden",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "rwarden",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rwarden",
		),
	)

/obj/item/clothing/under/rank/security/warden/grey
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "warden",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "warden",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "warden",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "warden",
		),
	)

/obj/item/clothing/under/rank/security/warden/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "rwarden_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rwarden_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "rwarden_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "rwarden_skirt",
		),
	)

/obj/item/clothing/under/rank/security/warden/formal
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "wardenblueclothes",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "wardenblueclothes",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "wardenblueclothes",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "wardenblueclothes",
		),
	)

// DETECTIVE

/obj/item/clothing/under/rank/security/detective
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "detective_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "detective_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "detective_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "detective_skirt",
		),
	)

/obj/item/clothing/under/rank/security/detective/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "detective",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "detective",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "detective",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "detective",
		),
	)

/obj/item/clothing/under/rank/security/detective/noir
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "noirdet",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "noirdet",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "noirdet",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "noirdet",
		),
	)


/obj/item/clothing/under/rank/security/detective/noir/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/security.dmi',
			RESKIN_ICON_STATE = "noirdet_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "noirdet_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/security.dmi',
			RESKIN_ICON_STATE = "noirdet_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/security.dmi',
			RESKIN_WORN_ICON_STATE = "noirdet_skirt",
		),
	)


// CARGO

/obj/item/clothing/under/rank/cargo/qm
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/cargo.dmi',
			RESKIN_ICON_STATE = "qm",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/cargo.dmi',
			RESKIN_WORN_ICON_STATE = "qm",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/cargo.dmi',
			RESKIN_ICON_STATE = "qm",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/cargo.dmi',
			RESKIN_WORN_ICON_STATE = "qm",
		),
	)

/obj/item/clothing/under/rank/cargo/qm/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/cargo.dmi',
			RESKIN_ICON_STATE = "qm_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/cargo.dmi',
			RESKIN_WORN_ICON_STATE = "qm_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/cargo.dmi',
			RESKIN_ICON_STATE = "qm_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/cargo.dmi',
			RESKIN_WORN_ICON_STATE = "qm_skirt",
		),
	)

/obj/item/clothing/under/rank/cargo/tech
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/cargo.dmi',
			RESKIN_ICON_STATE = "cargotech",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/cargo.dmi',
			RESKIN_WORN_ICON_STATE = "cargotech",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/cargo.dmi',
			RESKIN_ICON_STATE = "cargotech",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/cargo.dmi',
			RESKIN_WORN_ICON_STATE = "cargotech",
		),
	)

/obj/item/clothing/under/rank/cargo/tech/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/cargo.dmi',
			RESKIN_ICON_STATE = "cargo_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/cargo.dmi',
			RESKIN_WORN_ICON_STATE = "cargo_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/cargo.dmi',
			RESKIN_ICON_STATE = "cargo_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/cargo.dmi',
			RESKIN_WORN_ICON_STATE = "cargo_skirt",
		),
	)


// MEDICAL

/obj/item/clothing/under/rank/medical/doctor
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi',
			RESKIN_ICON_STATE = "medical",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "medical",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/medical.dmi',
			RESKIN_ICON_STATE = "medical",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "medical",
		),
	)

/obj/item/clothing/under/rank/medical/doctor/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi',
			RESKIN_ICON_STATE = "medical_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "medical_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/medical.dmi',
			RESKIN_ICON_STATE = "medical_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "medical_skirt",
		),
	)

/obj/item/clothing/under/rank/medical/chief_medical_officer
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi',
			RESKIN_ICON_STATE = "cmo",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "cmo",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/medical.dmi',
			RESKIN_ICON_STATE = "cmo",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "cmo",
		),
	)

/obj/item/clothing/under/rank/medical/chief_medical_officer/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi',
			RESKIN_ICON_STATE = "cmo_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "cmo_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/medical.dmi',
			RESKIN_ICON_STATE = "cmo_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "cmo_skirt",
		),
	)

/obj/item/clothing/under/rank/medical/chief_medical_officer/scrubs
	uses_advanced_reskins = FALSE
	unique_reskin = null

/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck
	uses_advanced_reskins = FALSE
	unique_reskin = null

/obj/item/clothing/under/rank/medical/virologist
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi',
			RESKIN_ICON_STATE = "virology",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "virology",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/medical.dmi',
			RESKIN_ICON_STATE = "virology",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "virology",
		),
	)

/obj/item/clothing/under/rank/medical/virologist/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi',
			RESKIN_ICON_STATE = "virologywhite_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "virologywhite_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/medical.dmi',
			RESKIN_ICON_STATE = "virologywhite_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "virologywhite_skirt",
		),
	)

/obj/item/clothing/under/rank/medical/chemist
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi',
			RESKIN_ICON_STATE = "chemistry",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "chemistry",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/medical.dmi',
			RESKIN_ICON_STATE = "chemistry",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "chemistry",
		),
	)

/obj/item/clothing/under/rank/medical/chemist/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi',
			RESKIN_ICON_STATE = "chemistrywhite_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "chemistrywhite_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/medical.dmi',
			RESKIN_ICON_STATE = "chemistrywhite_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/medical.dmi',
			RESKIN_WORN_ICON_STATE = "chemistrywhite_skirt",
		),
	)


// SCIENCE

/obj/item/clothing/under/rank/rnd/scientist
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi',
			RESKIN_ICON_STATE = "science",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "science",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "science",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "science",
		),
	)

/obj/item/clothing/under/rank/rnd/scientist/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi',
			RESKIN_ICON_STATE = "science_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "science_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "science_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "science_skirt",
		),
	)

/obj/item/clothing/under/rank/rnd/roboticist
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi',
			RESKIN_ICON_STATE = "robotics",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "robotics",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "robotics",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "robotics",
		),
	)

/obj/item/clothing/under/rank/rnd/roboticist/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi',
			RESKIN_ICON_STATE = "robotics_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "robotics_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "robotics_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "robotics_skirt",
		),
	)

/obj/item/clothing/under/rank/rnd/geneticist
	uses_advanced_reskins = TRUE
	obj_flags = INFINITE_RESKIN

	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi',
			RESKIN_ICON_STATE = "genetics",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "genetics",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "genetics",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "genetics",
		),
	)

/obj/item/clothing/under/rank/rnd/geneticist/skirt
	unique_reskin = list(
		"Old fashioned" = list(
			RESKIN_ICON = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi',
			RESKIN_ICON_STATE = "genetics_skirt",
			RESKIN_WORN_ICON = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "genetics_skirt",
		),
		"Original" = list(
			RESKIN_ICON = 'icons/obj/clothing/under/rnd.dmi',
			RESKIN_ICON_STATE = "genetics_skirt",
			RESKIN_WORN_ICON = 'icons/mob/clothing/under/rnd.dmi',
			RESKIN_WORN_ICON_STATE = "genetics_skirt",
		),
	)
