/*
	/datum/metacoinshop/listing/persistent/example_reward
		id = "example_reward"
		name = "Example Reward"
		desc = "Displayed text"
		price = 220

ID is the variable you use in owns_persistnent() proc, it refers to a line in DB, and returns 0 or 1 depending whether was it bought.

To check if a reward is bought
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	if(shop.owns_persistent(user.ckey, "example_reward") == TRUE)
		// There goes your feature/additional logic/etc.
		// you can lock anything behind it, unique reskins? job titles? jobs? like be able to spawn as an NT official? anything whatsoever!
*/

// DO NOT CHANGE ID'S, DOING SO WILL RESULT A DUPLICATE IN DB
/datum/metacoinshop/listing/persistent/wycc_soul
	id = "wycc_soul"
	name = "Unusual Cursed Strange Genuine Unique Vintage Collector's Decorated Community Self-made massmeta Wycc's own Soul"
	desc = "Spooky!"
	listing_type = "persistent"
	price = 220**2.20
	icon = 'icons/mob/human/species/ghost.dmi'
	icon_state = "ghost_base"

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

/datum/metacoin_shop_controller/proc/get_owned_rewards(ckey)
	var/datum/metacoin_shop_controller/controller
	var/rewards = controller.persistent_catalog

	for(var/reward in rewards)
		1



/datum/metacoinshop/settings_panel/ui_data(mob/user)
	var/list/panel
	if(shop.owns_persistent(user.ckey, reward) == TRUE)

