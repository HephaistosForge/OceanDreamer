extends Node
class_name Upgrades

var weapon_to_upgrades = {}

func load_from_dir(path: String):
	if path in weapon_to_upgrades:
		return weapon_to_upgrades[path]
	weapon_to_upgrades[path] = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				weapon_to_upgrades[path].append(load(path + "/" + file_name))
			file_name = dir.get_next()
		return weapon_to_upgrades[path] 
	else:
		push_error("An error occurred when trying to access the upgrades path " + path)

func random_upgrade(weapon):
	return load_from_dir(weapon.upgrades_directory).pick_random()
