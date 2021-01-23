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
	
	# Item Uniqueness properties
	var item_uniqueness = InventoryController.usage_inventory[i][2]
	if (item_uniqueness.size()) == 3:
		Player.stats[item_uniqueness[1].to_lower()] += item_uniqueness[2]
	elif (item_uniqueness.size()) == 5:
		Player.stats[item_uniqueness[1].to_lower()] += item_uniqueness[2]
		Player.stats[item_uniqueness[3].to_lower()] += item_uniqueness[4]
	Player.stats.health = Player.stats.strength + Player.stats.endurance
	
	# Item JSON properties
	var item_name = InventoryController.usage_inventory[i][0]
	var attack = Data.item_data[item_name]["attack_bonus"]
	var defense = Data.item_data[item_name]["defense_bonus"]
	var strength = Data.item_data[item_name]["strength_bonus"]
	var intelligence = Data.item_data[item_name]["intelligence_bonus"]
	var dexterity = Data.item_data[item_name]["dexterity_bonus"]
	var endurance = Data.item_data[item_name]["endurance_bonus"]

	if strength != null:
		Player.stats.strength += strength
	elif intelligence != null:
		Player.stats.intelligence += intelligence
	elif dexterity != null:
		Player.stats.dexterity += dexterity
	elif endurance != null:
		Player.stats.endurance += endurance
	elif attack != null:
		Player.stats.attack += attack
	elif defense != null:
		Player.stats.defense += defense
	
	character_info()


func _on_equipment_removed(item):
	
	# Item Uniqueness properties
	if (item.item_uniqueness.size()) == 3:
		Player.stats[item.item_uniqueness[1].to_lower()] -= item.item_uniqueness[2]
	elif (item.item_uniqueness.size()) == 5:
		Player.stats[item.item_uniqueness[1].to_lower()] -= item.item_uniqueness[2]
		Player.stats[item.item_uniqueness[3].to_lower()] -= item.item_uniqueness[4]
	Player.stats.health = Player.stats.strength + Player.stats.endurance
	
	# Item JSON properties
	var attack = Data.item_data[item.item_name]["attack_bonus"]
	var defense = Data.item_data[item.item_name]["defense_bonus"]
	var strength = Data.item_data[item.item_name]["strength_bonus"]
	var intelligence = Data.item_data[item.item_name]["intelligence_bonus"]
	var dexterity = Data.item_data[item.item_name]["dexterity_bonus"]
	var endurance = Data.item_data[item.item_name]["endurance_bonus"]
	
	if strength != null:
		Player.stats.strength -= strength
	elif intelligence != null:
		Player.stats.intelligence -= intelligence
	elif dexterity != null:
		Player.stats.dexterity -= dexterity
	elif endurance != null:
		Player.stats.endurance -= endurance
	elif attack != null:
		Player.stats.attack -= attack
	elif defense != null:
		Player.stats.defense -= defense
		
	character_info()
