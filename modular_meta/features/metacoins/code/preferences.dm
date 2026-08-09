/datum/metacoinshop/settings_panel
	parent_type = /datum/metacoinshop/panel
	interface_id = "MetacoinSettings"

/datum/metacoinshop/settings_panel/ui_data(mob/user)
	var/datum/metacoin_shop_controller/controller = get_metacoin_controller()
	var/user_ckey = user.ckey
	var/list/ui_data = list()
	var/list/rewards_data = list()

	for(var/reward_id in controller.owned_persistent(user_ckey))
		var/datum/metacoinshop/listing/listing = controller.persistent_catalog[reward_id]
		if(!listing)
			continue

		rewards_data += list(list(
			"id" = listing.id,
			"name" = listing.name,
			"desc" = listing.desc,
			"icon" = listing.icon,
			"iconState" = listing.icon_state,
			"fallbackIcon" = controller.default_listing_fallback_icon,
			"enabled" = controller.check_reward_preference(user_ckey, reward_id),
			"variant" = controller.get_persistent_variant(user_ckey, reward_id),
			"variantOptions" = controller.serialize_variant_options(listing.variant_options),
		))

	ui_data["rewards"] = rewards_data
	return ui_data

/datum/metacoinshop/settings_panel/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/metacoin_shop_controller/controller = get_metacoin_controller()
	var/owner_ckey = owner?.ckey

	if(action == "toggle_persistent")
		var/reward_id = params["rewardId"]
		if(!reward_id || !owner_ckey)
			return FALSE

		if(!controller.owns_persistent(owner_ckey, reward_id))
			return FALSE

		return controller.set_persistent_enabled(owner_ckey, reward_id, !controller.check_reward_preference(owner_ckey, reward_id))

	if(action == "set_variant")
		var/reward_id = params["rewardId"]
		var/variant = params["variant"]
		if(!reward_id || !owner_ckey)
			return FALSE

		if(!controller.owns_persistent(owner_ckey, reward_id))
			return FALSE

		return controller.set_persistent_variant(owner_ckey, reward_id, variant)

	return FALSE
