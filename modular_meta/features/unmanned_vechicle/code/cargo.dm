/datum/supply_pack/imports/unmanned_drone
	name = "CULD Neptune Crate"
	desc = "Remotely controllable land vehicle, made for civil purpose."
	cost = CARGO_CRATE_VALUE * 15
	contains = list(
		/obj/vehicle/unmanned = 1,
	)
	crate_name = "civil unmanned land drone crate"

/datum/supply_pack/imports/unmanned_drone/tiny
	name = "CULD-T Pluto Crate"
	desc = "Remotely controllable tiny land vehicle. \
			Removed from public sale due violation of law."
	order_flags = ORDER_CONTRABAND
	cost = CARGO_CRATE_VALUE * 25
	contains = list(
		/obj/item/deployable_vehicle/tiny = 1,
	)
	crate_name = "civil unmanned land drone crate"

/datum/supply_pack/imports/unmanned_drone_remote
	name = "Handheld Vehicle Controller Crate"
	desc = "Used to control an unmanned vehicle."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/unmanned_vehicle_remote = 1,
	)
	crate_name = "civil unmanned land drone crate"
	crate_type = /obj/structure/closet/crate
