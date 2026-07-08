/datum/mind/traitor_panel()
	if(!SSticker.HasRoundStarted())
		tgui_alert(usr, "Not before round-start!", "Alert")
		return
	if(QDELETED(src))
		tgui_alert(usr, "This mind doesn't have a mob, or is deleted! For some reason!", "Edit Memory")
		return

	var/out = "<B>[name]</B>[(current && (current.real_name != name))?" (as [current.real_name])":""]<br>"
	out += "Mind currently owned by key: [key] [active?"(synced)":"(not synced)"]<br>"
	out += "Assigned role: [assigned_role.title]. <a href='byond://?src=[REF(src)];role_edit=1'>Edit</a><br>"
	out += "<a href='byond://?_src_=holder;[HrefToken()];check_teams=1'>Show Teams</a><br><br>"

	var/special_statuses = get_special_roles() | get_special_statuses()
	if(length(special_statuses))
		out += "Roles: [jointext(special_statuses, " | ")]<br>"

	if(!GLOB.antag_prototypes)
		GLOB.antag_prototypes = list()
		for(var/antag_type in subtypesof(/datum/antagonist))
			var/datum/antagonist/A = new antag_type
			var/cat_id = A.antagpanel_category
			if(!GLOB.antag_prototypes[cat_id])
				GLOB.antag_prototypes[cat_id] = list(A)
			else
				GLOB.antag_prototypes[cat_id] += A
	sortTim(GLOB.antag_prototypes, GLOBAL_PROC_REF(cmp_text_asc),associative=TRUE)

	var/list/sections = list()
	var/list/priority_sections = list()

	for(var/antag_category in GLOB.antag_prototypes)
		var/category_header = "<i><b>[antag_category]:</b></i>"
		var/list/antag_header_parts = list(category_header)

		var/datum/antagonist/current_antag
		var/list/possible_admin_antags = list()

		for(var/datum/antagonist/prototype in GLOB.antag_prototypes[antag_category])
			var/datum/antagonist/A = has_antag_datum(prototype.type)
			if(A)
				//We got the antag
				if(!current_antag)
					current_antag = A
				else
					continue //Let's skip subtypes of what we already shown.
			else if(prototype.show_in_antagpanel)
				if(prototype.can_be_owned(src))
					possible_admin_antags += "<a href='byond://?src=[REF(src)];add_antag=[prototype.type]' title='[prototype.type]'>[prototype.name]</a>"
				else
					possible_admin_antags += "<a class='linkOff'>[prototype.name]</a>"
			else
				//We don't have it and it shouldn't be shown as an option to be added.
				continue

		if(!current_antag) //Show antagging options
			if(possible_admin_antags.len)
				antag_header_parts += span_highlight("None")
				antag_header_parts += possible_admin_antags
			else
				//If there's no antags to show in this category skip the section completely
				continue
		else //Show removal and current one
			priority_sections |= antag_category
			antag_header_parts += span_bad("[current_antag.name]")
			antag_header_parts += "<a href='byond://?src=[REF(src)];remove_antag=[REF(current_antag)]'>Remove</a>"
			antag_header_parts += "<a href='byond://?src=[REF(src)];open_antag_vv=[REF(current_antag)]'>Open VV</a>"


		//We aren't antag of this category, grab first prototype to check the prefs (This is pretty vague but really not sure how else to do this)
		var/datum/antagonist/pref_source = current_antag
		if(!pref_source)
			for(var/datum/antagonist/prototype in GLOB.antag_prototypes[antag_category])
				if(!prototype.show_in_antagpanel)
					continue
				pref_source = prototype
				break
		if(pref_source.pref_flag)
			antag_header_parts += pref_source.enabled_in_preferences(src) ? "Enabled in Prefs" : "Disabled in Prefs"

		//Traitor : None | Traitor | IAA
		// Command1 | Command2 | Command3
		// Secret Word : Banana
		// Objectives:
		// 1.Do the thing [a][b]
		// [a][b]
		// Memory:
		// Uplink Code: 777 Alpha
		var/cat_section = antag_header_parts.Join(" | ") + "<br>"
		if(current_antag)
			cat_section += current_antag.antag_panel()
		sections[antag_category] = cat_section

	for(var/s in priority_sections)
		out += sections[s]
	for(var/s in sections - priority_sections)
		out += sections[s]

	out += "<br>"

	//Uplink
	if(ishuman(current))
		var/uplink_info = "<i><b>Uplink</b></i>:"
		var/datum/component/uplink/U = find_syndicate_uplink()
		if(U)
			//MASSMETA EDIT ADDITION BEGIN (progressive_traitor)
			if(!U.uplink_handler.has_objectives)
				uplink_info += "<a href='byond://?src=[REF(src)];common=takeuplink'>take</a>"
			//MASSMETA EDIT ADDITION END (progressive_traitor)
			if (check_rights(R_FUN, 0))
				uplink_info += ", <a href='byond://?src=[REF(src)];common=crystals'>[U.uplink_handler.telecrystals]</a> TC"
				if(U.uplink_handler.has_progression)
					uplink_info += ", <a href='byond://?src=[REF(src)];common=progression'>[U.uplink_handler.progression_points]</a> PR"
				//MASSMETA EDIT ADDITION BEGIN (progressive_traitor)
				if(U.uplink_handler.has_objectives)
					uplink_info += ", <a href='byond://?src=[REF(src)];common=give_objective'>Force Give Objective</a>"
				//MASSMETA EDIT ADDITION END (progressive_traitor)
			else
				uplink_info += ", [U.uplink_handler.telecrystals] TC"
				if(U.uplink_handler.has_progression)
					uplink_info += ", [U.uplink_handler.progression_points] PR"
		else
			uplink_info += "<a href='byond://?src=[REF(src)];common=uplink'>give</a>"
		uplink_info += "." //hiel grammar

		out += uplink_info + "<br>"
	//Other stuff
	out += get_common_admin_commands()

	var/datum/browser/panel = new(usr, "traitorpanel", "", 600, 600)
	panel.set_content(out)
	panel.open()
	return
