extends "res://Scripts/Characters/_character.gd"

#export (int) var speed = 300
var inventory:Dictionary = {}

func add_item(item,amount):
	if inventory.has(item):
		var temp = inventory[item]
		temp += amount
		inventory[item] = temp
#		print("You have %d %s" % [inventory[item], item])
	else:
		inventory[item] = amount
#		print("You have %d %s" % [inventory[item], item])
	Gui.update_label()

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
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
	if (Input.is_action_just_released("inventory")):
		Gui.show_inventory()
	if (Input.is_action_just_released("character")):
		Gui.show_character()

func _physics_process(_delta):
	get_input()
	movement()
	sprite_input()

	if velocity != Vector2():
		anim_switch("walk")
	else:
		anim_switch("idle")
