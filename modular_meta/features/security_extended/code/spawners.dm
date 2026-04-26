/obj/effect/spawner/random/armory/laser_gun

/obj/effect/spawner/random/armory/laser_gun/spawn_loot(lootcount_override)
	. = ..()
	new /obj/item/ammo_box/magazine/recharge(get_turf(src))
	new /obj/item/gun/ballistic/automatic/laser/security(get_turf(src))

/obj/effect/spawner/random/baton_or_tonfa
	name = "baton or tonfa spawner"
	loot = list(
		/obj/item/melee/baton/security/loaded = 2,
		/obj/item/melee/tonfa = 1,
	)

/obj/item/storage/belt/security/full/PopulateContents()
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/effect/spawner/random/baton_or_tonfa(src)
	update_appearance()
