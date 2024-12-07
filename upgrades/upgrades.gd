extends Node

class_name Upgrades

var default: Dictionary 
var upgrades: Array

func _init():

	var text = FileAccess.get_file_as_string("res://upgrades/upgrades.json")
	var parsed = JSON.parse_string(text)
	default = parsed["default"][0]
	upgrades = parsed["upgrades"]
	
func random() -> Upgrade:
	return Upgrade.new(upgrades.pick_random().merged(default))
