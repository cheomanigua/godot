# RPG Godot project 

## Items

- Items is a **Item.tscn** scene with a **Area2D** parent node and the following children nodes: **Sprite** and **CollisionShape2D**
- No texture file must be added in the **Item.tscn**'s sprite node. Only add texture file in instanciated items sprite nodes. 
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

## Creatures

- Creatures is a **Creature.tscn** scene with a **KinematicBody2D** parent node and the following children nodes: **Sprite**, **CollisionShape2D** and **Area2D** called *HitBox* with a child node of type **CollisionShape2D**
- No texture file must be added in the **Creature.tscn**'s sprite node. Only add texture file in instanciated creatures sprite nodes. 
- Creatures functionality is implemented by script **Creature.gd**
- Creatures has a property called **Creature type** that can be selected from a drop down menu in the Inspector Panel. By default, the **Creature Type** is *Orc*
- Creatures have five skill's properties: *Strength, Intelligence, Dexterity, Endurance* and *Health*
- *Health* property is the sum of *Strength* and *Endurance*
- Skill's property are parsed to a dictionary variable from a JSON file,
- The file is located at [https://drive.google.com/file/d/14wp-Bb6rZby27-2HRgM0o01dv5klm_hL/view](https://drive.google.com/file/d/14wp-Bb6rZby27-2HRgM0o01dv5klm_hL/view)

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


## Combat system

### Actual combat system
- When Player enters the creature's Zone2D collision shape, his chance to hit the creature is the percentage of Player's **Dexterity** skill. For instance: if Player's **Dexterity** skill is 4, there is a 40% chances to hit the creature.
- When Player hits the creature, the damage provoked is a random generated number between 1 and Player's **Strength** skill.

### Desired combat system
Combat is separated in two stages:
1. Attack: check if attack is successful. Modifiers are:
  - \+ Attacker dexterity
  - \- Target dexterity


2. Damage
