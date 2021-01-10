extends "res://scripts/characters/character.gd"
#signal item_picked

#var inventory:Dictionary
var is_paused: bool = false

export (Dictionary) var stats = {
	"strength" : 4,
	"intelligence" : 4,
	"dexterity" : 3,
	"endurance" : 6,
	"health" : 10,
}


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	speed = 70
	print_stray_nodes()


func get_input():
	velocity = Vector2()
	var LEFT = Input.is_action_pressed('left')
	var RIGHT = Input.is_action_pressed('right')
	var UP = Input.is_action_pressed('up')
	var DOWN = Input.is_action_pressed('down')
	
	velocity.x = -int(LEFT) + int(RIGHT)
	velocity.y = -int(UP) + int(DOWN)


func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		grab_item()
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	if (event.is_action_pressed("ui_accept")):
		pause()
	if (event.is_action_pressed("ui_down")):
		var node = $PickupZone.items_in_range
		for i in node.size():
			print(node.keys()[i].queue_free())


func pickup_item():
	# Be sure to set the $PickupZone's Collision Mask to point to ItemDrop
	if $PickupZone.items_in_range.size() > 0:
		var pickup_item = $PickupZone.items_in_range.values()
		for item in pickup_item:
			item.pick_up_item(self)
			$PickupZone.items_in_range.erase(item)
			Global.emit_signal("item_picked")



func grab_item():
	if $PickupZone.items_in_range.size() > 0:
		
		# Grabbing only one item at once (bug when opening inventory)
		var pickup_item = $PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$PickupZone.items_in_range.erase(pickup_item)
		Global.emit_signal("item_grabbed")

#		# Grabing grabbing all items at once (bug when opening inventory)
#		var pickup_item = $PickupZone.items_in_range.values()
#		for i in pickup_item:
#			i.pick_up_item(self)
#			$PickupZone.items_in_range.erase(i)
#			Global.emit_signal("item_grabbed")
#			i.free()


func reset_pickup_zone():
	$PickupZone/CollisionShape2D.disabled = true
	$PickupZone/CollisionShape2D.disabled = false


func pause():
	is_paused = !is_paused
	if is_paused:
		get_tree().paused = true
		set_physics_process(false)
	else:
		get_tree().paused = false
		set_physics_process(true)


func _physics_process(_delta):
	get_input()
	movement()
	sprite_input()

	if velocity != Vector2():
		anim_switch("walk")
	else:
		anim_switch("idle")


func stop():
	self.set_physics_process(false)
	$AnimationPlayer.stop()


func resume():
	self.set_physics_process(true)
