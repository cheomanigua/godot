extends Node

var creature_data: Dictionary
var item_data: Dictionary

func open_creatures_file() -> Dictionary:
	var creature_data_file = File.new()
	creature_data_file.open(GlobalWorld.DATA_PATH + "creatures.json", File.READ)
	var creature_data_json = JSON.parse(creature_data_file.get_as_text())
	creature_data_file.close()
	return creature_data_json.result

func open_items_file() -> Dictionary:
	var item_data_file = File.new()
	item_data_file.open(GlobalWorld.DATA_PATH + "items3.json", File.READ)
	var item_data_json = JSON.parse(item_data_file.get_as_text())
	item_data_file.close()
	return item_data_json.result

func _ready():
	creature_data = open_creatures_file()
	item_data = open_items_file()
