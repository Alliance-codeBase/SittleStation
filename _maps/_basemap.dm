//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.
//#define ABSOLUTE_MINIMUM //uncomment this to load a smaller centcomm and smaller runtime station, only works together with LOWMEMORYMODE

#ifdef ABSOLUTE_MINIMUM
#define LOWMEMORYMODE
#endif

#ifndef ABSOLUTE_MINIMUM
#include "map_files\generic\CentCom.dmm"
#else
#include "map_files\generic\CentCom_minimal.dmm"
#endif

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\debug\multiz.dmm"
		#include "map_files\debug\runtimestation.dmm"
		#include "map_files\Deltastation\DeltaStation2.dmm"
		#include "map_files\IceBoxStation\IceBoxStation.dmm"
		#include "map_files\MetaStation\MetaStation.dmm"
		#include "map_files\Mining\Lavaland.dmm"
		#include "map_files\tramstation\tramstation.dmm"
		#include "map_files\CatwalkStation\CatwalkStation_2023.dmm"
		#include "map_files\NebulaStation\NebulaStation.dmm"
		#include "map_files\wawastation\wawastation.dmm"

		// MASSMETA EDIT BEGIN - Compiling our modular maps too!
		#include "map_files\PubbyStation\PubbyStation.dmm"
		#include "map_files\KiloStation\KiloStation.dmm"
		#include "map_files\ProtoBoxStation\ProtoBoxStation.dmm"
		#include "map_files\protosstation\protos.dmm"
		#include "map_files\bearcat\bearcat.dmm"
		// MASSMETA EDIT END

	#endif
	#ifdef ALL_TEMPLATES
		#include "templates.dm"
	#endif
#endif
