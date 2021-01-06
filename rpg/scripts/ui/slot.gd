extends Panel

var default_tex = preload("res://images/ui/item_slot_default_background.png")
var empty_tex = preload("res://images/ui/item_slot_empty_background.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://scenes/ui/item.tscn")
var item = null
var slot_index
var loot_slot_index
var usage_slot_index

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
	refresh_style()
		
func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)


func remove_from_slot():
	remove_child(item)
	item.free()
	item = null
	refresh_style()

func pickFromSlot():
	# Remove item from the Slot node
	remove_child(item)
	# Add item to the Inventory node so we can move the item around
	# the inventory using the mouse cursor
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
func putIntoSlot(new_item):
	item = new_item
	# Put item in the center of the slot
	item.position = Vector2(0, 0)
	# Remove item from the Inventory node
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	## Add item to be a child of the Slot
	add_child(item)
	refresh_style()
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()

