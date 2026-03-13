#define BRAIN_TRAUMA_PUNISH_MODE_EXACT "exact"
#define BRAIN_TRAUMA_PUNISH_MODE_CATEGORY "category"

#define BRAIN_TRAUMA_PUNISH_MAX_REASON_LENGTH 600
#define BRAIN_TRAUMA_UNPANEL_PAGE_SIZE 10
#define BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT 20

GLOBAL_LIST_INIT(brain_trauma_punishment_forbidden_traumas, list(
	/datum/brain_trauma/special/imaginary_friend,
	/datum/brain_trauma/special/imaginary_friend/trapped_owner,
	/datum/brain_trauma/special/obsessed,
	/datum/brain_trauma/severe/split_personality,
	/datum/brain_trauma/severe/split_personality/brainwashing,
	/datum/brain_trauma/severe/split_personality/blackout,
	// Add any other forbidden trauma paths below. Keep the commentary though.
))

/proc/is_forbidden_brain_trauma_type(trauma_type)
	if(!ispath(trauma_type, /datum/brain_trauma))
		return FALSE

	for(var/forbidden_trauma in GLOB.brain_trauma_punishment_forbidden_traumas)
		if(!ispath(forbidden_trauma, /datum/brain_trauma))
			continue
		if(ispath(trauma_type, forbidden_trauma))
			return TRUE

	return FALSE

/datum/brain_trauma_punishment_manager
	var/check_interval = 1 MINUTES
	var/check_timer = TIMER_ID_NULL
	var/list/active_traumas_by_record = list()
	var/list/alerted_ckeys = list()
	var/debug_logging = FALSE

/datum/brain_trauma_punishment_manager/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGGED_IN, PROC_REF(on_mob_login))
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(on_crewmember_join))
	check_timer = addtimer(CALLBACK(src, PROC_REF(process_cycle)), check_interval, TIMER_STOPPABLE | TIMER_LOOP)
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(on_roundstart)))

/datum/brain_trauma_punishment_manager/Destroy(force)
	UnregisterSignal(SSdcs, list(COMSIG_GLOB_MOB_LOGGED_IN, COMSIG_GLOB_CREWMEMBER_JOINED))
	if(check_timer != TIMER_ID_NULL)
		deltimer(check_timer)
		check_timer = TIMER_ID_NULL
	active_traumas_by_record = null
	alerted_ckeys = null
	return ..()

/datum/brain_trauma_punishment_manager/proc/debug_log(message, notify_admins = FALSE)
	if(!debug_logging)
		return

	var/log_text = "[type] DEBUG: [message]"
	log_world(log_text)

	if(notify_admins)
		message_admins(span_adminnotice(log_text))

/datum/brain_trauma_punishment_manager/proc/get_record_cache_key(record_id)
	record_id = text2num(record_id)
	if(!record_id)
		return null

	return "id_[record_id]"

/datum/brain_trauma_punishment_manager/proc/process_cycle()
	if(!SSdbcore.Connect())
		return
	remove_expired_traumas()
	apply_to_all_connected()
	cleanup_invalid_refs()

/datum/brain_trauma_punishment_manager/proc/on_roundstart()
	if(!SSdbcore.Connect())
		return
	remove_expired_traumas()
	apply_to_all_connected()
	cleanup_invalid_refs()

/datum/brain_trauma_punishment_manager/proc/on_mob_login(datum/source, mob/logged_in)
	SIGNAL_HANDLER
	if(!SSdbcore.Connect())
		return
	if(!isliving(logged_in))
		return

	var/mob/living/living_mob = logged_in
	if(living_mob.stat == DEAD)
		return
	if(!living_mob.ckey)
		return

	debug_log("Login signal for [living_mob.ckey] ([living_mob.type]).")
	INVOKE_ASYNC(src, PROC_REF(apply_to_mob), living_mob)

/datum/brain_trauma_punishment_manager/proc/on_crewmember_join(datum/source, mob/living/new_crewmember, rank)
	SIGNAL_HANDLER
	if(!SSdbcore.Connect())
		return
	if(!istype(new_crewmember))
		return
	if(new_crewmember.stat == DEAD)
		return
	if(!new_crewmember.ckey)
		return

	debug_log("Crewmember join signal for [new_crewmember.ckey] ([new_crewmember.type]) rank=[rank].")
	INVOKE_ASYNC(src, PROC_REF(apply_to_mob), new_crewmember)

/datum/brain_trauma_punishment_manager/proc/apply_to_all_connected()
	var/applied_candidates = 0
	for(var/client/client_entry as anything in GLOB.clients)
		var/mob/living/living_mob = client_entry.mob
		if(!istype(living_mob))
			continue
		if(living_mob.stat == DEAD)
			continue
		applied_candidates++
		apply_to_mob(living_mob)

	if(applied_candidates)
		debug_log("apply_to_all_connected processed [applied_candidates] living mobs.")

/datum/brain_trauma_punishment_manager/proc/apply_to_mob(mob/living/living_mob)
	if(!islist(active_traumas_by_record))
		active_traumas_by_record = list()

	if(!iscarbon(living_mob))
		debug_log("Skipping non-carbon mob [living_mob] ([living_mob?.type]) for ckey [living_mob?.ckey].")
		return

	var/player_ckey = ckey(living_mob.ckey)
	if(!player_ckey)
		return

	debug_log("Checking active punishments for [player_ckey] on [living_mob.type].")

	var/datum/db_query/query_get = SSdbcore.NewQuery({"
		SELECT
			id,
			mode,
			trauma_path,
			trauma_category,
			resilience,
			trauma_count
		FROM [format_table_name("brain_trauma_punishment")]
		WHERE
			ckey = :ckey AND
			removed_datetime IS NULL AND
			(expiration_time IS NULL OR expiration_time > NOW())
	"}, list("ckey" = player_ckey))

	if(!query_get.warn_execute())
		debug_log("Failed to query active punishments for [player_ckey].", TRUE)
		qdel(query_get)
		return

	var/records_found = 0
	var/traumas_granted = 0
	var/any_active_records = FALSE
	while(query_get.NextRow())
		records_found++
		any_active_records = TRUE
		var/record_id = text2num(query_get.item[1])
		if(!record_id)
			debug_log("Skipping punishment row with invalid id for [player_ckey].")
			continue

		var/record_cache_key = get_record_cache_key(record_id)
		if(!record_cache_key)
			debug_log("Skipping punishment row #[record_id] due to invalid cache key for [player_ckey].")
			continue

		var/mode = query_get.item[2]
		var/trauma_path_text = query_get.item[3]
		var/trauma_category_text = query_get.item[4]
		var/resilience = text2num(query_get.item[5])
		if(!resilience)
			resilience = TRAUMA_RESILIENCE_ABSOLUTE
		var/trauma_count = text2num(query_get.item[6])
		if(trauma_count < 1)
			trauma_count = 1
		if(trauma_count > BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT)
			trauma_count = BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT

		var/list/refs_for_record = active_traumas_by_record[record_cache_key]
		if(!islist(refs_for_record))
			refs_for_record = list()
			active_traumas_by_record[record_cache_key] = refs_for_record

		var/current_count = count_active_traumas_on_mob(refs_for_record, living_mob)
		if(current_count >= trauma_count)
			debug_log("Skipping record #[record_id] for [player_ckey], already has [current_count]/[trauma_count] traumas on mob.")
			continue

		var/to_grant = trauma_count - current_count
		for(var/i in 1 to to_grant)
			var/datum/brain_trauma/granted = grant_trauma_by_record(living_mob, mode, trauma_path_text, trauma_category_text, resilience)
			if(!granted)
				debug_log("Record #[record_id] for [player_ckey] failed to grant trauma [i]/[to_grant] (mode=[mode], path=[trauma_path_text], category=[trauma_category_text], resilience=[resilience]).", TRUE)
				break

			var/datum/weakref/granted_ref = WEAKREF(granted)
			if(!isweakref(granted_ref))
				debug_log("Record #[record_id] for [player_ckey] granted trauma [granted.type], but failed to create weakref.", TRUE)
				continue

			refs_for_record += granted_ref
			traumas_granted++
			debug_log("Record #[record_id] granted [granted.type] to [player_ckey] ([i]/[to_grant]).")

	qdel(query_get)

	if(any_active_records)
		show_target_tgui_alert(living_mob)
	else
		clear_target_tgui_alert_flag(player_ckey)

	if(records_found && !traumas_granted)
		debug_log("Found [records_found] active punishment rows for [player_ckey], but granted 0 traumas.", TRUE)

/datum/brain_trauma_punishment_manager/proc/show_target_tgui_alert(mob/living/living_mob)
	set waitfor = FALSE

	if(!istype(living_mob)) // Shall not be shown, if our [living_mob], well.. isn't alive?
		return

	var/player_ckey = ckey(living_mob.ckey)
	if(!player_ckey)
		return

	if(!islist(alerted_ckeys))
		alerted_ckeys = list()

	if(alerted_ckeys[player_ckey])
		return

	living_mob.playsound_local(null, pick('sound/effects/pope_entry.ogg',
		'sound/effects/cartoon_sfx/cartoon_splat.ogg',
		'sound/items/bikehorn.ogg',
		'sound/effects/adminhelp.ogg'), 100, TRUE, pressure_affected = FALSE, use_reverb = FALSE)

	alerted_ckeys[player_ckey] = TRUE
	if(!prob(75))
		tgui_alert(living_mob, "You have been punished with recurring brain trauma by administrators.", "Divine Intervention!", list("Understood"), 0, TRUE, GLOB.always_state)
		return



	var/what_presses = 0
	while(TRUE)
		if(QDELETED(living_mob))
			return

		var/response = tgui_alert(living_mob, "You have been punished with recurring brain trauma by administrators.", "Divine Intervention!", list("Understood", "What?"), 0, TRUE, GLOB.always_state)
		if(response != "What?")
			return

		what_presses++
		living_mob.playsound_local(null, pick('sound/effects/page_turn/pageturn3.ogg', 'sound/effects/page_turn/pageturn2.ogg', 'sound/effects/page_turn/pageturn1.ogg'), 100, TRUE, pressure_affected = FALSE, use_reverb = FALSE)

		if(what_presses >= 15)
			living_mob.client?.give_award(/datum/award/achievement/misc/what_loop, living_mob)
			tgui_alert(living_mob, "You asked \"What?\" fifteen times. The divine office has filed your complaint.", "What?", list("Understood"), 0, TRUE, GLOB.always_state)
			return

/datum/brain_trauma_punishment_manager/proc/clear_target_tgui_alert_flag(player_ckey)
	player_ckey = ckey(player_ckey)
	if(!player_ckey || !islist(alerted_ckeys))
		return

	alerted_ckeys -= player_ckey

/datum/brain_trauma_punishment_manager/proc/count_active_traumas_on_mob(list/refs_for_record, mob/living/living_mob)
	var/active_count = 0
	for(var/entry as anything in refs_for_record.Copy())
		if(!isweakref(entry))
			refs_for_record -= entry
			continue

		var/datum/weakref/trauma_ref = entry
		var/datum/brain_trauma/trauma = trauma_ref.resolve()
		if(!istype(trauma) || QDELETED(trauma))
			refs_for_record -= entry
			continue
		if(trauma.owner == living_mob)
			active_count++

	return active_count

/datum/brain_trauma_punishment_manager/proc/grant_trauma_by_record(mob/living/living_mob, mode, trauma_path_text, trauma_category_text, resilience)
	var/mob/living/carbon/carbon_mob = living_mob
	if(!istype(carbon_mob))
		return null

	var/obj/item/organ/brain/brain = carbon_mob.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!brain)
		debug_log("Mob [carbon_mob] ([carbon_mob.ckey]) has no brain organ; trauma grant skipped.", TRUE)
		return null

	if(mode == BRAIN_TRAUMA_PUNISH_MODE_EXACT)
		var/trauma_path = text2path(trauma_path_text)
		if(!ispath(trauma_path, /datum/brain_trauma))
			debug_log("Failed text2path for exact trauma path '[trauma_path_text]'.", TRUE)
			return null
		if(is_forbidden_brain_trauma_type(trauma_path))
			debug_log("Exact trauma path '[trauma_path_text]' is forbidden by punishment blacklist.", TRUE)
			return null

		var/datum/brain_trauma/exact_trauma = carbon_mob.gain_trauma(trauma_path, resilience)
		if(!exact_trauma)
			debug_log("gain_trauma([trauma_path]) returned null for [carbon_mob.ckey].", TRUE)
		return exact_trauma

	if(mode == BRAIN_TRAUMA_PUNISH_MODE_CATEGORY)
		var/category_path = text2path(trauma_category_text)
		if(!ispath(category_path, /datum/brain_trauma))
			debug_log("Failed text2path for trauma category '[trauma_category_text]'.", TRUE)
			return null

		var/list/possible_traumas = get_allowed_category_traumas(category_path, brain, resilience)
		if(!possible_traumas.len)
			debug_log("No eligible trauma candidates left for category '[trauma_category_text]' on [carbon_mob.ckey].", TRUE)
			return null

		var/selected_trauma = pick(possible_traumas)
		var/datum/brain_trauma/category_trauma = carbon_mob.gain_trauma(selected_trauma, resilience)
		if(!category_trauma)
			debug_log("gain_trauma([selected_trauma]) returned null for [carbon_mob.ckey].", TRUE)
		return category_trauma

	debug_log("Unknown punishment mode '[mode]' while granting trauma.", TRUE)
	return null

/datum/brain_trauma_punishment_manager/proc/get_allowed_category_traumas(category_path, obj/item/organ/brain/brain, resilience)
	var/list/possible_traumas = list()
	for(var/trauma_type in subtypesof(category_path))
		if(is_forbidden_brain_trauma_type(trauma_type))
			continue

		var/datum/brain_trauma/trauma_prototype = trauma_type
		if(!initial(trauma_prototype.random_gain))
			continue
		if(!brain.can_gain_trauma(trauma_prototype, resilience, FALSE))
			continue

		possible_traumas += trauma_type

	return possible_traumas

/datum/brain_trauma_punishment_manager/proc/remove_expired_traumas()
	if(!SSdbcore.Connect())
		return

	var/datum/db_query/query_expired = SSdbcore.NewQuery({"
		SELECT id
		FROM [format_table_name("brain_trauma_punishment")]
		WHERE
			removed_datetime IS NULL AND
			expiration_time IS NOT NULL AND
			expiration_time <= NOW()
	"})

	if(!query_expired.warn_execute())
		debug_log("Failed to query expired trauma punishments.", TRUE)
		qdel(query_expired)
		return

	var/list/expired_ids = list()
	while(query_expired.NextRow())
		var/expired_id = text2num(query_expired.item[1])
		if(expired_id)
			expired_ids += expired_id
	qdel(query_expired)

	if(!length(expired_ids))
		return

	debug_log("Found [expired_ids.len] expired punishment rows to clear.")

	for(var/expired_id in expired_ids)
		remove_record_traumas(expired_id)

	clear_alerted_ckeys_without_active_punishments()

	var/list/value_map = list()
	var/list/placeholders = list()
	for(var/i in 1 to expired_ids.len)
		var/key = "id_[i]"
		value_map[key] = expired_ids[i]
		placeholders += ":[key]"

	var/datum/db_query/query_mark_removed = SSdbcore.NewQuery({"
		UPDATE [format_table_name("brain_trauma_punishment")]
		SET removed_datetime = NOW()
		WHERE id IN ([placeholders.Join(", ")])
	"}, value_map)

	if(!query_mark_removed.warn_execute())
		debug_log("Failed to mark expired punishment rows as removed.", TRUE)
	qdel(query_mark_removed)

/datum/brain_trauma_punishment_manager/proc/clear_alerted_ckeys_without_active_punishments()
	if(!islist(alerted_ckeys) || !alerted_ckeys.len)
		return

	for(var/player_ckey in alerted_ckeys.Copy())
		var/datum/db_query/query_has_active = SSdbcore.NewQuery({"
			SELECT 1
			FROM [format_table_name("brain_trauma_punishment")]
			WHERE
				ckey = :ckey AND
				removed_datetime IS NULL AND
				(expiration_time IS NULL OR expiration_time > NOW())
			LIMIT 1
		"}, list("ckey" = player_ckey))

		if(!query_has_active.warn_execute())
			qdel(query_has_active)
			continue

		var/has_active = query_has_active.NextRow()
		qdel(query_has_active)

		if(!has_active)
			alerted_ckeys -= player_ckey

/datum/brain_trauma_punishment_manager/proc/remove_record_traumas(record_id)
	if(!islist(active_traumas_by_record))
		active_traumas_by_record = list()
		debug_log("Trauma cache was invalid during remove_record_traumas, reinitialized.", TRUE)
		return

	var/record_cache_key = get_record_cache_key(record_id)
	if(!record_cache_key)
		debug_log("remove_record_traumas failed to build cache key for record id [record_id].", TRUE)
		return

	var/list/refs_for_record = active_traumas_by_record[record_cache_key]
	if(!islist(refs_for_record))
		active_traumas_by_record -= record_cache_key
		return

	for(var/entry as anything in refs_for_record.Copy())
		if(!isweakref(entry))
			refs_for_record -= entry
			continue

		var/datum/weakref/trauma_ref = entry
		var/datum/brain_trauma/trauma = trauma_ref.resolve()
		if(!istype(trauma))
			refs_for_record -= entry
			continue
		if(QDELETED(trauma))
			refs_for_record -= entry
			continue

		qdel(trauma)
		refs_for_record -= entry

	active_traumas_by_record -= record_cache_key
	debug_log("Removed tracked traumas for punishment record #[record_id].")

/datum/brain_trauma_punishment_manager/proc/cleanup_invalid_refs()
	if(!islist(active_traumas_by_record))
		return

	for(var/record_cache_key in active_traumas_by_record.Copy())
		var/list/refs_for_record = active_traumas_by_record[record_cache_key]
		if(!islist(refs_for_record))
			active_traumas_by_record -= record_cache_key
			continue

		for(var/entry as anything in refs_for_record.Copy())
			if(!isweakref(entry))
				refs_for_record -= entry
				continue

			var/datum/weakref/trauma_ref = entry
			var/datum/brain_trauma/trauma = trauma_ref.resolve()
			if(!istype(trauma) || QDELETED(trauma) || isnull(trauma.owner))
				refs_for_record -= entry

		if(!refs_for_record.len)
			active_traumas_by_record -= record_cache_key

/datum/admins/proc/build_brain_trauma_path_options(selected_path)
	var/selected_text = ispath(selected_path) ? "[selected_path]" : "[selected_path || ""]"
	var/list/possible_traumas = sort_list(subtypesof(/datum/brain_trauma), GLOBAL_PROC_REF(cmp_typepaths_asc))

	if(!possible_traumas.len)
		return "<option value=''>No trauma entries available</option>"

	var/list/options = list()
	for(var/trauma_type in possible_traumas)
		if(is_forbidden_brain_trauma_type(trauma_type))
			continue

		var/trauma_text = "[trauma_type]"
		var/selected = trauma_text == selected_text ? " selected" : ""
		options += "<option value='[html_encode(trauma_text)]'[selected]>[html_encode(trauma_text)]</option>"

	if(!options.len)
		return "<option value=''>No trauma entries available</option>"

	return options.Join("")

/datum/admins/proc/build_brain_trauma_category_options(selected_category)
	var/selected_text = ispath(selected_category) ? "[selected_category]" : "[selected_category || ""]"
	var/list/categories = list(BRAIN_TRAUMA_MILD, BRAIN_TRAUMA_SEVERE, BRAIN_TRAUMA_SPECIAL, BRAIN_TRAUMA_MAGIC)

	var/list/options = list()
	for(var/category in categories)
		var/category_text = "[category]"
		var/selected = category_text == selected_text ? " selected" : ""
		options += "<option value='[html_encode(category_text)]'[selected]>[html_encode(category_text)]</option>"

	return options.Join("")

/datum/admins/proc/brain_trauma_punish_panel(player_key, mode = BRAIN_TRAUMA_PUNISH_MODE_EXACT, trauma_path, trauma_category, duration = 60, interval = "MINUTE", reason = "Administrative punishment", trauma_count = 1, status_message, status_is_error = FALSE)
	if(!check_rights(R_BAN))
		return

	if(!(mode in list(BRAIN_TRAUMA_PUNISH_MODE_EXACT, BRAIN_TRAUMA_PUNISH_MODE_CATEGORY)))
		mode = BRAIN_TRAUMA_PUNISH_MODE_EXACT

	if(!(interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR")))
		interval = "MINUTE"

	var/target_ckey = ckey(player_key)
	var/temporary = isnull(duration) ? FALSE : TRUE
	var/duration_value = temporary ? max(1, text2num(duration || 60)) : 60
	trauma_count = text2num(trauma_count)
	if(trauma_count < 1)
		trauma_count = 1
	if(trauma_count > BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT)
		trauma_count = BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT
	var/trauma_options = build_brain_trauma_path_options(trauma_path)
	var/category_options = build_brain_trauma_category_options(trauma_category)
	var/encoded_reason = html_encode(reason || "")
	var/status_html = ""
	if(status_message)
		var/status_class = status_is_error ? "bt-status-error" : "bt-status-ok"
		status_html = "<div class='[status_class]'>[html_encode(status_message)]</div>"

	var/datum/browser/panel = new(usr, "braintraumapanel", "Brain Trauma Punishment Panel", 1100, 620)
	panel.add_stylesheet("admin_panelscss", 'html/admin/admin_panels.css')
	panel.add_stylesheet("braintraumapanelcss", 'html/admin/brain_trauma_panel.css')
	panel.add_stylesheet("admin_panelscss3", 'html/admin/admin_panels_css3.css')
	panel.add_script("braintraumapaneljs", 'html/admin/brain_trauma_panel.js')

	var/list/output = list("<form method='get' action='?src=[REF(src)]'>[HrefTokenFormField()]")
	output += {"<input type='hidden' name='src' value='[REF(src)]'>
	<input type='hidden' name='braintrauma_create_delimiter' value='1'>
	<div class='bt-toolbar'>
		<a href='byond://?_src_=holder;[HrefToken()];braintrauma_unpanel=1'>Open active punishments list</a>
	</div>
	[status_html]
	<div class='row'>
		<div class='column bt-left'>
			Target ckey<br>
			<input type='text' name='target_ckey' size='24' value='[target_ckey]'><br><br>
			Duration type<br>
			<label class='inputlabel radio'>Permanent
				<input type='radio' id='bt_duration_permanent' name='trauma_radioduration' value='permanent'[temporary ? "" : " checked"]>
				<div class='inputbox'></div>
			</label><br>
			<label class='inputlabel radio'>Temporary
				<input type='radio' id='bt_duration_temporary' name='trauma_radioduration' value='temporary'[temporary ? " checked" : ""]>
				<div class='inputbox'></div>
			</label><br>
			<input type='text' id='bt_duration_value' name='trauma_duration' size='7' value='[duration_value]'>
			<div class='select'>
				<select id='bt_interval' name='trauma_intervaltype'>
					<option value='SECOND'[interval == "SECOND" ? " selected" : ""]>Seconds</option>
					<option value='MINUTE'[interval == "MINUTE" ? " selected" : ""]>Minutes</option>
					<option value='HOUR'[interval == "HOUR" ? " selected" : ""]>Hours</option>
					<option value='DAY'[interval == "DAY" ? " selected" : ""]>Days</option>
					<option value='WEEK'[interval == "WEEK" ? " selected" : ""]>Weeks</option>
					<option value='MONTH'[interval == "MONTH" ? " selected" : ""]>Months</option>
					<option value='YEAR'[interval == "YEAR" ? " selected" : ""]>Years</option>
				</select>
			</div>
		</div>
		<div class='column bt-middle'>
			Trauma mode<br>
			<label class='inputlabel radio'>Specific trauma
				<input type='radio' id='bt_mode_exact' name='trauma_mode' value='[BRAIN_TRAUMA_PUNISH_MODE_EXACT]'[mode == BRAIN_TRAUMA_PUNISH_MODE_EXACT ? " checked" : ""]>
				<div class='inputbox'></div>
			</label><br>
			<label class='inputlabel radio'>Random by category
				<input type='radio' id='bt_mode_category' name='trauma_mode' value='[BRAIN_TRAUMA_PUNISH_MODE_CATEGORY]'[mode == BRAIN_TRAUMA_PUNISH_MODE_CATEGORY ? " checked" : ""]>
				<div class='inputbox'></div>
			</label><br><br>
			<div id='bt_exact_wrap'>
				Specific trauma<br>
				<select id='bt_trauma_path' name='trauma_path' class='bt-select'>
					[trauma_options]
				</select>
			</div>
			<br>
			<div id='bt_category_wrap'>
				Category<br>
				<select id='bt_trauma_category' name='trauma_category' class='bt-select'>
					[category_options]
				</select>
			</div>
			<br>
			Trauma count (category mode)<br>
			<input type='text' id='bt_trauma_count' name='trauma_count' size='7' value='[trauma_count]'>
		</div>
		<div class='column bt-right'>
			Reason<br>
			<textarea class='bt-reason' name='trauma_reason' maxlength='[BRAIN_TRAUMA_PUNISH_MAX_REASON_LENGTH]'>[encoded_reason]</textarea><br>
			<input type='submit' value='Create brain trauma punishment'>
		</div>
	</div>
	</form>"}

	panel.set_content(output.Join(""))
	panel.open()

/datum/admins/proc/brain_trauma_punish_parse_href(list/href_list)
	if(!check_rights(R_BAN))
		return

	var/list/error_state = list()
	var/target_ckey = ckey(href_list["target_ckey"])
	if(!target_ckey)
		error_state += "Target ckey is required."

	var/mode = lowertext(href_list["trauma_mode"])
	if(!(mode in list(BRAIN_TRAUMA_PUNISH_MODE_EXACT, BRAIN_TRAUMA_PUNISH_MODE_CATEGORY)))
		error_state += "Invalid trauma mode selected."

	var/duration
	var/is_permanent = FALSE
	var/interval = href_list["trauma_intervaltype"]
	switch(href_list["trauma_radioduration"])
		if("permanent")
			duration = null
			is_permanent = TRUE
		if("temporary")
			duration = text2num(href_list["trauma_duration"])
			if(duration <= 0)
				error_state += "Temporary duration must be a positive number."
		else
			error_state += "Duration type was not selected."

	if(!(interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR")))
		interval = "MINUTE"

	var/reason = href_list["trauma_reason"]
	if(!reason)
		error_state += "Reason is required."
	if(length(reason) > BRAIN_TRAUMA_PUNISH_MAX_REASON_LENGTH)
		error_state += "Reason cannot be longer than [BRAIN_TRAUMA_PUNISH_MAX_REASON_LENGTH] characters."

	var/trauma_path_text = href_list["trauma_path"]
	var/trauma_category_text = href_list["trauma_category"]
	var/trauma_count = text2num(href_list["trauma_count"])
	if(mode == BRAIN_TRAUMA_PUNISH_MODE_EXACT && !trauma_path_text)
		error_state += "Specific trauma is required for exact mode."
	if(mode == BRAIN_TRAUMA_PUNISH_MODE_CATEGORY && !trauma_category_text)
		error_state += "Trauma category is required for category mode."
	if(mode == BRAIN_TRAUMA_PUNISH_MODE_CATEGORY)
		if(trauma_count < 1)
			error_state += "Trauma count must be at least 1."
		if(trauma_count > BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT)
			error_state += "Trauma count cannot exceed [BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT]."
	else
		trauma_count = 1

	var/display_duration = is_permanent ? null : duration

	if(error_state.len)
		brain_trauma_punish_panel(target_ckey, mode, trauma_path_text, trauma_category_text, display_duration, interval, reason, trauma_count, error_state.Join(" | "), TRUE)
		return

	var/list/create_result = create_brain_trauma_punishment(target_ckey, duration, interval, reason, mode, trauma_path_text, trauma_category_text, trauma_count)
	if(create_result["ok"])
		brain_trauma_punish_panel(target_ckey, mode, trauma_path_text, trauma_category_text, display_duration, interval, reason, trauma_count, "Brain trauma punishment was created for [target_ckey].")
		return

	var/error_message = create_result["error"] || "Failed to create brain trauma punishment."
	brain_trauma_punish_panel(target_ckey, mode, trauma_path_text, trauma_category_text, display_duration, interval, reason, trauma_count, error_message, TRUE)

/datum/admins/proc/create_brain_trauma_punishment(player_key, duration, interval, reason, selected_mode, trauma_path, trauma_category, trauma_count)
	if(!check_rights(R_BAN))
		return list("ok" = FALSE, "error" = "Insufficient permissions.")
	if(!SSdbcore.Connect())
		return list("ok" = FALSE, "error" = "Failed to establish database connection.")

	var/player_ckey = ckey(player_key)
	if(!player_ckey)
		return list("ok" = FALSE, "error" = "Invalid target ckey.")

	var/admin_ckey = usr.client?.ckey
	if(!admin_ckey)
		return list("ok" = FALSE, "error" = "Failed to resolve admin ckey.")

	if(!(interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR")))
		interval = "MINUTE"

	duration = text2num(duration)
	if(duration <= 0)
		duration = null

	if(!reason)
		return list("ok" = FALSE, "error" = "Reason is required.")
	if(length(reason) > BRAIN_TRAUMA_PUNISH_MAX_REASON_LENGTH)
		return list("ok" = FALSE, "error" = "Reason cannot be longer than [BRAIN_TRAUMA_PUNISH_MAX_REASON_LENGTH] characters.")

	selected_mode = lowertext(selected_mode)
	var/trauma_path_type
	var/trauma_category_type
	trauma_count = text2num(trauma_count)

	if(selected_mode == BRAIN_TRAUMA_PUNISH_MODE_EXACT)
		trauma_count = 1
		trauma_path_type = ispath(trauma_path, /datum/brain_trauma) ? trauma_path : text2path("[trauma_path]")
		if(!ispath(trauma_path_type, /datum/brain_trauma))
			return list("ok" = FALSE, "error" = "Invalid trauma selection.")
		if(is_forbidden_brain_trauma_type(trauma_path_type))
			return list("ok" = FALSE, "error" = "Selected trauma is forbidden by punishment blacklist.")
	else if(selected_mode == BRAIN_TRAUMA_PUNISH_MODE_CATEGORY)
		if(trauma_count < 1 || trauma_count > BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT)
			return list("ok" = FALSE, "error" = "Trauma count must be between 1 and [BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT].")
		trauma_category_type = ispath(trauma_category, /datum/brain_trauma) ? trauma_category : text2path("[trauma_category]")
		if(!ispath(trauma_category_type, /datum/brain_trauma))
			return list("ok" = FALSE, "error" = "Invalid trauma category selection.")
	else
		return list("ok" = FALSE, "error" = "Invalid punishment mode.")

	var/datum/db_query/query_create = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("brain_trauma_punishment")] (
			ckey,
			a_ckey,
			reason,
			mode,
			trauma_path,
			trauma_category,
			trauma_count,
			resilience,
			expiration_time,
			round_id,
			server_ip,
			server_port
		)
		VALUES (
			:ckey,
			:a_ckey,
			:reason,
			:mode,
			:trauma_path,
			:trauma_category,
			:trauma_count,
			:resilience,
			IF(:duration IS NULL, NULL, NOW() + INTERVAL :duration [interval]),
			:round_id,
			INET_ATON(:server_ip),
			:server_port
		)
	"}, list(
		"ckey" = player_ckey,
		"a_ckey" = admin_ckey,
		"reason" = reason,
		"mode" = selected_mode,
		"trauma_path" = trauma_path_type ? "[trauma_path_type]" : null,
		"trauma_category" = trauma_category_type ? "[trauma_category_type]" : null,
		"trauma_count" = trauma_count,
		"resilience" = TRAUMA_RESILIENCE_ABSOLUTE,
		"duration" = duration,
		"round_id" = GLOB.round_id,
		"server_ip" = world.internet_address || "0",
		"server_port" = world.port,
	))

	if(!query_create.warn_execute())
		qdel(query_create)
		return list("ok" = FALSE, "error" = "Database query failed while creating punishment.")

	var/new_record_id = query_create.last_insert_id
	qdel(query_create)

	var/interval_text = lowertext("[interval]")
	var/time_message = isnull(duration) ? "permanently" : "for [duration] [interval_text][duration > 1 ? "s" : ""]"
	var/selection_text = selected_mode == BRAIN_TRAUMA_PUNISH_MODE_EXACT ? "[trauma_path_type]" : "category [trauma_category_type] x[trauma_count]"
	var/punishment_note_text
	if(isnull(duration))
		punishment_note_text = "Brain trauma punished permanently. Reason: [reason]"
	else
		var/expiration_text = "[duration] [interval_text][duration > 1 ? "s" : ""]"
		if(new_record_id)
			var/datum/db_query/query_expiration = SSdbcore.NewQuery({"
				SELECT expiration_time
				FROM [format_table_name("brain_trauma_punishment")]
				WHERE id = :id
			"}, list("id" = new_record_id))
			if(query_expiration.warn_execute() && query_expiration.NextRow() && query_expiration.item[1])
				expiration_text = "[query_expiration.item[1]]"
			qdel(query_expiration)

		punishment_note_text = "Brain trauma punished until [expiration_text]. Reason: [reason]"

	log_admin_private("[key_name(usr)] created brain trauma punishment for [player_ckey] [time_message]. Mode: [selected_mode]. Selection: [selection_text]. Reason: [reason]")
	message_admins("[key_name_admin(usr)] created brain trauma punishment for [player_ckey] [time_message]. Mode: [selected_mode]. Selection: [selection_text]. Reason: [reason]")
	create_message("note", player_ckey, admin_ckey, punishment_note_text, null, null, 0, 0, null, 0, "Medium")

	GLOB.brain_trauma_punishment_manager?.apply_to_all_connected()
	if(new_record_id)
		GLOB.brain_trauma_punishment_manager?.cleanup_invalid_refs()

	return list("ok" = TRUE, "record_id" = new_record_id)

/datum/admins/proc/brain_trauma_unpunish_panel(player_key, admin_key, page = 0, status_message, status_is_error = FALSE)
	if(!check_rights(R_BAN))
		return
	if(!SSdbcore.Connect())
		return

	var/target_ckey = ckey(player_key)
	var/filter_admin_ckey = ckey(admin_key)
	var/page_num = max(0, text2num(page))

	var/list/query_filters = list(
		"target_ckey" = target_ckey || null,
		"admin_ckey" = filter_admin_ckey || null,
	)

	var/total_count = 0
	var/datum/db_query/query_count = SSdbcore.NewQuery({"
		SELECT COUNT(id)
		FROM [format_table_name("brain_trauma_punishment")]
		WHERE
			removed_datetime IS NULL AND
			(expiration_time IS NULL OR expiration_time > NOW()) AND
			(:target_ckey IS NULL OR ckey = :target_ckey) AND
			(:admin_ckey IS NULL OR a_ckey = :admin_ckey)
	"}, query_filters)

	if(!query_count.warn_execute())
		qdel(query_count)
		return
	if(query_count.NextRow())
		total_count = text2num(query_count.item[1])
	qdel(query_count)

	var/list/query_values = list(
		"target_ckey" = target_ckey || null,
		"admin_ckey" = filter_admin_ckey || null,
		"skip" = page_num * BRAIN_TRAUMA_UNPANEL_PAGE_SIZE,
		"take" = BRAIN_TRAUMA_UNPANEL_PAGE_SIZE,
	)

	var/datum/db_query/query_list = SSdbcore.NewQuery({"
		SELECT
			id,
			ckey,
			a_ckey,
			reason,
			mode,
			trauma_path,
			trauma_category,
			trauma_count,
			timestamp,
			expiration_time
		FROM [format_table_name("brain_trauma_punishment")]
		WHERE
			removed_datetime IS NULL AND
			(expiration_time IS NULL OR expiration_time > NOW()) AND
			(:target_ckey IS NULL OR ckey = :target_ckey) AND
			(:admin_ckey IS NULL OR a_ckey = :admin_ckey)
		ORDER BY id DESC
		LIMIT :skip, :take
	"}, query_values)

	if(!query_list.warn_execute())
		qdel(query_list)
		return

	var/datum/browser/panel = new(usr, "braintraumaunpanel", "Brain Trauma Punishments List", 1100, 680)
	panel.add_stylesheet("braintraumaunpanelcss", 'html/admin/brain_trauma_unpanel.css')
	var/status_html = ""
	if(status_message)
		var/status_class = status_is_error ? "btu-status-error" : "btu-status-ok"
		status_html = "<div class='[status_class]'>[html_encode(status_message)]</div>"

	var/list/output = list()
	output += "<div class='btu-searchbar'>"
	output += {"<form method='get' action='?src=[REF(src)]'>[HrefTokenFormField()]
		<input type='hidden' name='src' value='[REF(src)]'>
		<input type='hidden' name='braintrauma_unpanel' value='1'>
		Target ckey: <input type='text' name='searchbraintraumakey' size='18' value='[html_encode(target_ckey || "")]'>
		Admin ckey: <input type='text' name='searchbraintraumaadminkey' size='18' value='[html_encode(filter_admin_ckey || "")]'>
		<input type='submit' value='Search'>
		<a class='btu-link' href='byond://?_src_=holder;[HrefToken()];braintrauma_newpanel=[target_ckey || ""]'>Open creation panel</a>
	</form>"}
	output += status_html

	if(total_count > BRAIN_TRAUMA_UNPANEL_PAGE_SIZE)
		output += "<div class='btu-pages'><b>Page:</b> "
		var/total_pages = CEILING(total_count / BRAIN_TRAUMA_UNPANEL_PAGE_SIZE, 1)
		var/list/pages = list()
		for(var/current_page in 0 to max(0, total_pages - 1))
			var/display = current_page + 1
			pages += "<a href='byond://?_src_=holder;[HrefToken()];braintrauma_unpanel=1;braintraumaunpage=[current_page];searchbraintraumakey=[target_ckey || ""];searchbraintraumaadminkey=[filter_admin_ckey || ""]'>[current_page == page_num ? "<b>[display]</b>" : "[display]"]</a>"
		output += pages.Join(" | ")
		output += "</div>"

	output += "</div><div class='btu-main'>"

	var/rows_written = 0
	while(query_list.NextRow())
		rows_written++
		var/record_id = query_list.item[1]
		var/target = query_list.item[2]
		var/admin = query_list.item[3]
		var/reason = html_encode(query_list.item[4])
		var/mode = query_list.item[5]
		var/trauma_text = query_list.item[6] ? "[query_list.item[6]]" : "[query_list.item[7]]"
		var/trauma_count = max(1, text2num(query_list.item[8]))
		var/created_at = query_list.item[9]
		var/expires_at = query_list.item[10] ? "[query_list.item[10]]" : "never"

		output += {"<div class='btu-entry'>
			<div class='btu-entry-header'>#[record_id] | target=[html_encode(target)] | admin=[html_encode(admin)] | mode=[html_encode(mode)]</div>
			<div class='btu-entry-body'>
				<div><b>Trauma:</b> [html_encode(trauma_text)]</div>
				<div><b>Trauma count:</b> [trauma_count]</div>
				<div><b>Created:</b> [created_at]</div>
				<div><b>Expires:</b> [expires_at]</div>
				<div><b>Reason:</b> [reason]</div>
			</div>
			<div class='btu-entry-actions'>
				<a class='btu-remove' href='byond://?_src_=holder;[HrefToken()];braintrauma_removeid=[record_id];braintraumaunkey=[target_ckey || ""];braintraumaunadminkey=[filter_admin_ckey || ""];braintraumaunpage=[page_num]'>Remove punishment</a>
			</div>
		</div>"}

	if(!rows_written)
		output += "<div class='btu-empty'>No active brain trauma punishments found.</div>"

	output += "</div>"
	qdel(query_list)

	panel.set_content(output.Join(""))
	panel.open()


/datum/admins/proc/remove_brain_trauma_punishment_record(record_id)
	if(!check_rights(R_BAN))
		return list("ok" = FALSE, "error" = "Insufficient permissions.")
	if(!SSdbcore.Connect())
		return list("ok" = FALSE, "error" = "Failed to establish database connection.")

	record_id = text2num(record_id)
	if(!record_id)
		return list("ok" = FALSE, "error" = "Invalid punishment id.")

	var/target_ckey
	var/datum/db_query/query_target = SSdbcore.NewQuery({"
		SELECT ckey
		FROM [format_table_name("brain_trauma_punishment")]
		WHERE id = :id AND removed_datetime IS NULL
	"}, list("id" = record_id))

	if(!query_target.warn_execute())
		qdel(query_target)
		return list("ok" = FALSE, "error" = "Failed to resolve punishment target for #[record_id].")

	if(query_target.NextRow())
		target_ckey = ckey(query_target.item[1])
	qdel(query_target)

	if(!target_ckey)
		return list("ok" = FALSE, "error" = "Punishment #[record_id] was not found or is already removed.")

	var/datum/db_query/query_remove = SSdbcore.NewQuery({"
		UPDATE [format_table_name("brain_trauma_punishment")]
		SET removed_datetime = NOW()
		WHERE id = :id AND removed_datetime IS NULL
	"}, list("id" = record_id))

	if(!query_remove.warn_execute())
		qdel(query_remove)
		return list("ok" = FALSE, "error" = "Failed to remove punishment #[record_id].")
	qdel(query_remove)

	GLOB.brain_trauma_punishment_manager?.remove_record_traumas(record_id)
	GLOB.brain_trauma_punishment_manager?.clear_target_tgui_alert_flag(target_ckey)
	log_admin_private("[key_name(usr)] removed brain trauma punishment for [target_ckey].")
	message_admins("[key_name_admin(usr)] removed brain trauma punishment for [target_ckey].")

	return list("ok" = TRUE, "record_id" = record_id, "target_ckey" = target_ckey)

/datum/admins/proc/remove_brain_trauma_punishment(record_id, player_key, admin_key, page = 0)
	var/list/remove_result = remove_brain_trauma_punishment_record(record_id)
	if(!remove_result["ok"])
		brain_trauma_unpunish_panel(player_key, admin_key, page, remove_result["error"] || "Failed to remove punishment.", TRUE)
		return

	var/removed_record_id = remove_result["record_id"] || text2num(record_id)
	brain_trauma_unpunish_panel(player_key, admin_key, page, "Brain trauma punishment #[removed_record_id] removed.")

/datum/brain_trauma_punishment_panel
	var/list/user_state = list()

/datum/brain_trauma_punishment_panel/proc/get_trauma_categories()
	var/list/categories = list(BRAIN_TRAUMA_MILD, BRAIN_TRAUMA_SEVERE, BRAIN_TRAUMA_SPECIAL, BRAIN_TRAUMA_MAGIC)
	var/list/output = list()
	for(var/category in categories)
		output += "[category]"

	return output

/datum/brain_trauma_punishment_panel/proc/get_trauma_paths()
	var/list/output = list()
	var/list/possible_traumas = sort_list(subtypesof(/datum/brain_trauma), GLOBAL_PROC_REF(cmp_typepaths_asc))

	for(var/trauma_type in possible_traumas)
		if(is_forbidden_brain_trauma_type(trauma_type))
			continue
		output += "[trauma_type]"

	return output

/datum/brain_trauma_punishment_panel/proc/build_default_state()
	var/list/trauma_paths = get_trauma_paths()
	var/list/trauma_categories = get_trauma_categories()

	return list(
		"create_target_ckey" = "",
		"create_mode" = BRAIN_TRAUMA_PUNISH_MODE_EXACT,
		"create_trauma_path" = trauma_paths.len ? trauma_paths[1] : "",
		"create_trauma_category" = trauma_categories.len ? trauma_categories[1] : "[BRAIN_TRAUMA_MILD]",
		"create_duration_type" = "temporary",
		"create_duration_value" = 60,
		"create_interval" = "MINUTE",
		"create_reason" = "Administrative punishment",
		"create_trauma_count" = 1,
		"filter_target_ckey" = "",
		"filter_admin_ckey" = "",
		"page" = 0,
		"status_message" = "",
		"status_is_error" = FALSE,
	)

/datum/brain_trauma_punishment_panel/proc/get_user_state(mob/user)
	if(!user?.ckey)
		return null

	var/list/state = user_state[user.ckey]
	if(!islist(state))
		state = build_default_state()
		user_state[user.ckey] = state

	return state

/datum/brain_trauma_punishment_panel/proc/set_status(list/state, message, is_error = FALSE)
	if(!islist(state))
		return

	state["status_message"] = "[message || ""]"
	state["status_is_error"] = !!is_error

/datum/brain_trauma_punishment_panel/proc/query_active_punishments(filter_target_ckey, filter_admin_ckey, requested_page)
	var/list/result = list(
		"rows" = list(),
		"total_count" = 0,
		"page" = 0,
		"page_count" = 1,
	)

	if(!SSdbcore.Connect())
		return result

	var/target_ckey = ckey(filter_target_ckey)
	var/admin_ckey = ckey(filter_admin_ckey)

	var/list/query_filters = list(
		"target_ckey" = target_ckey || null,
		"admin_ckey" = admin_ckey || null,
	)

	var/total_count = 0
	var/datum/db_query/query_count = SSdbcore.NewQuery({"
		SELECT COUNT(id)
		FROM [format_table_name("brain_trauma_punishment")]
		WHERE
			removed_datetime IS NULL AND
			(expiration_time IS NULL OR expiration_time > NOW()) AND
			(:target_ckey IS NULL OR ckey = :target_ckey) AND
			(:admin_ckey IS NULL OR a_ckey = :admin_ckey)
	"}, query_filters)

	if(!query_count.warn_execute())
		qdel(query_count)
		return result

	if(query_count.NextRow())
		total_count = text2num(query_count.item[1])
	qdel(query_count)

	var/page_num = max(0, text2num(requested_page))
	var/page_count = max(1, CEILING(total_count / BRAIN_TRAUMA_UNPANEL_PAGE_SIZE, 1))
	if(page_num >= page_count)
		page_num = max(0, page_count - 1)

	var/list/query_values = list(
		"target_ckey" = target_ckey || null,
		"admin_ckey" = admin_ckey || null,
		"skip" = page_num * BRAIN_TRAUMA_UNPANEL_PAGE_SIZE,
		"take" = BRAIN_TRAUMA_UNPANEL_PAGE_SIZE,
	)

	var/datum/db_query/query_list = SSdbcore.NewQuery({"
		SELECT
			id,
			ckey,
			a_ckey,
			reason,
			mode,
			trauma_path,
			trauma_category,
			trauma_count,
			timestamp,
			expiration_time
		FROM [format_table_name("brain_trauma_punishment")]
		WHERE
			removed_datetime IS NULL AND
			(expiration_time IS NULL OR expiration_time > NOW()) AND
			(:target_ckey IS NULL OR ckey = :target_ckey) AND
			(:admin_ckey IS NULL OR a_ckey = :admin_ckey)
		ORDER BY id DESC
		LIMIT :skip, :take
	"}, query_values)

	if(!query_list.warn_execute())
		qdel(query_list)
		return result

	var/list/rows = list()
	while(query_list.NextRow())
		var/entry_id = text2num(query_list.item[1])
		var/entry_mode = query_list.item[5]
		var/entry_trauma_text = query_list.item[6] ? "[query_list.item[6]]" : "[query_list.item[7]]"
		var/entry_trauma_count = max(1, text2num(query_list.item[8]))

		rows += list(list(
			"id" = entry_id,
			"target_ckey" = "[query_list.item[2]]",
			"admin_ckey" = "[query_list.item[3]]",
			"reason" = "[query_list.item[4]]",
			"mode" = "[entry_mode]",
			"trauma_display" = entry_trauma_text,
			"trauma_count" = entry_trauma_count,
			"created_at" = "[query_list.item[9]]",
			"expires_at" = query_list.item[10] ? "[query_list.item[10]]" : "never",
		))

	qdel(query_list)

	result["rows"] = rows
	result["total_count"] = total_count
	result["page"] = page_num
	result["page_count"] = page_count
	return result

/datum/brain_trauma_punishment_panel/ui_state(mob/user)
	return ADMIN_STATE(R_BAN)

/datum/brain_trauma_punishment_panel/ui_status(mob/user, datum/ui_state/state)
	return check_rights_for(user.client, R_BAN) ? UI_INTERACTIVE : UI_CLOSE

/datum/brain_trauma_punishment_panel/ui_static_data(mob/user)
	if(!check_rights_for(user.client, R_BAN))
		return list()

	return list(
		"intervals" = list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR"),
		"trauma_paths" = get_trauma_paths(),
		"trauma_categories" = get_trauma_categories(),
		"max_reason_length" = BRAIN_TRAUMA_PUNISH_MAX_REASON_LENGTH,
		"max_trauma_count" = BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT,
	)

/datum/brain_trauma_punishment_panel/ui_data(mob/user)
	if(!check_rights_for(user.client, R_BAN))
		return list()

	var/list/state = get_user_state(user)
	if(!islist(state))
		return list()

	var/list/query_data = query_active_punishments(state["filter_target_ckey"], state["filter_admin_ckey"], state["page"])
	state["page"] = query_data["page"]

	var/create_target_ckey = state["create_target_ckey"] || ""
	var/create_mode = state["create_mode"] || BRAIN_TRAUMA_PUNISH_MODE_EXACT
	var/create_trauma_path = state["create_trauma_path"] || ""
	var/create_trauma_category = state["create_trauma_category"] || ""
	var/create_duration_type = state["create_duration_type"] || "temporary"
	var/create_interval = state["create_interval"] || "MINUTE"
	var/create_reason = state["create_reason"] || ""
	var/filter_target_ckey = state["filter_target_ckey"] || ""
	var/filter_admin_ckey = state["filter_admin_ckey"] || ""
	var/status_message = state["status_message"] || ""

	return list(
		"create_target_ckey" = "[create_target_ckey]",
		"create_mode" = "[create_mode]",
		"create_trauma_path" = "[create_trauma_path]",
		"create_trauma_category" = "[create_trauma_category]",
		"create_duration_type" = "[create_duration_type]",
		"create_duration_value" = max(1, text2num(state["create_duration_value"] || 60)),
		"create_interval" = "[create_interval]",
		"create_reason" = "[create_reason]",
		"create_trauma_count" = max(1, text2num(state["create_trauma_count"] || 1)),
		"filter_target_ckey" = "[filter_target_ckey]",
		"filter_admin_ckey" = "[filter_admin_ckey]",
		"status_message" = "[status_message]",
		"status_is_error" = !!state["status_is_error"],
		"entries" = query_data["rows"],
		"total_count" = query_data["total_count"],
		"page" = query_data["page"],
		"page_count" = query_data["page_count"],
	)

/datum/brain_trauma_punishment_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!check_rights_for(ui.user.client, R_BAN))
		return TRUE

	var/list/current_state = get_user_state(ui.user)
	if(!islist(current_state))
		return TRUE

	var/datum/admins/admin_holder = ui.user.client?.holder
	if(!istype(admin_holder))
		set_status(current_state, "Failed to resolve admin holder.", TRUE)
		return TRUE

	switch(action)
		if("set_filters")
			current_state["filter_target_ckey"] = ckey(params["filter_target_ckey"])
			current_state["filter_admin_ckey"] = ckey(params["filter_admin_ckey"])
			set_status(current_state, "")
			current_state["page"] = 0
			return TRUE

		if("set_page")
			set_status(current_state, "")
			current_state["page"] = max(0, text2num(params["page"]))
			return TRUE

		if("remove")
			var/list/remove_result = admin_holder.remove_brain_trauma_punishment_record(params["record_id"])
			if(remove_result["ok"])
				set_status(current_state, "Brain trauma punishment #[remove_result["record_id"]] removed.")
			else
				set_status(current_state, remove_result["error"] || "Failed to remove punishment.", TRUE)
			return TRUE

		if("create")
			var/target_ckey = ckey(params["target_ckey"])
			var/mode = lowertext(params["mode"])
			var/trauma_path = params["trauma_path"]
			var/trauma_category = params["trauma_category"]
			var/duration_type = lowertext(params["duration_type"])
			var/duration_value = max(1, text2num(params["duration_value"]))
			var/interval = params["interval"]
			var/reason = params["reason"]
			var/trauma_count = text2num(params["trauma_count"])

			if(!(mode in list(BRAIN_TRAUMA_PUNISH_MODE_EXACT, BRAIN_TRAUMA_PUNISH_MODE_CATEGORY)))
				mode = BRAIN_TRAUMA_PUNISH_MODE_EXACT

			if(!(interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR")))
				interval = "MINUTE"

			if(!(duration_type in list("temporary", "permanent")))
				duration_type = "temporary"

			if(mode == BRAIN_TRAUMA_PUNISH_MODE_EXACT)
				trauma_count = 1
			else
				trauma_count = clamp(trauma_count, 1, BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT)

			current_state["create_target_ckey"] = target_ckey
			current_state["create_mode"] = mode
			current_state["create_trauma_path"] = trauma_path
			current_state["create_trauma_category"] = trauma_category
			current_state["create_duration_type"] = duration_type
			current_state["create_duration_value"] = duration_value
			current_state["create_interval"] = interval
			current_state["create_reason"] = reason
			current_state["create_trauma_count"] = trauma_count

			if(!target_ckey)
				set_status(current_state, "Target ckey is required.", TRUE)
				return TRUE
			if(!reason)
				set_status(current_state, "Reason is required.", TRUE)
				return TRUE
			if(mode == BRAIN_TRAUMA_PUNISH_MODE_EXACT && !trauma_path)
				set_status(current_state, "Specific trauma is required for exact mode.", TRUE)
				return TRUE
			if(mode == BRAIN_TRAUMA_PUNISH_MODE_CATEGORY && !trauma_category)
				set_status(current_state, "Trauma category is required for category mode.", TRUE)
				return TRUE

			var/duration = null
			if(duration_type == "temporary")
				duration = duration_value

			var/list/create_result = admin_holder.create_brain_trauma_punishment(target_ckey, duration, interval, reason, mode, trauma_path, trauma_category, trauma_count)
			if(create_result["ok"])
				current_state["filter_target_ckey"] = target_ckey
				current_state["page"] = 0
				set_status(current_state, "Brain trauma punishment was created for [target_ckey].")
			else
				set_status(current_state, create_result["error"] || "Failed to create brain trauma punishment.", TRUE)
			return TRUE

		else
			stack_trace("[type]/ui_act received unknown action [action].")
			return TRUE

/datum/brain_trauma_punishment_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!isnull(ui))
		ui.send_full_update()
		return

	ui = new(user, src, "BrainTraumaPunishments")
	ui.set_autoupdate(FALSE)
	ui.open()

/datum/admins/proc/manage_brain_trauma_punishments()
	if(!check_rights(R_BAN))
		return
	if(GLOB.brain_trauma_punishment_panel)
		GLOB.brain_trauma_punishment_panel.ui_interact(usr)
		return

	brain_trauma_punish_panel()

ADMIN_VERB(brain_trauma_punishments, R_BAN, "Brain Trauma Punishments", "Manage brain trauma punishments.", ADMIN_CATEGORY_MAIN)
	user.holder.manage_brain_trauma_punishments()
	BLACKBOX_LOG_ADMIN_VERB("Brain Trauma Punishments")

GLOBAL_DATUM_INIT(brain_trauma_punishment_manager, /datum/brain_trauma_punishment_manager, new)
GLOBAL_DATUM_INIT(brain_trauma_punishment_panel, /datum/brain_trauma_punishment_panel, new)

#undef BRAIN_TRAUMA_PUNISH_MODE_EXACT
#undef BRAIN_TRAUMA_PUNISH_MODE_CATEGORY
#undef BRAIN_TRAUMA_PUNISH_MAX_REASON_LENGTH
#undef BRAIN_TRAUMA_UNPANEL_PAGE_SIZE
#undef BRAIN_TRAUMA_PUNISH_MAX_TRAUMA_COUNT
