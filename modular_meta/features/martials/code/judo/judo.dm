/datum/martial_art/judo
	name = "corporate judo"
	id = "corporate judo"
	help_verb = "Remember the basics of judo"
	smashes_tables = FALSE
	display_combos = TRUE
	max_streak_length = 12
	combo_timer = 15 SECONDS
	grab_damage_modifier = 10
	grab_escape_chance_modifier = -10

/datum/martial_art/judo/activate_style(mob/living/new_holder)
	. = ..()
	RegisterSignal(holder, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(check_baton))
	for(var/obj/item/item in new_holder.held_items)
		check_baton(equipped_item = item, slot = ITEM_SLOT_HANDS)

	to_chat(new_holder, span_userdanger("The nanites of this belt grant you mastery of corporate judo!"))

/datum/martial_art/judo/deactivate_style(mob/living/remove_from)
	UnregisterSignal(holder, COMSIG_MOB_EQUIPPED_ITEM)
	to_chat(remove_from, span_userdanger("You are forgetting the mastery of corporate judo..."))
	return ..()

// конфликт батона и дзюдо
/datum/martial_art/judo/proc/check_baton(datum/source, obj/item/equipped_item, slot)
	SIGNAL_HANDLER
	if(!istype(equipped_item, /obj/item/melee/baton))
		return

	if(slot != ITEM_SLOT_HANDS)
		return

	to_chat(holder, span_warning("Your hands are rejecting the [equipped_item] against your will!"))
	holder.dropItemToGround(equipped_item)

// интенты
/datum/martial_art/judo/harm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("H", defender)
	to_chat(attacker, "har(a)m halal") //тест
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	attacker.do_attack_animation(defender)
	var/picked_hit_type = pick("robust", "strike", "punch")
	var/bonus_damage = 9
	defender.apply_damage(bonus_damage, BRUTE)
	playsound(get_turf(defender), 'sound/effects/hit_punch.ogg', 50, TRUE)

	/*defender.visible_message(
		span_danger("[attacker] [picked_hit_type]ed [defender]!"),
		span_userdanger("You're [picked_hit_type]ed by [attacker]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)*/



/datum/martial_art/judo/disarm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("D", defender)
	to_chat(attacker, "DiZZarm") //тест
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	if(attacker == defender)
		return MARTIAL_ATTACK_FAIL

	return MARTIAL_ATTACK_INVALID


/datum/martial_art/judo/grab_act(mob/living/attacker, mob/living/defender)
	if(attacker == defender)
		return MARTIAL_ATTACK_INVALID

	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(attacker.body_position == LYING_DOWN)
		return MARTIAL_ATTACK_INVALID

	add_to_streak("G", defender)
	to_chat(attacker, "Grab robit") //тест

	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS



/datum/martial_art/judo/reset_streak(mob/living/new_target)
	if(!IS_WEAKREF_OF(new_target, restraining_mob))
		restraining_mob = null
	return ..()

/datum/martial_art/judo/proc/check_streak(mob/living/attacker, mob/living/defender)
	if(findtext(streak, "THROW_COMBO"))
		reset_streak()
		return Throw(attacker, defender)
	/*if(findtext(streak, "some_combo2"))
		reset_streak()
		return Kick(attacker, defender)
	if(findtext(streak, "some_combo3"))
		reset_streak()
		return Restrain(attacker, defender)
	if(findtext(streak, "some_combo4"))
		reset_streak()
		return //Pressure(attacker, defender)
	if(findtext(streak, "some_combo5"))
		reset_streak()
		return Consecutive(attacker, defender) */
	return FALSE



/datum/martial_art/judo/proc/Throw(mob/living/attacker, mob/living/defender)
	if(defender.body_position != STANDING_UP)
		return FALSE

	attacker.do_attack_animation(defender)
	defender.visible_message(
		span_danger("[attacker] slams [defender] into the ground!"),
		span_userdanger("You're slammed into the ground by [attacker]!"),
		span_hear("You hear a sound of flesh hitting ground!"),
		null,
		attacker,
	)
	to_chat(attacker, span_danger("You slam [defender] into the ground!"))
	playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
	defender.Paralyze(7 SECONDS)
	log_combat(attacker, defender, "slammed (Judo)")
	return TRUE
