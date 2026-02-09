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

// CAPTAIN UNIFORMS

/obj/item/clothing/under/rank/captain/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/captain_uniform, infinite = FALSE)

/datum/atom_skin/captain_uniform/
	abstract_type = /datum/atom_skin/captain_uniform
	change_base_icon_state = FALSE
	reset_missing = FALSE

/datum/atom_skin/captain_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/captain.dmi'
	new_icon_state = "captain"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/captain.dmi'

/datum/atom_skin/captain_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/captain.dmi'
	new_icon_state = "captain"
	new_worn_icon = 'icons/mob/clothing/under/captain.dmi'

/obj/item/clothing/under/rank/captain/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/captain_uniform_skirt, infinite = TRUE)

/datum/atom_skin/captain_uniform_skirt
	abstract_type = /datum/atom_skin/captain_uniform_skirt

/datum/atom_skin/captain_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/captain.dmi'
	new_icon_state = "captain_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/captain.dmi'

/datum/atom_skin/captain_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/captain.dmi'
	new_icon_state = "captain_skirt"
	new_worn_icon = 'icons/mob/clothing/under/captain.dmi'

/obj/item/clothing/under/rank/captain/parade/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/captain_uniform_parade, infinite = FALSE)

/datum/atom_skin/captain_uniform_parade
	abstract_type = /datum/atom_skin/captain_uniform_parade
	change_base_icon_state = TRUE

/datum/atom_skin/captain_uniform_parade/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/captain.dmi'
	new_icon_state = "captain_parade"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/captain.dmi'

/datum/atom_skin/captain_uniform_parade/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/captain.dmi'
	new_icon_state = "captain_parade"
	new_worn_icon = 'icons/mob/clothing/under/captain.dmi'

// HOP

/obj/item/clothing/under/rank/civilian/head_of_personnel/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hop_uniform, infinite = FALSE)

/datum/atom_skin/hop_uniform
	abstract_type = /datum/atom_skin/hop_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/hop_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/hop.dmi'
	new_icon_state = "hop"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/hop.dmi'

/datum/atom_skin/hop_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/civilian.dmi'
	new_icon_state = "hop"
	new_worn_icon = 'icons/mob/clothing/under/civilian.dmi'

/obj/item/clothing/under/rank/civilian/head_of_personnel/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hop_uniform_skirt, infinite = FALSE)

/datum/atom_skin/hop_uniform_skirt
	abstract_type = /datum/atom_skin/hop_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/hop_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/hop.dmi'
	new_icon_state = "hop_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/hop.dmi'

/datum/atom_skin/hop_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/civilian.dmi'
	new_icon_state = "hop_skirt"
	new_worn_icon = 'icons/mob/clothing/under/civilian.dmi'

// RD

/obj/item/clothing/under/rank/rnd/research_director/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/rd_uniform, infinite = FALSE)

/datum/atom_skin/rd_uniform
	abstract_type = /datum/atom_skin/rd_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/rd_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi'
	new_icon_state = "director"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi'

/datum/atom_skin/rd_uniform/office
	preview_name = "Office fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi'
	new_icon_state = "rdwhimsy"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi'

/datum/atom_skin/rd_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "director"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/research_director/doctor_hilbert/setup_reskins()
	. = ..()
	return

/obj/item/clothing/under/rank/rnd/research_director/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/rd_uniform_skirt, infinite = FALSE)

/datum/atom_skin/rd_uniform_skirt
	abstract_type = /datum/atom_skin/rd_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/rd_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi'
	new_icon_state = "director_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi'

/datum/atom_skin/rd_uniform_skirt/office
	preview_name = "Office fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi'
	new_icon_state = "rdwhimsy_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi'

/datum/atom_skin/rd_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "director_skirt"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/research_director/turtleneck/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/rd_uniform_turtleneck, infinite = FALSE)

/datum/atom_skin/rd_uniform_turtleneck
	abstract_type = /datum/atom_skin/rd_uniform_turtleneck
	change_base_icon_state = TRUE

/datum/atom_skin/rd_uniform_turtleneck/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi'
	new_icon_state = "rdturtle"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi'

/datum/atom_skin/rd_uniform_turtleneck/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "rdturtle"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/research_director/turtleneck/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/rd_uniform_turtleneck_skirt, infinite = FALSE)

/datum/atom_skin/rd_uniform_turtleneck_skirt
	abstract_type = /datum/atom_skin/rd_uniform_turtleneck_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/rd_uniform_turtleneck_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rd.dmi'
	new_icon_state = "rdturtle_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rd.dmi'

/datum/atom_skin/rd_uniform_turtleneck_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "rdturtle_skirt"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

// HOS

/obj/item/clothing/under/rank/security/head_of_security/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_uniform, infinite = FALSE)

/datum/atom_skin/hos_uniform
	abstract_type = /datum/atom_skin/hos_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/hos_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "rhos"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/hos_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "rhos"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/head_of_security/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_uniform_skirt, infinite = FALSE)

/datum/atom_skin/hos_uniform_skirt
	abstract_type = /datum/atom_skin/hos_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/hos_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "rhos_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/hos_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "rhos_skirt"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/head_of_security/grey/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_uniform_grey, infinite = FALSE)

/datum/atom_skin/hos_uniform_grey
	abstract_type = /datum/atom_skin/hos_uniform_grey
	change_base_icon_state = TRUE

/datum/atom_skin/hos_uniform_grey/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "hos"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/hos_uniform_grey/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "hos"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/head_of_security/alt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_uniform_alt, infinite = FALSE)

/datum/atom_skin/hos_uniform_alt
	abstract_type = /datum/atom_skin/hos_uniform_alt
	change_base_icon_state = TRUE

/datum/atom_skin/hos_uniform_alt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "hosalt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/hos_uniform_alt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "hosalt"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/head_of_security/alt/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_uniform_alt_skirt, infinite = FALSE)

/datum/atom_skin/hos_uniform_alt_skirt
	abstract_type = /datum/atom_skin/hos_uniform_alt_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/hos_uniform_alt_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "hosalt_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/hos_uniform_alt_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "hosalt_skirt"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/head_of_security/parade/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_uniform_parade, infinite = FALSE)

/datum/atom_skin/hos_uniform_parade
	abstract_type = /datum/atom_skin/hos_uniform_parade
	change_base_icon_state = TRUE

/datum/atom_skin/hos_uniform_parade/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "hos_parade_male"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/hos_uniform_parade/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "hos_parade_male"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/head_of_security/parade/female/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_uniform_parade_female, infinite = FALSE)

/datum/atom_skin/hos_uniform_parade_female
	abstract_type = /datum/atom_skin/hos_uniform_parade_female
	change_base_icon_state = TRUE

/datum/atom_skin/hos_uniform_parade_female/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "hos_parade_fem"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/hos_uniform_parade_female/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "hos_parade_fem"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/head_of_security/formal/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_uniform_formal, infinite = FALSE)

/datum/atom_skin/hos_uniform_formal
	abstract_type = /datum/atom_skin/hos_uniform_formal
	change_base_icon_state = TRUE

/datum/atom_skin/hos_uniform_formal/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "hosblueclothes"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/hos_uniform_formal/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "hosblueclothes"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

// SUBORDINATE WORKERS

// SECURITY

/obj/item/clothing/under/rank/security/officer/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_officer_uniform, infinite = FALSE)

/datum/atom_skin/security_officer_uniform
	abstract_type = /datum/atom_skin/security_officer_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/security_officer_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "rsecurity"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/security_officer_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "rsecurity"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/officer/grey/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_officer_uniform_grey, infinite = FALSE)

/datum/atom_skin/security_officer_uniform_grey
	abstract_type = /datum/atom_skin/security_officer_uniform_grey
	change_base_icon_state = TRUE

/datum/atom_skin/security_officer_uniform_grey/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "security"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/security_officer_uniform_grey/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "security"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/officer/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_officer_uniform_skirt, infinite = FALSE)

/datum/atom_skin/security_officer_uniform_skirt
	abstract_type = /datum/atom_skin/security_officer_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/security_officer_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "secskirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/security_officer_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "secskirt"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/officer/blueshirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_officer_uniform_blueshirt, infinite = FALSE)

/datum/atom_skin/security_officer_uniform_blueshirt
	abstract_type = /datum/atom_skin/security_officer_uniform_blueshirt
	change_base_icon_state = TRUE

/datum/atom_skin/security_officer_uniform_blueshirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "blueshift"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/security_officer_uniform_blueshirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "blueshift"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/officer/formal/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_officer_uniform_formal, infinite = FALSE)

/datum/atom_skin/security_officer_uniform_formal
	abstract_type = /datum/atom_skin/security_officer_uniform_formal
	change_base_icon_state = TRUE

/datum/atom_skin/security_officer_uniform_formal/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "officerblueclothes"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/security_officer_uniform_formal/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "officerblueclothes"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'


// WARDEN

/obj/item/clothing/under/rank/security/warden/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_uniform, infinite = FALSE)

/datum/atom_skin/warden_uniform
	abstract_type = /datum/atom_skin/warden_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/warden_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "rwarden"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/warden_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "rwarden"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/warden/grey/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_uniform_grey, infinite = FALSE)

/datum/atom_skin/warden_uniform_grey
	abstract_type = /datum/atom_skin/warden_uniform_grey
	change_base_icon_state = TRUE

/datum/atom_skin/warden_uniform_grey/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "warden"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/warden_uniform_grey/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "warden"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/warden/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_uniform_skirt, infinite = FALSE)

/datum/atom_skin/warden_uniform_skirt
	abstract_type = /datum/atom_skin/warden_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/warden_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "rwarden_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/warden_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "rwarden_skirt"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/warden/formal/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_uniform_formal, infinite = FALSE)

/datum/atom_skin/warden_uniform_formal
	abstract_type = /datum/atom_skin/warden_uniform_formal
	change_base_icon_state = TRUE

/datum/atom_skin/warden_uniform_formal/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "wardenblueclothes"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/warden_uniform_formal/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "wardenblueclothes"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

// DETECTIVE

/obj/item/clothing/under/rank/security/detective/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/detective_uniform, infinite = FALSE)

/datum/atom_skin/detective_uniform
	abstract_type = /datum/atom_skin/detective_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/detective_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "detective_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/detective_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "detective_skirt"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/detective/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/detective_uniform_skirt, infinite = FALSE)

/datum/atom_skin/detective_uniform_skirt
	abstract_type = /datum/atom_skin/detective_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/detective_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "detective"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/detective_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "detective"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/detective/noir/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/detective_uniform_noir, infinite = FALSE)

/datum/atom_skin/detective_uniform_noir
	abstract_type = /datum/atom_skin/detective_uniform_noir
	change_base_icon_state = TRUE

/datum/atom_skin/detective_uniform_noir/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "noirdet"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/detective_uniform_noir/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "noirdet"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/detective/noir/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/detective_uniform_noir_skirt, infinite = FALSE)

/datum/atom_skin/detective_uniform_noir_skirt
	abstract_type = /datum/atom_skin/detective_uniform_noir_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/detective_uniform_noir_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/security.dmi'
	new_icon_state = "noirdet_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/security.dmi'

/datum/atom_skin/detective_uniform_noir_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/security.dmi'
	new_icon_state = "noirdet_skirt"
	new_worn_icon = 'icons/mob/clothing/under/security.dmi'


// CARGO

/obj/item/clothing/under/rank/cargo/qm/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/qm_uniform, infinite = FALSE)

/datum/atom_skin/qm_uniform
	abstract_type = /datum/atom_skin/qm_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/qm_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/cargo.dmi'
	new_icon_state = "qm"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/cargo.dmi'

/datum/atom_skin/qm_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/cargo.dmi'
	new_icon_state = "qm"
	new_worn_icon = 'icons/mob/clothing/under/cargo.dmi'

/obj/item/clothing/under/rank/cargo/qm/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/qm_uniform_skirt, infinite = FALSE)

/datum/atom_skin/qm_uniform_skirt
	abstract_type = /datum/atom_skin/qm_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/qm_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/cargo.dmi'
	new_icon_state = "qm_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/cargo.dmi'

/datum/atom_skin/qm_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/cargo.dmi'
	new_icon_state = "qm_skirt"
	new_worn_icon = 'icons/mob/clothing/under/cargo.dmi'

/obj/item/clothing/under/rank/cargo/tech/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/cargotech_uniform, infinite = FALSE)

/datum/atom_skin/cargotech_uniform
	abstract_type = /datum/atom_skin/cargotech_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/cargotech_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/cargo.dmi'
	new_icon_state = "cargotech"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/cargo.dmi'

/datum/atom_skin/cargotech_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/cargo.dmi'
	new_icon_state = "cargotech"
	new_worn_icon = 'icons/mob/clothing/under/cargo.dmi'

/obj/item/clothing/under/rank/cargo/tech/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/cargotech_uniform_skirt, infinite = FALSE)

/datum/atom_skin/cargotech_uniform_skirt
	abstract_type = /datum/atom_skin/cargotech_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/cargotech_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/cargo.dmi'
	new_icon_state = "cargo_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/cargo.dmi'

/datum/atom_skin/cargotech_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/cargo.dmi'
	new_icon_state = "cargo_skirt"
	new_worn_icon = 'icons/mob/clothing/under/cargo.dmi'


// MEDICAL

/obj/item/clothing/under/rank/medical/doctor/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/doctor_uniform, infinite = FALSE)

/datum/atom_skin/doctor_uniform
	abstract_type = /datum/atom_skin/doctor_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/doctor_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi'
	new_icon_state = "medical"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi'

/datum/atom_skin/doctor_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/medical.dmi'
	new_icon_state = "medical"
	new_worn_icon = 'icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/rank/medical/doctor/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/doctor_uniform_skirt, infinite = FALSE)

/datum/atom_skin/doctor_uniform_skirt
	abstract_type = /datum/atom_skin/doctor_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/doctor_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi'
	new_icon_state = "medical_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi'

/datum/atom_skin/doctor_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/medical.dmi'
	new_icon_state = "medical_skirt"
	new_worn_icon = 'icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/rank/medical/chief_medical_officer/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/cmo_uniform, infinite = FALSE)

/datum/atom_skin/cmo_uniform
	abstract_type = /datum/atom_skin/cmo_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/cmo_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi'
	new_icon_state = "cmo"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi'

/datum/atom_skin/cmo_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/medical.dmi'
	new_icon_state = "cmo"
	new_worn_icon = 'icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/rank/medical/chief_medical_officer/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/cmo_uniform_skirt, infinite = FALSE)

/datum/atom_skin/cmo_uniform_skirt
	abstract_type = /datum/atom_skin/cmo_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/cmo_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi'
	new_icon_state = "cmo_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi'

/datum/atom_skin/cmo_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/medical.dmi'
	new_icon_state = "cmo_skirt"
	new_worn_icon = 'icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/rank/medical/chief_medical_officer/scrubs/setup_reskins()
	. = ..()
	return

/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/setup_reskins()
	. = ..()
	return

/obj/item/clothing/under/rank/medical/virologist/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/virologist_uniform, infinite = FALSE)

/datum/atom_skin/virologist_uniform
	abstract_type = /datum/atom_skin/virologist_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/virologist_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi'
	new_icon_state = "virology"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi'

/datum/atom_skin/virologist_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/medical.dmi'
	new_icon_state = "virology"
	new_worn_icon = 'icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/rank/medical/virologist/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/virologist_uniform_skirt, infinite = FALSE)

/datum/atom_skin/virologist_uniform_skirt
	abstract_type = /datum/atom_skin/virologist_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/virologist_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi'
	new_icon_state = "virologywhite_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi'

/datum/atom_skin/virologist_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/medical.dmi'
	new_icon_state = "virologywhite_skirt"
	new_worn_icon = 'icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/rank/medical/chemist/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/chemist_uniform, infinite = FALSE)

/datum/atom_skin/chemist_uniform
	abstract_type = /datum/atom_skin/chemist_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/chemist_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi'
	new_icon_state = "chemistry"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi'

/datum/atom_skin/chemist_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/medical.dmi'
	new_icon_state = "chemistry"
	new_worn_icon = 'icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/rank/medical/chemist/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/chemist_uniform_skirt, infinite = FALSE)

/datum/atom_skin/chemist_uniform_skirt
	abstract_type = /datum/atom_skin/chemist_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/chemist_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/medical.dmi'
	new_icon_state = "chemistrywhite_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/medical.dmi'

/datum/atom_skin/chemist_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/medical.dmi'
	new_icon_state = "chemistrywhite_skirt"
	new_worn_icon = 'icons/mob/clothing/under/medical.dmi'


// SCIENCE

/obj/item/clothing/under/rank/rnd/scientist/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/scientist_uniform, infinite = FALSE)

/datum/atom_skin/scientist_uniform
	abstract_type = /datum/atom_skin/scientist_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/scientist_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi'
	new_icon_state = "science"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi'

/datum/atom_skin/scientist_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "science"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/scientist/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/scientist_uniform_skirt, infinite = FALSE)

/datum/atom_skin/scientist_uniform_skirt
	abstract_type = /datum/atom_skin/scientist_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/scientist_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi'
	new_icon_state = "science_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi'

/datum/atom_skin/scientist_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "science_skirt"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/roboticist/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/roboticist_uniform, infinite = FALSE)

/datum/atom_skin/roboticist_uniform
	abstract_type = /datum/atom_skin/roboticist_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/roboticist_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi'
	new_icon_state = "robotics"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi'

/datum/atom_skin/roboticist_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "robotics"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/roboticist/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/roboticist_uniform_skirt, infinite = FALSE)

/datum/atom_skin/roboticist_uniform_skirt
	abstract_type = /datum/atom_skin/roboticist_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/roboticist_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi'
	new_icon_state = "robotics_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi'

/datum/atom_skin/roboticist_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "robotics_skirt"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/geneticist/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/geneticist_uniform, infinite = FALSE)

/datum/atom_skin/geneticist_uniform
	abstract_type = /datum/atom_skin/geneticist_uniform
	change_base_icon_state = TRUE

/datum/atom_skin/geneticist_uniform/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi'
	new_icon_state = "genetics"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi'

/datum/atom_skin/geneticist_uniform/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "genetics"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/geneticist/skirt/setup_reskins()
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/geneticist_uniform_skirt, infinite = FALSE)

/datum/atom_skin/geneticist_uniform_skirt
	abstract_type = /datum/atom_skin/geneticist_uniform_skirt
	change_base_icon_state = TRUE

/datum/atom_skin/geneticist_uniform_skirt/old
	preview_name = "Old fashioned"
	new_icon = 'modular_meta/features/more_clothes/icons/items/under/rnd.dmi'
	new_icon_state = "genetics_skirt"
	new_worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/under/rnd.dmi'

/datum/atom_skin/geneticist_uniform_skirt/default
	preview_name = "Original"
	new_icon = 'icons/obj/clothing/under/rnd.dmi'
	new_icon_state = "genetics_skirt"
	new_worn_icon = 'icons/mob/clothing/under/rnd.dmi'

