#define SIN_GLUTTONY "gluttony"
#define SIN_GREED "greed"
#define SIN_SLOTH "sloth"
#define SIN_WRATH "wrath"
#define SIN_ENVY "envy"
#define SIN_PRIDE "pride"

/datum/demon_ability
	var/name = "Ability"
	var/desc = "Shit Code."
	var/cost = 2201984
	var/unlocked = FALSE
	var/spell_path
	var/required_sin = null
	var/persistent = FALSE

/datum/demon_ability/proc/on_purchase(mob/living/demon_mob)
	if(!spell_path)
		return FALSE
	var/datum/action/cooldown/spell/S = new spell_path()
	S.Grant(demon_mob)
	to_chat(demon_mob, span_purple("You have unlocked the ability: [name]!"))
	return TRUE

/datum/demon_ability/shapeshift
	name = "Demon Form"
	desc = "Allows you to assume your true infernal shape."
	cost = 50
	spell_path = /datum/action/cooldown/spell/shapeshift/demon
	required_sin = list(SIN_GREED, SIN_ENVY, SIN_PRIDE)

/datum/demon_ability/shapeshift/gluttony
	name = "Gluttonous Form"
	desc = "A special true form tailored for gluttony demons."
	cost = 50
	spell_path = /datum/action/cooldown/spell/shapeshift/demon/gluttony
	required_sin = SIN_GLUTTONY

/datum/demon_ability/shapeshift/wrath
	name = "Wrathful Form"
	desc = "A highly destructive true form meant for combat."
	cost = 50
	spell_path = /datum/action/cooldown/spell/shapeshift/demon/wrath
	required_sin = SIN_WRATH

/datum/demon_ability/shapeshift/sloth
	name = "Sloth Form"
	desc = "A lazier form of basic form meant for sleeping."
	cost = 50
	spell_path = /datum/action/cooldown/spell/shapeshift/demon/sloth
	required_sin = SIN_SLOTH

/datum/demon_ability/ignite
	name = "Ignite"
	desc = "Channels the fires of hell to set your target ablaze."
	cost = 100
	spell_path = /datum/action/cooldown/spell/pointed/ignite
	required_sin = SIN_WRATH

/datum/demon_ability/summon_mirror
	name = "Summon Mirror"
	desc = "Summon forth a temporary mirror of sin that will allow you and others to change anything they want about themselves."
	cost = 100
	spell_path = /datum/action/cooldown/spell/conjure/summon_mirror
	required_sin = SIN_PRIDE

/datum/demon_ability/mend_hand
	name = "Mend Hand"
	desc = "Engulfs your arm in a healing powers. Can't target yourself."
	cost = 100
	spell_path = /datum/action/cooldown/spell/touch/mend
	required_sin = SIN_PRIDE

/datum/demon_ability/ethereal_jaunt
	name = "Infernal Phase"
	desc = "Temporarily cross into the nether realm to pass through solid walls."
	cost = 200
	spell_path = /datum/action/cooldown/spell/jaunt/ethereal_jaunt/sin
	required_sin = list(SIN_GREED, SIN_GLUTTONY, SIN_ENVY, SIN_PRIDE)

/datum/demon_ability/ethereal_jaunt/wrath
	name = "Infernal Phase"
	desc = "Temporarily cross into the nether realm to pass through solid walls."
	cost = 200
	spell_path = /datum/action/cooldown/spell/jaunt/ethereal_jaunt/sin/wrath
	required_sin = SIN_WRATH

/datum/demon_ability/ethereal_jaunt/sloth
	name = "Infernal Phase"
	desc = "Temporarily cross into the nether realm to pass through solid walls."
	cost = 200
	spell_path = /datum/action/cooldown/spell/jaunt/ethereal_jaunt/sin/sloth
	required_sin = SIN_SLOTH

/datum/demon_ability/cursed_items
	name = "Summon Cursed Item"
	desc = "Manifest a random cursed object from hell beneath you."
	cost = 200
	spell_path = /datum/action/cooldown/spell/conjure/cursed_item
	required_sin = SIN_GREED

/datum/demon_ability/greed_slots
	name = "Summon Slotmachine"
	desc = "Summon forth a temporary slot machine of greed, allowing you to offer patrons a deadly game where the price is their lifes."
	cost = 777
	spell_path = /datum/action/cooldown/spell/conjure/summon_greedslots
	required_sin = SIN_GREED

/datum/demon_ability/envy_hand
	name = "Vanity Steal"
	desc = "Engulfs your arm in a jealous might, allowing you to steal the look of the first human-like struck with it. Note, the form change is not reversible."
	cost = 200
	spell_path = /datum/action/cooldown/spell/touch/envy
	required_sin = SIN_ENVY

/datum/demon_ability/forcewall_gluttony
	name = "Gluttonous Wall"
	desc = "Create a magical barrier that only allows fat people to pass through."
	cost = 300
	spell_path = /datum/action/cooldown/spell/forcewall/gluttony
	required_sin = SIN_GLUTTONY

/datum/demon_ability/torment
	name = "Torment"
	desc = "Torment your enemies, or just crew."
	cost = 160
	spell_path = /datum/action/cooldown/spell/touch/torment
	required_sin = list(SIN_WRATH, SIN_ENVY)

/datum/demon_ability/sleep_hand
	name = "Mimir"
	desc = "You make sleep energy, which forces all yawns, and stuns target."
	cost = 160
	spell_path = /datum/action/cooldown/spell/touch/sleepy
	required_sin = SIN_SLOTH

/datum/demon_ability/timestop
	name = "Slothful Stasis"
	desc = "This spell stops time for everyone INCLUDE you."
	cost = 220
	spell_path = /datum/action/cooldown/spell/timestop/sloth
	required_sin = SIN_SLOTH

/datum/antagonist/sinfuldemon
	name = "Sinful Demon"
	roundend_category = "demons of sin"
	antagpanel_category = "Demon"
	antag_hud_name = "demon"
	pref_flag = ROLE_SINFULDEMON
	hud_icon = 'modular_meta/features/antagonists/icons/sinful_demon/demon_icons.dmi'
	ui_name = "AntagInfoSinfulDemon"
	var/demonsin
	var/static/list/demonsins = list(SIN_GLUTTONY, SIN_GREED, SIN_WRATH, SIN_ENVY, SIN_PRIDE, SIN_SLOTH)

	var/ui_force_refresh_timer = 0
	var/sin_points = 0
	var/list/available_shop_abilities = list()
	var/objective_refresh_timer = 0
	var/has_rerolled_sin = FALSE
	var/currently_corrupting = FALSE
	var/list/corrupted_tiles = list()

	var/static/list/sinfuldemon_traits = list(
		TRAIT_GENELESS,
		TRAIT_STABLEHEART,
		TRAIT_NOCRITDAMAGE,
	)

/datum/antagonist/sinfuldemon/New()
	. = ..()
	if(!demonsin)
		demonsin = pick(demonsins)

/datum/antagonist/sinfuldemon/forge_objectives()
	if(!owner)
		return

	var/datum/objective/survive/survive = new()
	survive.owner = owner
	survive.explanation_text = "Spread the sin of [demonsin] and survive until the end of the round."
	objectives += survive

	var/datum/objective/demon_absorb_highrisk/highrisk = new()
	highrisk.owner = owner
	objectives += highrisk

	var/datum/objective/demon_corrupt_area/corruption = new()
	corruption.owner = owner
	objectives += corruption

/datum/antagonist/sinfuldemon/can_be_owned(datum/mind/new_owner)
	. = ..()
	return . && (ishuman(new_owner.current) || iscyborg(new_owner.current))

/datum/antagonist/sinfuldemon/admin_add(datum/mind/new_owner, mob/admin)
	var/choices = demonsins + "Random"
	var/chosen_sin = input(admin, "What kind ?", "Sin kind") as null|anything in choices
	if(!chosen_sin)
		return
	if(chosen_sin in demonsins)
		demonsin = chosen_sin
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has demonized [key_name_admin(new_owner)].")
	log_admin("[key_name(admin)] has demonized [key_name(new_owner)].")

/datum/antagonist/sinfuldemon/antag_listing_name()
	return ..() + " (demon of [demonsin])"

/datum/antagonist/sinfuldemon/greet()
	to_chat(owner.current, span_warning("<b>You remember your link to the infernal. You are a demon of [demonsin] released from hell to spread sin amongst the living.</b>"))
	to_chat(owner.current, span_warning("<b>Your half demon, half human form grants you increased fortitude, allowing you to resist more damage before going down.</b>"))
	to_chat(owner.current, span_warning("<b>However, your infernal form is not without weaknesses.</b>"))
	to_chat(owner.current, "You are incredibly vulnerable to holy artifacts and influence.")
	to_chat(owner.current, "While blessed with the unholy ability to transform into your true form, this form is extremely obvious and vulnerable to holy weapons.")
	to_chat(owner.current, "[span_warning("Do your best to complete your objectives without unnessecary death, unless you are a wrathful demon.")]<br>")

	if(objectives && length(objectives))
		to_chat(owner.current, span_notice("Your Current Objectives, they can change aftertime:"))
		for(var/datum/objective/O in objectives)
			to_chat(owner.current, " - [O.explanation_text]")

	SEND_SOUND(owner.current, sound('sound/effects/magic/ethereal_exit.ogg'))

/datum/antagonist/sinfuldemon/on_gain()
	owner.current.add_faction(FACTION_HELL)
	for(var/all_traits in sinfuldemon_traits)
		ADD_TRAIT(owner.current, all_traits, SINFULDEMON_TRAIT)
	forge_objectives()
	InitializeShop()
	START_PROCESSING(SSprocessing, src)

	RegisterSignal(src, "demon_give_points", PROC_REF(handle_points_signal))

	greet()
	ui_interact(owner.current)

	switch(demonsin)
		if(SIN_GLUTTONY)
			var/datum/movespeed_modifier/fatty/fatty = new(owner.current)
			fatty.New(owner.current)
	return ..()

/datum/antagonist/sinfuldemon/proc/handle_points_signal(datum/source, amount)
	SIGNAL_HANDLER
	if(amount > 0)
		add_sin_points(amount)

/datum/antagonist/sinfuldemon/on_removal()
	STOP_PROCESSING(SSprocessing, src)
	if(owner && owner.current)
		UnregisterSignal(src, "demon_give_points")
		owner.current.remove_faction(FACTION_HELL)
		for(var/all_status_traits in owner.current._status_traits)
			REMOVE_TRAIT(owner.current, all_status_traits, SINFULDEMON_TRAIT)
		for(var/datum/action/cooldown/spell in owner.current.actions)
			QDEL_NULL(spell)
			owner.current.actions -= spell
	to_chat(owner.current, span_userdanger("Your infernal link has been severed!"))
	return ..()

/datum/antagonist/sinfuldemon/apply_innate_effects(mob/living/mob_override)
	var/mob/living/current_mob = mob_override || owner.current
	handle_clown_mutation(current_mob, mob_override ? null : "Your infernal nature has allowed you to overcome your clownishness.")
	RegisterSignal(current_mob, COMSIG_LIVING_LIFE, PROC_REF(sinfuldemon_life))

/datum/antagonist/sinfuldemon/remove_innate_effects(mob/living/mob_override)
	var/mob/living/current_mob = mob_override || owner.current
	UnregisterSignal(current_mob, COMSIG_LIVING_LIFE)
	return ..()

/datum/antagonist/sinfuldemon/process(seconds_per_tick)
	if(!owner || !owner.current)
		return
	var/mob/living/living = owner.current
	if(living.stat == DEAD || !is_station_level(living.z))
		return

	if(living.health >= living.maxHealth)
		var/final_points = (10 / 60) * seconds_per_tick
		add_sin_points(final_points)
	else
		SStgui.update_uis(living)

	for(var/datum/objective/O in objectives)
		if(istype(O, /datum/objective/demon_corrupt_area))
			SEND_SIGNAL(O, "corrupt_area_tick", living, seconds_per_tick)
		if(istype(O, /datum/objective/demon_absorb_highrisk))
			SEND_SIGNAL(O, "absorb_item_tick", living, seconds_per_tick)

	objective_refresh_timer += seconds_per_tick
	if(objective_refresh_timer >= 600)
		objective_refresh_timer = 0
		refresh_objectives()

	ui_force_refresh_timer += seconds_per_tick
	if(ui_force_refresh_timer >= 5)
		ui_force_refresh_timer = 0
		var/datum/tgui/ui = SStgui.get_open_ui(living, src)
		if(ui)
			ui.send_full_update()

/datum/antagonist/sinfuldemon/proc/refresh_objectives()
	var/mob/living/living = owner?.current
	if(!living || !owner)
		return

	var/list/objectives_to_remove = list()
	for(var/datum/objective/O in objectives)
		if(istype(O, /datum/objective/demon_absorb_highrisk) || istype(O, /datum/objective/demon_corrupt_area))
			objectives_to_remove += O

	for(var/datum/objective/O in objectives_to_remove)
		objectives -= O
		qdel(O)

	var/datum/objective/demon_absorb_highrisk/new_absorb = new()
	var/item_exists_on_station = FALSE
	for(var/obj/item/I in world)
		var/turf/I_turf = get_turf(I)
		if(I_turf && is_station_level(I_turf.z) && I.type == new_absorb.target_type && !(I in GLOB.demon_absorbed_highrisk_items))
			item_exists_on_station = TRUE
			break

	if(item_exists_on_station)
		new_absorb.owner = owner
		objectives += new_absorb
	else
		qdel(new_absorb)

	var/datum/objective/demon_corrupt_area/new_corrupt = new()
	new_corrupt.owner = owner
	objectives += new_corrupt

	to_chat(living, span_purple("The shifting tides of hell have updated your dark objectives! Check your Infernal Legacy menu."))

	SStgui.update_uis(living)

/datum/antagonist/sinfuldemon/proc/sinfuldemon_life(mob/living/source, seconds_per_tick, times_fired)
	var/mob/living/carbon/carbon_source = source
	if(!carbon_source)
		return
	if(istype(get_area(carbon_source), /area/station/service/chapel))
		demon_burn()

/datum/antagonist/sinfuldemon/proc/demon_burn()
	var/mob/living/living = owner.current
	if(!living)
		return
	if(living.stat != DEAD)
		if(prob(50) && living.health >= 50)
			switch(living.health)
				if(85 to 100)
					living.visible_message(span_warning("[living]'s skin begins to heat up and darken!"), span_danger("Your flesh begins to sear..."))
				if(60 to 85)
					living.visible_message(span_warning("[living]'s skin begins to melt apart!"), span_danger("Your skin is melting!"), "You hear sizzling.")
			living.adjust_fire_loss(5)
		else if(living.health < 60)
			if(!living.on_fire)
				living.visible_message(span_warning("[living] lights up in a holy blaze!"), span_danger("Your skin catches fire!"))
				living.emote("scream")
			else
				living.visible_message(span_warning("[living] continues to burn!"), span_danger("You continue to burn!"))
			living.adjust_fire_stacks(5)
			living.ignite_mob()
	return

/datum/antagonist/sinfuldemon/roundend_report()
	var/list/parts = list()
	parts += printplayer(owner)

	var/list/visible_objectives = list()
	if(objectives && length(objectives))
		for(var/datum/objective/O in objectives)
			if(istype(O, /datum/objective/demon_absorb_highrisk) || istype(O, /datum/objective/demon_corrupt_area))
				continue
			visible_objectives += O
	parts += printobjectives(visible_objectives)
	return parts.Join("<br>")

/datum/antagonist/sinfuldemon/proc/InitializeShop()
	var/list/all_shop_types = subtypesof(/datum/demon_ability)
	var/mob/living/living = owner?.current

	for(var/ability in all_shop_types)
		var/already_exists = FALSE
		for(var/datum/demon_ability/existing in available_shop_abilities)
			if(existing.type == ability)
				already_exists = TRUE
				break
		if(already_exists)
			continue

		var/datum/demon_ability/ability_instance = new ability()
		var/should_add = FALSE

		if(isnull(ability_instance.required_sin))
			should_add = TRUE
		else if(islist(ability_instance.required_sin))
			var/list/sin_list = ability_instance.required_sin
			if(sin_list.Find(demonsin))
				should_add = TRUE
		else if(ability_instance.required_sin == demonsin)
			should_add = TRUE

		if(should_add)
			available_shop_abilities += ability_instance
			if(ability_instance.cost == 0 && !ability_instance.unlocked && living)
				ability_instance.unlocked = TRUE
				ability_instance.on_purchase(living)
		else
			qdel(ability_instance)

/datum/antagonist/sinfuldemon/proc/add_sin_points(amount)
	sin_points += amount
	if(owner && owner.current)
		SStgui.update_uis(owner.current)

/datum/antagonist/sinfuldemon/proc/purchase_ability(mob/living/user, datum/demon_ability/ability)
	if(ability.unlocked)
		to_chat(user, span_warning("You have already purchased this ability!"))
		return FALSE
	if(sin_points < ability.cost)
		to_chat(user, span_warning("Inadequate sin points! Required: [ability.cost]"))
		return FALSE

	sin_points -= ability.cost
	ability.unlocked = TRUE
	ability.on_purchase(user)
	return TRUE

/datum/antagonist/sinfuldemon/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AntagInfoSinfulDemon", "Infernal Legacy")
		ui.open()

/datum/antagonist/sinfuldemon/ui_status(mob/user, state)
	return ..()

/datum/antagonist/sinfuldemon/ui_data(mob/user)
	var/list/data = list()
	data["fluff"] = "You are a Sinful Demon!"
	data["explain_attack"] = TRUE
	data["demonsin"] = demonsin
	data["points"] = round(sin_points)
	data["next_refresh_in"] = max(0, 600 - objective_refresh_timer)
	data["can_reroll_sin"] = !has_rerolled_sin

	var/list/obj_list = list()
	if(objectives && length(objectives))
		for(var/datum/objective/O in objectives)
			var/list/obj_data = list()
			if(istype(O, /datum/objective/demon_corrupt_area))
				var/datum/objective/demon_corrupt_area/CA = O
				obj_data["explanation"] = CA.get_progress_text()
			else if(istype(O, /datum/objective/demon_absorb_highrisk))
				var/datum/objective/demon_absorb_highrisk/AH = O
				obj_data["explanation"] = AH.get_progress_text()
			else
				obj_data["explanation"] = O.explanation_text
			obj_data["completed"] = O.completed
			obj_list += list(obj_data)
	data["objectives"] = obj_list

	var/list/abilities_list = list()
	if(available_shop_abilities && length(available_shop_abilities))
		for(var/datum/demon_ability/ability in available_shop_abilities)
			var/list/ab_data = list()
			ab_data["name"] = ability.name
			ab_data["desc"] = ability.desc
			ab_data["cost"] = ability.cost
			ab_data["unlocked"] = ability.unlocked
			ab_data["ref"] = REF(ability)
			abilities_list += list(ab_data)
	data["abilities"] = abilities_list

	return data

/datum/antagonist/sinfuldemon/ui_act(action, list/params, datum/tgui/ui, state)
	. = ..()
	if(.)
		return TRUE

	switch(action)
		if("buy_ability")
			var/datum/demon_ability/ability = locate(params["ref"]) in available_shop_abilities
			if(ability)
				purchase_ability(ui.user, ability)
				return TRUE

		if("reroll_sin")
			if(has_rerolled_sin)
				return TRUE
			if(sin_points < 666)
				to_chat(ui.user, span_warning("Inadequate sin points! Required 666 of it"))
				return TRUE

			var/mob/living/living = ui.user
			sin_points -= 666
			has_rerolled_sin = TRUE

			var/list/demon_possible_sins = demonsins.Copy()
			demon_possible_sins -= demonsin
			var/demon_old_sin = demonsin
			demonsin = pick(demon_possible_sins)

			to_chat(living, span_userdanger("Your essence shifts! You are no longer a demon of [demon_old_sin]. You have become a Demon of [uppertext(demonsin)]!"))

			var/new_sin_has_jaunt_alternative = (demonsin == SIN_WRATH || demon_old_sin == SIN_WRATH)

			var/list/sins_with_custom_forms = list(SIN_WRATH, SIN_GLUTTONY, SIN_SLOTH)
			var/new_sin_has_form_alternative = (sins_with_custom_forms.Find(demonsin) || sins_with_custom_forms.Find(demon_old_sin))

			if(living && living.actions)
				if(new_sin_has_form_alternative)
					for(var/datum/action/cooldown/spell/shapeshift/old_form in living.actions)
						qdel(old_form)
				if(new_sin_has_jaunt_alternative)
					for(var/datum/action/cooldown/spell/jaunt/ethereal_jaunt/sin/old_jaunt in living.actions)
						qdel(old_jaunt)

			var/list/abilities_to_keep = list()
			var/returned_points = 0

			for(var/datum/demon_ability/BA in available_shop_abilities)
				if(BA.unlocked)
					if(istype(BA, /datum/demon_ability/shapeshift))
						if(new_sin_has_form_alternative)
							returned_points += BA.cost
							qdel(BA)
							continue
						else
							abilities_to_keep += BA
							continue

					if(istype(BA, /datum/demon_ability/ethereal_jaunt))
						if(new_sin_has_jaunt_alternative)
							returned_points += BA.cost
							qdel(BA)
							continue
						else
							abilities_to_keep += BA
							continue

					abilities_to_keep += BA
				else
					if(BA.persistent)
						abilities_to_keep += BA
					else
						qdel(BA)

			if(returned_points > 0)
				sin_points += returned_points
				to_chat(living, span_purple("The underworld refunds you [returned_points] Sin Points for your abandoned links!"))

			available_shop_abilities = abilities_to_keep

			InitializeShop()
			refresh_objectives()
			return TRUE

	return FALSE

/datum/antagonist/sinfuldemon/proc/send_unique_beam(target_turf, atom/movable/source, time = 0.3 SECONDS, by_type = TRUE)
	if(by_type)
		switch(demonsin)
			if(SIN_GLUTTONY)
				source.Beam(target_turf, "sendbeam", 'icons/effects/beam.dmi', time, beam_color = "#8b9221ff")
			if(SIN_GREED)
				source.Beam(target_turf, "sendbeam", 'icons/effects/beam.dmi', time, beam_color = "#00fc86")
			if(SIN_WRATH)
				source.Beam(target_turf, "sendbeam", 'icons/effects/beam.dmi', time, beam_color = "#e94a4a")
			if(SIN_ENVY)
				source.Beam(target_turf, "sendbeam", 'icons/effects/beam.dmi', time, beam_color = "#81128b")
			if(SIN_PRIDE)
				var/datum/beam/pride_beam = source.Beam(target_turf, "sendbeam", 'icons/effects/beam.dmi', time, beam_color = "#f112a7")
				animate(pride_beam.visuals, time, color = "#e20849")
			if(SIN_SLOTH)
				source.Beam(target_turf, "sendbeam", 'icons/effects/beam.dmi', time, beam_color = "#c784b0")
	else
		source.Beam(target_turf, "sendbeam", 'icons/effects/beam.dmi', time)

#undef SIN_ENVY
#undef SIN_GLUTTONY
#undef SIN_GREED
#undef SIN_PRIDE
#undef SIN_SLOTH
#undef SIN_WRATH

/datum/antagonist/sinfuldemon/get_preview_icon()
	var/datum/universal_icon/sinfuldemon_icon = uni_icon('modular_meta/features/antagonists/icons/sinful_demon/passport_photo.dmi', "sinfuldemon")

	sinfuldemon_icon.scale(ANTAGONIST_PREVIEW_ICON_SIZE, ANTAGONIST_PREVIEW_ICON_SIZE)

	return sinfuldemon_icon
