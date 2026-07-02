/datum/holiday/pride
	name = "Pride Week"
	begin_month = JUNE
	begin_day = 15
	end_day = 22

/datum/holiday/pride/celebrate()
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(peace_n_plasma)))

/datum/holiday/pride/proc/peace_n_plasma()
	for(var/i in 1 to FACTOR_GAS_VISIBLE_MAX)
		var/gas_overlay = GLOB.meta_gas_info[/datum/gas/plasma][META_GAS_OVERLAY][i]
		if(!gas_overlay)
			continue

		if(islist(gas_overlay))
			for(var/obj/effect/overlay/gas/G in gas_overlay)
				apply_pride_plasma(G)
		else if(isloc(gas_overlay) || istype(gas_overlay, /obj/effect/overlay/gas))
			apply_pride_plasma(gas_overlay)

/datum/holiday/pride/proc/apply_pride_plasma(obj/effect/overlay/gas/G)
	if(!G)
		return
	G.icon = 'modular_meta/features/holidays/icons/atmospherics.dmi'
	G.icon_state = "pridesma"
	animate(G, color = rgb(255, 0, 0), time = 5, loop = -1)
	animate(color = rgb(0, 255, 0), time = 5)
	animate(color = rgb(0, 0, 255), time = 5)
