extends "res://Scripts/Characters/character.gd"

#export (int) var speed = 300
var inventory:Dictionary = {}
var is_paused: bool = false

export (Dictionary) var stats = {
	"strength" : 4,
	"intelligence" : 4,
	"dexterity" : 3,
	"endurance" : 6,
	"health" : 10,
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
	pause_mode = Node.PAUSE_MODE_PROCESS
	speed = 70
	print_stray_nodes()


func get_input():
	velocity = Vector2()
	var LEFT = Input.is_action_pressed('left')
	var RIGHT = Input.is_action_pressed('right')
	var UP = Input.is_action_pressed('up')
	var DOWN = Input.is_action_pressed('down')

	velocity.x = -int(LEFT) + int(RIGHT)
	velocity.y = -int(UP) + int(DOWN)


func _unhandled_input(event):
#	get_input()                  
	if event.is_action_released("inventory"):
		Gui.show_inventory()
	if (event.is_action_released("character")):
		Gui.show_character()
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	if (event.is_action_pressed("ui_accept")):
		is_paused = !is_paused
		pause()
		print("Return key pressed")
		

func pause():
	if is_paused:
		get_tree().paused = true
		set_physics_process(false)
	else:
		get_tree().paused = false
		set_physics_process(true)
  
func _physics_process(_delta):
	get_input()
	movement()
	sprite_input()

	if velocity != Vector2():
		anim_switch("walk")
	else:
		anim_switch("idle")
