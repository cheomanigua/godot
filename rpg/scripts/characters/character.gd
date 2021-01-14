extends KinematicBody2D

var speed = 0
var velocity = Vector2()



func creature_random_movement():
	var d = randi() % 4 + 1
	match d:
		1:
			return Vector2.LEFT
		2:
			return Vector2.RIGHT
		3:
			return Vector2.UP
		4:
			return Vector2.DOWN


func movement():
	var motion = velocity.normalized() * speed
# warning-ignore:return_value_discarded
	move_and_slide(motion, Vector2())
#	move_and_slide(velocity,Vector2())
#	velocity = move_and_slide(velocity)


### PLAYER ANIMATION FUNCTIONS START HERE###
var spritedir = "down"

func sprite_input():
	match velocity:
		Vector2.LEFT:
			spritedir = "left"
		Vector2.RIGHT:
			spritedir = "right"
		Vector2.UP:
			spritedir = "up"
		Vector2.DOWN:
			spritedir = "down"


func anim_switch(animation):
	var newanim = str(animation,spritedir)
	if $AnimationPlayer.current_animation != newanim:
		$AnimationPlayer.play(newanim)

### PLAYER ANIMATION FUCTIONS ENDS HERE ###
