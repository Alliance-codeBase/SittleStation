/*
	/datum/metacoinshop/listing/persistent/example_reward
		id = "example_reward"
		name = "Example Reward"
		desc = "Displayed text"
		price = 220

ID is the variable you use in persistent.owns() proc, it refers to a line in DB, and returns 0 or 1 depending whether was it bought.

To check if a reward is bought
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	if(shop.persistent.owns(user.ckey, "example_reward") == TRUE)
		// There goes your feature/additional logic/etc.
		// you can lock anything behind it, unique reskins? job titles? jobs? like be able to spawn as an NT official? anything whatsoever!
*/

// DO NOT CHANGE ID'S, DOING SO WILL RESULT A DUPLICATE IN DB

/datum/metacoinshop/listing/persistent
	listing_type = "persistent"

/datum/metacoinshop/persistent
	var/datum/metacoin_shop_controller/shop

/datum/metacoinshop/persistent/New(datum/metacoin_shop_controller/shop)
	src.shop = shop

/datum/metacoinshop/persistent/proc/get_owned(target_ckey)
	target_ckey = ckey(target_ckey)
	if(!target_ckey)
		return list()
	if(!SSdbcore.Connect())
		return null

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT listing FROM [table_purchases] WHERE ckey = :ckey AND owned = TRUE",
		list("ckey" = target_ckey),
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return null

	var/list/owned_items = list()
	while(query.NextRow(async = FALSE))
		var/listing_id = query.item[1]
		if(listing_id)
			owned_items[listing_id] = TRUE

	qdel(query)
	return owned_items

/datum/metacoinshop/persistent/proc/read_flag(target_ckey, listing_id, flag)
	target_ckey = ckey(target_ckey)
	if(!target_ckey || !listing_id)
		return FALSE
	if(!SSdbcore.Connect())
		return null

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT [flag] FROM [table_purchases] WHERE ckey = :ckey AND listing = :listing LIMIT 1",
		list(
			"ckey" = target_ckey,
			"listing" = listing_id,
		),
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return null

	var/value = FALSE
	if(query.NextRow(async = FALSE))
		value = query.item[1] > 0

	qdel(query)
	return value

/datum/metacoinshop/persistent/proc/write_flag(target_ckey, listing_id, flag, value)
	target_ckey = ckey(target_ckey)
	if(!target_ckey || !listing_id || !SSdbcore.Connect())
		return FALSE

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO [table_purchases] (ckey, listing, [flag]) VALUES (:ckey, :listing, :value) ON DUPLICATE KEY UPDATE [flag] = VALUES([flag])",
		list(
			"ckey" = target_ckey,
			"listing" = listing_id,
			"value" = value ? TRUE : FALSE,
		),
	)
	var/success = query.warn_execute(async = FALSE)
	qdel(query)
	return success

/datum/metacoinshop/persistent/proc/owns(target_ckey, listing_id)
	return read_flag(target_ckey, listing_id, "owned")

/datum/metacoinshop/persistent/proc/is_enabled(target_ckey, listing_id)
	return read_flag(target_ckey, listing_id, "enabled")

/datum/metacoinshop/persistent/proc/set_owned(target_ckey, listing_id, owned = TRUE)
	return write_flag(target_ckey, listing_id, "owned", owned)

/datum/metacoinshop/persistent/proc/set_enabled(target_ckey, listing_id, enabled = TRUE)
	return write_flag(target_ckey, listing_id, "enabled", enabled)

/datum/metacoinshop/persistent/proc/get_variant(target_ckey, listing_id)
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

/// Stores the selected variant JSON string of a persistent reward for a player.
/datum/metacoinshop/persistent/proc/set_variant(target_ckey, listing_id, variant = null)
	target_ckey = ckey(target_ckey)
	if(!target_ckey || !listing_id || !SSdbcore.Connect())
		return FALSE

	var/table_purchases = format_table_name("metacoin_purchases")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO [table_purchases] (ckey, listing, variant) VALUES (:ckey, :listing, :variant) ON DUPLICATE KEY UPDATE variant = VALUES(variant)",
		list(
			"ckey" = target_ckey,
			"listing" = listing_id,
			"variant" = variant,
		),
	)
	var/success = query.warn_execute(async = FALSE)
	qdel(query)
	return success

/datum/metacoinshop/persistent/proc/grant(target_ckey, mob/living/spawned, client/player_client)
	target_ckey = ckey(target_ckey)
	if(!target_ckey)
		return FALSE

	var/list/owned_items = get_owned(target_ckey)
	if(isnull(owned_items))
		return FALSE

	for(var/listing_id in owned_items)
		var/datum/metacoinshop/listing/listing = shop.persistent_catalog[listing_id]
		if(listing && is_enabled(target_ckey, listing_id))
			listing.persistent_grant(shop, target_ckey, spawned, player_client)

	return TRUE

/datum/metacoinshop/listing/persistent/buy(datum/metacoin_shop_controller/shop, target_ckey, client/player_client, variant, role_id)
	var/owned = shop.persistent.owns(target_ckey, id)
	if(isnull(owned))
		return list("ok" = FALSE, "error" = "db_unavailable")
	if(owned)
		return list("ok" = FALSE, "error" = "already_owned")

	var/list/take = shop.wallet.take_metacoins(target_ckey, price)
	if(!take["ok"])
		return take

	if(!shop.persistent.set_owned(target_ckey, id))
		shop.wallet.add_metacoins(target_ckey, price)
		return list("ok" = FALSE, "error" = "db_failed")

	var/mob/player_mob = player_client?.mob || get_mob_by_ckey(target_ckey)
	on_bought(shop, target_ckey, player_mob, player_client, take["balance"])
	notify_bought(player_mob, "Purchased [name] for [price] metacoins.")
	return list("ok" = TRUE)

/datum/metacoinshop/listing/persistent/wycc_soul
	id = "wycc_soul"
	name = "Unusual Cursed Strange Genuine Unique Vintage Collector's Decorated Community Self-made massmeta Wycc's own Soul"
	desc = "Spooky!"
	price = 220**2.20
	icon = 'icons/mob/human/species/ghost.dmi'
	icon_state = "ghost_base"
	variant_options = list("color" = list(/datum/metacoinshop/listing_variant/wycc_soul/strange, /datum/metacoinshop/listing_variant/wycc_soul/unusual))

// Okay, so these "listing_variants" are like options for people to use, like, \
imagine you've set up an persistent reward of a crayon. Then you add these listing variants \
for a user to choose from, for an example, they may choose to get an green craoyon instead of a blue one
/datum/metacoinshop/listing_variant/wycc_soul/unusual
	id = "unusual"
	name = "Neobuchniy"

/datum/metacoinshop/listing_variant/wycc_soul/strange
	id = "strange"
	name = "Stranniy"
