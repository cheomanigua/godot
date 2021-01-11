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
			Player.stop()
		else:
			inventory_closed()

	if event.is_action_pressed("character"):
		$Stats.visible = !$Stats.visible


func inventory_closed():
	Player.resume()
	var slots = $Inventory/GridContainerLoot.get_children()
	
	for i in slots.size():
#		# If there are items remaining in Loot inventory
#		# place them in the ground
		if slots[i].item != null:
			var item_name = slots[i].item.item_name
			var item_quantity = slots[i].item.item_quantity
			var item_object = ItemObject.instance()
			item_object.initialize(item_name, item_quantity)
			add_child(item_object)
			item_object.position = Player.position
			slots[i].remove_from_slot()
	# Disable and enable Player's $PickupZone in order to fetch items
	# on the ground when opening the inventory again
	InventoryController.loot_inventory.clear()
	Player.reset_pickup_zone()
	print_stray_nodes()
