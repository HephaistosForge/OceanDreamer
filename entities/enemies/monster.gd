extends Entity

@export var speed: float = 100
@export var turn_speed: float = 10
@export var power_impulse_frequency: float = 10
@export var wiggle_factor: float = 0.1
@export var apply_power_impulse_to_velocity: bool = false
@export var melee_attack_damage: int = 5
@export var attack_delay: float = 1.0

@onready var ship = get_tree().get_first_node_in_group("ship")

var reload_timer: Timer = Timer.new()
var can_attack = true
var elapsed_time = 0

func _ready():
	super()
	add_child(reload_timer)
	reload_timer.wait_time = attack_delay
	reload_timer.timeout.connect(func(): can_attack = true)

func power_func(x):
	return sin(x)**2 + 0.4

func _physics_process(delta: float) -> void:
	elapsed_time += delta
	if ship and is_instance_valid(ship):
		var anim_progression_point = elapsed_time * power_impulse_frequency
		var power = power_func(anim_progression_point)
		var target = global_position.angle_to_point(ship.global_position) \
			+ sin(anim_progression_point) * wiggle_factor
		global_rotation = rotate_toward(global_rotation, target, turn_speed * delta * power)
		velocity = Vector2(cos(rotation), sin(rotation)) * speed * delta * 60
		if apply_power_impulse_to_velocity:
			velocity *= power
	move_and_slide()
	attack_player_in_melee_if_possible()

func attack_player_in_melee_if_possible():
	if melee_attack_damage > 0 and can_attack:
		var collision = get_last_slide_collision()
		if collision: 
			if collision.get_collider().is_in_group("ship"):
				can_attack = false
				reload_timer.start()
				collision.get_collider().take_damage(melee_attack_damage)
	 
