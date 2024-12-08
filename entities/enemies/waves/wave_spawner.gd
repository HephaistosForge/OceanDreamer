extends Node2D

var wave: Wave
var level = 1

#export var speed: float = 100
#@export var turn_speed: float = 10
#@export var power_impulse_frequency: float = 10
#@export var wiggle_factor: float = 0.1
#@export var apply_power_impulse_to_velocity: bool = false
#@export var melee_attack_damage: int = 5
#@export var attack_delay: float = 1.0
#@export var xp: int = 1

var available_mutations = [
	"speed",
	"gigaspeed",
	"damage",
	"huge"
]

func mutate(str, m):
	var color = Color(1, 1, 1, 0)
	match str:
		"speed":
			m.speed *= 1.3
			m.turn_speed *= 1.3
			color = Color.BLUE
		"gigaspeed":
			m.speed *= 1.7
			m.turn_speed *= 0.7
			color = Color.CYAN
		"damage":
			m.melee_attack_damage *= 1.3
			color = Color.RED
		"huge":
			m.scale *= Vector2.ONE * 1.3
			m.melee_attack_damage *= 2
			color = Color.DARK_GOLDENROD
	m.blend_coloring(color)
			

func _ready():
	$Timer.wait_time = wave.delay
	$Timer.timeout.connect(_spawn_enemy)
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.to_upgrade_screen.connect(func(_a): queue_free())
	
	
func mutate_monster(monster):
	var up_to_mutations = level / 2
	var mutation_count = randi_range(0, up_to_mutations)
	for i in mutation_count:
		mutate(available_mutations.pick_random(), monster)
	
func _spawn_enemy():
	if wave == null or wave.exhausted(): 
		queue_free()
	var angle = randf_range(0, TAU)
	
	for monster in wave.create_enemies():
		get_tree().current_scene.add_child(monster)
		mutate_monster.call_deferred(monster)
		monster.global_position = global_position + Vector2(cos(angle), sin(angle)) * wave.distance
		monster.global_rotation = randf_range(0, TAU) 

		var level_manager = get_tree().get_first_node_in_group("level_manager")
		if level_manager:
			monster.death.connect(level_manager._on_monster_death)
