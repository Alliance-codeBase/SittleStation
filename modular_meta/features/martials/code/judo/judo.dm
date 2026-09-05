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

// Регистрация интентов в комбо-статус
/datum/martial_art/judo/harm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL


	add_to_streak("H", defender)
	to_chat(attacker, "calling harm_act")
	return /* check_streak(attacker, defender) ? */ MARTIAL_ATTACK_SUCCESS /*: MARTIAL_ATTACK_INVALID */



/datum/martial_art/cqc/disarm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/cqc/grab_act(mob/living/attacker, mob/living/defender)
	if(attacker == defender)
		return MARTIAL_ATTACK_INVALID
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("G", defender)


/datum/martial_art/judo/proc/check_streak(mob/living/attacker, mob/living/defender)
	if(findtext(streak, "some_combo1"))
		reset_streak()
		return //Slam(attacker, defender)
	if(findtext(streak, "some_combo2"))
		reset_streak()
		return //Kick(attacker, defender)
	if(findtext(streak, "some_combo3"))
		reset_streak()
		return //Restrain(attacker, defender)
	if(findtext(streak, "some_combo4"))
		reset_streak()
		return //Pressure(attacker, defender)
	if(findtext(streak, "some_combo5"))
		reset_streak()
		return //Consecutive(attacker, defender)
	return FALSE
