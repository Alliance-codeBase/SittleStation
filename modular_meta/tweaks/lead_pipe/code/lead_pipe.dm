/obj/item/lead_pipe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is crushed under the weight of a thousand pipes!"))
	for(var/i in 1 to 8)
		playsound(user, 'sound/items/handling/lead_pipe/lead_pipe_drop.ogg', (20 + i * 10), FALSE)
		user.AddElement(/datum/element/squish, 1.5 SECONDS)
		sleep(1.5/8 SECONDS)
	user.gib(DROP_ALL_REMAINS)
	return MANUAL_SUICIDE
