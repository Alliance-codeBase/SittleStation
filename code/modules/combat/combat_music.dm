/client
	var/combat_music_started = 0
	var/combat_music_last_use = 0
	var/combat_music_track
	var/combat_music_playing = FALSE

#define COMBAT_MUSIC_CHANNEL 1009

/proc/get_combat_track(mob/living/M)

	if(M.mind?.has_antag_datum(/datum/antagonist/traitor))
		return 'sound/music/combat/traitor.ogg'

	switch(M.mind?.assigned_role)

		if("Station Engineer")
			return 'sound/music/combat/engineer.ogg'

		if("Security Officer")
			return 'sound/music/combat/security.ogg'

	return 'sound/music/combat/default.ogg'

/mob/living/proc/start_combat_music(client/C)

	if(!client)
		return

	if(C.combat_music_playing)
		return

	spawn(15)
		var/reset_time = 1800

		if(world.time > C.combat_music_last_use + reset_time)
			C.combat_music_started = world.time

		C.combat_music_last_use = world.time

		C.combat_music_track = get_combat_track(src)

		C.combat_music_playing = TRUE

		C << sound(
			C.combat_music_track,
			repeat = 1,
			wait = 0,
			volume = 70,
			channel = COMBAT_MUSIC_CHANNEL
		)

/mob/living/proc/stop_combat_music(client/C)

	if(!client)
		return

	C.combat_music_last_use = world.time
	C.combat_music_playing = FALSE

	C << sound(null, channel = COMBAT_MUSIC_CHANNEL)
