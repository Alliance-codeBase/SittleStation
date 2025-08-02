// Лавовая лампа

//Lava Lamps: Because we're already stuck in the 70ies with those fax machines.
/obj/item/flashlight/lamp/lava
	name = "lava lamp"
	desc = "A kitchy throwback decorative light. Noir Edition."
	icon = 'modular_meta/features/not_enough_decor/icons/items/obj/lavalamp.dmi'
	icon_state = "lavalamp"
	start_on = FALSE
	light_range = 3 //range of light when on
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.2)

/obj/item/flashlight/lamp/lava/update_icon_state()
	overlays.Cut()
	var/image/I = image(icon = icon, icon_state = "lavalamp-[light_on ? "on" : "off"]")
	I.color = light_color
	overlays += I
	return ..()

/obj/item/flashlight/lamp/lava/red
	desc = "A kitchy red decorative light."
	light_color = COLOR_RED

/obj/item/flashlight/lamp/lava/blue
	desc = "A kitchy blue decorative light."
	light_color = COLOR_BLUE

/obj/item/flashlight/lamp/lava/cyan
	desc = "A kitchy cyan decorative light."
	light_color = COLOR_CYAN

/obj/item/flashlight/lamp/lava/green
	desc = "A kitchy green decorative light."
	light_color = COLOR_GREEN

/obj/item/flashlight/lamp/lava/orange
	desc = "A kitchy orange decorative light."
	light_color = COLOR_ORANGE

/obj/item/flashlight/lamp/lava/purple
	desc = "A kitchy purple decorative light."
	light_color = COLOR_PURPLE
/obj/item/flashlight/lamp/lava/pink
	desc = "A kitchy pink decorative light."
	light_color = COLOR_PINK

/obj/item/flashlight/lamp/lava/yellow
	desc = "A kitchy yellow decorative light."
	light_color = COLOR_YELLOW

// Рандомная лампа
/obj/effect/spawner/random/decoration/lavalamp
	name = "lavalamp spawner"
	icon = 'modular_meta/features/not_enough_decor/icons/items/obj/lavalamp.dmi'
	icon_state = "lavalamp_random"
	loot = list(/obj/item/flashlight/lamp/lava,
					/obj/item/flashlight/lamp/lava/red,
					/obj/item/flashlight/lamp/lava/orange,
					/obj/item/flashlight/lamp/lava/yellow,
					/obj/item/flashlight/lamp/lava/green,
					/obj/item/flashlight/lamp/lava/cyan,
					/obj/item/flashlight/lamp/lava/blue,
					/obj/item/flashlight/lamp/lava/purple,
					/obj/item/flashlight/lamp/lava/pink)
