// Добавляем ИИ мозг в крафт

/datum/design/ai_brain
	name = "AI-uplink brain"
	desc = "A specially designed brain that allows AI to connect to a fully augmented body."
	id = "ai_cyberbrain"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.7,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*1.35,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/plastic = SMALL_MATERIAL_AMOUNT,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT,
	)
	construction_time = 30 SECONDS
	build_path = /obj/item/organ/brain/cybernetic/ai
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CONTROL_INTERFACES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
