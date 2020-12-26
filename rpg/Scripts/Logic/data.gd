extends Node

var creature_data: Dictionary = {}
var item_data: Dictionary = {}

func open_creatures_file() -> Dictionary:
	var creature_data_file = File.new()
	creature_data_file.open("res://Data/creatures.json", File.READ)
	var creature_data_json = JSON.parse(creature_data_file.get_as_text())
	creature_data_file.close()
	return creature_data_json.result

func open_items_file() -> Dictionary:
	var item_data_file = File.new()
	item_data_file.open("res://Data/items.json", File.READ)
	var item_data_json = JSON.parse(item_data_file.get_as_text())
	item_data_file.close()
	return item_data_json.result

func _ready():
	creature_data = open_creatures_file()
	item_data = open_items_file()
	
	# Testing
#	print(creature_data)
#	print (creature_data.keys())
#	var creature = "Goblin"
#	print ("%s stats are:" % [creature])
#	for key in creature_data.get(creature):
#		print ("%s : %s" % [key, creature_data.get(creature)[key]])
#	print("%s strength is %d" % [creature, creature_data.get(creature)["Strength"]])
#	print(creature_data[creature].Texture)

	print(item_data[str(0)]["stack_size"])

