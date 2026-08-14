/obj/item/gun/ballistic/automatic/laser/station //damage slightly worse than egun has but it has rechargeable magazine
	name = "security laser rifle"
	projectile_damage_multiplier = 0.9
	projectile_speed_multiplier = 1.2
	icon = 'modular_meta/features/security_extended/icons/guns.dmi'
	icon_state = "laser_rifle"
	worn_icon = 'modular_meta/features/security_extended/icons/guns.dmi'
	worn_icon_state = "rifle_onback"
	base_icon_state = "laser_rifle"
	fire_delay = 0

/obj/item/ammo_box/magazine/recharge/station
	w_class = WEIGHT_CLASS_SMALL
	max_ammo = 16
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/silver = SHEET_MATERIAL_AMOUNT, /datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)

/obj/item/ammo_box/magazine/recharge/station/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		stored_ammo = list(0)
		update_desc()
	return TRUE

/obj/item/ammo_box/magazine/recharge/station/stun
	name = "stun type power pack"
	desc = "A rechargeable, non-lethal, detachable battery that serves as a magazine for laser rifles."
	ammo_type = /obj/item/ammo_casing/laser/stun
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/ammo_casing/laser/stun
	projectile_type = /obj/projectile/beam/disabler
	harmful = FALSE
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/blue

/obj/item/ammo_box/magazine/recharge/station/scatter
	name = "scatter type power pack"
	ammo_type = /obj/item/ammo_casing/laser/scatter
	max_ammo = 8
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 2, /datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.5)

/obj/item/ammo_casing/laser/scatter
	projectile_type = /obj/projectile/beam/scatter/ldmg
	pellets = 7
	variance = 35

/obj/projectile/beam/scatter/ldmg
	damage = 4
