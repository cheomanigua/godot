extends StaticBody2D

@export var health: int = 5
@export var cannon_rotation: float = 0
enum munition { LOW_DAMAGE, MEDIUM_DAMAGE, HIGH_DAMAGE }
@export var munition_type: munition = munition.LOW_DAMAGE
@export var reload_time: float = 1.0

var detected: bool = false
var can_shoot: bool = true
var elapse: float = 5.0
var player: RigidBody2D


@onready var timer: Timer = Timer.new()
@onready var radar: Area2D = %Radar
@onready var cannon: Sprite2D = %Cannon
@onready var cannon_pivot: Marker2D = $CannonPivot
@onready var muzzle: Marker2D = %Muzzle
@onready var shoot_at: Marker2D = %ShootAt


func _ready():
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = reload_time
	cannon_pivot.rotation = deg_to_rad(cannon_rotation)
	radar.player_detected.connect(_on_player_detected)
	radar.player_lost.connect(_on_player_lost)


func _physics_process(delta: float) -> void:
	if detected:
		var target: Vector2 = position.direction_to(player.position)
		var facing = Vector2(cos(cannon_pivot.rotation), sin(cannon_pivot.rotation))
		var fov = target.dot(facing) # field of view
		cannon_pivot.raycast.target_position = Vector2(cos(rotation), sin(rotation)) + Vector2(350, 0)

		if fov > 0:
			cannon_pivot.rotation = lerp_angle(cannon_pivot.rotation, target.angle(), elapse * delta)
			await get_tree().create_timer(1.5).timeout
			cannon_pivot.look_at(player.position)
			queue_redraw()

			if cannon_pivot.raycast.is_colliding():
				var collider = cannon_pivot.raycast.get_collider()
				if collider != player:
					timer.set_paused(true)
				else:
					timer.set_paused(false)
					if can_shoot:
						_shoot()
						can_shoot = false
						timer.start()


func _draw() -> void:
	draw_line(cannon_pivot.raycast.position, cannon_pivot.raycast.target_position, Color.GREEN, 1.0)


func _on_player_detected(body):
	player = body
	detected = !detected
	cannon_pivot.raycast.enabled = true


func _on_player_lost():
	detected = !detected
	cannon_pivot.raycast.enabled = false


func _on_timer_timeout() -> void:
	can_shoot = true


func _shoot():
	var tween = create_tween()
	tween.tween_property(cannon, "position", Vector2(-10, 0), 0.2 * reload_time).as_relative().set_trans(Tween.TRANS_SINE)
	tween.tween_property(cannon, "position", Vector2(10, 0), 0.2 * reload_time).as_relative().set_trans(Tween.TRANS_SINE)
	var new_bullet: Bullet = Bullet.create_bullet(munition_type)
	get_parent().add_child(new_bullet)
	#new_bullet.transform = transform * Transform2D(rotation, Vector2(10, 0))
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
