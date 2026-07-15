/obj/effect/spawner/random/armory/laser_gun
	name = "laser gun and security rifle spawner"

/obj/effect/spawner/random/armory/laser_gun/spawn_loot(lootcount_override)
	. = ..()
	new /obj/item/ammo_box/magazine/recharge(get_turf(src))
	new /obj/item/gun/ballistic/automatic/laser/station(get_turf(src))

/obj/machinery/vending/security/Initialize(mapload)
	.=..()
	premium += list(
		/obj/item/melee/tonfa = 1,
	)

/obj/effect/spawner/random/armory/riot_shield
	name = "riot shield and tonfa spawner"

/obj/effect/spawner/random/armory/riot_shield/spawn_loot(lootcount_override)
	. = ..()
	new /obj/item/melee/tonfa(get_turf(src))
	new /obj/item/melee/tonfa(get_turf(src))
	if(prob(11)) //who stole my tonfa?!
		new /obj/item/melee/tonfa(get_turf(src))
