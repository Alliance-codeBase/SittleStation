/obj/item/deployable_vehicle
	name = "CULD Neptune-B"
	desc = "A small remote-controllable vehicle, ready to be deployed."
	icon = 'modular_meta/features/unmanned_vechicle/icons/unmanned_vehicles.dmi'
	icon_state = "light_uv_folded"
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 100
	var/deployable_item = /obj/vehicle/unmanned/deployable
	var/deploy_time = 10
	var/undeploy_time = 10

/obj/item/deployable_vehicle/Initialize(mapload)
	. = ..()

/obj/item/deployable_vehicle/attack_self(mob/user)
	if(!deployable_item)
		return
	to_chat(user, span_notice("You start deploying [src]..."))
	if(do_after(user, deploy_time, target = user))
		var/obj/vehicle/unmanned/deployable/spawned_drone = new deployable_item(user.drop_location(), src, user)
		if(spawned_drone)
			to_chat(user, span_notice("You successfully deploy [spawned_drone.name]."))
			src.forceMove(spawned_drone)

/obj/vehicle/unmanned/deployable
	name = "CULD Neptune-B"
	desc = "A small remote-controllable vehicle. Configured to be foldable."
	var/obj/item/deployable_vehicle/internal_item
	var/item_pack_type = /obj/item/deployable_vehicle

/obj/vehicle/unmanned/deployable/Initialize(mapload, _internal_item, mob/deployer)
	. = ..()
	if(_internal_item)
		internal_item = _internal_item
	else if(loc && istype(loc, /obj/item/deployable_vehicle))
		internal_item = loc

	if(internal_item)
		atom_integrity = internal_item.atom_integrity

/obj/vehicle/unmanned/deployable/Destroy()
	if(internal_item)
		qdel(internal_item)
	return ..()

/obj/vehicle/unmanned/deployable/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(user.incapacitated)
		return

	to_chat(user, span_notice("You start folding [src] back..."))
	if(do_after(user, 10, target = src))
		var/turf/drop_turf = drop_location()
		var/list/items_to_drop = list()

		if(src.contents)
			items_to_drop += src.contents.Copy()
		if(src.vis_contents)
			items_to_drop += src.vis_contents.Copy()

		if(drop_turf)
			for(var/atom/movable/AM in drop_turf)
				if(AM == src || AM == internal_item)
					continue
				if(AM.vars && ("target" in AM.vars) && AM.vars["target"] == src)
					items_to_drop += AM

		for(var/atom/movable/AM in items_to_drop)
			if(AM == internal_item)
				continue

			if(AM.vars && ("target" in AM.vars) && AM.vars["target"] == src)
				AM.vars["target"] = null

			AM.forceMove(drop_turf)

			SEND_SIGNAL(AM, COMSIG_MOVABLE_MOVED, drop_turf)

			src.vis_contents -= AM
			src.overlays -= AM

		src.cut_overlays()

		if(!internal_item)
			internal_item = new item_pack_type(src)

		if(internal_item)
			internal_item.forceMove(drop_turf)
			internal_item.atom_integrity = atom_integrity
			to_chat(user, span_notice("You pack [src] into [internal_item.name]."))
			internal_item = null

		qdel(src)

/obj/item/deployable_vehicle/tiny
	name = "CULD-T Pluto"
	desc = "A tiny remote-controllable vehicle, ready to be deployed."
	icon_state = "tiny_uv_folded"
	max_integrity = 25
	w_class = WEIGHT_CLASS_SMALL
	deployable_item = /obj/vehicle/unmanned/deployable/tiny

/obj/vehicle/unmanned/deployable/tiny
	name = "CULD-T Pluto"
	icon_state = "tiny_uv"
	vehicle_move_delay = 1.5
	density = FALSE
	hud_possible = list(DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_TRACK_HUD, DIAG_CAMERA_HUD)
	armor_type = /datum/armor/tiny_drone
	unmanned_flags = 1
	item_pack_type = /obj/item/deployable_vehicle/tiny

/datum/armor/tiny_drone
	melee = 25
	bullet = 25
	laser = 25
	energy = 25
	bomb = 25
	fire = 25
	acid = 25
