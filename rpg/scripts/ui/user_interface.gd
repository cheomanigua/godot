extends CanvasLayer

const ItemObject = preload("res://scenes/item_object.tscn")
func _ready():
	$Inventory.hide()
	$Stats.hide()
	
func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		Player.pickup_item()
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
		if $Inventory.visible:
			inventory_opened()
		else:
			inventory_closed()

	if event.is_action_pressed("character"):
		$Stats.visible = !$Stats.visible


func inventory_opened():
#	Player.pickup_item()
	Player.stop()


func inventory_closed():
	Player.resume()
	var i_slots = $Inventory/GridContainerLoot.get_children()
	var loot_inventory = InventoryController.loot_inventory
	
	for i in i_slots.size():
#		# If there are items remaining in Loot inventory
#		# place them in the ground
		if i_slots[i].item != null:
			var na = i_slots[i].item.item_name
			var qt = i_slots[i].item.item_quantity
			var item_object = ItemObject.instance()
			item_object.initialize(na, qt)
			add_child(item_object)
			item_object.position = Player.position
			i_slots[i].remove_from_slot()
	loot_inventory.clear()
	# Disable and enable Player's $PickupZone in order to fetch items
	# on the ground when opening the inventory again
	Player.reset_pickup_zone()
	print_stray_nodes()
