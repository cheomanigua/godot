extends Area2D

func _ready():
# warning-ignore:return_value_discarded
	connect("body_entered",self,"_on_Key_body_entered")

func _on_Key_body_entered(body):
	if body.get_name() == "Player":
		Player.add_item("key")
		queue_free()
