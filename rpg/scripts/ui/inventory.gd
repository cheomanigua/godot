## SCRIPT USED TO ADD, REMOVE, SWAP AND MERGE ITEMS IN THE SLOTS
## OF THE GRAPHICAL INVENTORY (VIEW)

extends Node2D

const SlotClass = preload("res://scripts/ui/slot.gd")
const ItemObject = preload("res://scenes/item_object.tscn")

onready var loot_slots = $GridContainerLoot
onready var usage_slots = $GridContainerUsage
onready var inventory_slots = $GridContainer
var holding_item = null

func _ready():
# warning-ignore:return_value_discarded
	GlobalWorld.connect("show_item_info",self,"_on_show_item_info")
# warning-ignore:return_value_discarded
	GlobalWorld.connect("hide_item_info",self,"_on_hide_item_info")
	var i_slots = inventory_slots.get_children()
	var l_slots = loot_slots.get_children()
	var u_slots = usage_slots.get_children()
	
	# Iterate through all the slots to connect any gui input such as
	# mouse movements or clicks to the function "slot_gui_input"
	for i in range(i_slots.size()):
		i_slots[i].connect("gui_input", self, "slot_gui_input", [i_slots[i]])
		i_slots[i].slot_index = i

	for i in range(l_slots.size()):
		l_slots[i].connect("gui_input", self, "loot_slot_gui_input", [l_slots[i]])
		l_slots[i].loot_slot_index = i
	
	for i in range(u_slots.size()):
		u_slots[i].connect("gui_input", self, "usage_slot_gui_input", [u_slots[i]])
		u_slots[i].usage_slot_index = i

	initialize_inventory()


func initialize_inventory():
	var i_slots = inventory_slots.get_children()
	var l_slots = loot_slots.get_children()
	var u_slots = usage_slots.get_children()
	
	for i in range(i_slots.size()):
		if InventoryController.inventory.has(i):
			i_slots[i].initialize_item(InventoryController.inventory[i][0], InventoryController.inventory[i][1], InventoryController.inventory[i][2])
	
	for i in range(l_slots.size()):
		if InventoryController.loot_inventory.has(i):
			l_slots[i].initialize_item(InventoryController.loot_inventory[i][0], InventoryController.loot_inventory[i][1], InventoryController.loot_inventory[i][2])
	
	for i in range(u_slots.size()):
		if InventoryController.usage_inventory.has(i):
			u_slots[i].initialize_item(InventoryController.usage_inventory[i][0], InventoryController.usage_inventory[i][1], InventoryController.usage_inventory[i][2])


func _input(_event):
	# Update the holding item's global position to be where the mouse cursor is
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func canEquip(item, slot):
	var item_slot_type = Data.item_data[item.item_name]["slot_type"]
	var slot_type = Global.SlotType.keys()[slot.slotType]
	return item_slot_type == slot_type


############### INVENTORY CODE STARTS HERE #################

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


func left_click_empty_slot(slot: SlotClass):
	InventoryController.add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null


# Swaping logic
func left_click_different_item(event: InputEvent, slot: SlotClass):
	InventoryController.remove_item(slot)
	InventoryController.add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item


# Merging logic
func left_click_same_item(slot: SlotClass):
	var stack_size = int(Data.item_data[slot.item.item_name]["stack_size"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		InventoryController.add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
	else:
		InventoryController.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)


func left_click_not_holding(slot: SlotClass):
	InventoryController.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()

############### INVENTORY CODE ENDS #################



############### LOOT CODE STARTS HERE #################

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


func loot_left_click_empty_slot(slot: SlotClass):
	InventoryController.loot_add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	GlobalWorld.emit_signal("item_dropped", holding_item)
	holding_item = null


func loot_left_click_different_item(event: InputEvent, slot: SlotClass):
	InventoryController.loot_remove_item(slot)
	InventoryController.loot_add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	GlobalWorld.emit_signal("item_dropped", holding_item)
	holding_item = temp_item
	GlobalWorld.emit_signal("item_picked", holding_item)


func loot_left_click_same_item(slot: SlotClass):
	var stack_size = int(Data.item_data[slot.item.item_name]["stack_size"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		InventoryController.loot_add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		GlobalWorld.emit_signal("item_dropped", holding_item)
		holding_item.queue_free()
		holding_item = null
	else:
		InventoryController.loot_add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)
		GlobalWorld.emit_signal("item_dropped", holding_item)


func loot_left_click_not_holding(slot: SlotClass):
	InventoryController.loot_remove_item(slot)
	holding_item = slot.item
	GlobalWorld.emit_signal("item_picked", slot.item)
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()


func loot_remove_item_from_slot(slot: SlotClass):
	slot.pickFromSlot()

############### LOOT CODE ENDS #################



############### USAGE CODE STARTS HERE #################

func usage_slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		# Clicking left mouse button while...
		if event.button_index == BUTTON_LEFT && event.pressed:
			# ... holding an item
			if holding_item != null:
				if canEquip(holding_item, slot):
					# ... holding an item against an empty slot
					if !slot.item:
						usage_left_click_empty_slot(slot)
					else:
						# ... holding an item against a slot containing a different item
						if holding_item.item_name != slot.item.item_name:
							usage_left_click_different_item(event, slot)
						# .. holding an item againts a slot containing an equal item
						else:
							usage_left_click_same_item(slot)
			# ... not holding an item
			elif slot.item:
				usage_left_click_not_holding(slot)


func usage_left_click_empty_slot(slot: SlotClass):
	InventoryController.usage_add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	GlobalWorld.emit_signal("equipment_added", slot, holding_item)
	holding_item = null


func usage_left_click_different_item(event: InputEvent, slot: SlotClass):
	InventoryController.usage_remove_item(slot)
	InventoryController.usage_add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	GlobalWorld.emit_signal("equipment_added", slot)
	holding_item = temp_item
	GlobalWorld.emit_signal("equipment_removed", holding_item)


func usage_left_click_same_item(slot: SlotClass):
	var stack_size = int(Data.item_data[slot.item.item_name]["stack_size"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		InventoryController.usage_add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		GlobalWorld.emit_signal("equipment_added", slot)
		holding_item.queue_free()
		holding_item = null
	else:
		InventoryController.usage_add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)
		GlobalWorld.emit_signal("equipment_removed", holding_item)


func usage_left_click_not_holding(slot: SlotClass):
	InventoryController.usage_remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()
	GlobalWorld.emit_signal("equipment_removed", holding_item)

############### USAGE CODE ENDS #################


func _on_show_item_info(item_name, item_uniqueness):
	var value = Data.item_data[item_name]["item_value"]
	
	if item_uniqueness.size() < 1:
		$Label.text = "%s\n%d" % [item_name,value]
	elif item_uniqueness.size() == 1:
		var id = item_uniqueness[0]
		$Label.text = "%s\n%d\n\"%s\"" % [item_name,value,id]
	if item_uniqueness.size() == 3:
		var id = item_uniqueness[0]
		var skill = item_uniqueness[1].capitalize()
		var skill_value = item_uniqueness[2]
		$Label.text = "%s\n%d\n\"%s\"\n%s: +%d" % [item_name,value,id, skill, skill_value]
	elif item_uniqueness.size() == 5:
		var id = item_uniqueness[0]
		var skill = item_uniqueness[1].capitalize()
		var skill_value = item_uniqueness[2]
		var skill2 = item_uniqueness[3].capitalize()
		var skill2_value = item_uniqueness[4]
		$Label.text = "%s\n%d\n\"%s\"\n%s: +%d\n%s: +%d" % [item_name,value, id, skill, skill_value, skill2, skill2_value]

	var strength = Data.item_data[item_name]["strength_bonus"]
	var intelligence = Data.item_data[item_name]["intelligence_bonus"]
	var dexterity = Data.item_data[item_name]["dexterity_bonus"]
	var endurance = Data.item_data[item_name]["endurance_bonus"]
	var health = Data.item_data[item_name]["health_bonus"]
	var attack = Data.item_data[item_name]["attack_bonus"]
	var defense = Data.item_data[item_name]["defense_bonus"]
	var plus : String
	
	if strength != null:
		if strength > 0:
			plus = "+"
		$Label.text += "\nStrength %s%d" % [plus, strength]
		plus = ""
	if intelligence != null:
		if intelligence > 0:
			plus = "+"
		$Label.text += "\nIntelligence %s%d" % [plus, intelligence]
		plus = ""
	if dexterity != null:
		if dexterity > 0:
			plus = "+"
		$Label.text += "\nDexterity %s%d" % [plus, dexterity]
		plus = ""
	if endurance != null:
		if endurance > 0:
			plus = "+"
		$Label.text += "\nEndurance %s%d" % [plus, endurance]
		plus = ""
	if health != null:
		if health > 0:
			plus = "+"
		$Label.text += "\nHealth %s%d" % [plus, health]
		plus = ""
	if attack != null:
		if attack > 0:
			plus = "+"
		$Label.text += "\nAttack %s%d" % [plus, attack]
		plus = ""
	if defense != null:
		if defense > 0:
			plus = "+"
		$Label.text += "\nDefense %s%d" % [plus, defense]
		plus = ""


func _on_hide_item_info():
	$Label.text = ""
