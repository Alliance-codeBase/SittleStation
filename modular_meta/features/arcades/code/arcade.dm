/obj/machinery/computer/arcade/doom
	name = "Demons Occupied Our Marines"
	desc = "Legendary shooter, runs on ancient magic and CSS."
	icon_state = "arcade"
	icon_screen = "fighters"
	circuit = /obj/item/circuitboard/computer/arcade/doom

/obj/machinery/computer/arcade/doom/ui_interact(mob/user, datum/tgui/ui)
	if(machine_stat & (NOPOWER|BROKEN))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CssDoom", name)
		ui.open()

/obj/machinery/computer/arcade/doom/ui_data(mob/user)
	return list()

/obj/machinery/computer/arcade/doom/ui_act(action, list/params, datum/tgui/ui, datum/ui_status/status)
	if(..())
		return TRUE
	return FALSE

/obj/item/circuitboard/computer/arcade/doom
	name = "Demons Occupied Our Marines"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/arcade/doom

/obj/effect/spawner/random/entertainment/arcade
	name = "spawn random arcade machine"
	desc = "Automagically transforms into a random arcade machine. If you see this while in a shift, please create a bug report."
	icon_state = "arcade"
	loot = list(
		/obj/machinery/computer/arcade/orion_trail = 32,
		/obj/machinery/computer/arcade/battle = 32,
		/obj/machinery/computer/arcade/doom = 32,
		/obj/machinery/computer/arcade/amputation = 4,
	)
