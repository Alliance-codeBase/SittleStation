/datum/config_entry/str_list/admin_voices

/datum/controller/subsystem/tts
	var/list/player_speakers = list()
	var/list/admin_speakers = list()

/datum/controller/subsystem/tts/proc/valid_voice_list(list/voices)
	var/list/valid = list()
	if(!islist(voices))
		return valid
	for(var/voice in voices)
		if(voice in available_speakers)
			valid += voice
	return valid

/datum/controller/subsystem/tts/proc/refresh_voice_pools()
	var/list/admin_only = valid_voice_list(CONFIG_GET(str_list/admin_voices))

	var/list/reserved = list()
	for(var/voice in admin_only)
		reserved |= voice

	player_speakers = list()
	for(var/voice in available_speakers)
		if(!(voice in reserved))
			player_speakers += voice
	if(!length(player_speakers))
		player_speakers = available_speakers.Copy()

	admin_speakers = player_speakers.Copy()
	for(var/voice in admin_only)
		admin_speakers |= voice
	if(!length(admin_speakers))
		admin_speakers = available_speakers.Copy()

/datum/controller/subsystem/tts/proc/player_voice_choices()
	return length(player_speakers) ? player_speakers.Copy() : available_speakers.Copy()

/datum/controller/subsystem/tts/proc/admin_voices()
	return length(admin_speakers) ? admin_speakers.Copy() : available_speakers.Copy()



/datum/controller/subsystem/tts/proc/random_from_voices(list/voices, gender = NEUTER)
	if(!length(voices))
		return null

	var/list/gendered = list()
	for(var/voice in voices)
		if(gender == MALE && (findtext(voice, "Man") || findtext(voice, "Male")))
			if(findtext(voice, "Woman")) // someone told me that findtext() will find woman if man is in string
				continue
			gendered += voice
		else if(gender == FEMALE && (findtext(voice, "Woman") || findtext(voice, "Female")))
			gendered += voice

	if(length(gendered))
		return pick(gendered)
	return pick(voices)

/datum/controller/subsystem/tts/random_tts_voice(gender = NEUTER)
	if(!tts_enabled)
		return null
	return random_from_voices(player_voice_choices(), gender)

/datum/controller/subsystem/tts/random_vendor_voice()
	if(!tts_enabled)
		return null

	for(var/voice in available_speakers)
		if(findtext(voice, "Glados"))
			return voice
	return random_from_voices(player_voice_choices())
