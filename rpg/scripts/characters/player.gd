extends "res://scripts/characters/character.gd"

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
		pickup_item()
	if event.is_action_pressed("ui_down"):
		grab_item()
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	if (event.is_action_pressed("ui_accept")):
		pause()
	if event.is_action_pressed("ui_right"):
		overlapping()

func show_item():
	# Be sure to set the $PickupZone's Collision Mask to point to ItemDrop
	if $PickupZone.get_overlapping_bodies().size() > 0:
		var i := 0
		for item in $PickupZone.get_overlapping_bodies():
			if i < InventoryController.NUM_LOOT_INVENTORY_SLOTS:
				item.item_picked("shown")
				i += 1


func pickup_item():
	# Be sure to set the $PickupZone's Collision Mask to point to ItemDrop
	if $PickupZone.get_overlapping_bodies().size() > 0:
		# Pick up one item in Player's reach
		var item = $PickupZone.get_overlapping_bodies()[0]
		if InventoryController.inventory.size() < InventoryController.NUM_INVENTORY_SLOTS:
			item.item_picked("direct")
			item.queue_free()


func grab_item():
		# Be sure to set the $PickupZone's Collision Mask to point to ItemDrop
	if $PickupZone.get_overlapping_bodies().size() > 0:
		var o = $PickupZone.get_overlapping_bodies().size()
		var i = InventoryController.inventory.size()
		var s = InventoryController.NUM_INVENTORY_SLOTS
		# Grab all items in Player's reach if there is enough space in inventory
		if (s-i)/o >= 1:
			for item in $PickupZone.get_overlapping_bodies():
				item.item_picked("direct")
				i += 1
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
	var overlap: Array
	for i in $PickupZone.get_overlapping_bodies().size():
		var item = $PickupZone.get_overlapping_bodies()[i]
# warning-ignore:unassigned_variable
		var array: Array
		array.push_front(item.item_quantity)
		array.push_front(item.item_name)
		overlap.push_front(array)
	return overlap
