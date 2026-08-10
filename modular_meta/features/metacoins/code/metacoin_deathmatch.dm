/// Tries to charge the player for current entry fee before adding them to players list.
/datum/deathmatch_lobby/proc/pay_fee(mob/player)
	if(!player?.ckey)
		return FALSE

	var/already_paid = fees_paid[player.ckey] || 0
	if(entry_fee <= already_paid)
		return TRUE

	var/to_pay = entry_fee - already_paid
	var/list/take_result = get_metacoins_controller().take_metacoins(player.ckey, to_pay)
	if(!take_result["ok"])
		var/static/list/error_messages = list(
			"db_unavailable" = "Metacoin database is unavailable.",
			"db_failed" = "Metacoin database is unavailable.",
		)
		var/error = take_result["error"]
		var/message = error_messages[error] || "Failed to pay lobby entry fee."
		if(error == "not_enough")
			message = "Not enough metacoins for entry fee ([entry_fee])."
		to_chat(player, span_warning(message))
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

	if(!get_metacoins_controller().add_metacoins(target_ckey, paid_amount))
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
	var/datum/metacoins_controller/wallet = get_metacoins_controller()

	if(winner_ckey && wallet.add_metacoins(winner_ckey, payout_amount))
		announce(span_boldnicegreen("[winner ? winner.real_name : winner_ckey] received [payout_amount] metacoins from the prize pool."))
		if(winner)
			to_chat(winner, span_boldnicegreen("You won [payout_amount] metacoins from this deathmatch prize pool."))
		prize_pool = 0
		fees_paid = list()
		return

	for(var/paid_ckey in paid_snapshot)
		var/paid_amount = paid_snapshot[paid_ckey] || 0
		if(paid_amount <= 0)
			continue
		wallet.add_metacoins(paid_ckey, paid_amount)

	announce(span_warning("Prize payout failed, entry fees were refunded when possible."))
	prize_pool = 0
	fees_paid = list()
