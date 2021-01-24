extends Node2D
#const SlotClass = preload("res://scripts/ui/slot.gd")
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
#	print(Data.item_data[item_name].values()[9])
	var strength = Data.item_data[item_name]["strength_bonus"]
	var intelligence = Data.item_data[item_name]["intelligence_bonus"]
	var dexterity = Data.item_data[item_name]["dexterity_bonus"]
	var endurance = Data.item_data[item_name]["endurance_bonus"]
	var health = Data.item_data[item_name]["health_bonus"]
	var attack = Data.item_data[item_name]["attack_bonus"]
	var defense = Data.item_data[item_name]["defense_bonus"]
	var duration = Data.item_data[item_name]["duration"]

	if strength != null:
		consume_item("strength", Player.stats.strength, strength, duration, slot, item)
	if intelligence != null:
		consume_item("intelligence", Player.stats.intelligence, intelligence, duration, slot, item)
	if dexterity != null:
		consume_item("dexterity", Player.stats.dexterity, dexterity, duration, slot, item)
	if endurance != null:
		consume_item("endurance", Player.stats.endurance, endurance, duration, slot, item)
	if attack != null:
		consume_item("attack", Player.stats.attack, attack, duration, slot, item)
	if defense != null:
		consume_item("defense", Player.stats.defense, defense, duration, slot, item)
	if health != null:
		Player.stats.health += health
		if Player.stats.health > Player.max_health:
			Player.stats.health = Player.max_health
		item.queue_free()
		slot.remove_from_slot()
	if attack != null:
		Player.stats.attack += attack
	if defense != null:
		Player.stats.defense += defense
	
	# Be sure that health is not bigger than max_health
	if Player.stats.health > Player.max_health:
			Player.stats.health = Player.max_health
	character_info()


func _on_equipment_removed(item):
	
	# Item Uniqueness properties
	if (item.item_uniqueness.size()) == 3:
		Player.stats[item.item_uniqueness[1].to_lower()] -= item.item_uniqueness[2]
	elif (item.item_uniqueness.size()) == 5:
		Player.stats[item.item_uniqueness[1].to_lower()] -= item.item_uniqueness[2]
		Player.stats[item.item_uniqueness[3].to_lower()] -= item.item_uniqueness[4]
	
	# Item JSON properties
	var strength = Data.item_data[item.item_name]["strength_bonus"]
	var intelligence = Data.item_data[item.item_name]["intelligence_bonus"]
	var dexterity = Data.item_data[item.item_name]["dexterity_bonus"]
	var endurance = Data.item_data[item.item_name]["endurance_bonus"]
	var health = Data.item_data[item.item_name]["health_bonus"]
	var attack = Data.item_data[item.item_name]["attack_bonus"]
	var defense = Data.item_data[item.item_name]["defense_bonus"]
	
	if strength != null:
		Player.stats.strength -= strength
	if intelligence != null:
		Player.stats.intelligence -= intelligence
	if dexterity != null:
		Player.stats.dexterity -= dexterity
	if endurance != null:
		Player.stats.endurance -= endurance
	if health != null:
		Player.stats.health -= health
	if attack != null:
		Player.stats.attack -= attack
	if defense != null:
		Player.stats.defense -= defense
		
	character_info()


func consume_item(skill, value, bonus, duration, slot, item):
	if duration != null:
		var temp_value = value
		value += bonus
		Player.set_stats_value(skill, value)
		item.queue_free()
		slot.remove_from_slot()
		character_info()
		$Label.add_color_override("font_color", Color(0,1,0,1))
		yield(get_tree().create_timer(duration), "timeout")
		Player.set_stats_value(skill, temp_value)
		$Label.add_color_override("font_color", Color(1,1,1,1))
		character_info()
	else:
		Player.set_stats_value(skill, value)
