#define ORE_MULTIPLIER_MYTHRIL 0.1

/obj/structure/closet/crate/secure/bitrunning/decrypted/PopulateContents(reward_points, list/completion_loot, rewards_multiplier)
	. = ..()
	spawn_loot(completion_loot)

	if(reward_points > 4)
		if(prob(3))
			new /obj/item/stack/sheet/mineral/mythril(src, calculate_loot(reward_points, rewards_multiplier, ORE_MULTIPLIER_MYTHRIL))

#undef ORE_MULTIPLIER_MYTHRIL
