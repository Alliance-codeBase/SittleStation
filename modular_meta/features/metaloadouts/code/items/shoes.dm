/datum/loadout_item/shoes/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.shoes)
			LAZYADD(outfit.backpack_contents, outfit.shoes)
		outfit.shoes = item_path
	else
		outfit.shoes = item_path

//clown
/datum/loadout_item/shoes/jester_shoes
	name = "Jester shoes"
	group = "Clown Outfit"
	item_path = /obj/item/clothing/shoes/clown_shoes/jester
	restricted_roles = list(JOB_CLOWN)

/datum/loadout_item/shoes/meown_shoes
	name = "Meown shoes"
	group = "Clown Outfit"
	item_path = /obj/item/clothing/shoes/clown_shoes/meown_shoes
	restricted_roles = list(JOB_CLOWN)

/datum/loadout_item/shoes/moffers
	name = "Moffers"
	group = "Clown Outfit"
	item_path = /obj/item/clothing/shoes/clown_shoes/moffers
	restricted_roles = list(JOB_CLOWN)


//sec
/datum/loadout_item/shoes/jackboots
	name = "Jackboots (Black)"
	group = "Security Department Outfit"
	item_path = /obj/item/clothing/shoes/jackboots
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_DETECTIVE, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_SECURITY_OFFICER_MEDICAL, JOB_SECURITY_OFFICER_ENGINEERING, JOB_SECURITY_OFFICER_SCIENCE, JOB_SECURITY_OFFICER_SUPPLY)

//cargo
/datum/loadout_item/shoes/miningboots
	name = "Workboots (Explorer) (Exclude Miner)"
	group = "Cargo Department Outfit"
	item_path = /obj/item/clothing/shoes/workboots/mining
	restricted_roles = list(JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN, JOB_BITRUNNER)

//engineering
/datum/loadout_item/shoes/magboots
	name = "Magnetic Boots"
	group = "Engineering Department Outfit"
	item_path = /obj/item/clothing/shoes/magboots
	restricted_roles = list(JOB_CHIEF_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN, JOB_STATION_ENGINEER)
