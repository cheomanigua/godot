extends Node2D

const DATA_PATH = "res://data/"
const IMAGE_PATH = "res://images/"
const ITEMS_IMAGE_PATH = IMAGE_PATH + "items/"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# warning-ignore:unused_signal
signal item_picked

# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay = load("res://debug_overlay.tscn").instance()
	overlay.add_stats("Inventory", PlayerInventory, "inventory", false)
	overlay.add_stats("Loot", PlayerInventory, "loot_inventory", false)
	add_child(overlay) 
