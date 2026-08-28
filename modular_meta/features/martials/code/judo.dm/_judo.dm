/datum/martial_art/judo
	name = "corporate judo"
	id = "corporate judo"
	help_verb = /mob/living/proc/judo_verb()
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

/datum/martial_art/judo/proc/check_baton(datum/source, obj/item/equipped_item, slot)
	SIGNAL_HANDLER
	if(!istype(equipped_item, /obj/item/melee/baton))
		return

	if(slot != ITEM_SLOT_HANDS)
		return

	to_chat(holder, span_warning("Your hands are rejecting the [equipped_item.declent_ru(NOMINATIVE)] against your will!"))
	holder.dropItemToGround(equipped_item)

// Регистрация харм интента 
/datum/martial_art/judo/harm_act(mob/living/carbon/human/attacker, mob/living/carbon/human/defender)
	var/picked_hit_type = GLOB.ru_attack_verbs[pick("chops", "slices", "strikes")]
	attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)
	if(check_one_click_combo(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	add_to_streak("H", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	defender.apply_damage(6, BRUTE)
	playsound(get_turf(defender), 'sound/effects/hit_punch.ogg', 50, TRUE)
	defender.visible_message(
		span_danger("[attacker.declent_ru(NOMINATIVE)] [picked_hit_type] [defender.declent_ru(ACCUSATIVE)]!"),
		span_userdanger("[attacker.declent_ru(NOMINATIVE)] [picked_hit_type] вас!")
	)
	log_combat(attacker, defender, "melee attack ([src])")
	return MARTIAL_ATTACK_SUCCESS
