/obj/item/disk/computer/virus/frame/send_virus(obj/item/modular_computer/pda/source, obj/item/modular_computer/pda/target, mob/living/user, message)
	. = ..()
	if(!.)
		return FALSE

	charges--
	var/unlock_code = "[rand(100,999)] [pick(GLOB.phonetic_alphabet)]"
	to_chat(user, span_notice("Success! The unlock code to the target is: [unlock_code]"))
	var/datum/component/uplink/hidden_uplink = target.GetComponent(/datum/component/uplink)
	if(!hidden_uplink)
		var/datum/mind/target_mind
		var/list/backup_players = list()
		for(var/datum/mind/player as anything in get_crewmember_minds())
			if(player.assigned_role?.title == target.saved_job)
				backup_players += player
			if(player.name == target.saved_identification)
				target_mind = player
				break
		if(!target_mind)
			if(!length(backup_players))
				target_mind = user.mind
			else
				target_mind = pick(backup_players)
		hidden_uplink = target.AddComponent(/datum/component/uplink, target_mind, enabled = TRUE, starting_tc = telecrystals, has_progression = TRUE)
		hidden_uplink.unlock_code = unlock_code
		//MASSMETA EDIT ADDITION BEGIN (progressive_traitor)
		hidden_uplink.uplink_handler.has_objectives = TRUE
		hidden_uplink.uplink_handler.owner = target_mind
		hidden_uplink.uplink_handler.can_take_objectives = FALSE
		hidden_uplink.uplink_handler.progression_points = min(SStraitor.current_global_progression, current_progression)
		hidden_uplink.uplink_handler.generate_objectives()
		//MASSMETA EDIT ADDITION END (progressive_traitor)
		SStraitor.register_uplink_handler(hidden_uplink.uplink_handler)
	else
		hidden_uplink.uplink_handler.add_telecrystals(telecrystals)
	telecrystals = 0
	hidden_uplink.locked = FALSE
	hidden_uplink.active = TRUE
