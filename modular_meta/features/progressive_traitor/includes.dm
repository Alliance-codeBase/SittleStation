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


/datum/modpack/progressive_traitor
	id = ""
	name = ""
	group = "Features"
	desc = ""
	author = ""

/*
todo:

signals, comps, stuff:




code/datums/components/uplink.dm
code/datums/mind/_mind.dm
code/game/gamemodes/objective_items.dm
code/modules/admin/verbs/secrets.dm
code/modules/admin/antag_panel.dm

comps:

code/modules/antagonists/traitor/components/traitor_objective_helpers.dm
code/modules/antagonists/traitor/components/traitor_objective_limit_per_time.dm
code/modules/antagonists/traitor/components/traitor_objective_mind_tracker.dm

helpers:

code/modules/antagonists/traitor/balance_helper.dm


non-modular edits:

code/modules/antagonists/traitor/datum_traitor.dm
code/modules/antagonists/traitor/uplink_handler.dm
code/modules/modular_computers/computers/item/disks/virus_disk.dm 150-156
code/modules/paperwork/paper_cutter.dm
code/modules/station_goals/meteor_shield.dm

code/game/gamemodes/objective_items.dm
code/datums/mind/_mind.dm
code/datums/components/uplink.dm



code/modules/events/stray_cargo.dm - 1 ln - 169-171

-tfisthat?

code/modules/mapfluff/ruins/spaceruin_code/garbagetruck.dm


- tgui fuckery-wuckery
tgui/packages/tgui/interfaces/Uplink/constants.ts
tgui/packages/tgui/interfaces/Uplink/index.tsx
tgui/packages/tgui/interfaces/Uplink/ObjectiveMenu.tsx
tgui/packages/tgui/interfaces/Uplink/PrimaryObjectiveMenu.tsx
tgui/packages/tgui/interfaces/TraitorObjectiveDebug.tsx


done:
code/__DEFINES/dcs/signals/signals_traitor.dm
code/controllers/subsystem/traitor.dm
code\datums\components\uplink.dm

*/
