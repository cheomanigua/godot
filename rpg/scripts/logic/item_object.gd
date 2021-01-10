extends KinematicBody2D

export (String) var item_name
export (int) var item_quantity = 1

var player = null
var being_picked_up = false

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
	Global.connect("item_picked",self,"_on_item_picked")
# warning-ignore:return_value_discarded
	Global.connect("item_grabbed",self,"_on_item_grabbed")
# warning-ignore:return_value_discarded
	$Area2D.connect("body_entered",self,"_on_body_entered")
# warning-ignore:return_value_discarded
	$Area2D.connect("body_exited",self,"_on_body_exited")
# warning-ignore:return_value_discarded
	$Area2D.connect("mouse_entered",self,"_on_mouse_entered")
# warning-ignore:return_value_discarded
	$Area2D.connect("mouse_exited",self,"_on_mouse_exited")


func _on_body_entered(body):
	if body.get_name() == "Player":
		InventoryController.loot_add_item(item_name, item_quantity)


func _on_body_exited(body):
	if body.get_name() == "Player":
		InventoryController.loot_inventory.clear()


func _on_item_picked():
	if being_picked_up == true:
#		InventoryController.loot_inventory = str2var(var2str(InventoryController.temp_inventory))
#		InventoryController.add_item(item_name, item_quantity)
#		queue_free()
#		Notification.message("%d %s picked up" % [item_quantity,item_name])
		queue_free()


func _on_item_grabbed():
	
	# Grabbing only one item at once
	if being_picked_up == true:
		InventoryController.add_item(item_name, item_quantity)
		queue_free()
		
	# Grabing grabbing all items at once	
#	if is_queued_for_deletion():
#		return
#	queue_free()
#	var inventory = InventoryController.inventory
#	var temp_inventory = InventoryController.temp_inventory
#	if being_picked_up == true:
#		var offset = inventory.size()
#		for i in temp_inventory.size():
#			inventory[offset + i] = temp_inventory[i]

func pick_up_item():
	being_picked_up = true

func _on_mouse_entered():
	$Panel.show()

func _on_mouse_exited():
	$Panel.hide()

