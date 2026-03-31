///How long Sol will last until it's night again.
#define TIME_BLOODSUCKER_DAY 60
///Base time nighttime should be in for, until Sol rises.
#define TIME_BLOODSUCKER_NIGHT 600

///How much time Sol can be 'off' by, keeping the time inconsistent.
#define TIME_BLOODSUCKER_SOL_DELAY 120

SUBSYSTEM_DEF(sunlight)
	name = "Sol"
	can_fire = FALSE
	wait = 2 SECONDS
	flags = SS_NO_INIT | SS_BACKGROUND | SS_TICKER

	///If the Sun is currently out our not.
	var/sunlight_active = FALSE
	///The time between the next cycle, randomized every night.
	var/time_til_cycle = TIME_BLOODSUCKER_NIGHT
	///If Bloodsucker levels for the night has been given out yet.
	var/issued_XP = FALSE

/datum/controller/subsystem/sunlight/fire(resumed = FALSE)
	time_til_cycle--
	if(sunlight_active)
		if(time_til_cycle > 0)
			SEND_SIGNAL(src, COMSIG_SOL_RISE_TICK)
			if(!issued_XP && time_til_cycle <= 15)
				issued_XP = TRUE
				SEND_SIGNAL(src, COMSIG_SOL_RANKUP_BLOODSUCKERS)
		if(time_til_cycle <= 1)
			sunlight_active = FALSE
			issued_XP = FALSE
			//randomize the next sol timer
			time_til_cycle = round(rand((TIME_BLOODSUCKER_NIGHT-TIME_BLOODSUCKER_SOL_DELAY), (TIME_BLOODSUCKER_NIGHT+TIME_BLOODSUCKER_SOL_DELAY)), 60)
			message_admins("BLOODSUCKER NOTICE: Daylight Ended. Resetting to night (Lasts for [time_til_cycle / 60] minutes.")
			SEND_SIGNAL(src, COMSIG_SOL_END)
			warn_daylight(
				danger_level = DANGER_LEVEL_SOL_ENDED,
				vampire_warning_message = span_announce("Cycle of Night and Day ended."),
				vassal_warning_message = span_announce("Cycle of Night and Day ended."),
			)
		return

	switch(time_til_cycle)
		if(NONE)
			sunlight_active = TRUE
			//set the timer to countdown daytime now.
			time_til_cycle = TIME_BLOODSUCKER_DAY
			warn_daylight(
				vampire_warning_message = span_userdanger("Cycle of Night and Day started, next [TIME_BLOODSUCKER_DAY / 60] minutes will be daytime"),
				vassal_warning_message = span_userdanger("Time is Day now!"),
			)
/datum/controller/subsystem/sunlight/proc/warn_daylight(danger_level, vampire_warning_message, vassal_warning_message)
	SEND_SIGNAL(src, COMSIG_SOL_WARNING_GIVEN, danger_level, vampire_warning_message, vassal_warning_message)

#undef TIME_BLOODSUCKER_SOL_DELAY
#undef TIME_BLOODSUCKER_NIGHT
