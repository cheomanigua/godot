extends Area2D

func _ready():
# We create the built-in signal body_entered via code instead of using the editor
# warning-ignore:return_value_discarded
	connect("body_entered",self,"_on_Zone_body_entered")

func _on_Zone_body_entered(body):
	#if body.has_method("player_spotted")
	#if body.get_name() == "Player":
	if body.is_in_group("players"):
		print(str(get_name()) + "'s message: Player entered the ZONE")
	elif body.has_method("grabbed"):
		body.grabbed()
	else:
		print(str(get_name()) + "'s message: Unknown object entered the ZONE")
