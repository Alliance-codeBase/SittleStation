/obj/item/circuitboard/computer/telesci_console
	name = "Telescience Control Console"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/telescience

/obj/machinery/computer/telescience
	name = "Telepad console"
	desc = "Technology of teleportation between sectors. To work, you need to connect the telepad and insert bluespace crystals."
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	circuit = /obj/item/circuitboard/computer/telesci_console
	var/sending = 1
	var/obj/machinery/telepad/telepad = null
	var/temp_msg = "Hello! The console has been initialized, please connect the telepad."

	// VARIABLES //
	var/teles_left	// How many teleports left until it becomes uncalibrated
	var/datum/projectile_data/last_tele_data = null
	var/z_co = 1
	var/power_off
	var/rotation_off
	var/last_target

	var/rotation = 0
	var/angle = 45
	var/power = 5

	// Based on the power used
	var/teleport_cooldown = 0 // every index requires a bluespace crystal
	var/list/power_options = list(5, 10, 20, 25, 30, 40, 50, 80, 100)
	var/teleporting = 0
	var/starting_crystals = 4
	var/max_crystals = 4
	var/crystals = 0
	var/obj/item/gps/inserted_gps

/obj/machinery/computer/telescience/Initialize(mapload)
	recalibrate()
	. = ..()
	AddComponent(/datum/component/usb_port, list(
		/obj/item/circuit_component/telepad_console,
	))

/obj/machinery/computer/telescience/Destroy()
	eject()
	if(inserted_gps)
		inserted_gps.loc = loc
		inserted_gps = null
	return ..()

/obj/machinery/computer/telescience/examine(mob/user)
	. = ..()
	if(crystals == 0)
		. += "<hr>There are no bluespace crystals inside. Insert at least one for it to work."
	else
		. += "<hr>Inside [crystals ? crystals : "0"] bluespace crystals."

/obj/machinery/computer/telescience/Initialize(mapload)
	. = ..()
	if(mapload)
		crystals = starting_crystals

/obj/machinery/computer/telescience/attack_paw(mob/user)
	to_chat(user, span_warning("Your paws are too imprecise to use this."))
	return

/obj/machinery/computer/telescience/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/ore/bluespace_crystal) || istype(W, /obj/item/stack/sheet/bluespace_crystal))
		if(crystals >= max_crystals)
			to_chat(user, span_warning("Too many crystals inserted."))
			return
		var/obj/item/stack/BC = W
		if(!BC.amount)
			to_chat(user, span_warning("HOW?"))
			return
		crystals++
		BC.use(1)
		user.visible_message("[user] insert [W] in <b>[src.name]</b>.", span_notice("You insert [W] in <b>[src.name]</b>."))
		// updateDialog() // Я надеюсь всё не развалится нахуй
	else if(istype(W, /obj/item/gps))
		if(!inserted_gps)
			if(!user.transferItemToLoc(W, src))
				return
			inserted_gps = W
			user.visible_message("[user] insert [W] in <b>[src.name]</b>.", span_notice("You insert [W] in <b>[src.name]</b>."))
	else if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/M = W
		if(M.buffer && istype(M.buffer, /obj/machinery/telepad))
			telepad = M.buffer
			M.buffer = null
			to_chat(user, span_notice("Выгружаю данные из буффера [W.name] в консоль."))
	else
		return ..()

/obj/machinery/computer/telescience/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelesciComputer", name)
		ui.open()

/obj/machinery/computer/telescience/ui_data()
	var/list/data = list()
	data["telepad"] = telepad
	data["power_options"] = power_options
	data["efficiency"] = telepad?.efficiency
	data["crystals"] = crystals
	data["z_co"] = z_co
	data["angle"] = angle
	data["rotation"] = rotation
	data["power"] = power
	data["temp_msg"] = temp_msg
	data["inserted_gps"] = inserted_gps
	data["teleporting"] = teleporting
	data["last_tele_data"] = last_tele_data
	data["src_x"] = last_tele_data?.src_x
	data["src_y"] = last_tele_data?.src_y
	data["timedata"] = round(last_tele_data?.time, 0.1)
	return data

/obj/machinery/computer/telescience/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(telepad.panel_open)
		temp_msg = list("ERROR: Telepad undergoing physical maintenance operations.")
		return
	switch(action)
		if("setrotation")
			var/new_rot = text2num(params["newrotation"])
			rotation = clamp(new_rot, -900, 900)
			rotation = round(rotation, 0.01)
			. = TRUE
		if("setangle")
			var/new_angle = text2num(params["newangle"])
			angle = clamp(round(new_angle, 0.1), 1, 9999)
			. = TRUE
		if("setpower")
			var/new_power = text2num(params["newpower"])
			power = new_power
			. = TRUE
		if("setz")
			var/new_z = text2num(params["newz"])
			z_co = clamp(round(new_z), 1, 13)
			. = TRUE
		if("ejectGPS")
			if(inserted_gps)
				inserted_gps.loc = loc
				inserted_gps = null
			. = TRUE
		if("setMemory")
			if(last_target && inserted_gps)
				//inserted_gps.locked_location = last_target
				temp_msg = "WARNING: The location is not preserved."
			else
				temp_msg = "ERROR: No data found."
			. = TRUE
		if("send")
			sending = 1
			teleport(usr)
			. = TRUE
		if("receive")
			sending = 0
			teleport(usr)
			. = TRUE
		if("recal")
			recalibrate()
			sparks()
			temp_msg = "NOTICE: Calibration successful."
			. = TRUE
		if("eject")
			if(eject())
				temp_msg = list("NOTICE: Bluespace crystals ejected.")
			else
				temp_msg = list("ERROR: There are no crystals on the machine")
			. = TRUE

/obj/machinery/computer/telescience/proc/sparks()
	if(telepad)
		do_sparks(5, TRUE, get_turf(telepad))

/obj/machinery/computer/telescience/proc/telefail()
	sparks()
	visible_message(span_warning("The telepad sparks faintly."))

/obj/machinery/computer/telescience/proc/doteleport(mob/user)

	if(teleport_cooldown > world.time)
		temp_msg = "Telepad is recharging. Please wait [round((teleport_cooldown - world.time) / 10)] second(s)."
		return

	if(teleporting)
		temp_msg = "Telepad is active, please wait."
		return

	if(telepad)

		var/truePower = clamp(power + power_off, 1, 1000)
		var/trueRotation = rotation + rotation_off
		var/trueAngle = clamp(angle, 1, 90)

		var/datum/projectile_data/proj_data = projectile_trajectory(telepad.x, telepad.y, trueRotation, trueAngle, truePower)
		last_tele_data = proj_data

		var/trueX = clamp(round(proj_data.dest_x, 1), 1, world.maxx)
		var/trueY = clamp(round(proj_data.dest_y, 1), 1, world.maxy)
		var/spawn_time = round(proj_data.time) * 10

		var/turf/target = locate(trueX, trueY, z_co)
		last_target = target
		var/area/A = get_area(target)
		flick("pad-beam", telepad)

		if(spawn_time > 15) // 1.5 seconds
			playsound(telepad.loc, 'sound/items/weapons/flash.ogg', 25, 1)
			// Wait depending on the time the projectile took to get there
			teleporting = 1
			temp_msg = "Charging bluespace crystals, please wait."

		spawn(round(proj_data.time) * 10) // in seconds
			if(!telepad)
				return
			if(telepad.machine_stat & NOPOWER)
				return
			teleporting = 0
			teleport_cooldown = world.time + (power * 2)
			teles_left -= 1

			// use a lot of power
			use_energy(power * 10)

			do_sparks(5, TRUE, get_turf(telepad))

			temp_msg = "Teleportation successful."
			if(teles_left < 10)
				temp_msg += " Calibration will be required."
			else
				temp_msg += " Data is being output."

			do_sparks(5, TRUE, get_turf(target))

			var/turf/source = target
			var/turf/dest = get_turf(telepad)
			var/log_msg = ""
			log_msg += ": [key_name(user)] has teleported "

			if(sending)
				source = dest
				dest = target

			flick("pad-beam", telepad)
			playsound(telepad.loc, 'sound/items/weapons/emitter2.ogg', 25, 1, extrarange = 3)
			for(var/atom/movable/ROI in source)
				// if is anchored, don't let through
				if(ROI.anchored)
					if(isliving(ROI))
						var/mob/living/L = ROI
						if(L.buckled)
							// TP people on office chairs
							if(L.buckled.anchored)
								continue

							log_msg += "[key_name(L)] (on a chair), "
						else
							continue
					else if(!isobserver(ROI))
						continue
				if(ismob(ROI))
					var/mob/T = ROI
					log_msg += "[key_name(T)], "
				else
					log_msg += "[ROI.name]"
					if (istype(ROI, /obj/structure/closet))
						var/obj/structure/closet/C = ROI
						log_msg += " ("
						for(var/atom/movable/Q as mob|obj in C)
							if(ismob(Q))
								log_msg += "[key_name(Q)], "
							else
								log_msg += "[Q.name], "
						if (dd_hassuffix(log_msg, "("))
							log_msg += "empty)"
						else
							log_msg = dd_limittext(log_msg, length(log_msg) - 2)
							log_msg += ")"
					log_msg += ", "
				do_teleport(ROI, dest)

			if (dd_hassuffix(log_msg, ", "))
				log_msg = dd_limittext(log_msg, length(log_msg) - 2)
			else
				log_msg += "nothing"
			log_msg += " [sending ? "to" : "from"] [trueX], [trueY], [z_co] ([A ? A.name : "null area"])"
			investigate_log(log_msg, "telesci")
			// updateDialog() // Я надеюсь всё не развалится нахуй

/obj/machinery/computer/telescience/proc/teleport(mob/user)
	if(rotation == null || angle == null || z_co == null)
		temp_msg = "ERROR: Set rotation, angle and sector."
		return
	if(power <= 0)
		telefail()
		temp_msg = "ERROR: Not enough energy!"
		return
	if(angle < 1 || angle > 90)
		telefail()
		temp_msg = "ERROR: The angle is less than one or more than 90 degrees."
		return
	if(z_co == 1 || z_co < 1 || z_co > 13)
		telefail()
		temp_msg = "ERROR: Sector unavailable!"
		return
	if(teles_left > 0)
		doteleport(user)
		return
	else
		telefail()
		temp_msg = "ERROR: Calibration required."
		return

/obj/machinery/computer/telescience/proc/eject()
	for(var/i in 1 to crystals)
		new /obj/item/stack/ore/bluespace_crystal(drop_location())
	crystals = 0
	power = 0

/obj/machinery/computer/telescience/proc/recalibrate()
	teles_left = rand(30, 40)
	power_off = rand(-4, 0)
	rotation_off = rand(-10, 10)
