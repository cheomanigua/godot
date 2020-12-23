extends RigidBody2D

export var thrust = Vector2(0, -250)
export var torque = 1500

func _integrate_forces(_state):
	if Input.is_action_pressed("ui_up"):
		applied_force = thrust.rotated(rotation)
		$Particles2D.set_emitting(true)
	elif Input.is_action_pressed("ui_accept"):
		thrust = Vector2(0, -1000)
		applied_force = thrust.rotated(rotation)
		$Particles2D.set_emitting(true)
		thrust = Vector2(0, -250)
	else:
		applied_force = Vector2()
		$Particles2D.set_emitting(false)
	var rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
	applied_torque = rotation_dir * torque

func grabbed():
	print ("%s's message: I've been grabbed by the ZONE" % get_name())
