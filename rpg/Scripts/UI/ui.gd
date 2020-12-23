extends CanvasLayer

func _ready():
	$Inventory.hide()
	$Stats.hide()


func _unhandled_key_input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
	if event.is_action_pressed("character"):
		$Stats.visible = !$Stats.visible
