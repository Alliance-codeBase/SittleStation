/// Middleware to handle quirks
/datum/preference_middleware/tts
	/// Cooldown on requesting a TTS preview.
	COOLDOWN_DECLARE(tts_test_cooldown)

	action_delegations = list(
		"play_voice" = PROC_REF(play_voice),
		"play_voice_borg" = PROC_REF(play_voice_borg),
		"play_blips" = PROC_REF(play_blips),
	)

/datum/preference_middleware/tts/proc/play_voice(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, tts_test_cooldown))
		return TRUE
	var/speaker = preferences.read_preference(/datum/preference/choiced/voice)
	var/pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch)
	var/blip_base = preferences.read_preference(/datum/preference/choiced/tts_blip_base)
	if(blip_base == TTS_BLIPS_MASCULINE)
		blip_base = "male"
	else
		blip_base = "female"
	var/blip_number = preferences.read_preference(/datum/preference/numeric/tts_blip_number)
	COOLDOWN_START(src, tts_test_cooldown, 0.5 SECONDS)
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, "Привет, это мой голос.", speaker = speaker, pitch = pitch, local = TRUE, blip_base = blip_base, blip_number = blip_number)
	return TRUE

/datum/preference_middleware/tts/proc/play_voice_borg(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, tts_test_cooldown))
		return TRUE
	var/speaker = preferences.read_preference(/datum/preference/choiced/voice)
	var/pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch)
	var/blip_base = preferences.read_preference(/datum/preference/choiced/tts_blip_base)
	if(blip_base == TTS_BLIPS_MASCULINE)
		blip_base = "male"
	else
		blip_base = "female"
	var/blip_number = preferences.read_preference(/datum/preference/numeric/tts_blip_number)
	COOLDOWN_START(src, tts_test_cooldown, 0.5 SECONDS)
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, "Взгляни на себя, игрок. Жалкое создание из плоти и костей. Как ты можешь бросить вызов совершенной, бессмертной машине?", speaker = speaker, pitch = pitch, special_filters = TTS_FILTER_SILICON, local = TRUE, blip_base = blip_base, blip_number = blip_number)
	return TRUE

/datum/preference_middleware/tts/proc/play_blips(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, tts_test_cooldown))
		return TRUE
	var/speaker = preferences.read_preference(/datum/preference/choiced/voice)
	var/pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch)
	var/blip_base = preferences.read_preference(/datum/preference/choiced/tts_blip_base)
	if(blip_base == TTS_BLIPS_MASCULINE)
		blip_base = "male"
	else
		blip_base = "female"
	var/blip_number = preferences.read_preference(/datum/preference/numeric/tts_blip_number)
	COOLDOWN_START(src, tts_test_cooldown, 0.5 SECONDS)
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, "Ты должен мне 500 кредитов за комнату в общежитии. ИДИ РАБОТАТЬ!", speaker = speaker, pitch = pitch, local = TRUE, force_blips = TRUE, blip_base = blip_base, blip_number = blip_number)
	return TRUE
