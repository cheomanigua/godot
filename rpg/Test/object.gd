extends Node2D

#const itemImages = [
#	"res://Images/Items/Money/gold1.png",
#	"res://Images/Items/Money/gold2.png",
#	"res://Images/Items/Money/gold3.png",
#	"res://Images/Items/Money/silver1.png",
#	"res://Images/Items/Money/silver2.png",
#	"res://Images/Items/Money/silver3.png",
#	"res://Images/Items/Money/gem1.png",
#	"res://Images/Items/Money/gem2.png",
#	"res://Images/Items/Money/gem3.png",
#	"res://Images/Items/Money/gem4.png",
#	"res://Images/Items/Money/gem5.png",
#	"res://Images/Items/Money/gem6.png",
#	"res://Images/Items/Money/gem7.png",
#	"res://Images/Items/Money/gem8.png",
#	"res://Images/Items/Money/gem9.png",
#	"res://Images/Items/Money/gem10.png",
#];
#
#const itemDictionary = {
#	0: {
#		"item_name": "Gold1",
#		"item_value": 456,
#		"item_icon": itemImages[0],
#		"stack_size": 99
#	},
#	1: {
#		"item_name": "Gold2",
#		"item_value": 456,
#		"item_icon": itemImages[1],
#		"stack_size": 99
#	},
#	2: {
#		"item_name": "Gold3",
#		"item_value": 456,
#		"item_icon": itemImages[1],
#		"stack_size": 99
#	},
#	3: {
#		"item_name": "Silver1",
#		"item_value": 456,
#		"item_icon": itemImages[1],
#		"stack_size": 1
#	},
#	4: {
#		"item_name": "Silver2",
#		"item_value": 456,
#		"item_icon": itemImages[1],
#		"stack_size": 1
#	},
#	5: {
#		"item_name": "Silver3",
#		"item_value": 456,
#		"item_icon": itemImages[1],
#		"stack_size": 1
#	},
#	6: {
#		"item_name": "Gem1",
#		"item_value": 456,
#		"item_icon": itemImages[6],
#		"stack_size": 10
#	},
#	7: {
#		"item_name": "Gem2",
#		"item_value": 456,
#		"item_icon": itemImages[7],
#		"stack_size": 10
#	},
#	8: {
#		"item_name": "Gem3",
#		"item_value": 456,
#		"item_icon": itemImages[8],
#		"stack_size": 10
#	},
#	9: {
#		"item_name": "Gem4",
#		"item_value": 456,
#		"item_icon": itemImages[9],
#		"stack_size": 10
#	},
#	10: {
#		"item_name": "Gem5",
#		"item_value": 456,
#		"item_icon": itemImages[10],
#		"stack_size": 10
#	},
#	11: {
#		"item_name": "Gem6",
#		"item_value": 456,
#		"item_icon": itemImages[11],
#		"stack_size": 10
#	},
#	12: {
#		"item_name": "Gem7",
#		"item_value": 456,
#		"item_icon": itemImages[12],
#		"stack_size": 10
#	},
#	13: {
#		"item_name": "Gem8",
#		"item_value": 456,
#		"item_icon": itemImages[13],
#		"stack_size": 10
#	},
#	14: {
#		"item_name": "Gem9",
#		"item_value": 456,
#		"item_icon": itemImages[14],
#		"stack_size": 10
#	},
#	15: {
#		"item_name": "Gem10",
#		"item_value": 456,
#		"item_icon": itemImages[15],
#		"stack_size": 10
#	},
#}


var item_quantity
var item_key

func _ready():
	randomize()
	var rand = randi() % 15
	$TextureRect.texture = load("%s" % Data.item_data[str(rand)]["item_image"])
	var stack_size = int(Data.item_data[str(rand)]["stack_size"])
	item_quantity = randi() % stack_size + 1
	item_key = str(rand)
	
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = String(item_quantity)

#	$Sprite.texture = load("res://Images/Items/Money.png")
#	$Sprite.set_vframes(8)
#	$Sprite.set_hframes(8)
#	$Sprite.set_frame(randi() % 29)

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)

func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
