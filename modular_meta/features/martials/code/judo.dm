#define THROW_COMBO "GD"
#define PIN_COMBO "GH"

/datum/martial_art/judo
	name = "corporate judo"
	id = MARTIALART_CORPORATE_JUDO
	help_verb = "Remember The Basics"
	smashes_tables = FALSE
	display_combos = TRUE
	grab_damage_modifier = 10
	grab_escape_chance_modifier = -10

/datum/martial_art/judo/activate_style(mob/living/new_holder)
	. = ..()

/datum/martial_art/judo/deactivate_style(mob/living/remove_from)
	. = ..()

/obj/item/storage/belt/security/judo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/martial_art_giver, /datum/martial_art/judo)

/datum/martial_art/judo/proc/check_streak(mob/living/attacker, mob/living/defender)
	if(findtext(streak, THROW_COMBO))
		reset_streak()
		return perform_throw(attacker, defender)
	if(findtext(streak, PIN_COMBO))
		reset_streak()
		return perform_pin(attacker, defender)
	return FALSE

/datum/martial_art/judo/proc/perform_throw(mob/living/attacker, mob/living/defender)
	if(defender.body_position != STANDING_UP)
		return FALSE
	attacker.do_attack_animation(defender)
	defender.visible_message(
		span_danger("[attacker] performs a corporate throw on [defender]!"),
		span_userdanger("You're thrown to the ground by [attacker]!"),
		span_hear("You hear a loud thud!"),
		null,
		attacker,
	)
	to_chat(attacker, span_danger("You throw [defender] to the ground!"))
	defender.apply_damage(10, BRUTE)
	defender.Knockdown(4 SECONDS)
	log_combat(attacker, defender, "thrown (Corporate Judo)")
	return TRUE

	/datum/martial_art/judo/harm_act(mob/living/attacker, mob/living/defender)
	add_to_streak("H", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	// ... если комбо не получилось, можно сделать обычный удар
	attacker.do_attack_animation(defender)
	defender.apply_damage(5, BRUTE)
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/judo/disarm_act(mob/living/attacker, mob/living/defender)
	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	// ... обычный disarm
	return ..() // вызов стандартного disarm

/datum/martial_art/judo/grab_act(mob/living/attacker, mob/living/defender)
	add_to_streak("G", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	// ... обычный grab
	return ..()
