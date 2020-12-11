tool
extends Area2D

export(Texture) onready var texture setget texture_set, texture_get
export (String) var item_name
export (int) var amount = 1

func texture_set(newtexture):
	$Sprite.texture = newtexture

func texture_get():
	return $Sprite.texture

func _ready():
	if item_name:
		pickup(item_name)
	else:
		pickup(get_parent().get_name())

func pickup(item):
# warning-ignore:return_value_discarded
	connect("body_entered",self,"_on_body_entered",[item])

func _on_body_entered(body,item):
	if body.get_name() == "Player":
		Player.add_item(item,amount)
		Gui.message("%d %s picked up" % [amount,item])
		queue_free()
