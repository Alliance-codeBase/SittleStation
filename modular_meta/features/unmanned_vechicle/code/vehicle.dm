/obj/vehicle/unmanned
	name = "CULD Neptune"
	desc = "A small remote-controllable vehicle. Seems like you can't place anything on it."
	icon = 'modular_meta/features/unmanned_vechicle/icons/unmanned_vehicles.dmi'
	icon_state = "light_uv"
	anchored = FALSE
	light_range = 2
	light_power = 0.75
	max_integrity = 100
	hud_possible = list(DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_TRACK_HUD, DIAG_CAMERA_HUD)

	var/next_vehicle_move_delay = 0
	var/vehicle_move_delay = 2
	var/can_interact = FALSE
	var/fire_delay = 5
	var/static/serial = 1
	var/controlled = FALSE
	var/unmanned_flags = 2

/datum/armor/unmanned_drone
	melee = 25
	bullet = 85
	laser = 85
	energy = 85
	bomb = 50
	fire = 25
	acid = 25

/obj/vehicle/unmanned/Initialize(mapload, _internal_item, mob/deployer)
	. = ..()
	name += " " + num2text(serial)
	serial++

	var/datum/atom_hud/diag_hud = GLOB.huds[DATA_HUD_DIAGNOSTIC]
	if(diag_hud)
		if(diag_hud.hud_atoms)
			diag_hud.hud_atoms += src

/obj/vehicle/unmanned/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, blocked)
	. = ..()

/obj/vehicle/unmanned/repair_damage(repair_amount)
	. = ..()

/obj/vehicle/unmanned/atom_destruction(damage_flag)
	do_sparks(3, TRUE, src)
	playsound(src, 'sound/effects/sparks/sparks4.ogg', 60, TRUE)
	new /obj/item/stack/sheet/iron(loc, 2)

	if(has_buckled_mobs())
		unbuckle_all_mobs(force = TRUE)

	SEND_SIGNAL(src, COMSIG_ATOM_DESTRUCTION, damage_flag)

	var/turf/T = drop_location()
	for(var/atom/movable/AM in src)
		if(AM.flags_1 & INITIALIZED_1)
			AM.forceMove(T)
			if(isitem(AM))
				var/obj/item/I = AM
				I.throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), 1, 1)

	return ..()

/obj/vehicle/unmanned/relaymove(mob/living/user, direction)
	if(world.time < next_vehicle_move_delay)
		return FALSE

	. = Move(get_step(src, direction))

	next_vehicle_move_delay = world.time + vehicle_move_delay
	return .

/obj/vehicle/unmanned/proc/on_link(atom/remote_controller)
	controlled = TRUE

/obj/vehicle/unmanned/proc/on_unlink(atom/remote_controller)
	controlled = FALSE

/obj/vehicle/unmanned/fire_act(burn_level)
	take_damage(burn_level / 2, BURN, FIRE)

/obj/vehicle/unmanned/Bump(atom/A)
	..()
	if(!istype(A, /obj/machinery/door/airlock))
		return

	var/obj/machinery/door/airlock/airlock = A

	if(airlock.density == FALSE)
		return

	if(airlock.req_access && length(airlock.req_access))
		return
	if(airlock.req_one_access && length(airlock.req_one_access))
		return

	if(airlock.welded || airlock.locked || (airlock.machine_stat & NOPOWER))
		return

	airlock.open()
