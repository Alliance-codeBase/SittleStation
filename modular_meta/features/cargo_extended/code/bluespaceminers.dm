// Майнер руды взятый с вайта так как там он сделан лучше чем на блюмуне
/obj/item/circuitboard/machine/bluespace_miner
	name = "Bluespace Miner"
	build_path = /obj/machinery/mineral/bluespace_miner
	req_components = list(
		/datum/stock_part/matter_bin = 3,
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/servo = 3,
		/datum/stock_part/scanning_module = 1,
		/obj/item/stack/ore/bluespace_crystal = 3,
		/obj/item/stack/sheet/mineral/gold = 1,
		/obj/item/stack/sheet/mineral/uranium = 1)
	needs_anchored = FALSE

// Ветка в РнД
/datum/techweb_node/automining
	id = TECHWEB_NODE_AUTOMINERS
	display_name = "Automatic Miners"
	description = "Automatic miners that extract money and ore in exchange require a colossal amount of energy."
	prereq_ids = list(TECHWEB_NODE_BLUESPACE_TRAVEL, TECHWEB_NODE_PROGRAMMED_SERVER, TECHWEB_NODE_TELECOMS)
	design_ids = list("bluemine", "cryptominer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/syndie_mining
	id = TECHWEB_NODE_SYNDIE_MINERS
	display_name = "Unstable Cryptominer"
	description = "Miner banned by Nanotrasen due to greater instability than the first version."
	prereq_ids = list(TECHWEB_NODE_AUTOMINERS, TECHWEB_NODE_SYNDICATE_BASIC)
	design_ids = list("cryptominersyndie")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SUPPLY)

// Схема в импринтере
/datum/design/bluemine
	name = "Bluespace miner"
	desc = "A machine that uses Bluespace tech to slowly create materials and add them to a linked ore silo."
	id = "bluemine"
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/circuitboard/machine/bluespace_miner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/obj/machinery/mineral/bluespace_miner
	name = "bluespace miner"
	desc = "A machine that uses Bluespace tech to slowly create materials and add them to a linked ore silo."
	icon = 'modular_meta/features/cargo_extended/icons/bsm.dmi'
	icon_state = "bsm_idle"
	circuit = /obj/item/circuitboard/machine/bluespace_miner
	layer = BELOW_OBJ_LAYER
	idle_power_usage = 2000
	var/list/ores = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/plasma = SMALL_MATERIAL_AMOUNT*4,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*4,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*2.5,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT*2.5,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT*2.5,
		/datum/material/bananium = COIN_MATERIAL_AMOUNT*0.1,
		/datum/material/diamond = COIN_MATERIAL_AMOUNT,
		/datum/material/bluespace = COIN_MATERIAL_AMOUNT
	)
	var/datum/component/remote_materials/materials
	var/mine_rate = 1

/obj/machinery/mineral/bluespace_miner/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSmachines, src)
	materials = AddComponent(/datum/component/remote_materials, "bsm", mapload)

/obj/machinery/mineral/bluespace_miner/Destroy()
	materials = null
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/machinery/mineral/bluespace_miner/update_icon_state()
	if(panel_open)
		icon_state = "bsm_t"
		return ..()
	else if(!powered())
		icon_state = "bsm_off"
		return ..()
	else if(!materials?.silo || materials?.on_hold())
		icon_state = "bsm_idle"
		return ..()
	else
		icon_state = "bsm_on"
		return ..()

/obj/machinery/mineral/bluespace_miner/RefreshParts()
	. = ..()
	var/tot_rating = 0
	for(var/obj/item/stock_parts/SP in src)
		tot_rating += SP.rating
	mine_rate = tot_rating

/obj/machinery/mineral/bluespace_miner/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I))
		to_chat(user, span_notice("You update the miner buffer with the multitool buffer."))
		materials?.silo = I.buffer
		return TRUE
	else
		to_chat(user, span_notice("The multitool buffer is empty."))
		return FALSE

/obj/machinery/mineral/bluespace_miner/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += span_notice("Resource collection speed [mine_rate]")
	if(!materials?.silo)
		. += "\n<span class='notice'>The ore silo is not connected. Use the multitool to link the ore silo to this machine.</span>"
	else if(materials?.on_hold())
		. += "\n<span class='warning'>Access to ore silo is blocked, contact the quartermaster.</span>"

/obj/machinery/mineral/bluespace_miner/attackby(obj/item/O, mob/living/user, params)
	if(user.combat_mode)
		return ..()
	if(default_deconstruction_screwdriver(user, "bsm_t", "bsm_off", O))
		update_icon_state()
		return

/obj/machinery/mineral/bluespace_miner/process()
	if(!materials?.silo || materials?.on_hold() || panel_open || !powered() || !anchored)
		update_icon_state()
		return
	var/datum/component/material_container/mat_container = materials.mat_container
	if(!mat_container)
		update_icon_state()
		return
	var/datum/material/ore = pick_weight(ores)
	if(!mat_container.can_hold_material(ore))
		to_chat(src, span_warning("БС майнер сломался по причине: [ore]"))
		return
	materials.mat_container.insert_amount_mat(rand(5, 9) * mine_rate, ore)
	update_icon_state()
