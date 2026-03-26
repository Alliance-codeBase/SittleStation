/datum/design/self_surgery
	name = "4U70-P3R4710N-2 skillchip"
	desc = "A skillchip containing legal Nanotrasen medical training protocols, which one could use to perform surgical operations on themselves."
	id = "self_surgery_chip"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*2,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*2,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*4,
		/datum/material/plastic = SMALL_MATERIAL_AMOUNT*4,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT*4,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT,
		/datum/material/bananium = SHEET_MATERIAL_AMOUNT, //it costs 20k to do self surgery
	)
	construction_time = 180 SECONDS  // ⏳
	build_path = /obj/item/skillchip/self_surgery/better
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/obj/item/skillchip/self_surgery/better // not contraband
	name = "4U70-P3R4710N-2 skillchip"
	desc = "A skillchip containing legal Nanotrasen medical training protocols, which one could use to perform surgical operations on themselves."
	skill_name = "Self Surgery 2"
	skill_description = "Allows you to perform surgery on yourself. Legal."
	skill_icon = FA_ICON_USER_DOCTOR

/obj/item/skillchip/self_surgery/better/Initialize(mapload, is_removable)
	. = ..()
	REMOVE_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)
