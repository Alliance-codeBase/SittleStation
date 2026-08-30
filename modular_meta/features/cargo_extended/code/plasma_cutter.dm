/obj/item/gun/energy/plasmacutter/adv/i_cutter
  name = "I.C. Tool"
  description = "Isaac's Cutting Tool, or IC Tool, has 2 modes: slashing and cutting, slashing uses a lot of energy but heavily wounds your foe, while cutting shoots 3 weak lasers that REALLY good at dismembering target, cutting has low range but great mining ability, while slashing is an organ-spilling blast."
  icon_state = "adv_plasmacutter"
  inhand_icon_state = "adv_plasmacutter"
  wound_bonus = 15
  ammo_type = list(/obj/projectile/plasma/adv/slash, /obj/projectile/plasma/adv/cut)

/obj/item/ammo_casing/energy/plasma/adv/slash
  projectile_type = /obj/projectile/plasma/adv/slash
  delay = 20
  e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE)

/obj/item/ammo_casing/energy/plasma/adv/cut
  projectile_type = /obj/projectile/plasma/adv/cut
  delay = 8
  pellets = 3
  variance = 20
  e_cost = LASER_SHOTS(30, STANDARD_CELL_CHARGE)

/obj/effect/projectile/tracer/plasma/adv/slash
  name = "slash"
  icon_state = "u_laser"

/obj/effect/projectile/tracer/plasma/adv/cut
  name = "cut"
  icon_state = "xray"

/obj/projectile/plasma/adv/slash
  damage = 10
  range = 30
  mine_range = 10
  wound_bonus = 60
  speed = 1.6
  tracer_type = /obj/effect/projectile/tracer/plasma/adv/slash
  damage_type = BRUTE
  dismemberment = 40

/obj/projectile/plasma/adv/cut
  damage = 4
  range = 8
  mine_range = 10
  wound_bonus = 6
  speed = 0.8
  tracer_type = /obj/effect/projectile/tracer/plasma/adv/cut
  damage_type = BURN
  dismemberment = 10
