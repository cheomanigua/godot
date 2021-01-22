extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	character_info()
# warning-ignore:return_value_discarded
	GlobalWorld.connect("equipment_added",self,"_on_equipment_added")
# warning-ignore:return_value_discarded
	GlobalWorld.connect("equipment_removed",self,"_on_equipment_removed")


func character_info():
	$Label.text = ""
	for key in Player.stats:
		var cap_key: String = key.capitalize()
		$Label.text += "%s: %d" % [cap_key, Player.stats[key]]
		if (key != Player.stats.keys().back()):
			$Label.text += "\n"


func _on_equipment_added(slot):
	var i = slot.usage_slot_index
	var item_uniqueness = InventoryController.usage_inventory[i][2]
	if (item_uniqueness.size()) < 3:
		pass
	elif (item_uniqueness.size()) == 3:
		Player.stats[item_uniqueness[1].to_lower()] += item_uniqueness[2]
	elif (item_uniqueness.size()) == 5:
		Player.stats[item_uniqueness[1].to_lower()] += item_uniqueness[2]
		Player.stats[item_uniqueness[3].to_lower()] += item_uniqueness[4]
	Player.stats.health = Player.stats.strength + Player.stats.endurance
	character_info()


func _on_equipment_removed(item):
	if (item.item_uniqueness.size()) < 3:
		pass
	elif (item.item_uniqueness.size()) == 3:
		Player.stats[item.item_uniqueness[1].to_lower()] -= item.item_uniqueness[2]
	elif (item.item_uniqueness.size()) == 5:
		Player.stats[item.item_uniqueness[1].to_lower()] -= item.item_uniqueness[2]
		Player.stats[item.item_uniqueness[3].to_lower()] -= item.item_uniqueness[4]
	Player.stats.health = Player.stats.strength + Player.stats.endurance
	character_info()
