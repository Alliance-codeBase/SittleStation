/// * Message - the message itself
/// * ID - ticket's ID
/// * Ckey - ckey of the person who sent the message
/// * Admin - whether is sender an admin? (true/false)
/// * Engager - was the ticket engaged by an admin, or was it created by an player as ahelp (player/admin)
/// * New_ticket - whether is this a new ticket, or continuation of older one (true/false)
/// *
///

/proc/get_ticket_info(message, ticket_id, ckey, admin, new_ticket, engager) //called at adminhelp ln 762
	var/list/processed_message = list(
		"type" = "admin_ticket",
		"ticket_id" = ticket_id,
		"message" = message,
		"by_whom" = ckey,
		"is_admin" = admin,
		"is_new_ticket" = new_ticket,
		"created_by" = engager,
		"timestamp" = ISOtime(),
		"round_id" = GLOB.round_id
	)

	GLOB.bot_event_sending_que += list(processed_message)
