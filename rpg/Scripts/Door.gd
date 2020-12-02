extends StaticBody2D

func _ready():
# warning-ignore:return_value_discarded
	$HitBox.connect("body_entered",self,"_on_Door_body_entered")
# warning-ignore:return_value_discarded
	$HitBox.connect("body_exited",self,"_on_Door_body_exited")

func _on_Door_body_entered(body):
	if body.get_name() == "Player":
		if Player.inventory.has("key"):
			$CollisionShape2D.set_deferred("disabled", true)
			get_node(".").hide()
			print ("You shall pass")
		else:
			print("You need a key")

func _on_Door_body_exited(body):
	if body.get_name() == "Player":
		$CollisionShape2D.set_deferred("disabled", false)
		get_node(".").show()

