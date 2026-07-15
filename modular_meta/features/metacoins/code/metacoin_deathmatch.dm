/// Tries to charge the player for current entry fee before adding them to players list.
/datum/deathmatch_lobby/proc/pay_fee(mob/player)
	if(!player?.ckey)
		return FALSE

	var/already_paid = fees_paid[player.ckey] || 0
	if(entry_fee <= already_paid)
		return TRUE

	var/to_pay = entry_fee - already_paid
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	if(!shop)
		to_chat(player, span_warning("Metacoin subsystem is unavailable."))
		return FALSE

	var/list/take_result = shop.take_metacoins(player.ckey, to_pay)
	if(!take_result["ok"])
		switch(take_result["error"])
			if("not_enough")
				to_chat(player, span_warning("Not enough metacoins for entry fee ([entry_fee])."))
			if("db_unavailable", "db_failed")
				to_chat(player, span_warning("Metacoin database is unavailable."))
			else
				to_chat(player, span_warning("Failed to pay lobby entry fee."))
		return FALSE

	fees_paid[player.ckey] = already_paid + to_pay
	prize_pool += to_pay
	to_chat(player, span_boldnicegreen("Entry fee paid: [to_pay] metacoins."))
	return TRUE

/// Returns paid fee to the player while lobby is not in active match state.
/datum/deathmatch_lobby/proc/refund_fee(target_ckey, reason)
	if(!target_ckey)
		return FALSE

	var/paid_amount = fees_paid[target_ckey] || 0
	if(paid_amount <= 0)
		fees_paid -= target_ckey
		return TRUE

	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	if(!shop || !shop.add_metacoins(target_ckey, paid_amount))
		log_game("Deathmatch lobby [host] failed to refund [paid_amount] metacoins to [target_ckey].")
		return FALSE

	prize_pool = max(prize_pool - paid_amount, 0)
	fees_paid -= target_ckey

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(player_mob)
		to_chat(player_mob, span_notice("Entry fee refunded: [paid_amount] metacoins. [reason]"))
	return TRUE

/// Pays prize pool to winner. If payout fails, tries to refund everyone.
/datum/deathmatch_lobby/proc/pay_pool(winner_ckey, mob/winner)
	if(prize_pool <= 0)
		return

	var/payout_amount = prize_pool
	var/list/paid_snapshot = fees_paid?.Copy() || list()
	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()

	if(winner_ckey && shop?.add_metacoins(winner_ckey, payout_amount))
		announce(span_boldnicegreen("[winner ? winner.real_name : winner_ckey] received [payout_amount] metacoins from the prize pool."))
		if(winner)
			to_chat(winner, span_boldnicegreen("You won [payout_amount] metacoins from this deathmatch prize pool."))
		log_game("Deathmatch lobby [host] paid [payout_amount] metacoins to [winner_ckey].")
		prize_pool = 0
		fees_paid = list()
		return

	var/payout_target = winner_ckey || "no winner"
	log_game("Deathmatch lobby [host] failed to pay prize pool [payout_amount] to [payout_target], trying refunds.")
	if(shop)
		for(var/paid_ckey in paid_snapshot)
			var/paid_amount = paid_snapshot[paid_ckey] || 0
			if(paid_amount <= 0)
				continue
			shop.add_metacoins(paid_ckey, paid_amount)

	announce(span_warning("Prize payout failed, entry fees were refunded when possible."))
	prize_pool = 0
	fees_paid = list()
