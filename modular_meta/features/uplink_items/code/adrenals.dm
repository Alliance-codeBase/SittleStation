/obj/item/implant/adrenalin
	name = "adrenal implant"
	desc = "Used to remove any stun, incapaciation, paralysis, knockdown and etc."
	icon_state = "adrenal"
	icon = 'modular_meta/features/uplink_items/icons/implant.dmi'
	uses = 3

/obj/item/implant/adrenalin/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Cybersun Industries Adrenaline Implant<BR>
				<b>Life:</b> Five days.<BR>
				<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
				<HR>
				<b>Implant Details:</b> Subjects injected with implant can activate an injection of medical cocktails.<BR>
				<b>Function:</b> Removes stuns, increases speed, and has a mild healing effect.<BR>
				<b>Integrity:</b> Implant can only be used three times before reserves are depleted."}
	return dat

/obj/item/implant/adrenalin/activate()
	. = ..()
	uses--
	to_chat(imp_in, span_notice("As you activate your [name], you feel a sudden surge of energy!"))
	imp_in.adjust_stamina_loss(-200)
	imp_in.reagents.add_reagent(/datum/reagent/medicine/synaptizine, 10)
	imp_in.reagents.add_reagent(/datum/reagent/medicine/omnizine, 10)
	imp_in.reagents.add_reagent(/datum/reagent/medicine/ephedrine, 0.5) //To prevent shaking hands, as well as random item drop caused by ephedrine
	imp_in.reagents.add_reagent(/datum/reagent/medicine/epinephrine, 5)
	imp_in.reagents.add_reagent(/datum/reagent/medicine/atropine, 3)
	if(!uses)
		qdel(src)

/obj/item/implanter/adrenalin
	name = "implanter (adrenalin)"
	imp_type = /obj/item/implant/adrenalin
