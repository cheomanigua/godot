extends "res://scripts/characters/character.gd"

var is_paused: bool = false

export (Dictionary) var stats = {
	"strength" : 4,
	"intelligence" : 4,
	"dexterity" : 3,
	"endurance" : 6,
	"health" : 0,
	"attack" : 0,
	"defense" : 0
}

func set_stats_value(key, value, duration):
	if duration != null:
		stats[key] = value
	else:
		stats[key] += value
	
var max_health = stats.strength + stats.endurance


func _ready():
	stats.health = stats.strength + stats.endurance
	pause_mode = Node.PAUSE_MODE_PROCESS
	speed = 70
	print_stray_nodes()


func get_input():
	velocity = Vector2()
	var LEFT = Input.is_key_pressed(KEY_A)
	var RIGHT = Input.is_key_pressed(KEY_D)
	var UP = Input.is_key_pressed(KEY_W)
	var DOWN = Input.is_key_pressed(KEY_S)
	
	velocity.x = -int(LEFT) + int(RIGHT)
	velocity.y = -int(UP) + int(DOWN)


func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		pickup_item()
	if event.is_action_pressed("ui_down"):
		grab_item()
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	if (event.is_action_pressed("ui_accept")):
		pause()


func show_loot():
	# Be sure to set the $PickupZone's Collision Mask to point to ItemObject
	if $PickupZone.get_overlapping_bodies().size() > 0:
		var i := 0
		for item in $PickupZone.get_overlapping_bodies():
			GlobalWorld.item_position[item.item_name] = item.position
			if i < InventoryController.NUM_LOOT_INVENTORY_SLOTS:
				item.fetch_item("shown")
				i += 1


func pickup_item():
	# Be sure to set the $PickupZone's Collision Mask to point to ItemObject
	if $PickupZone.get_overlapping_bodies().size() > 0:
		# Pick up one item in Player's reach
		var item = $PickupZone.get_overlapping_bodies()[0]
		if InventoryController.inventory.size() < InventoryController.NUM_INVENTORY_SLOTS:
			item.fetch_item("direct")
			item.queue_free()


func grab_item():
		# Be sure to set the $PickupZone's Collision Mask to point to ItemObject
	if $PickupZone.get_overlapping_bodies().size() > 0:
		var o = $PickupZone.get_overlapping_bodies().size()
		var i = InventoryController.inventory.size()
		var s = InventoryController.NUM_INVENTORY_SLOTS
		# Grab all items in Player's reach if there is enough space in inventory
		if (s-i)/o >= 1:
			for item in $PickupZone.get_overlapping_bodies():
				item.fetch_item("direct")
		else:
			print("Alert: Not enough space in inventory. Pick one by one instead")


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


# Debugging
func overlapping():
# warning-ignore:unassigned_variable
	var overlap: Dictionary
	var i := 0
	for item in $PickupZone.get_overlapping_bodies():
		overlap[i] = [item.item_name, item.item_quantity]
		i += 1
	return overlap
