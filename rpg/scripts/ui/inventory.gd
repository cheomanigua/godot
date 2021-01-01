extends Node2D

const SlotClass = preload("res://scripts/ui/slot.gd")

onready var loot_slots = $GridContainerLoot
onready var inventory_slots = $GridContainer
var holding_item = null

func _ready():
	var i_slots = inventory_slots.get_children()
	var l_slots = loot_slots.get_children()
	
	for i in range(i_slots.size()):
		i_slots[i].connect("gui_input", self, "slot_gui_input", [i_slots[i]])
		i_slots[i].slot_index = i

	for i in range(l_slots.size()):
		l_slots[i].connect("gui_input", self, "loot_slot_gui_input", [l_slots[i]])
		l_slots[i].loot_slot_index = i
	
	
	initialize_inventory()
	
#	for e in range(l_slots.size()):
#		l_slots[e].connect("gui_input", self, "loot_slot_gui_input", [l_slots[e]])
#		l_slots[e].loot_slot_index = e
#	initialize_inventory()

func initialize_inventory():
	var i_slots = inventory_slots.get_children()
	var l_slots = loot_slots.get_children()
	
	for i in range(i_slots.size()):
		if PlayerInventory.inventory.has(i):
			i_slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
	
	for i in range(l_slots.size()):
		if PlayerInventory.loot_inventory.has(i):
			l_slots[i].initialize_item(PlayerInventory.loot_inventory[i][0], PlayerInventory.loot_inventory[i][1])

func check():
	if PlayerInventory.loot_inventory.size() == 0:
		print("Loot:")
		print("No items yet on Loot")
	else:
		print("")
		print("Loot:")
		for key in PlayerInventory.loot_inventory:
			print("%s: %s" % [PlayerInventory.loot_inventory[key][0],PlayerInventory.loot_inventory[key][1]])
	if PlayerInventory.inventory.size() == 0:
		print("Inventory:")
		print("No items yet on Inventory")
	else:
		print("")
		print("Inventory:")
		for key in PlayerInventory.inventory:
			print("%s: %s" % [PlayerInventory.inventory[key][0],PlayerInventory.inventory[key][1]])
############### INVENTORY CODE STARTS #################

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		# Clicking left mouse button while...
		if event.button_index == BUTTON_LEFT && event.pressed:
			# ... holding an item
			if holding_item != null:
				# ... holding an item against an empty slot
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					# ... holding an item against a slot containing a different item
					if holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					# .. holding an item againts a slot containing an equal item
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)
			check()

func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(Data.item_data[slot.item.item_name]["stack_size"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()

############### INVENTORY CODE ENDS #################

############### LOOT CODE STARTS #################

func loot_slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		# Clicking left mouse button while...
		if event.button_index == BUTTON_LEFT && event.pressed:
			# ... holding an item
			if holding_item != null:
				# ... holding an item against an empty slot
				if !slot.item:
					loot_left_click_empty_slot(slot)
				else:
					# ... holding an item against a slot containing a different item
					if holding_item.item_name != slot.item.item_name:
						loot_left_click_different_item(event, slot)
					# .. holding an item againts a slot containing an equal item
					else:
						loot_left_click_same_item(slot)
			# ... not holding an item
			elif slot.item:
				loot_left_click_not_holding(slot)
			check()

func loot_left_click_empty_slot(slot: SlotClass):
	PlayerInventory.loot_add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null

func loot_left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.loot_remove_item(slot)
	PlayerInventory.loot_add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item

func loot_left_click_same_item(slot: SlotClass):
	var stack_size = int(Data.item_data[slot.item.item_name]["stack_size"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		PlayerInventory.loot_add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
	else:
		PlayerInventory.loot_add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)

func loot_left_click_not_holding(slot: SlotClass):
	PlayerInventory.loot_remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()

############### LOOT CODE ENDS #################
