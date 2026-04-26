/obj/item/melee/tonfa/proc/check_martial_counter(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(target.check_block())
		target.visible_message(span_danger("[target.name] blocks [src] and twists [user]'s arm behind [user.p_their()] back!"),
					span_userdanger("You block the attack!"))
		user.Stun(15)
		return TRUE

//tonfa
/obj/item/melee/tonfa
	name = "police tonfa"
	desc = "A traditional police baton for gaining the submission of an uncooperative target without the use of lethal-force. \
		As with all traditional weapons, the target will find themselves bruised, but alive. It has proven to be effective in preventing \
		repeat offenses and has brought employment to lawyers for decades."
	icon = 'modular_meta/features/security_extended/icons/baton.dmi'
	icon_state = "beater"
	worn_icon_state = "classic_baton"
	lefthand_file = 'modular_meta/features/security_extended/icons/inhands/lefthand.dmi'
	righthand_file = 'modular_meta/features/security_extended/icons/inhands/righthand.dmi'
	force = 12
	throwforce = 7
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/effects/woodhit.ogg'
	custom_price = PAYCHECK_COMMAND
	armour_penetration = -15
	/// Damage dealt while on help intent
	var/non_harm_force = 3
	/// Stamina damage dealt
	var/stamina_force = 25

/obj/item/melee/tonfa/attack(mob/living/target, mob/living/user)
	var/target_zone = user.zone_selected == target
	var/armour_level = target.getarmor(target_zone)

	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, span_danger("You hit yourself over the head."))
		user.adjust_stamina_loss(stamina_force)

		// Deal full damage
		force = initial(force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(!isliving(target))
		return ..()
	if(iscyborg(target))
		if (!user.combat_mode)
			playsound(get_turf(src), hitsound, 75, 1, -1)
			user.do_attack_animation(target) // The attacker cuddles the Cyborg, awww. No damage here.
			return
	if (!user.combat_mode)
		force = non_harm_force
	else
		force = initial(force)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if (H.check_block(src, 0, "[user]'s [name]", MELEE_ATTACK))
			return
		if(check_martial_counter(H, user))
			log_combat(user, target, "attempted to attack", src, "(blocked by martial arts)")
			return

		target.visible_message("[user] strikes [target] in the [parse_zone(target_zone)].", "You strike [target] in the [parse_zone(target_zone)].")
		log_combat(user, target, "attacked", src)

		// If the target has a lot of stamina loss, knock them down
		if (user.zone_selected == BODY_ZONE_L_LEG || user.zone_selected == BODY_ZONE_R_LEG && target.get_stamina_loss() > 22)
			var/effectiveness = CLAMP01((target.get_stamina_loss() - 22) / 50)
			log_combat(user, target, "knocked-down", src, "(additional effect)")
			// Move the target back upon knockdown, to give them some time to recover
			var/shove_dir = get_dir(user.loc, target.loc)
			var/turf/target_shove_turf = get_step(target.loc, shove_dir)
			var/mob/living/carbon/human/target_collateral_human = locate(/mob/living/carbon) in target_shove_turf.contents
			if (target_collateral_human && target_shove_turf != get_turf(user))
				target.Knockdown(max(0.5 SECONDS, effectiveness * 4 SECONDS * (100-armour_level)/100))
				target_collateral_human.Knockdown(0.5 SECONDS)
			else
				target.Knockdown(effectiveness * 4 SECONDS * (100-armour_level)/100)
			target.Move(target_shove_turf, shove_dir)
		if (user.zone_selected == BODY_ZONE_L_LEG || user.zone_selected == BODY_ZONE_R_LEG || user.zone_selected == BODY_ZONE_L_ARM || user.zone_selected == BODY_ZONE_R_ARM)
			// 4-5 hits on an unarmoured target
			target.apply_damage(stamina_force*0.6, STAMINA, target_zone, armour_level)
		else
			// 4-5 hits on an unarmoured target
			target.apply_damage(stamina_force, STAMINA, target_zone, armour_level)

	return ..()
