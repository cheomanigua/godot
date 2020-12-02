extends KinematicBody2D

export (int) var speed = 300
var velocity = Vector2()

var inventory = {"coin" : 0}

var health = 10

func add_item(item):
	if inventory.has(item):
		var t = inventory[item]
		t += 1
		inventory[item] = t
		print("You have collected %d %ss" % [inventory[item], item])
	else:
		inventory[item] = 1
		print("You have collected %d %s" % [inventory[item], item])


func get_input():
	velocity = Vector2()
	var LEFT	= Input.is_action_pressed('left')
	var RIGHT	= Input.is_action_pressed('right')
	var UP		= Input.is_action_pressed('up')
	var DOWN	= Input.is_action_pressed('down')
	
	velocity.x = -int(LEFT) + int(RIGHT)
	velocity.y = -int(UP) + int(DOWN)
	velocity = velocity.normalized() * speed

func movement():
	velocity = move_and_slide(velocity)

func _physics_process(_delta):
	get_input()
	movement()
