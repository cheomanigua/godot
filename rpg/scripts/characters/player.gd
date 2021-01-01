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
		pickup_item()
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	if (event.is_action_pressed("ui_accept")):
		pause()
	# Key for testing
	if event.is_action_pressed("ui_left"):
		# Testing
#		randomize()
		if PlayerInventory.loot_inventory.size() == 0:
			print("Loot:")
			print("No items yet on Loot")
		else:
			print("")
			print("Loot:")
			for key in PlayerInventory.loot_inventory:
				print("%s: %s" % [PlayerInventory.loot_inventory[key][0],PlayerInventory.loot_inventory[key][1]])
	if event.is_action_pressed("ui_right"):
		# Testing
#		randomize()
		if PlayerInventory.inventory.size() == 0:
			print("Inventory:")
			print("No items yet on Inventory")
		else:
			print("")
			print("Inventory:")
			for key in PlayerInventory.inventory:
				print("%s: %s" % [PlayerInventory.inventory[key][0],PlayerInventory.inventory[key][1]])
#			var rand = randi() % Player.inventory.size()
#			var item = Player.inventory[rand][0]
#			var amount = randi() % 5 + 1
#			print("%s: %s" % [item, amount])


func pickup_item():
	if $PickupZone.items_in_range.size() > 0:
		var pickup_item = $PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$PickupZone.items_in_range.erase(pickup_item)
		Global.emit_signal("item_picked")


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
