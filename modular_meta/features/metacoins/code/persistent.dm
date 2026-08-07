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

/datum/metacoinshop/listing/persistent/perm_surg
		id = "perm_surg"
		name = "4U70-P3R4710N skillchip"
		desc = "Self-surgery skillchip, for your daily self-cutting needs!"
		price = 8704
		listing_type = "persistent"
		item_type = /obj/item/skillchip/self_surgery

/datum/metacoinshop/listing/persistent/perm_surg/persistent_grant(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned, client/player_client)
	var/obj/item/skillchip/skillchip = new item_type()
	var/mob/living/carbon/human/patient = spawned
	patient.implant_skillchip(skillchip)
	skillchip.try_activate_skillchip()

// DO NOT CHANGE ID'S, DOING SO WILL RESULT A DUPLICATE IN DB
/datum/metacoinshop/listing/persistent/wycc_soul
	id = "wycc_soul"
	name = "Unusual Cursed Strange Genuine Unique Vintage Collector's Decorated Community Self-made massmeta Wycc's own Soul"
	desc = "Spooky!"
	listing_type = "persistent"
	price = 220**2.20
	icon = 'icons/mob/human/species/ghost.dmi'
	icon_state = "ghost_base"
