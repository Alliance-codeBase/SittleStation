#define MODPACKS_SET 'modular_meta/__modpack/mods_icon_placeholder.dmi'

/datum/asset/spritesheet_batched/modpacks
	name = "modpacks"

/datum/asset/spritesheet_batched/modpacks/create_spritesheets()
	// catch all modpack's previews which are pulling icons from preview.dmi files
	// not from .png due of special work insert_icon() with uni_icon()
	for(var/datum/modpack/this_modpack as anything in subtypesof(/datum/modpack))
		if(!this_modpack.visible)
			continue

		var/icon = initial(this_modpack.icon)
		var/modpack_id = initial(this_modpack.id)

		if(icon == MODPACKS_SET)
			insert_icon("modpack-[modpack_id]", uni_icon(icon, "no-preview"))
		else
			insert_icon("modpack-[modpack_id]", uni_icon(icon, "preview"))

#undef MODPACKS_SET
