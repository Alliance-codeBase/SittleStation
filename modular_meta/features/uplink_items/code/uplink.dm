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
	desc = "Looking like basicaly folding knife, but have syndicate mark. \
			Deals x4 damage bonus if you attack enemy from back."
	population_minimum = TRAITOR_POPULATION_LOWPOP
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
