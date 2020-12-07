extends "res://Scripts/Characters/_character.gd"

var combat = load("res://Scripts/Logic/_combat.gd").new()

func _ready():
# warning-ignore:return_value_discarded
	$HitBox.connect("body_entered",self,"_on_Orc_body_entered")

func _on_Orc_body_entered(body):
	if body.get_name() == "Player":
		combat.combat(get_node("."))
