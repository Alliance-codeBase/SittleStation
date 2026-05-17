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
	force = 11
	wound_bonus = -25
	throwforce = 7
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/effects/woodhit.ogg'
	custom_price = PAYCHECK_COMMAND
	/// How much armor does our tonfa ignore? This operates as armour penetration, but only applies to the stun attack.
	var/stun_armour_penetration = 15
	/// Stamina damage dealt
	var/stamina_force = 25

/obj/item/melee/tonfa/attack(mob/living/target, mob/living/user, mob/living/martial_artist)
	var/target_zone = user.zone_selected == target
	var/armour_level = target.getarmor(target_zone)
	var/shove_dir = get_dir(user.loc, target.loc)
	var/turf/target_shove_turf = get_step(target.loc, shove_dir)
	var/mob/living/carbon/human/target_collateral_human = locate(/mob/living/carbon) in target_shove_turf.contents

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
		force = 0
		playsound(loc, 'modular_meta/features/security_extended/sound/light_woodhit.ogg', 25, TRUE, -1)
		if(prob(6)) //isn't that a dnd rng
			force = 3
			to_chat(user, span_danger("Unfortunately, you hit [target] too hard, and hurt them."))
			if(user.zone_selected == BODY_ZONE_HEAD)
				target.Knockdown(0.5 SECONDS)
				force = rand(5, 7)
				to_chat(user, span_danger("You knocked [target] by tonfa right onto his head."))
				if(prob(66))
					target.emote("scream")
					if(prob(10))
						target.adjust_organ_loss(ORGAN_SLOT_BRAIN, BRAIN_DAMAGE_MILD - 1, BRAIN_DAMAGE_ASYNC_BLINKING - 1)
						if(prob(66))
							target.emote("cry")
						if(prob(6))
							target.emote("deathgasp")
	if(user.combat_mode)
		force = initial(force)
		if(user.zone_selected == BODY_ZONE_HEAD && prob(8))
			target.Knockdown(0.5 SECONDS)
			force = rand(13, 16)
			to_chat(user, span_danger("You knocked [target] by tonfa right onto his head."))
			if(prob(70))
				target.emote("scream")
			if(prob(6))
				target.emote("cry")
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/list/adjectives = list("expretly", "professionally", "skillfully", "masterfully")
		var/list/nouns = list("attack", "hit", "bash", "swing")
		if (H.check_block(src, 0, "[user]'s [name]", MELEE_ATTACK))
			return
		if(target.check_block(martial_artist))
			target.visible_message(span_danger("[target.name] blocks [src] and [pick(adjectives)] twists [user]'s arm behind [user.p_their()] back!"),
				span_userdanger("You block the [user]'s [src] [pick(nouns)] by [pick(adjectives)] twisting [user.p_their()] hand behind [user.p_their()] back!"))
			user.Stun(7)
			log_combat(user, target, "attempted to attack", src, "(blocked by martial arts)")
			return
		log_combat(user, target, "attacked", src)

		// If the target has a lot of stamina loss, knock them down
		if (user.zone_selected == BODY_ZONE_L_LEG || user.zone_selected == BODY_ZONE_R_LEG && target.get_stamina_loss() > 22)
			var/effectiveness = CLAMP01((target.get_stamina_loss() - 22) / 50)
			log_combat(user, target, "knocked-down", src, "(additional effect)")
			// Move the target back upon knockdown, to give them some time to recover
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
