/datum/action/cooldown/spell/shapeshift/demon //emergency get out of jail card.
	name = "Lesser Demon Form"
	desc = "Take on your true demon form. This form is strong but very obvious. It's full demonic nature in this realm is taxing on you \
	and you will slowly lose life while in this form, while also being especially weak to holy influences. \
	Be aware low health transfers between forms. If gravely wounded, attack live mortals to siphon life energy from them!"
	button_icon = 'modular_meta/features/antagonists/icons/sinful_demon/actions_demon.dmi'
	button_icon_state = "daemontransform"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	invocation = "COWER, MORTALS!!"

	possible_shapes = list(/mob/living/simple_animal/lesserdemon)
	spell_requirements = NONE
