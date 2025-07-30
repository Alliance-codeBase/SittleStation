//ORIGINAL FILE: code/datums/components/pet_commands/fetch.dm
/datum/pet_command/point_targeting/fetch
	speech_commands = list("fetch", "принес", "апорт")

//ORIGINAL FILE: code/datums/components/pet_commands/pet_commands_basic.dm
/datum/pet_command/idle
	speech_commands = list("sit", "stay", "stop", "лежать", "место", "сидеть", "стоп", "стой", "стоять", "фу")

/datum/pet_command/free
	speech_commands = list("free", "loose", "брысь", "вон", "гулять", "свобод", "ждать")

/datum/pet_command/follow
	speech_commands = list("heel", "follow", "айда", "идем", "за мной", "к ноге", "ко мне", "охран", "след")

/datum/pet_command/play_dead
	speech_commands = list("play dead", "мертв", "притворись")

/datum/pet_command/point_targeting/attack
	speech_commands = list("attack", "sic", "kill", "атак", "бить", "бей", "еби", "куса", "куси", "сдохни", "умри" ,"фас")

/datum/pet_command/point_targeting/breed
	speech_commands = list("breed", "consummate", "ебитес", "размнож")

/datum/pet_command/point_targeting/use_ability
	speech_commands = list("shoot", "blast", "cast", "каст", "паф", "пиу", "стрел")
