extends Node

class_name Wave

func _init(batches: Array[Batch]):
	self.batches = batches
	
func create_enemies():
	var enemies = []
	for batch in self.batches:
		enemies.append_array(batch.possibly_create_batch())
	return enemies
