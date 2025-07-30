/obj/item/switchblade/backstab
	var/nt = FALSE

/obj/item/switchblade/backstab/nt
	nt = TRUE

/obj/item/switchblade/backstab/examine(mob/user)
	. = ..()
	. += span_danger("\The [src] has a [nt ? "Nanotrasen" : "Syndicate"] marking on the blade.")

/obj/item/switchblade/backstab/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/backstabs, 1.75) // 35 damage


/datum/component/backstabs
	var/backstab_multiplier

/datum/component/backstabs/Initialize(backstab_multiplier = 4) // 4x damage by default
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, .proc/on_attack)

/datum/component/backstabs/proc/on_attack(obj/item/source, mob/living/target, mob/living/user)
	// No bypassing pacifism nerd
	if(source.force > 0 && HAS_TRAIT(user, TRAIT_PACIFISM) && (source.damtype != STAMINA))
		return
	// Same calculation that kinetic crusher uses
	var/backstab_dir = get_dir(user, target)
	// No backstabbing people if they're already in crit
	if(!target.stat && (user.dir & backstab_dir) && (target.dir & backstab_dir))
		var/multi = backstab_multiplier - 1
		var/dmg = source.force * multi
		if(dmg) // Truthy because backstabs can heal lol
			target.apply_damage(dmg, source.damtype, BODY_ZONE_CHEST, 0, source.wound_bonus*multi, source.exposed_wound_bonus*multi, source.sharpness*multi)
			log_combat(user, target, "scored a backstab", source.name, "(DAMTYPE: [uppertext(source.damtype)])")
			if(iscarbon(target))
				target.emote("scream") // SPY AROUND HERE
