//not really a general sanabi power, but more than 1 sin has it
/datum/action/cooldown/spell/touch/torment
	name = "Torment"
	desc = "Engulfs your arm in a vindictive might. Striking someone with it will severely debilitate them, though will cause no visible damage."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "scream_for_me"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	school = SCHOOL_EVOCATION
	invocation = "TORMENT"
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 30 SECONDS
	spell_requirements = NONE

	hand_path = /obj/item/melee/touch_attack/torment


/obj/item/melee/touch_attack/torment
	name = "Vindictive Hand"
	desc = "An utterly scornful mass of hateful energy, ready to strike."
	icon_state = "flagellation"

/datum/action/cooldown/spell/touch/torment/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster)
	if(victim.can_block_magic())
		to_chat(caster, span_warning("[victim] resists your torment!"))
		to_chat(victim, span_warning("A hideous feeling of agony dances around your mind before being suddenly dispelled."))
		..()
		return TRUE
	playsound(caster, 'sound/effects/magic/demon_attack1.ogg', 75, TRUE)
	victim.adjust_eye_blur(15) //huge array of relatively minor effects.
	victim.adjust_jitter(5 SECONDS)
	victim.set_confusion_if_lower(5 SECONDS)
	victim.adjust_disgust(40)
	victim.adjust_hallucinations(20 SECONDS)
	victim.Immobilize(3 SECONDS)
	victim.Stun(1 SECONDS)
	victim.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10)
	victim.visible_message(span_danger("[victim] cringes in pain as they hold their head for a second!"))
	victim.emote("scream")
	to_chat(victim, span_warning("You feel an explosion of pain erupt in your mind!"))
	return TRUE
