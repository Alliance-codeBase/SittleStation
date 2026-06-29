/obj/machinery/jukebox
	var/list/custom_songs = list()
	var/internet_track_selected = null

/obj/machinery/jukebox/ui_data(mob/user)
	var/list/data = ..()
	data["internet_sound_enabled"] = CONFIG_GET(flag/request_internet_sound) ? TRUE : FALSE

	if(internet_track_selected)
		data["track_selected"] = internet_track_selected

	var/list/all_songs = data["songs"]
	if(!all_songs)
		all_songs = list()

	for(var/song_name in custom_songs)
		var/list/custom_song_data = list(
			"name" = song_name,
			"length" = "Internet Stream",
			"beat" = 0,
			"is_custom" = TRUE,
			"url" = custom_songs[song_name]
		)
		all_songs += list(custom_song_data)

	data["songs"] = all_songs
	return data

/obj/machinery/jukebox/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("select_track")
			var/track_name = params["track"]

			if(custom_songs[track_name])
				internet_track_selected = track_name

				if(hascall(src, "turn_off"))
					call(src, "turn_off")()
				else if(hascall(src, "stop_playing"))
					call(src, "stop_playing")()
				else
					..("toggle", params, ui, state)

				var/mob/user = ui.user
				var/request_url = custom_songs[track_name]

				if(user && user.client)
					to_chat(user, span_info("Playing internet stream: [track_name]..."), confidential = TRUE)
					GLOB.requests.music_request(user.client, request_url, null)

				update_static_data_for_all_viewers()
				return TRUE
			else
				internet_track_selected = null

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

	if(..())
		var/track_name = params["track"]
		if(action == "select_track" && !custom_songs[track_name])
			internet_track_selected = null
			update_static_data_for_all_viewers()
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

	if(user.client.handle_spam_prevention(request_url, MUTE_INTERNET_REQUEST))
		return

	var/track_title = tgui_input_text(user, "Enter a name/title for this track to display in the Jukebox menu:", "Track Title Menu")
	if(!track_title)
		track_title = "[replacetext(request_url, "https://", "")]"
		if(length(track_title) > 30)
			track_title = "[copytext(track_title, 1, 28)]..."

	var/display_name = "🌐 | [track_title]"
	custom_songs[display_name] = request_url
	internet_track_selected = display_name

	if(hascall(src, "turn_off"))
		call(src, "turn_off")()
	else if(hascall(src, "stop_playing"))
		call(src, "stop_playing")()

	log_internet_request("[user.key]/([user.name]) successfully loaded via Jukebox: [request_url]")
	to_chat(user, span_info("Added '[display_name]' to the track list."), confidential = TRUE)

	GLOB.requests.music_request(user.client, request_url, null)

	var/list/admin_message = list()
	admin_message += ("[ADMIN_FULLMONTY(user)] [ADMIN_SC(user)] has played the following internet track via Jukebox:<br>")
	admin_message += ("<b>[display_name]</b><br>[span_linkify(request_url)]")

	for(var/client/admin_client in GLOB.admins)
		if(get_chat_toggles(admin_client) & CHAT_PRAYER)
			to_chat(admin_client, fieldset_block("Jukebox music", jointext(admin_message, ""), "boxed_message"), type = MESSAGE_TYPE_PRAYER, confidential = TRUE)

	SSblackbox.record_feedback("tally", "music_request", 1, "Music Direct Play")
	update_static_data_for_all_viewers()
