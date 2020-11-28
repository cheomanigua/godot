extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

func _ready():
	add_to_group("players")
	var zone = get_tree().get_root().find_node("Zone", true, false)
	zone.connect("body_entered",self,"player_spotted")

func player_spotted(body):
	if body.is_in_group("players"):
		print(str(self.get_name()) + "'s message: The Zone knows that I entered the ZONE")
	
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

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
