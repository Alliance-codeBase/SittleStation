/**
 *	# WITHOUT THIS POWER:
 *
 *	- Mid-Blood: SHOW AS PALE
 *	- Low-Blood: SHOW AS DEAD
 *	- No Heartbeat
 *  - Examine shows actual blood
 *	- Thermal homeostasis (ColdBlooded)
 * 		WITH THIS POWER:
 *	- Normal body temp -- remove Cold Blooded (return on deactivate)
 */

/datum/action/cooldown/bloodsucker/masquerade
	name = "Masquerade"
	desc = "Feign the vital signs of a mortal, and escape both casual and medical notice as the monster you truly are."
	button_icon_state = "power_human"
	power_explanation = "Masquerade:\n\
		Activating Masquerade will physiologically make you identical to a human;\n\
		- You lose nearly all Bloodsucker benefits, including healing, sleep, radiation, crit, virus and cold immunity.\n\
		- Your eyes become less vulnerable to bright lights.\n\
		- You gain reflection, making mortals unable to discover your undeath with a simple mirror.\n\
		- You gain a genetic sequence, and appear to have 100% blood when scanned by a health analyzer.\n\
		- You will not appear as pale when examined. Anything further than pale, however, will not be hidden.\n\
		At the end of Masquerade you will re-gain your vampiric qualities and lose any diseases or genetic alterations you might have."
	power_flags = BP_AM_TOGGLE|BP_AM_STATIC_COOLDOWN|BP_AM_COSTLESS_UNCONSCIOUS
	check_flags = BP_CANT_USE_IN_FRENZY
	purchase_flags = BLOODSUCKER_CAN_BUY|BLOODSUCKER_DEFAULT_POWER
	bloodcost = 10
	cooldown_time = 5 SECONDS
	constant_bloodcost = 0.1
	should_level = FALSE

/datum/action/cooldown/bloodsucker/masquerade/ActivatePower(trigger_flags)
	. = ..()
	var/mob/living/carbon/user = owner
	owner.balloon_alert(owner, "masquerade turned on.")
	to_chat(user, span_notice("Your heart beats falsely within your lifeless chest. You may yet pass for a mortal."))
	to_chat(user, span_warning("Your vampiric healing is halted while imitating life."))

	// Give status effect
	user.apply_status_effect(/datum/status_effect/masquerade)

	// Handle Traits
	user.remove_traits(bloodsuckerdatum_power.bloodsucker_traits, BLOODSUCKER_TRAIT)
	ADD_TRAIT(user, TRAIT_MASQUERADE, BLOODSUCKER_TRAIT)
	// Handle organs
	var/obj/item/organ/heart/vampheart = user.get_organ_slot(ORGAN_SLOT_HEART)
	if(vampheart)
		vampheart.Restart()
	var/obj/item/organ/eyes/eyes = user.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.flash_protect = initial(eyes.flash_protect)

/datum/action/cooldown/bloodsucker/masquerade/DeactivatePower()
	. = ..() // activate = FALSE
	var/mob/living/carbon/user = owner
	owner.balloon_alert(owner, "masquerade turned off.")

	// Remove status effect, mutations & diseases that you got while on masq.
	user.remove_status_effect(/datum/status_effect/masquerade)
	user.dna.remove_all_mutations()
	for(var/datum/disease/diseases as anything in user.diseases)
		diseases.cure()

	// Handle Traits
	user.add_traits(bloodsuckerdatum_power.bloodsucker_traits, BLOODSUCKER_TRAIT)
	REMOVE_TRAIT(user, TRAIT_MASQUERADE, BLOODSUCKER_TRAIT)

	// Handle organs
	var/obj/item/organ/heart/vampheart = user.get_organ_slot(ORGAN_SLOT_HEART)
	if(vampheart)
		vampheart.Stop()
	var/obj/item/organ/eyes/eyes = user.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.flash_protect = max(initial(eyes.flash_protect) - 1, FLASH_PROTECTION_SENSITIVE)
	to_chat(user, span_notice("Your heart beats one final time as your skin dries out and your icy pallor returns."))

/**
 * # Status effect
 *
 * This is what the Masquerade power gives, handles their bonuses and gives them a neat icon to tell them they're on Masquerade.
 */

/datum/status_effect/masquerade
	id = "masquerade"
	duration = -1
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/masquerade

/atom/movable/screen/alert/status_effect/masquerade
	name = "Masquerade"
	desc = "You are currently hiding your true nature using the Masquerade power. This halts vampiric healing."
	icon = 'modular_meta/features/antagonists/icons/bloodsuckers/actions_bloodsucker.dmi'
	icon_state = "power_human"
	alerttooltipstyle = "cult"

/atom/movable/screen/alert/status_effect/masquerade/MouseEntered(location,control,params)
	desc = initial(desc)
	return ..()
