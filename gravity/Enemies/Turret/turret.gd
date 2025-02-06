extends StaticBody2D

@export var health: int = 5
@export var cannon_rotation: float = 0
enum munition { LOW_DAMAGE, MEDIUM_DAMAGE, HIGH_DAMAGE }
@export var munition_type: munition = munition.LOW_DAMAGE
@export var reload_time: float = 1

var detected: bool = false
var locked: bool = false
var elapse: float = 5.0
#var direction: float # Option 2
var timer = Timer.new()
var player: RigidBody2D

@onready var radar: Area2D = %Radar
@onready var cannon: Sprite2D = %Cannon
@onready var cannon_pivot: Marker2D = $CannonPivot
@onready var muzzle: Marker2D = %Muzzle
@onready var shoot_at: Marker2D = %ShootAt


func _ready():
	add_child(timer)
	timer.wait_time = reload_time
	cannon_pivot.rotation = deg_to_rad(cannon_rotation)
	#direction = cannon_pivot.rotation # Option 2
	radar.player_detected.connect(_on_player_detected)
	radar.player_lost.connect(_on_player_lost)


func _physics_process(delta: float) -> void:
	if detected:
		## Store current angle between the player position and the turret position
		var target: Vector2 = position.direction_to(player.position) # Option 1
		var facing = Vector2(cos(cannon_pivot.rotation), sin(cannon_pivot.rotation)) # #Option 1
		var fov = target.dot(facing) # field of view
		#var angle: float = (player.position - position).normalized().angle() # Option 2
		
		## Calculate if the player is located within the field of view of the turret.
		## The field of view of the turret is 90º to the left and 90º degrees to the right
		## of the direcction the turret is facing.
		#if target.dot(Vector2(cos(cannon_pivot.rotation), sin(cannon_pivot.rotation))) > 0: # Option 2
		if fov > 0: # Option 1
		#if angle_difference(direction, angle) < PI/2 and angle_difference(direction, angle) > -PI/2: # Option 2
			locked = true
			## Rotate the cannon towards the player (stored angle)
			cannon_pivot.rotation = lerp_angle(cannon_pivot.rotation, target.angle(), elapse * delta) # Option 1
			#cannon_pivot.rotation = lerp_angle(cannon_pivot.rotation, angle, elapse * delta) # Option 2
		else:
			locked = false


func _on_player_detected(body):
	player = body
	detected = !detected
	#add_child(timer)
	timer.start()
	timer.timeout.connect(_shoot)
	#var tween = get_tree().create_tween().set_loops()
	#tween.tween_callback(_shoot).set_delay(1)


func _on_player_lost():
	detected = !detected
	timer.timeout.disconnect(_shoot)
	timer.stop()
	#timer.queue_free()


func _shoot():
	if locked:
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
