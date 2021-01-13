extends KinematicBody2D

export (String) var item_name
export (int) var item_quantity = 1


func initialize(name: String, quantity: int):
	item_name = name
	item_quantity = quantity


func _ready():
	add_to_group("items")
	$Sprite.texture = load(Global.ITEMS_IMAGE_PATH + Data.item_data[item_name]["item_image"])


func fetch_item(mode):
	if is_in_group("items"):
		if mode == "shown":
			InventoryController.loot_add_item(item_name, item_quantity)
			queue_free()
		elif mode == "direct":
			InventoryController.add_item(item_name, item_quantity)
			queue_free()
