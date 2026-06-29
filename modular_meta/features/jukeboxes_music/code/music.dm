/obj/machinery/jukebox
	var/list/custom_songs = list()
	var/internet_track_selected = null
	var/internet_playing = FALSE
	var/current_stream_path = ""

/obj/machinery/jukebox/Destroy()
	stop_internet_stream()
	return ..()

/obj/machinery/jukebox/ui_data(mob/user)
	var/list/data = ..()
	data["internet_sound_enabled"] = CONFIG_GET(flag/request_internet_sound) ? TRUE : FALSE

	if(internet_track_selected)
		data["track_selected"] = internet_track_selected
		data["active"] = internet_playing ? TRUE : FALSE

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
	if(action == "select_track")
		var/track_name = params["track"]

		if(custom_songs[track_name])
			internet_track_selected = track_name
			if(internet_playing)
				stop_internet_stream(ui.user)

			if(hascall(src, "turn_off"))
				call(src, "turn_off")()
			else if(hascall(src, "stop_playing"))
				call(src, "stop_playing")()

			update_static_data_for_all_viewers()
			return TRUE
		else
			internet_track_selected = null
			if(internet_playing)
				stop_internet_stream(ui.user)

	if(action == "toggle")
		if(internet_track_selected)
			var/mob/user = ui.user
			if(!user)
				return TRUE

			if(internet_playing)
				stop_internet_stream(user)
			else
				if(hascall(src, "turn_off"))
					call(src, "turn_off")()
				else if(hascall(src, "stop_playing"))
					call(src, "stop_playing")()

				internet_playing = TRUE
				update_static_data_for_all_viewers()
				INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/machinery/jukebox, start_internet_stream), user)

			return TRUE

	if(action == "request_internet_track")
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

	if(internet_playing)
		stop_internet_stream(user)

	log_internet_request("[user.key]/([user.name]) successfully loaded via Jukebox: [request_url]")
	to_chat(user, span_info("Added '[display_name]' to the track list."), confidential = TRUE)

	var/list/admin_message = list()
	admin_message += ("[ADMIN_FULLMONTY(user)] [ADMIN_SC(user)] has added the following internet track via Jukebox:<br>")
	admin_message += ("<b>[display_name]</b><br>[span_linkify(request_url)]")

	for(var/client/admin_client in GLOB.admins)
		if(get_chat_toggles(admin_client) & CHAT_PRAYER)
			to_chat(admin_client, fieldset_block("Jukebox music", jointext(admin_message, ""), "boxed_message"), type = MESSAGE_TYPE_PRAYER, confidential = TRUE)

	SSblackbox.record_feedback("tally", "music_request", 1, "Music Direct Play")
	update_static_data_for_all_viewers()

/obj/machinery/jukebox/proc/start_internet_stream(mob/user)
	var/request_url = custom_songs[internet_track_selected]
	if(!request_url)
		internet_playing = FALSE
		update_static_data_for_all_viewers()
		return

	to_chat(user, span_notice("Downloading and processing audio."))

	var/safe_url = replacetext(request_url, "\"", "")
	safe_url = replacetext(safe_url, ";", "")
	safe_url = replacetext(safe_url, "&", "")

	var/stream_id = rand(1111, 9999)
	var/output_template = "data/music_cache/yt_[stream_id]"
	current_stream_path = "[output_template].ogg"

	fdel(current_stream_path)

	var/shell_command = "yt-dlp -x --audio-format vorbis --audio-quality 5 -o \"[output_template].%(ext)s\" \"[safe_url]\""

	shell(shell_command)

	var/check_attempts = 0
	while(!fexists(current_stream_path) && check_attempts < 40)
		sleep(5)
		check_attempts++

	if(!fexists(current_stream_path) || !internet_playing)
		to_chat(user, span_danger("Failed to download or extract audio from YouTube. Check server yt-dlp/ffmpeg installation."))
		internet_playing = FALSE
		if(current_stream_path)
			fdel(current_stream_path)
			current_stream_path = ""
		update_static_data_for_all_viewers()
		return

	var/sound/internet_sound = sound(file(current_stream_path))
	internet_sound.wait = 0
	internet_sound.repeat = 0
	internet_sound.channel = CHANNEL_JUKEBOX
	internet_sound.volume = 30

	SEND_SOUND(user, internet_sound)
	to_chat(user, span_info("Now playing stream: [internet_track_selected]."))

/obj/machinery/jukebox/proc/stop_internet_stream(mob/user)
	internet_playing = FALSE
	if(user)
		var/sound/mute_sound = sound(null)
		mute_sound.channel = CHANNEL_JUKEBOX
		SEND_SOUND(user, mute_sound)

	if(current_stream_path)
		fdel(current_stream_path)
		current_stream_path = ""

	update_static_data_for_all_viewers()
