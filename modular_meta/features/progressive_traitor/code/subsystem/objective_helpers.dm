/datum/controller/subsystem/traitor/proc/on_objective_taken(datum/traitor_objective/objective)
	if(!istype(objective))
		return

	add_objective_to_list(objective, taken_objectives_by_type)

/datum/controller/subsystem/traitor/proc/get_taken_count(datum/traitor_objective/objective_type)
	return length(taken_objectives_by_type[objective_type])


/datum/controller/subsystem/traitor/proc/add_objective_to_list(datum/traitor_objective/objective, list/objective_list)
	var/datum/traitor_objective/current_type = objective.type
	while(current_type != /datum/traitor_objective)
		if(!objective_list[current_type])
			objective_list[current_type] = list(objective)
		else
			objective_list[current_type] += objective
		current_type = current_type::parent_type
