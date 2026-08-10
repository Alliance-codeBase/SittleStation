// Set these to zero's to disable them completely
#define METACOIN_REWARD_ROUNDSTART_READY 10
#define METACOIN_REWARD_SURVIVE_EVAC 25
#define METACOIN_REWARD_IMPORTANT_JOBS 50
#define METACOIN_REWARD_ANTAG_GREENTEXT 50
#define METACOIN_IMPORTANT_JOBS list(JOB_SHAFT_MINER, JOB_CAPTAIN, JOB_HEAD_OF_PERSONNEL, JOB_HEAD_OF_SECURITY, JOB_RESEARCH_DIRECTOR, JOB_SECURITY_OFFICER_SUPPLY, JOB_SECURITY_OFFICER_SCIENCE, JOB_SECURITY_OFFICER_ENGINEERING, JOB_WARDEN, JOB_SECURITY_OFFICER, JOB_CHIEF_MEDICAL_OFFICER, JOB_DETECTIVE, JOB_CHIEF_ENGINEER ) // THIS SHALL BE IN CONFIG, BUT I'M VERY LAZY, OKAY?
#define METACOIN_ICON_PATH "icons/obj/economy.dmi"
#define METACOIN_ICON_STATE "coin_tails" // someone get us a nice lil' carp_coin sprite, or "masscoin"

GLOBAL_DATUM(metacoins_controller, /datum/metacoins_controller)

/proc/get_metacoins_controller()
	if(!GLOB.metacoins_controller)
		GLOB.metacoins_controller = new /datum/metacoins_controller()
		GLOB.metacoins_controller.register_round_callbacks()
	return GLOB.metacoins_controller

/datum/modpack/metacoins/initialize()
	. = ..()
	if(.)
		return
	get_metacoins_controller()
	get_metacoin_controller()

/datum/metacoins_controller
	var/list/round_award_log_by_ckey = list()
	var/list/awarded_sources_by_ckey = list()
	var/round_awards_applied = FALSE

/datum/metacoins_controller/proc/register_round_callbacks()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(on_round_start)))
	SSticker.OnRoundend(CALLBACK(src, PROC_REF(grant_round_end_rewards)))

/datum/metacoins_controller/proc/on_round_start()
	round_awards_applied = FALSE
	round_award_log_by_ckey = list()
	awarded_sources_by_ckey = list()

	if(METACOIN_REWARD_ROUNDSTART_READY <= 0)
		return

	var/list/ready_ckeys = list()
	for(var/ready_ckey in GLOB.joined_player_list)
		if(!ready_ckey)
			continue
		ready_ckeys[ready_ckey] = TRUE

	for(var/player_ckey in ready_ckeys)
		award_metacoins(player_ckey, METACOIN_REWARD_ROUNDSTART_READY, "roundstart_ready", "Roundstart Ready")

/datum/metacoins_controller/proc/grant_round_end_rewards()
	if(round_awards_applied)
		return

	round_awards_applied = TRUE

	var/list/processed_ckeys = list()
	for(var/player_ckey in GLOB.joined_player_list)
		if(!player_ckey || processed_ckeys[player_ckey])
			continue

		processed_ckeys[player_ckey] = TRUE

		var/list/rewards = get_round_rewards(player_ckey)
		if(length(rewards))
			award_entries(player_ckey, rewards)
/// Main proc for your awards. Integrate it wherever you like to
///
/// Arguments:
/// * target_ckey - Player ckey that receives metacoins.
/// * reward_value - Direct amount, or an award typepath when resolve_from_award_type is TRUE.
/// * source - Source key for round log entries and per-round dedupe checks.
/// * reason - reason shown in reward chat message.
/// * allow_repeat - If TRUE, skips source dedupe and allows payout on every call.
/// * resolve_from_award_type - If TRUE, reward_value is resolved through the award datum's reward var.
/// * sound - If TRUE plays a sound, check notify_reward
/// Returns TRUE when payout is persisted, FALSE otherwise.
/datum/metacoins_controller/proc/award_metacoins(target_ckey, reward_value, source, reason, allow_repeat = FALSE, resolve_from_award_type = FALSE, sound = TRUE)
	var/amount
	if(resolve_from_award_type)
		amount = get_reward_amount(reward_value)
	else
		amount = reward_value
	if(!target_ckey || amount <= 0)
		return FALSE

	var/list/rewards = list(list(
		"amount" = amount,
		"source" = source || "unknown",
		"reason" = reason || "Reward",
		"by_award_type" = resolve_from_award_type,
	))
	return award_entries(target_ckey, rewards, allow_repeat, sound)

/datum/metacoins_controller/proc/award_entries(target_ckey, list/rewards, allow_repeat = FALSE, sound = TRUE)
	if(!target_ckey || !length(rewards))
		return FALSE

	var/list/source_awards
	if(!allow_repeat)
		source_awards = awarded_sources_by_ckey[target_ckey]
		if(!islist(source_awards))
			source_awards = list()
			awarded_sources_by_ckey[target_ckey] = source_awards

	var/total_amount = 0
	var/list/pay_rewards = list()
	for(var/list/reward_entry as anything in rewards)
		var/amount = reward_entry["amount"] || 0
		if(amount <= 0)
			continue

		var/sanitized_source = reward_entry["source"] || "unknown"
		var/sanitized_reason = reward_entry["reason"] || "Reward"
		if(!allow_repeat && source_awards[sanitized_source])
			continue

		pay_rewards += list(list(
			"amount" = amount,
			"source" = sanitized_source,
			"reason" = sanitized_reason,
			"by_award_type" = reward_entry["by_award_type"] || FALSE,
		))
		total_amount += amount

	if(total_amount <= 0)
		return FALSE

	if(!add_metacoins(target_ckey, total_amount))
		return FALSE

	if(!allow_repeat)
		for(var/list/reward_entry as anything in pay_rewards)
			source_awards[reward_entry["source"]] = TRUE

	for(var/list/reward_entry as anything in pay_rewards)
		add_round_award_log_entry(target_ckey, reward_entry["amount"], reward_entry["source"], reward_entry["reason"])

	notify_reward(target_ckey, total_amount, pay_rewards, sound)

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(player_mob)
		SStgui.update_user_uis(player_mob)

	return TRUE

/datum/metacoins_controller/proc/get_round_rewards(target_ckey)
	var/list/rewards = list()
	if(METACOIN_REWARD_SURVIVE_EVAC > 0 && is_evacuation_condition_met(target_ckey))
		rewards += list(list(
			"amount" = METACOIN_REWARD_SURVIVE_EVAC,
			"source" = "survived_shift",
			"reason" = "Survived Shift",
		))
	if(METACOIN_REWARD_IMPORTANT_JOBS > 0 && is_important_role(target_ckey))
		rewards += list(list(
			"amount" = METACOIN_REWARD_IMPORTANT_JOBS,
			"source" = "social_role",
			"reason" = "Highly Important Role",
		))
	if(METACOIN_REWARD_ANTAG_GREENTEXT > 0 && is_antag_greentext(target_ckey))
		rewards += list(list(
			"amount" = METACOIN_REWARD_ANTAG_GREENTEXT,
			"source" = "antag_greentext",
			"reason" = "Antagonist Greentext",
		))
	return rewards

/datum/metacoins_controller/proc/get_reward_amount(award_type)
	if(!ispath(award_type, /datum/award))
		return 0

	var/datum/award/award_path = award_type
	var/reward = award_path.reward
	if(isnull(reward))
		reward = 50

	return reward

/datum/metacoins_controller/proc/get_round_bonus(target_ckey)
	if(!target_ckey)
		return 0

	var/list/award_log = round_award_log_by_ckey[target_ckey]
	if(!islist(award_log))
		return 0

	var/total_reward = 0
	for(var/list/award_entry in award_log)
		total_reward += award_entry["amount"] || 0

	return total_reward

/datum/metacoins_controller/proc/get_round_award_log(target_ckey)
	if(!target_ckey)
		return list()

	var/list/award_log = round_award_log_by_ckey[target_ckey]
	if(!islist(award_log))
		return list()

	return award_log.Copy()

/datum/metacoins_controller/proc/add_round_award_log_entry(target_ckey, amount, source, reason)
	if(!target_ckey || amount <= 0)
		return

	var/list/award_log = round_award_log_by_ckey[target_ckey]
	if(!islist(award_log))
		award_log = list()
		round_award_log_by_ckey[target_ckey] = award_log

	award_log += list(list(
		"amount" = amount,
		"source" = source || "unknown",
		"reason" = reason || "No reason",
		"time" = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"),
	))

/datum/metacoins_controller/proc/get_round_mind(target_ckey)
	if(!target_ckey)
		return

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(player_mob?.mind)
		return player_mob.mind

	for(var/datum/mind/player_mind in SSticker.minds)
		if(ckey(player_mind?.key) == target_ckey)
			return player_mind

/datum/metacoins_controller/proc/is_evacuation_condition_met(target_ckey)
	var/datum/mind/player_mind = get_round_mind(target_ckey)
	if(!player_mind)
		return FALSE

	if(!considered_alive(player_mind, enforce_human = FALSE))
		return FALSE

	if(SSshuttle.emergency?.mode != SHUTTLE_ENDGAME)
		return FALSE

	var/mob/player_mob = player_mind.current
	var/area/player_area = get_area(player_mob)
	if(!player_area || istype(player_area, /area/shuttle/escape/brig))
		return FALSE

	var/turf/player_turf = get_turf(player_mob)
	if(!player_turf)
		return FALSE

	if(player_turf.onCentCom() || player_turf.onSyndieBase() || player_turf.on_escaped_shuttle())
		return TRUE

	return !!SSshuttle.emergency.shuttle_areas[player_area]

/datum/metacoins_controller/proc/is_important_role(target_ckey)
	var/datum/mind/player_mind = get_round_mind(target_ckey)
	var/job_title = player_mind?.assigned_role?.title
	if(!job_title)
		return FALSE

	return (job_title in METACOIN_IMPORTANT_JOBS)

/datum/metacoins_controller/proc/is_antag_greentext(target_ckey)
	var/datum/mind/player_mind = get_round_mind(target_ckey)
	if(!player_mind || !length(player_mind.antag_datums))
		return FALSE

	for(var/datum/antagonist/antag_datum as anything in player_mind.antag_datums)
		if(istype(antag_datum, /datum/antagonist/greentext))
			return TRUE
		if(antag_datum.antag_flags & ANTAG_FAKE)
			continue
		if(!is_greentext(antag_datum))
			continue
		return TRUE

	return FALSE

/datum/metacoins_controller/proc/is_greentext(datum/antagonist/antag_datum)
	if(!antag_datum)
		return FALSE

	if(!length(antag_datum.objectives))
		return TRUE

	for(var/datum/objective/objective as anything in antag_datum.objectives)
		if(!objective.check_completion())
			return FALSE

	return TRUE

/datum/metacoins_controller/proc/notify_reward(target_ckey, total_reward, list/reward_entries, sound = TRUE)
	if(total_reward <= 0)
		return

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(!player_mob)
		return

	var/list/reason_parts = list()
	for(var/list/reward_entry in reward_entries)
		var/entry_amount = reward_entry["amount"] || 0
		if(entry_amount <= 0)
			continue
		reason_parts += "+[entry_amount] [reward_entry["reason"] || "Reward"]"

	var/reasons_text = length(reason_parts) ? jointext(reason_parts, ", ") : "+[total_reward] Reward"
	if(sound)
		player_mob.playsound_local(player_mob, 'sound/effects/coin2.ogg', 40, TRUE, use_reverb = FALSE, pressure_affected = FALSE)
	to_chat(player_mob, span_boldnicegreen("You received [total_reward] metacoins ([reasons_text])."))

/datum/metacoins_controller/proc/fetch_balance(target_ckey)
	if(!target_ckey)
		return 0
	if(!SSdbcore.Connect())
		return null

	var/table_player = format_table_name("player")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT metacoins FROM [table_player] WHERE ckey = :ckey",
		list("ckey" = target_ckey),
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return null

	var/balance = 0
	if(query.NextRow(async = FALSE))
		balance = query.item[1] || 0
	qdel(query)
	return balance

/datum/metacoins_controller/proc/add_metacoins(target_ckey, amount)
	if(!target_ckey || amount <= 0)
		return FALSE
	if(!SSdbcore.Connect())
		return FALSE

	var/table_player = format_table_name("player")
	var/datum/db_query/update_query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins + :amount WHERE ckey = :ckey",
		list(
			"amount" = amount,
			"ckey" = target_ckey,
		),
	)

	var/success = update_query.warn_execute(async = FALSE)
	var/affected = update_query.affected
	qdel(update_query)
	return success && affected > 0

///Takes coins in one atomic query
/datum/metacoins_controller/proc/take_metacoins(target_ckey, amount)
	if(!target_ckey || !isnum(amount) || amount <= 0)
		return list("ok" = FALSE, "error" = "invalid_request")

	var/current_balance = fetch_balance(target_ckey)
	if(isnull(current_balance))
		return list("ok" = FALSE, "error" = "db_unavailable")
	if(current_balance < amount)
		return list("ok" = FALSE, "error" = "not_enough")

	var/table_player = format_table_name("player")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins - :amount WHERE ckey = :ckey AND metacoins >= :amount",
		list(
			"amount" = amount,
			"ckey" = target_ckey,
		),
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return list("ok" = FALSE, "error" = "db_failed")
	qdel(query)

	var/balance = fetch_balance(target_ckey)
	if(isnull(balance))
		return list("ok" = FALSE, "error" = "db_failed")
	if(balance > current_balance - amount)
		return list("ok" = FALSE, "error" = "not_enough")

	return list("ok" = TRUE, "balance" = balance)

/datum/metacoinshop/panel/wallet
	interface_id = "MetaCoins"

/datum/metacoinshop/panel/wallet/ui_data(mob/user)
	var/list/data = list()
	var/datum/metacoins_controller/controller = get_metacoins_controller()
	var/client_ckey = owner?.ckey

	data["coinIcon"] = METACOIN_ICON_PATH
	data["coinIconState"] = METACOIN_ICON_STATE
	data["roundAwardsApplied"] = controller.round_awards_applied
	data["roundAwarded"] = client_ckey ? controller.get_round_bonus(client_ckey) : 0
	data["roundAwardLog"] = client_ckey ? controller.get_round_award_log(client_ckey) : list()
	data["canOpenShop"] = TRUE

	var/balance = controller.fetch_balance(client_ckey)
	data["dbConnected"] = !isnull(balance)
	data["balance"] = isnull(balance) ? 0 : balance

	return data

/datum/metacoinshop/panel/wallet/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "open_shop")
		new /datum/metacoinshop/panel/shop(owner, ui.user)
		return TRUE

	return FALSE

/client/verb/view_metacoins()
	set name = "View Metacoins"
	set category = "OOC"
	set desc = "View your metacoin balance and this round award log."

	new /datum/metacoinshop/panel/wallet(src, usr)

#undef METACOIN_REWARD_ROUNDSTART_READY
#undef METACOIN_REWARD_SURVIVE_EVAC
#undef METACOIN_REWARD_IMPORTANT_JOBS
#undef METACOIN_REWARD_ANTAG_GREENTEXT
#undef METACOIN_IMPORTANT_JOBS
#undef METACOIN_ICON_PATH
#undef METACOIN_ICON_STATE
