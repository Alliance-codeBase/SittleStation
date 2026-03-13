/obj/effect/accelerated_particle
	name = "Accelerated Particles"
	desc = "Small things moving very fast."
	icon = 'modular_meta/features/singularity/icons/particle_accelerator.dmi'
	icon_state = "particle"
	anchored = TRUE
	density = FALSE
	var/movement_range = 10
	var/energy = 10
	var/speed = 1

/obj/effect/accelerated_particle/weak
	movement_range = 8
	energy = 5

/obj/effect/accelerated_particle/strong
	movement_range = 15
	energy = 15

/obj/effect/accelerated_particle/powerful
	movement_range = 20
	energy = 50


/obj/effect/accelerated_particle/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(move)), 1)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)


/obj/effect/accelerated_particle/Bump(atom/bumped_atom)
	if(bumped_atom)
		if(isliving(bumped_atom))
			toxmob(bumped_atom)
		else if(istype(bumped_atom, /obj/machinery/the_singularitygen))
			var/obj/machinery/the_singularitygen/the_singularitygen = bumped_atom
			the_singularitygen.energy += energy
		else if(istype(bumped_atom, /obj/singularity))
			var/obj/singularity/singularity = bumped_atom
			singularity.energy += energy
		else if(istype(bumped_atom, /obj/energy_ball))
			var/obj/energy_ball/energy_ball = bumped_atom
			energy_ball.energy += energy
		else if(istype(bumped_atom, /obj/structure/blob))
			var/obj/structure/blob/blob = bumped_atom
			blob.take_damage(energy * 0.6)
			movement_range = 0

/obj/effect/accelerated_particle/proc/on_entered(datum/source, atom/movable/movable_atom)
	SIGNAL_HANDLER
	if(isliving(movable_atom))
		toxmob(movable_atom)


/obj/effect/accelerated_particle/ex_act(severity, target)
	qdel(src)

/obj/effect/accelerated_particle/singularity_pull()
	return

/obj/effect/accelerated_particle/singularity_act()
	return

/obj/effect/accelerated_particle/proc/toxmob(mob/living/target_mob)
	to_chat(target_mob, span_green("Your body tingles as the accelerated particles pass through you."))
	target_mob.adjust_tox_loss(energy / 10)

/obj/effect/accelerated_particle/proc/move()
	if(QDELETED(src))
		return
	if(!step(src, dir))
		forceMove(get_step(src, dir))
	movement_range--
	if(!movement_range)
		qdel(src)
	else
		addtimer(CALLBACK(src, PROC_REF(move)), speed, TIMER_STOPPABLE)
