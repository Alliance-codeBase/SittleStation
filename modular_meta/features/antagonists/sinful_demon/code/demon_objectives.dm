GLOBAL_LIST_EMPTY(demon_absorbed_highrisk_items)

/datum/objective/demon_absorb_highrisk
	explanation_text = "Locate a high-risk item on the station, hold it in your hands for 10 seconds to absorb its essence."
	var/target_type
	var/target_name = "high-risk item"
	var/time_held = 0
	var/required_hold_time = 10
	var/static/list/highrisk_types = list(
		/obj/item/disk/nuclear,
		/obj/item/blackbox,
		/obj/item/hand_tele,
		/obj/item/tank/jetpack/captain,
		/obj/item/clothing/shoes/magboots/advance,
		/obj/item/reagent_containers/hypospray/cmo,
	)

/datum/objective/demon_absorb_highrisk/New()
	..()
	target_type = pick(highrisk_types)

	var/obj/item/dummy = target_type
	if(dummy)
		target_name = initial(dummy.name)

	explanation_text = "Locate the exact [target_name] on the station, hold it in your hands for 10 seconds to absorb its infernal essence. Reward is 300 Sin Points."
	RegisterSignal(src, "absorb_item_tick", PROC_REF(process_tick))

/datum/objective/demon_absorb_highrisk/proc/get_progress_text()
	if(completed)
		return "SUCCESS: Absorbed the essence of the [target_name]!"
	return "Hold the [target_name] in your hands. Progress: [round(time_held)]s / [required_hold_time]s"

/datum/objective/demon_absorb_highrisk/proc/process_tick(datum/source, mob/living/carbon/human/H, seconds_per_tick)
	SIGNAL_HANDLER
	if(completed)
		return

	var/obj/item/held_item = H.get_active_held_item() || H.get_inactive_held_item()
	if(!held_item)
		time_held = max(0, time_held - seconds_per_tick)
		SStgui.update_uis(H)
		return

	var/is_valid = FALSE
	if(target_type)
		if(held_item.type == target_type)
			is_valid = TRUE
	else
		if(highrisk_types.Find(held_item.type))
			is_valid = TRUE

	if(!is_valid)
		time_held = max(0, time_held - seconds_per_tick)
		SStgui.update_uis(H)
		return

	time_held += seconds_per_tick
	SStgui.update_uis(H)

	if(time_held >= required_hold_time)
		trigger_absorption(H, held_item)

datum/objective/demon_absorb_highrisk/proc/trigger_absorption(mob/living/carbon/human/H, obj/item/I)
	completed = TRUE
	to_chat(H, span_purple("You successfully absorb the essence of the [I.name]! It turns blood-red!"))

	I.color = "#ff0000"
	GLOB.demon_absorbed_highrisk_items += I

	var/datum/antagonist/sinfuldemon/demon = H.mind?.has_antag_datum(/datum/antagonist/sinfuldemon)
	if(demon)
		SEND_SIGNAL(demon, "demon_give_points", 300)
		demon.objectives -= src

	var/turf/open/T = get_turf(I)
	if(T)
		new /obj/effect/particle_effect/fluid/smoke(T)

	var/list/turfs = list()
	for(var/turf/open/floor/ST in world)
		if(is_station_level(ST.z))
			turfs += ST

	if(length(turfs))
		var/turf/new_loc = pick(turfs)
		var/area/new_area = get_area(new_loc)

		log_game("[key_name(H)] absorbed [I.name] ([I.type]). The item teleported to [new_area ? new_area.name : "Unknown Area"].")

		message_admins("[key_name_admin(H)] absorbed high-risk [I.name]. Teleported to: <b>[new_area ? new_area.name : "Unknown Area"]</b>.")

		I.forceMove(new_loc)
		new /obj/effect/particle_effect/fluid/smoke(new_loc)
	else
		log_game("[key_name(H)] absorbed [I.name] ([I.type]). Item was hard-deleted (qdel) due to missing valid station turfs.")
		message_admins("[key_name_admin(H)] absorbed high-risk [I.name]. Item was DELETED (qdel) because no valid station floors were found.")
		qdel(I)

	qdel(src)

/datum/objective/demon_corrupt_area
	explanation_text = "Lurk in a vital department or room to break the lights."
	var/area/target_area
	var/time_spent = 0
	var/required_time = 120
	var/currently_corrupting = FALSE
	var/list/corrupted_tiles = list()

/datum/objective/demon_corrupt_area/New()
	..()
	pick_target_area()
	RegisterSignal(src, "corrupt_area_tick", PROC_REF(process_tick))

/datum/objective/demon_corrupt_area/proc/pick_target_area()
	var/list/valid_areas = list()
	for(var/area/A in world)
		if(!is_station_level(A.z) || !length(A.contents))
			continue
		if(istype(A, /area/station/hallway) || istype(A, /area/station/maintenance) || istype(A, /area/station/engineering/supermatter) || istype(A, /area/station/service/chapel) || istype(A, /area/station/ai) || istype(A, /area/space))
			continue
		valid_areas += A
	if(length(valid_areas))
		target_area = pick(valid_areas)
		explanation_text = "Lurk inside [target_area.name] for 2 minutes to completely corrupt its power and smash the lights. Reward is 250 Sin Points."

/datum/objective/demon_corrupt_area/proc/get_progress_text()
	if(completed)
		return "SUCCESS: Plunged [target_area ? target_area.name : "the area"] into dark corruption!"
	if(!target_area)
		return "Corrupt a vital station department."
	return "Lurk inside [target_area.name]. Progress: [round(time_spent)]s / [required_time]s"

/datum/objective/demon_corrupt_area/proc/process_tick(datum/source, mob/living/living_mob, seconds_per_tick, mob/living/bystander)
	SIGNAL_HANDLER
	var/list/area_turfs = get_area_turfs(target_area)
	if(completed || !target_area)
		return

	var/area/current_area = get_area(living_mob)
	if(!current_area)
		return

	if(!istype(current_area, target_area.type))
		return

	time_spent += seconds_per_tick

	var/datum/antagonist/sinfuldemon/demon = living_mob.mind?.has_antag_datum(/datum/antagonist/sinfuldemon)
	if(demon)
		SStgui.update_uis(demon)

	if(time_spent >= required_time)
		trigger_corruption(living_mob) //living?
	if(currently_corrupting || completed || !target_area)
		return
	corrupt_tiles(area_turfs, beam_source = living_mob)

/datum/objective/demon_corrupt_area/proc/trigger_corruption(mob/living/living_mob)
	completed = TRUE
	to_chat(living_mob, span_userdanger("The darkness takes over! The lights in [target_area.name] shatter from your presence!"))

	var/datum/antagonist/sinfuldemon/demon = living_mob.mind?.has_antag_datum(/datum/antagonist/sinfuldemon)
	if(demon)
		SEND_SIGNAL(demon, "demon_give_points", 250)
		demon.objectives -= src

	for(var/obj/machinery/light/L_fixture in target_area)
		L_fixture.break_light_tube()

	qdel(src)

/** TODO: RELOCATE THIS TO /datum/antagonist/demon - it allows to proc call it much easier**/
/// Args:
/// - Tiles to corrupt - list of tiles to corrupt.
/// - beam_source - atom, our demon or anything to cast a beam from.
/// - Shuffle - boolean, whether shall be var/list/valid_tiles shuffled and cd applied.
/datum/objective/demon_corrupt_area/proc/corrupt_tiles(list/tiles_to_corrupt, atom/movable/beam_source, shuffle = TRUE )
	set waitfor = FALSE
	currently_corrupting = TRUE
	var/list/valid_tiles = list()
	if(!corrupted_tiles)
		corrupted_tiles = list()

	for(var/turf/valid_tile in tiles_to_corrupt)
		if(istype(valid_tile, /turf/closed))
			return
		else
			valid_tile += valid_tiles

	if(shuffle)
		valid_tiles = shuffle(valid_tiles)

	for(var/turf/area_turf in valid_tiles)
		if(QDELETED(beam_source) || get_area(beam_source) != target_area)
			break
		if(area_turf in corrupted_tiles)
			continue
		if(istype(area_turf, /turf/closed))
			continue

		corrupted_tiles += area_turf
		new /obj/effect/temp_visual/cult/turf/floor(area_turf)
		new /obj/effect/turf_decal/tile/dark_red/full(area_turf)
		playsound(area_turf, 'sound/effects/magic/enter_blood.ogg', 100, TRUE)
		if(beam_source)
			beam_source.Beam(area_turf, "sendbeam", 'icons/effects/beam.dmi', 2 SECONDS)
		if(shuffle) // if it's not shuffled, why bother delaying it?
			sleep(0.5 SECONDS)

	currently_corrupting = FALSE

/// todo:
/*
obj lurk - shall be visually represented, aka tile effect or etc
gameplay wise - it should give buffs demon (when corrupted)
corrupted tiles should slowdown people.
*/

/*

var/list/valid_turfs = list()

*/
