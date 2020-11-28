extends KinematicBody2D
#export (int) var speed = 200
#var velocity = Vector2()
#
func _input(event):
	if event.is_action_pressed('click'):
		target = get_global_mouse_position()

var target = Vector2()
const FOLLOW_SPEED = 4.0

func _physics_process(delta):
	self.position = self.position.linear_interpolate(target, delta * FOLLOW_SPEED)

#func _physics_process(delta):
#	velocity = position.direction_to(target) * speed
#	# look_at(target)
#	if position.distance_to(target) > 5:
#		velocity = move_and_slide(velocity)
