extends Marker2D

var raycast: RayCast2D = RayCast2D.new()

func _ready():
	add_child(raycast)
	pass
	#raycast.position = position
	#print(position)
	#print(global_position)
	#print(raycast.position)
	#raycast.look_at(%ShootAt.global_position)
	#raycast.rotation = global_rotation
	#get_parent().add_child(raycast)
	#raycast.enabled = true
