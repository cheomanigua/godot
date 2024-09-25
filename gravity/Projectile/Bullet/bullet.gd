extends Area2D

var speed:float = 500
@export var damage: float = 1
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)


func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta


func _on_screen_exited() -> void:
	queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage(damage)
