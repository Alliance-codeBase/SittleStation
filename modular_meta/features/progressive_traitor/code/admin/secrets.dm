/datum/everyone_is_an_antag_controller/make_antag(datum/source, mob/living/player)
	if(player.stat == DEAD || !player.mind)
		return
	sleep(1)
	if(ishuman(player))
		switch(chosen_antag)
			if(ROLE_TRAITOR)
				var/datum/antagonist/traitor/antag_datum = new(give_objectives = keep_generic_objecives)
				assign_admin_objective_and_antag(player, antag_datum)
				var/datum/uplink_handler/uplink = antag_datum.uplink_handler
				uplink.has_progression = FALSE
				//MASSMETA EDIT ADDITION BEGIN (progressive_traitor)
				uplink.has_objectives = FALSE
				//MASSMETA EDIT ADDITION END (progressive_traitor)
			if(ROLE_CHANGELING)
				var/datum/antagonist/changeling/antag_datum = new
				antag_datum.give_objectives = keep_generic_objecives
				assign_admin_objective_and_antag(player, antag_datum)
			if(ROLE_HERETIC)
				var/datum/antagonist/heretic/antag_datum = new
				antag_datum.give_objectives = keep_generic_objecives
				assign_admin_objective_and_antag(player, antag_datum)
			if(ROLE_CULTIST)
				var/datum/antagonist/cult/antag_datum = new
				assign_admin_objective_and_antag(player, antag_datum)
			if(ROLE_NINJA)
				var/datum/antagonist/ninja/antag_datum = new
				antag_datum.give_objectives = keep_generic_objecives
				for(var/obj/item/item_to_drop in player)
					if(!istype(item_to_drop, /obj/item/implant)) //avoid removing implanted uplinks
						player.dropItemToGround(item_to_drop, FALSE)
				assign_admin_objective_and_antag(player, antag_datum)
			if(ROLE_WIZARD)
				var/datum/antagonist/wizard/antag_datum = new
				antag_datum.give_objectives = keep_generic_objecives
				antag_datum.move_to_lair = FALSE
				for(var/obj/item/item_to_drop in player) //avoid deleting player's items
					if(!istype(item_to_drop, /obj/item/implant))
						player.dropItemToGround(item_to_drop, FALSE)
				assign_admin_objective_and_antag(player, antag_datum)
			if(ROLE_NIGHTMARE)
				var/datum/antagonist/nightmare/antag_datum = new
				assign_admin_objective_and_antag(player, antag_datum)
				player.set_species(/datum/species/shadow/nightmare)

	else if(isAI(player))
		var/datum/antagonist/malf_ai/antag_datum = new
		antag_datum.give_objectives = keep_generic_objecives
		assign_admin_objective_and_antag(player, antag_datum)
