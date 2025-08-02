//////////////////////////////////////////////
//                                          //
//        ROUNDSTART BLOODSUCKER            //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/bloodsucker
	name = "Bloodsuckers"
	config_tag = "Bloodsucker"
	pref_flag = ROLE_BLOODSUCKER
	jobban_flag = ROLE_TRAITOR
	preview_antag_datum = /datum/antagonist/bloodsucker
	min_pop = 5
	weight = 10
	max_antag_cap = list("denominator" = 24)
	blacklisted_roles = list(
		JOB_CURATOR,
	)

/datum/dynamic_ruleset/roundstart/bloodsucker/assign_role(datum/mind/candidate)
	candidate.add_antag_datum(/datum/antagonist/sinfuldemon)

//////////////////////////////////////////////
//                                          //
//          MIDROUND BLOODSUCKER            //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/bloodsucker
	name = "Vampiric Accident"
	config_tag = "Midround Bloodsucker"
	preview_antag_datum = /datum/antagonist/bloodsucker
	pref_flag = ROLE_VAMPIRICACCIDENT
	min_pop = 5
	weight = 15
	max_antag_cap = list("denominator" = 24)
	blacklisted_roles = list(
		JOB_CURATOR,
	)

/datum/dynamic_ruleset/midround/bloodsucker/assign_role(datum/mind/candidate)
	candidate.add_antag_datum(/datum/antagonist/sinfuldemon)

//////////////////////////////////////////////
//                                          //
//          LATEJOIN BLOODSUCKER            //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/bloodsucker
	name = "Bloodsucker Breakout"
	config_tag = "Latejoin Bloodsucker"
	preview_antag_datum = /datum/antagonist/bloodsucker
	pref_flag = ROLE_BLOODSUCKERBREAKOUT
	min_pop = 5
	weight = 15
	blacklisted_roles = list(
		JOB_CURATOR,
	)

/datum/dynamic_ruleset/latejoin/bloodsucker/assign_role(datum/mind/candidate)
	candidate.add_antag_datum(/datum/antagonist/sinfuldemon)
