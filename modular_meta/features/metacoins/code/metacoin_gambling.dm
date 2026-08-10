#define METACOIN_SLOT_BASE_BET 5
#define METACOIN_SLOT_MIN_BET 5
#define METACOIN_SLOT_MAX_BET 100
#define METACOIN_SLOT_DEFAULT_BET 5
#define METACOIN_SLOT_BET_STEP 5
#define METACOIN_SLOT_PAYOUT_LINE3 20
#define METACOIN_SLOT_PAYOUT_LINE4 55
#define METACOIN_SLOT_PAYOUT_LINE5 150
#define METACOIN_SLOT_PAYOUT_JACKPOT 666
#define METACOIN_SLOT_COOLDOWN_DS 5
#define METACOIN_SLOT_JACKPOT_ICON FA_ICON_7

/datum/metacoinshop/slot
	var/datum/metacoin_shop_controller/shop
	var/list/lock_by_ckey = list()
	var/list/cooldown_by_ckey = list()

/datum/metacoinshop/slot/New(datum/metacoin_shop_controller/shop)
	src.shop = shop

/datum/metacoinshop/slot/proc/get_icons()
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

/datum/metacoinshop/slot/proc/roll_reels()
	var/list/icons = get_icons()
	var/list/reels = list()

	for(var/reel_index in 1 to 5)
		var/list/reel = list()
		for(var/row_index in 1 to 3)
			var/icon_name = pick(icons)
			reel += list(list(
				"icon_name" = icon_name,
				"colour" = icons[icon_name]["colour"] || "white",
			))

		reels += list(reel)

	return reels

/datum/metacoinshop/slot/proc/get_line(list/reels)
	var/best = 0

	for(var/row_index in 1 to 3)
		var/streak = 0
		var/last_icon

		for(var/reel_index in 1 to 5)
			var/icon = reels[reel_index][row_index]["icon_name"]
			if(icon == last_icon)
				streak++
			else
				streak = 1
				last_icon = icon

			best = max(best, streak)

	return best

/datum/metacoinshop/slot/proc/is_jackpot(list/reels)
	var/icon = "[METACOIN_SLOT_JACKPOT_ICON]"
	for(var/reel_index in 1 to 5)
		if(reels[reel_index][2]["icon_name"] != icon)
			return FALSE

	return TRUE

/datum/metacoinshop/slot/proc/get_base_win(line, jackpot)
	if(jackpot)
		return METACOIN_SLOT_PAYOUT_JACKPOT
	if(line >= 5)
		return METACOIN_SLOT_PAYOUT_LINE5
	if(line >= 4)
		return METACOIN_SLOT_PAYOUT_LINE4
	if(line >= 3)
		return METACOIN_SLOT_PAYOUT_LINE3
	return 0

/datum/metacoinshop/slot/proc/get_win(line, jackpot, bet)
	var/base = get_base_win(line, jackpot)
	if(base <= 0)
		return 0

	return round((base * bet) / METACOIN_SLOT_BASE_BET)

/datum/metacoinshop/slot/proc/apply_payout(ck, payout, balance)
	if(payout <= 0)
		return balance
	if(!shop.wallet.add_metacoins(ck, payout))
		return null
	return shop.wallet.fetch_balance(ck)

/datum/metacoinshop/slot/proc/normalize_bet(raw_bet)
	if(isnull(raw_bet))
		return METACOIN_SLOT_DEFAULT_BET
	if(istext(raw_bet))
		raw_bet = text2num(raw_bet)
	if(!isnum(raw_bet))
		return null

	var/bet = round(raw_bet)
	if(bet < METACOIN_SLOT_MIN_BET || bet > METACOIN_SLOT_MAX_BET)
		return null
	if((bet - METACOIN_SLOT_MIN_BET) % METACOIN_SLOT_BET_STEP)
		return null

	return bet

/datum/metacoinshop/slot/proc/get_cooldown(ck)
	ck = ckey(ck)
	if(!ck)
		return 0

	var/next = cooldown_by_ckey[ck] || 0
	if(next <= world.time)
		return 0

	return next - world.time

/datum/metacoinshop/slot/proc/unlock(ck)
	ck = ckey(ck)
	if(!ck)
		return

	lock_by_ckey -= ck

/datum/metacoinshop/slot/proc/send_announcement(mob/player, message, snd)
	if(QDELETED(player) || player.stat != DEAD || !player.client)
		return

	to_chat(player, message)
	if(player.client.prefs.read_preference(/datum/preference/toggle/sound_announcements))
		SEND_SOUND(player, sound(snd))

/datum/metacoinshop/slot/proc/announce_win(winner_name, payout, line, jackpot, atom/winner_source)
	if(!winner_name || payout <= 0)
		return

	var/announce_text
	var/announce_title
	var/announce_sound

	if(jackpot)
		announce_text = "[winner_name] hit the metacoin slot JACKPOT and won [payout] metacoins!"
		announce_title = "Metacoin Slot Jackpot"
		announce_sound = 'sound/machines/roulette/roulettejackpot.ogg'
	else if(line >= 5)
		announce_text = "[winner_name] won a huge metacoin slot payout: [payout] metacoins!"
		announce_title = "Metacoin Slot Big Win"
		announce_sound = 'sound/effects/kaching.ogg'
	else
		return

	var/title = html_encode(announce_title)
	var/text = html_encode(announce_text)
	var/announce_final = "<div class='chat_alert_default'><span class='announcement_header'><span class='minor_announcement_title'>[title]</span></span><span class='minor_announcement_text'>[text]</span></div>"

	for(var/mob/lobby_mob as anything in GLOB.new_player_list)
		if(isnewplayer(lobby_mob))
			send_announcement(lobby_mob, announce_final, announce_sound)

	for(var/mob/player_mob as anything in GLOB.player_list)
		if(isobserver(player_mob))
			send_announcement(player_mob, announce_final, announce_sound)

	if(isobserver(winner_source))
		notify_ghosts(
			message = "[title]: [text]",
			source = winner_source,
			header = announce_title
		)

/datum/metacoinshop/slot/proc/spin(ck, mob/user, raw_bet)
	ck = ckey(ck)
	if(!ck)
		return list("ok" = FALSE, "error" = "invalid_request")

	if(!shop.is_open() && !isobserver(user))
		return list("ok" = FALSE, "error" = "shop_closed")

	var/lock_until = lock_by_ckey[ck] || 0
	if(lock_until > world.time)
		return list("ok" = FALSE, "error" = "busy")
	if(lock_until)
		unlock(ck)

	var/cd = get_cooldown(ck)
	if(cd > 0)
		return list(
			"ok" = FALSE,
			"error" = "cooldown",
			"cooldownLeftDs" = cd,
		)

	var/bet = normalize_bet(raw_bet)
	if(isnull(bet))
		return list("ok" = FALSE, "error" = "invalid_bet")

	lock_by_ckey[ck] = world.time + 40

	var/list/take = shop.wallet.take_metacoins(ck, bet)
	if(!take["ok"])
		unlock(ck)
		return take

	cooldown_by_ckey[ck] = world.time + METACOIN_SLOT_COOLDOWN_DS

	var/list/reels = roll_reels()
	var/line = get_line(reels)
	var/jackpot = is_jackpot(reels)
	var/payout = get_win(line, jackpot, bet)

	var/end_balance = apply_payout(ck, payout, take["balance"])
	if(isnull(end_balance))
		unlock(ck)
		return list("ok" = FALSE, "error" = "db_failed")

	addtimer(CALLBACK(src, PROC_REF(unlock), ck), 40)
	return list(
		"ok" = TRUE,
		"reels" = reels,
		"lineLength" = line,
		"isJackpot" = jackpot,
		"payout" = payout,
		"bet" = bet,
		"balance" = end_balance,
		"cooldownLeftDs" = get_cooldown(ck),
	)

/datum/metacoinshop/panel/slot
	interface_id = "MetaCoinSlot"
	var/datum/metacoinshop/slot/machine
	var/list/reels = list()
	var/working = FALSE
	var/balance = 0
	var/list/last = list()
	var/list/history = list()

/datum/metacoinshop/panel/slot/New(client/owner, mob/viewer)
	machine = get_metacoin_controller().slot
	reels = machine.roll_reels()
	last = list(
		"bet" = METACOIN_SLOT_DEFAULT_BET,
		"lineLength" = 0,
		"payout" = 0,
		"isJackpot" = FALSE,
		"net" = 0,
		"resultState" = "idle",
	)
	history = list()
	balance = get_metacoins_controller().fetch_balance(owner?.ckey)
	if(isnull(balance))
		balance = 0
	..(owner, viewer)

/datum/metacoinshop/panel/slot/ui_static_data(mob/user)
	var/list/data = list()

	data["icons"] = list()
	var/list/icons = machine.get_icons()
	for(var/icon_name in icons)
		var/list/icon_info = icons[icon_name]
		data["icons"] += list(list(
			"icon_name" = icon_name,
			"colour" = icon_info["colour"],
		))

	data["baseBet"] = METACOIN_SLOT_BASE_BET
	data["defaultBet"] = METACOIN_SLOT_DEFAULT_BET
	data["minBet"] = METACOIN_SLOT_MIN_BET
	data["maxBet"] = METACOIN_SLOT_MAX_BET
	data["betStep"] = METACOIN_SLOT_BET_STEP
	data["quickBets"] = list(5, 10, 25, 50)
	data["payoutLine3"] = METACOIN_SLOT_PAYOUT_LINE3
	data["payoutLine4"] = METACOIN_SLOT_PAYOUT_LINE4
	data["payoutLine5"] = METACOIN_SLOT_PAYOUT_LINE5
	data["payoutJackpot"] = METACOIN_SLOT_PAYOUT_JACKPOT

	return data

/datum/metacoinshop/panel/slot/ui_data(mob/user)
	var/list/data = list()
	var/client_ckey = owner?.ckey

	if(!working)
		var/live = machine.shop.wallet.fetch_balance(client_ckey)
		if(!isnull(live))
			balance = live

	data["isPregame"] = machine.shop.is_open()
	data["isObserver"] = isobserver(user)
	data["working"] = working
	data["balance"] = balance
	data["state"] = reels
	data["lastSpin"] = last
	data["history"] = history.Copy()
	data["cooldownLeftDs"] = machine.get_cooldown(client_ckey)

	return data

/datum/metacoinshop/panel/slot/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "spin")
		if(working)
			return FALSE

		working = TRUE
		var/mob/user_mob = ui?.user

		var/list/result = machine.spin(owner?.ckey, user_mob, params?["bet"])

		if(!result["ok"])
			show_error(user_mob, result)
			working = FALSE
			return FALSE

		reels = result["reels"]
		var/datum/weakref/user_ref = user_mob ? WEAKREF(user_mob) : null
		play_spin_sound(user_ref, 'sound/machines/lever/lever_start.ogg', 45)
		addtimer(CALLBACK(src, PROC_REF(play_spin_sound), user_ref, 'sound/machines/roulette/roulettewheel.ogg', 20), 3)
		addtimer(CALLBACK(src, PROC_REF(finish_spin), result, user_ref), 40)
		SStgui.update_uis(src)
		return TRUE

	return FALSE

/datum/metacoinshop/panel/slot/proc/show_error(mob/user, list/result)
	var/static/list/error_messages = list(
		"shop_closed" = "Metacoin slot machine is available only for ghosts and in pre-game lobby.",
		"invalid_bet" = "Invalid bet selected.",
		"not_enough" = "Not enough metacoins for a spin.",
		"busy" = "Spin is already being processed.",
		"db_unavailable" = "Database error. Try again later.",
		"db_failed" = "Database error. Try again later.",
	)
	if(!user)
		return

	var/error = result["error"]
	var/message = error_messages[error] || "Spin failed."
	if(error == "cooldown")
		message = "Spin cooldown active: [round((result["cooldownLeftDs"] || 0) / 10, 0.1)]s left."

	to_chat(user, span_warning(message))
	user.playsound_local(user, 'sound/machines/compiler/compiler-failure.ogg', 40, TRUE, use_reverb = FALSE)

/datum/metacoinshop/panel/slot/proc/play_spin_sound(datum/weakref/user_ref, snd, volume)
	var/mob/user_mob = user_ref?.resolve()
	if(!user_mob)
		return

	user_mob.playsound_local(user_mob, snd, volume, TRUE, use_reverb = FALSE)

/datum/metacoinshop/panel/slot/proc/finish_spin(list/result, datum/weakref/user_ref)
	var/mob/user_mob = user_ref?.resolve() || owner?.mob

	var/payout = result["payout"] || 0
	var/bet = result["bet"] || METACOIN_SLOT_DEFAULT_BET
	var/line = result["lineLength"] || 0
	var/jackpot_hit = !!result["isJackpot"]
	var/net_amount = payout - bet
	var/state = payout > 0 ? "win" : "loss"
	if(jackpot_hit)
		state = "jackpot"

	if(!isnull(result["balance"]))
		balance = result["balance"] || 0

	last = list(
		"bet" = bet,
		"lineLength" = line,
		"payout" = payout,
		"isJackpot" = jackpot_hit,
		"net" = net_amount,
		"resultState" = state,
	)

	history = list(list(
		"time" = time2text(world.realtime, "hh:mm:ss"),
		"bet" = bet,
		"lineLength" = line,
		"payout" = payout,
		"net" = net_amount,
		"isJackpot" = jackpot_hit,
	)) + history
	if(length(history) > 5)
		history.Cut(6)

	if(jackpot_hit || line >= 5)
		machine.announce_win(user_mob?.real_name || owner?.ckey || "Unknown", payout, line, jackpot_hit, user_mob)

	if(user_mob)
		if(jackpot_hit)
			to_chat(user_mob, span_boldnicegreen("JACKPOT! You won [payout] metacoins."))
			user_mob.playsound_local(user_mob, 'sound/machines/roulette/roulettejackpot.ogg', 45, TRUE, use_reverb = FALSE)
		else if(payout > 0)
			to_chat(user_mob, span_boldnicegreen("You won [payout] metacoins."))
			user_mob.playsound_local(user_mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE)
		else
			to_chat(user_mob, span_warning("No luck this spin."))
			user_mob.playsound_local(user_mob, 'sound/machines/buzz/buzz-sigh.ogg', 10, TRUE, use_reverb = FALSE)

	working = FALSE
	SStgui.update_uis(src)
	if(user_mob)
		SStgui.update_user_uis(user_mob)

#undef METACOIN_SLOT_BASE_BET
#undef METACOIN_SLOT_MIN_BET
#undef METACOIN_SLOT_MAX_BET
#undef METACOIN_SLOT_DEFAULT_BET
#undef METACOIN_SLOT_BET_STEP
#undef METACOIN_SLOT_PAYOUT_LINE3
#undef METACOIN_SLOT_PAYOUT_LINE4
#undef METACOIN_SLOT_PAYOUT_LINE5
#undef METACOIN_SLOT_PAYOUT_JACKPOT
#undef METACOIN_SLOT_COOLDOWN_DS
#undef METACOIN_SLOT_JACKPOT_ICON
