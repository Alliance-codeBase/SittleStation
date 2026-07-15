/atom/movable/screen/plane_master/rendering_plate/game_world/show_to(mob/mymob)
	. = ..()
	if(!.)
		return
	remove_filter("AO")
	if(istype(mymob) && mymob.canon_client?.prefs?.read_preference(/datum/preference/toggle/ambient_occlusion))
		add_filter("AO", 1, drop_shadow_filter(x = 0, y = -0.75, size = 1.5, color = "#1108048a"))

/atom/movable/screen/plane_master/runechat/show_to(mob/mymob)
	. = ..()
	if(!.)
		return
	remove_filter("AO")
	if(istype(mymob) && mymob.canon_client?.prefs?.read_preference(/datum/preference/toggle/ambient_occlusion))
		add_filter("AO", 1, outline_filter(size = 1.5, color = "#11080420", flags = OUTLINE_SQUARE))

/atom/movable/screen/plane_master/balloon_chat/show_to(mob/mymob)
	. = ..()
	if(!.)
		return
	remove_filter("AO")
	if(istype(mymob) && mymob.canon_client?.prefs?.read_preference(/datum/preference/toggle/ambient_occlusion))
		add_filter("AO", 1, outline_filter(size = 0.25, color = "#11080420", flags = OUTLINE_SQUARE))

#undef AMBIENT_OCCLUSION

#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-0.75, size=1.5, color="#110804AA")
