/mob/living/basic/melon
	name = "green melon runner"
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

GLOBAL_LIST_INIT(melon_runner_colors, list(
	"Blue" = "#3399ff",
	"Yellow" = "#fbdf56",
	"Orange" = "#ffa64d",
	"Red" = "#ff4d4d",
))

/mob/living/basic/melon/colored
	name = "melon runner"
	icon_state = "pidorskiyi_arbuz"
	icon_living = "pidorskiyi_arbuz"
	greyscale_config = /datum/greyscale_config/melon_runner

/mob/living/basic/melon/colored/proc/apply_colour()
	if (!greyscale_config)
		return
	set_greyscale(colors = list(pick_weight(GLOB.melon_runner_colors)))

//blue
/mob/living/basic/melon/colored/blue
	name = "blue melon runner"

/mob/living/basic/melon/colored/blue/apply_colour()
	set_greyscale(colors = list("Blue"))

//yellow
/mob/living/basic/melon/colored/yellow
	name = "yellow melon runner"

/mob/living/basic/melon/colored/yellow/apply_colour()
	. = ..()
	set_greyscale(colors = list("Yellow"))

//orange
/mob/living/basic/melon/colored/orange
	name = "orange melon runner"

/mob/living/basic/melon/colored/orange/apply_colour()
	. = ..()
	set_greyscale(colors = list("Orange"))

//red
/mob/living/basic/melon/colored/red
	name = "red melon runner"

/mob/living/basic/melon/colored/red/apply_colour()
	. = ..()
	set_greyscale(colors = list("Red"))
