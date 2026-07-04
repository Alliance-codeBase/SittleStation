/obj/item/gun/ballistic/automatic/laser/station/syndicate
	name = "laser rifle"
	desc = "Seems like an illegal and deadly weapon. Has a 'Cybersun' marking."
	projectile_damage_multiplier = 1
	icon = 'modular_meta/features/uplink_items/icons/weapon/lrifle.dmi'

/obj/item/gun/ballistic/automatic/laser/station/syndicate/compact
	name = "compact laser rifle"
	var/folded = FALSE

/obj/item/gun/ballistic/automatic/laser/station/syndicate/compact/update_icon_state()
	. = ..()
	if(folded)
		icon_state = "laser_rifle_folded"
		base_icon_state = "laser_rifle_folded"
	else
		icon_state = "laser_rifle"
		base_icon_state = "laser_rifle"

/obj/item/gun/ballistic/automatic/laser/station/syndicate/compact/click_alt(mob/user)
	if(!user.can_perform_action(src, ALLOW_SILICON_REACH))
		return CLICK_ACTION_BLOCKING

	user.changeNext_move(CLICK_CD_MELEE)

	if(!folded)
		folded = TRUE
		w_class = WEIGHT_CLASS_NORMAL
		spread = 30
		icon_state = "laser_rifle_folded"
		base_icon_state = "laser_rifle_folded"
		balloon_alert(user, "folded")
		playsound(src, 'sound/items/weapons/gun/l6/l6_rack.ogg', 50, TRUE)
	else
		folded = FALSE
		w_class = WEIGHT_CLASS_BULKY
		spread = 0
		icon_state = "laser_rifle"
		base_icon_state = "laser_rifle"
		balloon_alert(user, "deployed")
		playsound(src, 'sound/items/weapons/gun/l6/l6_door.ogg', 50, TRUE)

	update_appearance()
	if(ismob(loc))
		var/mob/living/M = loc
		M.update_held_items()

	return CLICK_ACTION_SUCCESS

/obj/item/gun/ballistic/automatic/laser/station/syndicate/compact/guncase
	folded = TRUE
	spread = 30
	spawn_magazine_type = /obj/item/ammo_box/magazine/recharge/station/syndi
