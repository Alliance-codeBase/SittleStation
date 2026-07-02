/datum/design/board/telepad
	name = "Telepad Board"
	desc = "The circuit board for a telescience telepad."
	id = "telepad"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/telesci_pad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/telesci_console
	name = "Telepad Control Console Board"
	desc = "Allows for the construction of circuit boards used to build a telescience console."
	id = "telesci_console"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/telesci_console
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
