/obj/item/gun/energy/plasmacutter/adv/i_cutter
	name = "I.C. Tool"
	description = "Isaac's Cutting Tool, or IC Tool, has 2 modes: slashing and cutting, slashing uses a lot of energy but can make tunnels fast, while cutting shoots 3 weak lasers that REALLY good at dismembering target, cutting has low range but great mining ability, while slashing is a rock crushing blast."
	icon_state = "adv_plasmacutter"
	inhand_icon_state = "adv_plasmacutter"
	wound_bonus = 15
	ammo_type = list(/obj/projectile/plasma/adv/slash, /obj/projectile/plasma/adv/cut)

/obj/item/ammo_casing/energy/plasma/adv/slash
	projectile_type = /obj/projectile/plasma/adv/slash
	delay = 50
	e_cost = LASER_SHOTS(4, STANDARD_CELL_CHARGE)

/obj/item/ammo_casing/energy/plasma/adv/cut
	projectile_type = /obj/projectile/plasma/adv/cut
	delay = 16
	pellets = 3
	variance = 20
	e_cost = LASER_SHOTS(10, STANDARD_CELL_CHARGE)

/obj/effect/projectile/tracer/plasma/adv/slash
	name = "slash"
	icon_state = "u_laser"

/obj/effect/projectile/tracer/plasma/adv/cut
	name = "cut"
	icon_state = "xray"

/obj/projectile/plasma/adv/slash
	damage = 5
	range = 20
	mine_range = 20
	wound_bonus = 0
	speed = 1.6
	tracer_type = /obj/effect/projectile/tracer/plasma/adv/slash
	damage_type = BRUTE
	dismemberment = 0

/obj/projectile/plasma/adv/cut
	damage = 5
	range = 8
	mine_range = 10
	wound_bonus = 6
	speed = 0.8
	tracer_type = /obj/effect/projectile/tracer/plasma/adv/cut
	damage_type = BURN
	dismemberment = 15
