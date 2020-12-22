extends Node

var creature_data: Dictionary = {}

func open_creatures_file() -> Dictionary:
	var creature_data_file = File.new()
	creature_data_file.open("res://Data/creatures.json", File.READ)
	var creature_data_json = JSON.parse(creature_data_file.get_as_text())
	creature_data_file.close()
	return creature_data_json.result

func _ready():
	creature_data = open_creatures_file()
	
	# Testing
#	print(creature_data)
#	print (creature_data.keys())
#	var creature = "Goblin"
#	print ("%s stats are:" % [creature])
#	for key in creature_data.get(creature):
#		print ("%s : %s" % [key, creature_data.get(creature)[key]])
#	print("%s strength is %d" % [creature, creature_data.get(creature)["Strength"]])
#	print(creature_data[creature].Texture)

