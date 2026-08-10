/*
/datum/metacoinshop/listing/preround/donut_box/on_bought(datum/metacoin_shop_controller/shop, target_ckey, mob/player_mob, client/player_client, balance_after, role_id = null)
	to_chat(player_mob, span_green("success! die!")) // no idea why's there mob/player mob in params, but it's there, it exists! and it matters!

/datum/metacoinshop/listing/preround/donut_box/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	to_chat(human_spawned, span_green("success!"))
	sleep(20)
	to_chat(human_spawned, span_red("die!"))
	sleep(10)
	human_spawned.gib()// DIE!


example usage of variants for prerounds:

/datum/metacoinshop/listing/preround/backpack
	id = "backpack"
	name = "Backpack"
	desc = "A backpack of your chosen style!"
	price = 200
	item_type = /obj/item/storage/backpack
	variant_options = list("style" = list(
		/datum/metacoinshop/listing_variant/backpack/miner,
		/datum/metacoinshop/listing_variant/backpack/security,
	))

example usage of variants for persistent

/datum/metacoinshop/listing/persistent/_blessing/persistent_grant(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned, client/player_client)
	var/saved_variant = shop.persistent.get_variant(target_ckey, src.id)
	var/selected_id = parse_choice(saved_variant, "blessing")
	var/datum/metacoinshop/listing_variant/variant_type = get_variant_datum("blessing", selected_id)
	switch(variant_type.id)
		if("health")
			spawned.heal_overall_damage(25)
		if("wealth")
			spawned.put_in_hands(new /obj/item/stack/spacecash/c1000(spawned))

*/

/datum/metacoinshop/listing/preround/donut_box
	id = "donut_box"
	name = "Donut Box"
	desc = "A box of donuts... what else do you expect?"
	price = 50
	item_type = /obj/item/storage/fancy/donut_box

/datum/metacoinshop/listing/preround/spray_libital
	id = "spray_libital"
	name = "Libital Spray"
	desc = "An medigel full of libital, mainly used to treat bruises"
	price = 75
	item_type = /obj/item/reagent_containers/medigel/libital

/datum/metacoinshop/listing/preround/spray_auri
	id = "spray_auri"
	name = "Aiuri Spray"
	desc = "An medigel full of aiuri, mainly used to treat burns"
	price = 75
	item_type = /obj/item/reagent_containers/medigel/aiuri

/datum/metacoinshop/listing/preround/eva_kit
	id = "extra_vehicular"
	name = "Premium EVA-ready kit"
	desc = "Full-kit containing a bluespace-compressed jetpack, an oxygen tank, a suit, a helmet and a medkit! Gun included!"
	price = 300
	item_type = /obj/item/storage/box/eva_kit

/obj/item/storage/box/eva_kit
	name = "EVA kit"
	desc = "A sturdy looking box, label says \"it has everything needed for space exploration\""

/obj/item/storage/box/eva_kit/Initialize(mapload)
	. = ..()
	var/obj/item/stack/medical/suture/suture = new /obj/item/stack/medical/suture(src)
	suture.amount = 10
	var/obj/item/stack/medical/mesh/mesh = new /obj/item/stack/medical/mesh(src)
	mesh.amount = 10
	var/obj/item/stock_parts/power_store/cell/high/cell = new /obj/item/stock_parts/power_store/cell/high(src)
	cell.charge = 10000 // the fuck is a cell unit? ten thousand I guess? because after test a hundred is turned to be 0.1%
	var/obj/item/gun/energy/e_gun/mini/gun = new /obj/item/gun/energy/e_gun/mini(src)
	gun.pin = /obj/item/firing_pin/explorer
	var/obj/item/tank/jetpack/jpack = new /obj/item/tank/jetpack(src)
	//get current gas
	var/datum/gas_mixture/gas = jpack.return_air() // bitch it's literally oxygen
	gas.assert_gas(jpack.gas_type)
	// quadruple it and give it to the next jetpack
	gas.set_gas(/datum/gas/oxygen, ((24 * ONE_ATMOSPHERE) * jpack.volume / (R_IDEAL_GAS_EQUATION * T20C)))
	new /obj/item/clothing/suit/space(src)
	new /obj/item/clothing/head/helmet/space(src)
	new /obj/item/tank/internals/oxygen(src)
	new /obj/item/storage/medkit/advanced(src)
	new /obj/item/storage/belt/utility/full(src)
	new /obj/item/knife/combat/survival(src)
	new /obj/item/case_portable_recharger(src)
	new /obj/item/manual_cell_recharger(src)
	new /obj/item/stock_parts/servo/pico(src)
	new /obj/item/flashlight/seclite(src)

/obj/item/storage/box/eva_kit/examine(mob/user)
	. = ..()
	. += span_notice("It has a small label taped to it that says, \"Bluespace compressed!\" ")

/obj/item/storage/box/eva_kit/examine_more(mob/user)
	. = ..()
	. += span_notice("Items seem to be rather small on the inside.. however, taking anything from the box makes it impossible to put it back in..")

/datum/metacoinshop/listing/preround/other/self_surgery
	id = "surgery"
	name = "4U70-P3R4710N skillchip"
	desc = "A skillchip containing old Nanotrasen medical training protocols, which one could use to perform surgical operations on themselves. \
	This one is new, I'd say, \"almost pristine condition.\" It will be already implanted in your brain upon purchause and your arrival."
	price = 250
	item_type = /obj/item/skillchip/self_surgery

/datum/metacoinshop/listing/preround/other/self_surgery/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	var/obj/item/skillchip/skillchip = new item_type()
	human_spawned.implant_skillchip(skillchip)
	skillchip.try_activate_skillchip()
	playsound(human_spawned, 'sound/items/weapons/circsawhit.ogg', 100)
	to_chat(human_spawned, span_notice("You've been implanted with [skillchip.name]"))
