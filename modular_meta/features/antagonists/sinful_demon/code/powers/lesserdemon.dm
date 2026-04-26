/mob/living/basic/lesserdemon
	name = "demon"
	real_name = "demon"
	desc = "A large, menacing creature covered in armored red scales."
	speak_emote = list("cackles")
	response_help_continuous = "thinks better of touching"
	response_help_simple = "thinks better of touchingt"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flails at"
	response_harm_continuous = "punches"
	response_harm_simple = "punches"
	icon = 'modular_meta/features/antagonists/icons/sinful_demon/mob.dmi'
	icon_state = "lesserdaemon"
	icon_living = "lesserdaemon"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speed = 1
	attack_sound = 'sound/effects/magic/demon_attack1.ogg'
	death_sound = 'sound/effects/magic/demon_dies.ogg'
	death_message = "wails in anger and fear as it collapses in defeat!"
	minimum_survivable_temperature = 250 //Weak to cold
	maximum_survivable_temperature = INFINITY
	faction = list("hell")
	attack_verb_continuous = "wildly tears into"
	attack_verb_simple = "wildly tears into"
	maxHealth = 150
	health = 150
	obj_damage = 40
	melee_damage_lower = 15
	melee_damage_upper = 15
	wound_bonus = -15
	lighting_cutoff_red = 22
	lighting_cutoff_green = 5
	lighting_cutoff_blue = 5
	butcher_results = list(/obj/effect/decal/cleanable/blood)
	basic_mob_flags = DEL_ON_DEATH

/mob/living/basic/lesserdemon/attackby(obj/item/W, mob/living/caster, params)
	. = ..()
	if(istype(W, /obj/item/nullrod))
		visible_message(span_warning("[src] screams in unholy pain from the blow!"), \
						span_cult("As \the [W] hits you, you feel holy power blast through your form, tearing it apart!"))
		adjust_brute_loss(22) //22 extra damage from the nullrod while in your true form. On average this means 40 damage is taken now.

/mob/living/basic/lesserdemon/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)//10 hp healed from landing a hit.
	if(!isliving(attack_target))
		return ..()
	var/mob/living/living_target = attack_target
	if(living_target.stat != DEAD && !living_target.can_block_magic(MAGIC_RESISTANCE_HOLY|MAGIC_RESISTANCE_MIND)) //demons do not gain succor from the dead or holy
		adjust_health(-maxHealth * 0.05)
	return ..()

/mob/living/basic/lesserdemon/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	. = ..()
	if(!src)
		return
	if(istype(get_area(src.loc), /area/station/service/chapel)) //being a non-carbon will not save you!
		if(src.stat != DEAD) //being dead, however, will save you
			src.visible_message(span_warning("[src] begins to melt apart!"), span_danger("Your very soul melts from the holy room!"), "You hear sizzling.")
			adjust_health(20) //20 damage every ~2 seconds. About 20 seconds for a full HP demon to melt apart in the chapel.

/mob/living/basic/lesserdemon/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/lifesteal, 2)
