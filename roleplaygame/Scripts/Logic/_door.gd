extends StaticBody2D
export (String) var key

func _ready():
# warning-ignore:return_value_discarded
	$Area2D.connect("body_entered",self,"_on_Door_body_entered")
# warning-ignore:return_value_discarded
	$Area2D.connect("body_exited",self,"_on_Door_body_exited")

func _on_Door_body_entered(body):
	if body.get_name() == "Player":
		if key:
			if Player.inventory.has(key):
				$CollisionShape2D.set_deferred("disabled", true)
				get_node(".").hide()
				Gui.message("Door opened with %s" % [key])
			else:
				Gui.message("You need a %s" % [key])
		else:
			$CollisionShape2D.set_deferred("disabled", true)
			get_node(".").hide()
			Gui.message("No key needed")

func _on_Door_body_exited(body):
	if body.get_name() == "Player":
		$CollisionShape2D.set_deferred("disabled", false)
		get_node(".").show()
