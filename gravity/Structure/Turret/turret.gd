extends StaticBody2D

const BULLET = preload("res://Projectile/Bullet/bullet.tscn")
@export var health: int = 5
var detected: bool = false
var locked: bool = false
var elapse: float = 5.0
var direccion: float

@onready var timer: Timer = %Timer
@onready var radar: Area2D = %Radar
@onready var muzzle: Marker2D = %Muzzle
@onready var shoot_at: Marker2D = %ShootAt
@onready var player: Player = %Player


func _ready():
	direccion = global_rotation
	radar.player_detected.connect(_on_player_detected)
	radar.player_lost.connect(_on_player_lost)


func _physics_process(delta: float) -> void:
	if detected:
		var angle: float = (player.global_position - global_position).angle()
		if angle_difference(direccion, angle) < PI/2 and angle_difference(direccion, angle) > -PI/2:
			locked = true
			global_rotation = lerp_angle(global_rotation, angle, elapse * delta)
		else:
			locked = false


func _on_player_detected():
		detected = !detected
		timer.timeout.connect(_shoot)
		timer.start()


func _on_player_lost():
		detected = !detected
		timer.stop()
		timer.timeout.disconnect(_shoot)


func _shoot():
	if detected and locked:
		var new_bullet = BULLET.instantiate()
		get_tree().root.call_deferred("add_child", new_bullet)
		new_bullet.global_position = muzzle.global_position
		new_bullet.look_at(shoot_at.global_position)


func take_damage(damage):
	health -= damage
	print("Turret's health: %d" % [health])
	if health <= 0:
		queue_free()
