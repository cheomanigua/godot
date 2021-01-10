extends CanvasLayer
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
	var _temp_inventory = InventoryController.temp_inventory
	
	if Global.picked_up:
		print("Has tocado cosas")
		if loot_inventory.empty():
#			var node = Player.get_node("PickupZone").items_in_range
#			for i in node.size():
#				node.keys()[i].queue_free()
#			Player.grab_item()
			_temp_inventory.clear()
			print("You grabbed it all")
		else:
			Global.picked_up = false
			for i in i_slots.size():
				if i_slots[i].item == null:
					pass
				else:
					i_slots[i].remove_from_slot()
			_temp_inventory = Global.deep_copy(loot_inventory)
			loot_inventory.clear()
			# Disable and enable Player's $PickupZone in order to fetch items
			# on the ground when opening the inventory again
			Player.reset_pickup_zone()
			print_stray_nodes()
			
#			print(loot_inventory.keys())
#			print(loot_inventory.values())
	#				add_child(item_object)
	#				item_object.position = Player.position
	else:
		print("You haven't touched anything")
	_temp_inventory.clear()
	Player.reset_pickup_zone()
