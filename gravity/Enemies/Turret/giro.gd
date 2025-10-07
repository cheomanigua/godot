extends Marker2D

var raycast: RayCast2D = RayCast2D.new()

func _ready() -> void:
	add_child(raycast)
	raycast.target_position = Vector2(350, 0)

func get_raycast() -> RayCast2D:
	return raycast

func _physics_process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_line(raycast.position, raycast.target_position, Color.GREEN, 1.0)
	draw_circle(Vector2(raycast.target_position), 8.0, Color.SKY_BLUE, false, -1.0, false)
