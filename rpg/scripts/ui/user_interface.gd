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
	var loot_inventory = PlayerInventory.loot_inventory
	var _temp_inventory = PlayerInventory.temp_inventory
	
	if Global.picked_up:
		print("Has tocado cosas")
		if loot_inventory.empty():
#			Player.grab_item()
#			PlayerInventory.temp_inventory.clear()	
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
			Player.reset_pickup_zone()
			
			
			
#			print(loot_inventory.keys())
#			print(loot_inventory.values())
	#				add_child(item_drop)
	#				item_drop.position = Player.position
	else:
		print("You haven't touched anything")

