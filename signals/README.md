## Signal's tutorial

This example creates a **Zone** that can be traversed by **Player** and **Objeto**. When this happens, **Panel** logs each trespass in two counters, one for **Player** and one for **Objeto**.

**Zone** creates the Godot's built-in signal `body_entered` via code, instead of creating it in the editor. **Zone** listen to its own `body_entered` signal with the function `_on_Zone_body_entered` that alerts when an object enters in the zone.

**Player** can move using the WASD keys. **Player** also listen to **Zone**'s `body_entered` signal and creates his own reaction function `player_spotted` to alert of their own intrusion in the zone.

**Objeto** can move by point and click with the mouse. **Objeto** is not interested in listening to the **Zone**'s `body_entered` signal, so it is not aware that is being monitored when entering in the zone.

**Panel** listen to **Zone**'s `body_entered` signal and updates the trespass counter accordingly by using the function `increase_counter`.
