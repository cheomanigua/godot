extends "res://Scripts/Characters/_character.gd"

#export (int) var speed = 300
var inventory:Dictionary = {}
export (Dictionary) var stats = {
	"Strength" : 4,
	"Intelligence" : 4,
	"Dexterity" : 3,
	"Endurance" : 6,
	"Health" : 10,
}
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

func _input(event):
	if event.is_action_released("inventory"):
		Gui.show_inventory()
	if (event.is_action_released("character")):
		Gui.show_character()
	if (event.is_action_pressed("quit")):
		get_tree().quit()
	
func _physics_process(_delta):
	get_input()
	movement()
	sprite_input()

	if velocity != Vector2():
		anim_switch("walk")
	else:
		anim_switch("idle")
