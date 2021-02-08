extends KinematicBody2D
export (String, "Gold","Silver","Quartz","Zaphyr","Ruby","Garnet","Azurite",
	"Obsidian","Emerald","Turquoise","Aquamarine","Topaz",
	"Leather Jacked","Karuta","Segmentata","Chain Mail","Iron Curiass","Bronze Curiass",
	"Round Shield","Buckler Shield","Heater Shield","Kite Shield","Pavise Shield",
	"Strength Potion","Intelligence Potion","Dexterity Potion","Endurance Potion","Healing Potion","Magicka Potion",
	"Club","Pike","Mace","Flail","Dagger","Sword","Axe","Double Axe","Hammer","Halberd") \
	var item_name = "Gold"
export (int) var item_quantity = 1
export (Array) var item_uniqueness

func initialize(name: String, quantity: int):
	item_name = name
	item_quantity = quantity


func _ready():
	add_to_group("items")
	$Sprite.texture = load(GlobalWorld.ITEMS_IMAGE_PATH + Data.item_data[item_name]["item_image"])
# warning-ignore:return_value_discarded
	GlobalWorld.connect("item_picked",self,"_on_item_picked")


func fetch_item(mode):
	if is_in_group("items"):
		if mode == "shown":
			InventoryController.loot_add_item(item_name, item_quantity, item_uniqueness)
		elif mode == "direct":
			InventoryController.add_item(item_name, item_quantity, item_uniqueness)
			queue_free()
			

func _on_item_picked(item):
	if is_in_group("items"):
		for i in Player.get_node("PickupZone").get_overlapping_bodies():
			if item.item_name == i.item_name:
				i.queue_free()

