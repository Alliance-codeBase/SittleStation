/datum/map_template/shuttle/arrival/protos
	suffix = "protos"
	name = "arrival shuttle (Protos)"

/datum/map_template/shuttle/cargo/protos
	suffix = "protos"
	name = "supply shuttle (Protos)"

/datum/map_template/shuttle/labour/protos
	suffix = "protos"
	name = "labour shuttle (Protos)"

/datum/map_template/shuttle/mining/protos
	suffix = "protos"
	name = "mining shuttle (Protos)"

/datum/map_template/shuttle/mining_common/protos
	suffix = "protos"
	name = "lavaland shuttle (Protos)"

/obj/docking_port/stationary/laborcamp_home/protos
	roundstart_template = /datum/map_template/shuttle/labour/protos

/obj/docking_port/stationary/mining_home/protos
	roundstart_template = /datum/map_template/shuttle/mining/protos
	height = 4

/obj/docking_port/stationary/mining_home/common/protos
	roundstart_template = /datum/map_template/shuttle/mining_common/protos
