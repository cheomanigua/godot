tool
extends "res://Scripts/Characters/character.gd"
onready var data = preload("res://Scripts/Logic/data.gd").new()
onready var combat = load("res://Scripts/Logic/combat.gd").new()

export(String,"Human","Orc","Goblin") var creature_type = "Orc"

## Uncomment below if you want to add the sprite texture manually in the inspector ##
export(Texture) onready var texture setget texture_set, texture_get
func texture_set(newtexture):
	$Sprite.texture = newtexture

func texture_get():
	return $Sprite.texture


func _ready():
	add_child(data)
	add_child(combat)
	combat.connect("enemy_hit",self,"show_hit")
	# Initialize creature_stats dictionary based on json file data
	data.open_creatures_file()
	for key in data.creature_data.get(creature_type):
		creature_stats = data.creature_data.get(creature_type)
	data.queue_free()
	
	# Initialize creature texture based on json file data
#	var texture = load("%s" % creature_stats.Texture)
#	get_node("Sprite").texture = texture

# warning-ignore:return_value_discarded
	# Initiate combat when creature is touched
	$HitBox.connect("body_entered",self,"_on_Creature_body_entered")

#func _exit_tree():
#	data.queue_free()
#	combat.queue_free()

func _on_Creature_body_entered(body):
	if body.get_name() == "Player":
		combat.attack(self)


func show_hit(damage, crit):
	$FCTMgr.show_value(damage, crit)

