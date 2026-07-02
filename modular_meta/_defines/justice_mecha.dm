/// Module is compatible with Justice models
#define EXOSUIT_MODULE_JUSTICE (1<<12)

/// Defines for Justice mech
#define JUSTICE_IDLE "idle"
#define JUSTICE_CHARGE "charge"
#define JUSTICE_INVISIBILITY "invisibility"
#define JUSTICE_INVISIBILITY_ATTACK "invisibility attack"
#define JUSTICE_FATALITY "fatality"

#define JUSTICE_ENGINE_ACTIVE "active"
#define JUSTICE_ENGINE_ACTIVATING "activating"
#define JUSTICE_ENGINE_ONCOOLDOWN "oncooldown"
#define JUSTICE_ENGINE_DEACTIVATING "deactivating"
#define JUSTICE_ENGINE_DEACTIVE "deactive"

#define COMSIG_JUSTICE_ATTACK_AOE "justice_attack_aoe"
#define COMSIG_JUSTICE_CHARGE_BUTTON_DOWN "justice_charge_button_down"

#define COMSIG_JUSTICE_INVISIBILITY_ACTIVATE "justice_invisibility_activate"
	#define COMPONENT_CANCEL_JUSTICE_INVISIBILITY_ACTIVATE (1<<0)
#define COMSIG_JUSTICE_INVISIBILITY_DEACTIVATE "justice_invisibility_deactivate"
	#define COMPONENT_CANCEL_JUSTICE_INVISIBILITY_DEACTIVATE (1<<0)

#define RND_CATEGORY_MECHFAB_JUSTICE "/Justice"

#define HUD_JUSTICE_CHARGE_ARROW "justice_charge_arrow"
