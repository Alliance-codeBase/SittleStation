/datum/metacoinshop/listing
	var/id
	var/name
	var/desc
	var/price
	var/item_type
	var/listing_type = "item"
	var/icon
	var/icon_state
	var/list/variant_options = list()

/// Is called after a successful purchase.
/datum/metacoinshop/listing/proc/on_bought(datum/metacoin_shop_controller/shop, target_ckey, mob/player_mob, client/player_client, balance_after, role_id = null)
	return TRUE
// here lies any additional logic you might want to add, mainly, I added it because I wanted to see a cool announcement when wycc's soul is bought

/datum/metacoinshop/listing/proc/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	return

// It's like the same ^^^ but you may edit variables of stuff in params, like human_spawned or item. e.g you may buy a baton, \
then have it variable edit'ed like so item.force = 25, potentially escaping any additional hardcode or unneeded bloat

/datum/metacoinshop/listing/proc/persistent_grant(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned, client/player_client)
	return
// it's persistenly repeated code on each round if the SSdb returns true whether something's been bought, use it for any effects on demand
// later on we'll add a preference flag to disable bought items on demand

/datum/metacoinshop/listing/proc/buy(datum/metacoin_shop_controller/shop, target_ckey, client/player_client, variant, role_id)
	return list("ok" = FALSE, "error" = "unknown_item")

/datum/metacoinshop/listing/proc/is_owned(target_ckey, list/owned_items)
	return islist(owned_items) && (id in owned_items)

/datum/metacoinshop/listing/proc/serialize(datum/metacoin_shop_controller/shop, target_ckey, balance, list/owned_items)
	return list(
		"id" = id,
		"kind" = listing_type,
		"name" = name,
		"desc" = desc,
		"price" = price,
		"icon" = icon,
		"iconState" = icon_state,
		"fallbackIcon" = shop.default_listing_fallback_icon,
		"owned" = is_owned(target_ckey, owned_items),
		"canAfford" = !isnull(balance) && balance >= price,
		"variantOptions" = serialize_variants(),
	)

/datum/metacoinshop/listing/proc/serialize_variants()
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

/datum/metacoinshop/listing/proc/notify_bought(mob/player_mob, message)
	if(!player_mob)
		return

	to_chat(player_mob, span_boldnicegreen(message))
	player_mob.playsound_local(player_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
	SStgui.update_user_uis(player_mob)

/datum/metacoinshop/listing/proc/reset(datum/metacoin_shop_controller/shop)
	return

/datum/metacoinshop/listing/proc/on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned, client/player_client)
	return

/datum/metacoinshop/listing/proc/on_latejoin(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned)
	return

/datum/metacoinshop/listing/proc/deliver(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, client/player_client)
	return

/// Returns datum of chosen variant of
/datum/metacoinshop/listing/proc/get_variant_datum(option_name, option_id)
	for(var/variant_path in variant_options?[option_name])
		var/datum/metacoinshop/listing_variant/variant_type = variant_path
		if(initial(variant_type.id) == option_id)
			return variant_type
	return null

/// Returns the id of the variant the player chose for the option group. Defaults to the group's first variant when nothing was chosen.
/// - variant - your string from db e.g "coolish"
/// - group - the option group key from variant_options
/datum/metacoinshop/listing/proc/parse_choice(variant, group)
	var/datum/metacoinshop/listing_variant/first_variant = variant_options[group][1]
	var/list/chosen = json_decode(variant)
	if(islist(chosen))
		var/chosen_id = chosen[group]
		if(chosen_id)
			return chosen_id
	return initial(first_variant.id)

/// Returns the item type to spawn for this player
/// Override for custom logic
/datum/metacoinshop/listing/proc/get_chosen_typepath(datum/metacoin_shop_controller/shop, target_ckey)
	if(!length(variant_options))
		return item_type

	var/option_name = variant_options[1]
	var/saved_variant = shop.get_pending_variant(target_ckey, src.id)
	var/selected_id = parse_choice(saved_variant, option_name)

	var/datum/metacoinshop/listing_variant/variant_type = get_variant_datum(option_name, selected_id)
	if(!variant_type)
		return item_type

	var/item_path = initial(variant_type.item_type)
	if(!item_path)
		return item_type

	return item_path

/datum/metacoinshop/listing/preround/buy(datum/metacoin_shop_controller/shop, target_ckey, client/player_client, variant, role_id)
	if(!shop.is_open())
		return list("ok" = FALSE, "error" = "shop_closed")

	var/list/pending_items = shop.preround_pending_by_ckey[target_ckey]
	if(!islist(pending_items))
		pending_items = list()
		shop.preround_pending_by_ckey[target_ckey] = pending_items

	if(id in pending_items)
		return list("ok" = FALSE, "error" = "already_owned")

	var/list/take = shop.wallet.take_metacoins(target_ckey, price)
	if(!take["ok"])
		return take

	pending_items[id] = variant
	var/mob/player_mob = player_client?.mob || get_mob_by_ckey(target_ckey)
	on_bought(shop, target_ckey, player_mob, player_client, take["balance"])
	notify_bought(player_mob, "Purchased [name] for [price] metacoins. It will be delivered on first roundstart spawn.")
	return list("ok" = TRUE)

/datum/metacoinshop/listing/preround/deliver(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, client/player_client)
	if(!item_type)
		return

	var/item_path = get_chosen_typepath(shop, target_ckey)
	var/obj/item/new_item = new item_path(human_spawned)
	bought_on_spawn(shop, target_ckey, human_spawned, new_item, player_client)
	if(human_spawned.back?.atom_storage?.attempt_insert(new_item, human_spawned, override = TRUE))
		return

	if(!human_spawned.put_in_hands(new_item))
		new_item.forceMove(get_turf(human_spawned))

/datum/metacoinshop/listing/preround/other
	listing_type = "other"

/datum/metacoinshop/listing/preround/other/deliver(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, client/player_client)
	bought_on_spawn(shop, target_ckey, human_spawned, null, player_client)

/datum/metacoinshop/listing_variant
	var/id
	var/name
	var/item_type
