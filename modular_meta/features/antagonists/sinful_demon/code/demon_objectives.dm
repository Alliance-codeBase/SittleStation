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

/datum/objective/demon_absorb_highrisk/proc/process_tick(datum/source, mob/living/carbon/human/human, seconds_per_tick)
	SIGNAL_HANDLER
	if(completed)
		return

	var/obj/item/held_item = human.get_active_held_item() || human.get_inactive_held_item()
	if(!held_item)
		time_held = max(0, time_held - seconds_per_tick)
		SStgui.update_uis(human)
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
		SStgui.update_uis(human)
		return

	time_held += seconds_per_tick
	SStgui.update_uis(human)

	if(time_held >= required_hold_time)
		trigger_absorption(human, held_item)

/datum/objective/demon_absorb_highrisk/proc/trigger_absorption(mob/living/carbon/human/human, obj/item/item)
	completed = TRUE
	to_chat(human, span_purple("You successfully absorb the essence of the [item.name]! It turns blood-red!"))

	item.color = "#ff0000"
	GLOB.demon_absorbed_highrisk_items += item

	var/datum/antagonist/sinfuldemon/demon = human.mind?.has_antag_datum(/datum/antagonist/sinfuldemon)
	if(demon)
		SEND_SIGNAL(demon, "demon_give_points", 300)
		demon.objectives -= src

	var/turf/open/T = get_turf(item)
	if(T)
		new /obj/effect/particle_effect/fluid/smoke(T)

	var/list/turfs = list()
	for(var/turf/open/floor/ST in world)
		if(is_station_level(ST.z))
			turfs += ST

	if(length(turfs))
		var/turf/new_loc = pick(turfs)
		var/area/new_area = get_area(new_loc)

		log_game("[key_name(human)] absorbed [item.name] ([item.type]). The item teleported to [new_area ? new_area.name : "Unknown Area"].")

		message_admins("[key_name_admin(human)] absorbed high-risk [item.name]. Teleported to: <b>[new_area ? new_area.name : "Unknown Area"]</b>.")

		item.forceMove(new_loc)
		new /obj/effect/particle_effect/fluid/smoke(new_loc)
	else
		log_game("[key_name(human)] absorbed [item.name] ([item.type]). Item was hard-deleted (qdel) due to missing valid station turfs.")
		message_admins("[key_name_admin(human)] absorbed high-risk [item.name]. Item was DELETED (qdel) because no valid station floors were found.")
		qdel(item)

	qdel(src)

/datum/objective/demon_corrupt_area
	explanation_text = "Lurk in a vital department or room to break the lights."
	var/area/target_area
	var/time_spent = 0
	var/required_time = 120

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
		trigger_corruption(living_mob)
	if(completed || !target_area)
		return
	demon.corrupt_tiles(area_turfs, living_mob,target_area, TRUE)

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

/// Args:
/// - Tiles to corrupt - list of tiles to corrupt.
/// - beam_source - atom, our demon or anything to cast a beam from.
/// - Shuffle - boolean, whether shall be var/list/valid_tiles shuffled and cd applied.
/datum/antagonist/sinfuldemon/proc/corrupt_tiles(list/tiles_to_corrupt, atom/movable/beam_source, area/target_area, shuffle = TRUE)
	set waitfor = FALSE
	var/mob/demon_mob = beam_source

	if(currently_corrupting)
		return

	currently_corrupting = TRUE

	if(!corrupted_tiles)
		corrupted_tiles = list()

	var/list/valid_tiles = list()

	for(var/turf/valid_tile in tiles_to_corrupt)
		if(istype(valid_tile, /turf/closed))
			continue
		else
			valid_tiles += valid_tile

	if(shuffle)
		valid_tiles = shuffle(valid_tiles)

	for(var/turf/area_turf in valid_tiles)
		if(QDELETED(beam_source) || !demon_mob.mind.has_antag_datum(/datum/antagonist/sinfuldemon) || get_area(beam_source) != target_area)
			currently_corrupting = FALSE
			break

		if(area_turf in corrupted_tiles)
			continue

		if(istype(area_turf, /turf/closed))
			continue

		corrupted_tiles += area_turf
		new /obj/effect/temp_visual/cult/turf/floor(area_turf)
		playsound(area_turf, 'sound/effects/magic/enter_blood.ogg', 100, TRUE)
		sleep(0.5 SECONDS)
		new /obj/effect/turf_decal/tile/dark_red/full(area_turf) // temporary
		if(beam_source)
			send_unique_beam(area_turf, beam_source)
		if(shuffle) // if it's not shuffled, why bother delaying it?
			sleep(1 SECONDS)

	currently_corrupting = FALSE


/// todo:
/*
obj lurk - shall be visually represented, aka tile effect or etc
gameplay wise - it should give buffs demon (when corrupted)
corrupted tiles should slowdown people.
*/
