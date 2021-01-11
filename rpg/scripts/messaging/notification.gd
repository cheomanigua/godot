extends CanvasLayer

func _ready():
	$Control/Error_panel.hide()
	$Control/bottom_message.text = "Press \"I\" to show the inventory\n" \
	+ "Press \"C\" to show Player stats\n" \
	+ "Press \"ARROW UP\" to pickup one item\n" \
	+ "Press \"ARROW DOWN\" to grab all items\n" \
	+ "Press \"ESC\" to exit the game\n" \
	+ "Press \"SPACE BAR\" or \"RETURN\" to pause the game"


func message(message):
	$Control/bottom_message.text = message
	yield(get_tree().create_timer(5.0), "timeout")
	$Control/bottom_message.text = ""


func error(message):
	$Control/Error_panel/Error_label.text = message
