/mob/living/silicon/Initialize(mapload)
	..()
	if (check_holidays(APRIL_FOOLS))
		death_sound = 'modular_meta/features/april_fools_day/borgs/sound/windows-xp-shutdown.ogg'

/datum/emote/silicon/beep/get_sound(mob/living/user)
	if (check_holidays(APRIL_FOOLS))
		return 'modular_meta/features/april_fools_day/borgs/sound/windows-xp-hardware-moddif.ogg'
	return ..()

/datum/emote/silicon/buzz/get_sound(mob/living/user)
	if (check_holidays(APRIL_FOOLS))
		return 'modular_meta/features/april_fools_day/borgs/sound/windows-xp-battery-low.ogg'
	return ..()

/datum/emote/silicon/buzz2/get_sound(mob/living/user)
	if (check_holidays(APRIL_FOOLS))
		return 'modular_meta/features/april_fools_day/borgs/sound/windows-xp-battery-critical.ogg'
	return ..()

/datum/emote/silicon/chime/get_sound(mob/living/user)
	if (check_holidays(APRIL_FOOLS))
		return 'modular_meta/features/april_fools_day/borgs/sound/windows-xp-chime-moddif.ogg'
	return ..()

/datum/emote/silicon/ping/get_sound(mob/living/user)
	if (check_holidays(APRIL_FOOLS))
		return 'modular_meta/features/april_fools_day/borgs/sound/windows-xp-error.ogg'
	return ..()

/datum/emote/silicon/sad/get_sound(mob/living/user)
	if (check_holidays(APRIL_FOOLS))
		return 'modular_meta/features/april_fools_day/borgs/sound/windows-xp-sad-moddif.ogg'
	return ..()

/datum/emote/silicon/warn/get_sound(mob/living/user)
	if (check_holidays(APRIL_FOOLS))
		return 'modular_meta/features/april_fools_day/borgs/sound/windows-xp-warning-modif.ogg'
	return ..()
