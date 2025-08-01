/datum/action/cooldown/spell/forcewall/gluttony
	name = "Gluttonous Wall"
	desc = "Create a magical barrier that only allows fat people to pass through."
	button_icon = 'icons/mob/nonhuman-player/blob.dmi'
	button_icon_state = "blob"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	invocation = "INDULGE"
	invocation_type = INVOCATION_SHOUT

	wall_type = /obj/effect/gluttony/timed
	spell_requirements = NONE

/datum/action/cooldown/spell/shapeshift/demon/gluttony //emergency get out of jail card, but better. It also eats agents 220.
	name = "Gluttony Demon Form"
	desc = "Take on your true demon form. This form is strong but very obvious. It's full demonic nature in this realm is taxing on you \
		and you will slowly lose life while in this form, while also being especially weak to holy influences. \
		Be aware low health transfers between forms. If gravely wounded, attack live mortals to siphon life energy from them! \
		Your unique form as a demon of gluttony also allows you to eat corpses to heal yourself."
	possible_shapes = list(/mob/living/simple_animal/lesserdemon/gluttony)

/mob/living/simple_animal/lesserdemon/gluttony //capable of devouring corpses for health
	name = "gluttonous demon"
	real_name = "gluttonous demon"
	icon_state = "lesserdaemon_gluttony"
	icon_living = "lesserdaemon_gluttony"
	speed = 1.25

/mob/living/simple_animal/lesserdemon/gluttony/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(!isliving(attack_target))
		return ..()
	var/mob/living/living_target = attack_target
	//Eat Corpses of agents 220 to regen health
	if(living_target.stat == DEAD)
		if(do_after(src, 3 SECONDS, living_target))
			devour(living_target)
		return
	return ..()

/mob/living/simple_animal/lesserdemon/gluttony/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	adjustBruteLoss(-50)
	L.gib()
	return TRUE

/obj/effect/gluttony/timed
	///Time before it deletes itself.
	var/timeleft = 15 SECONDS

/obj/effect/gluttony/timed/Initialize(mapload)
	. = ..()
	if(timeleft)
		QDEL_IN(src, timeleft)
