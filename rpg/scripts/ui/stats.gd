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
		if key != "health":
			$Label.text += "%s: %d" % [cap_key, Player.stats[key]]
			if (key != Player.stats.keys().back()):
				$Label.text += "\n"
		else:
			$Label.text += "%s: %d/%d" % [cap_key, Player.stats[key], Player.max_health]
			if (key != Player.stats.keys().back()):
				$Label.text += "\n"


func _on_equipment_added(slot, item):
	var i = slot.usage_slot_index
	
	# Item Uniqueness properties
	var item_uniqueness = InventoryController.usage_inventory[i][2]
	if (item_uniqueness.size()) == 3:
		Player.stats[item_uniqueness[1].to_lower()] += item_uniqueness[2]
	elif (item_uniqueness.size()) == 5:
		Player.stats[item_uniqueness[1].to_lower()] += item_uniqueness[2]
		Player.stats[item_uniqueness[3].to_lower()] += item_uniqueness[4]
	
	# Item JSON properties
	var item_name = InventoryController.usage_inventory[i][0]
# warning-ignore:unassigned_variable
	var vars: Dictionary
	var bonus_index := 9 # this is the value of the JSON file, starting in strength_bonus
	var duration = Data.item_data[item_name]["duration"]
	for key in Player.stats:
		# Dynamically creating variables of Player stats keys and assigning JSON file value
		vars[key] = Data.item_data[item_name].values()[bonus_index]
		if vars[key] != null:
			use_item(key, Player.stats[key], vars[key], duration, slot, item)
		bonus_index += 1
	character_info()


func _on_equipment_removed(item):
	
	# Item Uniqueness properties
	if (item.item_uniqueness.size()) == 3:
		Player.stats[item.item_uniqueness[1].to_lower()] -= item.item_uniqueness[2]
	elif (item.item_uniqueness.size()) == 5:
		Player.stats[item.item_uniqueness[1].to_lower()] -= item.item_uniqueness[2]
		Player.stats[item.item_uniqueness[3].to_lower()] -= item.item_uniqueness[4]
	
	# Item JSON properties
# warning-ignore:unassigned_variable
	var vars: Dictionary
	var bonus_index := 9 # this is the value of the JSON file, starting in strength_bonus
	for key in Player.stats:
		# Dynamically creating variables of Player stats keys and assigning JSON file value
		vars[key] = Data.item_data[item.item_name].values()[bonus_index]
		if vars[key] != null:
			Player.stats[key] -= vars[key]
		bonus_index += 1
	character_info()


# Consume or equip item
func use_item(skill, value, bonus, duration, slot, item):
	if duration != null:
		var temp_value = value
		value += bonus
		Player.set_stats_value(skill, value, duration)
		item.queue_free()
		slot.remove_from_slot()
		character_info()
		yield(get_tree().create_timer(duration), "timeout")
		Player.set_stats_value(skill, temp_value, duration)
		character_info()
	else:
		if skill == 'health':
			Player.stats[skill] += bonus
			if Player.stats[skill] > Player.max_health:
				Player.stats[skill] = Player.max_health
			item.queue_free()
			slot.remove_from_slot()
		else:
			Player.set_stats_value(skill, bonus, duration)
