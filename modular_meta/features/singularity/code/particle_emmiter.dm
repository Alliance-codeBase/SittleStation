/obj/structure/particle_accelerator/particle_emitter
	name = "EM Containment Grid"
	desc = "This launches the Alpha particles, might not want to stand near this end."
	icon = 'modular_meta/features/singularity/icons/particle_accelerator.dmi'
	icon_state = "none"
	var/fire_delay = 5 SECONDS

	COOLDOWN_DECLARE(fire_delay_cooldown)

/obj/structure/particle_accelerator/particle_emitter/center
	icon_state = "emitter_center"
	reference = "emitter_center"

/obj/structure/particle_accelerator/particle_emitter/left
	icon_state = "emitter_left"
	reference = "emitter_left"

/obj/structure/particle_accelerator/particle_emitter/right
	icon_state = "emitter_right"
	reference = "emitter_right"

/obj/structure/particle_accelerator/particle_emitter/proc/set_delay(delay)
	if(delay)
		fire_delay = delay
		return TRUE
	return FALSE

/obj/structure/particle_accelerator/particle_emitter/proc/emit_particle(strength)
	if(COOLDOWN_FINISHED(src, fire_delay_cooldown))
		var/turf/T = get_turf(src)
		var/obj/effect/accelerated_particle/P
		switch(strength)
			if(PARTICLE_STRENGTH_WEAK)
				P = new/obj/effect/accelerated_particle/weak(T)
			if(PARTICLE_STRENGTH_NORMAL)
				P = new/obj/effect/accelerated_particle(T)
			if(PARTICLE_STRENGTH_STRONG)
				P = new/obj/effect/accelerated_particle/strong(T)
			if(PARTICLE_STRENGTH_MAX)
				P = new/obj/effect/accelerated_particle/powerful(T)
				new /obj/effect/particle_effect/sparks/quantum (T)
				radiation_pulse(src, max_range = 3, threshold = RAD_EXTREME_INSULATION)
		P.setDir(dir)
		COOLDOWN_START(src, fire_delay_cooldown, fire_delay)
		return TRUE
	return FALSE
