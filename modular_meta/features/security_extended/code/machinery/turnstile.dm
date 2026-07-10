/obj/machinery/turnstile
	name = "turnstile"
	desc = "A mechanical door that permits one-way access to an area."
	icon = 'modular_meta/features/security_extended/icons/objects.dmi'
	icon_state = "turnstile_map"
	power_channel = AREA_USAGE_ENVIRON
	density = TRUE
	max_integrity = 250
	armor_type = /datum/armor/machinery_turnstile
	anchored = TRUE
	use_power = FALSE
	idle_power_usage = 2
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = OPEN_DOOR_LAYER

/datum/armor/machinery_turnstile
	melee = 50
	bullet = 20
	laser = 0
	energy = 80
	bomb = 10
	fire = 90
	acid = 50

/obj/machinery/turnstile/Initialize(mapload)
	. = ..()
	icon_state = "turnstile"

/obj/machinery/turnstile/can_atmos_pass(turf/target_turf, vertical = FALSE)
	return TRUE

/obj/machinery/turnstile/Cross(atom/movable/mover)
	. = ..()
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return TRUE
	if(istype(mover, /mob/living/simple_animal/bot))
		flick("operate", src)
		playsound(src,'sound/items/tools/ratchet.ogg',50,0,3)
		return TRUE
	else if (!isliving(mover) && !istype(mover, /obj/vehicle/ridden/wheelchair))
		flick("deny", src)
		playsound(src,'sound/machines/beep/deniedbeep.ogg',50,0,3)
		return FALSE
	var/allowed = allowed(mover)
	if(!allowed && mover.pulledby)
		allowed = allowed(mover.pulledby)

	if(istype(mover, /obj/vehicle/ridden/wheelchair))
		for(var/mob/living/rider in mover.buckled_mobs)
			if(allowed(rider) && !mover.pulledby)
				allowed = TRUE
	var/is_handcuffed = FALSE
	if(iscarbon(mover))
		var/mob/living/carbon/C = mover
		is_handcuffed = C.handcuffed
	if((get_dir(loc, mover.loc) == dir && !is_handcuffed) || allowed)
		flick("operate", src)
		playsound(src,'sound/items/tools/ratchet.ogg',50,0,3)
		return TRUE
	else
		flick("deny", src)
		playsound(src,'sound/machines/beep/deniedbeep.ogg',50,0,3)
		return FALSE

/obj/machinery/turnstile/brig
	name = "brig turnstile"
	req_access = list(ACCESS_SECURITY)
	max_integrity = 350
	damage_deflection = 16
