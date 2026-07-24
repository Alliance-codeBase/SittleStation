/datum/escape_menu/show_home_page()
	..()

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/text/clickable(
			null,
			/* hud_owner = */ null,
			/* escape_menu = */ src,
			/* button_text = */ "Metacoins Shop",
			/* offset = */ list(-206, 28),
			/* font_size = */ 24,
			/* on_click_callback = */ CALLBACK(src, PROC_REF(metacoin_shop_prompt)),
		)
	)

/datum/escape_menu/proc/metacoin_shop_prompt()
	PRIVATE_PROC(TRUE)

	new /datum/metacoin_shop_panel(usr.client, usr)
	qdel(src)
