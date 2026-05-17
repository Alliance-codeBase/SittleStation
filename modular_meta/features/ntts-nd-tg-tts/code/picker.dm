/datum/tts_voice_picker
	var/datum/preference_middleware/tts/middleware
	var/datum/preferences/preferences

/datum/tts_voice_picker/New(datum/preference_middleware/tts/middleware)
	. = ..()
	src.middleware = middleware
	preferences = middleware.preferences

/datum/tts_voice_picker/Destroy(force)
	middleware = null
	preferences = null
	return ..()

/datum/tts_voice_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TTSVoicePicker", "TTS Voice", 650, 720)
		ui.open()

/datum/tts_voice_picker/ui_state(mob/user)
	return GLOB.always_state

/datum/tts_voice_picker/ui_status(mob/user, datum/ui_state/state)
	return user.client == preferences.parent ? UI_INTERACTIVE : UI_CLOSE

/datum/tts_voice_picker/ui_close(mob/user)
	qdel(src)

/datum/tts_voice_picker/ui_data(mob/user)
	return list(
		"voice" = preferences.read_preference(/datum/preference/choiced/voice),
		"pitch" = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch),
		"blip_base" = preferences.read_preference(/datum/preference/choiced/tts_blip_base),
		"blip_number" = preferences.read_preference(/datum/preference/numeric/tts_blip_number),
		"voices" = user.client?.holder ? SStts.admin_voices() : SStts.player_voice_choices(),
		"categories" = SStts.voice_categories,
	)

/datum/tts_voice_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_voice")
			return set_preference(/datum/preference/choiced/voice, params["value"])
		if("set_pitch")
			return set_preference(/datum/preference/numeric/tts_voice_pitch, params["value"])
		if("set_blip_base")
			return set_preference(/datum/preference/choiced/tts_blip_base, params["value"])
		if("set_blip_number")
			return set_preference(/datum/preference/numeric/tts_blip_number, params["value"])
		if("play_voice")
			return middleware.play_voice(params, ui.user)
		if("play_robot")
			return middleware.play_voice_borg(params, ui.user)
		if("play_blips")
			return middleware.play_blips(params, ui.user)
		if("play_radio")
			return play_radio(params, ui.user)
		/*
		 if("play_radio_ion")
		 	return play_radio(params, ui.user, TRUE)
		*/
		if("play_gas_mask")
			return play_mask(params, ui.user, /obj/item/clothing/mask/gas)
		if("play_sec_hailer")
			return play_mask(params, ui.user, /obj/item/clothing/mask/gas/sechailer)

	return FALSE

/datum/tts_voice_picker/proc/set_preference(preference_type, value)
	var/datum/preference/preference = GLOB.preference_entries[preference_type]
	if(!preferences.update_preference(preference, value))
		return FALSE
	SStgui.update_uis(preferences)
	return TRUE

/datum/tts_voice_picker/proc/play_radio(list/params, mob/user, ion = FALSE)
	if(!COOLDOWN_FINISHED(middleware, tts_test_cooldown))
		return TRUE
	var/identifier = "tts_preview_[REF(user)]_[world.time]_[rand(1, 999999)]"
	var/list/radio_messages = list()
	radio_messages[TTS_GHOST_RADIO] = list(user)
	SStts.queued_radio_messages[identifier] = radio_messages
	SStts.queued_radio_messages_compression[identifier] = 0
	// SStts.queued_radio_messages_compression[identifier] = ion ? 31 : 0
	COOLDOWN_START(middleware, tts_test_cooldown, 0.5 SECONDS)
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, params["message"], speaker = params["voice"], pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch), listeners = list(), blip_base = get_blip_base(), blip_number = preferences.read_preference(/datum/preference/numeric/tts_blip_number), identifier = identifier)
	return TRUE

/datum/tts_voice_picker/proc/play_mask(list/params, mob/user, obj/item/clothing/mask/mask_type)
	if(!COOLDOWN_FINISHED(middleware, tts_test_cooldown))
		return TRUE
	var/speaker = initial(mask_type.voice_override) || params["voice"]
	var/list/filter = list()
	if(initial(mask_type.voice_filter))
		filter += initial(mask_type.voice_filter)
	var/list/special_filter = list()
	if(initial(mask_type.use_radio_beeps_tts))
		special_filter |= TTS_FILTER_RADIO
	COOLDOWN_START(middleware, tts_test_cooldown, 0.5 SECONDS)
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, params["message"], speaker = speaker, filter = filter.Join(","), pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch), special_filters = special_filter.Join("|"), local = TRUE, blip_base = get_blip_base(), blip_number = preferences.read_preference(/datum/preference/numeric/tts_blip_number))
	return TRUE

/datum/tts_voice_picker/proc/get_blip_base()
	var/blip_base = preferences.read_preference(/datum/preference/choiced/tts_blip_base)
	if(blip_base == TTS_BLIPS_MASCULINE)
		return "male"
	return "female"
