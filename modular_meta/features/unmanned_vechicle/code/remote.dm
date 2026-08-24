/obj/item/unmanned_vehicle_remote
	name = "handheld vehicle controller"
	desc = "Used to control an unmanned vehicle.<br>Tap the vehicle you want to control with the controller to link it."
	icon = 'modular_meta/features/unmanned_vechicle/icons/unmanned_vehicles.dmi'
	icon_state = "remote"
	w_class = WEIGHT_CLASS_SMALL
	var/obj/vehicle/unmanned/vehicle
	var/mob/living/current_operator

/obj/item/unmanned_vehicle_remote/Destroy()
	disconnect_operator()
	clear_vehicle()
	return ..()

/obj/item/unmanned_vehicle_remote/afterattack(atom/target, mob/user, flag)
	if(!istype(target, /obj/vehicle/unmanned))
		return ..()

	if(vehicle && vehicle == target)
		to_chat(user, span_notice("You unlink [target] from [src]."))
		clear_vehicle()
		return

	if(vehicle)
		clear_vehicle()

	var/obj/vehicle/unmanned/target_vehicle = target

	if(target_vehicle.controlled)
		to_chat(user, span_warning("Something is already controlling this vehicle."))
		return

	vehicle = target_vehicle
	vehicle.on_link(src)

	to_chat(user, span_notice("You link [target_vehicle] to [src]."))
	RegisterSignal(vehicle, COMSIG_QDELETING, PROC_REF(clear_vehicle))
	return ..()

/obj/item/unmanned_vehicle_remote/attack_self(mob/user)
	if(!vehicle)
		to_chat(user, span_warning("The controller is not linked to any vehicle!"))
		return

	if(current_operator == user)
		disconnect_operator()
		return

	if(current_operator && current_operator != user)
		to_chat(user, span_warning("Someone else is using this controller!"))
		return

	if(user.client)
		current_operator = user
		to_chat(user, span_notice("Connecting to [vehicle.name] control systems..."))

		user.reset_perspective(vehicle)
		user.remote_control = vehicle

		RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(disconnect_operator))

		if(vehicle.unmanned_flags & 2)
			vehicle.set_light_on(TRUE)

	return ..()

/obj/item/unmanned_vehicle_remote/proc/disconnect_operator()
	SIGNAL_HANDLER
	if(!current_operator)
		return

	to_chat(current_operator, span_notice("Disconnecting from vehicle..."))
	current_operator.reset_perspective(null)

	if(current_operator.remote_control == vehicle)
		current_operator.remote_control = null

	UnregisterSignal(src, COMSIG_ITEM_DROPPED)

	if(vehicle && (vehicle.unmanned_flags & 2))
		vehicle.set_light_on(FALSE)

	current_operator = null

/obj/item/unmanned_vehicle_remote/proc/clear_vehicle()
	SIGNAL_HANDLER
	disconnect_operator()
	if(!vehicle)
		return

	UnregisterSignal(vehicle, COMSIG_QDELETING)
	vehicle.on_unlink(src)
	vehicle = null
