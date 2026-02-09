// Kumiss

/datum/reagent/consumable/kumiss
	name = "Kumiss"
	description = "Сәлем, қымыз ішіңіз."
	color = "#c7c7c7ff"
	quality = DRINK_VERYGOOD
	overdose_threshold = 50
	taste_description = "Қазақстан"
	ph = 7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/bottle/kumiss
	var/hymningrn = 0

/datum/reagent/consumable/kumiss/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_tox_loss(-0.5, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_LIVER, -0.5 * REM * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC)
	for(var/datum/reagent/toxin/R in affected_mob.reagents.reagent_list)
		affected_mob.reagents.remove_reagent(R.type, 1.5 * REM * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH
	//тут надо добавить замену частых слов на казахские но это я делать не буду так что пока что эффект кваса

/datum/reagent/consumable/kumiss/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	// ну че, окумысился?
	affected_mob.set_jitter_if_lower(5 SECONDS * REM * seconds_per_tick)
	if(SPT_PROB(10, seconds_per_tick))
		var/list/phrase = world.file2list("strings/massmeta/kumiss.txt")
		affected_mob.say(pick(phrase), forced = /datum/reagent/consumable/kvass)
	if(SPT_PROB(20, seconds_per_tick))
		var/thinking = rand(1,3)
		switch(thinking)
			if(1)
				to_chat(affected_mob, span_warning("Қымыз тым көп іштім деп ойлаймын..."))
			if(2)
				to_chat(affected_mob, span_warning("You feel the Қазақстан as it absorbs every last bit of Kumiss in you to empower!"))
			if(3)
				to_chat(affected_mob, span_warning("Қазақстан IS STRONGER THAN EVER BEFORE!"))

//Пьём кумысс без админов еее

/datum/chemical_reaction/consumable/kumiss
	results = list(/datum/reagent/consumable/kumiss = 3)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/milk = 1)
	required_catalysts = list(/datum/reagent/consumable/enzyme = 5)
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_OTHER

