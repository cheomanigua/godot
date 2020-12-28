extends Node

const SlotClass = preload("res://scripts/ui/slot.gd")
const ItemClass = preload("res://scripts/logic/item.gd")
const NUM_INVENTORY_SLOTS = 20

func add_item(item_name, item_quantity):
	for item in Player.inventory:
		if Player.inventory[item][0] == item_name:
			var stack_size = int(Data.item_data[item_name]["stack_size"])
			var able_to_add = stack_size - Player.inventory[item][1]
			if able_to_add >= item_quantity:
				Player.inventory[item][1] += item_quantity
				return
			else:
				Player.inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
	# item doesn't exist in Player.inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if Player.inventory.has(i) == false:
			Player.inventory[i] = [item_name, item_quantity]
			return


func remove_item(slot: SlotClass):
	Player.inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	Player.inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	Player.inventory[slot.slot_index][1] += quantity_to_add
