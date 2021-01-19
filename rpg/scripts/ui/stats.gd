extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	character_info()


func character_info():
	$Label.text = ""
	for key in Player.stats:
		var cap_key: String = key.capitalize()
		$Label.text += "%s: %d" % [cap_key, Player.stats[key]]
		if (key != Player.stats.keys().back()):
			$Label.text += "\n"
