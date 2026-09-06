/obj/item/ammo_casing/shotgun/improvised
	name = "improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards."
	icon_state = "improvshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_improvised
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*2.5)
	pellets = 10
	variance = 25

/obj/item/ammo_casing/shotgun/scatterlaser
	name = "scatter laser shell"
	desc = "An advanced shotgun shell that uses a micro laser to replicate the effects of a scatter laser weapon in a ballistic package."
	icon_state = "lshell"
	projectile_type = /obj/projectile/beam/scatter
	pellets = 6
	variance = 35


/obj/item/ammo_box/magazine/internal/boltaction/pipegun/is_compatible_round(obj/item/ammo_casing/new_round)
	if(!new_round || !(caliber ? (caliber == new_round.caliber || istype(new_round, /obj/item/ammo_casing/shotgun/improvised)) : (ammo_type == new_round.type)))
		return FALSE
	return TRUE
