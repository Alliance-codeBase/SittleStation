/obj/effect/spawner/random/armory/laser_gun

/obj/effect/spawner/random/armory/laser_gun/spawn_loot(lootcount_override)
	. = ..()
	new /obj/item/ammo_box/magazine/recharge(get_turf(src))
	new /obj/item/gun/ballistic/automatic/laser/station(get_turf(src))

/obj/machinery/vending/autodrobe/Initialize(mapload)
	.=..()
	premium += list(
		/obj/item/melee/tonfa = 1,
	)
