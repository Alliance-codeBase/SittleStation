//Various topics, various info fetch from DB, many not yet implemented in bot, though might still find use later.

/datum/world_topic/bans
	keyword = "bans"
	require_comms_key = TRUE

/datum/world_topic/bans/Run(list/input)
	log_world("Bans: bans topic called")
	var/target_ckey = input["bans"]
	log_world("Bans: target_ckey: [target_ckey]")
	var/bans_list = list()

	if(!SSdbcore.Connect())
		log_world("Bans: Database connection failed")
		return list("bans" = list())

	var/datum/db_query/query_bans
	if(target_ckey)
		query_bans = SSdbcore.NewQuery({"
			SELECT
				id,
				bantime,
				round_id,
				expiration_time,
				TIMESTAMPDIFF(MINUTE, bantime, expiration_time) as duration,
				applies_to_admins,
				reason,
				IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].ckey), ckey) as player_name,
				IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].a_ckey), a_ckey) as admin_name,
				a_ckey as admin_ckey
			FROM [format_table_name("ban")]
			WHERE ckey = :ckey
				AND unbanned_datetime IS NULL
				AND (expiration_time IS NULL OR expiration_time > NOW())
			ORDER BY bantime DESC
		"}, list("ckey" = ckey(target_ckey)))
	else
		query_bans = SSdbcore.NewQuery({"
			SELECT
				id,
				bantime,
				round_id,
				expiration_time,
				TIMESTAMPDIFF(MINUTE, bantime, expiration_time) as duration,
				applies_to_admins,
				reason,
				IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].ckey), ckey) as player_name,
				IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].a_ckey), a_ckey) as admin_name,
				a_ckey as admin_ckey
			FROM [format_table_name("ban")]
			WHERE unbanned_datetime IS NULL
				AND (expiration_time IS NULL OR expiration_time > NOW())
			ORDER BY bantime DESC
			LIMIT 100
		"}, list())

	if(!query_bans.warn_execute())
		log_world("Bans: Query execution failed")
		qdel(query_bans)
		return list("bans" = list())

	while(query_bans.NextRow())
		var/ban_data = list(
			"type" = "ban",
			"name" = query_bans.item["player_name"] || query_bans.item["ckey"],
			"ckey" = query_bans.item["ckey"],
			"admin_name" = query_bans.item["admin_name"] || query_bans.item["admin_ckey"],
			"admin" = query_bans.item["admin_ckey"],
			"timestamp" = query_bans.item["bantime"],
			"duration" = text2num(query_bans.item["duration"]),
			"reason" = query_bans.item["reason"]
		)
		bans_list += list(ban_data)

	qdel(query_bans)
	log_world("Bans: Found [length(bans_list)] bans")
	var/json_result = json_encode(list("bans" = bans_list))
	log_world("Bans: Returning JSON: [json_result]")
	return json_result

/datum/world_topic/bot_events
	keyword = "bot_events"
	require_comms_key = TRUE

/datum/world_topic/bot_events/Run(list/input)
	log_world("Bot Events: bot_events topic called")

	if(!GLOB.bot_event_sending_que)
		GLOB.bot_event_sending_que = list()
		log_world("Bot Events: GLOB.bot_event_sending_que was null, initialized empty list")
		return json_encode(list("events" = list(), "last_index" = 0))

	log_world("Bot Events: Queue length before copy: [length(GLOB.bot_event_sending_que)]")

	// Copy and clear the queue (same pattern as OOC)
	var/events_list = GLOB.bot_event_sending_que.Copy()
	GLOB.bot_event_sending_que = list()

	log_world("Bot Events: Copied [length(events_list)] events, queue cleared")

	var/json_result = json_encode(list("events" = events_list, "last_index" = length(events_list)))
	log_world("Bot Events: Returning JSON with [length(events_list)] events")

	return json_result

/datum/world_topic/playerinfo
	keyword = "playerinfo"
	require_comms_key = TRUE

/datum/world_topic/playerinfo/Run(list/input)
	var/target_ckey = ckey(input["playerinfo"])

	if(!target_ckey)
		return list("error" = "No ckey provided")

	if(!SSdbcore.Connect())
		return list("error" = "Database connection failed")

	var/player_data = list("ckey" = target_ckey)

	var/datum/db_query/query_player = SSdbcore.NewQuery({"
		SELECT
			firstseen,
			lastseen
		FROM [format_table_name("player")]
		WHERE ckey = :ckey
		LIMIT 1
	"}, list("ckey" = target_ckey))

	if(!query_player.warn_execute())
		qdel(query_player)
		return list("error" = "Query failed")

	if(query_player.NextRow())
		// item is a list, not an associative list - use indexes
		player_data["first_seen"] = query_player.item[1]
		player_data["last_seen"] = query_player.item[2]
	else
		qdel(query_player)
		return list("error" = "Player not found")

	qdel(query_player)

	// Get total playtime from role_time - sum on BYOND side instead of SQL
	//Otherwise throws nulls for whatever reason, duh..
	var/datum/db_query/query_playtime = SSdbcore.NewQuery({"
		SELECT minutes
		FROM [format_table_name("role_time")]
		WHERE ckey = :ckey
		AND job NOT IN ('Living')
	"}, list("ckey" = target_ckey))

	var/total_minutes = 0
	if(query_playtime.warn_execute())
		while(query_playtime.NextRow())
			var/minutes = text2num(query_playtime.item[1]) || 0
			total_minutes += minutes
		player_data["playtime"] = total_minutes
	else
		player_data["playtime"] = 0

	qdel(query_playtime)

	// Get achievements count
	var/datum/db_query/query_achievements = SSdbcore.NewQuery({"
		SELECT COUNT(*) as achievement_count
		FROM [format_table_name("achievements")]
		WHERE ckey = :ckey
	"}, list("ckey" = target_ckey))

	if(query_achievements.warn_execute() && query_achievements.NextRow())
		// item is a list, not an associative list - use indexes
		player_data["achievements"] = text2num(query_achievements.item[1]) || 0
	else
		player_data["achievements"] = 0

	qdel(query_achievements)

	// Get role time details
	var/datum/db_query/query_roles = SSdbcore.NewQuery({"
		SELECT job, minutes
		FROM [format_table_name("role_time")]
		WHERE ckey = :ckey
			AND job NOT IN ('Living')
		ORDER BY minutes DESC
	"}, list("ckey" = target_ckey))

	var/roles_list = list()
	if(query_roles.warn_execute())
		while(query_roles.NextRow())
			// item is a list, not an associative list - use indexes
			roles_list += list(list(
				"job" = query_roles.item[1],
				"minutes" = text2num(query_roles.item[2]) || 0
			))
	qdel(query_roles)
	player_data["roles"] = roles_list

	// Get achievements details
	//Excludes Achievements Score and boss killed statistics, as it's not, well. An achievement? Though it's still present in the same database under the achievement_key line.
	var/datum/db_query/query_achievements_detail = SSdbcore.NewQuery({"
		SELECT achievement_key, last_updated
		FROM [format_table_name("achievements")]
		WHERE ckey = :ckey
			AND achievement_key NOT IN ('Achievements Score')
			AND LOWER(achievement_key) NOT LIKE '%killed'
		ORDER BY last_updated DESC
	"}, list("ckey" = target_ckey)) // should work?

	var/achievements_list = list()
	if(query_achievements_detail.warn_execute())
		while(query_achievements_detail.NextRow())
			// item is a list, not an associative list - use indexes
			var/ach_key = query_achievements_detail.item[1]
			var/ach_date = query_achievements_detail.item[2]
			achievements_list += list(list(
				"achievement_key" = ach_key,
				"last_updated" = ach_date
			))
	qdel(query_achievements_detail)
	player_data["achievements_detail"] = achievements_list

	return json_encode(player_data)

/// Topic handler for getting OOC messages from queue
/datum/world_topic/ooc_messages
	keyword = "ooc_messages"
	require_comms_key = TRUE

/datum/world_topic/ooc_messages/Run(list/input)
	log_world("OOC Bridge: ooc_messages topic called")

	var/ooc_list = list()

	if(!GLOB.bot_ooc_sending_que)
		GLOB.bot_ooc_sending_que = list()
		log_world("OOC Bridge: GLOB.bot_ooc_sending_que was null, initialized empty list")
		return json_encode(list("ooc" = list()))

	log_world("OOC Bridge: Queue length before copy: [length(GLOB.bot_ooc_sending_que)]")

	// Copy and clear the queue
	ooc_list = GLOB.bot_ooc_sending_que.Copy()
	GLOB.bot_ooc_sending_que = list()

	log_world("OOC Bridge: Copied [length(ooc_list)] messages, queue cleared")

	var/json_result = json_encode(list("ooc" = ooc_list))
	log_world("OOC Bridge: Returning JSON: [json_result]")

	return json_result

/// Topic handler for sending OOC messages from Discord to game
/datum/world_topic/send_ooc
	keyword = "send_ooc"
	require_comms_key = TRUE
	required_params = list("author", "message")

/datum/world_topic/send_ooc/Run(list/input)
	var/author = input["author"]
	var/message = input["message"]

	if(!author || !message)
		return json_encode(list("error" = "Missing author or message"))

	message = sanitize(message)

	for(var/client/C in GLOB.clients)
		if(!C.prefs)
			continue
		if(!(C.prefs.chat_toggles & CHAT_OOC))
			continue
		to_chat(C, "<span class='ooc'><span class='prefix'>DISCORD OOC:</span> <EM>[author]:</EM> <span class='message linkify'>[message]</span></span>")

	return json_encode(list("success" = TRUE))
// We might need it later
/datum/world_topic/notes
	keyword = "notes"
	require_comms_key = TRUE

/datum/world_topic/notes/Run(list/input)
	log_world("Notes: notes topic called")
	var/target_ckey = input["notes"]
	log_world("Notes: target_ckey: [target_ckey]")
	var/notes_list = list()

	if(!SSdbcore.Connect())
		log_world("Notes: Database connection failed")
		return list("notes" = list())

	var/datum/db_query/query_notes
	if(target_ckey)
		query_notes = SSdbcore.NewQuery({"
			SELECT
				id,
				timestamp,
				IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("messages")].targetckey), targetckey) as player_name,
				IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("messages")].adminckey), adminckey) as admin_name,
				adminckey,
				text,
				severity,
				expire_timestamp
			FROM [format_table_name("messages")]
			WHERE type = 'note'
				AND targetckey = :ckey
				AND deleted = 0
				AND secret = 0
				AND (expire_timestamp IS NULL OR expire_timestamp > NOW())
			ORDER BY timestamp DESC
		"}, list("ckey" = ckey(target_ckey)))
	else
		query_notes = SSdbcore.NewQuery({"
			SELECT
				id,
				timestamp,
				IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("messages")].targetckey), targetckey) as player_name,
				IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("messages")].adminckey), adminckey) as admin_name,
				adminckey,
				text,
				severity,
				expire_timestamp
			FROM [format_table_name("messages")]
			WHERE type = 'note'
				AND deleted = 0
				AND secret = 0
				AND (expire_timestamp IS NULL OR expire_timestamp > NOW())
			ORDER BY timestamp DESC
			LIMIT 100
		"}, list())

	if(!query_notes.warn_execute())
		log_world("Notes: Query execution failed")
		qdel(query_notes)
		return list("notes" = list())

	while(query_notes.NextRow())
		var/note_data = list(
			"type" = "note",
			"id" = text2num(query_notes.item["id"]),
			"player_name" = query_notes.item["player_name"] || query_notes.item["targetckey"],
			"admin_name" = query_notes.item["admin_name"] || query_notes.item["adminckey"],
			"admin_ckey" = query_notes.item["adminckey"],
			"timestamp" = query_notes.item["timestamp"],
			"text" = query_notes.item["text"],
			"severity" = query_notes.item["severity"],
			"expire_timestamp" = query_notes.item["expire_timestamp"]
		)
		notes_list += list(note_data)

	qdel(query_notes)
	log_world("Notes: Found [length(notes_list)] notes")
	var/json_result = json_encode(list("notes" = notes_list))
	log_world("Notes: Returning JSON: [json_result]")
	return json_result
