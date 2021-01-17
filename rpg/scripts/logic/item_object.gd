extends KinematicBody2D

export (String) var item_name
export (int) var item_quantity = 1
var item_position = get_position()

func initialize(name: String, quantity: int):
	item_name = name
	item_quantity = quantity


func _ready():
	add_to_group("items")
	$Sprite.texture = load(Global.ITEMS_IMAGE_PATH + Data.item_data[item_name]["item_image"])
# warning-ignore:return_value_discarded
	Global.connect("item_picked",self,"_on_item_picked")


func fetch_item(mode):
	if is_in_group("items"):
		if mode == "shown":
			InventoryController.loot_add_item(item_name, item_quantity)
		elif mode == "direct":
			InventoryController.add_item(item_name, item_quantity)
			queue_free()
			

func _on_item_picked(item):
	if is_in_group("items"):
		for i in Player.get_node("PickupZone").get_overlapping_bodies():
			if item.item_name == i.item_name:
				i.queue_free()

