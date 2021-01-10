# RPG Godot project 

## Player
- Player is a **Player.tscn** scene with a **KinematicBody2D** parent node and the following children nodes: **Sprite**, **Sprite2**, **AnimationPlayer**, **AnimationPlayer2**, **CollisionShape2D** and **Camera2D**
- **Sprite** is a sprite sheet used for **AnimationPlayer**
- **Sprite2** is a sprite sheet used for **AnimationPlayer2**
- In order to swap between Animations, edit funcion `anim_switch()` in script **character.gd** and hide the other sprite node.

## Items

Items are divided in three categories:
1. **items.json**: Used as the data model
2. **item_object.tscn**/**item_object.gd**: Used for managing items in the environment
3. **item.tscn**/**item.gd**: Used for managing items in the inventory

**item_object.tscn** scene is composed of a **KinematicBody2D** as parent node and the following children nodes: **Sprite**, **Area2D** and **CollisionShape2D**
- No texture file must be added in the **Sprite** node. Only add a texture file in the instanciated *item_object*'s sprite node. 
- Items functionality is implemented by script **item.gd** 
- The fundamental feature of an item is that it can be picked up and dropped by the player. When picked up, the item is added to a dictionary called `inventory`
- Items have three custom properties that can be edited in the instanciated nodes:
  1. **Texture**: Used in the editor in an instanciated item for adding a texture to the **Sprite** node. Sprite sheets may be used as texture also, so you need to set the values of Animation's *VFrames*, *HFrames* and *Frame*
  2. **Item Name**: Used to identify the item both in the inventory and when interacting with the environment.
  3. **Amount**: Used to quantify the number of items on an item instance.
- If no **Item Name** is added, there will be an alert in the main editor window and an error message in Godot’s built-in debugger.
- Items are instanciated from the parent scene "Item.tscn"
- It is recommended to create an empty parent Node for instances that share the same **Item name**. For instance, create an empty Node and name it **Gems**. From **Gems** you can instanciate items that are going to use *Gem* as **Item Name**.

### Pickup()

- `pickup_item()` function in **player.gd** will be used to add the item to the inventory dictionary in **inventory_controller.gd**.
- **pickup_zone.gd** is used to pickup items only in the zone of influence of the player.
- If no *Item Name* is added in an instance of **item_object.tscn**, there will be an alert in the main editor window and an error message in Godot’s built-in debugger.
- *Item amount* will contain the number of units of a given **item_object.tscn** instance.


## Inventory

Inventory are divided in three elements:
1. **inventory.tscn**/**inventory.gd**/**slot.gd**: Used as view, is the user interface for the inventory system.
2. **inventory_controller.gd**: Used as a controller to store the players item in a dictionary.
3. **items.json**: Used as model, it's a json file containing all the data model for the items

## Creatures

- Creatures is a **Creature.tscn** scene with a **KinematicBody2D** parent node and
the following children nodes: **Sprite**, **CollisionShape2D**, **Area2D** and **AnimationPlayer**
- The **Area2D** is called *HitBox* and has child node of type **CollisionShape2D**
used to detect when Player is attacking and initiate the combat process.
- The **AnimationPlayer** has a basic *flip_h* key animation.
- Creatures functionality is implemented by script **creature.gd**
- Creatures has a property called **Creature type** that can be selected from a drop down menu in the Inspector Panel. By default, the **Creature Type** is *Orc*. This property is very important because it is used to automatically initialize the creature's instance texture and skills from a JSON file.
- A placeholder texture file is added in the **Creature.tscn**'s sprite node. When instantiated, creatures get their texture from a JSON file where the *sprite sheet* resource path, *VFrames*, *HFrames* and *Frame* properties are fetched.
- Creatures have five skill's properties: *Strength, Intelligence, Dexterity, Endurance* and *Health*
- *Health* property is the sum of *Strength* and *Endurance*
- Skill's property are parsed to a dictionary variable from a JSON file.
- The file is located at [https://drive.google.com/file/d/1Fq4q-3b1RMubc4cYm9QwMyzznOpFjcK5/view](https://drive.google.com/file/d/1Fq4q-3b1RMubc4cYm9QwMyzznOpFjcK5/view)

## Doors

- Doors are represented with a **StaticBody2D** node.
- Doors functionality is implemented by script **door.gd**
- Doors have a custom property:
- **key**: This string field will be filled if a unique item (a key) is needed in order to open the door. If key field is not filled, player can open the door without a key.


## UI
- UI is a **UI.tscn** scene with a **CanvasLayer** parent node with two **Control** children nodes. 
- The two **Control** children nodes are separate instances of **Inventory.tscn** and **Stats.tscn**
- **Inventory.tscn** and **Stats.tscn** have both a **Label** node as children
- The Inventory and Stats are toggled by pressing "I" and "C".


## Notifications
- Notifications is a **Notification.tscn** scene with a **Control** child node.
- The **Control** child node has two children nodes: a **Label** named *bottom_message* and a **Panel** named *Error_panel*.
- The *Error_panel* **Label** has a **Label** child node called *Error_label*
- The *bottom_message* shows general messages during the game
- The *Error_label* shows an error when we don't fill the *item_name* property if an **Item.tscn** instance.



## Combat system

### Actual combat system
- When Player enters the creature's Zone2D collision shape, his chance to hit the creature is the percentage of Player's **Dexterity** skill. For instance: if Player's **Dexterity** skill is 4, there is a 40% chances to hit the creature.
- When Player hits the creature, the damage provoked is a random generated number between 1 and Player's **Strength** skill.
- When Player hits the creature, there is a 10% chance to inflict a critical. In this case, the damage doubles.

### Desired combat system
Combat is separated in two stages:
1. Attack: check if attack is successful. Modifiers are:
  - \+ Attacker dexterity
  - \- Target dexterity


2. Damage

### Floating text
When hitting or missing a strike, a floating pop up text appers on top of the creature. This floating text is implemented by **FTC.tscn** and **FTCMgr.tcsn**


## Singletons

There are two singletons: **Player.tscn** and **Notification.tscn**
