extends Node

class_name Wave


var batches = null
var delay: float
var distance: float


func _init(batches: Array[Batch], delay: float, distance: float):
	self.batches = batches
	self.delay = delay
	self.distance = distance
	
func exhausted():
	for batch in self.batches:
		if batch.remaining > 0:
			return false
	return true
	
func create_enemies():
	var enemies = []
	for batch in self.batches:
		enemies.append_array(batch.possibly_create_batch())
	return enemies