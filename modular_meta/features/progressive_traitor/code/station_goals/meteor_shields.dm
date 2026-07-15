/obj/machinery/satellite/meteor_shield/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		balloon_alert(user, "already emagged!")
		return FALSE
	if(!COOLDOWN_FINISHED(src, shared_emag_cooldown))
		balloon_alert(user, "on cooldown!")
		to_chat(user, span_warning("The last satellite emagged needs [DisplayTimeText(COOLDOWN_TIMELEFT(src, shared_emag_cooldown))] to recalibrate first. Emagging another so soon could damage the satellite network."))
		return FALSE
	var/cooldown_applied = 1 MINUTES

	//MASSMETA EDIT ADDITION BEGIN (progressive_traitor)

	if(istype(emag_card, /obj/item/card/emag/meteor_shield_recalibrator))
		cooldown_applied /= 3

	//MASSMETA EDIT ADDITION END (progressive_traitor)

	COOLDOWN_START(src, shared_emag_cooldown, cooldown_applied)
	obj_flags |= EMAGGED
	to_chat(user, span_notice("You access the satellite's debug mode and it begins emitting a strange signal, increasing the chance of meteor strikes."))
	AddComponent(/datum/component/gps, "Corrupted Meteor Shield Attraction Signal")
	say("Recalibrating... ETA:[DisplayTimeText(cooldown_applied)].")
	if(active) //if we allowed inactive updates a sat could be worth -1 active meteor shields on first emag
		update_emagged_meteor_sat(user)
	return TRUE
