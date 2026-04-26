// Ban event system for Discord bot integration
// Handles sending ban events to bot event queue

/// Adds a ban or note event to the bot event queue
/// Args:
/// event_type - Type of event ("created", "edited", "unbanned", "rebanned")
/// event_data - List containing ban or note information
/proc/add_ban_event_to_queue(event_type, list/event_data)
	if(!GLOB.bot_event_sending_que)
		GLOB.bot_event_sending_que = list()

	var/final_event_data = list(
		"timestamp" = ISOtime(),
		"round_id" = GLOB.round_id,
	)

	final_event_data += event_data

	GLOB.bot_event_sending_que += list(final_event_data)
	log_admin_private("BOT DEBUG: Added event to queue. Type: [event_type], Queue length: [length(GLOB.bot_event_sending_que)]")
