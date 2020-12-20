tool
extends Sprite

export (String) var item_name
export (int) var amount = 1


func _ready():
	if item_name:
		pickup(item_name)
	else:
		# If item_name is not filled in the inspector, throw a warning
		push_warning("You must fill out item_name for node %s/%s" % [get_parent().name, get_name()])
		Gui.get_node("Control/Error_panel").show()
		Gui.error("You must fill out item_name\nfor node %s/%s" % [get_parent().name, get_name()])


func pickup(item):
# warning-ignore:return_value_discarded
	$Area2D.connect("body_entered",self,"_on_body_entered",[item])


func _on_body_entered(body,item):
	if body.get_name() == "Player":
		Player.add_item(item,amount)
		if amount > 1:
			Gui.message("%d %ss picked up" % [amount,item])
		else:
			Gui.message("%d %s picked up" % [amount,item])
		queue_free()
