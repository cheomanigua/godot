extends Control
var show = true

func _ready():
	$Label.hide()
	$Label.text = "No items"
	$Label2.text = ""
# warning-ignore:return_value_discarded
	Player.connect("inventory_updated",self,"update_label")
	
func show_panel():
	if show:
		$Label.show()
	else:
		$Label.hide()
	show = !show

func update_label():
	$Label.text =""
	for key in Player.inventory:
		$Label.text += "%s : %d" % [key, Player.inventory[key]]
		if (key != Player.inventory.keys().back()):
				$Label.text += "\n"

func message(message):
	$Label2.text = message


