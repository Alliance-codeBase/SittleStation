// Achievement reward defines
// Feel free to add more macro's if you feel like it
#define METACOIN_AWARD_NONE 0
#define METACOIN_AWARD_ONE_POINT 1
#define METACOIN_AWARD_CLOSE_TO_NOTHING 5
#define METACOIN_AWARD_SMALL 50
#define METACOIN_AWARD_MED 150
#define METACOIN_AWARD_BIG 250
#define METACOIN_AWARD_HUGE 500 // economics here kinda suck actually

// Achievements
/datum/award
	var/reward = METACOIN_AWARD_SMALL

// METACOIN_AWARD_SMALL

/datum/award/achievement/mafia
	reward = METACOIN_AWARD_SMALL

/datum/award/achievement/mafia/universally_hated
	reward = METACOIN_AWARD_SMALL

// METACOIN_AWARD_MED
/datum/award/achievement/misc/sisyphus
	reward = METACOIN_AWARD_MED

/datum/award/achievement/jobs/theoretical_limits
	reward = METACOIN_AWARD_MED

/datum/award/achievement/jobs/service_good
	reward = METACOIN_AWARD_MED

// METACOIN_AWARD BIG

/datum/award/achievement/misc/grand_ritual_finale
	reward = METACOIN_AWARD_BIG

// METACOIN_AWARD_HUGE

/datum/award/achievement/misc/pulse
	reward = METACOIN_AWARD_HUGE

/datum/award/achievement/jobs/helbitaljanken
	reward = 1500 // you deserve this

/datum/award/achievement/misc/time_waste
	reward = METACOIN_AWARD_HUGE

// Scores

/datum/award/score/
	reward = METACOIN_AWARD_CLOSE_TO_NOTHING

// METACOIN_AWARD_NONE

/datum/award/score/achievements_score
	reward = METACOIN_AWARD_NONE

/datum/award/score/blood_miner_score
	reward = METACOIN_AWARD_NONE

/datum/award/score/intento_score
	reward = METACOIN_AWARD_NONE

/datum/award/score/boss_score
	reward = METACOIN_AWARD_NONE

/datum/award/score/demonic_miner_score
	reward = METACOIN_AWARD_NONE

/datum/award/score/swarmer_beacon_score
	reward = METACOIN_AWARD_NONE

/datum/award/achievement/misc/selfouch
	reward = METACOIN_AWARD_NONE

// CLOSE_TO_NOTHING

// You genuinely don't want to award much for every "robot" served in kitchen. Five points is okay, in my opinion.

/datum/award/score/bartender_tourist_score

/datum/award/score/chef_tourist_score

// ONE_POINT

/datum/award/score/maintenance_pill
	reward = METACOIN_AWARD_ONE_POINT

/datum/award/score/progress/fish
	reward = METACOIN_AWARD_ONE_POINT

/datum/award/score/progress/pda_themes
	reward = METACOIN_AWARD_ONE_POINT

/datum/award/score/tendril_score
	reward = METACOIN_AWARD_ONE_POINT

// METACOIN_AWARD_SMALL

/datum/award/score/wendigo_score
	reward = METACOIN_AWARD_SMALL

/datum/award/score/hardcore_random
	reward = METACOIN_AWARD_SMALL

/datum/award/score/style_score
	reward = METACOIN_AWARD_NONE

/datum/award/score/drake_score
	reward = METACOIN_AWARD_SMALL

/datum/award/score/hierophant_score
	reward = METACOIN_AWARD_SMALL

// METACOIN_AWARD_MED

/datum/award/score/bubblegum_score
	reward = METACOIN_AWARD_MED

/datum/award/score/colussus_score
	reward = METACOIN_AWARD_MED

// METACOIN_AWARD_BIG
/datum/award/score/thething_score
	reward = METACOIN_AWARD_BIG //overall rare boss, why not?

/datum/award/score/legion_score
	reward = METACOIN_AWARD_BIG // this one is hard to kill y'know?
