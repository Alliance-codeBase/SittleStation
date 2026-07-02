GLOBAL_DATUM(metacoin_shop_controller, /datum/metacoin_shop_controller)

/proc/get_metacoin_controller()
	if(!GLOB.metacoin_shop_controller)
		GLOB.metacoin_shop_controller = new /datum/metacoin_shop_controller()
		GLOB.metacoin_shop_controller.register_signals()
	return GLOB.metacoin_shop_controller

/proc/cmp_antag_role(datum/metacoinshop/antag_role/a, datum/metacoinshop/antag_role/b)
	var/order_diff = cmp_numeric_asc(a.ui_order, b.ui_order)
	if(order_diff)
		return order_diff

	return cmp_text_asc(a.id, b.id)

/datum/metacoin_shop_controller
	var/list/preround_catalog = list()
	var/list/persistent_catalog = list()
	var/list/preround_pending_by_ckey = list()
	var/list/preround_delivered_by_ckey = list()
	var/list/antag_token_pending_by_ckey = list()
	var/antag_token_slots_left = 3
	var/default_listing_fallback_icon = "question-circle"
	var/signals_registered = FALSE

/datum/metacoin_shop_controller/New()
	. = ..()
	setup_catalog()

/datum/metacoin_shop_controller/proc/setup_catalog()
	preround_catalog = alist()
	for(var/listing_path in subtypesof(/datum/metacoinshop/listing/preround))
		var/datum/metacoinshop/listing/listing = new listing_path
		if(listing.item_type && !listing.icon)
			var/obj/item/type_cast_item_path = listing.item_type
			listing.icon = initial(type_cast_item_path.icon)
			listing.icon_state = initial(type_cast_item_path.icon_state)

		preround_catalog[listing.id] = listing

	persistent_catalog = alist()
	for(var/listing_path in subtypesof(/datum/metacoinshop/listing/persistent))
		var/datum/metacoinshop/listing/listing = new listing_path
		if(listing.item_type && !listing.icon)
			var/obj/item/type_cast_item_path = listing.item_type
			listing.icon = initial(type_cast_item_path.icon)
			listing.icon_state = initial(type_cast_item_path.icon_state)

		persistent_catalog[listing.id] = listing

/datum/metacoin_shop_controller/proc/register_signals()
	if(signals_registered)
		return

	signals_registered = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_spawn))
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(on_round_start)))
	SSticker.OnRoundend(CALLBACK(src, PROC_REF(on_round_end)))

/datum/metacoin_shop_controller/proc/on_round_start()
	preround_delivered_by_ckey = list()

/datum/metacoin_shop_controller/proc/on_round_end()
	refund_all_tokens()
	preround_pending_by_ckey = list()
	preround_delivered_by_ckey = list()
	antag_token_pending_by_ckey = list()
	antag_token_slots_left = 3

/datum/metacoin_shop_controller/proc/is_open()
	if(!SSticker)
		return FALSE
	return SSticker.current_state == GAME_STATE_PREGAME

/datum/metacoin_shop_controller/proc/get_token_listing()
	return preround_catalog["antag_token"]

/datum/metacoin_shop_controller/proc/get_token_slots()
	return antag_token_slots_left

/datum/metacoin_shop_controller/proc/get_restricted_jobs()
	var/static/list/antag_token_restricted_jobs = list(
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
	) //i've spawned as a heretic captain, that's why it exists

	return antag_token_restricted_jobs

/datum/metacoin_shop_controller/proc/is_restricted_job(job_title)
	if(!job_title)
		return FALSE

	return job_title in get_restricted_jobs()

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
			antag_roles += new role_path

		antag_roles = sort_list(antag_roles, GLOBAL_PROC_REF(cmp_antag_role))

	return antag_roles

/datum/metacoin_shop_controller/proc/get_antag_role(role_id)
	if(!role_id)
		return null

	for(var/datum/metacoinshop/antag_role/role as anything in get_antag_roles())
		if(role.id == role_id)
			return role

	return null

/datum/metacoin_shop_controller/proc/get_role_name(role_id)
	if(!role_id)
		return null

	var/datum/metacoinshop/antag_role/role = get_antag_role(role_id)
	if(!role)
		return null
	return role.name

/datum/metacoin_shop_controller/proc/has_weight(weight_setting)
	if(isnull(weight_setting))
		return FALSE

	if(isnum(weight_setting))
		return weight_setting > 0

	if(islist(weight_setting))
		for(var/key in weight_setting)
			if(weight_setting[key] > 0)
				return TRUE

	return FALSE

/datum/metacoin_shop_controller/proc/resolve_min_pop(min_pop_setting, fallback_value)
	if(isnum(min_pop_setting))
		return min_pop_setting

	if(islist(min_pop_setting))
		var/best_value
		for(var/key in min_pop_setting)
			var/current_value = min_pop_setting[key]
			if(isnull(best_value) || current_value < best_value)
				best_value = current_value

		if(!isnull(best_value))
			return best_value

	return fallback_value

/datum/metacoin_shop_controller/proc/get_role_block(target_ckey, role_id, datum/job/current_job = null)
	var/datum/metacoinshop/antag_role/role = get_antag_role(role_id)
	if(!role)
		return list("code" = "unknown_role")

	var/role_ban_flag = role.jobban_flag
	if(target_ckey && is_banned_from(target_ckey, list(ROLE_SYNDICATE, role_ban_flag)))
		return list("code" = "job_banned")

	if(current_job && is_restricted_job(current_job.title))
		return list(
			"code" = "restricted_job",
			"job_title" = current_job.title,
		)

	var/default_min_pop = role.default_min_pop
	var/min_pop_setting = default_min_pop

	if(CONFIG_GET(flag/dynamic_config_enabled))
		var/ruleset_tag = role.ruleset_tag
		var/list/ruleset_config = SSdynamic.get_config()?[ruleset_tag]

		if(!isnull(ruleset_config?["weight"]) && !has_weight(ruleset_config["weight"]))
			return list("code" = "disabled_by_config")

		if(!isnull(ruleset_config?["min_pop"]))
			min_pop_setting = ruleset_config["min_pop"]

	var/min_pop = resolve_min_pop(min_pop_setting, default_min_pop)
	var/current_population = length(GLOB.new_player_list)
	if(current_population < min_pop)
		return list(
			"code" = "min_pop",
			"required_pop" = min_pop,
			"current_pop" = current_population,
		)

	return null

/datum/metacoin_shop_controller/proc/get_block_text(list/block_info)
	if(!islist(block_info))
		return null

	var/code = block_info["code"]
	switch(code)
		if("job_banned")
			return "Role is blocked by jobban."
		if("restricted_job")
			var/job_title = block_info["job_title"]
			if(job_title)
				return "Role is blocked for your current job: [job_title]."
			return "Role is blocked for your current job."
		if("disabled_by_config")
			return "Role is disabled by dynamic config."
		if("min_pop")
			var/current_pop = block_info["current_pop"]
			var/required_pop = block_info["required_pop"]
			return "Not enough population: [current_pop]/[required_pop]."
		if("unknown_role")
			return "Unknown role."

	return "Role is currently unavailable."

/datum/metacoin_shop_controller/proc/get_roles_ui(target_ckey)
	var/list/roles_ui_data = list()

	for(var/datum/metacoinshop/antag_role/role as anything in get_antag_roles())
		var/role_id = role.id
		var/list/block_info = get_role_block(target_ckey, role_id)

		roles_ui_data += list(list(
			"id" = role_id,
			"name" = role.name,
			"desc" = role.desc,
			"prefIconClass" = role_id,
			"fallbackIcon" = default_listing_fallback_icon,
			"available" = isnull(block_info),
			"unavailableReason" = get_block_text(block_info),
			"unavailableCode" = block_info?["code"],
			"minPopCurrent" = block_info?["current_pop"],
			"minPopRequired" = block_info?["required_pop"],
		))

	return roles_ui_data

/datum/metacoin_shop_controller/proc/refund_token(target_ckey, failure_text, mob/notify_mob)
	if(!target_ckey)
		return FALSE

	if(!(target_ckey in antag_token_pending_by_ckey))
		log_game("[src] antag token refund skipped for [target_ckey]: no pending reservation.")
		return FALSE

	var/datum/metacoinshop/listing/antag_listing = get_token_listing()
	var/refund_amount = antag_listing?.price || 0

	antag_token_pending_by_ckey -= target_ckey
	antag_token_slots_left = min(antag_token_slots_left + 1, 3)
	log_game("[src] antag token refund for [target_ckey], failure='[failure_text]', slots_left=[antag_token_slots_left].")

	if(refund_amount > 0)
		add_metacoins(target_ckey, refund_amount)

	var/message = failure_text
	if(!message)
		message = "Antag token delivery failed."
	if(refund_amount > 0)
		message += " [refund_amount] metacoins were refunded."

	if(notify_mob?.client)
		to_chat(notify_mob, span_warning(message))
		notify_mob.playsound_local(notify_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
	else
		log_game("[src] antag token refund notify deferred for [target_ckey]: no client on notify mob.")
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
	if(!length(antag_token_pending_by_ckey))
		return

	var/list/ckeys_to_refund = antag_token_pending_by_ckey.Copy()
	for(var/target_ckey in ckeys_to_refund)
		refund_token(target_ckey, null, null)

/datum/metacoin_shop_controller/proc/catalog_ui(target_ckey, kind = "preround")
	var/list/catalog_data = list()
	var/list/catalog = kind == "persistent" ? persistent_catalog : preround_catalog
	var/list/pending_items = kind == "preround" ? get_pending_items(target_ckey) : list()
	var/list/owned_items = kind == "persistent" ? owned_persistent(target_ckey) : null
	var/selected_antag_role = antag_token_pending_by_ckey[target_ckey]
	var/balance = fetch_balance(target_ckey)

	for(var/listing_id in catalog)
		var/datum/metacoinshop/listing/listing = catalog[listing_id]
		if(!listing)
			continue

		var/is_antag_token = listing.id == "antag_token"
		var/is_persistent = listing.listing_type == "persistent"
		var/is_owned = FALSE
		if(is_antag_token)
			is_owned = !isnull(selected_antag_role)
		else if(is_persistent)
			is_owned = !!owned_items?[listing.id]
		else
			is_owned = (listing.id in pending_items)

		var/list/listing_payload = list(
			"id" = listing.id,
			"kind" = is_antag_token ? "antag_token" : listing.listing_type,
			"name" = listing.name,
			"desc" = listing.desc,
			"price" = listing.price,
			"icon" = listing.icon,
			"iconState" = listing.icon_state,
			"fallbackIcon" = default_listing_fallback_icon,
			"owned" = is_owned,
			"canAfford" = !isnull(balance) && (balance >= listing.price),
		)

		if(is_antag_token)
			listing_payload["tokensLeft"] = get_token_slots()
			listing_payload["selectedRole"] = selected_antag_role
			listing_payload["selectedRoleName"] = get_role_name(selected_antag_role)

		catalog_data += list(listing_payload)

	return catalog_data

/datum/metacoin_shop_controller/proc/owned_persistent(target_ckey)
	target_ckey = ckey(target_ckey)
	if(!target_ckey)
		return list()

	if(!SSdbcore.Connect())
		return null

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/select_query = SSdbcore.NewQuery(
		"SELECT listing FROM [table_purchases] WHERE ckey = :ckey AND owned = TRUE",
		list("ckey" = target_ckey),
	)

	if(!select_query.warn_execute(async = FALSE))
		qdel(select_query)
		return null

	var/list/owned_items = list()
	while(select_query.NextRow(async = FALSE))
		var/listing_id = select_query.item[1]
		if(listing_id)
			owned_items[listing_id] = TRUE

	qdel(select_query)
	return owned_items

/datum/metacoin_shop_controller/proc/owns_persistent(target_ckey, listing_id)
	target_ckey = ckey(target_ckey)
	if(!target_ckey || !listing_id)
		return FALSE

	if(!SSdbcore.Connect())
		return null

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/select_query = SSdbcore.NewQuery(
		"SELECT owned FROM [table_purchases] WHERE ckey = :ckey AND listing = :listing LIMIT 1",
		list(
			"ckey" = target_ckey,
			"listing" = listing_id,
		),
	)

	if(!select_query.warn_execute(async = FALSE))
		qdel(select_query)
		return null

	var/is_owned = FALSE
	if(select_query.NextRow(async = FALSE))
		is_owned = select_query.item[1] > 0

	qdel(select_query)
	return is_owned

/// You may use this to manually set any listing_id to TRUE or FALSE. upsert queries add new lines in a table, so there "shall" be no issues with it
/datum/metacoin_shop_controller/proc/set_persistent(target_ckey, listing_id, owned = TRUE)
	target_ckey = ckey(target_ckey)
	if(!target_ckey || !listing_id)
		return FALSE

	if(!SSdbcore.Connect())
		return FALSE

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/upsert_query = SSdbcore.NewQuery(
		"INSERT INTO [table_purchases] (ckey, listing, owned) VALUES (:ckey, :listing, :owned) ON DUPLICATE KEY UPDATE owned = VALUES(owned)",
		list(
			"ckey" = target_ckey,
			"listing" = listing_id,
			"owned" = owned ? TRUE : FALSE,
		),
	)

	if(!upsert_query.warn_execute(async = FALSE))
		qdel(upsert_query)
		return FALSE

	qdel(upsert_query)
	return TRUE

/datum/metacoin_shop_controller/proc/grant_persistents(target_ckey, mob/living/spawned, client/player_client)
	target_ckey = ckey(target_ckey)
	if(!target_ckey)
		return FALSE

	var/list/owned_items = owned_persistent(target_ckey)
	if(isnull(owned_items))
		return FALSE

	for(var/listing_id in owned_items)
		var/datum/metacoinshop/listing/listing = persistent_catalog[listing_id]
		if(!listing)
			continue

		listing.persistent_grant(src, target_ckey, spawned, player_client)

	return TRUE

/datum/metacoin_shop_controller/proc/get_pending_items(target_ckey)
	if(!target_ckey)
		return list()

	var/list/pending_items = preround_pending_by_ckey[target_ckey]
	if(!islist(pending_items))
		return list()

	return pending_items.Copy()

/datum/metacoin_shop_controller/proc/fetch_balance(target_ckey)
	if(!target_ckey)
		return 0

	if(!SSdbcore.Connect())
		return null

	var/table_player = format_table_name("player")
	var/datum/db_query/select_query = SSdbcore.NewQuery(
		"SELECT metacoins FROM [table_player] WHERE ckey = :ckey",
		list("ckey" = target_ckey),
	)

	if(!select_query.warn_execute(async = FALSE))
		qdel(select_query)
		return null

	var/metacoin_balance = 0
	if(select_query.NextRow(async = FALSE))
		metacoin_balance = select_query.item[1]

	qdel(select_query)
	return metacoin_balance

/datum/metacoin_shop_controller/proc/add_metacoins(target_ckey, delta_amount)
	if(!target_ckey || !isnum(delta_amount) || delta_amount <= 0)
		return FALSE

	if(!SSdbcore.Connect())
		return FALSE

	var/table_player = format_table_name("player")
	var/datum/db_query/update_query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins + :delta WHERE ckey = :ckey",
		list(
			"delta" = delta_amount,
			"ckey" = target_ckey,
		),
	)

	if(!update_query.warn_execute(async = FALSE))
		qdel(update_query)
		return FALSE

	qdel(update_query)
	return TRUE

///Takes coins in one atomic query
/datum/metacoin_shop_controller/proc/take_metacoins(target_ckey, delta_amount)
	if(!target_ckey || !isnum(delta_amount) || delta_amount <= 0)
		return list("ok" = FALSE, "error" = "invalid_request")

	if(!SSdbcore.Connect())
		return list("ok" = FALSE, "error" = "db_unavailable")

	var/current_balance = fetch_balance(target_ckey)
	if(isnull(current_balance))
		return list("ok" = FALSE, "error" = "db_unavailable")

	if(current_balance < delta_amount)
		return list("ok" = FALSE, "error" = "not_enough")

	var/table_player = format_table_name("player")
	var/datum/db_query/take_query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins - :delta WHERE ckey = :ckey AND metacoins >= :delta",
		list(
			"delta" = delta_amount,
			"ckey" = target_ckey,
		),
	)

	if(!take_query.warn_execute(async = FALSE))
		qdel(take_query)
		return list("ok" = FALSE, "error" = "db_failed")
	qdel(take_query)

	var/new_balance = fetch_balance(target_ckey)
	if(isnull(new_balance))
		return list("ok" = FALSE, "error" = "db_failed")

	if(new_balance > (current_balance - delta_amount))
		return list("ok" = FALSE, "error" = "not_enough")

	return list(
		"ok" = TRUE,
		"balance" = new_balance,
	)

/datum/metacoin_shop_controller/proc/buy(target_ckey, item_id, role_id = null, client/player_client = null)
	target_ckey = ckey(target_ckey || player_client?.ckey)
	if(!target_ckey || !item_id)
		return list("ok" = FALSE, "error" = "invalid_request")

	var/datum/metacoinshop/listing/listing = persistent_catalog[item_id]
	if(!listing)
		listing = preround_catalog[item_id]

	if(!listing)
		return list("ok" = FALSE, "error" = "unknown_item")

	var/mob/player_mob = player_client?.mob || get_mob_by_ckey(target_ckey)
	var/list/take

	if(listing.listing_type == "persistent")
		var/is_owned = owns_persistent(target_ckey, item_id)
		if(isnull(is_owned))
			return list("ok" = FALSE, "error" = "db_unavailable")

		if(is_owned)
			return list("ok" = FALSE, "error" = "already_owned")

		take = take_metacoins(target_ckey, listing.price)
		if(!take["ok"])
			return take

		if(!set_persistent(target_ckey, item_id, TRUE))
			if(!add_metacoins(target_ckey, listing.price))
				log_game("[src] persistent purchase refund failed: ckey=[target_ckey], listing=[item_id], price=[listing.price].")
			return list("ok" = FALSE, "error" = "db_failed")

		listing.on_bought(src, target_ckey, player_mob, player_client, take["balance"])

		if(player_mob)
			to_chat(player_mob, span_boldnicegreen("Purchased [listing.name] for [listing.price] metacoins."))
			player_mob.playsound_local(player_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
			SStgui.update_user_uis(player_mob)

		return list("ok" = TRUE)

	if(listing.listing_type == "item" || (listing.listing_type == "other" && listing.id != "antag_token"))
		if(!is_open())
			return list("ok" = FALSE, "error" = "shop_closed")

		var/list/pending_items = preround_pending_by_ckey[target_ckey]
		if(!islist(pending_items))
			pending_items = list()
			preround_pending_by_ckey[target_ckey] = pending_items

		if(item_id in pending_items)
			return list("ok" = FALSE, "error" = "already_owned")

		take = take_metacoins(target_ckey, listing.price)
		if(!take["ok"])
			return take

		pending_items += item_id

		listing.on_bought(src, target_ckey, player_mob, player_client, take["balance"])

		if(player_mob)
			var/delivery_text = listing.listing_type == "item" ? "delivered" : "applied"
			to_chat(player_mob, span_boldnicegreen("Purchased [listing.name] for [listing.price] metacoins. It will be [delivery_text] on first roundstart spawn."))
			player_mob.playsound_local(player_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
			SStgui.update_user_uis(player_mob)

		return list("ok" = TRUE)

	if(listing.id != "antag_token")
		return list("ok" = FALSE, "error" = "unknown_item")

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

	take = take_metacoins(target_ckey, listing.price)
	if(!take["ok"])
		return take

	antag_token_pending_by_ckey[target_ckey] = role_id
	antag_token_slots_left--
	var/role_name = get_role_name(role_id)
	var/balance_after = take["balance"]
	log_game("[src] antag token purchase: ckey=[target_ckey], role=[role_id]/[role_name], price=[listing.price], balance_after=[balance_after], slots_left=[antag_token_slots_left].")

	listing.on_bought(src, target_ckey, player_mob, player_client, balance_after, role_id)

	if(player_mob)
		to_chat(player_mob, span_boldnicegreen("Purchased Antag Token ([role_name]) for [listing.price] metacoins. It will be applied at roundstart."))
		player_mob.playsound_local(player_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
		SStgui.update_user_uis(player_mob)

	return list("ok" = TRUE)

/datum/metacoin_shop_controller/proc/check_dynamic(datum/mind/target_mind)
	var/list/conflicts = list()
	if(!target_mind || !SSdynamic)
		return conflicts

	for(var/datum/dynamic_ruleset/roundstart/ruleset as anything in SSdynamic.queued_rulesets)
		if(!(target_mind in ruleset.selected_minds))
			continue

		var/ruleset_name = ruleset.name
		if(!ruleset_name)
			ruleset_name = ruleset.config_tag
		if(!ruleset_name)
			ruleset_name = "[ruleset.type]"

		conflicts += ruleset_name

	return conflicts

/datum/metacoin_shop_controller/proc/grant_token_on_spawn(target_ckey, mob/living/spawned, client/player_client)
	if(!target_ckey)
		return

	var/selected_role = antag_token_pending_by_ckey[target_ckey]
	if(!selected_role)
		return

	log_game("[src] antag token grant attempt: ckey=[target_ckey], role=[selected_role], state=[SSticker?.current_state], round_started=[SSticker?.HasRoundStarted()], job=[spawned?.mind?.assigned_role?.title], has_client=[!isnull(spawned?.client)].")

	var/mob/notify_mob = ismob(spawned) ? spawned : get_mob_by_ckey(target_ckey)
	var/datum/job/current_job = spawned?.mind?.assigned_role
	var/list/dynamic_conflicts = check_dynamic(spawned?.mind)
	if(length(dynamic_conflicts))
		var/conflict_text = english_list(dynamic_conflicts)
		var/log_rulesets = jointext(dynamic_conflicts, ", ")
		if(!conflict_text)
			conflict_text = "unknown dynamic ruleset"
		if(!log_rulesets)
			log_rulesets = "unknown"
		var/failure_text = "Antag token was refunded due to Dynamic subsystem role assignment ([conflict_text])."
		log_game("[src] antag token grant canceled for [target_ckey]: code=dynamic_interference, role=[selected_role], rulesets=[log_rulesets], job=[current_job?.title].")
		refund_token(target_ckey, failure_text, notify_mob)
		return

	var/list/block_info = get_role_block(target_ckey, selected_role, current_job)
	if(block_info)
		var/failure_text = "Antag token could not be applied: [get_block_text(block_info)]"
		log_game("[src] antag token grant blocked for [target_ckey]: code=[block_info["code"]], job=[current_job?.title].")
		refund_token(target_ckey, failure_text, notify_mob)
		return

	if(!ishuman(spawned))
		log_game("[src] antag token grant failed for [target_ckey]: spawned mob is not human ([spawned?.type]).")
		refund_token(target_ckey, "Antag token requires a human roundstart spawn.", notify_mob)
		return

	var/mob/living/carbon/human/human_spawned = spawned
	if(!human_spawned.mind)
		log_game("[src] antag token grant failed for [target_ckey]: human has no mind.")
		refund_token(target_ckey, "Antag token failed: no valid player mind found.", notify_mob)
		return

	var/datum/metacoinshop/antag_role/role = get_antag_role(selected_role)
	if(!role)
		log_game("[src] antag token grant failed for [target_ckey]: invalid role definition '[selected_role]'.")
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
	log_game("[src] antag token grant success for [target_ckey]: role=[selected_role], slots_left=[antag_token_slots_left].")

	/*if(notify_mob)
	unnecessary actually. why do you think we have stinger sounds?
		var/role_name = role.name
		to_chat(notify_mob, span_boldnicegreen("Antag token applied successfully: [role_name]."))
		notify_mob.playsound_local(notify_mob, 'sound/misc/server-ready.ogg', 25, TRUE, use_reverb = FALSE)
	*/
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

/datum/metacoin_shop_controller/proc/on_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER

	if(!player_client)
		return

	var/target_ckey = ckey(player_client.ckey)
	var/selected_role = antag_token_pending_by_ckey[target_ckey]
	if(selected_role)
		log_game("[src] on_spawn for token owner [target_ckey]: role=[selected_role], state=[SSticker?.current_state], round_started=[SSticker?.HasRoundStarted()], job=[job?.title], assigned=[spawned?.mind?.assigned_role?.title].")

	if(SSticker?.HasRoundStarted())
		if(selected_role)
			log_game("[src] skipping antag token grant for [target_ckey]: round already started in on_spawn.")
		return
	if(!target_ckey)
		return

	grant_token_on_spawn(target_ckey, spawned, player_client)
	grant_persistents(target_ckey, spawned, player_client)

	if(!ishuman(spawned))
		return

	if(preround_delivered_by_ckey[target_ckey])
		return

	var/list/pending_items = preround_pending_by_ckey[target_ckey]
	if(!islist(pending_items) || !length(pending_items))
		return

	var/mob/living/carbon/human/human_spawned = spawned

	for(var/item_id in pending_items)
		var/datum/metacoinshop/listing/listing = preround_catalog[item_id]
		if(!listing)
			continue

		if(listing.listing_type == "other")
			listing.bought_on_spawn(src, target_ckey, human_spawned, null, player_client)
			continue

		if(listing.listing_type != "item" || !listing.item_type)
			continue

		var/obj/item/new_item = new listing.item_type(human_spawned)
		listing.bought_on_spawn(src, target_ckey, human_spawned, new_item, player_client)
		if(human_spawned.back?.atom_storage?.attempt_insert(new_item, human_spawned, override = TRUE))
			continue

		if(!human_spawned.put_in_hands(new_item))
			new_item.forceMove(get_turf(human_spawned))

	preround_pending_by_ckey -= target_ckey

	preround_delivered_by_ckey[target_ckey] = TRUE

	to_chat(human_spawned, span_boldnicegreen("Your preround purchases were delivered."))

	human_spawned.playsound_local(human_spawned, 'sound/misc/server-ready.ogg', 25, TRUE, use_reverb = FALSE)

/datum/metacoin_shop_panel
	var/client/owner

/datum/metacoin_shop_panel/New(client/owner, mob/viewer)
	src.owner = owner
	ui_interact(viewer)

/datum/metacoin_shop_panel/ui_state()
	return GLOB.always_state

/datum/metacoin_shop_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MetaCoinShop")
		ui.open()


/datum/metacoin_shop_panel/ui_data(mob/user)
	var/list/data = list()
	var/client_ckey = owner?.ckey
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	var/balance = shop.fetch_balance(client_ckey)

	data["isPregame"] = shop.is_open()
	data["balance"] = isnull(balance) ? 0 : balance
	data["antagTokenSlotsLeft"] = shop.get_token_slots()
	data["preroundItems"] = shop.catalog_ui(client_ckey)
	data["persistentItems"] = shop.catalog_ui(client_ckey, "persistent")

	return data

/datum/metacoin_shop_panel/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "open_slots")
		new /datum/metacoin_slot_panel(owner, ui.user)
		return TRUE

	if(action == "open_antag_token")
		new /datum/metacoin_antag_token_panel(owner, ui.user)
		return TRUE

	if(action == "buy_preround")
		var/target_item = params["itemId"]
		if(!target_item)
			return FALSE

		var/result = get_metacoin_controller().buy(owner?.ckey, target_item, null, owner)
		if(!result["ok"])
			var/mob/user_mob = ui?.user
			if(user_mob)
				switch(result["error"])
					if("shop_closed")
						to_chat(user_mob, span_warning("Preround shop is only available before round start."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
					if("open_antag_panel")
						to_chat(user_mob, span_warning("Use the Antag Token picker window for this purchase."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
					if("already_owned")
						to_chat(user_mob, span_warning("You already purchased this item for this round."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
					if("not_enough")
						to_chat(user_mob, span_warning("Not enough metacoins."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
					if("db_unavailable", "db_failed")
						to_chat(user_mob, span_warning("Database error. Try again later."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
					else
						to_chat(user_mob, span_warning("Purchase failed."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
			return FALSE
//those exist justin cause ^^
		return TRUE

	if(action == "buy_persistent")
		var/target_item = params["itemId"]
		if(!target_item)
			return FALSE

		var/result = get_metacoin_controller().buy(owner?.ckey, target_item, null, owner)
		if(!result["ok"])
			var/mob/user_mob = ui?.user
			if(user_mob)
				switch(result["error"])
					if("already_owned")
						to_chat(user_mob, span_warning("You already own this persistent reward."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
					if("not_enough")
						to_chat(user_mob, span_warning("Not enough metacoins."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
					if("db_unavailable", "db_failed")
						to_chat(user_mob, span_warning("Database error. Try again later."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
					else
						to_chat(user_mob, span_warning("Purchase failed."))
						user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
			return FALSE

		return TRUE

	return FALSE

/datum/metacoin_antag_token_panel
	var/client/owner

/datum/metacoin_antag_token_panel/New(client/owner, mob/viewer)
	src.owner = owner
	ui_interact(viewer)

/datum/metacoin_antag_token_panel/ui_state()
	return GLOB.always_state

/datum/metacoin_antag_token_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MetaCoinAntagToken")
		ui.open()

/datum/metacoin_antag_token_panel/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet_batched/antagonists))
/datum/metacoin_antag_token_panel/ui_data(mob/user)
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

/datum/metacoin_antag_token_panel/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "buy_antag_token_role")
		var/role_id = params["roleId"]
		if(!role_id)
			return FALSE

		var/result = get_metacoin_controller().buy(owner?.ckey, "antag_token", role_id, owner)
		if(result["ok"])
			return TRUE

		var/mob/user_mob = ui?.user
		if(user_mob)
			switch(result["error"])
				if("shop_closed")
					to_chat(user_mob, span_warning("Antag token purchases are only available before round start."))
				if("already_owned")
					to_chat(user_mob, span_warning("You already purchased an antag token this round."))
				if("sold_out")
					to_chat(user_mob, span_warning("No antag tokens are left for this round."))
				if("job_banned")
					to_chat(user_mob, span_warning("You are jobbanned from this antagonist role."))
				if("disabled_by_config")
					to_chat(user_mob, span_warning("This role is disabled by dynamic config."))
				if("min_pop")
					to_chat(user_mob, span_warning("Current population is too low for this role."))
				if("not_enough")
					to_chat(user_mob, span_warning("Not enough metacoins."))
				if("db_unavailable", "db_failed")
					to_chat(user_mob, span_warning("Database error. Try again later."))
				if("unknown_role")
					to_chat(user_mob, span_warning("Selected role is not valid."))
				else
					to_chat(user_mob, span_warning("Antag token purchase failed."))

			user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
// those kinda too ^^
		return FALSE

	return FALSE

/client/verb/view_metacoin_shop()
	set name = "View Metacoin Shop"
	set category = "OOC"
	set desc = "Open metacoin shop window."

	new /datum/metacoin_shop_panel(src, usr)
