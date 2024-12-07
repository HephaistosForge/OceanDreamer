extends Entity

@export var speed: float = 100
@export var turn_speed: float = 10
@export var power_impulse_frequency: float = 100

@onready var ship = get_tree().get_first_node_in_group("ship")

func power_func(x):
	return sin(x)**2 + 0.4

func _physics_process(delta: float) -> void:
	if ship:
		var power = power_func(Time.get_ticks_msec() / 1000 * power_impulse_frequency)
		var target = global_position.angle_to_point(ship.global_position)
		global_rotation = rotate_toward(global_rotation, target, turn_speed * delta * power)
		velocity = Vector2(cos(rotation), sin(rotation)) * speed * power * delta * 60
	move_and_slide()
 
