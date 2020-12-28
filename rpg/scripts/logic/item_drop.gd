extends KinematicBody2D

#const ACCELERATION = 460
#const MAX_SPEED = 225
#var velocity = Vector2.ZERO
export (String) var item_name
export (int) var amount = 1

var player = null
var being_picked_up = false


func _ready():
	add_to_group("items")
#	item_name = "Slime Potion"
	$Sprite.texture = load("%s" % Data.item_data[item_name]["item_image"])
#	PlayerInventory.add_item(item_name, amount)
#	queue_free()
# warning-ignore:return_value_discarded
	Player.connect("item_picked",self,"_on_item_picked")


func _on_item_picked():
#func _physics_process(_delta):
	if being_picked_up == true:
#		pass
#	else:
#		var _direction = global_position.direction_to(player.global_position)
#		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
#		var distance = global_position.distance_to(player.global_position)
#		if distance < 4:
		PlayerInventory.add_item(item_name, amount)
		queue_free()
		Notification.message("%d %s picked up" % [amount,item_name])
		Notification.message("%s is a %s item and has a value of %s" % [item_name, Data.item_data[item_name]["rarity"], Data.item_data[item_name]["item_value"]])
#	velocity = move_and_slide(velocity, Vector2.UP)


func pick_up_item(body):
	player = body
	being_picked_up = true
