// Оутфит для ассистента на карте стройка

/datum/outfit/job/assistant/assistant_stroika
	name = "Assistant (Stroika)"
	neck = /obj/item/clothing/neck/link_scryer/loaded
	suit = /obj/item/clothing/suit/hooded/wintercoat/eva
	suit_store = /obj/item/tank/internals/emergency_oxygen/double
	ears = null
	mask = /obj/item/clothing/mask/gas/atmos
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/storage/box/donkpockets = 1,
		/obj/item/holosign_creator/atmos = 1,
		/obj/item/storage/belt/utility/full/powertools/rcd = 1,
		/obj/item/pickaxe/mini = 1,
		/obj/item/storage/box/circuitboard = 1,
	)
	glasses = /obj/item/clothing/glasses/meson/engine
	gloves = /obj/item/clothing/gloves/color/yellow
	head = /obj/item/clothing/head/utility/hardhat/welding/white/up
	shoes = /obj/item/clothing/shoes/winterboots/ice_boots/eva
	l_hand = /obj/item/storage/part_replacer/bluespace/tier1
	r_hand = /obj/item/storage/medkit/tactical_lite
	l_pocket = /obj/item/stack/sheet/iron/twenty
	r_pocket = /obj/item/climbing_hook
	implants = list(/obj/item/implant/spell)
	skillchips = list(/obj/item/skillchip/job/engineer)

// коробка с платами
/obj/item/storage/box/circuitboard
	name = "box of basic circuitboards"
	desc = "A box full of beautiful fiberglass plates."

/obj/item/storage/box/circuitboard/PopulateContents()
	new /obj/item/circuitboard/machine/circuit_imprinter(src)
	new	/obj/item/circuitboard/machine/protolathe(src)
	new	/obj/item/circuitboard/machine/autolathe(src)
	new /obj/item/electronics/apc(src)
