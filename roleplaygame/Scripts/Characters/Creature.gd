tool
extends "res://Scripts/Characters/_character.gd"

export(Texture) onready var texture setget texture_set, texture_get
export(String) var creature_type

func texture_set(newtexture):
	$Sprite.texture = newtexture

func texture_get():
	return $Sprite.texture

func _ready():
# warning-ignore:return_value_discarded
	$HitBox.connect("body_entered",self,"_on_Creature_body_entered")

func _on_Creature_body_entered(body):
	if body.get_name() == "Player":
		combat.combat(get_node("."))
