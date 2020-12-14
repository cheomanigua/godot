extends Node

func combat(enemy):
	var health = enemy.creature_stats["Health"]
	randomize()

	# If Player has, for instance, dexterity = 4, there will be a 40% chances to hit the enemy
	var percentage = randi() % 10
	if percentage > Player.stats["Dexterity"]:
		Gui.message("%s Missed" % [Player.get_name()])
	else:	
		# Player makes a random damage between 1 and his strength attribute
		var damage = randi() % Player.stats["Strength"] + 1
		health -= damage
		Gui.message("%s was hit by %s for %d hit points." % [enemy.creature_type, Player.get_name(), damage])

	enemy.creature_stats["Health"]= health
	status(enemy,health)

func status(enemy,health):
	if health > 0:
		print("%s health is %d" % [enemy.get_name(), health])
	else:
		Gui.message("%s died" % [enemy.creature_type])
		enemy.queue_free()

