extends StaticBody2D

@export var health: int = 5

const BULLET = preload("res://Projectile/Bullet/bullet.tscn")
var detected: bool = false
var locked: bool = false
var elapse: float = 5.0
var direccion: float
var timer = Timer.new()

@onready var radar: Area2D = %Radar
@onready var cannon: Sprite2D = %Cannon
@onready var muzzle: Marker2D = %Muzzle
@onready var shoot_at: Marker2D = %ShootAt
@onready var player: Player = %Player
@onready var base: StaticBody2D = %Base


func _ready():
	timer.wait_time = 1
	add_child(timer)
	direccion = rotation
	radar.player_detected.connect(_on_player_detected)
	radar.player_lost.connect(_on_player_lost)


func _physics_process(delta: float) -> void:
	if detected:
		# Store current angle between the player position and the turret position
		var angle: float = (player.global_position - global_position).angle()
		# Calculate if the player is located within the field of view of the turret.
		# The field of view of the turret is 90º to the left and 90º degrees to the right
		# of the direcction the turret is facing.
		if angle_difference(direccion, angle) < PI/2 and angle_difference(direccion, angle) > -PI/2:
			locked = true
			# Rotate the turret towards the player (stored angle)
			rotation = lerp_angle(rotation, angle, elapse * delta)
		else:
			locked = false


func _on_player_detected():
	detected = !detected
	timer.start()
	timer.timeout.connect(_shoot)
	#var tween = get_tree().create_tween().set_loops()
	#tween.tween_callback(_shoot).set_delay(1)


func _on_player_lost():
	detected = !detected
	timer.timeout.disconnect(_shoot)
	timer.stop()


func _shoot():
	if locked:
		var tween = create_tween()
		tween.tween_property(cannon, "position", Vector2(-10, 0), 0.2).as_relative().set_trans(Tween.TRANS_SINE)
		tween.tween_property(cannon, "position", Vector2(10, 0), 0.2).as_relative().set_trans(Tween.TRANS_SINE)
		var new_bullet = BULLET.instantiate()
		get_parent().add_child(new_bullet)
		new_bullet.global_position = muzzle.global_position
		new_bullet.look_at(shoot_at.global_position)


func take_damage(damage):
	var label: Label = Label.new()
	add_child(label)
	label.position = Vector2(-10, -30) + Vector2(randf_range(-20, 20), 0)
	label.text = "-%d" % [damage]
	
	var tween: Tween = create_tween()
	tween.tween_property(label, "position", Vector2(0, -30), 2.0).as_relative().set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel()
	tween.tween_property(label, "modulate:a", 0, 2.0)
	#tween.tween_property(label, "scale", Vector2.ZERO, 2.0)
	tween.connect("finished", Callable(label, "queue_free"))
	
	health -= damage
	if health <= 0:
		queue_free()
