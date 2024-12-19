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
	DINGHY.eval()
	
	var a = DINGHY.merged(BURST)
	print("============")
	print(a)
	
	
