extends Node

const SlotClass = preload("res://scripts/ui/slot.gd")
const ItemClass = preload("res://scripts/logic/item.gd")
const NUM_INVENTORY_SLOTS = 20
const NUM_LOOT_INVENTORY_SLOTS = 4
var inventory:Dictionary
var loot_inventory:Dictionary

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(Data.item_data[item_name]["stack_size"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				return
			else:
				inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return


func remove_item(slot: SlotClass):
# warning-ignore:return_value_discarded
	inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	inventory[slot.slot_index][1] += quantity_to_add

######## LOOT #########

func loot_add_item(item_name, item_quantity):
	for item in loot_inventory:
		if loot_inventory[item][0] == item_name:
			var stack_size = int(Data.item_data[item_name]["stack_size"])
			var able_to_add = stack_size - loot_inventory[item][1]
			if able_to_add >= item_quantity:
				loot_inventory[item][1] += item_quantity
				return
			else:
				loot_inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
	# item doesn't exist in loot_inventory yet, so add it to an empty slot
	for i in range(NUM_LOOT_INVENTORY_SLOTS):
		if loot_inventory.has(i) == false:
			loot_inventory[i] = [item_name, item_quantity]
			return


func loot_remove_item(slot: SlotClass):
# warning-ignore:return_value_discarded
	loot_inventory.erase(slot.slot_index)

func loot_add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	loot_inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func loot_add_item_quantity(slot: SlotClass, quantity_to_add: int):
	loot_inventory[slot.slot_index][1] += quantity_to_add
