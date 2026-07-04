ADMIN_VERB(change_announcements_voice, R_FUN, "Change Announcement Voice", "Tries to Change Announcement Voice if tts subsystem is available", ADMIN_CATEGORY_FUN)
	if(!SStts.tts_enabled)
		var/retry = tgui_alert(user, "Text To Speech is currently off, would you like to try re-establish connection", "Whoops!", list("Yes", "No")) == "Yes"
		if(retry)
			message_admins("[key_name_admin(user)] attempted to re-establish connection to the TTS HTTP server.")
			log_admin("[key_name(user)] attempted to re-establish connection to the TTS HTTP server.")
			SStts.establish_connection_to_tts()
			if(!SStts.can_fire)
				SStts.can_fire = TRUE

	var/voice = tgui_input_list(user, "What voice to use?", "How are we speaking today?", SStts.available_speakers, SStts.centcom_voice)
	if(isnull(voice)) // just in case admin presses cancel if they change their mind
		return
	if(voice == SStts.centcom_voice)
		return
	message_admins("[key_name(user)] has changed centcom announcement to from [SStts.centcom_voice] to [voice]")
	log_admin("[key_name(user)] has changed centcom announcement to from [SStts.centcom_voice] to [voice]")
	SStts.centcom_voice = voice





