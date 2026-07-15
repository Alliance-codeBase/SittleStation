/datum/preference/choiced/voice/init_possible_values()
	if(SStts.tts_enabled)
		return SStts.admin_voices()
	if(fexists("data/cached_tts_voices.json"))
		var/list/text_data = rustg_file_read("data/cached_tts_voices.json")
		var/list/cached_data = json_decode(text_data)
		if(!cached_data)
			return list("invalid")
		return cached_data
	return list("invalid")

/datum/preference/choiced/voice/apply_to_human(mob/living/carbon/human/target, value)
	if(SStts.tts_enabled)
		var/is_admin = target.client?.holder
		var/list/allowed = is_admin ? SStts.admin_voices() : SStts.player_voice_choices()
		if(!(value in allowed))
			value = SStts.random_tts_voice(target.gender)
	target.voice = value

/datum/preference/choiced/voice/compile_constant_data()
	. = ..()
	var/list/categories = list()
	for(var/voice in .["choices"])
		categories[voice] = SStts.voice_categories[voice] || "other"
	.["categories"] = categories
