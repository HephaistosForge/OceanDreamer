extends Node2D

@export var spawn_delay: int = 3
@export var monsters: Array[PackedScene] = []
@export var distance: int = 1000

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_delay
	timer.start()
	timer.timeout.connect(_spawn_enemy)
	
func _spawn_enemy():
	var angle = randf_range(0, TAU) 
	var monster = monsters.pick_random().instantiate() 
	get_tree().root.add_child(monster)
	monster.global_position = global_position + Vector2(cos(angle), sin(angle)) * distance
	
