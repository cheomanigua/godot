#tool
extends "res://Scripts/Characters/character.gd"
onready var data = preload("res://Scripts/Logic/data.gd").new()
onready var combat = load("res://Scripts/Logic/combat.gd").new()

export(String,"Human","Orc","Goblin", "Adivía", "Agoiru") var creature_type = "Orc"
var creature_stats:Dictionary = {}

var movetimer_length = 15
var movetimer = 0

## Uncomment below if you want to add the sprite texture manually in the inspector ##
#export(Texture) onready var texture setget texture_set, texture_get
#
#func texture_set(newtexture):
#	$Sprite.texture = newtexture
#
#func texture_get():
#	return $Sprite.texture


func _ready():
	speed = 40
	add_child(data)
	add_child(combat)
	
	# Initialize creature_stats data (dictionary) based on json file data
	data.open_creatures_file()
	for key in data.creature_data.get(creature_type):
		creature_stats = data.creature_data.get(creature_type)
	data.queue_free()
	
	# Initialize creature texture based on json file data
	var texture = load("%s" % creature_stats.texture)
	$Sprite.texture = texture
	$Sprite.set_vframes(creature_stats["vframes"])
	$Sprite.set_hframes(creature_stats["hframes"])
	$Sprite.set_frame(creature_stats["frame"])
	
	# Initiaze animation
	$AnimationPlayer.play("default")
	
	# Initialize creature movement
	velocity = creature_random_movement()
	
	# Show floating text on creataure when hit or missed
	combat.connect("enemy_hit",self,"show_hit")
	
# warning-ignore:return_value_discarded
	# Initiate combat when creature is touched
	$HitBox.connect("body_entered",self,"_on_Creature_body_entered")


func _physics_process(_delta):
	movement()
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0:
		velocity = creature_random_movement()
		movetimer = movetimer_length


func _on_Creature_body_entered(body):
	if body.get_name() == "Player":
		combat.attack(self)


func show_hit(damage, crit):
	$FCTMgr.show_value(damage, crit)


