//the permabrig

/datum/outfit/deathmatch_loadout/prisoner
	name = "Deathmatch: Prisoner"
	display_name = "Prisoner"
	desc = "You must have committed war crimes"

	uniform = /obj/item/clothing/under/rank/prisoner
	back = /obj/item/storage/backpack
	box = /obj/item/storage/box/survival/prisoner
	shoes = /obj/item/clothing/shoes/sneakers/orange

//middle east showdown

/datum/outfit/deathmatch_loadout/t_mid_east
	name = "Deathmatch: Arabic Syndicate Terrorist"
	display_name = "Middle East Terrorist"
	desc = "Pray Allah"

	uniform = /obj/item/clothing/under/pants/slacks
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = /obj/item/gun/ballistic/automatic/wt550
	gloves = /obj/item/clothing/gloves/fingerless
	belt = /obj/item/grenade/c4
	back = /obj/item/storage/backpack/saddlepack
	mask = /obj/item/clothing/mask/balaclava
	shoes = /obj/item/clothing/shoes/workboots

	l_pocket = /obj/item/ammo_box/magazine/wt550m9
	r_pocket = /obj/item/ammo_box/magazine/wt550m9

	backpack_contents = list(
		/obj/item/ammo_box/magazine/wt550m9,
		/obj/item/grenade/c4,
		/obj/item/grenade/c4,
	)

/datum/outfit/deathmatch_loadout/t_mid_east/pre_equip(mob/living/carbon/human/user, visualsOnly = FALSE)

	switch(pick(list("headband", "helmet")))
		if("headband")
			head = /obj/item/clothing/head/costume/celebrant_headband
		if("helmet")
			head = /obj/item/clothing/head/helmet/rus_helmet

/datum/outfit/deathmatch_loadout/ct_mid_east
	name = "Deathmatch: NaTo Marines"
	display_name = "Soldier 'Peacemaker'"
	desc = "I am a soldier and I'm marching on"

	uniform = /obj/item/clothing/under/syndicate/rus_army
	suit = /obj/item/clothing/suit/armor/vest/marine
	gloves = /obj/item/clothing/gloves/combat
	belt = /obj/item/ammo_box/magazine/m38
	back = /obj/item/gun/ballistic/automatic/battle_rifle
	head = /obj/item/clothing/head/beret/militia
	shoes = /obj/item/clothing/shoes/jackboots/dagger

	l_pocket = /obj/item/ammo_box/magazine/m38
	r_pocket = /obj/item/ammo_box/magazine/m38

//kamurocho

/datum/outfit/deathmatch_loadout/dragon_of_dojima
	name = "Deathmatch: Dragon of Dojima"
	display_name = "Dragon of Dojima"
	desc = "Bring that shit on!"

	uniform = /obj/item/clothing/under/costume/mm/lad/brawler
	suit = /obj/item/clothing/suit/costume/mm/brawler_blazer
	shoes = /obj/item/clothing/shoes/laceup/mm_lgray

	skillchips = list(/obj/item/skillchip/wrestling)

/datum/outfit/deathmatch_loadout/mad_dog_of_shimano
	name = "Deathmatch: Mad Dog of Shimano"
	display_name = "Mad Dog of Shimano"
	desc = "One Eyed Slugger!"

	uniform = /obj/item/clothing/under/costume/mm/lad/maddog
	shoes = /obj/item/clothing/shoes/mm_metalcomb
	r_hand = /obj/item/knife/combat

	skillchips = list(/obj/item/skillchip/kaza_ruk)

//library

/datum/outfit/deathmatch_loadout/curator
	name = "Deathmatch: Curator"
	display_name = "Curator"
	desc = "What you looking at."

	uniform = /obj/item/clothing/under/rank/civilian/curator
	back = /obj/item/storage/backpack
	box = /obj/item/storage/box/survival
	backpack_contents = list(/obj/item/choice_beacon/hero = 1)
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/laser_pointer/green
	r_pocket = /obj/item/key/displaycase
	l_hand = /obj/item/storage/bag/books

	accessory = /obj/item/clothing/accessory/pocketprotector/full

//nuthouse

/datum/outfit/deathmatch_loadout/patient
	name = "Deathmatch: Patient"
	display_name = "Patient"
	desc = "COCKSUCKER!"

	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/sneakers/white

//furious mages

/datum/outfit/deathmatch_loadout/fur_wizard
	name = "Deathmatch: Arcane Wizard"
	display_name = "Arcane Wizard"
	desc = "Magic missile."
	uniform = /datum/outfit/wizard::uniform
	suit = /datum/outfit/wizard::suit
	head = /datum/outfit/wizard::head
	shoes = /datum/outfit/wizard::shoes
	r_hand = /obj/item/staff/broom
	spells_to_add = list(
		/datum/action/cooldown/spell/aoe/magic_missile,
		/datum/action/cooldown/spell/aoe/repulse/wizard,
		)

/datum/outfit/deathmatch_loadout/fur_wizard/fire
	name = "Deathmatch: Fire Wizard"
	display_name = "Fire Wizard"
	desc = "Too hot to handle."
	head = /obj/item/clothing/head/wizard/red
	suit = /obj/item/clothing/suit/wizrobe/red

	spells_to_add = list(
		/datum/action/cooldown/spell/aoe/sacred_flame,
		/datum/action/cooldown/spell/pointed/projectile/fireball,
		)

/datum/outfit/deathmatch_loadout/fur_wizard/lightning
	name = "Deathmatch: Lightning Wizard"
	display_name = "Lightning Wizard"
	desc = "Unlimited power!"
	head = /obj/item/clothing/head/wizard/yellow
	suit = /obj/item/clothing/suit/wizrobe/yellow

	spells_to_add = list(
		/datum/action/cooldown/spell/charged/beam/tesla,
		/datum/action/cooldown/spell/pointed/projectile/lightningbolt,
		)

/datum/outfit/deathmatch_loadout/fur_wizard/holy
	name = "Deathmatch: Holy Wizard"
	display_name = "Holy Wizard"
	desc = "Outheal the competition."
	head = /obj/item/clothing/head/cowboy/white
	suit = /obj/item/clothing/suit/chaplainsuit/whiterobe
	r_hand = /obj/item/gun/magic/wand/resurrection

	spells_to_add = list(
		/datum/action/cooldown/spell/charge,
		/datum/action/cooldown/spell/forcewall,
		)

/datum/outfit/deathmatch_loadout/fur_wizard/chaos
	name = "Deathmatch: Chaos Wizard"
	display_name = "Chaos Wizard"
	desc = "The touch of death."
	head = /obj/item/clothing/head/wizard/black
	suit = /obj/item/clothing/suit/wizrobe/black
	r_hand = /obj/item/gun/magic/staff/chaos

	spells_to_add = list(
		/datum/action/cooldown/spell/tap,
		/datum/action/cooldown/spell/touch/smite,
		)

/datum/outfit/deathmatch_loadout/fur_wizard/bee
	name = "Deathmatch: Bee Wizard"
	display_name = "Bee Wizard"
	desc = "OH NO, NOT THE BEES!"
	suit = /obj/item/clothing/suit/wizrobe/yellow
	head = /obj/item/clothing/head/wizard/yellow
	mask = /obj/item/clothing/mask/animal/small/bee/cursed
	r_hand = /obj/item/bee_smoker

	spells_to_add = list(
		/datum/action/cooldown/spell/conjure/bee,
		)

/datum/outfit/deathmatch_loadout/fur_chaplain
	name = "Deathmatch: The Chaplain"
	display_name = "The Chaplain"
	desc = "WIZARDS! FACE ME, COWARDS!"
	head = /obj/item/clothing/head/hooded/chaplain_hood
	suit = /obj/item/clothing/suit/hooded/chaplain_hoodie
	shoes = /obj/item/clothing/shoes/sandal
	l_hand = /obj/item/book/bible
	r_hand = /obj/item/nullrod

//waffle corp

/datum/outfit/deathmatch_loadout/syndicate
	name = "Deathmatch: Syndicate Agent"
	display_name = "Spinward Syndicate"
	desc = "The typical loadout for agents employed in the Spinward Periphery. Equipped with a pistol, a knife, and plenty of ammo."
	ears = /obj/item/radio/headset/syndicate/alt
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/vest
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack/fireproof
	id = /obj/item/card/id/advanced/chameleon
	l_hand = /obj/item/gun/ballistic/automatic/pistol
	l_pocket = /obj/item/knife/combat
	backpack_contents = list(/obj/item/ammo_box/magazine/m9mm = 5)
	implants = list(/obj/item/implant/explosive, /obj/item/implant/weapons_auth)
	var/jobname = "Syndicate Agent"

/datum/outfit/deathmatch_loadout/syndicate/post_equip(mob/living/carbon/human/player, visualsOnly = FALSE)
	if(visualsOnly)
		return
	var/obj/item/card/id/idcard = player.wear_id
	idcard.registered_name = player.real_name
	idcard.assignment = jobname
	idcard.trim = /datum/id_trim/syndicom
	return ..()

/datum/outfit/deathmatch_loadout/syndicate/cybersun
	name = "Deathmatch: Cybersun Troubleshooter"
	display_name = "Cybersun Industries"
	desc = "The loadout used by Cybersun's infamous Troubleshooter Division. Equipped with an S-120 and energy dagger."
	uniform = /obj/item/clothing/under/syndicate/cybersun
	suit = /obj/item/clothing/suit/jacket/leather_trenchcoat
	mask = /obj/item/clothing/mask/gas/syndicate/cybersun
	glasses = /obj/item/clothing/glasses/sunglasses/oval
	back = /obj/item/storage/backpack/messenger
	belt = /obj/item/gun/energy/laser/cybersun/unrestricted
	l_hand = null
	l_pocket = /obj/item/pen/edagger
	backpack_contents = null

/datum/outfit/deathmatch_loadout/syndicate/donk
	name = "Deathmatch: Donk Co. Employee"
	display_name = "Donk Company"
	desc = "Some people would kill to make minimum wage. This loadout is for those people. Equipped with a .38 revolver, grenades, and tactical rations."
	head = /obj/item/clothing/head/utility/hardhat/orange
	suit = /obj/item/clothing/suit/hazardvest
	back = /obj/item/storage/backpack/industrial
	shoes = /obj/item/clothing/shoes/workboots
	glasses = /obj/item/clothing/glasses/heat
	l_hand = /obj/item/gun/ballistic/revolver/c38
	l_pocket = /obj/item/grenade/smokebomb
	r_pocket = /obj/item/food/donkpocket/warm/deluxe
	id = /obj/item/card/id/away/donk
	backpack_contents = list(/obj/item/ammo_box/speedloader/c38 = 3, /obj/item/grenade/frag = 2,)

/datum/outfit/deathmatch_loadout/syndicate/gorlex
	name = "Deathmatch: Gorlex Rent-A-Trooper"
	display_name = "Gorlex Marauders"
	desc = "The uniform worn by Gorlex's basic troopers. Each soldier comes with a shotgun, a knife, and a grenade."
	head = /obj/item/clothing/head/helmet/swat
	uniform = /obj/item/clothing/under/syndicate/bloodred
	glasses = /obj/item/clothing/glasses/meson/night
	suit = /obj/item/clothing/suit/armor/vest/alt
	mask = /obj/item/clothing/mask/gas/syndicate
	id = /obj/item/card/id/advanced/black/syndicate_command
	l_hand = /obj/item/gun/ballistic/shotgun/lethal
	r_pocket = /obj/item/grenade/frag
	backpack_contents = list(/obj/item/ammo_casing/shotgun/buckshot = 4,)

/datum/outfit/deathmatch_loadout/syndicate/waffle
	name = "Deathmatch: Waffle Corporate Security"
	display_name = "Waffle Corporation"
	desc = "Standard equipment loadout for Waffle Corp's corporate security team. Equipped with an autorifle and spare ammo."
	uniform = /obj/item/clothing/under/syndicate/combat
	head = /obj/item/clothing/head/helmet/blueshirt
	suit = /obj/item/clothing/suit/armor/vest
	glasses = /obj/item/clothing/glasses/welding/up
	l_hand = null
	belt = /obj/item/gun/ballistic/automatic/wt550/waffle
	l_pocket = /obj/item/knife/combat/survival
	backpack_contents = list(/obj/item/ammo_box/magazine/wt550m9 = 2,)

/obj/item/gun/ballistic/automatic/wt550/waffle
	name = "\improper C-570 Autorifle"
	desc = "A lightweight, fully automatic carbine rifle based on a leaked Nanotrasen design. Uses 4.6x30mm rounds. It has 'Scarborough Arms' inscribed on its handle."

/datum/outfit/deathmatch_loadout/syndicate/roroco
	name = "Deathmatch: RoroCo Security Guard"
	display_name = "RoroCo"
	desc = "Used by Roroco Security Guards of Gloves Factory. Equipped with an nice tackler gloves and nunchaku."
	uniform = /obj/item/clothing/under/costume/buttondown/slacks/roroco
	suit = /obj/item/clothing/suit/jacket/fancy/roroco
	mask =/obj/item/clothing/mask/gas/syndicate
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	back = /obj/item/storage/backpack/messenger
	belt = /obj/item/melee/baton/nunchaku
	id = /obj/item/card/id/away/roroco/deathmatch
	l_hand = null
	l_pocket = /obj/item/reagent_containers/hypospray/medipen/atropine
	backpack_contents = null

/obj/item/clothing/suit/jacket/fancy/roroco
	greyscale_colors = "#FFCCCC#88242D"

/obj/item/card/id/away/roroco/deathmatch
	trim = /datum/id_trim/syndicom

//icemoon

/datum/outfit/deathmatch_loadout/miner
	name = "Deathmatch: Miner"
	display_name = "Miner"
	desc = "Rock and Stone!"

	r_hand = /obj/item/gun/energy/recharge/kinetic_accelerator
	uniform = /obj/item/clothing/under/rank/cargo/miner/lavaland
	glasses = /obj/item/clothing/glasses/meson/night
	gloves = /obj/item/clothing/gloves/color/black
	suit = /obj/item/clothing/suit/hooded/explorer
	shoes = /obj/item/clothing/shoes/workboots/mining
	mask = /obj/item/clothing/mask/gas/explorer
	internals_slot = ITEM_SLOT_SUITSTORE
	suit_store = /obj/item/tank/internals/oxygen/yellow
	l_pocket = /obj/item/knife/combat/survival
	r_pocket = /obj/item/flashlight/seclite

//friday 22

/datum/outfit/deathmatch_loadout/runner
	name = "Deathmatch: Runner"
	display_name = "Runner"
	desc = "Nothing will go wrong at Friday of 22th"

	uniform = /obj/item/clothing/under/costume/buttondown/shorts
	shoes = /obj/item/clothing/shoes/sneakers/brown
	belt = /obj/item/storage/belt/fannypack
	l_pocket = /obj/item/flashlight
	r_pocket = /obj/item/reagent_containers/cup/glass/waterbottle

/datum/outfit/deathmatch_loadout/runner/pre_equip(mob/living/carbon/human/user, visuals_only)
	. = ..()
	ADD_TRAIT(user, TRAIT_SWIMMER, REF(src))

/datum/outfit/deathmatch_loadout/slasher
	name = "Deathmatch: Slasher"
	display_name = "Slasher"
	desc = "Are you cosplayer?"

	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/toggle/jacket/trenchcoat/slasher
	back = /obj/item/fireaxe
	shoes = /obj/item/clothing/shoes/workboots/black
	mask = /obj/item/clothing/mask/madness_mask
	l_pocket = /obj/item/flashlight/flare/torch/red/on

/obj/item/clothing/suit/toggle/jacket/trenchcoat/slasher
	color = "#ffa05a"
