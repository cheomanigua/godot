extends Node2D

const DATA_PATH = "res://data/"
const IMAGE_PATH = "res://images/"
const ITEMS_IMAGE_PATH = IMAGE_PATH + "items/"

const SlotClass = preload("res://scripts/ui/slot.gd")
const ItemClass = preload("res://scripts/ui/item.gd")
# warning-ignore:unused_signal
signal item_picked
signal item_grabbed
var picked_up:= false
#const ItemDrop = preload("res://scripts/logic/item_drop.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay = load("res://debug_overlay.tscn").instance()
	overlay.add_stats("Inventory", PlayerInventory, "inventory", false)
	overlay.add_stats("Loot", PlayerInventory, "loot_inventory", false)
	overlay.add_stats("Usage", PlayerInventory, "usage_inventory", false)
	overlay.add_stats("Temp", PlayerInventory, "temp_inventory", false)
	add_child(overlay)
	

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
func _unhandled_key_input(event):
	if event.is_action_pressed("ui_down"):
		var name = "Gem6"
		var quantity = 10 / 2
		var item_drop = preload("res://scenes/item_drop.tscn").instance()
		item_drop.initialize(name, quantity)
		add_child(item_drop)
		item_drop.position = Player.position
