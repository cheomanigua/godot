extends KinematicBody2D

export (String) var item_name
export (int) var amount = 1

var player = null
var being_picked_up = false

func initialize(name: String, quantity: int):
	item_name = name
	amount = quantity
	
func _ready():
	add_to_group("items")
	$Sprite.texture = load(Global.ITEMS_IMAGE_PATH + Data.item_data[item_name]["item_image"])
	pickup(item_name)
# warning-ignore:return_value_discarded
	Global.connect("item_picked",self,"_on_item_picked")
	Global.connect("item_grabbed",self,"_on_item_grabbed")
	

func pickup(item):
# warning-ignore:return_value_discarded
	$Area2D.connect("body_entered",self,"_on_body_entered",[item])
# warning-ignore:return_value_discarded
	$Area2D.connect("body_exited",self,"_on_body_exited",[item])

func _on_body_entered(body,_item):
	if body.get_name() == "Player":
#		print("Player entered")
		PlayerInventory.temp_add_item(item_name, amount)
#		print(PlayerInventory.loot_inventory)

func _on_body_exited(body,_item):
	if body.get_name() == "Player":
#		print("Player exited")
		PlayerInventory.temp_inventory.clear()
#		print(PlayerInventory.loot_inventory)


func _on_item_picked():
	if being_picked_up == true:
		PlayerInventory.loot_inventory = Global.deep_copy(PlayerInventory.temp_inventory)
#		PlayerInventory.loot_add_item(item_name, amount)
#		queue_free()
		Notification.message("%d %s picked up" % [amount,item_name])
		Global.picked_up = true

func _on_item_grabbed():
	if being_picked_up == true:
		queue_free()
		print("Has llegado hasta aqui?")

func pick_up_item(body):
	player = body
	being_picked_up = true



