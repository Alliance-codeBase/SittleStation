/obj/item/ammo_box/magazine/recharge/station/syndi
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles. Has a 'Cybersun' trademark."
	ammo_type = /obj/item/ammo_casing/laser/lrifle_cybersun

/obj/item/ammo_casing/laser/lrifle_cybersun
	projectile_type = /obj/projectile/beam/laser/lrifle_cybersun
	fire_sound = 'sound/items/weapons/laser2.ogg'
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect

/obj/projectile/beam/laser/lrifle_cybersun
	name = "red plasma beam"
	icon_state = "lava"
	light_color = COLOR_DARK_RED
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	damage = 20
	wound_bonus = -30
