/datum/supply_pack/security/armory/slrifle
	name = "Security Laser Rifle Crate"
	desc = "Contains single Security Laser Rifle and powerpack to it. Developed by Research Nanotrasen group. \
		For security department, ."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/gun/ballistic/automatic/laser/security = 1, /obj/item/ammo_box/magazine/recharge = 2)
	crate_name = "security laser rifle crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/slr_ammo
	name = "Security Laser Rifle Ammo Crate"
	desc = "Contains a bunch of types powerpacks, that can be putted \
		in the Security Laser Rifle."
	cost = CARGO_CRATE_VALUE * 6.5
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/ammo_box/magazine/recharge = 3,
					/obj/item/ammo_box/magazine/recharge/stun = 1,
					/obj/item/ammo_box/magazine/recharge/scatter = 1,
				)
	crate_name = "ammo crate"

/datum/supply_pack/security/tonfa
	name = "Poilice Tonfa Crate"
	desc = "Arm the Civil Protection Forces with three police tonfa."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/melee/tonfa = 3)
	crate_name = "police tonfa crate"
