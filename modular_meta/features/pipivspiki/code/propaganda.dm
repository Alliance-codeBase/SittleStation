/obj/item/poster/random_propaganda
	name = "random propaganda poster"
	poster_type = /obj/structure/sign/poster/official/random
	icon_state = "rolled_legit"

/obj/structure/sign/poster/propaganda
	poster_item_name = "propagantistic poster"
	poster_item_desc = "An official elections 2026 is now. Vote today!"
	poster_item_icon_state = "rolled_legit"
	printable = TRUE

/obj/structure/sign/poster/propaganda/random
	name = "Random Propagandistic Poster (ROP)"
	random_basetype = /obj/structure/sign/poster/propaganda
	icon_state = "random_anything"
	never_random = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/official/random, 32)
//This is being hardcoded here to ensure we don't print directionals from the library management computer because they act wierd as a poster item
/obj/structure/sign/poster/official/random/directional
	printable = FALSE

/obj/structure/sign/poster/propaganda/vibori
	icon = 'modular_meta/features/pipivspiki/icons/poster.dmi'

/obj/structure/sign/poster/propaganda/vibori/pikita_eats
	name = "Пикита Ест Детей"
	desc = "И это факт!"
	icon_state = "pikita_eats"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/propaganda/vibori/pikita_eats, 32)

/obj/structure/sign/poster/propaganda/vibori/i_need_you
	name = "Ты Нужен Мне"
	desc = "Чтобы проголовать за меня!"
	icon_state = "ineedyou"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/propaganda/vibori/i_need_you, 32)

/obj/structure/sign/poster/propaganda/vibori/viva_la_pikita
	name = "Viva la Pikita"
	desc = "За силиконовый стандарт!"
	icon_state = "viva_la_pikita"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/propaganda/vibori/viva_la_pikita, 32)

/obj/structure/sign/poster/propaganda/vibori/melok
	name = "Только Мелок"
	desc = "Обязан Я Быть - ЧЕСТНЫМ. \
	Сын и слуга народа - ЧИСТЫМ. \
	Навечно быть - Благодарным. \
	Перед людьми - Пеколюбимым."
	icon_state = "viva_la_pikita"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/propaganda/vibori/viva_la_pikita, 32)
