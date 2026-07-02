/obj/structure/closet/decay/take_contents()
    for(var/obj/item/item in loc)
        if(istype(item, /obj/item/gun/magic/staff/locker))
            continue
        insert(item)
