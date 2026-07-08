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
	generate_replacement_codes() // amazing ui shenanigans
	. = ..()

	if(give_secondary_objectives)
		uplink_handler.has_objectives = TRUE
		uplink_handler.generate_objectives()

	owner.teach_crafting_recipe(/datum/crafting_recipe/syndicate_uplink_beacon)


/// proc that generates the traitors replacement uplink code and radio frequency
/datum/antagonist/traitor/proc/generate_replacement_codes()
	replacement_uplink_code = "[pick(GLOB.phonetic_alphabet)] [rand(10,99)]"
	replacement_uplink_frequency = sanitize_frequency(rand(MIN_UNUSED_FREQ, MAX_FREQ), free = FALSE, syndie = FALSE)

/datum/antagonist/traitor/proc/traitor_objective_to_html(datum/traitor_objective/to_display)
	var/string = "[to_display.name]"
	if(to_display.objective_state == OBJECTIVE_STATE_ACTIVE || to_display.objective_state == OBJECTIVE_STATE_INACTIVE)
		string += " <a href='byond://?src=[REF(owner)];edit_obj_tc=[REF(to_display)]'>[to_display.telecrystal_reward] TC</a>"
		string += " <a href='byond://?src=[REF(owner)];edit_obj_pr=[REF(to_display)]'>[to_display.progression_reward] PR</a>"
	else
		string += ", [to_display.telecrystal_reward] TC"
		string += ", [to_display.progression_reward] PR"
	if(to_display.objective_state == OBJECTIVE_STATE_ACTIVE && !istype(to_display, /datum/traitor_objective/ultimate))
		string += " <a href='byond://?src=[REF(owner)];fail_objective=[REF(to_display)]'>Fail this objective</a>"
		string += " <a href='byond://?src=[REF(owner)];succeed_objective=[REF(to_display)]'>Succeed this objective</a>"
	if(to_display.objective_state == OBJECTIVE_STATE_INACTIVE)
		string += " <a href='byond://?src=[REF(owner)];fail_objective=[REF(to_display)]'>Dispose of this objective</a>"

	if(to_display.skipped)
		string += " - <b>Skipped</b>"
	else if(to_display.objective_state == OBJECTIVE_STATE_FAILED)
		string += " - <b><font color='red'>Failed</font></b>"
	else if(to_display.objective_state == OBJECTIVE_STATE_INVALID)
		string += " - <b>Invalidated</b>"
	else if(to_display.objective_state == OBJECTIVE_STATE_COMPLETED)
		string += " - <b><font color='green'>Succeeded</font></b>"

	return string

/datum/antagonist/traitor/antag_panel_objectives()
	var/result = ..()
	if(!uplink_handler)
		return result
	result += "<i><b>Traitor specific objectives</b></i><br>"
	result += "<i><b>Concluded Objectives</b></i>:<br>"
	for(var/datum/traitor_objective/objective as anything in uplink_handler.completed_objectives)
		result += "[traitor_objective_to_html(objective)]<br>"
	if(!length(uplink_handler.completed_objectives))
		result += "EMPTY<br>"
	result += "<i><b>Ongoing Objectives</b></i>:<br>"
	for(var/datum/traitor_objective/objective as anything in uplink_handler.active_objectives)
		result += "[traitor_objective_to_html(objective)]<br>"
	if(!length(uplink_handler.active_objectives))
		result += "EMPTY<br>"
	result += "<i><b>Potential Objectives</b></i>:<br>"
	for(var/datum/traitor_objective/objective as anything in uplink_handler.potential_objectives)
		result += "[traitor_objective_to_html(objective)]<br>"
	if(!length(uplink_handler.potential_objectives))
		result += "EMPTY<br>"
	result += "<a href='byond://?src=[REF(owner)];common=give_objective'>Force add objective</a><br>"
	return result

/datum/antagonist/traitor/on_removal()
	. = ..()
	if(!isnull(uplink_handler))
		uplink_handler.has_objectives = FALSE

	owner.forget_crafting_recipe(/datum/crafting_recipe/syndicate_uplink_beacon)

