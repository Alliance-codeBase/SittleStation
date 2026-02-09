/datum/reagent/toxin/novichok
    name = "Novichok"
    description = "A lethal nerve agent."
    color = "#AAAAAA77"
    toxpwr = 2
    metabolization_rate = 0.7 * REAGENTS_METABOLISM

/datum/reagent/toxin/novichok/proc/pick_paralyzed_limb()
    return pick(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_R_LEG, TRAIT_PARALYSIS_L_LEG)

/datum/reagent/toxin/novichok/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
    . = ..()
    var/need_update
    if(times_fired % 3 == 0)
        need_update += M.adjust_oxy_loss(12, updating_health = TRUE)
    need_update += M.adjust_organ_loss(ORGAN_SLOT_HEART, 3 * REM * seconds_per_tick)
    need_update += M.adjust_organ_loss(ORGAN_SLOT_BRAIN, 3 * REM * seconds_per_tick)
    if(times_fired % 30 == 0 && times_fired > 0)
        if(ishuman(M) && !M.undergoing_cardiac_arrest() && M.can_heartattack())
            M.set_heartattack(TRUE)
            if(M.stat == CONSCIOUS)
                M.visible_message(span_userdanger("[M] clutches at [M.p_their()] chest as if [M.p_their()] heart stopped!"))
    if(SPT_PROB(10, seconds_per_tick))
        var/paralyzed_limb = pick_paralyzed_limb()
        ADD_TRAIT(M, paralyzed_limb, type)
        need_update += M.adjust_stamina_loss(10 * REM * seconds_per_tick, updating_stamina = FALSE)
    if(need_update)
        return UPDATE_MOB_HEALTH

/datum/reagent/toxin/novichok/on_mob_end_metabolize(mob/living/carbon/M)
    . = ..()
    if(!ishuman(M))
        return
    REMOVE_TRAIT(M, TRAIT_PARALYSIS_L_ARM, type)
    REMOVE_TRAIT(M, TRAIT_PARALYSIS_R_ARM, type)
    REMOVE_TRAIT(M, TRAIT_PARALYSIS_L_LEG, type)

    REMOVE_TRAIT(M, TRAIT_PARALYSIS_R_LEG, type)

