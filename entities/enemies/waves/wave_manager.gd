extends Node2D

var small = preload("res://entities/enemies/small/small.tscn")
var medium = preload("res://entities/enemies/medium/medium.tscn")
var large = preload("res://entities/enemies/large/large.tscn")
var boss = preload("res://entities/enemies/boss/boss.tscn")

const WAVE_SPAWNER = preload("res://entities/enemies/waves/wave_spawner.tscn")

const DELAY_INSTANT = .1
const DELAY_SHORT = .75
const DELAY_MEDIUM = 1
const DELAY_LONG = 2
const DELAY_BOSS = 3

const DISTANCE_VERYSHORT = 750
const DISTANCE_SHORT = 1500
const DISTANCE_MEDIUM = 2000
const DISTANCE_FAR = 2800
const DISTANCE_BOSS = 3500

var waves = [
	# Wave = [batch: [], delay: float, distance: float, xp_required: int]
	# Batch = [enemy_type, batch (= how many at once), chance (1 = 100%), max_count]
	Wave.new([Batch.new(small, 1, 1, 6)], DELAY_SHORT, DISTANCE_MEDIUM, 3),
	Wave.new([Batch.new(small, 1, 0.5, 50), Batch.new(medium, 1, 0.3, 30)], DELAY_SHORT, DISTANCE_MEDIUM, 10),
	Wave.new([
		Batch.new(small, 3, 0.5, 300), 
		Batch.new(medium, 1, 0.3, 300),
		Batch.new(large, 1, 0.2, 100),
	], DELAY_MEDIUM, DISTANCE_MEDIUM, 20),
	Wave.new([Batch.new(small, 1, 1, 1000)], DELAY_INSTANT, DISTANCE_FAR, 50),
	Wave.new([Batch.new(boss, 1, 1, 1), Batch.new(small, 5, 1, 1000)], DELAY_BOSS, DISTANCE_BOSS, 10000),
	Wave.new([
		Batch.new(small, 3, 0.3, 3000), 
		Batch.new(medium, 1, 0.4, 3000),
		Batch.new(large, 1, 0.3, 1000),
	], DELAY_INSTANT, DISTANCE_MEDIUM, 90),
	Wave.new([
		Batch.new(small, 20, 0.5, 5000), 
		Batch.new(medium, 10, 0.5, 5000),
	], DELAY_SHORT, DISTANCE_MEDIUM, 200),
	Wave.new([
		Batch.new(medium, 1, 0.3, 3000),
		Batch.new(large, 1, 0.7, 6000),
	], DELAY_INSTANT, DISTANCE_MEDIUM, 500),
	Wave.new([
		Batch.new(large, 1, 1, 10000),
	], DELAY_INSTANT, DISTANCE_FAR, 1200),
	Wave.new([
		Batch.new(medium, 1, 1, 10000),
		Batch.new(boss, 1, 1, 2)
	], DELAY_INSTANT, DISTANCE_BOSS, 20000),
	Wave.new([
		Batch.new(small, 10, 1, 10000),
	], DELAY_INSTANT, DISTANCE_FAR, 2000),
	Wave.new([
		Batch.new(large, 4, 1, 10000),
	], DELAY_INSTANT, DISTANCE_MEDIUM, 4000),
	Wave.new([
		Batch.new(small, 5, 1, 10000),
		Batch.new(medium, 3, 1, 10000),
		Batch.new(large, 1, 1, 10000),
	], DELAY_INSTANT, DISTANCE_MEDIUM, 7000),
	Wave.new([
		Batch.new(small, 3, .5, 10000),
		Batch.new(medium, 1, .3, 10000),
		Batch.new(large, 6, 1, 12000),
	], DELAY_INSTANT, DISTANCE_SHORT, 10000),
	Wave.new([
		Batch.new(small, 3, .5, 10000),
		Batch.new(medium, 1, .3, 10000),
		Batch.new(large, 6, .7, 12000),
		Batch.new(boss, 1, 0.05, 10),
	], DELAY_INSTANT, DISTANCE_BOSS, 60000),
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
		spawner.level = level
		var xp = spawner.wave.xp_required
		# DEBUG OVERRIDE
		# xp = 2
		level_manager.total_monsters = xp
		level_manager.update_remaining_monsters(xp)
		ship.add_child(spawner)
		
	
