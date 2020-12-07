extends KinematicBody2D

var speed = 0
var velocity = Vector2()
var spritedir = "down"

export (Dictionary) var stats = {
	"strength" : 4,
	"intelligence" : 4,
	"dexterity" : 3,
	"endurance" : 6,
	"health" : 10,
}

func movement():
	var motion = velocity.normalized() * speed
# warning-ignore:return_value_discarded
	move_and_slide(motion, Vector2())
#	move_and_slide(velocity,Vector2())
#	velocity = move_and_slide(velocity)
#
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
	if get_node("AnimationPlayer").current_animation != newanim:
		get_node("AnimationPlayer").play(newanim)
