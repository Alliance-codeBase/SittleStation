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
/datum/metacoinshop/listing/proc/get_chosen_typepath(target_ckey)
	if(!length(variant_options))
		return item_type

	var/option_name = variant_options[1]
	var/saved_variant = get_metacoin_controller().get_pending_variant(target_ckey, src.id)
	var/selected_id = parse_choice(saved_variant, option_name)

	var/datum/metacoinshop/listing_variant/variant_type = get_variant_datum(option_name, selected_id)
	if(!variant_type)
		return item_type

	var/item_path = initial(variant_type.item_type)
	if(!item_path)
		return item_type

	return item_path

/datum/metacoinshop/listing/preround

/datum/metacoinshop/listing_variant
	var/id
	var/name
	var/item_type
