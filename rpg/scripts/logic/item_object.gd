extends KinematicBody2D

export (String) var item_name
export (int) var item_quantity = 1

var player = null

func initialize(name: String, quantity: int):
	item_name = name
	item_quantity = quantity

func _ready():
	add_to_group("items")
	$Sprite.texture = load(Global.ITEMS_IMAGE_PATH + Data.item_data[item_name]["item_image"])
	$Panel/TextureRect.texture = load(Global.ITEMS_IMAGE_PATH + Data.item_data[item_name]["item_image"])
	$Panel/Amount.text = str(item_quantity)
	$Panel/Name.text = item_name

# warning-ignore:return_value_discarded
	$Area2D.connect("mouse_entered",self,"_on_mouse_entered")
# warning-ignore:return_value_discarded
	$Area2D.connect("mouse_exited",self,"_on_mouse_exited")


func item_picked(mode):
	if is_in_group("items"):
		if mode == "shown":
			InventoryController.loot_add_item(item_name, item_quantity)
			queue_free()
		elif mode == "direct":
			InventoryController.add_item(item_name, item_quantity)
			queue_free()

func _on_mouse_entered():
	$Panel.show()

func _on_mouse_exited():
	$Panel.hide()

