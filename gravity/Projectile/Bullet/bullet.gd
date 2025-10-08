class_name Bullet
extends Area2D
const BULLET: PackedScene = preload("res://Projectile/Bullet/bullet.tscn")
enum munition_type { LOW_DAMAGE = 1, MEDIUM_DAMAGE, HIGH_DAMAGE }
var munition_index: int = 0
var speed:float = 500  
var damage: int = 1

@onready var vosn2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D

# static method created to instantiate bullets with parameters in other scenes
static func create_bullet(_munition_index: int) -> Bullet:
	var new_bullet: Bullet = BULLET.instantiate()
	new_bullet.munition_index = _munition_index
	return new_bullet


func _ready() -> void:
	damage = munition_type.values()[munition_index]

	body_entered.connect(_on_body_entered)
	vosn2d.screen_exited.connect(_on_screen_exited)


func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta


func _on_screen_exited() ->  void:
	await get_tree().create_timer(3.0).timeout
	queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("TakeDamage"):
		body.TakeDamage(damage)
