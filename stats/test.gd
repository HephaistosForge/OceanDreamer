extends Node2D

const BASE_CANNON = preload("res://stats/weapons/cannon/base_cannon.tres")
const BURST = preload("res://stats/weapons/cannon/upgrades/burst.tres")
const DINGHY = preload("res://stats/ships/dinghy.tres")

func _ready() -> void:
	
	#BASE_CANNON.merge(BURST)
	print("====================")
	#BASE_CANNON.merge(BURST)
	print("====================")
	#DINGHY.merge(HP_UPGRADE)
	save_dps()
	
	get_tree().quit()
		
	var a = DINGHY.merged(BURST)
	print("============")
	print(a)
	
func save_dps():
	var file = FileAccess.open("res://dps.txt", FileAccess.WRITE)
	DINGHY.eval()
	var upgrades = Upgrades.new()
	upgrades.random_upgrade(DINGHY.weapon)
	
	var output = func(string):
		print(string)
		file.store_string(string + "\n")
		
	output.call("Base dps: " + str(DINGHY.weapon.dps()))
	for path in upgrades.weapon_to_upgrades:
		for upgrade in upgrades.weapon_to_upgrades[path]:
			var upgraded = DINGHY.merged(upgrade)
			# if upgrade.name.begins_with("Mobility"): continue
			var string = upgrade.name + " dps: " + str(upgraded.weapon.dps())
			output.call(string)
			for upgrade2 in upgrades.weapon_to_upgrades[path]:
				# if upgrade2.name.begins_with("Mobility"): continue
				var upgraded2 = upgraded.merged(upgrade2)
				string = upgrade.name + "+" + upgrade2.name + " dps: " + str(upgraded2.weapon.dps())
				output.call(string)
		
	

	
	
