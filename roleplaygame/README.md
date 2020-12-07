# RPG Godot project 

## Combat system

Combat is separated in two stages:
1. Attack: check if attack is successful. Modifiers are:
  - \+ Attacker dexterity
  - \- Target dexterity


2. Damage

## Items

- Items are **Area2D** scenes with the following children nodes: **Sprite** and **CollisionShape2D**
- Items functionality is implemented by script **item.gd** 
- The fundamental feature of an item is that it can be picked up by the player. When picked up, the item is added to a dictionary called `inventory`
- Items have two custom properties:
  1. **Textures**: Used in the editor in an instanciated item for adding a texture to the **Sprite** node.
  2. **Tag**: Used to identify unique items. This String field should be filled with the name of the unique item.


Items are divided into two categories:

1. Common items:
  - They are instanciated from a parent Scene. For instance: Potion.tscn, Coin.tscn
  - They can have more that one instance at the same time in the game.
  - An empty `Node` is created manually in the Scene tree of the editor as parent in order to group all the instances. Give a name to `Node`, like **Potion**. This name is used for the `pickup()` funcion to pass as reference.

2. Unique items:
  - They should have only one instance in the game.
  - They are instanciated from the parent scene "Item.tscn".
  - An empty `Node` is created manually in the Scene tree of the editor as parent in order to group all item instances. The name given to the `Node` is **Unique**
  - Their uniqueness comes from a tag that can be added in the editor. This tag name is used for the `pickup()` function to pass as reference.

### Pickup()
- If a tag is added (unique items), the `pickup(tag)` function will be used to add the item to the inventory dictionary.
- If no tag is added (common items), the `pickup(get_parent().get_name())` function will be used to add the item to the inventory dictionary.

```
func _ready():
	if tag:
		pickup(tag)
	else:
		pickup(get_parent().get_name())

func pickup(item):
# warning-ignore:return_value_discarded
	connect("body_entered",self,"_on_body_entered",[item])

func _on_body_entered(body,item):
	if body.get_name() == "Player":
		Player.add_item(item)
		queue_free()
```

### Advantages of this method

- You can easily automate common items instantiation
- You don't need to add a tag name to each instance, since it is referenced by `get_parent().get_name()`

### Disadvantages of this method

You must add the tag name manually in the editor


## Doors

- Doors are represented with a **StaticBody2D** node.
- Doors functionality is implemented by script **door.gd**
- Doors have a custom property:
  - **key**: This string field will be filled if a unique item (a key) is needed in order to open the door. If key field is not filled, player can open the door without a key.

```
extends StaticBody2D
export (String) var key

func _ready():
# warning-ignore:return_value_discarded
	$Area2D.connect("body_entered",self,"_on_Door_body_entered")
# warning-ignore:return_value_discarded
	$Area2D.connect("body_exited",self,"_on_Door_body_exited")

func _on_Door_body_entered(body):
	if body.get_name() == "Player":
		if key:
			if Player.inventory.has(key):
				$CollisionShape2D.set_deferred("disabled", true)
				get_node(".").hide()
			else:
				print("You need a key")
		else:
			$CollisionShape2D.set_deferred("disabled", true)
			get_node(".").hide()

func _on_Door_body_exited(body):
	if body.get_name() == "Player":
		$CollisionShape2D.set_deferred("disabled", false)
		get_node(".").show()
```


