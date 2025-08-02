// SETUP
/* OLD
/proc/TopicHandlers()
	. = list()
	var/list/all_handlers = subtypesof(/datum/world_topic)
	for(var/I in all_handlers)
		var/datum/world_topic/WT = I
		var/keyword = initial(WT.keyword)
		if(!keyword)
			warning("[WT] has no keyword! Ignoring...")
			continue
		var/existing_path = .[keyword]
		if(existing_path)
			warning("[existing_path] and [WT] have the same keyword! Ignoring [WT]...")
		else if(keyword == "key")
			warning("[WT] has keyword 'key'! Ignoring...")
		else
			.[keyword] = WT

// DATUM

/datum/world_topic
	var/keyword
	var/log = TRUE
	var/key_valid
	/// If the comms.txt config key is required. If you flip this to false, ensure the code is correct and the query you receive is legit.
	var/require_comms_key = TRUE

/datum/world_topic/proc/TryRun(list/input)
	key_valid = (CONFIG_GET(string/comms_key) == input["key"]) && CONFIG_GET(string/comms_key) && input["key"]
	input -= "key"
	if(require_comms_key && !key_valid)
		. = "Bad Key"
		if (input["format"] == "json")
			. = list("error" = .)
	else
		. = Run(input)
	if (input["format"] == "json")
		. = json_encode(.)
	else if(islist(.))
		. = list2params(.)

/datum/world_topic/proc/Run(list/input)
	CRASH("Run() not implemented for [type]!")

/** TOPICS
 * These are the handlers for world.Export() -> World.Topic() server communication.
 * Double check to ensure any calls are correct and the query is legit.
 * World.Topic() exploits can be very devastating since these can be called via a normal player connection without a client.
 * https://secure.byond.com/docs/ref/index.html#/world/proc/Topic
*/

// If you modify the protocol for this, update tools/Tgstation.PRAnnouncer
/datum/world_topic/ping
	keyword = "ping"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/ping/Run(list/input)
	. = 0
	for (var/client/C in GLOB.clients)
		++.

/datum/world_topic/playing
	keyword = "playing"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/playing/Run(list/input)
	return GLOB.player_list.len

// If you modify the protocol for this, update tools/Tgstation.PRAnnouncer
/datum/world_topic/pr_announce
	keyword = "announce"
	var/static/list/PRcounts = list() //PR id -> number of times announced this round

/datum/world_topic/pr_announce/Run(list/input)
	var/list/payload = json_decode(input["payload"])
	var/id = "[payload["pull_request"]["id"]]"
	if(!PRcounts[id])
		PRcounts[id] = 1
	else
		++PRcounts[id]
		if(PRcounts[id] > CONFIG_GET(number/pr_announcements_per_round))
			return

	var/final_composed = span_announce("PR: [input[keyword]]")
	for(var/client/C in GLOB.clients)
		C.AnnouncePR(final_composed)

/datum/world_topic/ahelp_relay
	keyword = "Ahelp"

/datum/world_topic/ahelp_relay/Run(list/input)
	relay_msg_admins(span_adminnotice("<b><font color=red>HELP: </font> [input["source"]] [input["message_sender"]]: [input["message"]]</b>"))

/datum/world_topic/comms_console
	keyword = "Comms_Console"

	var/list/timers

/datum/world_topic/comms_console/Run(list/input)
	// Reject comms messages from other servers that are not on our configured network,
	// if this has been configured. (See CROSS_COMMS_NETWORK in comms.txt)
	var/configured_network = CONFIG_GET(string/cross_comms_network)
	if (configured_network && configured_network != input["network"])
		return

	// We can't add the timer without the timer ID, but we can't get the timer ID without the timer!
	// To solve this, we just use a list that we mutate later.
	var/list/data = list("input" = input)
	// Did we have to pass the soft filter on our origin server? Passed as a boolean value.
	var/soft_filter_passed = !!input["is_filtered"]
	var/timer_id = addtimer(CALLBACK(src, PROC_REF(receive_cross_comms_message), data), soft_filter_passed ? EXTENDED_CROSS_SECTOR_CANCEL_TIME : CROSS_SECTOR_CANCEL_TIME, TIMER_STOPPABLE)
	data["timer_id"] = timer_id

	LAZYADD(timers, timer_id)

	var/extended_time_display = DisplayTimeText(EXTENDED_CROSS_SECTOR_CANCEL_TIME)
	var/normal_time_display = DisplayTimeText(CROSS_SECTOR_CANCEL_TIME)

	var/message = "<b color='orange'>CROSS-SECTOR MESSAGE (INCOMING):</b> [input["sender_ckey"]] (from [input["source"]]) is about to send \
			the following message (will autoapprove in [soft_filter_passed ? "[extended_time_display]" : "[normal_time_display]"]): \
			<b><a href='byond://?src=[REF(src)];reject_cross_comms_message=[timer_id]'>REJECT</a></b><br><br>\
			[input["message"]]"

	if(soft_filter_passed)
		message += "<br><br><b>NOTE: This message passed the soft filter on the origin server! The time was automatically expanded to [extended_time_display].</b>"

	message_admins(span_adminnotice(message))

/datum/world_topic/comms_console/Topic(href, list/href_list)
	. = ..()
	if (.)
		return

	if (href_list["reject_cross_comms_message"])
		if (!usr.client?.holder)
			log_game("[key_name(usr)] tried to reject an incoming cross-comms message without being an admin.")
			message_admins("[key_name(usr)] tried to reject an incoming cross-comms message without being an admin.")
			return

		var/timer_id = href_list["reject_cross_comms_message"]
		if (!(timer_id in timers))
			to_chat(usr, span_warning("It's too late!"))
			return

		deltimer(timer_id)
		LAZYREMOVE(timers, timer_id)

		log_admin("[key_name(usr)] has cancelled the incoming cross-comms message.")
		message_admins("[key_name(usr)] has cancelled the incoming cross-comms message.")

		return TRUE

/datum/world_topic/comms_console/proc/receive_cross_comms_message(list/data)
	var/list/input = data["input"]
	var/timer_id = data["timer_id"]

	LAZYREMOVE(timers, timer_id)

	minor_announce(input["message"], "Incoming message from [input["message_sender"]]")
	message_admins("Receiving a message from [input["sender_ckey"]] at [input["source"]]")
	for(var/obj/machinery/computer/communications/communications_console in GLOB.shuttle_caller_list)
		communications_console.override_cooldown()

/datum/world_topic/news_report
	keyword = "News_Report"

/datum/world_topic/news_report/Run(list/input)
	minor_announce(input["message"], "Breaking Update From [input["message_sender"]]")

/datum/world_topic/adminmsg
	keyword = "adminmsg"

/datum/world_topic/adminmsg/Run(list/input)
	return TgsPm(input[keyword], input["msg"], input["sender"])

/datum/world_topic/namecheck
	keyword = "namecheck"

/datum/world_topic/namecheck/Run(list/input)
	log_admin("world/Topic Name Check: [input["sender"]] on [input["namecheck"]]")
	message_admins("Name checking [input["namecheck"]] from [input["sender"]] (World topic)")

	return keywords_lookup(input["namecheck"], 1)

/datum/world_topic/adminwho
	keyword = "adminwho"

/datum/world_topic/adminwho/Run(list/input)
	return tgsadminwho()

/datum/world_topic/status
	keyword = "status"
	require_comms_key = FALSE

/datum/world_topic/status/Run(list/input)
	. = list()
	.["version"] = GLOB.game_version
	.["respawn"] = config ? !!CONFIG_GET(flag/allow_respawn) : FALSE // show respawn as true regardless of "respawn as char" or "free respawn"
	.["enter"] = !LAZYACCESS(SSlag_switch.measures, DISABLE_NON_OBSJOBS)
	.["ai"] = CONFIG_GET(flag/allow_ai)
	.["host"] = world.host ? world.host : null
	.["round_id"] = GLOB.round_id
	.["players"] = GLOB.clients.len
	.["revision"] = GLOB.revdata.commit
	.["revision_date"] = GLOB.revdata.date
	.["hub"] = GLOB.hub_visibility
	.["identifier"] = CONFIG_GET(string/serversqlname)

	var/public_address = CONFIG_GET(string/public_address)
	if(public_address)
		.["public_address"] = public_address


	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	.["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
	.["gamestate"] = SSticker.current_state

	.["map_name"] = SSmapping.current_map.map_name || "Loading..."

	if(key_valid)
		.["active_players"] = get_active_player_count()

	.["security_level"] = SSsecurity_level.get_current_level_as_text()
	.["round_duration"] = SSticker ? round((world.time-SSticker.round_start_time)/10) : 0
	// Amount of world's ticks in seconds, useful for calculating round duration

	//Time dilation stats.
	.["time_dilation_current"] = SStime_track.time_dilation_current
	.["time_dilation_avg"] = SStime_track.time_dilation_avg
	.["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	.["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast

	//pop cap stats
	.["soft_popcap"] = CONFIG_GET(number/soft_popcap) || 0
	.["hard_popcap"] = CONFIG_GET(number/hard_popcap) || 0
	.["extreme_popcap"] = CONFIG_GET(number/extreme_popcap) || 0
	.["popcap"] = max(CONFIG_GET(number/soft_popcap), CONFIG_GET(number/hard_popcap), CONFIG_GET(number/extreme_popcap)) //generalized field for this concept for use across ss13 codebases
	.["bunkered"] = CONFIG_GET(flag/panic_bunker) || FALSE
	.["interviews"] = CONFIG_GET(flag/panic_bunker_interview) || FALSE
	if(SSshuttle?.emergency)
		.["shuttle_mode"] = SSshuttle.emergency.mode
		// Shuttle status, see /__DEFINES/stat.dm
		.["shuttle_timer"] = SSshuttle.emergency.timeLeft()
		// Shuttle timer, in seconds

/datum/world_topic/create_news_channel
	keyword = "create_news_channel"
	/// Lazylist of timers for actually creating the channel to give admins some time
	var/list/timers

/datum/world_topic/create_news_channel/Run(list/input)
	var/message_delay = text2num(input["delay"])
	var/timer_id = addtimer(CALLBACK(src, PROC_REF(create_channel), input), message_delay)
	input["timer_id"] = timer_id
	LAZYADD(timers, timer_id)

	var/message = "<b color='orange'>Cross-sector channel creation (Incoming):</b> [input["author_ckey"]] is about to create a cross-sector \
			newscaster channel \"[input["message"]]\" (will autoapprove in [DisplayTimeText(message_delay)]): \
			<b><a href='byond://?src=[REF(src)];reject_channel_creation=[timer_id]'>REJECT</a></b>"

	message_admins(span_adminnotice(message))

/datum/world_topic/create_news_channel/Topic(href, list/href_list)
	. = ..()
	if (.)
		return

	var/timer_id = href_list["reject_channel_creation"]
	if (!timer_id)
		return

	if (!usr.client?.holder)
		log_game("tried to reject the creation of an incoming cross-sector newscaster channel without being an admin.", LOG_ADMIN)
		message_admins("[key_name(usr)] tried to reject the creation of an incoming cross-sector newscaster channel without being an admin.")
		return

	if (!(timer_id in timers))
		to_chat(usr, span_warning("It's too late!"))
		return

	deltimer(timer_id)
	LAZYREMOVE(timers, timer_id)

	log_admin("[key_name(usr)] has cancelled the creation of an incoming cross-sector newscaster channel.")
	message_admins("[key_name(usr)] has cancelled the creation of an incoming cross-sector newscaster channel.")
	return TRUE

/datum/world_topic/create_news_channel/proc/create_channel(list/input)
	LAZYREMOVE(timers, input["timer_id"])
	message_admins("[input["author_ckey"]] has crated a cross-sector newscaster channel titled \"[input["message"]]\"")
	GLOB.news_network.create_feed_channel(input["message"], input["author"], input["desc"], locked = TRUE, receiving_cross_sector = TRUE)

/datum/world_topic/create_news_article
	keyword = "create_news_article"

/datum/world_topic/create_news_article/Run(list/input)
	var/msg = input["msg"]
	var/author = input["author"]
	var/author_key = input["author_ckey"]
	var/channel_name = input["message"]

	var/found_channel = FALSE
	for(var/datum/feed_channel/channel as anything in GLOB.news_network.network_channels)
		if(channel.channel_name == channel_name)
			found_channel = TRUE
			break

	// No channel with a matching name, abort
	if (!found_channel)
		return

	message_admins(span_adminnotice("Incoming cross-sector newscaster article by [author_key] in channel [channel_name]."))
	GLOB.news_network.submit_article(msg, author, channel_name)
*/





/datum/world_topic
	/// query key
	var/key

	/// can be used with anonymous authentication
	var/anonymous = FALSE

	var/list/required_params = list()
	var/statuscode
	var/response
	var/data

/datum/world_topic/proc/CheckParams(list/params)
	var/list/missing_params = list()
	var/errorcount = 0

	for(var/param in required_params)
		if(!params[param])
			errorcount++
			missing_params += param

	if(errorcount)
		statuscode = 400
		response = "Bad Request - Missing parameters"
		data = missing_params
		return errorcount

/datum/world_topic/proc/Run(list/input)
	// Always returns true; actual details in statuscode, response and data variables
	return TRUE

// API INFO TOPICS

/datum/world_topic/api_get_authed_functions
	key = "api_get_authed_functions"
	anonymous = TRUE

/datum/world_topic/api_get_authed_functions/Run(list/input)
	. = ..()
	var/list/functions = GLOB.topic_tokens[input["auth"]]
	if(functions)
		statuscode = 200
		response = "Authorized functions retrieved"
		data = functions
	else
		statuscode = 401
		response = "Unauthorized - No functions found"
		data = null

// TOPICS

// If you modify the protocol for this, update tools/Tgstation.PRAnnouncer
/datum/world_topic/pr_announce
	key = "announce"
	anonymous = TRUE
	var/static/list/PRcounts = list() //PR id -> number of times announced this round

/datum/world_topic/pr_announce/Run(list/input)
	. = ..()
	var/list/payload = json_decode(input["payload"])
	var/id = "[payload["pull_request"]["id"]]"
	if(!PRcounts[id])
		PRcounts[id] = 1
	else
		++PRcounts[id]
		if(PRcounts[id] > CONFIG_GET(number/pr_announcements_per_round))
			return

	var/final_composed = span_announce("PR: [input[key]]")
	for(var/client/C in GLOB.clients)
		C.AnnouncePR(final_composed)

	statuscode = 200
	response = "Received"

/datum/world_topic/ping
	key = "ping"
	anonymous = TRUE

/datum/world_topic/ping/Run(list/input)
	. = ..()
	statuscode = 200
	response = "Pong!"
	data = length(GLOB.clients)

/datum/world_topic/status
	key = "status"
	anonymous = TRUE

/datum/world_topic/status/Run(list/input)
	. = ..()

	data = list()

	data["version"] = GLOB.game_version
	data["respawn"] = config ? !!CONFIG_GET(flag/allow_respawn) : FALSE // show respawn as true regardless of "respawn as char" or "free respawn"
	data["enter"] = !LAZYACCESS(SSlag_switch.measures, DISABLE_NON_OBSJOBS)
	data["ai"] = CONFIG_GET(flag/allow_ai)
	data["host"] = world.host ? world.host : null

	data["round_id"] = GLOB.round_id

	data["map_name"] = SSmapping.current_map?.map_name || "Loading..."

	data["players"] = length(GLOB.clients)

	data["identifier"] = CONFIG_GET(string/serversqlname)


	var/public_address = CONFIG_GET(string/public_address)
	if(public_address)
		data["public_address"] = public_address

	data["revision"] = GLOB.revdata.commit
	data["revision_date"] = GLOB.revdata.date
	data["hub"] = GLOB.hub_visibility

	data["security_level"] = SSsecurity_level.get_current_level_as_text()
	data["round_duration"] = SSticker ? round((world.time-SSticker.round_start_time)/10) : 0

	//Time dilation stats.
	data["time_dilation_current"] = SStime_track.time_dilation_current
	data["time_dilation_avg"] = SStime_track.time_dilation_avg
	data["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	data["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast

	data["soft_popcap"] = CONFIG_GET(number/soft_popcap) || 0
	data["hard_popcap"] = CONFIG_GET(number/hard_popcap) || 0
	data["extreme_popcap"] = CONFIG_GET(number/extreme_popcap) || 0
	data["popcap"] = max(CONFIG_GET(number/soft_popcap), CONFIG_GET(number/hard_popcap), CONFIG_GET(number/extreme_popcap)) //generalized field for this concept for use across ss13 codebases
	data["bunkered"] = CONFIG_GET(flag/panic_bunker) || FALSE
	data["interviews"] = CONFIG_GET(flag/panic_bunker_interview) || FALSE
	if(SSshuttle?.emergency)
		data["shuttle_mode"] = SSshuttle.emergency.mode
		// Shuttle status, see /__DEFINES/stat.dm
		data["shuttle_timer"] = SSshuttle.emergency.timeLeft()
		// Shuttle timer, in seconds

	statuscode = 200
	response = "Status retrieved"

/datum/world_topic/status/authed
	key = "status_authed"
	anonymous = FALSE

/datum/world_topic/status/authed/Run(list/input)
	. = ..()

	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	data["admins"] = length(presentmins) + length(afkmins)
	data["gamestate"] = SSticker.current_state

	data["active_players"] = get_active_player_count()

	data["mcpu"] = world.map_cpu
	data["cpu"] = world.cpu

GLOBAL_LIST_EMPTY(bot_event_sending_que)
GLOBAL_LIST_EMPTY(bot_ooc_sending_que)
GLOBAL_LIST_EMPTY(bot_asay_sending_que)

/datum/world_topic/receive_info
	key = "receive_info"

/datum/world_topic/receive_info/Run(list/input)
	data = list()
	if(!length(GLOB.bot_event_sending_que) && !length(GLOB.bot_ooc_sending_que) && !length(GLOB.bot_asay_sending_que))
		statuscode = 501
		response = "No events pool."
		return

	//Yeah, we can use /datum/http_request, but nuh... it's less fun.
	data["events"] = GLOB.bot_event_sending_que
	data["ooc"] = GLOB.bot_ooc_sending_que
	data["admin"] = GLOB.bot_asay_sending_que
	GLOB.bot_event_sending_que = list()
	GLOB.bot_ooc_sending_que = list()
	GLOB.bot_asay_sending_que = list()
	statuscode = 200
	response = "Events sent."

/datum/world_topic/send_info
	key = "send_info"
	required_params = list("data")

/datum/world_topic/send_info/Run(list/input)
	data = list()

	var/list/bot_data = input["data"]
	if(!istype(bot_data) || !length(bot_data))
		statuscode = 403
		response = "Wrong data"
		return

	if(bot_data["ooc"])
		for(var/list/data in bot_data["ooc"])
			var/msg = sanitize(data["message"])
			for(var/client/C in GLOB.clients)
				if(C.prefs.chat_toggles & CHAT_OOC)
					to_chat(C, "<span class='ooc'><span class='prefix'>DISCORD OOC:</span> <EM>[data["author"]]:</EM> <span class='message linkify'>[msg]</span></span>")

	if(bot_data["admin"])
		for(var/list/data in bot_data["admin"])
			to_chat(GLOB.admins, "<span class='adminsay'><span class='prefix'>DISCORD ADMIN:</span> <EM>[data["author"]]</EM>: <span class='message linkify'>[sanitize(data["message"])]</span></span>", confidential = TRUE)

	statuscode = 200
	response = "Events received."

/datum/world_topic/delay
	key = "set_delay"
	required_params = list("delay")

/datum/world_topic/delay/Run(list/input)
	. = ..()

	if(SSticker.timeLeft < 0 && input["delay"])
		statuscode = 501
		response = "Delay already set to same state."
		return

	SSticker.timeLeft = input["delay"] ? -1 : 300
	message_admins(span_notice("[input["source"]] ([input["addr"]]) [SSticker.timeLeft < 0 ? "delayed the round start" : "has made the round start normally"]."))
	to_chat(world, span_notice("The game start has been [SSticker.timeLeft < 0 ? "delayed" : "continued"]."))
	if(SSticker.timeLeft < 0)
		statuscode = 200
		response = "Delay set."
	else
		statuscode = 200
		response = "Delay removed."
