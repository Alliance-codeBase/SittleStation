/obj/item
	var/uses_advanced_reskins = FALSE

/obj/item/clothing/verb/clothing_reskin()
	set name = "Reskin Clothes"
	set category = "Object"
	set src in usr
	var/mob/M = usr
	
	if(!uses_advanced_reskins)
		to_chat(M, "[src] has no reskins available.")
		return
	if(!LAZYLEN(unique_reskin))
		return

	var/list/items = list()


	for(var/reskin_option in unique_reskin)
		var/image/item_image = image(icon = unique_reskin[reskin_option][RESKIN_ICON] ? unique_reskin[reskin_option][RESKIN_ICON] : icon, icon_state = "[unique_reskin[reskin_option][RESKIN_ICON_STATE]]")
		items += list("[reskin_option]" = item_image)
	sort_list(items)

	var/pick = show_radial_menu(M, src, items, custom_check = CALLBACK(src, PROC_REF(check_reskin_menu), M), radius = 38, require_near = TRUE)
	if(!pick)
		return
	if(!unique_reskin[pick])
		return
	current_skin = pick

	if(unique_reskin[pick][RESKIN_ICON])
		icon = unique_reskin[pick][RESKIN_ICON]

	if(unique_reskin[pick][RESKIN_ICON_STATE])
		icon_state = unique_reskin[pick][RESKIN_ICON_STATE]

	if(unique_reskin[pick][RESKIN_WORN_ICON])
		worn_icon = unique_reskin[pick][RESKIN_WORN_ICON]

	if(unique_reskin[pick][RESKIN_WORN_ICON_STATE])
		worn_icon_state = unique_reskin[pick][RESKIN_WORN_ICON_STATE]

	if(unique_reskin[pick][RESKIN_INHAND_L])
		lefthand_file = unique_reskin[pick][RESKIN_INHAND_L]
	if(unique_reskin[pick][RESKIN_INHAND_R])
		righthand_file = unique_reskin[pick][RESKIN_INHAND_R]
	if(unique_reskin[pick][RESKIN_INHAND_STATE])
		inhand_icon_state = unique_reskin[pick][RESKIN_INHAND_STATE]
	if(unique_reskin[pick][RESKIN_SUPPORTS_VARIATIONS_FLAGS])
		supports_variations_flags = unique_reskin[pick][RESKIN_SUPPORTS_VARIATIONS_FLAGS]
	if(ishuman(M))
		var/mob/living/carbon/human/wearer = M
		wearer.regenerate_icons() // update that mf
	to_chat(M, "[src] is now skinned as '[pick].'")
