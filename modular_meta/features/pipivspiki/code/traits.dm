#define PRO_PIPI "pro-pipidaster"
#define PRO_PIKI "pro-pikita"
#define PRO_MELOK "pro-melok"
#define RANDOM_PRO null
#define STATION_TRAIT_NO_COST 0

/datum/station_trait/vibori
	name = "Выборы.. Выборы.."
	cost = STATION_TRAIT_COST_FULL
	trait_type = STATION_TRAIT_NO_COST
	show_in_report = FALSE
	weight = 100
	sign_up_button = TRUE
	var/list/vibori = list()

/datum/station_trait/vibori/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))

/datum/station_trait/vibori/setup_lobby_button(atom/movable/screen/lobby/button/sign_up/lobby_button)
	RegisterSignal(lobby_button, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_lobby_button_update_overlays))
	lobby_button.desc = "За кого ты проголосуешь? Пипидастер, Пикита или же Мелок?"
	return ..()

/datum/station_trait/vibori/can_display_lobby_button(client/player)
	return sign_up_button

/// We don't destroy buttons on round start for those who are still in the lobby.
/datum/station_trait/vibori/on_round_start()
	return

/datum/station_trait/vibori/on_lobby_button_update_icon(atom/movable/screen/lobby/button/sign_up/lobby_button, location, control, params, mob/dead/new_player/user)
	var/mob/player = lobby_button.get_mob()
	var/vibori_stance = vibori[player.ckey]
	switch(vibori_stance)
		if(PRO_PIPI)
			lobby_button.base_icon_state = "signup"
		if(PRO_PIKI)
			lobby_button.base_icon_state = "signup"
		if(PRO_PIKI)
			lobby_button.base_icon_state = "signup"
		else
			lobby_button.base_icon_state = "signup_neutral"

/datum/station_trait/vibori/on_lobby_button_click(atom/movable/screen/lobby/button/sign_up/lobby_button, updates)
	var/mob/player = lobby_button.get_mob()
	var/vibori_stance = vibori[player.ckey]
	switch(vibori_stance)
		if(PRO_PIPI)
			vibori[player.ckey] = PRO_PIKI
			lobby_button.balloon_alert(player, "За пикиту")
		if(PRO_PIKI)
			vibori[player.ckey] = PRO_MELOK
			lobby_button.balloon_alert(player, "За мелка")
		if(PRO_MELOK)
			vibori[player.ckey] = RANDOM_PRO
			lobby_button.balloon_alert(player, "За лучшего")
		if(RANDOM_PRO)
			vibori[player.ckey] = PRO_PIPI
			lobby_button.balloon_alert(player, "За пипидастера")

/datum/station_trait/vibori/proc/on_lobby_button_update_overlays(atom/movable/screen/lobby/button/sign_up/lobby_button, list/overlays)
	SIGNAL_HANDLER
	var/mob/player = lobby_button.get_mob()
	var/vibori_stance = vibori[player.ckey]
	switch(vibori_stance)
		if(PRO_PIPI)
			overlays += "pipi"
		if(PRO_PIKI)
			overlays += "piki"
		if(PRO_MELOK)
			overlays += "melok"
		if(RANDOM_PRO)
			overlays += "random"

/datum/station_trait/vibori/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER

	var/vibori_stance = vibori[player_client.ckey]
	if((vibori_stance == RANDOM_PRO && prob(33)) || vibori_stance == PRO_PIPI)
		var/obj/item/storage/box/stickers/vibori/pro_pipi/boxie = new(spawned.loc)
		spawned.equip_to_storage(boxie, ITEM_SLOT_BACK, indirect_action = TRUE)
		if(ishuman(spawned))
			var/obj/item/clothing/suit/costume/wellworn_shirt/vibori/pipi/shirt = new(spawned.loc)
			if(!spawned.equip_to_slot_if_possible(shirt, ITEM_SLOT_OCLOTHING, indirect_action = TRUE))
				shirt.forceMove(boxie)
		return
	if((vibori_stance == RANDOM_PRO && prob(33)) || vibori_stance == PRO_PIKI)
		var/obj/item/storage/box/stickers/vibori/pro_piki/boxie = new(spawned.loc)
		spawned.equip_to_storage(boxie, ITEM_SLOT_BACK, indirect_action = TRUE)
		if(!ishuman(spawned))
			var/obj/item/clothing/suit/costume/wellworn_shirt/vibori/piki/shirt = new(spawned.loc)
			if(!spawned.equip_to_slot_if_possible(shirt, ITEM_SLOT_OCLOTHING, indirect_action = TRUE))
				shirt.forceMove(boxie)
		return
	if((vibori_stance == RANDOM_PRO && prob(33)) || vibori_stance == PRO_MELOK)
		var/obj/item/storage/box/stickers/vibori/pro_mel/boxie = new(spawned.loc)
		spawned.equip_to_storage(boxie, ITEM_SLOT_BACK, indirect_action = TRUE)
		if(!ishuman(spawned))
			var/obj/item/clothing/suit/costume/wellworn_shirt/vibori/melok/shirt = new(spawned.loc)
			if(!spawned.equip_to_slot_if_possible(shirt, ITEM_SLOT_OCLOTHING, indirect_action = TRUE))
				shirt.forceMove(boxie)


#undef PRO_PIPI
#undef PRO_PIKI
#undef PRO_MELOK
#undef RANDOM_PRO

/obj/item/sticker/vibori
	icon = 'modular_meta/features/pipivspiki/icons/stickers.dmi'

/obj/item/sticker/vibori/pipi
	name = "стикеры от партии Пипидастера"
	icon_state = "pipi"
	examine_text = "Стикер указывает о том что думает лидер: <b>Я 2 ЕБАННЫХ ГОДА ПРОШУ ПЕДАЛЬ ЧТОБЫ ПОКАЗАТЬ ЧТО Я НА САМОМ ДЕЛЕ УМЕЮ!</b>"

/obj/item/sticker/vibori/piki
	name = "стикеры от партии Пикиты"
	icon_state = "piki"
	examine_text = "Стикер указывает о том что думает лидер: <b>Пикита пошёл нахуй.</b>"

/obj/item/sticker/vibori/mel
	name = "стикеры от партии Мелка"
	icon_state = "mel"
	examine_text = "Стикер указывает о том что думает лидер: <b>я проголсую за пепедастра.</b>"

/datum/greyscale_config/wellworn_shirt/vibori
	name = "Well-Worn Shirt (vibori)"
	icon_file = 'icons/obj/clothing/suits/costume.dmi'
	json_config = 'modular_meta/features/pipivspiki/code/shirt.json'

/datum/greyscale_config/wellworn_shirt/vibori/worn
	name = "Well-Worn Shirt (Worn vibori)"
	icon_file = 'icons/mob/clothing/suits/costume.dmi'

/obj/item/clothing/suit/costume/wellworn_shirt/vibori
	icon = 'icons/map_icons/clothing/suit/costume.dmi'
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt"
	post_init_icon_state = "wellworn_shirt_pro_pipi"
	greyscale_config = /datum/greyscale_config/wellworn_shirt/vibori
	greyscale_config_worn = /datum/greyscale_config/wellworn_shirt/vibori/worn

/obj/item/clothing/suit/costume/wellworn_shirt/vibori/pipi
	name = "pro-pipidaster shirt"
	desc = "A worn out, curiously comfortable t-shirt."
	greyscale_colors = "#50D050"

/obj/item/clothing/suit/costume/wellworn_shirt/vibori/piki
	name = "pro-pikita shirt"
	desc = "A worn out, curiously comfortable t-shirt."
	greyscale_colors = "#D0D050"
	post_init_icon_state = "wellworn_shirt_pro_piki"

/obj/item/clothing/suit/costume/wellworn_shirt/vibori/melok
	name = "pro-melok shirt"
	desc = "A worn out, curiously comfortable t-shirt."
	greyscale_colors = "#D05050"
	post_init_icon_state = "wellworn_shirt_pro_melok"

/obj/item/storage/box/stickers/vibori
	icon = 'modular_meta/features/pipivspiki/icons/stickers.dmi'

/obj/item/storage/box/stickers/vibori/pro_pipi
	name = "Pipidaster approved sticker pack"
	desc = "2 YEARS ON STATION MADE YOU A FUCKING ADMIN!"
	illustration = "label_pipi"

/obj/item/storage/box/stickers/pro_pipi/PopulateContents()
	new /obj/item/sticker/vibori/pipi(src)
	new /obj/item/sticker/vibori/pipi(src)
	new /obj/item/sticker/vibori/pipi(src)

/obj/item/storage/box/stickers/vibori/pro_piki
	name = "Pikita approved sticker pack"
	desc = "За силиконов и текущую власть!"
	illustration = "label_piki"

/obj/item/storage/box/stickers/pro_piki/PopulateContents()
	new /obj/item/sticker/vibori/piki(src)
	new /obj/item/sticker/vibori/piki(src)
	new /obj/item/sticker/vibori/piki(src)

/obj/item/storage/box/stickers/vibori/pro_mel
	name = "Melok approved sticker pack"
	desc = "За новую власть и так далее!"
	illustration = "label_mel"

/obj/item/storage/box/stickers/pro_mel/PopulateContents()
	new /obj/item/sticker/vibori/mel(src)
	new /obj/item/sticker/vibori/mel(src)
	new /obj/item/sticker/vibori/mel(src)
