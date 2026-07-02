/obj/item/circuitboard/machine/telesci_pad
	name = "Telepad"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/telepad
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 2,
		/datum/stock_part/capacitor = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1,
	)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

///SCI TELEPAD///
/obj/machinery/telepad
	name = "telepad"
	desc = "A bluespace telepad used for teleporting objects to and from a location."
	icon = 'icons/obj/machines/telepad.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 5000
	circuit = /obj/item/circuitboard/machine/telesci_pad
	var/efficiency

/obj/machinery/telepad/RefreshParts()
	. = ..()
	var/E
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		E += capacitor.tier
	efficiency = E

/obj/machinery/telepad/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "pad-idle-open", "pad-idle", I))
		return
	if(exchange_parts(user, I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/telepad/multitool_act(mob/living/user, obj/item/multitool/multi)
	. = NONE
	if(!panel_open)
		return

	multi.set_buffer(src)
	balloon_alert(user, "saved to buffer")
	return ITEM_INTERACT_SUCCESS
