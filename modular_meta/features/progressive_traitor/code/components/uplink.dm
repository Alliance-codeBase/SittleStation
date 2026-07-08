/datum/component/uplink/Initialize(owner,
	lockable = TRUE,
	enabled = FALSE,
	uplink_flag = UPLINK_TRAITORS,
	starting_tc = TELECRYSTALS_DEFAULT,
	has_progression = FALSE,
	datum/uplink_handler/uplink_handler_override,)

	. = ..()

	if(!uplink_handler_override)
		uplink_handler.has_objectives = FALSE

	if(istype(parent, /obj/item/uplink/replacement))
		RegisterSignal(parent, COMSIG_MOVABLE_HEAR, PROC_REF(on_heard))

	RegisterSignal(uplink_handler, COMSIG_UPLINK_HANDLER_REPLACEMENT_ORDERED, PROC_REF(handle_uplink_replaced))


/// When a new uplink is made via the syndicate beacon it locks all lockable uplinks and destroys replacement uplinks
/datum/component/uplink/proc/handle_uplink_replaced()
	SIGNAL_HANDLER
	if(lockable)
		lock_uplink()
	if(!istype(parent, /obj/item/uplink/replacement))
		return
	var/obj/item/uplink_item = parent
	do_sparks(number = 3, cardinal_only = FALSE, source = uplink_item)
	uplink_item.visible_message(span_warning("The [uplink_item] suddenly combusts!"), vision_distance = COMBAT_MESSAGE_RANGE)
	new /obj/effect/decal/cleanable/ash(get_turf(uplink_item))
	qdel(uplink_item)

/datum/component/uplink/ui_static_data(mob/user)
	. = ..()
	.["has_objectives"] = uplink_handler.has_objectives

/datum/component/uplink/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!active)
		return
	switch(action)
		if("buy")
			var/datum/uplink_item/item
			if(params["ref"])
				item = locate(params["ref"]) in uplink_handler.extra_purchasable
				if(!item)
					return
			else
				var/datum/uplink_item/item_path = text2path(params["path"])
				if(!ispath(item_path, /datum/uplink_item))
					return
				item = SStraitor.uplink_items_by_type[item_path]
			uplink_handler.purchase_item(ui.user, item, parent)
		if("buy_raw_tc")
			if (uplink_handler.telecrystals <= 0)
				return
			var/desired_amount = tgui_input_number(ui.user, "How many raw telecrystals to buy?", "Buy Raw TC", default = uplink_handler.telecrystals, max_value = uplink_handler.telecrystals)
			if(!desired_amount || desired_amount < 1)
				return
			uplink_handler.purchase_raw_tc(ui.user, desired_amount, parent)
		if("lock")
			if(!lockable)
				return TRUE
			lock_uplink()

		if("renegotiate_objectives")
			uplink_handler.replace_objectives?.Invoke()
			SStgui.update_uis(src)

	if(!uplink_handler.has_objectives)
		return TRUE

	if(uplink_handler.owner?.current != ui.user || !uplink_handler.can_take_objectives)
		return TRUE

	switch(action)
		if("regenerate_objectives")
			uplink_handler.generate_objectives()
			return TRUE

	var/list/objectives
	switch(action)
		if("start_objective")
			objectives = uplink_handler.potential_objectives
		if("objective_act", "finish_objective", "objective_abort")
			objectives = uplink_handler.active_objectives

	if(!objectives)
		return

	var/objective_index = round(text2num(params["index"]))
	if(objective_index < 1 || objective_index > length(objectives))
		return TRUE
	var/datum/traitor_objective/objective = objectives[objective_index]

	// Objective actions
	switch(action)
		if("start_objective")
			uplink_handler.take_objective(ui.user, objective)
		if("objective_act")
			uplink_handler.ui_objective_act(ui.user, objective, params["objective_action"])
		if("finish_objective")
			if(!objective.finish_objective(ui.user))
				return
			uplink_handler.complete_objective(objective)
		if("objective_abort")
			uplink_handler.abort_objective(objective)

	return TRUE

/// Proc that unlocks a locked replacement uplink when it hears the unlock code from their datum
/datum/component/uplink/proc/on_heard(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	if(!locked)
		return
	if(!findtext(hearing_args[HEARING_RAW_MESSAGE], unlock_code))
		return
	var/atom/replacement_uplink = parent
	locked = FALSE
	replacement_uplink.balloon_alert_to_viewers("beep", vision_distance = COMBAT_MESSAGE_RANGE)

/datum/component/uplink/ui_data(mob/user)
	. = ..()
	if(uplink_handler.has_objectives)
		var/list/potential_objectives = list()
		for(var/index in 1 to uplink_handler.potential_objectives.len)
			var/datum/traitor_objective/objective = uplink_handler.potential_objectives[index]
			var/list/objective_data = objective.uplink_ui_data(user)
			objective_data["id"] = index
			potential_objectives += list(objective_data)

		var/list/active_objectives = list()
		for(var/index in 1 to uplink_handler.active_objectives.len)
			var/datum/traitor_objective/objective = uplink_handler.active_objectives[index]
			var/list/objective_data = objective.uplink_ui_data(user)
			objective_data["id"] = index
			active_objectives += list(objective_data)

		.["potential_objectives"] = potential_objectives
		.["active_objectives"] = active_objectives
		.["completed_final_objective"] = uplink_handler.final_objective
		.["maximum_active_objectives"] = uplink_handler.maximum_active_objectives
		.["maximum_potential_objectives"] = uplink_handler.maximum_potential_objectives
		.["current_expected_progression"] = SStraitor.current_global_progression
		.["progression_scaling_deviance"] = SStraitor.progression_scaling_deviance

