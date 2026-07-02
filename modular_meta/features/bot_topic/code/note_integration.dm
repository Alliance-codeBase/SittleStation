// Note integration for Discord bot
// Provides wrapper procs to send note events to bot queue
// Secret notes are NOT sent to Discord

/// Sends note created event to bot queue
/// Called from /proc/create_message() in sql_message_system.dm
/// Returns FALSE if note is secret (not sent to bot)
/proc/send_note_created_to_bot(target_ckey, target_name, admin_ckey, admin_name, text, severity, secret)
	if(secret)
		return FALSE // Skip secret notes

	if(!target_ckey || !admin_ckey)
		return FALSE

	var/list/event_data = list(
		"type" = "note",
		"action" = "created",
		"ckey" = target_ckey,
		"name" = target_name || target_ckey,
		"admin_ckey" = admin_ckey,
		"admin_name" = admin_name || admin_ckey,
		"description" = text || "No description",
		"severity" = severity || "none",
		"secret" = FALSE, // Always FALSE since we skip secret notes
	)

	add_ban_event_to_queue("created", event_data)
	return TRUE

/// Sends note deleted event to bot queue
/// Called from /proc/delete_message() in sql_message_system.dm
/// Returns FALSE if note was secret (not sent to bot)
/proc/send_note_deleted_to_bot(target_ckey, target_name, admin_ckey, admin_name, text, secret)
	if(secret)
		return FALSE // Skip secret notes

	if(!target_ckey || !admin_ckey)
		return FALSE

	var/list/event_data = list(
		"type" = "note",
		"action" = "deleted",
		"ckey" = target_ckey,
		"name" = target_name || target_ckey,
		"admin_ckey" = admin_ckey,
		"admin_name" = admin_name || admin_ckey,
		"description" = text || "No description",
	)

	add_ban_event_to_queue("deleted", event_data)
	return TRUE

/// Sends note edited event to bot queue
/// Called from /proc/edit_message() in sql_message_system.dm
/// Returns FALSE if note is secret (not sent to bot)
/proc/send_note_edited_to_bot(target_ckey, target_name, admin_ckey, admin_name, old_text, new_text, secret)
	if(secret)
		return FALSE // Skip secret notes

	if(!target_ckey || !admin_ckey)
		return FALSE

	var/list/event_data = list(
		"type" = "note",
		"action" = "edited",
		"ckey" = target_ckey,
		"name" = target_name || target_ckey,
		"admin_ckey" = admin_ckey,
		"admin_name" = admin_name || admin_ckey,
		"description" = new_text || "No description",
		"old_description" = old_text || "No description",
	)

	add_ban_event_to_queue("edited", event_data)
	return TRUE
