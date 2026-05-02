#define COLOR_MELON_BLUE "#3399ff"
#define COLOR_MELON_YELLOW "#fbdf56"
#define COLOR_MELON_ORANGE "#ffa64d"
#define COLOR_MELON_RED "#ff4d4d"

/mob/living/basic/melon
	name = "green melon runner"
	desc = "Беги ради мамы и папы, беги."
	icon = 'modular_meta/features/bangclaw/icons/melons.dmi'
	icon_state = "melon_runner"
	icon_living = "melon_runner"
	health = 30
	maxHealth = 30
	basic_mob_flags = DEL_ON_DEATH
	speed = 0.5220
	melee_damage_lower = 0
	melee_damage_upper = 0
	greyscale_config = /datum/greyscale_config/melon_runner

/mob/living/basic/melon/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/death_drops, /obj/effect/decal/cleanable/food/tomato_smudge)

/datum/greyscale_config/melon_runner
	name = "Melon Runner"
	icon_file = 'modular_meta/features/bangclaw/icons/melons.dmi'
	json_config = 'code/datums/greyscale/json_configs/melon.json'

/mob/living/basic/melon/colored
	name = "melon runner"
	icon_state = "pidorskiyi_arbuz"
	icon_living = "pidorskiyi_arbuz"
	greyscale_config = /datum/greyscale_config/melon_runner

//blue
/mob/living/basic/melon/colored/blue
	name = "blue melon runner"
	color = "#3399ff"

//yellow
/mob/living/basic/melon/colored/yellow
	name = "yellow melon runner"
	color = "#fbdf56"
//orange
/mob/living/basic/melon/colored/orange
	name = "orange melon runner"
	color = "#ffa64d"

//red
/mob/living/basic/melon/colored/red
	name = "red melon runner"
	color = "#ff4d4d"
