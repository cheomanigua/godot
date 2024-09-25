extends Area2D

@export_enum("health", "ammo", "fuel") var item: String = "health"
@export var value: float = 0
@onready var sprite_2d: Sprite2D = %Sprite2D
var tween: Tween

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	sprite_2d.texture = load("res://Items/Item/Sprite/" + item + ".png")
	tween = get_tree().create_tween().set_loops()
	tween.tween_property(self, "position", Vector2(0, 20), 0.5).as_relative().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(0, -20), 0.5).as_relative().set_trans(Tween.TRANS_SINE)


func _on_body_entered(body):
	if body is Player:
		if value > 0:
			body.take_item(item, value)
			tween.kill()
			queue_free()
