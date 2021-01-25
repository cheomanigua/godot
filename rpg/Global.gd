extends Node
class_name Global

enum SlotType {
	SLOT_DEFAULT = 0,
	SLOT_HEAD,
	SLOT_MOUTH,
	SLOT_TORSO,
	SLOT_RHAND,
	SLOT_LHAND,
	SLOT_FEET,
	## Move the below slots up the list if you implement them. The order of the slot
	## is important and must match the order of GridContainerUsage children
	SLOT_NECK,
	SLOT_RING,
	SLOT_RING2
}
