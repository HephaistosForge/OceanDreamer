extends Node

class_name Batch

var remaining = 0

func _init(scene: PackedScene, batch: int, chance: float, max_count: int):
	self.scene = scene
	self.batch = batch
	self.chance = chance
	self.max_count = max_count
	remaining = max_count
	
func possibly_create_batch():
	var enemies = []
	if randf() < self.chance and remaining > 0:
		for i in self.batch:
			enemies.append(self.scene.instantiate())
		remaining -= 1
	return enemies
