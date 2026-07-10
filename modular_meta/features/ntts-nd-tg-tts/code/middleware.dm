/datum/preference_middleware/tts/New(datum/preferences/preferences)
	. = ..()
	action_delegations = action_delegations.Copy()
	action_delegations["open_tts_voice_picker"] = PROC_REF(open_voice_picker)

/datum/preference_middleware/tts/proc/open_voice_picker(list/params, mob/user)
	var/datum/tts_voice_picker/picker = new(src)
	picker.ui_interact(user)
	return TRUE

/datum/preference_middleware/tts/play_voice(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, tts_test_cooldown))
		return TRUE
	var/speaker = params["voice"]
	var/message = params["message"]
	var/pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch)
	var/blip_base = preferences.read_preference(/datum/preference/choiced/tts_blip_base)
	if(blip_base == TTS_BLIPS_MASCULINE)
		blip_base = "male"
	else
		blip_base = "female"
	var/blip_number = preferences.read_preference(/datum/preference/numeric/tts_blip_number)
	COOLDOWN_START(src, tts_test_cooldown, 0.5 SECONDS)
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, message, speaker = speaker, pitch = pitch, local = TRUE, blip_base = blip_base, blip_number = blip_number)
	return TRUE

/datum/preference_middleware/tts/play_voice_borg(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, tts_test_cooldown))
		return TRUE
	var/speaker = params["voice"]
	var/message = params["message"]
	var/pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch)
	var/blip_base = preferences.read_preference(/datum/preference/choiced/tts_blip_base)
	if(blip_base == TTS_BLIPS_MASCULINE)
		blip_base = "male"
	else
		blip_base = "female"
	var/blip_number = preferences.read_preference(/datum/preference/numeric/tts_blip_number)
	COOLDOWN_START(src, tts_test_cooldown, 0.5 SECONDS)
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, message, speaker = speaker, pitch = pitch, special_filters = TTS_FILTER_SILICON, local = TRUE, blip_base = blip_base, blip_number = blip_number)
	return TRUE

/datum/preference_middleware/tts/play_blips(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, tts_test_cooldown))
		return TRUE
	var/speaker = params["voice"]
	var/message = params["message"]
	var/pitch = preferences.read_preference(/datum/preference/numeric/tts_voice_pitch)
	var/blip_base = preferences.read_preference(/datum/preference/choiced/tts_blip_base)
	if(blip_base == TTS_BLIPS_MASCULINE)
		blip_base = "male"
	else
		blip_base = "female"
	var/blip_number = preferences.read_preference(/datum/preference/numeric/tts_blip_number)
	COOLDOWN_START(src, tts_test_cooldown, 0.5 SECONDS)
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, message, speaker = speaker, pitch = pitch, local = TRUE, force_blips = TRUE, blip_base = blip_base, blip_number = blip_number)
	return TRUE
