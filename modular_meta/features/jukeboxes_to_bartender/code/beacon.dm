/obj/item/choice_beacon/jukebox
	name = "Jukebox delivery beacon"
	desc = "Is it party time already?"
/obj/item/choice_beacon/jukebox/examine()
	. = ..()
	.+= span_warning("Chosen item will be bolted with floor upon an arrival. Please, be careful \
with your pleased location")

/obj/item/choice_beacon/jukebox/generate_display_names()
	. = ..()
	var/static/list/jukebox_items
	if(!jukebox_items)
		jukebox_items = list()
		var/list/possible_jukebox_items = list(
			/obj/machinery/jukebox
		)
		for(var/obj/item/jukebox_item as anything in possible_jukebox_items)
			jukebox_items[initial(jukebox_item.name)] = jukebox_item
	return jukebox_items
