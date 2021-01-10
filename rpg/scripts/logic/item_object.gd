extends KinematicBody2D

export (String) var item_name
export (int) var amount = 1

var player = null
var being_picked_up = false

func initialize(name: String, quantity: int):
	item_name = name
	amount = quantity

func _input(event):
	if event.is_action_pressed("left_mouse"):
#		InventoryController.add_item(item_name, amount)
#		self.queue_free()
		print(item_name)
func _ready():
	add_to_group("items")
	$Sprite.texture = load(Global.ITEMS_IMAGE_PATH + Data.item_data[item_name]["item_image"])
	$Panel/TextureRect.texture = load(Global.ITEMS_IMAGE_PATH + Data.item_data[item_name]["item_image"])
	$Panel/Amount.text = str(amount)
	$Panel/Name.text = item_name
	
	pickup(item_name)
# warning-ignore:return_value_discarded
	Global.connect("item_picked",self,"_on_item_picked")
# warning-ignore:return_value_discarded
	Global.connect("item_grabbed",self,"_on_item_grabbed")
	

func pickup(item):
# warning-ignore:return_value_discarded
	$Area2D.connect("body_entered",self,"_on_body_entered",[item])
# warning-ignore:return_value_discarded
	$Area2D.connect("body_exited",self,"_on_body_exited",[item])
# warning-ignore:return_value_discarded
	$Area2D.connect("mouse_entered",self,"_on_mouse_entered")
# warning-ignore:return_value_discarded
	$Area2D.connect("mouse_exited",self,"_on_mouse_exited")


func _on_body_entered(body,_item):
	if body.get_name() == "Player":
		InventoryController.temp_add_item(item_name, amount)

func _on_body_exited(body,_item):
	if body.get_name() == "Player":
		InventoryController.temp_inventory.clear()


func _on_item_picked():
	if being_picked_up == true:
		InventoryController.loot_inventory = str2var(var2str(InventoryController.temp_inventory))
#		InventoryController.add_item(item_name, amount)
#		queue_free()
#		Notification.message("%d %s picked up" % [amount,item_name])
		Global.picked_up = true


func _on_item_grabbed():
	
	# Grabbing only one item at once
	if being_picked_up == true:
		InventoryController.add_item(item_name, amount)
		queue_free()
#		Global.picked_up = true
		
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

func pick_up_item(body):
	player = body
	being_picked_up = true

func _on_mouse_entered():
	$Panel.show()

func _on_mouse_exited():
	$Panel.hide()

