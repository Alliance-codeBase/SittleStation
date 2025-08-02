// return back elite traitor modsuit, removed in PR
// https://github.com/tgstation/tgstation/pull/89472

/datum/uplink_item/suits/modsuit/elite_traitor
	name = "Elite Syndicate MODsuit"
	desc = "An upgraded, elite version of the Syndicate MODsuit. It features fireproofing, and also \
			provides the user with superior armor and mobility compared to the standard Syndicate MODsuit."
	item = /obj/item/mod/control/pre_equipped/traitor_elite
	// This one costs more than the nuke op counterpart
	purchasable_from = ~UPLINK_ALL_SYNDIE_OPS
	//progression_minimum = 90 MINUTES
	cost = 16
	cant_discount = TRUE
