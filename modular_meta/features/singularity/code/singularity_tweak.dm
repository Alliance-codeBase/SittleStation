/obj/singularity
	invisibility = INVISIBILITY_MAXIMUM

/obj/singularity/Initialize(mapload, starting_energy = 50)
	. = ..()

	new /obj/effect/singularity_creation(loc)

	addtimer(CALLBACK(src, PROC_REF(make_visible)), SINGULARITY_EFFECT_ANIM_TIME)

/obj/singularity/emp_area()
	empulse(src, 5, 8)

/obj/energy_ball/var/static/list/things_to_shock = zebra_typecacheof(list(
	/obj/machinery/particle_accelerator/control_box = FALSE,
	/obj/structure/particle_accelerator/fuel_chamber = FALSE,
	/obj/structure/particle_accelerator/particle_emitter/center = FALSE,
	/obj/structure/particle_accelerator/particle_emitter/left = FALSE,
	/obj/structure/particle_accelerator/particle_emitter/right = FALSE,
	/obj/structure/particle_accelerator/power_box = FALSE,
	/obj/structure/particle_accelerator/end_cap = FALSE,
))

/obj/machinery/field/generator
	var/shield_floor = TRUE

/obj/singularity/dissipate(seconds_per_tick)
	time_since_last_dissipiation += seconds_per_tick SECONDS
