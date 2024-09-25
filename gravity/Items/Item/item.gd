extends Area2D

@export_enum("health", "ammo", "fuel") var item: String = "health"
@export var value: float = 0
@onready var sprite_2d: Sprite2D = %Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	sprite_2d.texture = load("res://Items/Item/Sprite/" + item + ".png")


func _on_body_entered(body):
	if body is Player:
		if value > 0:
			body.take_item(item, value)
			queue_free()
