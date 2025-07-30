/datum/action/cooldown/spell/shapeshift/demon/wrath //emergency get out of jail card, but better.
	name = "Wrath Demon Form"
	possible_shapes = list(/mob/living/simple_animal/lesserdemon/wrath)

/mob/living/simple_animal/lesserdemon/wrath //slightly more damage.
	name = "wrathful demon"
	real_name = "wrathful demon"
	melee_damage_lower = 19
	melee_damage_upper = 19
	icon_state = "lesserdaemon_wrath"
	icon_living = "lesserdaemon_wrath"

#define WRATHFUL_FIRE_AMOUNT 5

/datum/action/cooldown/spell/pointed/ignite
	name = "Ignite"
	desc = "This ranged spell sets a person on fire."
	button_icon = 'icons/mob/effects/onfire.dmi'
	button_icon_state = "generic_fire"
	active_msg = "You prepare to ignite a target..."
	ranged_mousepointer = 'icons/effects/mouse_pointers/throw_target.dmi'
	overlay_icon_state = "bg_demon_border"

	school = SCHOOL_TRANSMUTATION
	invocation = "BURN IN HELL!!"
	invocation_type = INVOCATION_SHOUT

	sound = 'sound/effects/magic/fireball.ogg'
	cooldown_time = 1 MINUTES
	active_msg = span_notice("You ignite in a flash of hellfire!")
	spell_requirements = NONE

/datum/action/cooldown/spell/pointed/ignite/InterceptClickOn(mob/living/clicker, params, atom/target)
	. = ..()
	if(!.)
		return FALSE

	if(!isliving(target))
		return FALSE
	
	var/mob/living/T = target
	T.adjust_fire_stacks(WRATHFUL_FIRE_AMOUNT)
	T.ignite_mob()

	return TRUE

#undef WRATHFUL_FIRE_AMOUNT

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/sin/wrath
	name = "Greater Demonic Jaunt"
	desc = "Briefly turn to cinder and ash, allowing you to freely pass through objects. Lasts slightly shorter than normal, but is more easily used."

	cooldown_time = 25 SECONDS

	jaunt_duration = 3 SECONDS
