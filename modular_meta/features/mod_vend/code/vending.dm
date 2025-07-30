/obj/machinery/vending/mod_modules
	name = "\improper NanoMOD"
	desc = "A MOD modules equipment vendor."
	icon = 'modular_meta/features/mod_vend/icons/mod-vend.dmi'
	product_ads = "Используй свой МОД на полную!;Стань лучше всех!;Не сомневайся - действуй!;МОД без модулей - ничто!;Покажи всем всю силу МОД костюмов!;РИГи это прошлый век, МОДы это текущий век!"
	icon_state = "mod"
	icon_deny = "mod-deny"
	panel_type = "mod-panel"
	light_mask = "mod-light-mask"
	products = list(
		/obj/item/mod/module/flashlight = 10,
		/obj/item/mod/module/gps = 10,
		/obj/item/mod/module/headprotector = 5,
		/obj/item/mod/module/health_analyzer = 5,
		/obj/item/mod/module/jetpack = 5,
		/obj/item/mod/module/longfall = 3,
		/obj/item/mod/module/magboot = 4,
		/obj/item/mod/module/mouthhole = 7,
		/obj/item/mod/module/reagent_scanner = 5,
		/obj/item/mod/module/storage = 5,
		/obj/item/mod/module/visor/meson = 2,
	)
	contraband = list(
		/obj/item/mod/module/energy_shield = 1,
		/obj/item/mod/module/atrocinator = 2,
		/obj/item/mod/module/springlock = 1,
	)
	premium = list(
		/obj/item/mod/module/emp_shield = 2,
		/obj/item/mod/module/jetpack/advanced = 5,
		/obj/item/mod/module/pathfinder = 3,
		/obj/item/mod/module/rad_protection = 3,
		/obj/item/mod/module/megaphone = 3,
		/obj/item/mod/module/hat_stabilizer = 3,
		/obj/item/mod/module/fishing_glove = 2,
		/obj/item/mod/module/anomaly_locked/kinesis/prebuilt/locked = 4,
		/obj/item/mod/module/jump_jet = 5,
	)
	refill_canister = /obj/item/vending_refill/mod_modules
	default_price = PAYCHECK_COMMAND
	extra_price = PAYCHECK_COMMAND * 1.5
	payment_department = ACCOUNT_SCI
	light_color = COLOR_BLUE_GRAY

/obj/item/vending_refill/mod_modules
	machine_name = "NanoMOD"
	icon_state = "refill_sec"
