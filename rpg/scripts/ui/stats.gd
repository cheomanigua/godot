extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	character_info()
	GlobalWorld.connect("equipment_added",self,"_on_equipment_added")
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
		for key in Player.stats:
			if key == item_uniqueness[1]:
				Player.stats[key] += item_uniqueness[2]
	elif (item_uniqueness.size()) == 5:
		var a = item_uniqueness
		var b = item_uniqueness
		Player.stats[a[1].to_lower()] += a[2]
		Player.stats[b[3].to_lower()] += b[4]
	Player.stats.health = Player.stats.strength + Player.stats.endurance
	character_info()


func _on_equipment_removed(item):
	if (item.item_uniqueness.size()) < 3:
		pass
	elif (item.item_uniqueness.size()) == 3:
		for key in Player.stats:
			if key == item.item_uniqueness[1]:
				Player.stats[key] -= item.item_uniqueness[2]
	elif (item.item_uniqueness.size()) == 5:
		var a = item.item_uniqueness
		var b = item.item_uniqueness
		Player.stats[a[1].to_lower()] -= a[2]
		Player.stats[b[3].to_lower()] -= b[4]
	Player.stats.health = Player.stats.strength + Player.stats.endurance
	character_info()
