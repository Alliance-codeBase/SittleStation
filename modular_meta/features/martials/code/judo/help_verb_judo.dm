/mob/living/proc/judo_verb()
	set name = "Remember The Basics"
	set desc = "You started recalling the techniques you had learned."
	set category = "Judo"

	var/list/message = list()
	message += span_bolditalic("You started recalling the techniques you had learned.")
	message += "[span_notice("throw")]: Grab Shove."

	to_chat(usr, message.Join("\n"))
