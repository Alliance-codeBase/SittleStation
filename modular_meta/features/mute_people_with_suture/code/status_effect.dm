/obj/item/stack/medical/suture/proc/try_mute(mob/living/mutedone, mob/living/user, healed_zone)
	var/x = mutedone.staminaloss //I skipped my math classes
	var/stamina_modifier = 5 / (x + 1) // trying some fancy math here, for the first time.
	var/obj/item/stack/medical/suture/sew_thing = user.get_active_held_item()
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if(sew_thing.amount < 2)
			to_chat(user, span_danger("You don't have enough of [sew_thing] to do that!"))
			return ITEM_INTERACT_BLOCKING

		if(mutedone.has_status_effect(/datum/status_effect/mouth_sewed_up))
			to_chat(user, span_alert(pick("You can't...", "Their mouth is already sewed..", "Hurr-durr... they are already..", "No...", "This isn't right..")))
			return ITEM_INTERACT_BLOCKING

		user.visible_message(
			span_danger("[user] is trying to sew [mutedone]'s mouth shut with [sew_thing]"),
			span_danger("You begin trying to suture up [mutedone]'s mouth")
		)
		balloon_alert(user, "sewing mouth shut...")
		playsound(mutedone, heal_begin_sound, 100)
		to_chat(mutedone, span_userdanger("[user] is trying to sew your mouth shut with [sew_thing]"))

		if(do_after(user, (7 SECONDS + stamina_modifier SECONDS) / mouth_sewing_force, mutedone))
			user.visible_message(
				span_danger("[user] sews [mutedone]'s mouth shut"),
				span_danger("You succesfully sew [mutedone]'s mouth with the [sew_thing]")
			)
			to_chat(mutedone, span_userdanger("[user] has sewed your mouth shut with the [sew_thing]!"))
			mutedone.emote("scream", forced = TRUE)
			mutedone.apply_status_effect(/datum/status_effect/mouth_sewed_up)

			playsound(mutedone, heal_end_sound, 100)

			log_combat(user, mutedone, "[user] has used [sew_thing] on [mutedone] to prevent them from speaking", sew_thing)
			sew_thing.amount -= 2
			sew_thing.update_appearance() // Otherwise the "counter" overlay wouldn't change. It'll show "10" when it's actually eight or six
		return

/obj/item/stack/medical/suture/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(!try_mute(interacting_with, user))
		return NONE
	return ITEM_INTERACT_SUCCESS

/datum/status_effect/mouth_sewed_up
	id = "mouth_sewed_up"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/mouth_sewed_up

/datum/status_effect/mouth_sewed_up/get_examine_text()
	. = ..()
	return span_danger("[owner.p_Their()] mouth appears to be sewed shut with some suture!")

/atom/movable/screen/alert/status_effect/mouth_sewed_up
	name = "Mute!"
	desc = "Whoops! Someone has sewed your mouth shut, \
			press resist to try break the suture by your mouth \
			or use any sharp item to tear it away!"
	overlay_state = "mind_control"
	attached_effect = /datum/status_effect/mouth_sewed_up

/datum/status_effect/mouth_sewed_up/on_apply()
	if(ishuman(owner))
		RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(muzzle_talk))
		RegisterSignal(owner, COMSIG_LIVING_RESIST, PROC_REF(handle_resist))
		RegisterSignal(owner, COMSIG_ATOM_ATTACKBY, PROC_REF(someone_removing_sutures))
	return TRUE

/datum/status_effect/mouth_sewed_up/on_remove()
	if(ishuman(owner))
		owner.remove_traits(list(TRAIT_MUTE), REF(src))
		UnregisterSignal(owner, list(COMSIG_MOB_SAY, COMSIG_MOB_PRE_EMOTED, COMSIG_LIVING_RESIST, COMSIG_ATOM_ATTACKBY))
	return TRUE

/datum/status_effect/mouth_sewed_up/proc/muzzle_talk(datum/source, list/speech_args)  //thx to whoever made muffles_speech.dm
	SIGNAL_HANDLER
	if(HAS_TRAIT(source, TRAIT_SIGN_LANG))
		return
	var/spoken_message = speech_args[SPEECH_MESSAGE]
	if(spoken_message)
		var/list/words = splittext(spoken_message, " ")
		var/yell_suffix = copytext(spoken_message, findtext(spoken_message, "!"))
		spoken_message = ""

		for(var/ind = 1 to length(words))
			var/new_word = ""
			for(var/i = 1 to length(words[ind]) + rand(-1,1))
				new_word += "m"
			new_word += "f"
			words[ind] = yell_suffix ? uppertext(new_word) : new_word
		spoken_message = "[jointext(words, " ")][yell_suffix]"
	speech_args[SPEECH_MESSAGE] = spoken_message

/datum/status_effect/mouth_sewed_up/proc/handle_resist(datum/source)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(handle_resist_async), source)
	return COMPONENT_BLOCK_MISC_HELP

// resist out of the, uhh.. sutures?
/datum/status_effect/mouth_sewed_up/proc/handle_resist_async(mob/living/carbon/muteman)
	muteman.visible_message(
		message = span_warning("[muteman] starts tearing at the sutures on [muteman.p_their()] mouth!"),
		self_message = span_danger("You start tearing at the sutures on your mouth... This will hurt!")
	)
	if(do_after(muteman, 20 SECONDS, target = muteman)) //Yeah, those take some time.. those are surgery grade.
		if(!muteman.has_status_effect(/datum/status_effect/mouth_sewed_up))
			return
		playsound(muteman, 'sound/items/weapons/slice.ogg', 55, TRUE)
		muteman.visible_message(
			message = span_danger("[muteman] tears the sutures off [muteman.p_their()] mouth!"),
			self_message = span_userdanger("You tear the sutures off your mouth! AGH!")
		)
		if(ishuman(muteman))
			var/obj/item/bodypart/golova = muteman.get_bodypart(BODY_ZONE_HEAD)
			if(golova)
				muteman.apply_damage(10, BRUTE, BODY_ZONE_HEAD)
				muteman.cause_wound_of_type_and_severity(WOUND_SLASH, golova, WOUND_SEVERITY_TRIVIAL, WOUND_SEVERITY_MODERATE)
		muteman.emote("scream", forced = TRUE)
		qdel(src) // delete status effect

/datum/status_effect/mouth_sewed_up/proc/someone_removing_sutures(atom/source, obj/item/weapon, mob/living/user, list/modifiers)
	SIGNAL_HANDLER
	// what are we targeting?
	if(user.zone_selected != BODY_ZONE_PRECISE_MOUTH)
		return NONE
	// is it sharp?
	if(!weapon)
		return NONE

	var/sharpness = weapon.get_sharpness()
	if(sharpness != SHARP_EDGED && sharpness != SHARP_POINTY)
		return NONE

	INVOKE_ASYNC(src, PROC_REF(try_remove_sutures_async), user, weapon)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/status_effect/mouth_sewed_up/proc/try_remove_sutures_async(mob/living/helper, obj/item/tool)
	if(DOING_INTERACTION(helper, id))
		return
	helper.visible_message(
		span_warning("[helper] starts cutting the sutures on [owner] mouth with [tool]!"),
		span_notice("You start cutting the sutures on [owner] mouth with [tool]!"),
	)

	if(do_after(helper, 5.5 SECONDS, owner, extra_checks = CALLBACK(src, PROC_REF(try_remove_sutures_checks)), interaction_key = id))
		playsound(owner, 'sound/items/weapons/slice.ogg', 55, TRUE)
		owner.visible_message(
			span_danger("[helper] cuts the sutures from [owner]'s mouth!"),
			span_danger("You cut the sutures from [owner]'s mouth!"),
		)
		qdel(src)
	else
		var/mob/living/carbon/carbon_owner = owner // cause_wound_of_type_and_severity() works only for carbons and carbons only
		var/obj/item/bodypart/bashka = carbon_owner.get_bodypart(BODY_ZONE_HEAD)
		if(bashka)
			carbon_owner.apply_damage(3, BRUTE, BODY_ZONE_HEAD)
			playsound(owner, 'sound/effects/wounds/pierce1.ogg', 50, TRUE)
			if(prob(50))
				carbon_owner.cause_wound_of_type_and_severity(WOUND_SLASH, bashka, WOUND_SEVERITY_TRIVIAL, WOUND_SEVERITY_MODERATE)
				owner.visible_message(
					span_danger("[helper] cuts the sutures from [owner]'s mouth, but [helper]'s hand slips, leaving their face with a nasty cut in process!"),
					span_danger("You cut open [owner]'s mouth free. But your hands slips and cuts their face, leaving a nasty cut!")
				)
	return

/datum/status_effect/mouth_sewed_up/proc/try_remove_sutures_checks()
	return !QDELETED(src) // code\modules\projectiles\projectile\energy\stun.dm ln. 339-340 - I dunno what it's really for, but I suppose it's there for a reason

/mob/living/carbon/human/is_mouth_covered(check_flags = ALL)
	if(has_status_effect(/datum/status_effect/mouth_sewed_up))
		return src
	return ..()
