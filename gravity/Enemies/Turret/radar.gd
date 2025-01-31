extends Area2D

signal player_detected
signal player_lost


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body is Player:
		player_detected.emit(body)
		

func _on_body_exited(body):
	if body is Player:
		player_lost.emit()
