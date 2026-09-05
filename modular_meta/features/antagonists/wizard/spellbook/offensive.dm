#define SPELLBOOK_CATEGORY_OFFENSIVE "Offensive"

/datum/spellbook_entry/headburster
	name = "Head Burster"
	desc = "Focus a beam of sanguine magic upon a victim, swelling their head until it bursts in a shower of blood and gore. \
	The released energy then leaps between nearby victims "
	spell_type = /datum/action/cooldown/spell/pointed/headburst
	category = SPELLBOOK_CATEGORY_OFFENSIVE

#undef SPELLBOOK_CATEGORY_OFFENSIVE
