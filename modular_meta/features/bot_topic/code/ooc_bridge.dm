// OOC Bridge - sends OOC messages to Discord bot queue
// Proc added via massmeta edit in code/modules/client/verbs/ooc.dm

/// Adds an OOC message to the bot event queue for Discord relay
/proc/add_ooc_to_queue(client/sender, message)
	if(!GLOB.bot_ooc_sending_que)
		GLOB.bot_ooc_sending_que = list()
		log_world("OOC Bridge: Initialized GLOB.bot_ooc_sending_que")

	var/list/ooc_data = list(
		"type" = "ooc",
		"ckey" = sender?.ckey || "unknown",
		"key" = sender?.key || "unknown",
		"message" = message,
		"timestamp" = ISOtime()
	)

	GLOB.bot_ooc_sending_que += list(ooc_data)
	log_world("OOC Bridge: Added message from [sender?.ckey] to queue. Queue length: [length(GLOB.bot_ooc_sending_que)]")
