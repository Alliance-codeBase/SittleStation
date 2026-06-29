/obj/machinery/jukebox

/obj/machinery/jukebox/ui_data(mob/user)
	var/list/data = ..()
	data["internet_sound_enabled"] = CONFIG_GET(flag/request_internet_sound) ? TRUE : FALSE
	return data

/obj/machinery/jukebox/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("request_internet_track")
			var/mob/user = ui.user
			if(!user || !user.client)
				return TRUE

			if(!CONFIG_GET(flag/request_internet_sound))
				to_chat(user, span_danger("This server has disabled internet sound requests."), confidential = TRUE)
				return TRUE

			if(user.client.prefs.muted & MUTE_INTERNET_REQUEST)
				to_chat(user, span_danger("You cannot play music at this time. (muted)."), confidential = TRUE)
				return TRUE

			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/machinery/jukebox, handle_internet_request), user)
			return TRUE

	return FALSE

/obj/machinery/jukebox/proc/handle_internet_request(mob/user)
	var/request_url = tgui_input_text(user, "Please input a URL. Supported sources: [replacetext(replacetext(CONFIG_GET(string/request_internet_allowed), "\\", ""), ",", ", ")].", "Play Internet sound")
	if(!request_url)
		return

	var/regex/allowed_regex = regex(replacetext(CONFIG_GET(string/request_internet_allowed), ",", "|"), "i")
	if(!allowed_regex.Find(request_url))
		to_chat(user, span_danger("Invalid URL. Please use a URL from one of the following sites: [replacetext(CONFIG_GET(string/request_internet_allowed), "\\", " ")]"), confidential = TRUE)
		return

	log_internet_request("[user.key]/([user.name]) played directly via Jukebox: [request_url]")

	if(user.client.handle_spam_prevention(request_url, MUTE_INTERNET_REQUEST))
		return

	to_chat(user, span_info("Streaming [span_linkify(request_url)] directly to your client..."), confidential = TRUE)

	var/sound/internet_sound = sound(request_url)
	internet_sound.wait = 0
	internet_sound.repeat = 0
	internet_sound.channel = CHANNEL_JUKEBOX
	internet_sound.volume = 30

	SEND_SOUND(user, internet_sound)

	var/list/admin_message = list()
	admin_message += ("[ADMIN_FULLMONTY(user)] [ADMIN_SC(user)] has played the following internet track directly via Jukebox:<br>")
	admin_message += ("[span_linkify(request_url)]")

	for(var/client/admin_client in GLOB.admins)
		if(get_chat_toggles(admin_client) & CHAT_PRAYER)
			to_chat(admin_client, fieldset_block("Jukebox music", jointext(admin_message, ""), "boxed_message"), type = MESSAGE_TYPE_PRAYER, confidential = TRUE)

	SSblackbox.record_feedback("tally", "music_request", 1, "Music Direct Play")
