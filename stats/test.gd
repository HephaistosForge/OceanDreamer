extends Node2D

const BASE_CANNON = preload("res://stats/weapons/cannon/base_cannon.tres")
const BURST = preload("res://stats/weapons/cannon/upgrades/burst.tres")
const DINGHY = preload("res://stats/ships/dinghy.tres")
const HP_UPGRADE = preload("res://stats/ships/upgrades/hp_upgrade.tres")

func _ready() -> void:
	
	#BASE_CANNON.merge(BURST)
	print("====================")
	#BASE_CANNON.merge(BURST)
	print("====================")
	#DINGHY.merge(HP_UPGRADE)
	
	var a = DINGHY.merged(HP_UPGRADE)
	print("============")
	print(a)
	
	print(DINGHY.changes_on_upgrade(HP_UPGRADE))
	
