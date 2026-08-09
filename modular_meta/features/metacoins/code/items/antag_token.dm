/datum/metacoinshop/listing/preround/antag_token
	id = "antag_token"
	name = "Antag Token"
	desc = "Guarantees one chosen antagonist role at roundstart."
	price = 650
	item_type = /obj/item/coin/antagtoken // to get the display icon of ours
	listing_type = "antag_token"

/datum/metacoinshop/antag_role
	var/id
	/// Displayed name.
	var/name
	/// Displayed description.
	var/desc
	/// as in code\modules\jobs\departments\departments.dm. Needed for UI sorting purpouses.
	var/ui_order = 100
/// Check dynamic.toml, put here your ruleset tag \
(The name of it, e.g ["Roundstart Traitor"]) Under no circumstances there shall be midround antag, or any other that spawns with unique loadout.
	var/ruleset_tag
	/// check code\__DEFINES\role_preferences.dm , when bought role is banned, then it will try to refund the metacoins.
	var/jobban_flag
	/// Your antag datum.
	var/antag_datum
	/// Defaulted value, if for some reason config is unavailable.
	var/default_min_pop = 0

/datum/metacoinshop/antag_role/proc/is_before(datum/metacoinshop/antag_role/other)
	if(ui_order != other.ui_order)
		return ui_order < other.ui_order

	return sorttext(other.id, id) < 0

/datum/metacoinshop/antag_role/traitor
	id = "traitor"
	name = "Traitor"
	ui_order = 10
	desc = "An unpaid debt. A score to be settled. Maybe you were just in the wrong \
	place at the wrong time. Whatever the reasons, you were selected to \
	infiltrate Space Station 13."
	ruleset_tag = "Roundstart Traitor"
	jobban_flag = ROLE_TRAITOR
	antag_datum = /datum/antagonist/traitor
	default_min_pop = 3

/datum/metacoinshop/antag_role/changeling
	id = "changeling"
	name = "Changeling"
	ui_order = 20
	desc = "A highly intelligent alien predator that is capable of altering their \
	shape to flawlessly resemble a human."
	ruleset_tag = "Roundstart Changeling"
	jobban_flag = ROLE_CHANGELING
	antag_datum = /datum/antagonist/changeling
	default_min_pop = 15

/datum/metacoinshop/antag_role/heretic
	id = "heretic"
	name = "Heretic"
	ui_order = 30
	desc = " Forgotten, devoured, gutted. Humanity has forgotten the eldritch forces \
	of decay, but the mansus veil has weakened. We will make them taste fear \
	again..."
	ruleset_tag = "Roundstart Heretics"
	jobban_flag = ROLE_HERETIC
	antag_datum = /datum/antagonist/heretic
	default_min_pop = 30

/datum/metacoinshop/antag_role/spy
	id = "spy"
	name = "Spy"
	ui_order = 40
	desc = "Your mission, should you choose to accept it: Infiltrate Space Station 13. \
	Disguise yourself as a member of their crew and steal vital equipment. \
	Should you be caught or killed, your employer will disavow any knowledge of your actions. Good luck agent. \
	Complete Spy Bounties to earn rewards from your employer. Use these rewards to sow chaos and mischief!"
	ruleset_tag = "Roundstart Spies"
	jobban_flag = ROLE_SPY
	antag_datum = /datum/antagonist/spy
	default_min_pop = 5

/datum/metacoin_shop_controller
	var/list/antag_token_pending_by_ckey = list()
	var/antag_token_slots_left = 3

/datum/metacoin_shop_controller/proc/reset_tokens()
	refund_all_tokens()
	antag_token_pending_by_ckey = list()
	antag_token_slots_left = 3

/datum/metacoin_shop_controller/proc/get_token_listing()
	return preround_catalog["antag_token"]

/datum/metacoin_shop_controller/proc/get_token_slots()
	return antag_token_slots_left

/datum/metacoin_shop_controller/proc/get_restricted_jobs()
	var/static/list/restricted_jobs = list(
		JOB_CAPTAIN,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_RESEARCH_DIRECTOR,
		JOB_CHIEF_ENGINEER,
		JOB_CHIEF_MEDICAL_OFFICER,
		JOB_QUARTERMASTER,
		JOB_BRIDGE_ASSISTANT,
		JOB_VETERAN_ADVISOR,
		JOB_AI,
		JOB_CYBORG,
		JOB_HUMAN_AI,
		JOB_WARDEN,
		JOB_DETECTIVE,
		JOB_SECURITY_OFFICER,
		JOB_SECURITY_OFFICER_MEDICAL,
		JOB_SECURITY_OFFICER_ENGINEERING,
		JOB_SECURITY_OFFICER_SCIENCE,
		JOB_SECURITY_OFFICER_SUPPLY,
		JOB_PRISONER,
		JOB_CARGO_GORILLA,
	)

	return restricted_jobs

/datum/metacoin_shop_controller/proc/is_restricted_job(job_title)
	return job_title && (job_title in get_restricted_jobs())

/datum/metacoin_shop_controller/proc/get_restricted_prefs(client/target_client)
	var/list/restricted_preferences = list()
	var/list/job_preferences = target_client?.prefs?.job_preferences
	if(!islist(job_preferences))
		return restricted_preferences

	for(var/job_title in get_restricted_jobs())
		if(!isnull(job_preferences[job_title]))
			restricted_preferences += job_title

	return restricted_preferences

/datum/metacoin_shop_controller/proc/get_restricted_warn(client/target_client)
	var/list/restricted_preferences = get_restricted_prefs(target_client)
	if(!length(restricted_preferences))
		return null

	return "Warning: you have restricted jobs enabled in preferences ([english_list(restricted_preferences)]). If one of these jobs is assigned at roundstart, antag token will be refunded."

/datum/metacoin_shop_controller/proc/get_antag_roles()
	var/static/list/antag_roles
	if(isnull(antag_roles))
		antag_roles = list()
		for(var/role_path in subtypesof(/datum/metacoinshop/antag_role))
			var/datum/metacoinshop/antag_role/role = new role_path
			var/index = 1
			while(index <= length(antag_roles))
				var/datum/metacoinshop/antag_role/current_role = antag_roles[index]
				if(role.is_before(current_role))
					break
				index++

			antag_roles.Insert(index, role)

	return antag_roles

/datum/metacoin_shop_controller/proc/get_antag_role(role_id)
	if(!role_id)
		return null

	for(var/datum/metacoinshop/antag_role/role as anything in get_antag_roles())
		if(role.id == role_id)
			return role

	return null

/datum/metacoin_shop_controller/proc/get_role_name(role_id)
	var/datum/metacoinshop/antag_role/role = get_antag_role(role_id)
	return role?.name

/datum/metacoin_shop_controller/proc/has_weight(weight_setting)
	if(isnum(weight_setting))
		return weight_setting > 0

	if(!islist(weight_setting))
		return FALSE

	for(var/key in weight_setting)
		if(weight_setting[key] > 0)
			return TRUE

	return FALSE

/datum/metacoin_shop_controller/proc/resolve_min_pop(min_pop_setting, fallback_value)
	if(isnum(min_pop_setting))
		return min_pop_setting

	if(!islist(min_pop_setting))
		return fallback_value

	var/best_value
	for(var/key in min_pop_setting)
		var/current_value = min_pop_setting[key]
		if(isnull(best_value) || current_value < best_value)
			best_value = current_value

	return isnull(best_value) ? fallback_value : best_value

/datum/metacoin_shop_controller/proc/get_role_block(target_ckey, role_id, datum/job/current_job = null)
	var/datum/metacoinshop/antag_role/role = get_antag_role(role_id)
	if(!role)
		return list("code" = "unknown_role")

	if(target_ckey && is_banned_from(target_ckey, list(ROLE_SYNDICATE, role.jobban_flag)))
		return list("code" = "job_banned")

	if(current_job && is_restricted_job(current_job.title))
		return list(
			"code" = "restricted_job",
			"job_title" = current_job.title,
		)

	var/min_pop_setting = role.default_min_pop
	if(CONFIG_GET(flag/dynamic_config_enabled))
		var/list/ruleset_config = SSdynamic.get_config()?[role.ruleset_tag]
		if(!isnull(ruleset_config?["weight"]) && !has_weight(ruleset_config["weight"]))
			return list("code" = "disabled_by_config")

		if(!isnull(ruleset_config?["min_pop"]))
			min_pop_setting = ruleset_config["min_pop"]

	var/min_pop = resolve_min_pop(min_pop_setting, role.default_min_pop)
	var/current_population = length(GLOB.new_player_list)
	if(current_population >= min_pop)
		return null

	return list(
		"code" = "min_pop",
		"required_pop" = min_pop,
		"current_pop" = current_population,
	)

/datum/metacoin_shop_controller/proc/get_block_text(list/block_info)
	if(!islist(block_info))
		return null

	switch(block_info["code"])
		if("job_banned")
			return "Role is blocked by jobban."
		if("restricted_job")
			var/job_title = block_info["job_title"]
			return job_title ? "Role is blocked for your current job: [job_title]." : "Role is blocked for your current job."
		if("disabled_by_config")
			return "Role is disabled by dynamic config."
		if("min_pop")
			return "Not enough population: [block_info["current_pop"]]/[block_info["required_pop"]]."
		if("unknown_role")
			return "Unknown role."

	return "Role is currently unavailable."

/datum/metacoin_shop_controller/proc/get_roles_ui(target_ckey)
	var/list/roles_ui_data = list()
	for(var/datum/metacoinshop/antag_role/role as anything in get_antag_roles())
		var/list/block_info = get_role_block(target_ckey, role.id)
		roles_ui_data += list(list(
			"id" = role.id,
			"name" = role.name,
			"desc" = role.desc,
			"prefIconClass" = role.id,
			"fallbackIcon" = default_listing_fallback_icon,
			"available" = isnull(block_info),
			"unavailableReason" = get_block_text(block_info),
			"unavailableCode" = block_info?["code"],
			"minPopCurrent" = block_info?["current_pop"],
			"minPopRequired" = block_info?["required_pop"],
		))

	return roles_ui_data

/datum/metacoin_shop_controller/proc/buy_token(target_ckey, datum/metacoinshop/listing/listing, role_id, mob/player_mob, client/player_client)
	if(!role_id)
		return list("ok" = FALSE, "error" = "open_antag_panel")

	if(!is_open())
		return list("ok" = FALSE, "error" = "shop_closed")

	if(antag_token_pending_by_ckey[target_ckey])
		return list("ok" = FALSE, "error" = "already_owned")

	if(get_token_slots() <= 0)
		return list("ok" = FALSE, "error" = "sold_out")

	var/list/block_info = get_role_block(target_ckey, role_id)
	if(block_info)
		return list("ok" = FALSE, "error" = block_info["code"])

	var/list/take = take_metacoins(target_ckey, listing.price)
	if(!take["ok"])
		return take

	antag_token_pending_by_ckey[target_ckey] = role_id
	antag_token_slots_left--
	var/role_name = get_role_name(role_id)
	listing.on_bought(src, target_ckey, player_mob, player_client, take["balance"], role_id)

	if(player_mob)
		to_chat(player_mob, span_boldnicegreen("Purchased Antag Token ([role_name]) for [listing.price] metacoins. It will be applied at roundstart."))
		player_mob.playsound_local(player_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
		SStgui.update_user_uis(player_mob)

	return list("ok" = TRUE)

/datum/metacoin_shop_controller/proc/refund_token(target_ckey, failure_text, mob/notify_mob)
	if(!target_ckey || !(target_ckey in antag_token_pending_by_ckey))
		return FALSE

	var/datum/metacoinshop/listing/antag_listing = get_token_listing()
	var/refund_amount = antag_listing?.price || 0
	antag_token_pending_by_ckey -= target_ckey
	antag_token_slots_left = min(antag_token_slots_left + 1, 3)

	if(refund_amount > 0)
		add_metacoins(target_ckey, refund_amount)

	var/message = failure_text || "Antag token delivery failed."
	if(refund_amount > 0)
		message += " [refund_amount] metacoins were refunded."

	if(notify_mob?.client)
		to_chat(notify_mob, span_warning(message))
		notify_mob.playsound_local(notify_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
	else
		addtimer(CALLBACK(src, PROC_REF(retry_refund_notice), target_ckey, message, 20), 1 SECONDS)

	return TRUE

/datum/metacoin_shop_controller/proc/retry_refund_notice(target_ckey, message, attempts_left)
	if(!target_ckey || !message)
		return

	var/mob/target_mob = get_mob_by_ckey(target_ckey)
	if(!target_mob?.client)
		if(attempts_left > 0)
			addtimer(CALLBACK(src, PROC_REF(retry_refund_notice), target_ckey, message, attempts_left - 1), 0.5 SECONDS)
		return

	to_chat(target_mob, span_warning(message))
	target_mob.playsound_local(target_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)

/datum/metacoin_shop_controller/proc/refund_all_tokens()
	var/list/ckeys_to_refund = antag_token_pending_by_ckey.Copy()
	for(var/target_ckey in ckeys_to_refund)
		refund_token(target_ckey, null, null)

/datum/metacoin_shop_controller/proc/check_dynamic(datum/mind/target_mind)
	var/list/conflicts = list()
	if(!target_mind || !SSdynamic)
		return conflicts

	for(var/datum/dynamic_ruleset/roundstart/ruleset as anything in SSdynamic.queued_rulesets)
		if(!(target_mind in ruleset.selected_minds))
			continue

		var/ruleset_name = ruleset.name || ruleset.config_tag || "[ruleset.type]"
		conflicts += ruleset_name

	return conflicts

/datum/metacoin_shop_controller/proc/grant_token_on_spawn(target_ckey, mob/living/spawned)
	if(!target_ckey)
		return

	var/selected_role = antag_token_pending_by_ckey[target_ckey]
	if(!selected_role)
		return

	var/mob/notify_mob = ismob(spawned) ? spawned : get_mob_by_ckey(target_ckey)
	var/datum/job/current_job = spawned?.mind?.assigned_role
	var/list/dynamic_conflicts = check_dynamic(spawned?.mind)
	if(length(dynamic_conflicts))
		var/conflict_text = english_list(dynamic_conflicts)
		refund_token(target_ckey, "Antag token was refunded due to Dynamic subsystem role assignment ([conflict_text]).", notify_mob)
		return

	var/list/block_info = get_role_block(target_ckey, selected_role, current_job)
	if(block_info)
		refund_token(target_ckey, "Antag token could not be applied: [get_block_text(block_info)]", notify_mob)
		return

	if(!ishuman(spawned))
		refund_token(target_ckey, "Antag token requires one to join as an human", notify_mob)
		return

	var/mob/living/carbon/human/human_spawned = spawned
	if(!human_spawned.mind)
		refund_token(target_ckey, "Antag token failed: no valid player mind found.", notify_mob)
		return

	var/datum/metacoinshop/antag_role/role = get_antag_role(selected_role)
	if(!role)
		refund_token(target_ckey, "Antag token failed: selected role is invalid.", notify_mob)
		return

	var/antag_datum_path = role.antag_datum
	var/datum/antagonist/created_antag = new antag_datum_path()
	created_antag.silent = TRUE
	human_spawned.mind.add_antag_datum(created_antag)

	var/datum/antagonist/granted_antag = human_spawned.mind.has_antag_datum(antag_datum_path, TRUE)
	if(!granted_antag)
		log_game("[src] antag token grant failed for [target_ckey]: antag datum [antag_datum_path] not present after add.")
		refund_token(target_ckey, "Antag token failed to grant the selected role.", notify_mob)
		return

	addtimer(CALLBACK(src, PROC_REF(retry_intro), target_ckey, granted_antag, 20), 1 SECONDS)
	antag_token_pending_by_ckey -= target_ckey
	SStgui.update_uis(src)

/datum/metacoin_shop_controller/proc/retry_intro(target_ckey, datum/antagonist/granted_antag, attempts_left)
	if(!target_ckey || !granted_antag || QDELETED(granted_antag))
		return

	var/mob/player_mob = granted_antag.owner?.current
	if(!player_mob || ckey(player_mob.ckey) != target_ckey)
		player_mob = get_mob_by_ckey(target_ckey)

	if(!player_mob?.client)
		if(attempts_left > 0)
			addtimer(CALLBACK(src, PROC_REF(retry_intro), target_ckey, granted_antag, attempts_left - 1), 0.5 SECONDS)
		return

	var/datum/action/antag_info/info_button = granted_antag.info_button_ref?.resolve()
	if(granted_antag.ui_name && !info_button)
		if(attempts_left > 0)
			addtimer(CALLBACK(src, PROC_REF(retry_intro), target_ckey, granted_antag, attempts_left - 1), 0.5 SECONDS)
		return

	granted_antag.silent = FALSE
	granted_antag.greet()

	if(granted_antag.ui_name)
		to_chat(player_mob, span_boldnotice("For more info, read the panel. You can always come back to it using the button in the top left."))
		info_button?.Trigger(player_mob)

	var/type_policy = get_policy("[granted_antag.type]")
	if(type_policy)
		to_chat(player_mob, type_policy)

/datum/metacoin_shop_controller/proc/latejoin_token_grant(target_ckey, mob/living/spawned)
	var/datum/mind/mind = spawned.mind
	if(mind.has_antag_datum(/datum/antagonist, TRUE))
		refund_token(target_ckey, "Antag token grant failed: Dynamic has assigened you a role, \
		note, if you still wish to play a certain role, please, contact your local admin.")
		return

	if(!CONFIG_GET(flag/allow_latejoin_antagonists))
		refund_token(target_ckey, "Antag token grant failed: Server configuration has opted-out \
		to disable latejoin antagonists")
		return

	grant_token_on_spawn(spawned.ckey, spawned)

/datum/metacoinshop/panel/antag_token
	interface_id = "MetaCoinAntagToken"

/datum/metacoinshop/panel/antag_token/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet_batched/antagonists))

/datum/metacoinshop/panel/antag_token/ui_data(mob/user)
	var/list/data = list()
	var/client_ckey = owner?.ckey
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	var/balance = shop.fetch_balance(client_ckey)
	var/selected_role = shop.antag_token_pending_by_ckey[client_ckey]
	var/datum/metacoinshop/listing/antag_listing = shop.get_token_listing()

	data["isPregame"] = shop.is_open()
	data["balance"] = isnull(balance) ? 0 : balance
	data["price"] = antag_listing?.price || 40
	data["slotsLeft"] = shop.get_token_slots()
	data["alreadyPurchased"] = !isnull(selected_role)
	data["selectedRole"] = selected_role
	data["selectedRoleName"] = shop.get_role_name(selected_role)
	data["roles"] = shop.get_roles_ui(client_ckey)
	data["restrictedJobPreferences"] = shop.get_restricted_prefs(owner)
	data["restrictedJobWarning"] = shop.get_restricted_warn(owner)

	return data

/datum/metacoinshop/panel/antag_token/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action != "buy_antag_token_role")
		return FALSE

	var/static/list/error_messages = list(
		"shop_closed" = "Antag token purchases are only available before round start.",
		"already_owned" = "You already purchased an antag token this round.",
		"sold_out" = "No antag tokens are left for this round.",
		"job_banned" = "You are jobbanned from this antagonist role.",
		"disabled_by_config" = "This role is disabled by dynamic config.",
		"min_pop" = "Current population is too low for this role.",
		"not_enough" = "Not enough metacoins.",
		"db_unavailable" = "Database error. Try again later.",
		"db_failed" = "Database error. Try again later.",
		"unknown_role" = "Selected role is not valid.",
	)
	var/role_id = params["roleId"]
	if(!role_id)
		return FALSE

	var/result = get_metacoin_controller().buy(owner?.ckey, "antag_token", role_id, owner)
	if(result["ok"])
		return TRUE

	send_error(ui?.user, result["error"], error_messages, "Antag token purchase failed.")
	return FALSE
