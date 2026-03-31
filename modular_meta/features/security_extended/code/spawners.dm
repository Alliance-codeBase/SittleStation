/obj/effect/spawner/random/armory/laser_gun

/obj/effect/spawner/random/armory/laser_gun/spawn_loot(lootcount_override)
	. = ..()
	new /obj/item/ammo_box/magazine/recharge(get_turf(src))
	new /obj/item/gun/ballistic/automatic/laser/security(get_turf(src))
