/obj/item/examine(mob/user)
	. = ..()
	if(GetExactComponent(/datum/component/reskinable_item))
		. += span_notice("This object can be reskinned, you can do so by alt clicking on it")
