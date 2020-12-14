extends Node

var creature_data

func open_creatures():
	var creaturedata_file = File.new()
	creaturedata_file.open("res://Data/Creatures2.json", File.READ)
	var creaturedata_json = JSON.parse(creaturedata_file.get_as_text())
	creaturedata_file.close()
	creature_data = creaturedata_json.result

func _ready():
	open_creatures()
	
	# Testing
#	print (creature_data.keys())
#	var creature = "Goblin"
#	print ("%s stats are:" % [creature])
#	for key in creature_data.get(creature):
#		print ("%s : %s" % [key, creature_data.get(creature)[key]])
#	print("%s strength is %d" % [creature, creature_data.get(creature)["Strength"]])
#	print(creature_data[creature].Texture)
	
