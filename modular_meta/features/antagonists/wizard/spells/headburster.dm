#define FAKE_EFFECTS_LIFETIME 3 SECONDS
#define BASE_AFTERCAST_JUMP_INTERVAL 1 SECONDS
#define AFTERCAST_JUMP_INTERVAL 1.2 SECONDS

/datum/action/cooldown/spell/pointed/headburst
	name = "Head burster"
	desc = "Focuses a deadly beam that leaps through nearby targets swelling nd' exploding their heads in a bloody shower on touch!"
	cooldown_time = 30 SECONDS
	cast_range = 5
	invocation = "H'D BR'ST!!"
	invocation_type = INVOCATION_SHOUT
	sparks_amt = 3
	spell_max_level = 3
	antimagic_flags = MAGIC_RESISTANCE
	school = SCHOOL_SANGUINE
	var/charging = FALSE
	var/base_beam_time = 10 SECONDS
	var/base_aftercast_range = 2
	var/range_per_level = 1
	var/beam_time_per_level = 1.7 SECONDS
	button_icon_state = "headburster"

/datum/action/cooldown/spell/pointed/headburst/is_valid_target(atom/cast_on)
	. = ..()

	if(charging)
		owner.balloon_alert(owner, "one target at the time!")
		return FALSE

	if(!ishuman(cast_on))
		return FALSE

	if(!.)
		return FALSE

	var/mob/living/carbon/carbon_target = cast_on
	var/obj/item/bodypart/head = carbon_target?.get_bodypart(BODY_ZONE_HEAD)
	var/are_we_dead_ass = carbon_target.stat == DEAD
	var/harsey = carbon_target.dna?.check_mutation(/datum/mutation/headless) == /datum/mutation/headless

	if(are_we_dead_ass)
		owner.balloon_alert(owner, "they're dead!")
		return FALSE

	if(isnull(head) || harsey)
		if(prob(5))
			owner.balloon_alert(owner, "no head, rip :(")
		else
			owner.balloon_alert(owner, "no head!")
		return FALSE

	if(!cast_on) // liminal spaces
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/headburst/before_cast(atom/cast_on)
	. = ..()
	var/beam_time = base_beam_time - ((spell_level -1) * beam_time_per_level)
	var/mob/living/carbon/carbon_target = cast_on
	charging = TRUE
	INVOKE_ASYNC(src, PROC_REF(play_charging_sound))

	var/mutable_appearance/mutable_appearance = mutable_appearance(
		icon = 'icons/mob/effects/genetics.dmi',
		icon_state = "telekinesishead",
		layer = -MUTATIONS_LAYER,
	)
	// adds a glowy effect on target's head
	var/atom/movable/flick_visual/glowy_head = carbon_target.flick_overlay_view(mutable_appearance, FAKE_EFFECTS_LIFETIME)

	glowy_head.color = "#c75751"
	glowy_head.alpha = 255

	carbon_target.visible_message(
		span_danger("[owner] is concentrating dark energy into a beam, preparing to strike [cast_on]!"),
		span_userdanger("You feel nauseous as [owner] points a deadly beam at your head!")
	)

	var/datum/beam/beam = owner.Beam(cast_on, "blood", 'icons/effects/beam.dmi', beam_time, layer = ABOVE_ALL_MOB_LAYER)
	var/head_popped = do_after(owner, beam_time, cast_on, IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM | IGNORE_SLOWDOWNS, extra_checks = CALLBACK(src, PROC_REF(range_check), owner, cast_on))

	if(!head_popped)
		owner.balloon_alert(owner, "too far away!")
		charging = FALSE
		qdel(beam)
		return SPELL_CANCEL_CAST

	if(head_popped)
		qdel(beam)
		charging = FALSE
		return

/datum/action/cooldown/spell/pointed/headburst/proc/play_charging_sound()
	while(charging)
		playsound(owner, 'sound/effects/magic/charge.ogg', 15, TRUE, vary = TRUE)
		sleep(1 SECONDS)

/datum/action/cooldown/spell/pointed/headburst/proc/range_check(mob/living/carbon/human/user, mob/living/carbon/human/target, bar_override = owner)
	var/caster_loc = user.loc
	var/target_loc = target.loc

	if(QDELETED(user) || QDELETED(target))
		return

	if(get_dist(caster_loc, target_loc) > cast_range)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/headburst/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/carbon_target = cast_on
	var/head_explosion_time = 3 SECONDS
	var/time_till_body_falls = rand(4.6 SECONDS, 7 SECONDS)

	if(carbon_target.can_block_magic(antimagic_flags))
		carbon_target.visible_message(
			span_warning("[carbon_target] absorbs the spell, remaining unharmed!"),
			span_userdanger("You absorb the spell, remaining unharmed!"),
		)
		charging = FALSE
		return FALSE

	carbon_target.Stun(3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(headburst), cast_on), head_explosion_time)
	addtimer(CALLBACK(src, PROC_REF(drop_body), cast_on), time_till_body_falls)
	ADD_TRAIT(carbon_target, TRAIT_FORCED_STANDING, REF(src))
	inflate(cast_on)
	charging = FALSE
	to_chat(carbon_target, span_userdanger("You feel exhausted as the pain in your head overwhelms you"))

/datum/action/cooldown/spell/pointed/headburst/proc/headburst(atom/cast_on)
	var/mob/living/carbon/carbon_target = cast_on
	var/obj/item/bodypart/head = carbon_target?.get_bodypart(BODY_ZONE_HEAD)
	var/list/blood_dna = carbon_target?.get_blood_dna_list()
	var/obj/item/organ/brain = carbon_target?.get_organ_slot(ORGAN_SLOT_BRAIN)
	var/blood_color = get_color_from_blood_list(blood_dna)
	var/bloody_turfs = view(1, carbon_target)


	playsound(carbon_target, 'sound/effects/wounds/crackandbleed.ogg', 100)
	playsound(carbon_target, 'sound/effects/splat.ogg', 50, TRUE)
	playsound(carbon_target, 'modular_meta/features/antagonists/sound/blood_spray.ogg', 35)
	carbon_target?.adjust_organ_loss(ORGAN_SLOT_BRAIN, 190)
	carbon_target.spawn_gibs()
	brain.Remove(carbon_target)
	head?.receive_damage(95)
	head?.drop_limb(FALSE, TRUE, TRUE)
	head.throw_at(pick(view(3, carbon_target)))
	head.AddElement(/datum/element/decal/blood, _color = blood_color)
	brain.AddElement(/datum/element/decal/blood, _color = blood_color)
	brain.forceMove(carbon_target.drop_location())

	var/count = rand(1, length(bloody_turfs))

	for(var/i in 3 to count)
		var/turf/bloody_turf = pick_n_take(bloody_turfs)
		var/obj/effect/decal/cleanable/blood/blood_spot = new(bloody_turf)
		blood_spot.add_blood_DNA(blood_dna)

	var/obj/effect/decal/cleanable/blood/hitsplatter/blood_shower = new(
			null,
			null,
			blood_dna,
		)

	blood_shower.setDir(NORTH)
	blood_shower.pixel_z = 10
	blood_shower.layer = ABOVE_ALL_MOB_LAYER
	blood_shower.vis_flags = VIS_INHERIT_PLANE
	carbon_target.vis_contents += blood_shower
	QDEL_IN(blood_shower, FAKE_EFFECTS_LIFETIME)

	blood_shower.pixel_z = 10
	blood_shower.layer = ABOVE_MOB_LAYER

/datum/action/cooldown/spell/pointed/headburst/after_cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/initial_target = cast_on
	var/aftercast_range = base_aftercast_range + ((spell_level -1) * range_per_level)
	var/delay = BASE_AFTERCAST_JUMP_INTERVAL

	for(var/mob/living/carbon/current_target in view(aftercast_range, initial_target))
		if(initial_target == current_target)
			continue

		if(!is_valid_target(current_target))
			continue

		addtimer(CALLBACK(src, PROC_REF(chainburst), initial_target, current_target), delay)
		delay += AFTERCAST_JUMP_INTERVAL
		initial_target = current_target

/datum/action/cooldown/spell/pointed/headburst/proc/inflate(atom/cast_on)
	var/mob/living/carbon/carbon_target = cast_on
	var/obj/item/bodypart/head/head = carbon_target.get_bodypart(BODY_ZONE_HEAD)
	var/list/head_overlays = head.get_limb_icon(FALSE)

	carbon_target.visible_message(
		span_bolddanger("You watch as [carbon_target]'s head begin to inflate"),
		pick(span_userdanger("You feel your head suddenly begin to swell."), span_userdanger("You feel a crushing pressure building inside your skull")),
		span_bolddanger("You can hear someone's head bursting like a balloon")
	)

	head_overlays += head.get_eye_overlays()
	head_overlays += head.get_hair_overlays()

	//why can't we get a normal way to get overlays for item slots?
	head_overlays += carbon_target.overlays_standing[HEAD_LAYER]
	head_overlays += carbon_target.overlays_standing[GLASSES_LAYER]
	head_overlays += carbon_target.overlays_standing[FACEMASK_LAYER]
	head_overlays += carbon_target.overlays_standing[EARS_LAYER]


	var/mutable_appearance/fake_head = mutable_appearance(
		layer = ABOVE_MOB_LAYER,
		appearance_flags = KEEP_TOGETHER
		)

	fake_head.overlays += head_overlays

	// attaches our fake head to a layer
	var/atom/movable/flick_visual/our_head = carbon_target.flick_overlay_view(
			fake_head,
			duration = FAKE_EFFECTS_LIFETIME
		)
	our_head.vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	our_head.pixel_z = -1

	animate(our_head, transform = matrix().Scale(1.5), time = FAKE_EFFECTS_LIFETIME, color = COLOR_RED)


/datum/action/cooldown/spell/pointed/headburst/proc/drop_body(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_FORCED_STANDING, REF(src))

/datum/action/cooldown/spell/pointed/headburst/proc/chainburst(mob/living/carbon/prev_target, mob/living/carbon/current_target)
	var/aftercast_range = base_aftercast_range + ((spell_level -1) * range_per_level)
	var/beam_time = base_beam_time - ((spell_level -1) * beam_time_per_level)

	if(QDELETED(prev_target) || QDELETED(current_target))
		return

	if(get_dist(prev_target, current_target) > aftercast_range)
		return

	if(!is_valid_target(current_target))
		return

	playsound(prev_target, 'sound/effects/magic/blind.ogg', 15, TRUE, vary = TRUE)

	prev_target.visible_message(
		span_bolddanger("Deadly beam suddenly jumps from [prev_target] to [current_target]!")
		)

	prev_target.Beam(current_target, "blood", 'icons/effects/beam.dmi', beam_time, layer = ABOVE_ALL_MOB_LAYER)
	cast(current_target)

#undef FAKE_EFFECTS_LIFETIME
#undef BASE_AFTERCAST_JUMP_INTERVAL
#undef AFTERCAST_JUMP_INTERVAL
