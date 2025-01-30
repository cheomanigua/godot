extends Label


func _ready() -> void:
	Signals.news.connect(_on_event)


func _on_event(message):
	text = message
	await get_tree().create_timer(5.0).timeout
	text = ""
