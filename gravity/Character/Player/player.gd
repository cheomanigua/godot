class_name Player
extends RigidBody2D

var attributes: Dictionary = {
	"health": 0,
	"ammo": 0,
	"fuel": 0
}

var top: Dictionary = {
	"health": 10,
	"ammo": 20,
	"fuel": 20
}

var thrust: Vector2 = Vector2(0, -500)
var torque: int = 4000

const BULLET = preload("res://Projectile/Bullet/bullet.tscn")
@onready var muzzle: Marker2D = %Muzzle
@onready var shoot_at: Marker2D = %ShootAt
@onready var health_label: Label = %HealthLabel
@onready var trace: GPUParticles2D = %Trace
@onready var ammo_label: Label = %AmmoLabel
@onready var fuel_label: Label = %FuelLabel
@onready var stats: Label = %Stats


func _ready() -> void:
	for key in attributes:
		attributes[key] = top[key]
		stats.text += ("%s: %d\n" % [key, attributes[key]])
	angular_damp = 20.0
	gravity_scale = 0.2
	trace.emitting = false


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		_shoot()


func _integrate_forces(state):
	if Input.is_action_pressed("ui_up"):
		attributes.fuel -= 0.01
		attributes.fuel = clamp(attributes.fuel, 0, top.fuel)
		trace.emitting = true
		_update_gui()
		state.apply_force(thrust.rotated(rotation))
		if attributes.fuel <= 0:
			thrust = Vector2(0, 0)
	else:
		trace.emitting = false
#	state.apply_force(Vector2())
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
	state.apply_torque(rotation_direction * torque)


func _shoot():
	if attributes.ammo > 0:
		var new_bullet = BULLET.instantiate()
		get_tree().root.add_child(new_bullet)
		new_bullet.global_position = muzzle.global_position
		new_bullet.look_at(shoot_at.global_position)
		attributes.ammo -= 1
		attributes.ammo = clamp(attributes.ammo, 0, top.ammo)
		_update_gui()
	else:
		Signals.event.emit("Ammo depleted!")


func take_damage(damage):
	attributes.health -= damage
	attributes.health = clamp(attributes.health, 0, top.health)
	_update_gui()
	if attributes.health == 2:
		Signals.event.emit("Damage critical!")
	if attributes.health == 0:
		Signals.event.emit("You died!")


func take_item(item: String, value: float):
	attributes[item] += value
	attributes[item] = clamp(attributes[item], 0, top[item])
	_update_gui()


func _update_gui():
	stats.text = ""
	for key in attributes:
		if key == "fuel":
			stats.text += ("%s: %0.2f\n" % [key, attributes[key]])
		else:
			stats.text += ("%s: %d\n" % [key, attributes[key]])
			
