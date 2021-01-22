# RPG Godot project 

## Player
- Player is a **Player.tscn** scene with a **KinematicBody2D** parent node and the following children nodes: **Sprite**, **AnimationPlayer**, **CollisionShape2D**, **Camera2D** and an **Area2D** called **PickupZone** used to interact with items in the environment.

## Items

Items are divided in three categories:
1. **items.json**: Used as the data model
2. **item_object.tscn**/**item_object.gd**: For managing items in the environment
3. **item.tscn**/**item.gd**: For managing items in the inventory

**item_object.tscn** scene is composed of a **KinematicBody2D** as parent node and the following children nodes: **Sprite**, **Area2D** and **CollisionShape2D**
- No texture file must be added in the **Sprite** node. Only add a texture file in the instanciated *item_object*'s sprite node. 
- Items functionality is implemented by script **item.gd** 
- The fundamental feature of an item is that it can be picked up and dropped by the player. When picked up, the item is added to a dictionary called `inventory`
- Items have four custom properties that can be edited in the instanciated nodes:
  1. **Texture**: Used in the editor in an instanciated item for adding a texture to the **Sprite** node. Sprite sheets may be used as texture also, so you need to set the values of Animation's *VFrames*, *HFrames* and *Frame*
  2. **Item Name**: Used to identify the item both in the inventory and when interacting with the environment.
  3. **Item Quantity**: Used to quantify the number of items on an item instance.
  4. **Item Uniqueness**: This property is optional. Used to add an array of special attributes: special name, power ups.
- If no **Item Name** is added, there will be an alert in the main editor window and an error message in Godot’s built-in debugger.
- Items are instanciated from the parent scene "item_object.tscn"
- When instanciated, items are automatically added to the group *Items*
- It is recommended to create an empty parent Node for instances that share the same **Item name**. For instance, create an empty Node and name it **Gems**. From **Gems** you can instanciate items that are going to use *Gem* as **Item Name**.
### Item Uniqueness
- This optional property is used to provide an item with specific properties that are not available for ordinary items properties fetched via json file.
- This property consist of an array that can have one or more elements:
1. First element is the unique name of the item
2. Second and third elements corresponds with the name of a skill and its value
3. Forth and fith elements corresponds with the name of a skill and its value

The best example of its use is in the `stats.gd` file, where it is used to powerup player's skills.


### Pickup()

- `pickup_item()` function in **player.gd** adds **one** item in the overlapping **Aread2D** of the player to the inventory dictionary in **inventory_controller.gd**.
- `grab_item()` function in **player.gd** adds **all** items in the overlapping **Aread2D** of the player to the inventory dictionary in **inventory_controller.gd**.
- `show_loot()` function in **player.gd** fetches all items in the overlapping **Aread2D** of the player and show them in the inventory UI.
- `show_loot()` function in **player.gd** sets the dictionary `GlobalWorld.item_position` for the function `_on_item_dropped` in **world.gd** to work correctly.
- If no *Item Name* is added in an instance of **item_object.tscn**, there will be an alert in the main editor window and an error message in Godot’s built-in debugger.
- *Item quantity* will contain the number of units of a given **item_object.tscn** instance.


## Inventory

Inventory are divided in three elements:
1. **inventory.tscn**/**inventory.gd**/**slot.gd**: Used as view, is the user interface for the inventory system.
2. **inventory_controller.gd**: Used as a controller to store the players item in a dictionary.
3. **items.json**: Used as model, it's a json file containing all the data model for the items

The Inventory UI is divided in three sections:
1. The equipment section, which will allow to fit specific items in specific slots (head, neck, left hand, etc). This items will powerup the player stats.
2. The info panel will show Player's stats and the item's characteristics
3. The container slots will hold the player inventory and the area inventory (items in the ground, a chest, etc)

## Creatures

- Creatures is a **Creature.tscn** scene with a **KinematicBody2D** parent node and
the following children nodes: **Sprite**, **CollisionShape2D**, 2 **Area2D** and **AnimationPlayer**
- The first **Area2D** is called *HitBox* and has child node of type **CollisionShape2D**
- The second **Area2D** is called *DetectArea* and has child node of type **CollisionShape2D**
used to detect when Player enters creature's detect area and trigger the state CHASE.
- The **AnimationPlayer** has a basic *flip_h* key animation.
- Creatures functionality is implemented by script **creature.gd**
- Creatures has a property called **Creature type** that can be selected from a drop down menu in the Inspector Panel. By default, the **Creature Type** is *Orc*. This property is very important because it is used to automatically initialize the creature's instance texture and skills from a JSON file.
- A placeholder texture file is added in the **Creature.tscn**'s sprite node. When instantiated, creatures get their texture from a JSON file where the *sprite sheet* resource path, *VFrames*, *HFrames* and *Frame* properties are fetched.
- Creatures have five skill's properties: *Strength, Intelligence, Dexterity, Endurance* and *Health*
- *Health* property is the sum of *Strength* and *Endurance*
- Skill's property are parsed to a dictionary variable from a JSON file.
- The file is located at [https://drive.google.com/file/d/1EngStPfZxbTGDxjVKbe7Zql3kBepNaq3/view](https://drive.google.com/file/d/1EngStPfZxbTGDxjVKbe7Zql3kBepNaq3/view)
- Creatures have a basic AI by using FSM. Currently there are only two states: PATROL and CHASE.

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
