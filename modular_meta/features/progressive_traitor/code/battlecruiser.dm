/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/corvette/attack_hand(mob/user, list/modifiers)
	. = ..()
	var/station_loc = SSmapping.get_station_center()
	eyeobj.setLoc(station_loc, TRUE) // you were one button away from nuking the station, and you still had me to do this

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter_three/attack_hand(mob/user, list/modifiers)
	. = ..()
	var/station_loc = SSmapping.get_station_center()
	eyeobj.setLoc(station_loc, TRUE)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter_two/attack_hand(mob/user, list/modifiers)
	. = ..()
	var/station_loc = SSmapping.get_station_center()
	eyeobj.setLoc(station_loc, TRUE)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter_one/attack_hand(mob/user, list/modifiers)
	. = ..()
	var/station_loc = SSmapping.get_station_center()
	eyeobj.setLoc(station_loc, TRUE)

// yeah let's call an async function on a something that haven't properly initialized yet, very good
/obj/docking_port/stationary/starfury_fighter/LateInitialize()
    return

/obj/docking_port/stationary/starfury_corvette/LateInitialize()
    return
