/datum/antagonist/traitor
	/// Code that allows traitor to get a replacement uplink
	var/replacement_uplink_code = ""
	/// Radio frequency that traitor must speak on to get a replacement uplink
	var/replacement_uplink_frequency = ""


/datum/antagonist/traitor/infiltrator
	// Used to denote traitors who have joined midround and therefore have no access to secondary objectives.
	// Progression elements are best left to the roundstart antagonists
	// There will still be a timelock on uplink items
	name = "\improper Infiltrator"
	give_secondary_objectives = FALSE
	uplink_flag_given = UPLINK_INFILTRATORS

/datum/antagonist/traitor/infiltrator/sleeper_agent
	name = "\improper Syndicate Sleeper Agent"


/datum/antagonist/traitor/on_gain()
	. = ..()

	if(give_secondary_objectives)
		uplink_handler.has_objectives = TRUE
		uplink_handler.generate_objectives()

	generate_replacement_codes()
	owner.teach_crafting_recipe(/datum/crafting_recipe/syndicate_uplink_beacon)
