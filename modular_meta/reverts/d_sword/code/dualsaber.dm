/obj/item/dualsaber
    block_chance = 100
/obj/item/dualsaber/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
    if(!HAS_TRAIT(src, TRAIT_WIELDED))
        return FALSE //not interested unless we're wielding
    if(attack_type == MELEE_ATTACK)
        final_block_chance = 75 // мили атака - 75%
    if(attack_type == PROJECTILE_ATTACK)
        var/obj/projectile/our_projectile = hitby

        if(our_projectile.reflectable)
            final_block_chance = 0 //we handle this via IsReflect(), effectively 75% block
        else
            final_block_chance -= 25 //We aren't AS good at blocking physical projectiles, like ballistics and thermals

    if(attack_type == LEAP_ATTACK)
        final_block_chance -= 50 //We are particularly bad at blocking someone JUMPING at us..

    if(attack_type == OVERWHELMING_ATTACK)
        final_block_chance = 0 //Far too small to block these kinds of attacks.

    return ..()
/datum/uplink_item/dangerous/doublesword
    cost = 16
/datum/uplink_item/dangerous/doublesword/get_discount_value(discount_type)
	switch(discount_type)
		if(TRAITOR_DISCOUNT_BIG)
			return 0.35
		if(TRAITOR_DISCOUNT_AVERAGE)
			return 0.2
		else
			return 0.1
