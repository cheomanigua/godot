extends StaticBody2D
export (String) var key # Fill this field in Inspector if a door requires a key to be opened


func _ready():
# warning-ignore:return_value_discarded
	$Area2D.connect("body_entered",self,"_on_Door_body_entered")
# warning-ignore:return_value_discarded
	$Area2D.connect("body_exited",self,"_on_Door_body_exited")
#	var my_door = Door.instance()


func _on_Door_body_entered(body):
	if body.get_name() == "Player":
		# Execute if a key is needed to open the door
		if key:
			var has_key: bool = false
			# Loop through the inventory dictionary to check for the key
			for i in InventoryController.usage_inventory:
				# If key is found, door is opened
				if InventoryController.usage_inventory[i][0] == key:
					has_key = true
					$CollisionShape2D.set_deferred("disabled", true)
					hide()
					Notification.message("Door opened with %s" % [key])
			# If no key is found, no door is opened
			if !has_key:
				Notification.message("You need a %s" % [key])
		# Exectute if no key is needed to open the door
		else:
			$CollisionShape2D.set_deferred("disabled", true)
			hide()
			Notification.message("No key needed")

func _on_Door_body_exited(body):
	if body.get_name() == "Player":
		$CollisionShape2D.set_deferred("disabled", false)
		show()

