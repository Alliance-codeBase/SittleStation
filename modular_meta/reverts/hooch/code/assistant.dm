//ORIGINAL FILE: code/modules/jobs/job_types/assistants/assistant.dm
/datum/job/assistant
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

// code/modules/reagents/chemistry/reagents/drinks/alcohol_reagents.dm
/datum/reagent/consumable/ethanol/hooch/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	var/obj/item/organ/internal/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_GREYTIDE_METABOLISM))
		if(drinker.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

//ORIGINAL FILE: code/modules/reagents/withdrawal/generic_addictions.dm
/datum/addiction/maintenance_drugs/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon)
	. = ..()
	var/obj/item/organ/internal/liver/empowered_liver = affected_carbon.get_organ_by_type(/obj/item/organ/internal/liver)
	if(empowered_liver)
		ADD_TRAIT(empowered_liver, TRAIT_GREYTIDE_METABOLISM, "maint_drug_addiction")

//ORIGINAL FILE: code/modules/surgery/organs/internal/liver/_liver.dm
/obj/item/organ/internal/liver/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_ENTRAILS_READER) || isobserver(user))
		if(HAS_TRAIT(src, TRAIT_GREYTIDE_METABOLISM))
			. += span_info("Greyer than most with electrical burn marks, this is the liver of an <em>assistant</em>.")
