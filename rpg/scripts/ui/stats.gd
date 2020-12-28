extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	character_info()


func character_info():
	$Label.text = ""
	for key in Player.stats:
		$Label.text += "%s : %d" % [key, Player.stats[key]]
		if (key != Player.stats.keys().back()):
				$Label.text += "\n"
