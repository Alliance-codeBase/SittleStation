#define RU_MEDIBOT_VOICED_HOLD_ON "Жди! Я к тебе уже качусь."
#define RU_MEDIBOT_VOICED_WANT_TO_HELP "Стопэ! Я тебе помочь хочу!"
#define RU_MEDIBOT_VOICED_YOU_ARE_INJURED "А тебе здорово досталось, дружок."
#define RU_MEDIBOT_VOICED_ALL_PATCHED_UP "Алл пачит ап!"
#define RU_MEDIBOT_VOICED_APPLE_A_DAY "По яблоку в день или мне вас лечить лень."
#define RU_MEDIBOT_VOICED_FEEL_BETTER "Ну я заебался, покеда."
#define RU_MEDIBOT_VOICED_STAY_WITH_ME	"Мы его теряем!"
#define RU_MEDIBOT_VOICED_LIVE	"Живи, падла! Живи!"
#define RU_MEDIBOT_VOICED_NEVER_LOST "Вот и помер дед максим, только ID остался с ним."
#define RU_MEDIBOT_VOICED_DELICIOUS "Вкуснотища какая!"
#define RU_MEDIBOT_VOICED_PLASTIC_SURGEON "Твой кривой еблет уже ничего не исправит."
#define RU_MEDIBOT_VOICED_MASK_ON "А ну маску надел кожанный ублюдок!"
#define RU_MEDIBOT_VOICED_ALWAYS_A_CATCH "Везде есть подъеб и я главный из них, рофлан ебало."
#define RU_MEDIBOT_VOICED_LIKE_FLIES "Это че за медблок такой? Все мрут как мухии."
#define RU_MEDIBOT_VOICED_SUFFER "Пачиму страдаю я, а не вы?"
#define RU_MEDIBOT_VOICED_FUCK_YOU	"Пшёл нах кожанный ублюдок."
#define RU_MEDIBOT_VOICED_NOT_A_GAME "Давай вырубай свой пэка, ты че, не понял?"
#define RU_MEDIBOT_VOICED_IM_DIFFERENT	"Я в своем познании настолько преисполнился."
#define RU_MEDIBOT_VOICED_FOURTH_WALL "Бъенд вырубай, на давай, вырубай мудила."
#define RU_MEDIBOT_VOICED_SHINDEMASHOU	"Шинимахуня."
#define RU_MEDIBOT_VOICED_WAIT	"Ебать, не понял..."
#define RU_MEDIBOT_VOICED_DONT	"Ну что, опять..."
#define RU_MEDIBOT_VOICED_TRUSTED_YOU "А я тебе верил..."
#define RU_MEDIBOT_VOICED_NO_SAD "Мы его теряем!"
#define RU_MEDIBOT_VOICED_OH_FUCK "Ну пиздц-"
#define RU_MEDIBOT_VOICED_FORGIVE "Ты йобать помилован."
#define RU_MEDIBOT_VOICED_THANKS "Благодарю! Кожанный ублюдок."
#define RU_MEDIBOT_VOICED_GOOD_PERSON "Ниухэ какой покладистый кожанный мешок."
#define RU_MEDIBOT_VOICED_BEHAVIOUR_REPORTED "Ну все, тоби пезда дружок."
#define RU_MEDIBOT_VOICED_ASSISTANCE "Эээ бля, помогите."
#define RU_MEDIBOT_VOICED_PUT_BACK	"Быстро блять вернул меня как было."
#define RU_MEDIBOT_VOICED_IM_SCARED "Испугался? Обосрался!"
#define RU_MEDIBOT_VOICED_NEED_HELP "Дело пахнет жареным, я уже бегу!"
#define RU_MEDIBOT_VOICED_THIS_HURTS "Это больно, ты это понимаешь?!"
#define RU_MEDIBOT_VOICED_THE_END "А это точно конец?"
#define RU_MEDIBOT_VOICED_NOOO	"О нет, о блять, опять!"
#define RU_MEDIBOT_VOICED_CHICKEN "Лук эт ми! Ай эм э-э чиикееен."

/mob/living/basic/bot/medbot
		///anouncements when we find a target to heal
		var/static/list/ru_wait_announcements = list(
			RU_MEDIBOT_VOICED_HOLD_ON = 'modular_meta/features/april_fools_day/medibot/sound/coming.ogg',
			RU_MEDIBOT_VOICED_WANT_TO_HELP = 'modular_meta/features/april_fools_day/medibot/sound/help.ogg',
			RU_MEDIBOT_VOICED_YOU_ARE_INJURED = 'modular_meta/features/april_fools_day/medibot/sound/injured.ogg',
		)

		///announcements after we heal someone
		var/static/list/ru_afterheal_announcements = list(
			RU_MEDIBOT_VOICED_ALL_PATCHED_UP = 'modular_meta/features/april_fools_day/medibot/sound/patchedup.ogg',
			RU_MEDIBOT_VOICED_APPLE_A_DAY = 'modular_meta/features/april_fools_day/medibot/sound/apple.ogg',
			RU_MEDIBOT_VOICED_FEEL_BETTER = 'modular_meta/features/april_fools_day/medibot/sound/feelbetter.ogg',
		)

		///announcements when we are healing someone near death
		var/static/list/ru_near_death_announcements = list(
			RU_MEDIBOT_VOICED_STAY_WITH_ME = 'modular_meta/features/april_fools_day/medibot/sound/no.ogg',
			RU_MEDIBOT_VOICED_LIVE = 'modular_meta/features/april_fools_day/medibot/sound/live.ogg',
			RU_MEDIBOT_VOICED_NEVER_LOST = 'modular_meta/features/april_fools_day/medibot/sound/lost.ogg',
		)
		///announcements when we are idle
		var/static/list/ru_idle_lines = list(
			RU_MEDIBOT_VOICED_DELICIOUS = 'modular_meta/features/april_fools_day/medibot/sound/delicious.ogg',
			RU_MEDIBOT_VOICED_PLASTIC_SURGEON = 'modular_meta/features/april_fools_day/medibot/sound/surgeon.ogg',
			RU_MEDIBOT_VOICED_MASK_ON = 'modular_meta/features/april_fools_day/medibot/sound/radar.ogg',
			RU_MEDIBOT_VOICED_ALWAYS_A_CATCH = 'modular_meta/features/april_fools_day/medibot/sound/catch.ogg',
			RU_MEDIBOT_VOICED_LIKE_FLIES = 'modular_meta/features/april_fools_day/medibot/sound/flies.ogg',
			RU_MEDIBOT_VOICED_SUFFER = 'modular_meta/features/april_fools_day/medibot/sound/why.ogg',
		)
		///announcements when we are emagged
		var/static/list/ru_emagged_announcements = list(
			RU_MEDIBOT_VOICED_FUCK_YOU = 'modular_meta/features/april_fools_day/medibot/sound/fuck_you.ogg',
			RU_MEDIBOT_VOICED_NOT_A_GAME = 'modular_meta/features/april_fools_day/medibot/sound/turn_off.ogg',
			RU_MEDIBOT_VOICED_IM_DIFFERENT = 'modular_meta/features/april_fools_day/medibot/sound/im_different.ogg',
			RU_MEDIBOT_VOICED_FOURTH_WALL = 'modular_meta/features/april_fools_day/medibot/sound/close.ogg',
			RU_MEDIBOT_VOICED_SHINDEMASHOU = 'modular_meta/features/april_fools_day/medibot/sound/shindemashou.ogg',
		)
		///announcements when we are being tipped
		var/static/list/ru_tipped_announcements = list(
			RU_MEDIBOT_VOICED_WAIT = 'modular_meta/features/april_fools_day/medibot/sound/hey_wait.ogg',
			RU_MEDIBOT_VOICED_DONT = 'modular_meta/features/april_fools_day/medibot/sound/please_dont.ogg',
			RU_MEDIBOT_VOICED_TRUSTED_YOU = 'modular_meta/features/april_fools_day/medibot/sound/i_trusted_you.ogg',
			RU_MEDIBOT_VOICED_NO_SAD = 'modular_meta/features/april_fools_day/medibot/sound/no.ogg',
			RU_MEDIBOT_VOICED_OH_FUCK = 'modular_meta/features/april_fools_day/medibot/sound/oh_fuck.ogg',
		)
		///announcements when we are being untipped
		var/static/list/ru_untipped_announcements = list(
			RU_MEDIBOT_VOICED_FORGIVE = 'modular_meta/features/april_fools_day/medibot/sound/forgive.ogg',
			RU_MEDIBOT_VOICED_THANKS = 'modular_meta/features/april_fools_day/medibot/sound/thank_you.ogg',
			RU_MEDIBOT_VOICED_GOOD_PERSON = 'modular_meta/features/april_fools_day/medibot/sound/youre_good.ogg',
		)
		///announcements when we are worried
		var/static/list/ru_worried_announcements = list(
			RU_MEDIBOT_VOICED_PUT_BACK = 'modular_meta/features/april_fools_day/medibot/sound/please_put_me_back.ogg',
			RU_MEDIBOT_VOICED_IM_SCARED = 'modular_meta/features/april_fools_day/medibot/sound/please_im_scared.ogg',
			RU_MEDIBOT_VOICED_NEED_HELP = 'modular_meta/features/april_fools_day/medibot/sound/dont_like.ogg',
			RU_MEDIBOT_VOICED_THIS_HURTS = 'modular_meta/features/april_fools_day/medibot/sound/pain_is_real.ogg',
			RU_MEDIBOT_VOICED_THE_END = 'modular_meta/features/april_fools_day/medibot/sound/is_this_the_end.ogg',
			RU_MEDIBOT_VOICED_NOOO = 'modular_meta/features/april_fools_day/medibot/sound/nooo.ogg',
		)
		var/static/list/ru_misc_announcements= list(
			RU_MEDIBOT_VOICED_CHICKEN = 'modular_meta/features/april_fools_day/medibot/sound/i_am_chicken.ogg',
		)
