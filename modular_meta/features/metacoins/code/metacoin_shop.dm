GLOBAL_DATUM(metacoin_shop_controller, /datum/metacoin_shop_controller)

/proc/get_metacoin_controller()
	if(!GLOB.metacoin_shop_controller)
		GLOB.metacoin_shop_controller = new /datum/metacoin_shop_controller()
		GLOB.metacoin_shop_controller.register_signals()
	return GLOB.metacoin_shop_controller

/datum/metacoin_shop_controller
	var/datum/metacoins_controller/wallet
	var/datum/metacoinshop/slot/slot
	var/datum/metacoinshop/persistent/persistent
	var/list/preround_catalog = list()
	var/list/persistent_catalog = list()
	var/list/preround_pending_by_ckey = list()
	var/list/preround_delivered_by_ckey = list()
	var/default_listing_fallback_icon = "question-circle"

/datum/metacoin_shop_controller/New()
	. = ..()
	wallet = get_metacoins_controller()
	slot = new(src)
	persistent = new(src)
	setup_catalog()

/datum/metacoin_shop_controller/proc/register_signals()
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
	for(var/listing_id in preround_catalog)
		var/datum/metacoinshop/listing/listing = preround_catalog[listing_id]
		listing.reset(src)

	preround_pending_by_ckey = list()
	preround_delivered_by_ckey = list()

/datum/metacoin_shop_controller/proc/is_open()
	return SSticker?.current_state == GAME_STATE_PREGAME

/datum/metacoin_shop_controller/proc/get_listing(listing_id)
	return persistent_catalog[listing_id] || preround_catalog[listing_id]

/datum/metacoin_shop_controller/proc/refund_items(target_ckey, failure_text, mob/notify_mob)
	var/list/items_to_refund = preround_pending_by_ckey[target_ckey]
	if(!length(items_to_refund))
		return FALSE

	var/sum_to_refund = 0
	for(var/item in items_to_refund)
		var/datum/metacoinshop/listing/listing = preround_catalog[item]
		sum_to_refund += listing.price

	preround_pending_by_ckey -= target_ckey
	wallet.add_metacoins(target_ckey, sum_to_refund)
	to_chat(notify_mob, span_warning(failure_text))
	notify_mob.playsound_local(notify_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)
	return TRUE

/datum/metacoin_shop_controller/proc/catalog_ui(target_ckey, balance, list/catalog, list/owned_items)
	var/list/catalog_data = list()
	for(var/listing_id in catalog)
		var/datum/metacoinshop/listing/listing = catalog[listing_id]
		catalog_data += list(listing.serialize(src, target_ckey, balance, owned_items))

	return catalog_data

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

/datum/metacoin_shop_controller/proc/buy(target_ckey, item_id, role_id = null, client/player_client = null, variant = null)
	target_ckey = ckey(target_ckey || player_client?.ckey)
	if(!target_ckey || !item_id)
		return list("ok" = FALSE, "error" = "invalid_request")

	var/datum/metacoinshop/listing/listing = get_listing(item_id)
	if(!listing)
		return list("ok" = FALSE, "error" = "unknown_item")

	return listing.buy(src, target_ckey, player_client, variant, role_id)

/datum/metacoin_shop_controller/proc/on_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER

	if(!player_client)
		return

	var/target_ckey = ckey(player_client.ckey)
	if(SSticker?.HasRoundStarted())
		return
	if(!target_ckey)
		return

	for(var/listing_id in preround_catalog)
		var/datum/metacoinshop/listing/listing = preround_catalog[listing_id]
		listing.on_spawn(src, target_ckey, spawned, player_client)

	persistent.grant(target_ckey, spawned, player_client)
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
		listing.deliver(src, target_ckey, human_spawned, player_client)

	preround_pending_by_ckey -= target_ckey

	preround_delivered_by_ckey[target_ckey] = TRUE

	to_chat(human_spawned, span_boldnicegreen("Your preround purchases were delivered."))

	human_spawned.playsound_local(human_spawned, 'sound/misc/server-ready.ogg', 25, TRUE, use_reverb = FALSE)

/datum/metacoin_shop_controller/proc/on_latejoin(datum/source, datum/job/job, mob/living/spawned)
	SIGNAL_HANDLER

	var/target_ckey = spawned.ckey

	persistent.grant(target_ckey, spawned, spawned.client)
	deliver_items(target_ckey, spawned, spawned.client)
	for(var/listing_id in preround_catalog)
		var/datum/metacoinshop/listing/listing = preround_catalog[listing_id]
		listing.on_latejoin(src, target_ckey, spawned)

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

/datum/metacoinshop/panel/proc/send_error(mob/user, error_code, fallback_message)
	var/static/list/error_messages = list(
		"shop_closed" = "Shop is only available before round start.",
		"open_antag_panel" = "Choose an antagonist role first.",
		"already_owned" = "You already own this listing.",
		"sold_out" = "No antag tokens are left for this round.",
		"job_banned" = "You are jobbanned from this antagonist role.",
		"disabled_by_config" = "This role is disabled by dynamic config.",
		"min_pop" = "Current population is too low for this role.",
		"not_enough" = "Not enough metacoins.",
		"db_unavailable" = "Database error. Try again later.",
		"db_failed" = "Database error. Try again later.",
		"unknown_role" = "Selected role is not valid.",
	)
	if(!user)
		return

	to_chat(user, span_warning(error_messages[error_code] || fallback_message))
	user.playsound_local(user, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)

/datum/metacoinshop/panel/shop
	interface_id = "MetaCoinShop"

/datum/metacoinshop/panel/shop/ui_data(mob/user)
	var/list/data = list()
	var/client_ckey = owner?.ckey
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	var/balance = shop.wallet.fetch_balance(client_ckey)

	data["isPregame"] = shop.is_open()
	data["balance"] = isnull(balance) ? 0 : balance
	data["preroundItems"] = shop.catalog_ui(client_ckey, balance, shop.preround_catalog, shop.get_pending_items(client_ckey))
	data["persistentItems"] = shop.catalog_ui(client_ckey, balance, shop.persistent_catalog, shop.persistent.get_owned(client_ckey))

	return data

/datum/metacoinshop/panel/shop/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "open_slots")
		new /datum/metacoinshop/panel/slot(owner, ui.user)
		return TRUE

	if(action == "open_settings")
		new /datum/metacoinshop/panel/settings(owner, ui.user)
		return TRUE

	if(action == "open_antag_token")
		new /datum/metacoinshop/panel/antag_token(owner, ui.user)
		return TRUE

	if(action == "buy_preround")
		return buy(params["itemId"], params["variant"], ui?.user)

	if(action == "buy_persistent")
		return buy(params["itemId"], null, ui?.user)

	return FALSE

/datum/metacoinshop/panel/shop/proc/buy(listing_id, variant, mob/user)
	if(!listing_id)
		return FALSE

	var/result = get_metacoin_controller().buy(owner?.ckey, listing_id, null, owner, variant)
	if(result["ok"])
		return TRUE

	send_error(user, result["error"], "Purchase failed.")
	return FALSE

/client/verb/view_metacoin_shop()
	set name = "View Metacoin Shop"
	set category = "OOC"
	set desc = "Open metacoin shop window."

	new /datum/metacoinshop/panel/shop(src, usr)
