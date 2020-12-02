extends KinematicBody2D

var health = 10

func _ready():
# warning-ignore:return_value_discarded
	$HitBox.connect("body_entered",self,"_on_Orc_body_entered")

func _on_Orc_body_entered(body):
	randomize()
	if body.get_name() == "Player":
		var damage = randi() % 5
		health -= damage
#		print (str(get_name()) + " was hit by " + str(body.get_name()))
		print ("%s was hit by %s for %d hit points." % [get_name(), body.get_name(), damage])
		status()

func status():
	if health > 0:
#		print(str(get_name()) + " health is " + str(health))
		print("%s health is %d" % [get_name(), health])
	else:
		print("%s died" % [get_name()])
		queue_free()
