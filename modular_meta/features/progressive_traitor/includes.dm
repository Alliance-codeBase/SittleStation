#include "code\objectives\final_objective\battle_royale.dm"
#include "code\objectives\final_objective\battlecruiser.dm"
#include "code\objectives\final_objective\final_objective.dm"
#include "code\objectives\final_objective\infect_ai.dm"
#include "code\objectives\final_objective\no_escape.dm"
#include "code\objectives\final_objective\objective_dark_matteor.dm"
#include "code\objectives\final_objective\romerol.dm"
#include "code\objectives\final_objective\supermatter_cascade.dm"

#include "code\objectives\abstract\target_player.dm"
#include "code\objectives\assassination.dm"
#include "code\objectives\demoralise_assault.dm"
#include "code\objectives\destroy_heirloom.dm"
#include "code\objectives\destroy_item.dm"
#include "code\objectives\eyesnatching.dm"
#include "code\objectives\hack_comm_console.dm"
#include "code\objectives\infect.dm"
#include "code\objectives\kidnapping.dm"
#include "code\objectives\kill_pet.dm"
#include "code\objectives\locate_weakpoint.dm"
#include "code\objectives\sabotage_machinery.dm"
#include "code\objectives\steal.dm"

#include "code\subsystem\traitor_subsystem.dm"
#include "code\subsystem\objective_helpers.dm"

#include "code\components\uplink.dm"
#include "code\components\traitor_objective_helpers.dm"
#include "code\components\traitor_objective_limit_per_time.dm"
#include "code\components\traitor_objective_mind_tracker.dm"

#include "code\station_goals\meteor_shields.dm"

#include "code\items\virus_disk.dm"
#include "code\items\syndicate_uplink_beacon.dm"
#include "code\items\es8_charge.dm"

#include "code\balance_helper.dm"
#include "code\datum_traitor.dm"
#include "code\uplink_handler.dm"
#include "code\battlecruiser.dm"

#include "code\admin\secrets.dm"
#include "code\admin\antag_panel.dm"



/datum/modpack/progressive_traitor
	id = "progressive_traitor"
	name = "Дополнительные и финальные задачи для Предателя"
	group = "Features"
	desc = "Добавляет дополнительные цели и финальные задачи для предателя"
	author = "Bruh24 - (Modpack) /tg/station - (Code)"

