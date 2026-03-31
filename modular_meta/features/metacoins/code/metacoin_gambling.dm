#define METACOIN_SLOT_SPIN_COST 5
#define METACOIN_SLOT_PAYOUT_LINE3 15
#define METACOIN_SLOT_PAYOUT_LINE4 50
#define METACOIN_SLOT_PAYOUT_LINE5 150
#define METACOIN_SLOT_PAYOUT_JACKPOT 1000
#define METACOIN_SLOT_COOLDOWN_DS 5
#define METACOIN_SLOT_JACKPOT_ICON FA_ICON_7

/datum/metacoin_shop_controller
	var/list/slot_spin_locks_by_ckey = list()
	var/list/slot_next_spin_time_by_ckey = list()

/datum/metacoin_shop_controller/proc/get_slot_icons_catalog()
	var/static/list/slot_icons = list(
		FA_ICON_LEMON = list("colour" = "yellow"),
		FA_ICON_STAR = list("colour" = "yellow"),
		FA_ICON_BOMB = list("colour" = "red"),
		FA_ICON_BIOHAZARD = list("colour" = "green"),
		FA_ICON_APPLE_WHOLE = list("colour" = "red"),
		FA_ICON_7 = list("colour" = "yellow"),
		FA_ICON_DOLLAR_SIGN = list("colour" = "green"),
	)
	return slot_icons

/datum/metacoin_shop_controller/proc/roll_slot_reels()
	var/list/icons_catalog = get_slot_icons_catalog()
	var/list/reels = list()

	for(var/reel_index in 1 to 5)
		var/list/reel = list()
		for(var/row_index in 1 to 3)
			var/chosen_icon_name = pick(icons_catalog)
			var/list/icon_data = icons_catalog[chosen_icon_name]
			reel += list(list(
				"icon_name" = chosen_icon_name,
				"colour" = icon_data["colour"] || "white",
			))

		reels += list(reel)

	return reels

/datum/metacoin_shop_controller/proc/get_slot_longest_line(list/reels)
	if(!islist(reels) || length(reels) < 5)
		return 0

	var/best_line = 0

	for(var/row_index in 1 to 3)
		var/current_streak = 0
		var/last_icon_name

		for(var/reel_index in 1 to 5)
			var/list/reel = reels[reel_index]
			if(!islist(reel) || length(reel) < row_index)
				current_streak = 0
				last_icon_name = null
				continue

			var/list/symbol = reel[row_index]
			var/icon_name = symbol?["icon_name"]
			if(isnull(icon_name))
				current_streak = 0
				last_icon_name = null
				continue

			if(icon_name == last_icon_name)
				current_streak++
			else
				current_streak = 1
				last_icon_name = icon_name

			best_line = max(best_line, current_streak)

	return best_line

/datum/metacoin_shop_controller/proc/is_slot_jackpot(list/reels)
	if(!islist(reels) || length(reels) < 5)
		return FALSE

	var/jackpot_icon_name = "[METACOIN_SLOT_JACKPOT_ICON]"
	for(var/reel_index in 1 to 5)
		var/list/reel = reels[reel_index]
		if(!islist(reel) || length(reel) < 2)
			return FALSE

		var/list/symbol = reel[2]
		if(symbol?["icon_name"] != jackpot_icon_name)
			return FALSE

	return TRUE

/datum/metacoin_shop_controller/proc/get_slot_payout(line_length, is_jackpot)
	if(is_jackpot)
		return METACOIN_SLOT_PAYOUT_JACKPOT
	if(line_length >= 5)
		return METACOIN_SLOT_PAYOUT_LINE5
	if(line_length >= 4)
		return METACOIN_SLOT_PAYOUT_LINE4
	if(line_length >= 3)
		return METACOIN_SLOT_PAYOUT_LINE3
	return 0

/datum/metacoin_shop_controller/proc/get_slot_cooldown_left_ds(target_ckey)
	target_ckey = ckey(target_ckey)
	if(!target_ckey)
		return 0

	var/next_spin_time = text2num(slot_next_spin_time_by_ckey[target_ckey]) || 0
	if(next_spin_time <= world.time)
		return 0

	return max(next_spin_time - world.time, 0)

/datum/metacoin_shop_controller/proc/announce_slot_big_win(winner_name, payout_amount, jackpot_hit)
	if(!winner_name || payout_amount <= 0)
		return
//priority announce might be too much actually.. who cares though?
	if(jackpot_hit)
		priority_announce(
			text = "[winner_name] hit the metacoin slot JACKPOT and won [payout_amount] metacoins!",
			title = "Metacoin Slot Jackpot",
			sound = 'sound/machines/roulette/roulettejackpot.ogg',
			has_important_message = TRUE,
		)
		return

	if(payout_amount >= METACOIN_SLOT_PAYOUT_LINE5)
		priority_announce(
			text = "[winner_name] won a huge metacoin slot payout: [payout_amount] metacoins!",
			title = "Metacoin Slot Big Win",
			sound = 'sound/effects/kaching.ogg',
		)

/datum/metacoin_shop_controller/proc/try_slot_spin(target_ckey, mob/request_user)
	target_ckey = ckey(target_ckey)
	if(!target_ckey)
		return list("ok" = FALSE, "error" = "invalid_request")

	if(!is_preround_purchase_open() && !isobserver(request_user))
		return list("ok" = FALSE, "error" = "shop_closed")

	if(slot_spin_locks_by_ckey[target_ckey])
		return list("ok" = FALSE, "error" = "busy")

	if(!SSdbcore.Connect())
		return list("ok" = FALSE, "error" = "db_unavailable")

	var/cooldown_left_ds = get_slot_cooldown_left_ds(target_ckey)
	if(cooldown_left_ds > 0)
		return list(
			"ok" = FALSE,
			"error" = "cooldown",
			"cooldownLeftDs" = cooldown_left_ds,
		)

	slot_spin_locks_by_ckey[target_ckey] = TRUE

	var/list/result = list("ok" = FALSE, "error" = "unknown")

	var/current_balance = fetch_metacoin_balance(target_ckey)
	if(isnull(current_balance))
		result["error"] = "db_unavailable"
		slot_spin_locks_by_ckey -= target_ckey
		return result

	if(current_balance < METACOIN_SLOT_SPIN_COST)
		result["error"] = "not_enough"
		slot_spin_locks_by_ckey -= target_ckey
		return result

	var/table_player = format_table_name("player")
	var/datum/db_query/debit_query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins - :price WHERE ckey = :ckey AND metacoins >= :price",
		list(
			"price" = METACOIN_SLOT_SPIN_COST,
			"ckey" = target_ckey,
		),
	)

	if(!debit_query.warn_execute(async = FALSE))
		qdel(debit_query)
		result["error"] = "db_failed"
		slot_spin_locks_by_ckey -= target_ckey
		return result
	qdel(debit_query)

	var/post_debit_balance = fetch_metacoin_balance(target_ckey)
	if(isnull(post_debit_balance))
		result["error"] = "db_failed"
		slot_spin_locks_by_ckey -= target_ckey
		return result

	if(post_debit_balance > (current_balance - METACOIN_SLOT_SPIN_COST))
		result["error"] = "not_enough"
		slot_spin_locks_by_ckey -= target_ckey
		return result

	slot_next_spin_time_by_ckey[target_ckey] = world.time + METACOIN_SLOT_COOLDOWN_DS

	var/list/reels = roll_slot_reels()
	var/line_length = get_slot_longest_line(reels)
	var/is_jackpot = is_slot_jackpot(reels)
	var/payout = get_slot_payout(line_length, is_jackpot)

	if(payout > 0)
		var/datum/db_query/payout_query = SSdbcore.NewQuery(
			"UPDATE [table_player] SET metacoins = metacoins + :amount WHERE ckey = :ckey",
			list(
				"amount" = payout,
				"ckey" = target_ckey,
			),
		)

		if(!payout_query.warn_execute(async = FALSE))
			qdel(payout_query)
			result["error"] = "db_failed"
			slot_spin_locks_by_ckey -= target_ckey
			return result
		qdel(payout_query)

	var/final_balance = fetch_metacoin_balance(target_ckey)
	if(isnull(final_balance))
		result["error"] = "db_failed"
		slot_spin_locks_by_ckey -= target_ckey
		return result

	result = list(
		"ok" = TRUE,
		"reels" = reels,
		"lineLength" = line_length,
		"isJackpot" = is_jackpot,
		"payout" = payout,
		"cost" = METACOIN_SLOT_SPIN_COST,
		"balance" = final_balance,
		"cooldownLeftDs" = get_slot_cooldown_left_ds(target_ckey),
	)

	slot_spin_locks_by_ckey -= target_ckey
	return result

/datum/metacoin_slot_panel
	var/client/owner
	var/list/current_reels = list()
	var/working = FALSE
	var/list/last_spin = list()
	var/list/spin_history = list()

/datum/metacoin_slot_panel/New(client/owner, mob/viewer)
	src.owner = owner
	current_reels = get_metacoin_shop_controller().roll_slot_reels()
	last_spin = list(
		"lineLength" = 0,
		"payout" = 0,
		"isJackpot" = FALSE,
		"net" = 0,
		"resultState" = "idle",
	)
	spin_history = list()
	ui_interact(viewer)

/datum/metacoin_slot_panel/ui_state()
	return GLOB.always_state

/datum/metacoin_slot_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MetaCoinSlot")
		ui.open()

/datum/metacoin_slot_panel/ui_static_data(mob/user)
	var/list/data = list()

	data["icons"] = list()
	var/list/icons_catalog = get_metacoin_shop_controller().get_slot_icons_catalog()
	for(var/icon_name in icons_catalog)
		var/list/icon_info = icons_catalog[icon_name]
		data["icons"] += list(list(
			"icon_name" = icon_name,
			"colour" = icon_info["colour"],
		))

	data["cost"] = METACOIN_SLOT_SPIN_COST
	data["payoutLine3"] = METACOIN_SLOT_PAYOUT_LINE3
	data["payoutLine4"] = METACOIN_SLOT_PAYOUT_LINE4
	data["payoutLine5"] = METACOIN_SLOT_PAYOUT_LINE5
	data["payoutJackpot"] = METACOIN_SLOT_PAYOUT_JACKPOT

	return data

/datum/metacoin_slot_panel/ui_data(mob/user)
	var/list/data = list()
	var/datum/metacoin_shop_controller/shop = get_metacoin_shop_controller()
	var/client_ckey = owner?.ckey
	var/balance = shop.fetch_metacoin_balance(client_ckey)

	data["isPregame"] = shop.is_preround_purchase_open()
	data["isObserver"] = isobserver(user)
	data["working"] = working
	data["balance"] = isnull(balance) ? 0 : balance
	data["state"] = current_reels
	data["lastSpin"] = last_spin
	data["history"] = spin_history.Copy()
	data["cooldownLeftDs"] = shop.get_slot_cooldown_left_ds(client_ckey)

	return data

/datum/metacoin_slot_panel/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "spin")
		if(working)
			return FALSE

		working = TRUE
		var/mob/user_mob = ui?.user

		var/list/result = get_metacoin_shop_controller().try_slot_spin(owner?.ckey, user_mob)

		if(!result["ok"])
			if(user_mob)
				var/cooldown_seconds = (text2num(result["cooldownLeftDs"]) || 0) / 10
				switch(result["error"])
					if("shop_closed")
						to_chat(user_mob, span_warning("Metacoin slot machine is available only before round start."))
					if("not_enough")
						to_chat(user_mob, span_warning("Not enough metacoins for a spin."))
					if("cooldown")
						to_chat(user_mob, span_warning("Spin cooldown active: [round(cooldown_seconds, 0.1)]s left."))
					if("busy")
						to_chat(user_mob, span_warning("Spin is already being processed."))
					if("db_unavailable", "db_failed")
						to_chat(user_mob, span_warning("Database error. Try again later."))
					else
						to_chat(user_mob, span_warning("Spin failed."))

				user_mob.playsound_local(user_mob, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)

			working = FALSE
			return FALSE

		var/datum/weakref/user_ref = user_mob ? WEAKREF(user_mob) : null
		addtimer(CALLBACK(src, PROC_REF(finish_spin), result, user_ref), 10)
		SStgui.update_uis(src)
		return TRUE

	return FALSE

/datum/metacoin_slot_panel/proc/finish_spin(list/result, datum/weakref/user_ref)
	if(!islist(result))
		working = FALSE
		SStgui.update_uis(src)
		return

	var/mob/user_mob = user_ref?.resolve() || owner?.mob

	current_reels = result["reels"]
	var/payout_amount = text2num(result["payout"]) || 0
	var/spin_cost = text2num(result["cost"]) || METACOIN_SLOT_SPIN_COST
	var/line_length = text2num(result["lineLength"]) || 0
	var/jackpot_hit = !!result["isJackpot"]
	var/net_amount = payout_amount - spin_cost
	var/result_state = payout_amount > 0 ? "win" : "loss"
	if(jackpot_hit)
		result_state = "jackpot"

	last_spin = list(
		"lineLength" = line_length,
		"payout" = payout_amount,
		"isJackpot" = jackpot_hit,
		"net" = net_amount,
		"resultState" = result_state,
	)

	var/list/history_entry = list(
		"time" = time2text(world.realtime, "hh:mm:ss"),
		"lineLength" = line_length,
		"payout" = payout_amount,
		"net" = net_amount,
		"isJackpot" = jackpot_hit,
	)
	spin_history = list(history_entry) + spin_history
	if(length(spin_history) > 5)
		spin_history.Cut(6)

	if(payout_amount >= METACOIN_SLOT_PAYOUT_LINE5)
		var/winner_name = user_mob?.real_name || owner?.ckey || "Unknown"
		get_metacoin_shop_controller().announce_slot_big_win(winner_name, payout_amount, jackpot_hit)

	if(user_mob)
		if(jackpot_hit)
			to_chat(user_mob, span_boldnicegreen("JACKPOT! You won [payout_amount] metacoins."))
			user_mob.playsound_local(user_mob, 'sound/machines/roulette/roulettejackpot.ogg', 45, TRUE, use_reverb = FALSE)
		else if(payout_amount > 0)
			to_chat(user_mob, span_boldnicegreen("You won [payout_amount] metacoins."))
			user_mob.playsound_local(user_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
		else
			to_chat(user_mob, span_warning("No luck this spin."))
			user_mob.playsound_local(user_mob, 'sound/machines/buzz/buzz-sigh.ogg', 10, TRUE, use_reverb = FALSE)

	working = FALSE
	SStgui.update_uis(src)
	if(user_mob)
		SStgui.update_user_uis(user_mob)

#undef METACOIN_SLOT_SPIN_COST
#undef METACOIN_SLOT_PAYOUT_LINE3
#undef METACOIN_SLOT_PAYOUT_LINE4
#undef METACOIN_SLOT_PAYOUT_LINE5
#undef METACOIN_SLOT_PAYOUT_JACKPOT
#undef METACOIN_SLOT_COOLDOWN_DS
#undef METACOIN_SLOT_JACKPOT_ICON
