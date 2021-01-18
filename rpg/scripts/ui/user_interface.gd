extends CanvasLayer

const ItemObject = preload("res://scenes/item_object.tscn")


func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		if $Inventory.visible:
			inventory_opened()
		else:
			inventory_closed()
	if event.is_action_pressed("character"):
		$Stats.visible = !$Stats.visible


func inventory_opened():
	var slots = $Inventory/GridContainerLoot.get_children()
	# Clear any remaining item from Loot slots
	for i in slots.size():
		if slots[i].item != null:
			slots[i].remove_from_slot()
	
	Player.show_loot()
	Player.stop()
	$Inventory.initialize_inventory()


func inventory_closed():
	Player.resume()
	InventoryController.loot_inventory.clear()
	Global.item_position.clear()
	print_stray_nodes()
