extends Control

const SlotClass = preload("res://Test/slot.gd")
onready var inventory_slots = $GridContainer
var holding_item = null

func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input",self,"slot_gui_input", [inv_slot])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event.is_action_pressed("mouse_left_button"):
		# Currently holding an Item
		if holding_item != null:
			# Empty slot
			if !slot.item:
				slot.putIntoSlot(holding_item)
				holding_item = null
			# Slot already contains an item
			else:
				# Different item, so no swap
				if holding_item.item_key != slot.item.item_key:
					var temp_item = slot.item
					slot.pickFromSlot()
					temp_item.global_position = event.global_position
					slot.putIntoSlot(holding_item)
					holding_item = temp_item
				# Same item, so try to merge
				else:
					var stack_size = int(Data.item_data[slot.item.item_key]["stack_size"])
					var able_to_add = stack_size - slot.item.item_quantity
					if able_to_add >= holding_item.item_quantity:
						slot.item.add_item_quantity(holding_item.item_quantity)
						holding_item.queue_free()
						holding_item = null
					else:
						slot.item.add_item_quantity(able_to_add)
						holding_item.decrease_item_quantity(able_to_add)
		elif slot.item:
			holding_item = slot.item
			slot.pickFromSlot()
			holding_item.global_position = get_global_mouse_position()

func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

#	$Label.text = "No items"
## warning-ignore:return_value_discarded
#	Player.connect("inventory_updated",self,"_on_inventory_updated")
#
#
#func _on_inventory_updated():
#	$Label.text =""
#	for key in Player.inventory:
#		$Label.text += "%s : %d" % [key, Player.inventory[key]]
#		if (key != Player.inventory.keys().back()):
#				$Label.text += "\n"




