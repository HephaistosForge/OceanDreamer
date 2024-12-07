extends Node

class_name Upgrades

var default: Dictionary 
var upgrades: Array[Upgrade] = []

func _init():

	var text = FileAccess.get_file_as_string("res://upgrades/upgrades.json")
	var parsed = JSON.parse_string(text)
	default = parsed["default"][0]
	var raw_upgrades = parsed["upgrades"]
	for upgrade in raw_upgrades:
		upgrades.append(Upgrade.new(upgrade.merged(default)))
	
func random(level: int) -> Upgrade:
	return upgrades.pick_random()
