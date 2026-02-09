// All new mod's includes here
// Some modules can be easy excludes from code compile sequence by commenting #define you need to remove in code\__DEFINES\__meta_modpaks_includes.dm
// Keep in mind, that module may not be only in modular folder but also embedded directly in TG code and covered with #ifdef - #endif structure

#include "__modpack\assets_modpacks.dm" //Assets for modpacks subsystem, used for TGUI and other things
#include "__modpack\modpack.dm" //Modpack base class, used for all modpacks
#include "__modpack\modpacks_subsystem.dm" //Actually modpacks subsystem + TGUI in "tgui/packages/tgui/interfaces/Modpacks.tsx"


/* --- Features --- */

#include "features\additional_circuit\includes.dm"
#include "features\admin\includes.dm"
#include "features\ai_things\includes.dm"
#include "features\antagonists\includes.dm"
#include "features\butt_farts\includes.dm"
#include "features\cheburek_car\includes.dm"
#include "features\more_clothes\includes.dm"
#include "features\hardsuits\includes.dm"
#include "features\kvass_beverage\includes.dm"
#include "features\kumiss_beverage\includes.dm"
#include "features\oguzok_cook\includes.dm"
#include "features\quirk_augmented\includes.dm"
#include "features\meta_maps\includes.dme"
#include "features\soviet_crate\includes.dm"
#include "features\uplink_items\includes.dm"
#include "features\clown_traitor_sound\includes.dm"
#include "features\woodgen\includes.dm"
//#include "features\not_enough_medical\includes.dm" -- upstream 18.01.2026. Surgery overhaul has made this code obsolete
#include "features\more_cell_interactions\includes.dm"
#include "features\makeshift_grenade_trap\includes.dm"
#include "features\makeshift_tools\includes.dm"
#include "features\parts_tier_5\includes.dm"
#include "features\copytech\includes.dm"
#include "features\cargo_extended\includes.dm"
#include "features\not_enough_decor\includes.dm"
#include "features\mod_vend\includes.dm"
#include "features\roundstart_shell\includes.dm"
#include "features\telescience\includes.dm"
#include "features\deathmatch\includes.dm"
#include "features\countdown_antimov_sfx\includes.dm"
#include "features\novichok\includes.dm"
#include "features\jukeboxes_to_bartender\includes.dm"

/* --- Reverts --- */

#include "reverts\beheading\includes.dm"
#include "reverts\buff_lasers\includes.dm"
#include "reverts\bulky_extinguishers\includes.dm"
#include "reverts\colossus\includes.dm"
#include "reverts\glasses_protect\includes.dm"
#include "reverts\hooch\includes.dm"
#include "reverts\nanomed\includes.dm"
#include "reverts\satchels_back\includes.dm"

/* --- Tweaks --- */

#include "tweaks\antagonists_balance\includes.dm"
#include "tweaks\better_ui\includes.dm"
#include "tweaks\del_required_experiments\includes.dm"
#include "tweaks\fonts\includes.dm"
#include "tweaks\resprite\includes.dm"
#include "tweaks\russian_translation\includes.dm"
#include "tweaks\gases\includes.dm"
#include "tweaks\heads_on_belts\includes.dm"
#include "tweaks\lead_pipe\includes.dm"
#include "tweaks\lgbt_removal\includes.dm"
#include "tweaks\tagline\includes.dm"
#include "tweaks\simple_vote_by_default\includes.dm"
