#define RU_HYGIENEBOT_VOICED_UNHYGIENIC "Обнаружена грязнуля. Пожалуйста остановитесь, чтобы я мог вас отмыть."
#define RU_HYGIENEBOT_VOICED_ENJOY_DAY "Теперь вы чисты и сияете от удовольствия!"
#define RU_HYGIENEBOT_VOICED_THREAT_AIRLOCK "Либо ты перестанешь бежать, либо я тебя блять, достану хоть за шлюзом."
#define RU_HYGIENEBOT_VOICED_FOUL_SMELL "Вернись сюда, вонючий ты ублюдок."
#define RU_HYGIENEBOT_VOICED_TROGLODYTE "Ща тебе троглодит пещерный блядь, надраим задницу."
#define RU_HYGIENEBOT_VOICED_GREEN_CLOUD "Если ты живо сюда не вернешься, то я сдам тебя в химчистку, сучка."
#define RU_HYGIENEBOT_VOICED_ARSEHOLE "Дай уже мне тебя блядина, вычистить!"
#define RU_HYGIENEBOT_VOICED_THREAT_ARTERIES "ПРЕКРАТИТЕ БЕЖАТЬ, ИЛИ Я ПЕРЕРЕЖУ ВАМ ГЛОТКУ!"
#define RU_HYGIENEBOT_VOICED_STOP_RUNNING "Не беги, заебал."
#define RU_HYGIENEBOT_VOICED_FUCKING_FINALLY "Ну наконец-то блять."
#define RU_HYGIENEBOT_VOICED_THANK_GOD "Слава богу, ты наконец остановился."
#define RU_HYGIENEBOT_VOICED_DEGENERATE "Ну, наконец-то этот выродок очищен от смрада."


/mob/living/basic/bot/hygienebot
	var/static/list/ru_found_announcements = list(
		RU_HYGIENEBOT_VOICED_UNHYGIENIC = 'modular_meta/features/april_fools_day/hygienebot/sound/unhygienicclient.ogg',
	)
	///announcements we say when the target keeps moving away
	var/static/list/ru_threat_announcements = list(
		RU_HYGIENEBOT_VOICED_THREAT_AIRLOCK = 'modular_meta/features/april_fools_day/hygienebot/sound/dragyouout.ogg',
		RU_HYGIENEBOT_VOICED_FOUL_SMELL = 'modular_meta/features/april_fools_day/hygienebot/sound/foulsmelling.ogg',
		RU_HYGIENEBOT_VOICED_TROGLODYTE = 'modular_meta/features/april_fools_day/hygienebot/sound/troglodyte.ogg',
		RU_HYGIENEBOT_VOICED_GREEN_CLOUD = 'modular_meta/features/april_fools_day/hygienebot/sound/greencloud.ogg',
		RU_HYGIENEBOT_VOICED_ARSEHOLE = 'modular_meta/features/april_fools_day/hygienebot/sound/letmeclean.ogg',
		RU_HYGIENEBOT_VOICED_THREAT_ARTERIES = 'modular_meta/features/april_fools_day/hygienebot/sound/cutarteries.ogg',
		RU_HYGIENEBOT_VOICED_STOP_RUNNING = 'modular_meta/features/april_fools_day/hygienebot/sound/stoprunning.ogg',
	)
	///announcements we say after we have cleaned our target
	var/static/list/ru_cleaned_announcements = list(
		RU_HYGIENEBOT_VOICED_FUCKING_FINALLY = 'modular_meta/features/april_fools_day/hygienebot/sound/finally.ogg',
		RU_HYGIENEBOT_VOICED_THANK_GOD = 'modular_meta/features/april_fools_day/hygienebot/sound/thankgod.ogg',
		RU_HYGIENEBOT_VOICED_DEGENERATE = 'modular_meta/features/april_fools_day/hygienebot/sound/degenerate.ogg',
	)
