/datum/action/cooldown/spell/pointed/headburst
	name = "Headburster"
	desc = "After a brief wait sends a deadly beam capable of bursting your target's head"
	cooldown_time = 20 SECONDS
	cast_range = 10
	invocation = "H'D BR'ST!!"
	invocation_type = INVOCATION_SHOUT
	sparks_amt = 3
	spell_max_level = 3
	//sound =
	//icon = ''
	//icon_state = ""

/datum/action/cooldown/spell/pointed/headburst/is_valid_target(atom/cast_on)
	. = ..()

	if(!.)
		return FALSE

	var/mob/living/carbon/carbon_target = cast_on
	var/head = carbon_target.get_bodypart(BODY_ZONE_HEAD)
	var/are_we_dead_ass = carbon_target.stat == DEAD
	var/harsey = carbon_target.dna?.check_mutation(/datum/mutation/headless) == /datum/mutation/headless

	if(are_we_dead_ass)
		owner.balloon_alert(owner, "They're dead!")
		return FALSE

	if(isnull(head) || harsey)
		if(prob(5))
			owner.balloon_alert(owner, "No head, rip :(")
		else
			owner.balloon_alert(owner, "No head!")
		return FALSE

	if(!target) // liminal spaces
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/headburst/before_cast(atom/cast_on)
	. = ..()
	var/beam_time = 10 SECONDS
	var/datum/beam/beam = owner.Beam(cast_on, "r_beam", 'icons/effects/beam.dmi', beam_time, layer = ABOVE_ALL_MOB_LAYER)
	if(!do_after(owner, beam_time, cast_on, IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM | IGNORE_SLOWDOWNS, extra_checks = CALLBACK(src, PROC_REF(range_check), owner, cast_on), hidden = TRUE))
		qdel(beam)
		owner.balloon_alert(owner, "Out of range!")
		return SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/pointed/headburst/proc/range_check(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/caster_loc = user.loc
	var/target_loc = target.loc
	var/max_cast_range = round((spell_level + 1) ** 2.3)
	if(get_dist(caster_loc, target_loc) >= max_cast_range)
		return FALSE

	return TRUE

