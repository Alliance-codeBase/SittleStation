/datum/escape_menu/proc/metacoin_shop_prompt()
	PRIVATE_PROC(TRUE)

	new /datum/metacoin_shop_panel(usr.client, usr)
	qdel(src)
