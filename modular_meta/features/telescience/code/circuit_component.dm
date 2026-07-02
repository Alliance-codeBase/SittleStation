/obj/item/circuit_component/telepad_console
	display_name = "Telepad Console"
	desc = "Technology of teleportation between sectors. To work, you need to connect the telepad and insert bluespace crystals."

	var/datum/port/input/elevation
	var/datum/port/input/rotation
	var/datum/port/input/power
	var/datum/port/input/sector

	var/datum/port/input/send_trigger
	var/datum/port/input/retrieve_trigger

	var/datum/port/output/sent
	var/datum/port/output/retrieved
	var/datum/port/output/on_fail
	var/datum/port/output/status

	var/obj/machinery/computer/telescience/attached_console

/obj/item/circuit_component/telepad_console/Initialize(mapload)
	. = ..()
	elevation = add_input_port("Elevation", PORT_TYPE_NUMBER)
	rotation = add_input_port("Rotation", PORT_TYPE_NUMBER)
	power = add_input_port("Power", PORT_TYPE_NUMBER)
	sector = add_input_port("Sector", PORT_TYPE_NUMBER)

	send_trigger = add_input_port("Send", PORT_TYPE_SIGNAL)
	retrieve_trigger = add_input_port("Retrieve", PORT_TYPE_SIGNAL)

	sent = add_output_port("Sent", PORT_TYPE_SIGNAL)
	retrieved = add_output_port("Retrieved", PORT_TYPE_SIGNAL)
	on_fail = add_output_port("Failed", PORT_TYPE_SIGNAL)
	status = add_output_port("Status", PORT_TYPE_STRING)

/obj/item/circuit_component/telepad_console/Destroy()
	elevation = null
	rotation = null
	power = null
	sector = null
	send_trigger = null
	retrieve_trigger = null
	sent = null
	retrieved = null
	on_fail = null
	status = null
	return ..()

/obj/item/circuit_component/telepad_console/register_usb_parent(atom/movable/parent)
	. = ..()
	if(istype(parent, /obj/machinery/computer/telescience))
		attached_console = parent

/obj/item/circuit_component/telepad_console/unregister_usb_parent(atom/movable/parent)
	attached_console = null
	return ..()

/obj/item/circuit_component/telepad_console/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return
	if(!attached_console || !attached_console.telepad)
		status.set_output("ERROR: Console or telepad not found!")
		return

	attached_console.angle = elevation.value
	attached_console.rotation = rotation.value
	attached_console.power = power.value
	attached_console.z_co = sector.value
	if(COMPONENT_TRIGGERED_BY(port, elevation))
		elevation.set_input(attached_console.angle, FALSE)
		return
	if(COMPONENT_TRIGGERED_BY(port, rotation))
		rotation.set_input(attached_console.rotation, FALSE)
		return
	if(COMPONENT_TRIGGERED_BY(port, power))
		power.set_input(attached_console.power, FALSE)
		return
	if(COMPONENT_TRIGGERED_BY(port, sector))
		sector.set_input(attached_console.z_co, FALSE)
		return

	status.set_output(attached_console.temp_msg)

	if(COMPONENT_TRIGGERED_BY(send_trigger, port))
		attached_console.sending = 1
		attached_console.teleport(parent.get_creator())

	if(COMPONENT_TRIGGERED_BY(retrieve_trigger, port))
		attached_console.sending = 0
		attached_console.teleport(parent.get_creator())
