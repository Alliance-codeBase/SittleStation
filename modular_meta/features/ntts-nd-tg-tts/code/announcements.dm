/datum/config_entry/string/centcom_voice

/atom/movable
	var/tts_announcement_effect

/obj/machinery/announcement_system
	tts_announcement_effect = "radio_machine"

/datum/controller/subsystem/tts
	var/centcom_voice

/datum/tts_request
	var/announcement = FALSE
	var/list/announcement_listeners

/datum/controller/subsystem/tts/proc/set_announcement_voices()
	centcom_voice = CONFIG_GET(string/centcom_voice) || computer_voice
	if(!(centcom_voice in available_speakers))
		centcom_voice = computer_voice

/datum/controller/subsystem/tts/proc/announcement_voice(atom/movable/source, voice_override)
	var/speaker = voice_override || source?.voice || centcom_voice || computer_voice
	if(speaker in available_speakers)
		return speaker
	if(computer_voice in available_speakers)
		return computer_voice
	return length(available_speakers) ? pick(available_speakers) : null

/datum/controller/subsystem/tts/proc/announcement_effect(atom/movable/source, fallback = "centcom")
	return source?.tts_announcement_effect || fallback

/datum/controller/subsystem/tts/proc/announcement_text(message, title)
	var/list/parts = list()
	if(title)
		parts += html_decode(STRIP_HTML_SIMPLE(title, MAX_MESSAGE_LEN))
	if(message)
		parts += html_decode(STRIP_HTML_SIMPLE(message, MAX_MESSAGE_LEN))
	return parts.Join(". ")

/datum/controller/subsystem/tts/proc/can_hear_announcement_tts(mob/listener, should_play_sound = TRUE)
	if(!listener || isnewplayer(listener) || HAS_TRAIT(listener, TRAIT_DEAF))
		return FALSE
	if(!listener.client)
		return FALSE

	var/datum/callback/play_check = astype(should_play_sound)
	if(!should_play_sound || (play_check && !play_check.Invoke(listener)))
		return FALSE
	if(!listener.client.prefs.read_preference(/datum/preference/toggle/sound_announcements))
		return FALSE
	if(listener.client.prefs.read_preference(/datum/preference/choiced/sound_tts) == TTS_SOUND_OFF)
		return FALSE
	return TRUE

/datum/controller/subsystem/tts/proc/announcement_listeners(list/players, should_play_sound = TRUE)
	var/list/filtered = list()
	for(var/mob/player as anything in (players || GLOB.player_list))
		if(can_hear_announcement_tts(player, should_play_sound))
			filtered += player
	return filtered

/datum/controller/subsystem/tts/proc/queue_global_announcement(message, list/players, atom/movable/source, voice_override, filter, special_filters, should_play_sound = TRUE, effect)
	if(!tts_enabled)
		return

	message = announcement_text(message)
	if(!message)
		return

	var/list/listeners = announcement_listeners(players, should_play_sound)
	if(!length(listeners))
		return

	var/list/filters = list()
	if(filter)
		filters += filter
	if(source?.voice_filter)
		filters += source.voice_filter

	var/list/special_filter_list = list()
	if(special_filters)
		special_filter_list += special_filters

	var/speaker = voice_override
	if(!speaker && isliving(source))
		var/mob/living/living_source = source
		speaker = living_source.get_tts_voice(filters, special_filter_list)
	if(!speaker)
		speaker = announcement_voice(source, voice_override)
	if(!(speaker in available_speakers))
		speaker = announcement_voice(source, null)
	if(!speaker)
		return

	filter = filters.Join(",")
	special_filters = special_filter_list.Join("|")
	var/pitch = source?.pitch || 0
	var/blip_base = source?.blip_base || "male"
	var/blip_number = source?.blip_number || "1"
	effect ||= announcement_effect(source)
	queue_announcement(message, listeners, speaker, filter, pitch, special_filters, blip_base, blip_number, effect)

/datum/controller/subsystem/tts/proc/queue_announcement(message, list/listeners, speaker, filter = "", pitch = 0, special_filters = "", blip_base = "male", blip_number = "1", effect = "centcom")
	if(!fexists("tmp/tts/init.txt"))
		rustg_file_write("rustg HTTP requests can't write to folders that don't exist, so we need to make it exist.", "tmp/tts/init.txt")

	filter ||= ""
	special_filters ||= ""
	var/static/regex/contains_alphanumeric = regex("\[а-яА-ЯёЁa-zA-Z0-9]")
	if(contains_alphanumeric.Find(message) == 0)
		return

	var/effect_param = effect ? "&announcement_effect=[url_encode(effect)]" : ""
	var/identifier = "[sha1("[speaker][filter][pitch][special_filters][message][blip_base][blip_number][effect]")].[world.time]"
	var/input = tts_speech_filter(message)
	var/list/headers = list(
		"Content-Type" = "application/json",
		"Authorization" = CONFIG_GET(string/tts_http_token),
	)

	var/datum/http_request/request = new()
	var/file_name = "tmp/tts/[identifier].ogg"
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/tts_http_url)]/tts?voice=[speaker]&identifier=[identifier]&filter=[tts_filter_encode(filter, speaker, pitch)]&pitch=[pitch]&special_filters=[url_encode(special_filters)][effect_param]", json_encode(list("text" = input)), headers, file_name, timeout_seconds = CONFIG_GET(number/tts_http_timeout_seconds))

	var/datum/tts_request/current_request = new /datum/tts_request(identifier, request, null, null, null, null, input, null, FALSE, /datum/language/common, INFINITY, 0, listeners, pitch, FALSE)
	current_request.announcement = TRUE
	current_request.announcement_listeners = listeners

	var/list/queued = queued_tts_messages[src]
	if(!queued)
		queued = list()
		queued_tts_messages[src] = queued
	queued += current_request
	if(length(in_process_http_messages) < max_concurrent_requests)
		current_request.start_requests()
		in_process_http_messages += current_request
	else
		queued_http_messages.insert(current_request)

/datum/controller/subsystem/tts/proc/prepare_radio_announcement(atom/movable/source, message, effect)
	if(!tts_enabled)
		return

	var/tts_text = announcement_text(message)
	if(!tts_text)
		return

	var/speaker = announcement_voice(null, computer_voice)
	if(!speaker)
		return

	var/filter = source?.voice_filter || ""
	var/pitch = source?.pitch || 0
	var/blip_base = source?.blip_base || "male"
	var/blip_number = source?.blip_number || "1"
	effect ||= announcement_effect(source, "radio_machine")
	var/identifier = "[sha1("[speaker][filter][pitch][tts_text][blip_base][blip_number][effect]")].[world.time]"
	var/language = source ? source.get_selected_language() : /datum/language/common
	INVOKE_ASYNC(src, PROC_REF(queue_tts_message), source, tts_text, language, speaker, filter, list(), message_range = INFINITY, pitch = pitch, blip_base = blip_base, blip_number = blip_number, identifier = identifier, announcement_effect = effect)
	return list(MODE_TTS_IDENTIFIER = identifier)

/datum/tts_request/proc/start_announcement_requests()
	request.begin_async()

/datum/tts_request/proc/announcement_requests_errored()
	var/datum/http_response/response = request.into_response()
	return response.errored || response.status_code != 200

/datum/tts_request/proc/announcement_requests_completed()
	return request.is_complete()

/datum/tts_request/proc/play_announcement()
	for(var/mob/listener as anything in announcement_listeners)
		if(!SStts.can_hear_announcement_tts(listener))
			continue
		var/volume = listener.client.prefs.read_preference(/datum/preference/numeric/volume/sound_tts_volume)
		if(!volume)
			continue
		var/sound/audio = sound(audio_file)
		audio.volume = 85 * (volume / 100)
		SEND_SOUND(listener, audio)
