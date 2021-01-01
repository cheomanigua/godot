extends Area2D

var items_in_range = {}

func _ready():
# warning-ignore:return_value_discarded
	connect("body_entered",self,"_on_PickupZone_body_entered")
# warning-ignore:return_value_discarded
	connect("body_exited",self,"_on_PickupZone_body_exited")


func _on_PickupZone_body_entered(body):
	items_in_range[body] = body


func _on_PickupZone_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)
