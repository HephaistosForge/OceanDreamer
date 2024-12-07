extends Entity

@export var speed: float = 100
@export var turn_speed: float = 10
@export var power_impulse_frequency: float = 10
@export var wiggle_factor: float = 0.1
@export var apply_power_impulse_to_velocity: bool = false

@onready var ship = get_tree().get_first_node_in_group("ship")

var elapsed_time = 0

func power_func(x):
	return sin(x)**2 + 0.4

func _physics_process(delta: float) -> void:
	elapsed_time += delta
	if ship:
		var anim_progression_point = elapsed_time * power_impulse_frequency
		var power = power_func(anim_progression_point)
		var target = global_position.angle_to_point(ship.global_position) \
			+ sin(anim_progression_point) * wiggle_factor
		global_rotation = rotate_toward(global_rotation, target, turn_speed * delta * power)
		velocity = Vector2(cos(rotation), sin(rotation)) * speed * delta * 60
		if apply_power_impulse_to_velocity:
			velocity *= power
	move_and_slide()
 
