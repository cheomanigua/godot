#tool
extends "res://scripts/characters/character.gd"
#onready var data = preload("res://Scripts/Logic/data.gd").new()
onready var combat = load("res://scripts/logic/combat.gd").new()

export(String,"Human","Orc","Goblin", "Adivía", "Agoiru") var creature_type = "Orc"
var creature_stats:Dictionary

enum states {PATROL, CHASE, ATTACK, DEAD}
var state = states.PATROL
var player = null

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
#	add_child(data)
	add_child(combat)
	
	# Initialize creature_stats Data (dictionary) based on json file data
	for key in Data.creature_data[creature_type]:
		creature_stats = Data.creature_data[creature_type]
#	data.queue_free()
	
	# Initialize creature texture based on json file data
	$Sprite.texture = load("%s" % creature_stats["texture"])
	$Sprite.set_vframes(creature_stats["vframes"])
	$Sprite.set_hframes(creature_stats["hframes"])
	$Sprite.set_frame(creature_stats["frame"])
	
	# Initiaze animation
	$AnimationPlayer.play("default")
	
	# Show floating text on creataure when hit or missed
	combat.connect("enemy_hit",self,"show_hit")
	
# warning-ignore:return_value_discarded
	# Start combat when creature is touched
	$HitBox.connect("body_entered",self,"_on_HitBox_body_entered")
	
# warning-ignore:return_value_discarded
	# Start chase state when player enters creature's detect area
	$DetectArea.connect("body_entered",self,"_on_DetectArea_body_entered")
# warning-ignore:return_value_discarded
	# Start patrol state when player exits creature's detect area
	$DetectArea.connect("body_exited",self,"_on_DetectArea_body_exited")


func _physics_process(_delta):
	state_switch()
	movement()


func _on_HitBox_body_entered(body):
	if body.get_name() == "Player":
		combat.attack(self)


func show_hit(damage, crit):
	$FCTMgr.show_value(damage, crit)


### STATE MACHINE RELATED FUNCTIONS START HERE ###

func _on_DetectArea_body_entered(body):
	if body.get_name() == "Player":
		state = states.CHASE
		player = body


func _on_DetectArea_body_exited(body):
	if body.get_name() == "Player":
		state = states.PATROL
		player = null


func state_switch():
	match state:
		states.PATROL:
			patrol()
		states.CHASE:
			chase()


func patrol():
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0:
		velocity = creature_random_movement()
		movetimer = movetimer_length


func chase():
	velocity = (player.position - position).normalized() * speed

### STATE MACHINE RELATED FUNCTIONS END HERE ###
