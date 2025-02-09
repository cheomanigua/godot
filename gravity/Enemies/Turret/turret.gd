extends StaticBody2D

@export var health: int = 5
@export var cannon_rotation: float = 0
enum munition { LOW_DAMAGE, MEDIUM_DAMAGE, HIGH_DAMAGE }
@export var munition_type: munition = munition.LOW_DAMAGE
@export var reload_time: float = 1.0

var detected: bool = false
var can_shoot: bool = true
var elapse: float = 10.0
var player: RigidBody2D

@onready var raycast: RayCast2D = RayCast2D.new()
@onready var timer: Timer = Timer.new()
@onready var radar: Area2D = %Radar
@onready var cannon: Sprite2D = %Cannon
@onready var muzzle: Marker2D = %Muzzle
@onready var shoot_at: Marker2D = %ShootAt


func _ready():
	add_child(raycast)
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = reload_time
	radar.player_detected.connect(_on_player_detected)
	radar.player_lost.connect(_on_player_lost)


func _physics_process(delta: float) -> void:
	if detected:
		queue_redraw()
		var target: Vector2 = position.direction_to(player.position)
		var facing = transform.x
		var fov = target.dot(facing) # field of view
		raycast.target_position = transform.x + Vector2(350, 0)
		if fov > 0:
			rotation = lerp_angle(rotation, target.angle(), elapse * delta)
			if can_shoot:
				if raycast.is_colliding():
					var collider = raycast.get_collider()
					if collider != player:
						timer.stop()
						can_shoot = true
					else:
						if can_shoot:
							_shoot()
							can_shoot = false
							timer.start()
		else:
			timer.stop()
			can_shoot = true
	else:
		timer.stop()
		can_shoot = true


func _draw() -> void:
	draw_line(raycast.position, raycast.target_position, Color.GREEN, 1.0)


func _on_player_detected(body):
	player = body
	detected = !detected
	raycast.enabled = true
	#timer.start()


func _on_player_lost():
	detected = !detected
	raycast.enabled = false
	#timer.stop()


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
