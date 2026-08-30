/datum/smite/headburst
	name = "Inflate Head"

/datum/smite/headburst/effect(client/user, mob/living/target)
	. = ..()
	var/datum/action/cooldown/spell/pointed/headburst/spell = new

	if (!iscarbon(target))
		to_chat(user, span_warning("This must be used on a carbon mob."), confidential = TRUE)
		return

	var/mob/living/carbon/carbon_target = target

	if (carbon_target.stat == DEAD)
		to_chat(user, span_warning("Target must be alive."), confidential = TRUE)
		return

	spell.cast(target)
