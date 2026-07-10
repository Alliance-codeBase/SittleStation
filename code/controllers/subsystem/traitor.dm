SUBSYSTEM_DEF(traitor)
	name = "Traitor"
	dependencies = list(
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/atoms,
	)
	ss_flags = SS_KEEP_TIMING
	wait = 10 SECONDS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	/// A list of all uplink items mapped by type
	var/list/uplink_items_by_type = list()
	/// A list of all uplink items
	var/list/uplink_items = list()

	/// The coefficient multiplied by the current_global_progression for new joining traitors to calculate their progression
	var/newjoin_progression_coeff = 1
	/// The current progression that all traitors should be at in the round, you can't have less than this
	var/current_global_progression = 0
<<<<<<< HEAD
	/// The current uplink handlers being managed
	var/list/datum/uplink_handler/uplink_handlers = list()
	/// The current scaling per minute of progression.
	var/current_progression_scaling = 1 MINUTES
	/// List of code words for traitors
	var/syndicate_code_phrase
	/// List of code responses for traitors
	var/syndicate_code_response
	/// Regex of code words for traitors
	var/regex/syndicate_code_phrase_regex
	/// Regex of code responses for traitors
	var/regex/syndicate_code_response_regex

=======
	/// The amount of deviance from the current global progression before you start getting 2x the current scaling or no scaling at all

	//MASSMETA ADDDITION START (re_traitorsecondary)

	var/list/datum/uplink_handler/uplink_handlers = list()
	/// The current scaling per minute of progression. Has a maximum value of 1 MINUTES.
	var/current_progression_scaling = 1 MINUTES
	/// Used to handle the probability of getting an objective.
	var/datum/traitor_category_handler/category_handler
	/// The current debug handler for objectives. Used for debugging objectives
	var/datum/traitor_objective_debug/traitor_debug_panel
	/// Used by the debug menu, decides whether newly created objectives should generate progression and telecrystals. Do not modify for non-debug purposes.
	var/generate_objectives = TRUE
	/// Objectives that have been completed by type. Used for limiting objectives.
	var/list/taken_objectives_by_type = list()
	/// A list of all existing objectives by type
	var/list/all_objectives_by_type = list()
	//MASSMETA ADDDITION END (re_traitorsecondary)
>>>>>>> parent of c1c522274a5 (Merge branch 'efficency' of https://github.com/Glamyrio/PostMeta into fixes)
/datum/controller/subsystem/traitor/Initialize()
	current_progression_scaling = 1 MINUTES * CONFIG_GET(number/traitor_scaling_multiplier)
	for(var/theft_item in subtypesof(/datum/objective_item/steal))
		new theft_item
<<<<<<< HEAD

	syndicate_code_phrase = generate_code_phrase(return_list = TRUE)
	syndicate_code_phrase_regex = new("([jointext(syndicate_code_phrase, "|")])", "ig")
	syndicate_code_response = generate_code_phrase(return_list = TRUE)
	syndicate_code_response_regex = new("([jointext(syndicate_code_response, "|")])", "ig")
=======
	//MASSMETA ADDITION START (re_traitor_secondary)
	if(fexists(configuration_path))
		var/list/data = json_decode(file2text(file(configuration_path)))
		for(var/typepath in data)
			var/actual_typepath = text2path(typepath)
			if(!actual_typepath)
				log_world("[configuration_path] has an invalid type ([typepath]) that doesn't exist in the codebase! Please correct or remove [typepath]")
			configuration_data[actual_typepath] = data[typepath]
	//MASSMETA ADDITION END (re_traitor_secondary)
>>>>>>> parent of c1c522274a5 (Merge branch 'efficency' of https://github.com/Glamyrio/PostMeta into fixes)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/traitor/fire(resumed)
	var/previous_progression = current_global_progression
	current_global_progression = (STATION_TIME_PASSED()) * CONFIG_GET(number/traitor_scaling_multiplier)
	var/progression_increment = current_global_progression - previous_progression

	for(var/datum/uplink_handler/handler in uplink_handlers)
		if(!handler.has_progression || QDELETED(handler))
			uplink_handlers -= handler
		if(handler.progression_points < current_global_progression)
			// If we got unsynced somehow, just set them to the current global progression
			// Prevents problems with precision errors.
			handler.progression_points = current_global_progression
		else
			handler.progression_points += progression_increment // Should only really happen if an admin is messing with an individual's progression value
		handler.on_update()

/datum/controller/subsystem/traitor/proc/register_uplink_handler(datum/uplink_handler/uplink_handler)
	if(!uplink_handler.has_progression)
		return
	uplink_handlers |= uplink_handler
	// An uplink handler can be registered multiple times if they get assigned to new uplinks, so
	// override is set to TRUE here because it is intentional that they could get added multiple times.
	RegisterSignal(uplink_handler, COMSIG_QDELETING, PROC_REF(uplink_handler_deleted), override = TRUE)

/datum/controller/subsystem/traitor/proc/uplink_handler_deleted(datum/uplink_handler/uplink_handler)
	SIGNAL_HANDLER
	uplink_handlers -= uplink_handler
