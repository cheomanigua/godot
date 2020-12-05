extends Node

func combat(enemy):
	var health = enemy.stats["health"]
	randomize()

	# If Player has for instance dexterity = 4, there will be a 40% chances to hit the enemy
	var percentage = randi() % 10
	if percentage > Player.stats["dexterity"]:
		print("%s Missed" % [Player.get_name()])
	else:	
		# Player makes a random damage between 1 and his strength attribute
		var damage = randi() % Player.stats["strength"] + 1
		health -= damage
		print ("%s was hit by %s for %d hit points." % [enemy.get_name(), Player.get_name(), damage])

	enemy.stats["health"]= health
	status(enemy,health)

func status(enemy,health):
	if health > 0:
		print("%s health is %d" % [enemy.get_name(), health])
	else:
		print("%s died" % [enemy.get_name()])
		enemy.queue_free()

