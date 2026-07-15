/obj/item/skillchip/wrestling
	name = "Wrestling skillchip"
	desc = "This skillchip teach you wrestling."
	skill_name = "Wrestling"
	skill_description = "A martial art that teach you basics of wrestling."
	skill_icon = "utensils"
	activate_message = span_notice("Wrest them all.")
	deactivate_message = span_notice("No more wrestling.")
	var/datum/martial_art/wrestling/style

/obj/item/skillchip/wrestling/Initialize(mapload)
	. = ..()
	style = new(src)

/obj/item/skillchip/wrestling/on_activate(mob/living/carbon/user, silent = FALSE)
	. = ..()
	style.teach(user)

/obj/item/skillchip/wrestling/on_deactivate(mob/living/carbon/user, silent = FALSE)
	style.unlearn(user)
	return ..()

/obj/item/skillchip/kaza_ruk
	name = "Kaza Ruk skillchip"
	desc = "This skillchip teach you kaza ruk."
	skill_name = "Kaza Ruk"
	skill_description = "A martial art that teach you basics of kaza ruk."
	skill_icon = "utensils"
	activate_message = span_notice("Kick them all.")
	deactivate_message = span_notice("No more kaza ruk.")
	var/datum/martial_art/kaza_ruk/sc/style

/obj/item/skillchip/kaza_ruk/Initialize(mapload)
	. = ..()
	style = new(src)

/obj/item/skillchip/kaza_ruk/on_activate(mob/living/carbon/user, silent = FALSE)
	. = ..()
	style.teach(user)

/obj/item/skillchip/kaza_ruk/on_deactivate(mob/living/carbon/user, silent = FALSE)
	style.unlearn(user)
	return ..()

/datum/martial_art/kaza_ruk/sc/quick_choke(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender)
	defender.visible_message(
		span_warning("[attacker] pounds [defender] on the chest!"),
		span_userdanger("Your chest is slammed by [attacker]! You can't breathe!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You pound [defender] on the chest!"))
	playsound(attacker, 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	if(defender.losebreath <= 15)
		defender.losebreath = clamp(defender.losebreath + 5, 0, 10)
	defender.adjust_oxy_loss(5)
	log_combat(attacker, defender, "quickchoked")
	return MARTIAL_ATTACK_SUCCESS
