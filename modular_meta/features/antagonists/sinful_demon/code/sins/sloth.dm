/datum/action/cooldown/spell/shapeshift/demon/sloth //emergency get out of jail card, but better.
	name = "Sloth Demon Form"
	possible_shapes = list(/mob/living/simple_animal/lesserdemon/sloth)

/mob/living/simple_animal/lesserdemon/sloth
	name = "sloth demon"
	real_name = "sloth demon"
	desc = "*yawns* aaw.. battle? Ahhh no.. i.. go.. to... to.. sleeep.."
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
	invocation = "MIMIR"
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 20 SECONDS
	spell_requirements = NONE

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
	victim.adjustOrganLoss(ORGAN_SLOT_EYES, 10)
	victim.visible_message(span_danger("[victim] yawns and want close eyes!"))
	victim.emote("yawn")
	to_chat(victim, span_warning("You want to sleep!"))
	return TRUE

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/sin/sloth
	cooldown_time = 30 SECONDS

	jaunt_duration = 1 SECONDS
