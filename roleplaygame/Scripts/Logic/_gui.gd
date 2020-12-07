extends Control

func _ready():
	$Label.text = "No items"
# warning-ignore:return_value_discarded
	Player.connect("inventory_updated",self,"update_label")

func update_label():
	$Label.text =""
	for key in Player.inventory:
		$Label.text += "%s : %d" % [key, Player.inventory[key]]
		if (key != Player.inventory.keys().back()):
				$Label.text += "\n"
