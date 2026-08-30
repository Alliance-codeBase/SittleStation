/datum/action/cooldown/spell/pointed/headburst
	name = "Headburster"
	desc = "This spell after a brief wait sends a deadly beam capable of bursting your target's head"
	cooldown_time = 20 SECONDS
	cast_range = 5
	invocation = "H'D BR'ST!!"
	invocation_type = INVOCATION_SHOUT
	sparks_amt = 3
	spell_max_level = 3
	var/charging = FALSE
	var/beam_time = 10 SECONDS
	//sound =
	//icon = ''
	//icon_state = ""

/datum/action/cooldown/spell/pointed/headburst/is_valid_target(atom/cast_on)
	. = ..()

	if(!ishuman(cast_on))
		return FALSE

	if(!.)
		return FALSE

	var/mob/living/carbon/carbon_target = cast_on
	var/obj/item/bodypart/head = carbon_target.get_bodypart(BODY_ZONE_HEAD)
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
	var/datum/beam/beam = owner.Beam(cast_on, "r_beam", 'icons/effects/beam.dmi', beam_time, layer = ABOVE_ALL_MOB_LAYER)
	charging = TRUE
	INVOKE_ASYNC(src, PROC_REF(play_charging_sound))
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
	carbon_target.Stun(3 SECONDS)
	addtimer(CALLBACK(cast_on, TYPE_PROC_REF(/mob/living/carbon, headburst), cast_on), 3 SECONDS)
	addtimer(CALLBACK(cast_on, PROC_REF(drop_body), cast_on), 4.2 SECONDS)
	ADD_TRAIT(carbon_target, TRAIT_FORCED_STANDING, REF(src))
	carbon_target.inflate_head(carbon_target)
	charging = FALSE

/mob/living/carbon/proc/headburst(atom/cast_on)
	var/mob/living/carbon/carbon_target = cast_on
	var/obj/item/bodypart/head = carbon_target?.get_bodypart(BODY_ZONE_HEAD)
	var/list/blood_dna = carbon_target?.get_blood_dna_list()
	var/obj/item/organ/brain = carbon_target?.get_organ_slot(ORGAN_SLOT_BRAIN) // some people are brainless, or may lose their brain while we cast, that's why we use ?.

	playsound(carbon_target, 'sound/effects/wounds/crackandbleed.ogg', 100)
	playsound(carbon_target, 'sound/effects/splat.ogg', 50, TRUE)
	playsound(carbon_target, 'modular_meta/features/antagonists/sound/blood_spray.ogg', 35)
	carbon_target.spawn_gibs()
	head.drop_limb(FALSE, TRUE, TRUE)
	brain.Remove(carbon_target)
	brain.add_mob_blood(carbon_target)

	brain.forceMove(carbon_target.drop_location())

	qdel(head)
	for(var/turf/bloody_turf in view(1, carbon_target))
		var/obj/effect/decal/cleanable/blood/blood_spot = new(bloody_turf)
		blood_spot.add_blood_DNA(blood_dna)

	var/obj/effect/decal/cleanable/blood/hitsplatter/blood_shower = new(
			get_turf(carbon_target),
			null,
			blood_dna,
		)
	blood_shower.setDir(NORTH)
	blood_shower.pixel_z = 10
	blood_shower.layer = ABOVE_ALL_MOB_LAYER
	QDEL_IN(blood_shower, 1 SECONDS)

	blood_shower.pixel_z = 10
	blood_shower.layer = ABOVE_MOB_LAYER

/mob/living/carbon/proc/inflate_head(atom/cast_on)
	var/mob/living/carbon/carbon_target = cast_on
	var/obj/item/bodypart/head/head = carbon_target.get_bodypart(BODY_ZONE_HEAD)
	var/list/head_overlays = head.get_limb_icon(FALSE)

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
	var/atom/movable/flick_visual/our_head = cast_on.flick_overlay_view(
			fake_head,
			3 SECONDS
		)
	our_head.vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	animate(our_head, transform = matrix().Scale(1.5), time = 3 SECONDS, color = COLOR_RED)
	addtimer(CALLBACK(cast_on, TYPE_PROC_REF(/datum/action/cooldown/spell/pointed/headburst, clean_debris), our_head), 3.2 SECONDS)

/datum/action/cooldown/spell/pointed/headburst/proc/clean_debris(fake_head)
	qdel(fake_head)

/datum/action/cooldown/spell/pointed/headburst/proc/drop_body(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_FORCED_STANDING, REF(src))
