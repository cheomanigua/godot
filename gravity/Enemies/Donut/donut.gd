extends Area2D

enum munition { LOW_DAMAGE, MEDIUM_DAMAGE, HIGH_DAMAGE }
@export var munition_type: munition = munition.LOW_DAMAGE
@export var reload_time: float = 1.0

var ray_length: float = 350
var detected: bool = false
var can_shoot: bool = true
var elapsed: float = 10.0
var player: RigidBody2D
var movement: Vector2

@onready var raycast: RayCast2D = RayCast2D.new()
@onready var timer: Timer = Timer.new()
@onready var radar: Area2D = %Radar


func _ready():
	add_child(raycast)
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = reload_time
	rotation = deg_to_rad(rotation)
	radar.player_detected.connect(_on_player_detected)
	radar.player_lost.connect(_on_player_lost)


func _physics_process(delta: float) -> void:
	queue_redraw()
	if detected:
		var target: Vector2 = position.direction_to(player.position)
		var facing = transform.x
		var fov = target.dot(facing) # field of view
		raycast.target_position = Vector2(ray_length, 0)
		if fov > 0:
			rotation = lerp_angle(rotation, target.angle(), elapsed * delta)
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
	draw_circle(Vector2(ray_length, 0), 8.0, Color.SKY_BLUE, false, -1.0, false)


func _on_player_detected(body):
	player = body
	detected = !detected
	raycast.set_enabled(true)
	#timer.start()


func _on_player_lost():
	detected = !detected
	raycast.set_enabled(false)
	#timer.set_paused(true)
	#timer.stop()


func _on_timer_timeout() -> void:
	can_shoot = true


func _shoot():
	var new_bullet: Bullet = Bullet.create_bullet(munition_type)
	new_bullet.rotation = rotation
	new_bullet.position = position
	get_parent().add_child(new_bullet)
