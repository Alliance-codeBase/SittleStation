// ORIGINAL FILE: code/datums/wounds/slash.dm
//modular override for self-licking, for some reason you CAN lick someone else's wound, but can't do the same for yourself..
// fixes being unable to lick-self your bleeding wounds as felinids
/datum/wound/slash/flesh/try_handling(mob/living/user)
	var/self_licking = (user == victim)
	if((!self_licking && user.pulling != victim) || !HAS_TRAIT(user, TRAIT_WOUND_LICKER) || !victim.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		return FALSE
	if(!isnull(user.hud_used?.zone_select) && user.zone_selected != limb.body_zone)
		return FALSE

	if(DOING_INTERACTION_WITH_TARGET(user, victim))
		to_chat(user, span_warning("You're already interacting with [victim]!"))
		return
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		if(carbon_user.is_mouth_covered())
			to_chat(user, span_warning("Your mouth is covered, you can't lick [victim]'s wounds!"))
			return
		if(!carbon_user.get_organ_slot(ORGAN_SLOT_TONGUE))
			to_chat(user, span_warning("You can't lick wounds without a tongue!"))
			return

	lick_wounds(user)
	return TRUE

/datum/wound/slash/flesh/proc/disease_chance(mob/living/target)
	if(isfelinid(target))
		return 15 // all cats are friends - they're immune
	if(ishumanbasic(target))
		return 45 // humans are friends!! :3 - and they're very simillar to us, thus you get lower chance
	return 80 // other races suck, duh!! you get disease!
// now properly infects the [victim] instead of the [user] felinid
/datum/wound/slash/flesh/lick_wounds(mob/living/user)
	// transmission is one way patient -> felinid since google said cat saliva is antiseptic or whatever, and also because felinids are already risking getting beaten for this even without people suspecting they're spreading a deathvirus
	for(var/datum/disease/iter_disease as anything in user.diseases)
		if(iter_disease.spread_flags & (DISEASE_SPREAD_SPECIAL | DISEASE_SPREAD_NON_CONTAGIOUS))
			continue
		if(prob(disease_chance(victim)))
			victim.ForceContractDisease(iter_disease)

	user.visible_message(span_notice("[user] begins licking the wounds on [victim]'s [limb.plaintext_zone]."), span_notice("You begin licking the wounds on [victim]'s [limb.plaintext_zone]..."), ignored_mobs=victim)
	to_chat(victim, span_notice("[user] begins to lick the wounds on your [limb.plaintext_zone]."))
	if(!do_after(user, base_treat_time, target = victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return

	user.visible_message(span_notice("[user] licks the wounds on [victim]'s [limb.plaintext_zone]."), span_notice("You lick some of the wounds on [victim]'s [limb.plaintext_zone]"), ignored_mobs=victim)
	to_chat(victim, span_green("[user] licks the wounds on your [limb.plaintext_zone]!"))
	var/mob/victim_stored = victim
	adjust_blood_flow(-0.5)

	if(blood_flow > minimum_flow)
		try_handling(user)
	else if(demotes_to)
		to_chat(user, span_green("You successfully lower the severity of [user == victim_stored ? "your" : "[victim_stored]'s"] cuts."))
