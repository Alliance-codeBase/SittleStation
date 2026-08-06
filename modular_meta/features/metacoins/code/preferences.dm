/datum/metacoinshop/settings_panel
	var/client/owner

/datum/metacoinshop/settings_panel/New(client/owner, mob/viewer)
	src.owner = owner
	ui_interact(viewer)

/datum/metacoinshop/settings_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/metacoinshop/settings_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MetacoinSettings")
		ui.open()

/datum/metacoinshop/settings_panel/ui_data(mob/user)
	var/datum/metacoin_shop_controller/controller = get_metacoin_controller()
	var/user_ckey = user.ckey
	var/list/ui_data = list()
	var/rewards_data = controller.get_owned_rewards(user_ckey)
	ui_data["rewards"] = rewards_data

	return ui_data

