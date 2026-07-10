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
		var/obj/effect/overlay/gas/G = GLOB.meta_gas_info[/datum/gas/plasma][META_GAS_OVERLAY][i]
		G.icon_state = "pridesma"
		animate(G, color = rgb(255, 0, 0), time = 5, loop = -1)
		animate(color = rgb(0, 255, 0), time = 5, loop = -1)
		animate(color = rgb(0, 0, 255), time = 5, loop = -1)
