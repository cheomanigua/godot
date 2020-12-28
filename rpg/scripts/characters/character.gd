extends KinematicBody2D

var speed = 0
var velocity = Vector2()
var spritedir = "down"

const CENTER = Vector2()
const LEFT = Vector2(-1,0)
const RIGHT = Vector2(1,0)
const UP = Vector2(0,-1)
const DOWN = Vector2(0,1)


func creature_random_movement():
	var d = randi() % 4 + 1
	match d:
		1:
			return LEFT
		2:
			return RIGHT
		3:
			return UP
		4:
			return DOWN


func movement():
	var motion = velocity.normalized() * speed
# warning-ignore:return_value_discarded
	move_and_slide(motion, Vector2())
#	move_and_slide(velocity,Vector2())
#	velocity = move_and_slide(velocity)


func sprite_input():
	match velocity:
		Vector2(-1,0):
			spritedir = "left"
		Vector2(1,0):
			spritedir = "right"
		Vector2(0,-1):
			spritedir = "up"
		Vector2(0,1):
			spritedir = "down"


func anim_switch(animation):
	var newanim = str(animation,spritedir)
	if $AnimationPlayer.current_animation != newanim:
		$AnimationPlayer.play(newanim)
