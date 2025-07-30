/obj/item/manual_cell_recharger
	name = "manual battery charger"
	desc = "Charges cell by converting mechanical energy into electrical energy. Just activate it in-hand and the cell will be charged by the your force."
	icon = 'modular_meta/features/more_cell_interactions/icons/manual_cell_recharger.dmi'
	icon_state= "handheldcharger_black_empty"
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/stock_parts/power_store/cell/incell
	var/obj/item/stock_parts/servo/motor

/obj/item/manual_cell_recharger/examine(mob/user)
	. = ..()
	if(incell)
		. += "<hr><span class='notice'>The [incell] indicator shows [incell.percent()] percent charge.</span>"
	else
		. += "<hr><span class='notice'>There is no cell inside.</span>"

	if(motor)
		. += "<hr><span class='notice'>There is a [motor] inside.</span>"
	else
		. += "<hr><span class='notice'>There is no micro-servo inside.</span>"

/obj/item/manual_cell_recharger/Initialize(mapload)
	. = ..()

/obj/item/manual_cell_recharger/attack_self(mob/user)
	if(!incell)
		to_chat(user, span_notice("There is no cell inside."))
		return

	if(!motor)
		to_chat(user, span_notice("There is no micro-servo inside."))
		return

	if(incell.charge >= incell.maxcharge)
		to_chat(user, span_notice("[incell] fully charged."))
		return

	while(do_after(user, 1 SECONDS, target=src, timed_action_flags = IGNORE_HELD_ITEM))
		incell.charge = min(incell.charge + 100*motor.rating, incell.maxcharge)
		to_chat(user, span_notice("I press the handle several times, charging the [incell] a little."))
		playsound(user, 'sound/items/weapons/chainsaw_stop.ogg', 15, 1, 5)
		if(incell.charge >= incell.maxcharge)
			to_chat(user, span_notice("[incell] fully charged."))
			return
	to_chat(user, span_notice("I stop pressing the handle and charging the [incell]."))


/obj/item/manual_cell_recharger/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/stock_parts/power_store/cell))
		if(!incell)
			incell = I
			user.transferItemToLoc(I, src)
			icon_state = "handheldcharger_black"
			update_icon()
			to_chat(user, span_notice("You insert [incell] in [src].")) // Господи как же я кончал шуссу в рот охххххххх бля
		else
			to_chat(user, span_notice("There is already a [incell] inside the [src]."))
			return
	if(istype(I, /obj/item/stock_parts/servo))
		if(!motor)
			motor = I
			user.transferItemToLoc(I, src)
			to_chat(user, span_notice("You insert [motor] in [src]."))
		else
			to_chat(user, span_notice("There is already a [motor] inside the [src]."))
			return
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_notice("You eject [motor] from [src]."))
		motor.forceMove(drop_location())
		motor = null

/obj/item/manual_cell_recharger/attack_hand_secondary(mob/user, modifiers)
	. = ..()
	if(incell)
		to_chat(user, span_notice("You remove the [incell]."))
		user.put_in_hands(incell)
		incell = null
		icon_state= "handheldcharger_black_empty"
		update_icon()
		incell.update_icon()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

// Крафт через крафтменю
// Шусс лох
/datum/crafting_recipe/manual_cell_recharger
	name = "manual cell recharger"
	result = /obj/item/manual_cell_recharger
	time = 80
	reqs = list(
				/obj/item/stack/cable_coil = 5,
				/obj/item/stack/rods = 2,
				/obj/item/stack/sheet/glass = 1,
				)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	category = CAT_TOOLS

// Крафт через автолат
// Wyсс сосал
/datum/design/manual_cell_recharger
	name = "Manual cell recharger"
	id = "manual_cell_recharger"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/glass = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/manual_cell_recharger
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE
