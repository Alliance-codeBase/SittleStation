// Стулья с бэйстейшона12

// Обычный стул
/obj/structure/chair/padded
	name = "padded chair"
	desc = "It looks seriously."
	icon = 'modular_meta/features/not_enough_decor/icons/items/obj/chairs.dmi'
	icon_state = "chair"
	icon_state_preview = "chair"
	color = "#666666"
	buildstackamount = 2
	item_chair = null
	has_armrest = FALSE
	anchored = TRUE

// В разных цветах
/obj/structure/chair/padded/red
	color = COLOR_OLD_GLORY_RED

/obj/structure/chair/padded/brown
	color = COLOR_DRIED_TAN

/obj/structure/chair/padded/teal
	color = COLOR_TEAL

/obj/structure/chair/padded/black
	color = COLOR_DARK

/obj/structure/chair/padded/green
	color = COLOR_PALE_GREEN

/obj/structure/chair/padded/purple
	color = COLOR_VOID_PURPLE

/obj/structure/chair/padded/blue
	color = COLOR_TRAM_LIGHT_BLUE

/obj/structure/chair/padded/beige
	color = COLOR_BEIGE

/obj/structure/chair/padded/lime
	color = COLOR_VIBRANT_LIME

/obj/structure/chair/padded/yellow
	color = COLOR_VERY_SOFT_YELLOW

/obj/structure/chair/padded/light
	color = COLOR_VERY_LIGHT_GRAY

// Стул шаттла
/obj/structure/chair/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	icon = 'modular_meta/features/not_enough_decor/icons/items/obj/chairs.dmi'
	//base_icon = "shuttle_chair"
	icon_state_preview = "shuttle_chair"
	icon_state = "shuttle_chair"
	has_armrest = TRUE
	anchored = TRUE
	max_integrity = 200
	item_chair = null
	color = "#666666"

/obj/structure/chair/shuttle/post_buckle_mob()
	if(has_buckled_mobs())
		icon_state = "shuttle_chair-b"
		playsound(src, 'sound/items/handcuff_finish.ogg', 50, FALSE)
	else
		icon_state = "shuttle_chair"
		playsound(src, 'sound/items/boxcutter_activate.ogg', 50, FALSE)
	..()

/obj/structure/chair/shuttle/update_icon_state()
	..()
	if(!can_buckle)
		var/image/I = image(icon, "[icon_state]_special")
		I.layer = WALL_OBJ_LAYER // ABOVE_MOB_LAYER
		overlays |= I

/obj/structure/chair/shuttle/blue
	color = COLOR_BLUE_GRAY

/obj/structure/chair/shuttle/black
	color = COLOR_ALMOST_BLACK

/obj/structure/chair/shuttle/white
	color = COLOR_GRAY

/obj/structure/chair/shuttle/red
	color = COLOR_RED_GRAY

/obj/structure/chair/shuttle/green
	color = COLOR_ASSISTANT_OLIVE
