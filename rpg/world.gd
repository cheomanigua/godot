extends Node2D

const DATA_PATH = "res://data/"
const IMAGE_PATH = "res://images/"
const ITEMS_IMAGE_PATH = IMAGE_PATH + "items/"
const ItemObject = preload("res://scenes/item_object.tscn")

# warning-ignore:unused_signal
signal item_picked
# warning-ignore:unused_signal
signal item_dropped
# warning-ignore:unused_signal
signal show_item_info
# warning-ignore:unused_signal
signal hide_item_info
# warning-ignore:unused_signal
signal equipment_added
# warning-ignore:unused_signal
signal equipment_removed

# Item position updated on player.gd on show_loot() method
var item_position: Dictionary



func _ready():
	var overlay = load("res://debug_overlay.tscn").instance()
	overlay.add_stats("Inventory", InventoryController, "inventory", false)
	overlay.add_stats("Loot", InventoryController, "loot_inventory", false)
	overlay.add_stats("Usage", InventoryController, "usage_inventory", false)
	overlay.add_stats("Stats", Player, "stats", false)
	overlay.add_stats("OverLap", Player, "overlapping", true)
	add_child(overlay)
# warning-ignore:return_value_discarded
	connect("item_dropped",self,"_on_item_dropped")
	
func _on_item_dropped(item):
	var item_name = item.item_name
	var item_quantity = item.item_quantity
	var item_object = ItemObject.instance()
	item_object.initialize(item_name, item_quantity)

	if Player.get_node("PickupZone").get_overlapping_bodies().size() > 0:
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
					item_object.position = GlobalWorld.item_position[item_name]
		add_child(item_object)
	else:
		if !item_position.has(item_name):
			item_object.position = Player.position
		else:
			item_object.position = GlobalWorld.item_position[item_name]
		add_child(item_object)
