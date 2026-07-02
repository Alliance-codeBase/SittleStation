/datum/smite/fake_discord
	name = "Fake discord ping"

/datum/smite/fake_discord/effect(client/user, mob/living/target)
	. = ..()
	SEND_SOUND(target, 'modular_meta/features/admin/sound/discord.ogg')
