#define CHANNEL_SOUNDTRACK		1015

/proc/play_soundtrack_music(sound_path, list/hearers = null, volume = 80, ignore_prefs = FALSE, play_to_lobby = FALSE, allow_deaf = TRUE, only_station = FALSE)
	var/sound/S = sound(sound_path, volume=volume, wait=0, channel=CHANNEL_SOUNDTRACK)
	. = S
	if(!hearers)
		hearers = GLOB.player_list

	for(var/mob/M as() in hearers)
		if (!ismob(M))
			continue

		if (!ignore_prefs && !(M.client?.prefs?.toggles & CHANNEL_AMBIENCE))
			continue

		if (!play_to_lobby && isnewplayer(M))
			continue

		if (!allow_deaf && !M.can_hear())
			continue

		if (only_station && !is_station_level(M.z))
			continue

		SEND_SOUND(M, S)

/proc/stop_soundtrack_music()
	for(var/mob/M as() in GLOB.player_list)
		M?.stop_sound_channel(CHANNEL_SOUNDTRACK)


/obj/item/nuclear_challenge/war_was_declared(mob/living/user, memo)
	. = ..()
	play_soundtrack_music('modular_meta/features/countdown_antimov_sfx/sound/soundtrack/future_perception.ogg')

/obj/machinery/nuclearbomb
	var/sound/countdown_music = null

/obj/machinery/nuclearbomb/arm_nuke(mob/armer)
	. = ..()
	countdown_music = play_soundtrack_music('modular_meta/features/countdown_antimov_sfx/sound/soundtrack/countdown.ogg')
