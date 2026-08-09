GLOBAL_DATUM(metacoin_shop_controller, /datum/metacoin_shop_controller)

/proc/get_metacoin_controller()
	if(!GLOB.metacoin_shop_controller)
		GLOB.metacoin_shop_controller = new /datum/metacoin_shop_controller()
		GLOB.metacoin_shop_controller.register_signals()
	return GLOB.metacoin_shop_controller

/datum/metacoin_shop_controller
	var/list/preround_catalog = list()
	var/list/persistent_catalog = list()
	var/list/preround_pending_by_ckey = list()
	var/list/preround_delivered_by_ckey = list()
	var/default_listing_fallback_icon = "question-circle"
	var/signals_registered = FALSE

/datum/metacoin_shop_controller/New()
	. = ..()
	setup_catalog()

/datum/metacoin_shop_controller/proc/register_signals()
	if(signals_registered)
		return

	signals_registered = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_spawn))
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_LATEJOIN_SPAWN, PROC_REF(on_latejoin))
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(on_round_start)))
	SSticker.OnRoundend(CALLBACK(src, PROC_REF(on_round_end)))

/datum/metacoin_shop_controller/proc/setup_catalog()
	preround_catalog = make_catalog(/datum/metacoinshop/listing/preround)
	persistent_catalog = make_catalog(/datum/metacoinshop/listing/persistent)

/datum/metacoin_shop_controller/proc/make_catalog(listing_type)
	var/list/catalog = alist()
	for(var/listing_path in subtypesof(listing_type))
		var/datum/metacoinshop/listing/listing = new listing_path
		if(listing.item_type && !listing.icon)
			var/obj/item/type_cast_item_path = listing.item_type
			listing.icon = initial(type_cast_item_path.icon)
			listing.icon_state = initial(type_cast_item_path.icon_state)

		catalog[listing.id] = listing
	return catalog

/datum/metacoin_shop_controller/proc/on_round_start()
	preround_delivered_by_ckey = list()

/datum/metacoin_shop_controller/proc/on_round_end()
	reset_tokens()
	preround_pending_by_ckey = list()
	preround_delivered_by_ckey = list()

/datum/metacoin_shop_controller/proc/is_open()
	return SSticker?.current_state == GAME_STATE_PREGAME

/datum/metacoin_shop_controller/proc/refund_items(target_ckey, failure_text, mob/notify_mob)
	var/list/items_to_refund = preround_pending_by_ckey[target_ckey]
	if(!length(items_to_refund))
		return FALSE

	var/sum_to_refund = 0
	for(var/item in items_to_refund)
		var/datum/metacoinshop/listing/listing = preround_catalog[item]
		sum_to_refund += listing.price

	preround_pending_by_ckey -= target_ckey
	if(sum_to_refund > 0)
		add_metacoins(target_ckey, sum_to_refund)
		to_chat(notify_mob, span_warning(failure_text))
		notify_mob.playsound_local(notify_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
		return TRUE

/datum/metacoin_shop_controller/proc/catalog_ui(target_ckey, kind, balance)
	var/list/catalog_data = list()
	var/list/catalog = kind == "persistent" ? persistent_catalog : preround_catalog
	var/list/pending_items = kind == "preround" ? get_pending_items(target_ckey) : list()
	var/list/owned_items = kind == "persistent" ? owned_persistent(target_ckey) : null
	var/selected_antag_role = antag_token_pending_by_ckey[target_ckey]

	for(var/listing_id in catalog)
		var/datum/metacoinshop/listing/listing = catalog[listing_id]
		if(!listing)
			continue

		var/is_persistent = listing.listing_type == "persistent"
		var/is_owned = FALSE
		if(listing.listing_type == "antag_token")
			is_owned = !isnull(selected_antag_role)
		else if(is_persistent)
			is_owned = !!owned_items?[listing.id]
		else
			is_owned = (listing.id in pending_items)

		var/list/listing_payload = list(
			"id" = listing.id,
			"kind" = listing.listing_type,
			"name" = listing.name,
			"desc" = listing.desc,
			"price" = listing.price,
			"icon" = listing.icon,
			"iconState" = listing.icon_state,
			"fallbackIcon" = default_listing_fallback_icon,
			"owned" = is_owned,
			"canAfford" = !isnull(balance) && (balance >= listing.price),
			"variantOptions" = serialize_variant_options(listing.variant_options),
		)

		if(listing.listing_type == "antag_token")
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

/datum/metacoin_shop_controller/proc/check_reward_preference(target_ckey, listing_id)
	target_ckey = ckey(target_ckey)

	if(!target_ckey || !listing_id)
		return FALSE
	if(!SSdbcore.Connect())
		return null

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT enabled FROM [table_purchases] WHERE ckey = :ckey AND listing = :listing LIMIT 1",
		list(
			"ckey" = target_ckey,
			"listing" = listing_id,
		),
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return null

	var/is_enabled = FALSE
	if(query.NextRow(async = FALSE))
		is_enabled = query.item[1] > 0

	qdel(query)
	return is_enabled

/datum/metacoin_shop_controller/proc/set_persistent_owned(target_ckey, listing_id, owned = TRUE)
	target_ckey = ckey(target_ckey)
	if(!target_ckey || !listing_id || !SSdbcore.Connect())
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

/datum/metacoin_shop_controller/proc/set_persistent_enabled(target_ckey, listing_id, enabled = TRUE)
	target_ckey = ckey(target_ckey)
	if(!target_ckey || !listing_id || !SSdbcore.Connect())
		return FALSE

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/upsert_query = SSdbcore.NewQuery(
		"INSERT INTO [table_purchases] (ckey, listing, enabled) VALUES (:ckey, :listing, :enabled) ON DUPLICATE KEY UPDATE enabled = VALUES(enabled)",
		list(
			"ckey" = target_ckey,
			"listing" = listing_id,
			"enabled" = enabled ? TRUE : FALSE,
		),
	)

	if(!upsert_query.warn_execute(async = FALSE))
		qdel(upsert_query)
		return FALSE

	qdel(upsert_query)
	return TRUE

/datum/metacoin_shop_controller/proc/get_persistent_variant(target_ckey, listing_id)
	target_ckey = ckey(target_ckey)
	if(!target_ckey || !listing_id || !SSdbcore.Connect())
		return null

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT variant FROM [table_purchases] WHERE ckey = :ckey AND listing = :listing LIMIT 1",
		list(
			"ckey" = target_ckey,
			"listing" = listing_id,
		),
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return null

	var/variant
	if(query.NextRow(async = FALSE))
		variant = query.item[1]

	qdel(query)
	return variant

/datum/metacoin_shop_controller/proc/serialize_variant_options(variant_options)
	if(!islist(variant_options))
		return null

	var/list/serialized = list()
	for(var/option_name in variant_options)
		var/list/values = list()
		for(var/variant_path in variant_options[option_name])
			var/datum/metacoinshop/listing_variant/variant_type = variant_path
			values += list(list(
				"id" = initial(variant_type.id),
				"name" = initial(variant_type.name),
			))
		serialized[option_name] = values
	return serialized

/// Stores the selected variant JSON string of a persistent reward for a player.
/datum/metacoin_shop_controller/proc/set_persistent_variant(target_ckey, listing_id, variant = null)
	target_ckey = ckey(target_ckey)
	if(!target_ckey || !listing_id)
		return FALSE

	if(!SSdbcore.Connect())
		return FALSE

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/upsert_query = SSdbcore.NewQuery(
		"INSERT INTO [table_purchases] (ckey, listing, variant) VALUES (:ckey, :listing, :variant) ON DUPLICATE KEY UPDATE variant = VALUES(variant)",
		list(
			"ckey" = target_ckey,
			"listing" = listing_id,
			"variant" = variant,
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
		if(!check_reward_preference(target_ckey, listing_id))
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

/datum/metacoin_shop_controller/proc/get_pending_variant(target_ckey, item_id)
	if(!target_ckey || !item_id)
		return null

	var/list/pending_items = preround_pending_by_ckey[target_ckey]
	if(!islist(pending_items))
		return null

	return pending_items[item_id]

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

/datum/metacoin_shop_controller/proc/add_metacoins(target_ckey, amount)
	if(!target_ckey || !isnum(amount) || amount <= 0)
		return FALSE

	if(!SSdbcore.Connect())
		return FALSE

	var/table_player = format_table_name("player")
	var/datum/db_query/update_query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins + :delta WHERE ckey = :ckey",
		list(
			"delta" = amount,
			"ckey" = target_ckey,
		),
	)

	if(!update_query.warn_execute(async = FALSE))
		qdel(update_query)
		return FALSE

	qdel(update_query)
	return TRUE

///Takes coins in one atomic query
/datum/metacoin_shop_controller/proc/take_metacoins(target_ckey, amount)
	if(!target_ckey || !isnum(amount) || amount <= 0)
		return list("ok" = FALSE, "error" = "invalid_request")

	if(!SSdbcore.Connect())
		return list("ok" = FALSE, "error" = "db_unavailable")

	var/current_balance = fetch_balance(target_ckey)
	if(isnull(current_balance))
		return list("ok" = FALSE, "error" = "db_unavailable")

	if(current_balance < amount)
		return list("ok" = FALSE, "error" = "not_enough")

	var/table_player = format_table_name("player")
	var/datum/db_query/take_query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins - :delta WHERE ckey = :ckey AND metacoins >= :delta",
		list(
			"delta" = amount,
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

	if(new_balance > (current_balance - amount))
		return list("ok" = FALSE, "error" = "not_enough")

	return list(
		"ok" = TRUE,
		"balance" = new_balance,
	)

/datum/metacoin_shop_controller/proc/buy(target_ckey, item_id, role_id = null, client/player_client = null, variant = null)
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

		if(!set_persistent_owned(target_ckey, item_id, TRUE))
			if(!add_metacoins(target_ckey, listing.price))
				log_game("[src] persistent purchase refund failed: ckey=[target_ckey], listing=[item_id], price=[listing.price].")
			return list("ok" = FALSE, "error" = "db_failed")

		listing.on_bought(src, target_ckey, player_mob, player_client, take["balance"])

		if(player_mob)
			to_chat(player_mob, span_boldnicegreen("Purchased [listing.name] for [listing.price] metacoins."))
			player_mob.playsound_local(player_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
			SStgui.update_user_uis(player_mob)

		return list("ok" = TRUE)

	if(listing.listing_type == "item" || listing.listing_type == "other")
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

		pending_items[item_id] = variant

		listing.on_bought(src, target_ckey, player_mob, player_client, take["balance"])

		if(player_mob)
			var/delivery_text = listing.listing_type == "item" ? "delivered" : "applied"
			to_chat(player_mob, span_boldnicegreen("Purchased [listing.name] for [listing.price] metacoins. It will be [delivery_text] on first roundstart spawn."))
			player_mob.playsound_local(player_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
			SStgui.update_user_uis(player_mob)

		return list("ok" = TRUE)

	if(listing.listing_type != "antag_token")
		return list("ok" = FALSE, "error" = "unknown_item")

	return buy_token(target_ckey, listing, role_id, player_mob, player_client)

/datum/metacoin_shop_controller/proc/on_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER

	if(!player_client)
		return

	var/target_ckey = ckey(player_client.ckey)
	if(SSticker?.HasRoundStarted())
		return
	if(!target_ckey)
		return

	grant_token_on_spawn(target_ckey, spawned)
	grant_persistents(target_ckey, spawned, player_client)
	deliver_items(target_ckey, spawned, player_client)

/datum/metacoin_shop_controller/proc/deliver_items(target_ckey, mob/living/spawned, client/player_client)
	if(!ishuman(spawned))
		refund_items(target_ckey, "We were unable to deliver your preround items", spawned)
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

		var/item_path = listing.get_chosen_typepath(target_ckey)
		var/obj/item/new_item = new item_path(human_spawned)

		listing.bought_on_spawn(src, target_ckey, human_spawned, new_item, player_client)
		if(human_spawned.back?.atom_storage?.attempt_insert(new_item, human_spawned, override = TRUE))
			continue

		if(!human_spawned.put_in_hands(new_item))
			new_item.forceMove(get_turf(human_spawned))

	preround_pending_by_ckey -= target_ckey

	preround_delivered_by_ckey[target_ckey] = TRUE

	to_chat(human_spawned, span_boldnicegreen("Your preround purchases were delivered."))

	human_spawned.playsound_local(human_spawned, 'sound/misc/server-ready.ogg', 25, TRUE, use_reverb = FALSE)

/datum/metacoin_shop_controller/proc/on_latejoin(datum/source, datum/job/job, mob/living/spawned)
	SIGNAL_HANDLER

	var/target_ckey = spawned.ckey

	grant_persistents(target_ckey, spawned, spawned.client)
	deliver_items(target_ckey, spawned, spawned.client)
	addtimer(CALLBACK(src, PROC_REF(latejoin_token_grant), target_ckey, spawned), 2 SECONDS)

/datum/metacoinshop/panel
	var/client/owner
	var/interface_id

/datum/metacoinshop/panel/New(client/owner, mob/viewer)
	src.owner = owner
	ui_interact(viewer)

/datum/metacoinshop/panel/ui_state(mob/user)
	return GLOB.always_state

/datum/metacoinshop/panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface_id)
		ui.open()

/datum/metacoinshop/panel/proc/send_error(mob/user, error_code, list/error_messages, fallback_message)
	if(!user)
		return

	to_chat(user, span_warning(error_messages[error_code] || fallback_message))
	user.playsound_local(user, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)

/datum/metacoin_shop_panel
	parent_type = /datum/metacoinshop/panel
	interface_id = "MetaCoinShop"

/datum/metacoin_shop_panel/ui_data(mob/user)
	var/list/data = list()
	var/client_ckey = owner?.ckey
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	var/balance = shop.fetch_balance(client_ckey)

	data["isPregame"] = shop.is_open()
	data["balance"] = isnull(balance) ? 0 : balance
	data["antagTokenSlotsLeft"] = shop.get_token_slots()
	data["preroundItems"] = shop.catalog_ui(client_ckey, "preround", balance)
	data["persistentItems"] = shop.catalog_ui(client_ckey, "persistent", balance)

	return data

/datum/metacoin_shop_panel/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "open_slots")
		new /datum/metacoin_slot_panel(owner, ui.user)
		return TRUE

	if(action == "open_settings")
		new /datum/metacoinshop/settings_panel(owner, ui.user)
		return TRUE

	if(action == "open_antag_token")
		new /datum/metacoinshop/panel/antag_token(owner, ui.user)
		return TRUE

	if(action == "buy_preround")
		var/static/list/preround_error_messages = list(
			"shop_closed" = "Preround shop is only available before round start.",
			"open_antag_panel" = "Use the Antag Token picker window for this purchase.",
			"already_owned" = "You already purchased this item for this round.",
			"not_enough" = "Not enough metacoins.",
			"db_unavailable" = "Database error. Try again later.",
			"db_failed" = "Database error. Try again later.",
		)
		var/target_item = params["itemId"]
		if(!target_item)
			return FALSE

		var/result = get_metacoin_controller().buy(owner?.ckey, target_item, null, owner, params["variant"])
		if(result["ok"])
			return TRUE

		send_error(ui?.user, result["error"], preround_error_messages, "Purchase failed.")
		return FALSE

	if(action == "buy_persistent")
		var/static/list/persistent_error_messages = list(
			"already_owned" = "You already own this persistent reward.",
			"not_enough" = "Not enough metacoins.",
			"db_unavailable" = "Database error. Try again later.",
			"db_failed" = "Database error. Try again later.",
		)
		var/target_item = params["itemId"]
		if(!target_item)
			return FALSE

		var/result = get_metacoin_controller().buy(owner?.ckey, target_item, null, owner)
		if(result["ok"])
			return TRUE

		send_error(ui?.user, result["error"], persistent_error_messages, "Purchase failed.")
		return FALSE

	return FALSE

/client/verb/view_metacoin_shop()
	set name = "View Metacoin Shop"
	set category = "OOC"
	set desc = "Open metacoin shop window."

	new /datum/metacoin_shop_panel(src, usr)
