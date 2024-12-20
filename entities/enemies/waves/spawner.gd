extends Node2D

@export var spawn_delay: float = 0.6
@export var monsters: Array[PackedScene] = []
@export var distance: int = 2000
@export var amount: int = 1
@export var spawn_only_once: bool = false

var allow_spawning = true

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_delay
	timer.start()
	timer.timeout.connect(_spawn_enemy)
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.to_next_level.connect(func(_a, _b): allow_spawning = true)
	level_manager.to_upgrade_screen.connect(func(_a, _b): allow_spawning = false)
	
	
func _spawn_enemy():
	if not allow_spawning: return
	var angle = randf_range(0, TAU)
	
	for i in amount:
		var monster = monsters.pick_random().instantiate() 
		get_tree().current_scene.add_child(monster)
		monster.global_position = global_position + Vector2(cos(angle), sin(angle)) * distance
		monster.global_rotation = randf_range(0, TAU) 

		var level_manager = get_tree().get_first_node_in_group("level_manager")
		if level_manager:
			monster.death.connect(level_manager._on_monster_death)
	
	if spawn_only_once:
		allow_spawning = false
