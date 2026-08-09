/datum/metacoinshop/panel/settings
	interface_id = "MetacoinSettings"

/datum/metacoinshop/panel/settings/ui_data(mob/user)
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	var/datum/metacoinshop/persistent/persistent = shop.persistent
	var/user_ckey = user.ckey
	var/list/ui_data = list()
	var/list/rewards_data = list()

	for(var/reward_id in persistent.get_owned(user_ckey))
		var/datum/metacoinshop/listing/listing = shop.persistent_catalog[reward_id]
		if(!listing)
			continue

		rewards_data += list(list(
			"id" = listing.id,
			"name" = listing.name,
			"desc" = listing.desc,
			"icon" = listing.icon,
			"iconState" = listing.icon_state,
			"fallbackIcon" = shop.default_listing_fallback_icon,
			"enabled" = persistent.is_enabled(user_ckey, reward_id),
			"variant" = persistent.get_variant(user_ckey, reward_id),
			"variantOptions" = listing.serialize_variants(),
		))

	ui_data["rewards"] = rewards_data
	return ui_data

/datum/metacoinshop/panel/settings/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/metacoinshop/persistent/persistent = get_metacoin_controller().persistent
	var/owner_ckey = owner?.ckey

	if(action == "toggle_persistent")
		var/reward_id = params["rewardId"]
		if(!reward_id || !owner_ckey)
			return FALSE

		if(!persistent.owns(owner_ckey, reward_id))
			return FALSE

		var/enabled = persistent.is_enabled(owner_ckey, reward_id)
		if(isnull(enabled))
			return FALSE
		return persistent.set_enabled(owner_ckey, reward_id, !enabled)

	if(action == "set_variant")
		var/reward_id = params["rewardId"]
		var/variant = params["variant"]
		if(!reward_id || !owner_ckey)
			return FALSE

		if(!persistent.owns(owner_ckey, reward_id))
			return FALSE

		return persistent.set_variant(owner_ckey, reward_id, variant)

	return FALSE
