/datum/deathmatch_controller
	/// Assoc list of all lobbies (ckey = lobby)
	var/list/datum/deathmatch_lobby/lobbies = list()
	/// All deathmatch map templates
	var/list/datum/lazy_template/deathmatch/maps = list()
	/// All loadouts
	var/list/datum/outfit/loadouts
	/// All modifiers
	var/list/datum/deathmatch_modifier/modifiers

/datum/deathmatch_controller/New()
	. = ..()
	if (GLOB.deathmatch_game)
		qdel(src)
		CRASH("A deathmatch controller already exists.")
	GLOB.deathmatch_game = src

	for (var/datum/lazy_template/deathmatch/template as anything in subtypesof(/datum/lazy_template/deathmatch))
		var/map_name = initial(template.name)
		maps[map_name] = new template
	loadouts = subtypesof(/datum/outfit/deathmatch_loadout)
	modifiers = sortTim(init_subtypes_w_path_keys(/datum/deathmatch_modifier), GLOBAL_PROC_REF(cmp_deathmatch_mods), associative = TRUE)

//MASSMETA EDIT CHANGE START (metacoins)
/*
	ORIGINAL:
/datum/deathmatch_controller/proc/create_new_lobby(mob/host)
	lobbies[host.ckey] = new /datum/deathmatch_lobby(host)
	deadchat_broadcast(" has opened a new deathmatch lobby. <a href=byond://?src=[REF(lobbies[host.ckey])];join=1>(Join)</a>", "<B>[host]</B>")
*/
/datum/deathmatch_controller/proc/create_new_lobby(mob/host, entry_fee = 0)
	if(!host?.ckey)
		return list("ok" = FALSE, "error" = "invalid_host")

	entry_fee = min(max(round(text2num("[entry_fee]") || 0), 0), 1000)

	if(entry_fee > 0)
		var/datum/metacoin_shop_controller/shop = get_metacoin_shop_controller()
		if(!shop)
			return list("ok" = FALSE, "error" = "shop_unavailable")

		var/current_balance = shop.fetch_metacoin_balance(host.ckey)
		if(isnull(current_balance))
			return list("ok" = FALSE, "error" = "db_unavailable")
		if(current_balance < entry_fee)
			return list("ok" = FALSE, "error" = "not_enough")

	var/datum/deathmatch_lobby/new_lobby = new /datum/deathmatch_lobby(host, entry_fee)
	if(QDELETED(new_lobby) || !(host.ckey in new_lobby.players))
		return list("ok" = FALSE, "error" = "create_failed")

	lobbies[host.ckey] = new_lobby
	deadchat_broadcast(" has opened a new deathmatch lobby. <a href=byond://?src=[REF(new_lobby)];join=1>(Join)</a>", "<B>[host]</B>")
	return list("ok" = TRUE)
//MASSMETA EDIT CHANGE START (metacoins)

/datum/deathmatch_controller/proc/remove_lobby(ckey)
	var/lobby = lobbies[ckey]
	lobbies[ckey] = null
	lobbies.Remove(ckey)
	qdel(lobby)

/datum/deathmatch_controller/proc/passoff_lobby(host, new_host)
	lobbies[new_host] = lobbies[host]
	lobbies[host] = null
	lobbies.Remove(host)

/datum/deathmatch_controller/ui_state(mob/user)
	return GLOB.observer_state

/datum/deathmatch_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "DeathmatchPanel")
		ui.open()

/datum/deathmatch_controller/ui_data(mob/user)
	. = ..()
	.["lobbies"] = list()
	.["hosting"] = FALSE
	.["admin"] = check_rights_for(user.client, R_ADMIN)
	for (var/ckey in lobbies)
		var/datum/deathmatch_lobby/lobby = lobbies[ckey]
		if (user.ckey == ckey)
			.["hosting"] = TRUE
		if (user.ckey in (lobby.observers+lobby.players))
			.["playing"] = ckey
		.["lobbies"] += list(list(
			name = ckey,
			players = lobby.players.len,
			max_players = initial(lobby.map.max_players),
			map = initial(lobby.map.name),
			// MASSMETA EDIT ADDITION START (metacoins)
			playing = lobby.playing,
			entry_fee = lobby.entry_fee,
			prize_pool = lobby.prize_pool,
			// MASSMETA EDIT ADDITION END (metacoins)
		))

/datum/deathmatch_controller/proc/find_lobby_by_user(ckey)
	for(var/lobbykey in lobbies)
		var/datum/deathmatch_lobby/lobby = lobbies[lobbykey]
		if(ckey in (lobby.players+lobby.observers))
			return lobby
// MASSMETA EDIT ADDITION START (metacoins)
/datum/deathmatch_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || !isobserver(usr))
		return
	switch (action)
		if ("host")
			if(!(GLOB.ghost_role_flags & GHOSTROLE_MINIGAME))
				tgui_alert(usr, "Deathmatch has been temporarily disabled by admins.")
				return
			if (lobbies[usr.ckey])
				return
			if(!SSticker.HasRoundStarted())
				tgui_alert(usr, "The round hasn't started yet!")
				return

			var/entry_fee = min(max(round(text2num(params["entry_fee"]) || 0), 0), 1000)
			var/list/create_result = create_new_lobby(usr, entry_fee)
			if(!create_result["ok"])
				switch(create_result["error"])
					if("not_enough")
						tgui_alert(usr, "Not enough metacoins for selected entry fee.")
					if("shop_unavailable", "db_unavailable")
						tgui_alert(usr, "Metacoin subsystem is unavailable right now.")
					else
						tgui_alert(usr, "Failed to create lobby.")
				return

			ui.close()
// MASSMETA EDIT ADDITION END (metacoins)
		if ("join")
			if(!(GLOB.ghost_role_flags & GHOSTROLE_MINIGAME))
				tgui_alert(usr, "Deathmatch has been temporarily disabled by admins.")
				return
			if (!lobbies[params["id"]])
				return
			var/datum/deathmatch_lobby/playing_lobby = find_lobby_by_user(usr.ckey)
			var/datum/deathmatch_lobby/chosen_lobby = lobbies[params["id"]]
			if (!isnull(playing_lobby) && playing_lobby != chosen_lobby)
				playing_lobby.leave(usr.ckey)

			if(isnull(playing_lobby))
				log_game("[usr.ckey] joined deathmatch lobby [params["id"]] as a player.")
				chosen_lobby.join(usr)

			chosen_lobby.ui_interact(usr)

		if ("spectate")
			var/datum/deathmatch_lobby/playing_lobby = find_lobby_by_user(usr.ckey)
			if (!lobbies[params["id"]])
				return
			var/datum/deathmatch_lobby/chosen_lobby = lobbies[params["id"]]
			// if the player is in this lobby
			if(!isnull(playing_lobby) && playing_lobby != chosen_lobby)
				playing_lobby.leave(usr.ckey)
			else if(playing_lobby == chosen_lobby)
				chosen_lobby.ui_interact(usr)
				return
			// they werent in the lobby, lets add them
			if (!chosen_lobby.playing)
				chosen_lobby.add_observer(usr)
				chosen_lobby.ui_interact(usr)
			else
				chosen_lobby.spectate(usr)
			log_game("[usr.ckey] joined deathmatch lobby [params["id"]] as an observer.")

		if ("admin")
			if (!check_rights(R_ADMIN))
				message_admins("[usr.key] has attempted to use admin functions in the deathmatch panel!")
				log_admin("[key_name(usr)] tried to use the deathmatch panel admin functions without authorization.")
				return
			var/lobby = params["id"]
			switch (params["func"])
				if ("Close")
					remove_lobby(lobby)
					log_admin("[key_name(usr)] removed deathmatch lobby [lobby].")
				if ("View")
					lobbies[lobby].ui_interact(usr)
