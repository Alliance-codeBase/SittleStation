/*
 * Generate a list of singleton loadout_item datums from all subtypes of [type_to_generate]
 *
 * returns a list of singleton datums.
 */
/proc/generate_loadout_items(type_to_generate)
	RETURN_TYPE(/list)

	. = list()
	if(!ispath(type_to_generate))
		CRASH("generate_loadout_items(): called with an invalid or null path as an argument!")

	for(var/datum/loadout_item/found_type as anything in subtypesof(type_to_generate))
		/// Any item without a name is "abstract"
		if(isnull(initial(found_type.name)))
			continue

		if(!ispath(initial(found_type.item_path)))
			stack_trace("generate_loadout_items(): Attempted to instantiate a loadout item ([initial(found_type.name)]) with an invalid or null typepath! (got path: [initial(found_type.item_path)])")
			continue

		var/datum/loadout_item/spawned_type = new found_type()
		GLOB.all_loadout_datums[spawned_type.item_path] = spawned_type
		. |= spawned_type

/datum/loadout_item
	/// If set, is a list of job names of which can get the loadout item
	var/list/restricted_roles
	/// If set, is a list of job names of which can't get the loadout item
	var/list/blacklisted_roles

/*
 * Place our [var/item_path] into [outfit].
 *
 * By default, just adds the item into the outfit's backpack contents, if non-visual.
 *
 * equipper - If we're equipping our outfit onto a mob at the time, this is the mob it is equipped on. Can be null.
 * outfit - The outfit we're equipping our items into.
 * visual - If TRUE, then our outfit is only for visual use (for example, a preview).
 * override_items - The type of override to use.
 */
/datum/loadout_item/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(!visuals_only)
		LAZYADD(outfit.backpack_contents, item_path)

/*
 * To be called before insert_path_into_outfit()
 *
 * Checks if an important_for_life item exists and puts the loadout item into the backpack if they would take up the same slot as it.
 *
 * equipper - If we're equipping our outfit onto a mob at the time, this is the mob it is equipped on. Can be null.
 * outfit - The outfit we're equipping our items into.
 * outfit_important_for_life - The outfit whose slots we want to make sure we don't equip an item into.
 * visual - If TRUE, then our outfit is only for visual use (for example, a preview).
 *
 * Returns TRUE if there is an important_for_life item in the slot that the loadout item would normally occupy, FALSE otherwise
 */
/datum/loadout_item/proc/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(!visuals_only)
		LAZYADD(outfit.backpack_contents, item_path)

/*
 * Called after the item is equipped on [equipper], at the end of character setup.
 */
/datum/loadout_item/proc/post_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper)
	return FALSE

/**
 * Called before a loadout item is given to a mob, making sure that they're
 * elligible to receive it, based on all of that item's restrictions, if any.
 *
 * Returns `TRUE` if `target` is allowed to receive this item, `FALSE` if not.
 */
/datum/loadout_item/proc/can_be_applied_to(mob/living/target, datum/preferences/preference_source, datum/job/equipping_job, silent = FALSE, visuals_only)
	var/client/client = preference_source.parent

	if(equipping_job)
		var/title = equipping_job.title

		if(restricted_roles && !(title in restricted_roles))
			if(!visuals_only)
				message_client(client, target, "job restrictions")
			return FALSE

		if(blacklisted_roles && (title in blacklisted_roles))
			if(!visuals_only)
				message_client(client, target, "job blacklist")
			return FALSE

	return TRUE

/// Tells the client we couldn't equip their item
/datum/loadout_item/proc/message_client(client, target, msg)
	if(client)
		to_chat(target, span_warning("You were unable to get a loadout item ([initial(item_path.name)]) due to [msg]!"))
	return FALSE

/datum/loadout_item/to_ui_data()
	var/list/formatted_item = ..()
	formatted_item["restricted_roles"] = restricted_roles
	formatted_item["blacklisted_roles"] = blacklisted_roles

	return formatted_item
