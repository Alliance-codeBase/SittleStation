/obj/machinery/vending/wallmed
	name = "\improper NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	products = list(
		/obj/item/reagent_containers/syringe = 3,
		/obj/item/reagent_containers/applicator/pill/multiver = 2,
		/obj/item/reagent_containers/medigel/libital = 2,
		/obj/item/reagent_containers/medigel/aiuri = 2,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/healthanalyzer/simple = 2,
		/obj/item/stack/medical/bone_gel = 2,
		/obj/item/storage/box/bandages = 1,
		)
	contraband = list(
		/obj/item/reagent_containers/applicator/pill/tox = 2,
		/obj/item/reagent_containers/applicator/pill/morphine = 2,
		/obj/item/storage/box/gum/happiness = 1,
	)
	premium = list(
		/obj/item/reagent_containers/applicator/patch/libital = 5, // Обратно на 5, с апстримом количество патчей уменьшили до еденицы.
		/obj/item/reagent_containers/applicator/patch/aiuri = 5,
	)
