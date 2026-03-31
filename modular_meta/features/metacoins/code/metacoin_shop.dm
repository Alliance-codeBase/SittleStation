GLOBAL_DATUM(metacoin_shop_controller, /datum/metacoin_shop_controller)

/proc/get_metacoin_shop_controller()
	if(!GLOB.metacoin_shop_controller)
		GLOB.metacoin_shop_controller = new /datum/metacoin_shop_controller()
		GLOB.metacoin_shop_controller.register_signals()
	return GLOB.metacoin_shop_controller

/datum/metacoin_shop_listing
	var/id
	var/name
	var/desc
	var/price
	var/item_type
	var/listing_kind = "item"
	var/icon
	var/icon_state

/datum/metacoin_shop_listing/New(id, name, desc, price, item_type, listing_kind = "item", icon, icon_state)
	src.id = id
	src.name = name
	src.desc = desc
	src.price = price
	src.item_type = item_type
	src.listing_kind = listing_kind
	src.icon = icon
	src.icon_state = icon_state

/datum/metacoin_shop_controller
	var/list/preround_catalog = list()
	var/list/preround_pending_by_ckey = list()
	var/list/preround_delivered_by_ckey = list()
	var/list/antag_token_pending_by_ckey = list()
	var/antag_token_slots_left = 3
	var/default_listing_fallback_icon = "question-circle"
	var/signals_registered = FALSE

/datum/metacoin_shop_controller/New()
	. = ..()
	setup_catalog()

//Add your items here!!!! ~`_-´
//In the list preround_catalog

/* EXAMPLE:
		alist(
			"listing_name" = "donut_box",
			"listing_display_name" = "Donut Box",
			"listing_display_desc" = "A box of donuts delivered on your first roundstart spawn.",
			"listing_price" = 5,
			"listing_typepath" = /obj/item/storage/fancy/donut_box,
		),
*/

/datum/metacoin_shop_controller/proc/setup_catalog()
	var/list/raw_preround_catalog = list(
		alist(
			"listing_name" = "donut_box",
			"listing_display_name" = "Donut Box",
			"listing_display_desc" = "A box of donuts... what else do you expect?",
			"listing_price" = 50,
			"listing_typepath" = /obj/item/storage/fancy/donut_box,
		),
		alist(
			"listing_name" = "spray_libital",
			"listing_display_name" = "Libital Spray",
			"listing_display_desc" = "An medigel full of libital, mainly used to treat bruises",
			"listing_price" = 75,
			"listing_typepath" = /obj/item/reagent_containers/medigel/libital,
		),
		alist(
			"listing_name" = "spray_auri",
			"listing_display_name" = "Aiuri Spray",
			"listing_display_desc" = "An medigel full of aiuri, mainly used to treat burns",
			"listing_price" = 75,
			"listing_typepath" = /obj/item/reagent_containers/medigel/aiuri,
		),
		alist(
			"listing_name" = "antag_token",
			"listing_display_name" = "Antag Token",
			"listing_display_desc" = "Guarantees one chosen antagonist role at roundstart.",
			"listing_price" = 500,
			"listing_typepath" = /obj/item/coin/antagtoken, // to get the display icon of ours
			"listing_kind" = "antag_token",
		),
	)

	preround_catalog = alist()
	for(var/listing_data in raw_preround_catalog)
		if(!listing_data)
			continue

		var/listing_name = listing_data["listing_name"]
		if(!listing_name)
			continue

		var/listing_display_name = listing_data["listing_display_name"]
		var/listing_display_desc = listing_data["listing_display_desc"]
		var/listing_price = listing_data["listing_price"]
		var/listing_typepath = listing_data["listing_typepath"]
		var/listing_kind = listing_data["listing_kind"]
		if(!listing_kind)
			listing_kind = "item"
		var/listing_icon = listing_data["listing_icon"]
		var/listing_icon_state = listing_data["listing_icon_state"]

		if(listing_kind == "item" && !listing_typepath)
			continue

		if(listing_typepath && !listing_icon)
			var/obj/item/type_cast_item_path = listing_typepath
			listing_icon = initial(type_cast_item_path.icon)
			listing_icon_state = initial(type_cast_item_path.icon_state)

		preround_catalog[listing_name] = new /datum/metacoin_shop_listing(
			listing_name,
			listing_display_name,
			listing_display_desc,
			listing_price,
			listing_typepath,
			listing_kind,
			listing_icon,
			listing_icon_state,
		)

/datum/metacoin_shop_controller/proc/register_signals()
	if(signals_registered)
		return

	signals_registered = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(on_round_start)))
	SSticker.OnRoundend(CALLBACK(src, PROC_REF(on_round_end)))

/datum/metacoin_shop_controller/proc/on_round_start()
	preround_delivered_by_ckey = list()

/datum/metacoin_shop_controller/proc/on_round_end()
	refund_all_pending_antag_tokens()
	preround_pending_by_ckey = list()
	preround_delivered_by_ckey = list()
	antag_token_pending_by_ckey = list()
	antag_token_slots_left = 3

/datum/metacoin_shop_controller/proc/is_preround_purchase_open()
	if(!SSticker)
		return FALSE
	return SSticker.current_state == GAME_STATE_PREGAME

/datum/metacoin_shop_controller/proc/get_antag_token_listing()
	return preround_catalog["antag_token"]

/datum/metacoin_shop_controller/proc/get_antag_token_slots_left()
	return max(antag_token_slots_left, 0)

/datum/metacoin_shop_controller/proc/get_antag_token_restricted_jobs()
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

/datum/metacoin_shop_controller/proc/is_antag_token_restricted_job(job_title)
	if(!job_title)
		return FALSE

	return job_title in get_antag_token_restricted_jobs()

/datum/metacoin_shop_controller/proc/get_antag_token_restricted_job_preferences_for_client(client/target_client)
	var/list/restricted_preferences = list()
	var/list/job_preferences = target_client?.prefs?.job_preferences
	if(!islist(job_preferences))
		return restricted_preferences

	for(var/job_title in get_antag_token_restricted_jobs())
		if(!isnull(job_preferences[job_title]))
			restricted_preferences += job_title

	return restricted_preferences

/datum/metacoin_shop_controller/proc/get_antag_token_restricted_job_preferences_warning_for_client(client/target_client)
	var/list/restricted_preferences = get_antag_token_restricted_job_preferences_for_client(target_client)
	if(!length(restricted_preferences))
		return null

	return "Warning: you have restricted jobs enabled in preferences ([english_list(restricted_preferences)]). If one of these jobs is assigned at roundstart, antag token will be refunded."

/datum/metacoin_shop_controller/proc/get_antag_token_role_definitions()
	var/static/list/role_definitions = list(
		alist(
			"id" = "traitor",
			"name" = "Traitor",
			"desc" = "An unpaid debt. A score to be settled. Maybe you were just in the wrong \
	   		place at the wrong time. Whatever the reasons, you were selected to \
	   		infiltrate Space Station 13.",
			"ruleset_tag" = "Roundstart Traitor",
			"jobban_flag" = ROLE_TRAITOR,
			"antag_datum" = /datum/antagonist/traitor,
			"default_min_pop" = 3,
		),
		alist(
			"id" = "changeling",
			"name" = "Changeling",
			"desc" = "A highly intelligent alien predator that is capable of altering their \
	 shape to flawlessly resemble a human.",
			"ruleset_tag" = "Roundstart Changeling",
			"jobban_flag" = ROLE_CHANGELING,
			"antag_datum" = /datum/antagonist/changeling,
			"default_min_pop" = 15,
		),
		alist(
			"id" = "heretic",
			"name" = "Heretic",
			"desc" = " Forgotten, devoured, gutted. Humanity has forgotten the eldritch forces \
	   		of decay, but the mansus veil has weakened. We will make them taste fear \
	   		again...",
			"ruleset_tag" = "Roundstart Heretics",
			"jobban_flag" = ROLE_HERETIC,
			"antag_datum" = /datum/antagonist/heretic,
			"default_min_pop" = 30,
		),
	)

	return role_definitions

/datum/metacoin_shop_controller/proc/get_antag_token_role_definition(role_id)
	if(!role_id)
		return null

	var/list/role_definitions = get_antag_token_role_definitions()
	for(var/role_key in role_definitions)
		var/list/role_definition = role_definitions[role_key]
		if(!islist(role_definition) && islist(role_key))
			role_definition = role_key
		if(!islist(role_definition))
			continue
		if(role_definition["id"] == role_id)
			return role_definition

	return null

/datum/metacoin_shop_controller/proc/get_antag_token_role_display_name(role_id)
	if(!role_id)
		return null

	var/list/role_definition = get_antag_token_role_definition(role_id)
	if(!role_definition)
		return null
	return role_definition["name"]

/datum/metacoin_shop_controller/proc/dynamic_weight_has_positive_value(weight_setting)
	if(isnull(weight_setting))
		return FALSE

	if(isnum(weight_setting))
		return text2num("[weight_setting]") > 0

	if(islist(weight_setting))
		for(var/key in weight_setting)
			if(text2num("[weight_setting[key]]") > 0)
				return TRUE

	return FALSE

/datum/metacoin_shop_controller/proc/dynamic_resolve_min_pop(min_pop_setting, fallback_value)
	if(isnum(min_pop_setting))
		return max(text2num("[min_pop_setting]"), 0)

	if(islist(min_pop_setting))
		var/best_value
		for(var/key in min_pop_setting)
			var/current_value = max(text2num("[min_pop_setting[key]]"), 0)
			if(isnull(best_value) || current_value < best_value)
				best_value = current_value

		if(!isnull(best_value))
			return best_value

	return max(text2num("[fallback_value]"), 0)

/datum/metacoin_shop_controller/proc/get_antag_token_role_block_info(target_ckey, role_id, datum/job/current_job = null)
	var/list/role_definition = get_antag_token_role_definition(role_id)
	if(!role_definition)
		return list("code" = "unknown_role")

	var/role_ban_flag = role_definition["jobban_flag"]
	if(target_ckey && is_banned_from(target_ckey, list(ROLE_SYNDICATE, role_ban_flag)))
		return list("code" = "job_banned")

	if(current_job && is_antag_token_restricted_job(current_job.title))
		return list(
			"code" = "restricted_job",
			"job_title" = current_job.title,
		)

	var/default_min_pop = role_definition["default_min_pop"]
	var/min_pop_setting = default_min_pop

	if(CONFIG_GET(flag/dynamic_config_enabled))
		var/ruleset_tag = role_definition["ruleset_tag"]
		var/list/ruleset_config = SSdynamic.get_config()?[ruleset_tag]

		if(!isnull(ruleset_config?["weight"]) && !dynamic_weight_has_positive_value(ruleset_config["weight"]))
			return list("code" = "disabled_by_config")

		if(!isnull(ruleset_config?["min_pop"]))
			min_pop_setting = ruleset_config["min_pop"]

	var/min_pop = dynamic_resolve_min_pop(min_pop_setting, default_min_pop)
	var/current_population = length(GLOB.new_player_list)
	if(current_population < min_pop)
		return list(
			"code" = "min_pop",
			"required_pop" = min_pop,
			"current_pop" = current_population,
		)

	return null

/datum/metacoin_shop_controller/proc/get_antag_token_role_block_text(list/block_info)
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

/datum/metacoin_shop_controller/proc/get_antag_token_roles_ui_data(target_ckey)
	var/list/roles_ui_data = list()

	var/list/role_definitions = get_antag_token_role_definitions()
	for(var/role_key in role_definitions)
		var/list/role_definition = role_definitions[role_key]
		if(!islist(role_definition) && islist(role_key))
			role_definition = role_key
		if(!islist(role_definition))
			continue

		var/role_id = role_definition["id"]
		var/list/block_info = get_antag_token_role_block_info(target_ckey, role_id)

		roles_ui_data += list(list(
			"id" = role_id,
			"name" = role_definition["name"],
			"desc" = role_definition["desc"],
			"prefIconClass" = role_id,
			"fallbackIcon" = default_listing_fallback_icon,
			"available" = isnull(block_info),
			"unavailableReason" = get_antag_token_role_block_text(block_info),
			"unavailableCode" = block_info?["code"],
			"minPopCurrent" = block_info?["current_pop"],
			"minPopRequired" = block_info?["required_pop"],
		))

	return roles_ui_data

/datum/metacoin_shop_controller/proc/refund_antag_token_purchase(target_ckey, failure_text, mob/notify_mob)
	if(!target_ckey)
		return FALSE

	if(!(target_ckey in antag_token_pending_by_ckey))
		log_game("[src] antag token refund skipped for [target_ckey]: no pending reservation.")
		return FALSE

	var/datum/metacoin_shop_listing/antag_listing = get_antag_token_listing()
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
		addtimer(CALLBACK(src, PROC_REF(retry_notify_antag_token_result), target_ckey, message, 20), 1 SECONDS)

	return TRUE

/datum/metacoin_shop_controller/proc/retry_notify_antag_token_result(target_ckey, message, attempts_left)
	if(!target_ckey || !message)
		return

	var/mob/target_mob = get_mob_by_ckey(target_ckey)
	if(!target_mob?.client)
		if(attempts_left > 0)
			addtimer(CALLBACK(src, PROC_REF(retry_notify_antag_token_result), target_ckey, message, attempts_left - 1), 0.5 SECONDS)
		return

	to_chat(target_mob, span_warning(message))
	target_mob.playsound_local(target_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)

/datum/metacoin_shop_controller/proc/refund_all_pending_antag_tokens()
	if(!length(antag_token_pending_by_ckey))
		return

	var/list/ckeys_to_refund = antag_token_pending_by_ckey.Copy()
	for(var/target_ckey in ckeys_to_refund)
		refund_antag_token_purchase(target_ckey, null, null)

/datum/metacoin_shop_controller/proc/get_catalog_ui_data(target_ckey)
	var/list/catalog_data = list()
	var/list/pending_items = get_pending_item_ids(target_ckey)
	var/selected_antag_role = antag_token_pending_by_ckey[target_ckey]
	var/balance = fetch_metacoin_balance(target_ckey)

	for(var/listing_id in preround_catalog)
		var/datum/metacoin_shop_listing/listing = preround_catalog[listing_id]
		if(!listing)
			continue

		var/is_antag_token = listing.listing_kind == "antag_token"
		var/is_owned = FALSE
		if(is_antag_token)
			is_owned = !isnull(selected_antag_role)
		else
			is_owned = (listing.id in pending_items)

		var/list/listing_payload = list(
			"id" = listing.id,
			"kind" = listing.listing_kind,
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
			listing_payload["tokensLeft"] = get_antag_token_slots_left()
			listing_payload["selectedRole"] = selected_antag_role
			listing_payload["selectedRoleName"] = get_antag_token_role_display_name(selected_antag_role)

		catalog_data += list(listing_payload)

	return catalog_data

/datum/metacoin_shop_controller/proc/get_pending_item_ids(target_ckey)
	if(!target_ckey)
		return list()

	var/list/pending_items = preround_pending_by_ckey[target_ckey]
	if(!islist(pending_items))
		return list()

	return pending_items.Copy()

/datum/metacoin_shop_controller/proc/fetch_metacoin_balance(target_ckey)
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
		metacoin_balance = text2num(select_query.item[1]) || 0

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

	var/current_balance = fetch_metacoin_balance(target_ckey)
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

	var/new_balance = fetch_metacoin_balance(target_ckey)
	if(isnull(new_balance))
		return list("ok" = FALSE, "error" = "db_failed")

	if(new_balance > (current_balance - delta_amount))
		return list("ok" = FALSE, "error" = "not_enough")

	return list(
		"ok" = TRUE,
		"balance" = new_balance,
	)

/datum/metacoin_shop_controller/proc/try_purchase_preround_item(target_ckey, item_id)
	if(!target_ckey || !item_id)
		return list("ok" = FALSE, "error" = "invalid_request")

	if(!is_preround_purchase_open())
		return list("ok" = FALSE, "error" = "shop_closed")

	var/datum/metacoin_shop_listing/listing = preround_catalog[item_id]
	if(!listing)
		return list("ok" = FALSE, "error" = "unknown_item")

	if(listing.listing_kind == "antag_token")
		return list("ok" = FALSE, "error" = "open_antag_panel")

	var/list/pending_items = preround_pending_by_ckey[target_ckey]
	if(!islist(pending_items))
		pending_items = list()
		preround_pending_by_ckey[target_ckey] = pending_items

	if(item_id in pending_items)
		return list("ok" = FALSE, "error" = "already_owned")

	if(!SSdbcore.Connect())
		return list("ok" = FALSE, "error" = "db_unavailable")

	var/current_balance = fetch_metacoin_balance(target_ckey)
	if(isnull(current_balance))
		return list("ok" = FALSE, "error" = "db_unavailable")

	if(current_balance < listing.price)
		return list("ok" = FALSE, "error" = "not_enough")

	var/table_player = format_table_name("player")
	var/datum/db_query/buy_query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins - :price WHERE ckey = :ckey AND metacoins >= :price",
		list(
			"price" = listing.price,
			"ckey" = target_ckey,
		),
	)

	if(!buy_query.warn_execute(async = FALSE))
		qdel(buy_query)
		return list("ok" = FALSE, "error" = "db_failed")
	qdel(buy_query)

	var/new_balance = fetch_metacoin_balance(target_ckey)
	if(isnull(new_balance))
		return list("ok" = FALSE, "error" = "db_failed")

	if(new_balance > (current_balance - listing.price))
		return list("ok" = FALSE, "error" = "not_enough")

	pending_items += item_id

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(player_mob)
		to_chat(player_mob, span_boldnicegreen("Purchased [listing.name] for [listing.price] metacoins. It will be delivered on first roundstart spawn."))
		player_mob.playsound_local(player_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
		SStgui.update_user_uis(player_mob)

	return list("ok" = TRUE)

/datum/metacoin_shop_controller/proc/try_purchase_antag_token(target_ckey, role_id)
	if(!target_ckey || !role_id)
		return list("ok" = FALSE, "error" = "invalid_request")

	if(!is_preround_purchase_open())
		return list("ok" = FALSE, "error" = "shop_closed")

	if(antag_token_pending_by_ckey[target_ckey])
		return list("ok" = FALSE, "error" = "already_owned")

	if(get_antag_token_slots_left() <= 0)
		return list("ok" = FALSE, "error" = "sold_out")

	var/list/block_info = get_antag_token_role_block_info(target_ckey, role_id)
	if(block_info)
		return list("ok" = FALSE, "error" = block_info["code"])

	var/datum/metacoin_shop_listing/listing = get_antag_token_listing()
	if(!listing)
		return list("ok" = FALSE, "error" = "unknown_item")

	if(!SSdbcore.Connect())
		return list("ok" = FALSE, "error" = "db_unavailable")

	var/current_balance = fetch_metacoin_balance(target_ckey)
	if(isnull(current_balance))
		return list("ok" = FALSE, "error" = "db_unavailable")

	if(current_balance < listing.price)
		return list("ok" = FALSE, "error" = "not_enough")

	var/table_player = format_table_name("player")
	var/datum/db_query/buy_query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins - :price WHERE ckey = :ckey AND metacoins >= :price",
		list(
			"price" = listing.price,
			"ckey" = target_ckey,
		),
	)

	if(!buy_query.warn_execute(async = FALSE))
		qdel(buy_query)
		return list("ok" = FALSE, "error" = "db_failed")
	qdel(buy_query)

	var/new_balance = fetch_metacoin_balance(target_ckey)
	if(isnull(new_balance))
		return list("ok" = FALSE, "error" = "db_failed")

	if(new_balance > (current_balance - listing.price))
		return list("ok" = FALSE, "error" = "not_enough")

	antag_token_pending_by_ckey[target_ckey] = role_id
	antag_token_slots_left = max(antag_token_slots_left - 1, 0)
	var/role_name = get_antag_token_role_display_name(role_id)
	log_game("[src] antag token purchase: ckey=[target_ckey], role=[role_id]/[role_name], price=[listing.price], balance_before=[current_balance], balance_after=[new_balance], slots_left=[antag_token_slots_left].")

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(player_mob)
		to_chat(player_mob, span_boldnicegreen("Purchased Antag Token ([role_name]) for [listing.price] metacoins. It will be applied at roundstart."))
		player_mob.playsound_local(player_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
		SStgui.update_user_uis(player_mob)

	return list("ok" = TRUE)

/datum/metacoin_shop_controller/proc/try_grant_antag_token_after_spawn(target_ckey, mob/living/spawned, client/player_client)
	if(!target_ckey)
		return

	var/selected_role = antag_token_pending_by_ckey[target_ckey]
	if(!selected_role)
		return

	log_game("[src] antag token grant attempt: ckey=[target_ckey], role=[selected_role], state=[SSticker?.current_state], round_started=[SSticker?.HasRoundStarted()], job=[spawned?.mind?.assigned_role?.title], has_client=[!isnull(spawned?.client)].")

	var/mob/notify_mob = ismob(spawned) ? spawned : get_mob_by_ckey(target_ckey)
	var/datum/job/current_job = spawned?.mind?.assigned_role
	var/list/block_info = get_antag_token_role_block_info(target_ckey, selected_role, current_job)
	if(block_info)
		var/failure_text = "Antag token could not be applied: [get_antag_token_role_block_text(block_info)]"
		log_game("[src] antag token grant blocked for [target_ckey]: code=[block_info["code"]], job=[current_job?.title].")
		refund_antag_token_purchase(target_ckey, failure_text, notify_mob)
		return

	if(!ishuman(spawned))
		log_game("[src] antag token grant failed for [target_ckey]: spawned mob is not human ([spawned?.type]).")
		refund_antag_token_purchase(target_ckey, "Antag token requires a human roundstart spawn.", notify_mob)
		return

	var/mob/living/carbon/human/human_spawned = spawned
	if(!human_spawned.mind)
		log_game("[src] antag token grant failed for [target_ckey]: human has no mind.")
		refund_antag_token_purchase(target_ckey, "Antag token failed: no valid player mind found.", notify_mob)
		return

	var/list/role_definition = get_antag_token_role_definition(selected_role)
	if(!role_definition)
		log_game("[src] antag token grant failed for [target_ckey]: invalid role definition '[selected_role]'.")
		refund_antag_token_purchase(target_ckey, "Antag token failed: selected role is invalid.", notify_mob)
		return

	var/antag_datum_path = role_definition["antag_datum"]
	var/datum/antagonist/created_antag = new antag_datum_path()
	created_antag.silent = TRUE
	human_spawned.mind.add_antag_datum(created_antag)

	var/datum/antagonist/granted_antag = human_spawned.mind.has_antag_datum(antag_datum_path, TRUE)
	if(!granted_antag)
		log_game("[src] antag token grant failed for [target_ckey]: antag datum [antag_datum_path] not present after add.")
		refund_antag_token_purchase(target_ckey, "Antag token failed to grant the selected role.", notify_mob)
		return

	addtimer(CALLBACK(src, PROC_REF(retry_show_antag_token_intro), target_ckey, granted_antag, 20), 1 SECONDS)

	antag_token_pending_by_ckey -= target_ckey
	log_game("[src] antag token grant success for [target_ckey]: role=[selected_role], slots_left=[antag_token_slots_left].")

	/*if(notify_mob)
	unnecessary actually. why do you think we have stinger sounds?
		var/role_name = role_definition["name"]
		to_chat(notify_mob, span_boldnicegreen("Antag token applied successfully: [role_name]."))
		notify_mob.playsound_local(notify_mob, 'sound/misc/server-ready.ogg', 25, TRUE, use_reverb = FALSE)
	*/
	SStgui.update_uis(src)

/datum/metacoin_shop_controller/proc/retry_show_antag_token_intro(target_ckey, datum/antagonist/granted_antag, attempts_left)
	if(!target_ckey || !granted_antag || QDELETED(granted_antag))
		return

	var/mob/player_mob = granted_antag.owner?.current
	if(!player_mob || ckey(player_mob.ckey) != target_ckey)
		player_mob = get_mob_by_ckey(target_ckey)

	if(!player_mob?.client)
		if(attempts_left > 0)
			addtimer(CALLBACK(src, PROC_REF(retry_show_antag_token_intro), target_ckey, granted_antag, attempts_left - 1), 0.5 SECONDS)
		return

	var/datum/action/antag_info/info_button = granted_antag.info_button_ref?.resolve()
	if(granted_antag.ui_name && !info_button)
		if(attempts_left > 0)
			addtimer(CALLBACK(src, PROC_REF(retry_show_antag_token_intro), target_ckey, granted_antag, attempts_left - 1), 0.5 SECONDS)
		return

	granted_antag.silent = FALSE
	granted_antag.greet()

	if(granted_antag.ui_name)
		to_chat(player_mob, span_boldnotice("For more info, read the panel. You can always come back to it using the button in the top left."))
		info_button?.Trigger(player_mob)

	var/type_policy = get_policy("[granted_antag.type]")
	if(type_policy)
		to_chat(player_mob, type_policy)

/datum/metacoin_shop_controller/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER

	if(!player_client)
		return

	var/target_ckey = ckey(player_client.ckey)
	var/selected_role = antag_token_pending_by_ckey[target_ckey]
	if(selected_role)
		log_game("[src] on_job_after_spawn for token owner [target_ckey]: role=[selected_role], state=[SSticker?.current_state], round_started=[SSticker?.HasRoundStarted()], job=[job?.title], assigned=[spawned?.mind?.assigned_role?.title].")

	if(SSticker?.HasRoundStarted())
		if(selected_role)
			log_game("[src] skipping antag token grant for [target_ckey]: round already started in on_job_after_spawn.")
		return
	if(!target_ckey)
		return

	try_grant_antag_token_after_spawn(target_ckey, spawned, player_client)

	if(!ishuman(spawned))
		return

	if(preround_delivered_by_ckey[target_ckey])
		return

	var/list/pending_items = preround_pending_by_ckey[target_ckey]
	if(!islist(pending_items) || !length(pending_items))
		return

	var/mob/living/carbon/human/human_spawned = spawned

	for(var/item_id in pending_items)
		var/datum/metacoin_shop_listing/listing = preround_catalog[item_id]
		if(listing?.listing_kind != "item" || !listing?.item_type)
			continue

		var/obj/item/new_item = new listing.item_type(human_spawned)
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
	var/datum/metacoin_shop_controller/shop = get_metacoin_shop_controller()
	var/balance = shop.fetch_metacoin_balance(client_ckey)

	data["isPregame"] = shop.is_preround_purchase_open()
	data["balance"] = isnull(balance) ? 0 : balance
	data["antagTokenSlotsLeft"] = shop.get_antag_token_slots_left()
	data["preroundItems"] = shop.get_catalog_ui_data(client_ckey)
	data["persistentItems"] = list()

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

		var/result = get_metacoin_shop_controller().try_purchase_preround_item(owner?.ckey, target_item)
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
	var/datum/metacoin_shop_controller/shop = get_metacoin_shop_controller()
	var/balance = shop.fetch_metacoin_balance(client_ckey)
	var/selected_role = shop.antag_token_pending_by_ckey[client_ckey]
	var/datum/metacoin_shop_listing/antag_listing = shop.get_antag_token_listing()

	data["isPregame"] = shop.is_preround_purchase_open()
	data["balance"] = isnull(balance) ? 0 : balance
	data["price"] = antag_listing?.price || 40
	data["slotsLeft"] = shop.get_antag_token_slots_left()
	data["alreadyPurchased"] = !isnull(selected_role)
	data["selectedRole"] = selected_role
	data["selectedRoleName"] = shop.get_antag_token_role_display_name(selected_role)
	data["roles"] = shop.get_antag_token_roles_ui_data(client_ckey)
	data["restrictedJobPreferences"] = shop.get_antag_token_restricted_job_preferences_for_client(owner)
	data["restrictedJobWarning"] = shop.get_antag_token_restricted_job_preferences_warning_for_client(owner)

	return data

/datum/metacoin_antag_token_panel/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "buy_antag_token_role")
		var/role_id = params["roleId"]
		if(!role_id)
			return FALSE

		var/result = get_metacoin_shop_controller().try_purchase_antag_token(owner?.ckey, role_id)
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

//TODO: Admin logs, paid metacoin deathmath matches, prettier ui, background change, more sounds upon clicks,
