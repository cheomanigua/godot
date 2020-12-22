extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

func _ready():
	add_to_group("players")
#	var zone = get_tree().get_root().find_node("Zone", true, false)
# warning-ignore:return_value_discarded
	get_parent().get_node("Zone").connect("body_entered",self,"player_spotted")

func player_spotted(body):
	if body.is_in_group("players"):
		print("%s's message: The Zone knows that I entered the ZONE" % get_name())
	
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
