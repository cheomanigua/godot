## THIS SCRIPT IS USED TO PICK UP ITEMS FROM THE ENVIRONMENT
## AND ADD THEM TO THE LOGICAL INVENTORY (CONTROLLER)

extends Node

const SlotClass = preload("res://scripts/ui/slot.gd")
const ItemClass = preload("res://scripts/ui/item.gd")
const NUM_INVENTORY_SLOTS = 20
const NUM_LOOT_INVENTORY_SLOTS = 4
const NUM_USAGE_INVENTORY_SLOTS = 1
const NUM_TEMP_INVENTORY_SLOTS = 4

var inventory:Dictionary
var loot_inventory:Dictionary
var usage_inventory:Dictionary
var temp_inventory:Dictionary


#func add_item(item_name, item_quantity):
#	for item in inventory:
#		if inventory[item][0] == item_name:
#			var stack_size = int(Data.item_data[item_name]["stack_size"])
#			var able_to_add = stack_size - inventory[item][1]
#			if able_to_add >= item_quantity:
#				inventory[item][1] += item_quantity
#				return
#			else:
#				inventory[item][1] += able_to_add
#				item_quantity = item_quantity - able_to_add
#	# item doesn't exist in inventory yet, so add it to an empty slot
#	for i in range(NUM_INVENTORY_SLOTS):
#		if inventory.has(i) == false:
#			inventory[i] = [item_name, item_quantity]
#			return


func _ready():
	add_item("Gold", 10)
	add_item("Gem8", 2)
#	add_item("Gem9", 5)


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
	loot_inventory.erase(slot.loot_slot_index)

func loot_add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	loot_inventory[slot.loot_slot_index] = [item.item_name, item.item_quantity]
	

func loot_add_item_quantity(slot: SlotClass, quantity_to_add: int):
	loot_inventory[slot.loot_slot_index][1] += quantity_to_add
	for i in range(NUM_LOOT_INVENTORY_SLOTS):
		if loot_inventory.has(i) == true:
			return


######## USAGE #########

func usage_add_item(item_name, item_quantity):
	for item in usage_inventory:
		if usage_inventory[item][0] == item_name:
			var stack_size = int(Data.item_data[item_name]["stack_size"])
			var able_to_add = stack_size - usage_inventory[item][1]
			if able_to_add >= item_quantity:
				usage_inventory[item][1] += item_quantity
				return
			else:
				usage_inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
	# item doesn't exist in usage_inventory yet, so add it to an empty slot
	for i in range(NUM_USAGE_INVENTORY_SLOTS):
		if usage_inventory.has(i) == false:
			usage_inventory[i] = [item_name, item_quantity]
			return


func usage_remove_item(slot: SlotClass):
# warning-ignore:return_value_discarded
	usage_inventory.erase(slot.usage_slot_index)

func usage_add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	usage_inventory[slot.usage_slot_index] = [item.item_name, item.item_quantity]

func usage_add_item_quantity(slot: SlotClass, quantity_to_add: int):
	usage_inventory[slot.usage_slot_index][1] += quantity_to_add


######## TEMP #########

func temp_add_item(item_name, item_quantity):
	for item in temp_inventory:
		if temp_inventory[item][0] == item_name:
			var stack_size = int(Data.item_data[item_name]["stack_size"])
			var able_to_add = stack_size - temp_inventory[item][1]
			if able_to_add >= item_quantity:
				temp_inventory[item][1] += item_quantity
				return
			else:
				temp_inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
	# item doesn't exist in temp_inventory yet, so add it to an empty slot
	for i in range(NUM_TEMP_INVENTORY_SLOTS):
		if temp_inventory.has(i) == false:
			temp_inventory[i] = [item_name, item_quantity]
			return
