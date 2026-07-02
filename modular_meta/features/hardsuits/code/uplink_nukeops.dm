//code/modules/uplink/uplink_items/nukeops.dm

/datum/uplink_item/suits/hardsuit/syndi
	name = "Syndicate Hardsuit"
	desc = "The feared suit of a Syndicate nuclear agent. Features slightly better armoring, a built in jetpack \
			that runs off standard atmospheric tanks and an advanced team location system. Toggling the suit in and out of \
			combat mode will allow you all the mobility of a loose fitting uniform without sacrificing armoring. \
			Additionally the suit is collapsible, making it small enough to fit within a backpack. \
			Nanotrasen crew who spot these suits are known to panic."
	item = /obj/item/clothing/suit/space/hardsuit/syndi
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/suits/hardsuit/syndi_elite
	name = "Elite Syndicate Hardsuit"
	desc = "An upgraded, elite version of the Syndicate hardsuit. It features fireproofing, and also \
			provides the user with superior armor and mobility compared to the standard Syndicate hardsuit."
	item = /obj/item/clothing/suit/space/hardsuit/syndi/elite
	cost = 8
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/suits/hardsuit/syndi_shielded
	name = "Shielded Hardsuit"
	desc = "An upgraded version of the standard Syndicate hardsuit. It features a built-in energy shielding system. \
			The shields can handle up to three impacts within a short duration and will rapidly recharge while not under fire."
	item = /obj/item/clothing/suit/space/hardsuit/shielded/syndi
	cost = 20
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/suits/hardsuit/syndi_military
	name = "Military Hardsuit"
	desc = "An military version of the syndicate hardsuit designed for active combat operations. It features heavy armor, \
			that can hinder mobility at the expense of high protection."
	item = /obj/item/clothing/suit/space/hardsuit/syndi_military
	cost = 14
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
