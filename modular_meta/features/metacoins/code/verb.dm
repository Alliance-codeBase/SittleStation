ADMIN_VERB(mc_give, R_ADMIN, "Grant Metacoins", "Grant metacoins to a target ckey.", ADMIN_CATEGORY_GAME)
	var/target_ckey = ckey(input(user, "Target ckey to receive metacoins", "Grant Metacoins", "") as text|null)
	if(!target_ckey)
		return

	var/amount = tgui_input_number(user, "Metacoin amount to grant", "Grant Metacoins", 1, 1000, 1)
	if(isnull(amount))
		return

	amount = round(amount)
	if(amount <= 0)
		to_chat(user, span_warning("Amount must be greater than zero."), confidential = TRUE)
		return

	var/grant_reason = input(user, "Reason shown in logs and player message", "Grant Metacoins", "") as text|null
	if(isnull(grant_reason))
		return

	grant_reason = trim(grant_reason)
	if(!length(grant_reason))
		grant_reason = "Manual admin grant"

	var/datum/metacoins_controller/controller = get_metacoins_controller()
	if(!controller)
		to_chat(user, span_warning("Metacoin controller is unavailable."), confidential = TRUE)
		return

	var/reward_source = "admin_manual_grant:[user.ckey]"
	var/reward_reason = "Admin grant: [grant_reason]"
	var/success = controller.award_metacoins(target_ckey, amount, reward_source, reward_reason, TRUE)

	if(!success)
		var/fail_msg = "[key_name_admin(user)] failed to grant [amount] metacoins to [target_ckey]. Reason='[grant_reason]'."
		message_admins(fail_msg)
		log_admin("[key_name(user)] failed to grant [amount] metacoins to [target_ckey]. Reason='[grant_reason]'.")
		to_chat(user, span_warning("Failed to grant metacoins. Check SQL logs"), confidential = TRUE)
		return

	var/admin_msg = "[key_name_admin(user)] granted [amount] metacoins to [target_ckey]. Reason='[grant_reason]']."
	message_admins(admin_msg)
	log_admin("[key_name(user)] granted [amount] metacoins to [target_ckey]. Reason='[grant_reason]'.")

ADMIN_VERB(mc_take, R_ADMIN, "Take Metacoins", "Take metacoins from a target ckey.", ADMIN_CATEGORY_GAME)
	var/target_ckey = ckey(input(user, "Target ckey to take metacoins from", "Take Metacoins", "") as text|null)
	if(!target_ckey)
		return

	var/amount = tgui_input_number(user, "Metacoin amount to take", "Take Metacoins", 1, 1000, 1)
	if(isnull(amount))
		return

	amount = round(amount)
	if(amount <= 0)
		to_chat(user, span_warning("Amount must be greater than zero."), confidential = TRUE)
		return

	var/take_reason = input(user, "Reason shown in logs and player message", "Take Metacoins", "") as text|null
	if(isnull(take_reason))
		return

	take_reason = trim(take_reason)
	if(!length(take_reason))
		take_reason = "Manual admin take"

	var/datum/metacoin_shop_controller/shop = get_metacoin_controller()
	if(!shop || !SSdbcore.Connect())
		to_chat(user, span_warning("Metacoin shop controller or database is unavailable."), confidential = TRUE)
		return

	if(!shop.take_metacoins(target_ckey, amount)["ok"])
		to_chat(user, span_warning("Failed to take metacoins."), confidential = TRUE)
		return

	var/admin_msg = "[key_name_admin(user)] took [amount] metacoins from [target_ckey]. Reason='[take_reason]'."
	message_admins(admin_msg)
	log_admin("[key_name(user)] took [amount] metacoins from [target_ckey]. Reason='[take_reason]'.")
