extends Node2D

var item_name
var item_quantity

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load(GlobalWorld.ITEMS_IMAGE_PATH + Data.item_data[item_name]["item_image"])
	
	var stack_size = int(Data.item_data[item_name]["stack_size"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)


# used to increase stack items quantity
func add_item_quantity(quantity_to_add):
	item_quantity += quantity_to_add
	$Label.text = String(item_quantity)


# used to reduce stack items quantity
func decrease_item_quantity(quantity_to_remove):
	item_quantity -= quantity_to_remove
	$Label.text = String(item_quantity)
	
