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
- Items have three custom properties that can be edited in the instanciated nodes:
  1. **Textures**: Used in the editor in an instanciated item for adding a texture to the **Sprite** node.
  2. **Item Name**: Used to identify the item both in the inventory and when interacting with the environment.
  3. **Amount**: Used to quantify the number of items on an item instance.
- Items are instanciated from the parent scene "Item.tscn"
- It is recommended to create an empty parent Node for instances that share the same **Item name**. For instance, create an empty Node and name it **Gems**. From **Gems** you can instanciate items that are going to use *Gem* as **Item Name**.

### Pickup()
- `pickup(item_name)` function will be used to add the item to the inventory dictionary.
- If no **Item Name** is added, there will be an alert in the main editor window and an error message in Godot’s built-in debugger.
- **Item amount** will be used to increment the inventory of such item.

```
func _ready():
    if item_name:
        pickup(item_name)
    else:
        push_error("You must add a name into item_name for node %s" % get_name())
        Gui.error("You must fill out item_name\nfor node %s/%s" % [get_parent().name, get_name()])

func _on_body_entered(body,item):
    if body.get_name() == "Player":
        Player.add_item(item,amount)
        if amount > 1:
            Gui.message("%d %ss picked up" % [amount,item])
        else:
            Gui.message("%d %s picked up" % [amount,item])
            queue_free()
        queue_free()
```

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


