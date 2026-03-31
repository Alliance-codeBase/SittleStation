/obj/item/stack/sheet/mineral/mythril/five
	amount = 5

/datum/map_template/ruin/lavaland/strong_stone
	allow_duplicates = TRUE
	cost = 5

/turf/closed/mineral/strong/drop_ores()
	if(prob(33))
		new /obj/item/stack/sheet/mineral/mythril(src, 5)
	else
		new /obj/item/stack/sheet/mineral/adamantine(src, 5)
