tool
extends "res://Scripts/Characters/character.gd"

export(String,"Human","Orc","Goblin") var creature_type = "Orc"

## Uncomment below if you want to add the sprite texture manually in the inspector ##
#export(Texture) onready var texture setget texture_set, texture_get
#func texture_set(newtexture):
#	$Sprite.texture = newtexture
#
#func texture_get():
#	return $Sprite.texture

func _ready():
	# Initialize creature stats dictionary based on json file data
	for key in Data.creature_data.get(creature_type):
		creature_stats = Data.creature_data.get(creature_type)
	
	# Initialize creature texture based on json file data
	var texture = load("%s" % creature_stats.Texture)
	get_node("Sprite").texture = texture
	
# warning-ignore:return_value_discarded
	# Initiate combat when creature is touched
	$HitBox.connect("body_entered",self,"_on_Creature_body_entered")

func _on_Creature_body_entered(body):
	if body.get_name() == "Player":
		Combat.combat(get_node("."))
