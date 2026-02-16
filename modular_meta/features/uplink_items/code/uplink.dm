////Байндлы в /bindle/bindles
///Вещи для нюкеров

//Мехи нюкеров

/datum/uplink_item/mech/justice
	name = "Justice Exosuit"
	desc = "Black and red syndicate mech designed for execution orders. \
		For safety reasons, the syndicate advises against standing too close."
	item = /obj/vehicle/sealed/mecha/justice/loaded
	cost = 60


///Вещи для определённых ролей трейторов

///Обычные предметы в аплинках трейторов
//dangerous категория
/datum/uplink_item/dangerous/backstab
	name = "Backstabing Knife"
	desc = "A specially designed syndicate's finest knife. \
			Used for stealthy assasinations, will deal bonus damage upon a hit from the back!"
	item = /obj/item/switchblade/backstab

	cost = 10
	purchasable_from = ~UPLINK_ALL_SYNDIE_OPS

//device tools категория
/datum/uplink_item/device_tools/ultdoorjack
	name = "Syndicate Ultimate authentication override card"
	desc = "Pinnacle of syndicate technical revolution. \
			A ultimate doorjack..? \
			Did the Cybersun scientists spent their research grant money on this? \
			Atleast it's better than the regular one having six charges, although has a longer cooldown."
	item = /obj/item/card/emag/doorjack/ultjacker
	cost = 6
	surplus = 20

//stealhy категория
/datum/uplink_item/stealthy_weapons/venom_knife
	name = "Poison Knife"
	desc = "Gorlex's new design on a combat knife, it has an integrated reagent container, \
	with each attack it is able to deliver deadliest poisons known to humanity, poisons not included! \
	Small note from Gorlex's engineers: use with poison kit to achieve best effect!"
	cost = 8
	item = /obj/item/knife/poison

/*Spy unique items.
	In pr #92481 some few cool spy items were added, since spy is a quite disliked antagonist out here,
	usually being either exchanged for an regular traitor or rather disabled by admins completely, we're going to add his items here.
	editing whole category "spy_unique" would cause some issues, due it having rocket launcher, bulldog shotgun and other quite impressive items.
	Genuinely, you do not want a traitor running around with an rocket launcher killing people
	So, what're we going to do, is to add all the funny items down here one by one.
*/
//stealthy category
/datum/uplink_item/stealthy_weapons/daggerboot
	name = "Boot Dagger"
	desc = "A pair of boots with a dagger embedded into the sole. Kicks with these will stab the target, potentially causing bleeding."
	item = /obj/item/clothing/shoes/jackboots/dagger
	cost = 4

//role_restricted catergory
/datum/uplink_item/role_restricted/monster_cube_box
	name = "Monster cube box"
	desc = "A box containing a bunch of random monster cubes. Add water and see what you get!"
	item = /obj/item/storage/box/monkeycubes/random
	cost = 12
	restricted_roles = list(JOB_SCIENTIST, JOB_CLOWN, JOB_RESEARCH_DIRECTOR, JOB_CHIEF_MEDICAL_OFFICER)

//dangerous category
/datum/uplink_item/dangerous/spider_bite_martial_arts
	name = "Spider-bite Martial Arts Scroll"
	desc = "A scroll teaching you the basics of the Spider Bite martial art."
	item = /obj/item/book/granter/martial/spider_bite
	cost = 10 // seems balanced to me.
	cant_discount = TRUE

/datum/uplink_item/dangerous/nunchaku
	name = "Syndie Fitness Nunchuks"
	desc = "Heavyweight titanium nunchucks, quickly knocking opponents to the ground, then just as easily smashing the opponent afterward."
	item = /obj/item/melee/baton/nunchaku
	cost = 12
	uplink_item_flags = SYNDIE_ILLEGAL_TECH | SYNDIE_TRIPS_CONTRABAND
	cant_discount = TRUE

/datum/uplink_item/implants/adrenal
	name = "Adrenal Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will inject a chemical \
			cocktail which removes all incapacitating effects, lets the user run faster and has a mild healing effect."
	item = /obj/item/storage/box/syndie_kit/imp_adrenal
	cost = 8
	limited_stock = 1 //To prevent a progressive traitor buying more than one. One click stun removal is nice, but only when it's limited.
	limited_discount_stock = 1

/obj/item/storage/box/syndie_kit/imp_adrenal
	name = "adrenal implant box"

/obj/item/storage/box/syndie_kit/imp_adrenal/PopulateContents()
	new /obj/item/implanter/adrenalin(src)
