extends Node2D

var small = preload("res://entities/enemies/small/small.tscn")
var medium = preload("res://entities/enemies/medium/medium.tscn")
var large = preload("res://entities/enemies/large/large.tscn")
var boss = preload("res://entities/enemies/boss/boss.tscn")

const WAVE_SPAWNER = preload("res://entities/enemies/waves/wave_spawner.tscn")

var waves = [
	Wave.new([Batch.new(small, 1, 1, 6)], 1, 2000, 3),
	Wave.new([Batch.new(small, 1, 0.5, 50), Batch.new(medium, 1, 0.3, 30)], 2, 2000, 10),
	Wave.new([
		Batch.new(small, 3, 0.5, 300), 
		Batch.new(medium, 1, 0.3, 300),
		Batch.new(large, 1, 0.2, 100),
	], 3, 2000, 30),
	Wave.new([Batch.new(small, 1, 1, 1000)], 0.1, 3000, 50),
	Wave.new([Batch.new(boss, 1, 1, 1), Batch.new(small, 5, 1, 1000)], 3, 3000, 10000),
]

@onready var ship = get_tree().get_first_node_in_group("ship")
@onready var level_manager = get_tree().get_first_node_in_group("level_manager")

func _ready():
	level_manager.to_next_level.connect(_on_next_level)
	_on_next_level(1, null)
	

func _on_next_level(level: int, _upgrade):
	if ship:
		var spawner = WAVE_SPAWNER.instantiate()
		spawner.wave = waves[min(level-1, len(waves)-1)]
		level_manager.total_monsters = spawner.wave.xp_required
		level_manager.update_remaining_monsters(spawner.wave.xp_required)
		ship.add_child(spawner)
		
	
