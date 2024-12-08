extends Node2D

var wave: Wave

func _ready():
	$Timer.wait_time = wave.delay
	$Timer.timeout.connect(_spawn_enemy)
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.to_upgrade_screen.connect(func(_a): queue_free())
	
	
func _spawn_enemy():
	if wave == null or wave.exhausted(): 
		queue_free()
	var angle = randf_range(0, TAU)
	
	for monster in wave.create_enemies():
		get_tree().current_scene.add_child(monster)
		monster.global_position = global_position + Vector2(cos(angle), sin(angle)) * wave.distance
		monster.global_rotation = randf_range(0, TAU) 

		var level_manager = get_tree().get_first_node_in_group("level_manager")
		if level_manager:
			monster.death.connect(level_manager._on_monster_death)
