extends "res://Scripts/Characters/_character.gd"

#export (int) var speed = 300
signal inventory_updated
var inventory:Dictionary = {}
	
func add_item(item):
	if inventory.has(item):
		var temp = inventory[item]
		temp += 1
		inventory[item] = temp
#		print("You have %d %s" % [inventory[item], item])
	else:
		inventory[item] = 1
#		print("You have %d %s" % [inventory[item], item])
	emit_signal("inventory_updated")

func _ready():
	speed = 70

func get_input():
	velocity = Vector2()
	var LEFT	= Input.is_action_pressed('left')
	var RIGHT	= Input.is_action_pressed('right')
	var UP		= Input.is_action_pressed('up')
	var DOWN	= Input.is_action_pressed('down')

	velocity.x = -int(LEFT) + int(RIGHT)
	velocity.y = -int(UP) + int(DOWN)
#	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	get_input()
	movement()
	sprite_input()

	if velocity != Vector2():
		anim_switch("walk")
	else:
		anim_switch("idle")
