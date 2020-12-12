extends Node2D
var show_inv= true
var show_ch = true
var timer_bottom_message

func _ready():
	$Control/Error_panel.hide()
	$Control/inventory.hide()
	$Control/character.hide()
	$Control/inventory.text = "No items"
	$Control/bottom_message.text = "Press \"I\" to show the inventory\nPress \"C\" to show Player stats\nPress \"ESC\" to exit the game"
	character_info()

func show_inventory():
	if show_inv:
		$Control/inventory.show()
	else:
		$Control/inventory.hide()
	show_inv = !show_inv

func show_character():
	if show_ch:
		$Control/character.show()
	else:
		$Control/character.hide()
	show_ch = !show_ch

func update_label():
	$Control/inventory.text =""
	for key in Player.inventory:
		$Control/inventory.text += "%ss : %d" % [key, Player.inventory[key]]
		if (key != Player.inventory.keys().back()):
				$Control/inventory.text += "\n"

func character_info():
	$Control/character.text = ""
	for key in Player.stats:
		$Control/character.text += "%s : %d" % [key, Player.stats[key]]
		if (key != Player.stats.keys().back()):
				$Control/character.text += "\n"

func message(message):
	$Control/bottom_message.text = message
	yield(get_tree().create_timer(2.0), "timeout")
	$Control/bottom_message.text = ""

func error(message):
	$Control/Error_panel/Error_label.text = message
