/datum/metacoinshop/listing/preround/antag_token
	id = "antag_token"
	name = "Antag Token"
	desc = "Guarantees one chosen antagonist role at roundstart."
	price = 650
	item_type = /obj/item/coin/antagtoken // to get the display icon of ours
	listing_type = "antag_token"
	var/list/pending_by_ckey = list()
	var/slots_left = 3

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

/datum/metacoinshop/listing/preround/antag_token/reset(datum/metacoin_shop_controller/shop)
	refund_all(shop)
	pending_by_ckey = list()
	slots_left = 3

/datum/metacoinshop/listing/preround/antag_token/proc/get_restricted_jobs()
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

/datum/metacoinshop/listing/preround/antag_token/proc/is_restricted_job(job_title)
	return job_title && (job_title in get_restricted_jobs())

/datum/metacoinshop/listing/preround/antag_token/proc/get_restricted_prefs(client/target_client)
	var/list/restricted_preferences = list()
	var/list/job_preferences = target_client?.prefs?.job_preferences
	if(!islist(job_preferences))
		return restricted_preferences

	for(var/job_title in get_restricted_jobs())
		if(!isnull(job_preferences[job_title]))
			restricted_preferences += job_title

	return restricted_preferences

/datum/metacoinshop/listing/preround/antag_token/proc/get_restricted_warn(client/target_client)
	var/list/restricted_preferences = get_restricted_prefs(target_client)
	if(!length(restricted_preferences))
		return null

	return "Warning: you have restricted jobs enabled in preferences ([english_list(restricted_preferences)]). If one of these jobs is assigned at roundstart, antag token will be refunded."

/datum/metacoinshop/listing/preround/antag_token/proc/get_roles()
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

/datum/metacoinshop/listing/preround/antag_token/proc/get_role(role_id)
	if(!role_id)
		return null

	for(var/datum/metacoinshop/antag_role/role as anything in get_roles())
		if(role.id == role_id)
			return role

	return null

/datum/metacoinshop/listing/preround/antag_token/proc/role_name(role_id)
	var/datum/metacoinshop/antag_role/role = get_role(role_id)
	return role?.name

/datum/metacoinshop/listing/preround/antag_token/proc/has_weight(weight_setting)
	if(isnum(weight_setting))
		return weight_setting > 0

	if(!islist(weight_setting))
		return FALSE

	for(var/key in weight_setting)
		if(weight_setting[key] > 0)
			return TRUE

	return FALSE

/datum/metacoinshop/listing/preround/antag_token/proc/resolve_min_pop(min_pop_setting, fallback_value)
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

/datum/metacoinshop/listing/preround/antag_token/proc/get_block(target_ckey, role_id, datum/job/current_job = null)
	var/datum/metacoinshop/antag_role/role = get_role(role_id)
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

/datum/metacoinshop/listing/preround/antag_token/proc/block_text(list/block_info)
	var/static/list/block_messages = list(
		"job_banned" = "Role is blocked by jobban.",
		"restricted_job" = "Role is blocked for your current job.",
		"disabled_by_config" = "Role is disabled by dynamic config.",
		"unknown_role" = "Unknown role.",
	)
	if(!islist(block_info))
		return null

	var/code = block_info["code"]
	if(code == "restricted_job" && block_info["job_title"])
		return "Role is blocked for your current job: [block_info["job_title"]]."

	if(code == "min_pop")
		return "Not enough population: [block_info["current_pop"]]/[block_info["required_pop"]]."

	return block_messages[code] || "Role is currently unavailable."

/datum/metacoinshop/listing/preround/antag_token/proc/roles_ui(datum/metacoin_shop_controller/shop, target_ckey)
	var/list/roles_ui_data = list()
	for(var/datum/metacoinshop/antag_role/role as anything in get_roles())
		var/list/block_info = get_block(target_ckey, role.id)
		roles_ui_data += list(list(
			"id" = role.id,
			"name" = role.name,
			"desc" = role.desc,
			"prefIconClass" = role.id,
			"fallbackIcon" = shop.default_listing_fallback_icon,
			"available" = isnull(block_info),
			"unavailableReason" = block_text(block_info),
			"unavailableCode" = block_info?["code"],
			"minPopCurrent" = block_info?["current_pop"],
			"minPopRequired" = block_info?["required_pop"],
		))

	return roles_ui_data

/datum/metacoinshop/listing/preround/antag_token/is_owned(target_ckey, list/owned_items)
	return target_ckey in pending_by_ckey

/datum/metacoinshop/listing/preround/antag_token/serialize(datum/metacoin_shop_controller/shop, target_ckey, balance, list/owned_items)
	. = ..()
	var/selected_role = pending_by_ckey[target_ckey]
	.["tokensLeft"] = slots_left
	.["selectedRole"] = selected_role
	.["selectedRoleName"] = role_name(selected_role)
	return .

/datum/metacoinshop/listing/preround/antag_token/buy(datum/metacoin_shop_controller/shop, target_ckey, client/player_client, variant, role_id)
	if(!role_id)
		return list("ok" = FALSE, "error" = "open_antag_panel")
	if(!shop.is_open())
		return list("ok" = FALSE, "error" = "shop_closed")
	if(target_ckey in pending_by_ckey)
		return list("ok" = FALSE, "error" = "already_owned")
	if(slots_left <= 0)
		return list("ok" = FALSE, "error" = "sold_out")

	var/list/block_info = get_block(target_ckey, role_id)
	if(block_info)
		return list("ok" = FALSE, "error" = block_info["code"])

	var/list/take = shop.wallet.take_metacoins(target_ckey, price)
	if(!take["ok"])
		return take

	pending_by_ckey[target_ckey] = role_id
	slots_left--
	var/mob/player_mob = player_client?.mob || get_mob_by_ckey(target_ckey)
	on_bought(shop, target_ckey, player_mob, player_client, take["balance"], role_id)
	notify_bought(player_mob, "Purchased [name] ([role_name(role_id)]) for [price] metacoins. It will be applied at roundstart.")
	return list("ok" = TRUE)

/datum/metacoinshop/listing/preround/antag_token/proc/refund(datum/metacoin_shop_controller/shop, target_ckey, failure_text, mob/notify_mob)
	if(!target_ckey || !(target_ckey in pending_by_ckey))
		return FALSE

	pending_by_ckey -= target_ckey
	slots_left = min(slots_left + 1, 3)
	var/message = failure_text || "Antag token delivery failed."
	if(shop.wallet.add_metacoins(target_ckey, price))
		message += " [price] metacoins were refunded."

	if(notify_mob?.client)
		to_chat(notify_mob, span_warning(message))
		notify_mob.playsound_local(notify_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
	else
		addtimer(CALLBACK(src, PROC_REF(retry_refund_notice), target_ckey, message, 20), 1 SECONDS)

	return TRUE

/datum/metacoinshop/listing/preround/antag_token/proc/retry_refund_notice(target_ckey, message, attempts_left)
	if(!target_ckey || !message)
		return

	var/mob/target_mob = get_mob_by_ckey(target_ckey)
	if(!target_mob?.client)
		if(attempts_left > 0)
			addtimer(CALLBACK(src, PROC_REF(retry_refund_notice), target_ckey, message, attempts_left - 1), 0.5 SECONDS)
		return

	to_chat(target_mob, span_warning(message))
	target_mob.playsound_local(target_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)

/datum/metacoinshop/listing/preround/antag_token/proc/refund_all(datum/metacoin_shop_controller/shop)
	var/list/ckeys_to_refund = pending_by_ckey.Copy()
	for(var/target_ckey in ckeys_to_refund)
		refund(shop, target_ckey, null, null)

/datum/metacoinshop/listing/preround/antag_token/proc/get_dynamic_roles(datum/mind/target_mind)
	var/list/conflicts = list()
	if(!target_mind || !SSdynamic)
		return conflicts

	for(var/datum/dynamic_ruleset/roundstart/ruleset as anything in SSdynamic.queued_rulesets)
		if(!(target_mind in ruleset.selected_minds))
			continue

		var/ruleset_name = ruleset.name || ruleset.config_tag || "[ruleset.type]"
		conflicts += ruleset_name

	return conflicts

/datum/metacoinshop/listing/preround/antag_token/on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned, client/player_client)
	grant(shop, target_ckey, spawned)

/datum/metacoinshop/listing/preround/antag_token/proc/grant(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned)
	if(!target_ckey)
		return

	var/selected_role = pending_by_ckey[target_ckey]
	if(!selected_role)
		return

	var/mob/notify_mob = spawned || get_mob_by_ckey(target_ckey)
	var/datum/job/current_job = spawned?.mind?.assigned_role
	var/list/dynamic_conflicts = get_dynamic_roles(spawned?.mind)
	if(length(dynamic_conflicts))
		return refund(shop, target_ckey, "Antag token was refunded due to Dynamic subsystem role assignment ([english_list(dynamic_conflicts)]).", notify_mob)

	var/list/block_info = get_block(target_ckey, selected_role, current_job)
	if(block_info)
		return refund(shop, target_ckey, "Antag token could not be applied: [block_text(block_info)]", notify_mob)

	if(!ishuman(spawned))
		return refund(shop, target_ckey, "Antag token requires one to join as an human", notify_mob)

	var/mob/living/carbon/human/human_spawned = spawned
	if(!human_spawned.mind)
		return refund(shop, target_ckey, "Antag token failed: no valid player mind found.", notify_mob)

	var/datum/metacoinshop/antag_role/role = get_role(selected_role)
	if(!role)
		return refund(shop, target_ckey, "Antag token failed: selected role is invalid.", notify_mob)

	var/antag_datum_path = role.antag_datum
	var/datum/antagonist/created_antag = new antag_datum_path()
	created_antag.silent = TRUE
	human_spawned.mind.add_antag_datum(created_antag)

	var/datum/antagonist/granted_antag = human_spawned.mind.has_antag_datum(antag_datum_path, TRUE)
	if(!granted_antag)
		return refund(shop, target_ckey, "Antag token failed to grant the selected role.", notify_mob)

	addtimer(CALLBACK(src, PROC_REF(retry_intro), target_ckey, granted_antag, 20), 1 SECONDS)
	pending_by_ckey -= target_ckey

/datum/metacoinshop/listing/preround/antag_token/proc/retry_intro(target_ckey, datum/antagonist/granted_antag, attempts_left)
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

/datum/metacoinshop/listing/preround/antag_token/on_latejoin(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned)
	addtimer(CALLBACK(src, PROC_REF(latejoin), shop, target_ckey, spawned), 2 SECONDS)

/datum/metacoinshop/listing/preround/antag_token/proc/latejoin(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned)
	var/datum/mind/mind = spawned.mind
	if(mind.has_antag_datum(/datum/antagonist, TRUE))
		refund(shop, target_ckey, "Antag token grant failed: Dynamic has assigened you a role, \
		note, if you still wish to play a certain role, please, contact your local admin.")
		return

	if(!CONFIG_GET(flag/allow_latejoin_antagonists))
		refund(shop, target_ckey, "Antag token grant failed: Server configuration has opted-out \
		to disable latejoin antagonists")
		return

	grant(shop, spawned.ckey, spawned)

/datum/metacoinshop/panel/antag_token
	interface_id = "MetaCoinAntagToken"

/datum/metacoinshop/panel/antag_token/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet_batched/antagonists))

/datum/metacoinshop/panel/antag_token/ui_data(mob/user)
	var/list/data = list()
	var/client_ckey = owner?.ckey
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	var/balance = shop.wallet.fetch_balance(client_ckey)
	var/datum/metacoinshop/listing/preround/antag_token/token = shop.get_listing("antag_token")
	var/selected_role = token.pending_by_ckey[client_ckey]

	data["isPregame"] = shop.is_open()
	data["balance"] = isnull(balance) ? 0 : balance
	data["price"] = token.price
	data["slotsLeft"] = token.slots_left
	data["alreadyPurchased"] = !isnull(selected_role)
	data["selectedRole"] = selected_role
	data["selectedRoleName"] = token.role_name(selected_role)
	data["roles"] = token.roles_ui(shop, client_ckey)
	data["restrictedJobPreferences"] = token.get_restricted_prefs(owner)
	data["restrictedJobWarning"] = token.get_restricted_warn(owner)

	return data

/datum/metacoinshop/panel/antag_token/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action != "buy_antag_token_role")
		return FALSE

	var/role_id = params["roleId"]
	if(!role_id)
		return FALSE

	var/result = get_metacoin_controller().buy(owner?.ckey, "antag_token", role_id, owner)
	if(result["ok"])
		return TRUE

	send_error(ui?.user, result["error"], "Antag token purchase failed.")
	return FALSE
