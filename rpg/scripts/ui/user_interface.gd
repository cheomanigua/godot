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
	var slots = $Inventory/GridContainerLoot.get_children()
	for i in slots.size():
		if slots[i].item != null:
			
			var item_name = slots[i].item.item_name
			var item_quantity = slots[i].item.item_quantity
			var item_object = ItemObject.instance()
			item_object.initialize(item_name, item_quantity)
			add_child(item_object)
			for o in Player.get_node("PickupZone").get_overlapping_bodies():
				if o.item_name == item_object.item_name:
					item_object.position = o.position
					o.queue_free()
			slots[i].remove_from_slot()
			
	# Disable and enable Player's $PickupZone in order to fetch items
	# on the ground when opening the inventory again
	InventoryController.loot_inventory.clear()
#	Player.reset_pickup_zone()
	print_stray_nodes()
