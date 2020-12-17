extends Node
signal enemy_hit


func attack(enemy):
	var health = enemy.creature_stats["Health"]
	var damage = "miss"
	var crit = false
	randomize()

	# If Player has, for instance, dexterity = 4, there will be a 40% chances to hit the enemy
	var hit = true if randi() % 10 < Player.stats["Dexterity"] else false
	if hit:
		# Player makes a random damage between 1 and his strength attribute
		# Also, there is a 10% chances of a critical hit, which doubles the damage
		damage = randi() % Player.stats["Strength"] + 1
		crit = true if randi() % 100 < 10 else false
		if crit:
			damage *= 2
		health -= damage
		emit_signal("enemy_hit", damage, crit)
#		Gui.message("%s was hit by %s for %d hit points." % [enemy.creature_type, Player.get_name(), damage])
	else:
		emit_signal("enemy_hit",damage,crit)
#		Gui.message("%s Missed" % [Player.get_name()])

	enemy.creature_stats["Health"]= health
	status(enemy,health)


func status(enemy,health):
	if health > 0:
		print("%s health is %d" % [enemy.get_name(), health])
	else:
		Gui.message("%s died" % [enemy.creature_type])
		enemy.queue_free()

