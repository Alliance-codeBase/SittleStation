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

/datum/design/board/doom
	name = "Demons Occupied Our Marines Machine Board"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "arcade_doom"
	build_path = /obj/item/circuitboard/computer/arcade/doom
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/obj/effect/spawner/random/techstorage/arcade_boards
	name = "arcade board spawner"
	spawn_all_loot = FALSE
	spawn_loot_count = 1
	loot = list(
		/obj/item/circuitboard/computer/arcade/amputation,
		/obj/item/circuitboard/computer/arcade/battle,
		/obj/item/circuitboard/computer/arcade/orion_trail,
		/obj/item/circuitboard/computer/arcade/doom,
	)

/obj/effect/spawner/random/techstorage/service_all
	name = "service circuit board spawner"
	loot = list(
		/obj/item/circuitboard/computer/arcade/battle,
		/obj/item/circuitboard/computer/arcade/orion_trail,
		/obj/item/circuitboard/computer/arcade/doom,
		/obj/item/circuitboard/machine/autolathe,
		/obj/item/circuitboard/computer/mining,
		/obj/item/circuitboard/machine/ore_redemption,
		/obj/item/circuitboard/computer/order_console/mining,
		/obj/item/circuitboard/machine/microwave,
		/obj/item/circuitboard/machine/microwave/engineering,
		/obj/item/circuitboard/machine/deep_fryer,
		/obj/item/circuitboard/machine/griddle,
		/obj/item/circuitboard/machine/reagentgrinder,
		/obj/item/circuitboard/machine/oven,
		/obj/item/circuitboard/machine/stove,
		/obj/item/circuitboard/machine/processor,
		/obj/item/circuitboard/machine/gibber,
		/obj/item/circuitboard/machine/chem_dispenser/drinks,
		/obj/item/circuitboard/machine/chem_dispenser/drinks/beer,
		/obj/item/circuitboard/computer/slot_machine,
	)

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
