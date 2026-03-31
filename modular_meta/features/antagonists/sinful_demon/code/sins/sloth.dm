/datum/action/cooldown/spell/shapeshift/demon/sloth //emergency get out of jail card, but better.
	name = "Sloth Demon Form"
	possible_shapes = list(/mob/living/basic/lesserdemon/sloth)

/mob/living/basic/lesserdemon/sloth
	name = "sloth demon"
	real_name = "sloth demon"
	desc = "A large, menacing creature covered in armored red scales, and red one sleeping cap."
	icon_state = "lesserdaemon_sloth"
	icon_living = "lesserdaemon_sloth"
	speed = 1.5
	maxHealth = 200
	health = 200
	melee_damage_lower = 20
	melee_damage_upper = 20
	melee_damage_type = OXY

/datum/action/cooldown/spell/touch/sleepy
	name = "Mimir"
	desc = "You make sleep energy, which forces all yawns, and stuns target."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "arcane_barrage"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	school = SCHOOL_EVOCATION
	invocation = "MI'MIR"
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 20 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	hand_path = /obj/item/melee/touch_attack/sleepy


/obj/item/melee/touch_attack/sleepy
	name = "Dozy Hand"
	desc = "An utterly scornful mass of somnific energy, ready to strike."
	icon_state = "star"

/datum/action/cooldown/spell/touch/sleepy/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster)
	if(victim.can_block_magic())
		to_chat(caster, span_warning("[victim] resists your mimir!"))
		to_chat(victim, span_warning("Blocks this, and resists sleep cast."))
		..()
		return TRUE
	playsound(caster, 'sound/effects/magic/demon_attack1.ogg', 75, TRUE)
	victim.adjust_eye_blur(20) //huge array of relatively minor effects.
	victim.Stun(3 SECONDS)
	victim.adjust_organ_loss(ORGAN_SLOT_EYES, 10)
	victim.visible_message(span_danger("[victim] yawns and want close eyes!"))
	victim.emote("yawn")
	to_chat(victim, span_warning("You want to sleep!"))
	return TRUE

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/sin/sloth
	name = "Sloth Demonic Jaunt"
	cooldown_time = 80 SECONDS
	jaunt_duration = 1 SECONDS

/datum/action/cooldown/spell/timestop/sloth
	name = "Stop Time"
	desc = "This spell stops time for everyone INCLUDE you."
	button_icon_state = "time"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED

	cooldown_time = 180 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	invocation = "CAN I HAVE TIME TO SLEEP?!!"
	invocation_type = INVOCATION_SHOUT

	timestop_range = 2
	timestop_duration = 12 SECONDS

	owner_is_immune_to_all_timestop = FALSE
	owner_is_immune_to_self_timestop = FALSE

/datum/action/cooldown/spell/timestop/sloth/cast(atom/cast_on)
	. = ..()
	new /obj/effect/timestop/sloth(get_turf(cast_on), timestop_range, timestop_duration)

/obj/effect/timestop/sloth
	anchored = TRUE
	name = "sleeping area"
	desc = "Go to sleep.. Go to sleep."
	icon = 'modular_meta/features/antagonists/icons/sinful_demon/160x160.dmi'
	icon_state = "go_to_sleep"
