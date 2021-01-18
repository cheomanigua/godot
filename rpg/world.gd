extends Node2D

const DATA_PATH = "res://data/"
const IMAGE_PATH = "res://images/"
const ITEMS_IMAGE_PATH = IMAGE_PATH + "items/"
const ItemObject = preload("res://scenes/item_object.tscn")

# warning-ignore:unused_signal
signal item_picked
# warning-ignore:unused_signal
signal item_dropped
var item_position: Dictionary

func _ready():
	var overlay = load("res://debug_overlay.tscn").instance()
	overlay.add_stats("Inventory", InventoryController, "inventory", false)
	overlay.add_stats("Loot", InventoryController, "loot_inventory", false)
	overlay.add_stats("Usage", InventoryController, "usage_inventory", false)
	overlay.add_stats("Temp", InventoryController, "temp_inventory", false)
	overlay.add_stats("OverLap", Player, "overlapping", true)
	add_child(overlay)
# warning-ignore:return_value_discarded
	connect("item_dropped",self,"_on_item_dropped")
	
func _on_item_dropped(item):
	var item_name = item.item_name
	var item_quantity = item.item_quantity
	var item_object = ItemObject.instance()
	item_object.initialize(item_name, item_quantity)

	# If holding item is not the same type as the overlapping ones,
	# drop it in player's position
	if !item_position.has(item_name):
		item_object.position = Player.position
	# Otherwise drop it in overlapping items map position
	else:
		for o in Player.get_node("PickupZone").get_overlapping_bodies():
			if o.item_name == item_name:
				item_object.position = o.position
			else:
				item_object.position = Global.item_position[item_name]
	add_child(item_object)


# Function used to copy arrays, dictionaries and objects (credit to Zylann on https://godotengine.org/qa)
static func deep_copy(v):
	var t = typeof(v)

	if t == TYPE_DICTIONARY:
		var d = {}
		for k in v:
			d[k] = deep_copy(v[k])
		return d

	elif t == TYPE_ARRAY:
		var d = []
		d.resize(len(v))
		for i in range(len(v)):
			d[i] = deep_copy(v[i])
		return d

	elif t == TYPE_OBJECT:
		if v.has_method("duplicate"):
			return v.duplicate()
		else:
			print("Found an object, but I don't know how to copy it!")
			return v

	else:
		# Other types should be fine,
		# they are value types (except poolarrays maybe)
		return v

# Testing
#func _unhandled_key_input(event):
#	if event.is_action_pressed("ui_down"):
#		var name = "Gem6"
#		var quantity = 10 / 2
#		var item_object = preload("res://scenes/item_object.tscn").instance()
#		item_object.initialize(name, quantity)
#		add_child(item_object)
#		item_object.position = Player.position
