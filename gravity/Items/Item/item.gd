extends Area2D

@export_enum("health", "ammo", "fuel") var item_name: String = "health"
@export var item_value: float = 0
@onready var sprite_2d: Sprite2D = %Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	sprite_2d.texture = load("res://Items/Item/Sprite/" + item_name + ".png")
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position", Vector2(0, 20), 0.5).as_relative().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", Vector2(0, -20), 0.5).as_relative().set_trans(Tween.TRANS_QUAD)
	#tween.tween_property(self, "modulate", Color.RED, 0.5).as_relative()
	#tween.tween_property(self, "modulate", Color.BLUE, 0.5).as_relative()


func _on_body_entered(body):
	if body is Player:
		if item_value > 0:
			body.take_item(item_name, item_value)
			queue_free()
