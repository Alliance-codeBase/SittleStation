/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen
	name = "Gravitational Singularity Generator"
	desc = "An odd device which produces a Gravitational Singularity when set up."
	icon = 'modular_meta/features/singularity/icons/gensing.dmi'
	icon_state = "TheSingGen"
	anchored = FALSE
	density = TRUE
	use_power = NO_POWER_USE
	resistance_flags = FIRE_PROOF

	// You can buckle someone to the singularity generator, then start the engine. Fun!
	can_buckle = TRUE
	buckle_lying = FALSE
	buckle_requires_restraints = TRUE

	var/energy = 0
	var/creation_type = /obj/singularity
	var/required_energy = ENERGY_REQ_SINGULARITY_CREATION

/obj/machinery/the_singularitygen/attackby(obj/item/weapon, mob/user, params)
	if(weapon.tool_behaviour == TOOL_WRENCH)
		default_unfasten_wrench(user, weapon, 0)
	else
		return ..()

/obj/machinery/the_singularitygen/process()
	if(energy)
		if(energy >= required_energy)
			var/turf/T = get_turf(src)
			SSblackbox.record_feedback("tally", "engine_started", 1, type)
			var/obj/singularity/S = new creation_type(T, 50)
			transfer_fingerprints_to(S)
			qdel(src)
		else
			energy--
