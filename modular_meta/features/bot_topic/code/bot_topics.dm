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

