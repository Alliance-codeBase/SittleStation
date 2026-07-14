/obj/item/grenade/c4/es8
	name = "ES8 explosive charge"
	desc = "A high-power explosive charge designed to create a shockwave in a structural weakpoint of the station."
	icon = 'modular_meta/features/progressive_traitor/icons/grenade.dmi'
	icon_state = "plasticx40"
	inhand_icon_state = "plasticx4"
	worn_icon = 'modular_meta/features/progressive_traitor/icons/grenade.dmi'
	worn_icon_state = "plasticx40"

	boom_sizes = list(3, 6, 9)

	/// Weakref to user's objective
	var/datum/weakref/objective_weakref

/obj/item/grenade/c4/es8/Initialize(mapload, objective)
	. = ..()
	objective_weakref = WEAKREF(objective)

/obj/item/grenade/c4/es8/Destroy()
	objective_weakref = null
	return ..()

/obj/item/grenade/c4/es8/plant_c4(atom/bomb_target, mob/living/user)
	if(!IS_TRAITOR(user))
		to_chat(user, span_warning("You can't seem to find a way to detonate the charge."))
		if(prob(50) || HAS_TRAIT(user, TRAIT_CLUMSY))
			to_chat(user, span_warning("You start pressing random buttons on [src]. You don't think it's a wise thing to do, though you still continue"))
			if(do_after(user, 5 SECONDS, user))
				// detonate() man...
				explosion(src, 0, -1 , -1, -1, 3)
				qdel(src)
			else
				to_chat(user, span_warning("You decide to leave alone the [src]"))
		return FALSE

	var/datum/traitor_objective/locate_weakpoint/objective = objective_weakref.resolve()
	if(!objective || objective.objective_state == OBJECTIVE_STATE_INACTIVE || objective.handler.owner != user.mind)
		to_chat(user, span_warning("You don't think it would be wise to use [src]."))
		return FALSE

	var/area/target_area = get_area(bomb_target)
	if (target_area.type != objective.weakpoint_area)
		to_chat(user, span_warning("[src] can only be detonated in [initial(objective.weakpoint_area.name)]."))
		return FALSE

	if(!isfloorturf(bomb_target) && !iswallturf(bomb_target))
		to_chat(user, span_warning("[src] can only be planted on a wall or the floor!"))
		return FALSE

	return ..()
