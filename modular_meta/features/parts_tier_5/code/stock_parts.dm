/obj/item/storage/part_replacer/bluespace/tier5/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor/noneuclid(src)
		new /obj/item/stock_parts/scanning_module/noneuclid(src)
		new /obj/item/stock_parts/servo/noneuclid(src)
		new /obj/item/stock_parts/micro_laser/noneuclid(src)
		new /obj/item/stock_parts/matter_bin/noneuclid(src)
		new /obj/item/stock_parts/power_store/cell/infinite/abductor(src)

/obj/item/stock_parts/capacitor/noneuclid
	name = "noneuclid capacitor"
	desc = "A capacity capacitor used in the construction of a variety of devices."
	icon = 'modular_meta/features/parts_tier_5/icons/stock_parts.dmi'
	icon_state = "noneuclid_capacitor"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2, /datum/material/gold = SMALL_MATERIAL_AMOUNT, /datum/material/diamond = SMALL_MATERIAL_AMOUNT)

/obj/item/stock_parts/scanning_module/noneuclid
	name = "noneuclid scanning module"
	desc = "A compact, ultra resolution triphasic scanning module used in the construction of certain devices."
	icon = 'modular_meta/features/parts_tier_5/icons/stock_parts.dmi'
	icon_state = "noneuclid_scan_module"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2, /datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/diamond = SMALL_MATERIAL_AMOUNT * 0.3)

/obj/item/stock_parts/servo/noneuclid
	name = "noneuclid-servo"
	desc = "A tiny little servo motor used in the construction of certain devices."
	icon = 'modular_meta/features/parts_tier_5/icons/stock_parts.dmi'
	icon_state = "noneuclid_servo"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2, /datum/material/diamond = SMALL_MATERIAL_AMOUNT * 0.3, /datum/material/titanium = SMALL_MATERIAL_AMOUNT * 0.3)

/obj/item/stock_parts/micro_laser/noneuclid
	name = "noneuclid micro-laser"
	desc = "A tiny laser used in certain devices."
	icon = 'modular_meta/features/parts_tier_5/icons/stock_parts.dmi'
	icon_state = "noneuclid_micro_laser"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2, /datum/material/uranium = SMALL_MATERIAL_AMOUNT, /datum/material/diamond = SMALL_MATERIAL_AMOUNT * 0.6)

/obj/item/stock_parts/matter_bin/noneuclid
	name = "noneuclid matter bin"
	desc = "A container designed to hold compressed matter awaiting reconstruction."
	icon = 'modular_meta/features/parts_tier_5/icons/stock_parts.dmi'
	icon_state = "noneuclid_matter_bin"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2.5, /datum/material/diamond = SMALL_MATERIAL_AMOUNT, /datum/material/bluespace = SMALL_MATERIAL_AMOUNT)

/obj/item/stock_parts/power_store/cell/infinite/abductor
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 30, /datum/material/diamond = SHEET_MATERIAL_AMOUNT * 16, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 12, /datum/material/gold = SHEET_MATERIAL_AMOUNT * 12, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 6, /datum/material/bluespace = SHEET_MATERIAL_AMOUNT * 5)
