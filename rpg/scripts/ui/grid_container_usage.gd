extends Control

#var slots = Array();
#
#func _ready():
#	slots.resize(10);
#	slots.insert(Global.SlotType.SLOT_HEAD, $SlotHead);
#	slots.insert(Global.SlotType.SLOT_MOUTH, $SlotMouth);
#	slots.insert(Global.SlotType.SLOT_TORSO, $SlotTorso);
##	slots.insert(GlobalWorld.SlotType.SLOT_ARMOR, get_node("Left/SlotArmor"));
##	slots.insert(GlobalWorld.SlotType.SLOT_FEET, get_node("Left/SlotFeet"));
##	slots.insert(GlobalWorld.SlotType.SLOT_NECK, get_node("Left/SlotNeck"));
##
##	slots.insert(GlobalWorld.SlotType.SLOT_RING, get_node("Right/SlotRing"));
##	slots.insert(GlobalWorld.SlotType.SLOT_RING2, get_node("Right/SlotRing2"));
##	slots.insert(GlobalWorld.SlotType.SLOT_LHAND, get_node("Right/SlotLHand"));
##	slots.insert(GlobalWorld.SlotType.SLOT_RHAND, get_node("Right/SlotRHand"));
#
#func getSlotByType(type):
#	if type == Global.SlotType.SLOT_RING:
#		return [slots[Global.SlotType.SLOT_RING], slots[Global.SlotType.SLOT_RING2]];
#
#	return slots[type];
#
#func getItemByType(type):
#	return slots[type].item;
