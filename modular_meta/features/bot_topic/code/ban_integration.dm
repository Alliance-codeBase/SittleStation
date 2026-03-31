// Ban integration for Discord bot
// Provides wrapper procs to send ban events to bot queue

/// Sends ban created event to bot queue
/// Called from /datum/admins/proc/create_ban() in sql_ban_system.dm
/proc/send_ban_created_to_bot(player_ckey, player_name, admin_ckey, admin_name, reason, duration, interval, list/roles, applies_to_admins)
	if(!player_ckey || !admin_ckey)
		return

	var/list/event_data = list(
		"type" = "ban",
		"action" = "created",
		"ckey" = player_ckey,
		"name" = player_name || player_ckey,
		"admin_ckey" = admin_ckey,
		"admin_name" = admin_name || admin_ckey,
		"reason" = reason || "No reason provided",
		"duration" = duration,
		"interval" = interval || "MINUTE",
		"roles" = roles ? roles.Copy() : list("Server"),
		"applies_to_admins" = applies_to_admins ? TRUE : FALSE,
	)

	add_ban_event_to_queue("created", event_data)

/// Sends ban unbanned event to bot queue
/// Called from /datum/admins/proc/unban() in sql_ban_system.dm
/proc/send_ban_unbanned_to_bot(player_ckey, player_name, admin_ckey, admin_name, role, reason)
	if(!player_ckey || !admin_ckey)
		return

	var/list/event_data = list(
		"type" = "ban",
		"action" = "unbanned",
		"ckey" = player_ckey,
		"name" = player_name || player_ckey,
		"admin_ckey" = admin_ckey,
		"admin_name" = admin_name || admin_ckey,
		"role" = role || "Server",
		"reason" = reason || "No reason provided",
	)

	add_ban_event_to_queue("unbanned", event_data)

/// Sends ban rebanned event to bot queue
/// Called from /datum/admins/proc/reban() in sql_ban_system.dm
/proc/send_ban_rebanned_to_bot(player_ckey, player_name, admin_ckey, admin_name, role, reason)
	if(!player_ckey || !admin_ckey)
		return

	var/list/event_data = list(
		"type" = "ban",
		"action" = "rebanned",
		"ckey" = player_ckey,
		"name" = player_name || player_ckey,
		"admin_ckey" = admin_ckey,
		"admin_name" = admin_name || admin_ckey,
		"role" = role || "Server",
		"reason" = reason || "No reason provided",
	)

	add_ban_event_to_queue("rebanned", event_data)

/// Sends ban edited event to bot queue
/// Called from /datum/admins/proc/edit_ban() in sql_ban_system.dm
/proc/send_ban_edited_to_bot(player_ckey, player_name, admin_ckey, admin_name, reason, duration, interval, role, list/changes)
	if(!player_ckey || !admin_ckey)
		return

	var/list/event_data = list(
		"type" = "ban",
		"action" = "edited",
		"ckey" = player_ckey,
		"name" = player_name || player_ckey,
		"admin_ckey" = admin_ckey,
		"admin_name" = admin_name || admin_ckey,
		"reason" = reason || "No reason provided",
		"duration" = duration,
		"interval" = interval || "MINUTE",
		"role" = role || "Server",
		"changes" = changes ? changes.Copy() : list(),
	)

	add_ban_event_to_queue("edited", event_data)
