//////////////////////////////////////////////
//                                          //
//        ROUNDSTART SINFUL DEMON           //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/sinfuldemon
	name = "Demon of Sin"
	config_tag = "Demon of Sin"
	pref_flag = ROLE_SINFULDEMON
	jobban_flag = ROLE_TRAITOR
	preview_antag_datum = /datum/antagonist/sinfuldemon
	min_pop = 10
	weight = 10
	max_antag_cap = list("denominator" = 24)
	blacklisted_roles = list(
		JOB_CHAPLAIN,
	)

/datum/dynamic_ruleset/roundstart/sinfuldemon/assign_role(datum/mind/candidate)
	candidate.add_antag_datum(/datum/antagonist/sinfuldemon)

//////////////////////////////////////////////
//                                          //
//          LATEJOIN SINFUL DEMON           //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/sinfuldemon
	name = "Demon Infiltration"
	config_tag = "Latejoin Demon of Sin"
	preview_antag_datum = /datum/antagonist/sinfuldemon
	pref_flag = ROLE_DEMONINFILTRATION
	jobban_flag = ROLE_TRAITOR
	min_pop = 10
	weight = 5
	blacklisted_roles = list(
		JOB_CHAPLAIN,
	)

/datum/dynamic_ruleset/latejoin/sinfuldemon/assign_role(datum/mind/candidate)
	candidate.add_antag_datum(/datum/antagonist/sinfuldemon)
