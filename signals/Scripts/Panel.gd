extends Control

var pcount = 0
var ocount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
#	var zone = get_tree().get_root().find_node("Zone", true, false)
# warning-ignore:return_value_discarded
	get_parent().get_node("Zone").connect("body_entered",self,"increase_counter")
	get_node("LPlayer").text = str(pcount)
	get_node("LOther").text = str(ocount)
	
func increase_counter(body):
	if body.is_in_group("players"):
		pcount += 1
		get_node("LPlayer").text = str(pcount)
	else:
		ocount += 	1
		get_node("LOther").text = str(ocount)
