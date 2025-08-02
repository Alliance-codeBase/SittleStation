#define MODPACKS_SET 'modular_meta/__modpack/mods_icon_placeholder.dmi'

/datum/asset/spritesheet_batched/modpacks
	name = "modpacks"

/datum/asset/spritesheet_batched/modpacks/create_spritesheets()
	insert_all_icons("modpack", MODPACKS_SET)
	// catch all modpack's previews which are pulling icons from preview.dmi files
	var/icon_placeholder = "default"
	for(var/datum/modpack/this_modpack as anything in subtypesof(/datum/modpack))
		if(!this_modpack.visible)
			continue

		var/icon = initial(this_modpack.icon)
		var/icon_state = initial(this_modpack.id)
		if(icon == MODPACKS_SET)
			insert_icon("modpack-[icon_state]", uni_icon(icon, icon_placeholder))
		else
			insert_icon("modpack-[icon_state]", uni_icon(icon, icon_state))

#undef MODPACKS_SET
