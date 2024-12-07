extends Node2D

const CANNONBALL_SCENE = preload("res://entities/weapons/cannonball.tscn")

@export var rotation_speed: float = 10.0
@export var shooting_delay: float = 0.5
@export var velocity: float = 1000
@export var damage: float = 10
@export var knockback: float = 0
@export var ball_size: float = 1
@export var burst_count: int = 1
@export var burst_delay: float = 0.1
@export var spray_count: int = 1
@export var flight_range: float = 2

@onready var camera = get_tree().get_first_node_in_group("camera")

var reload_timer: Timer = Timer.new()
var can_shoot = true

func _ready():
	add_child(reload_timer)
	reload_timer.wait_time = shooting_delay
	reload_timer.timeout.connect(func(): can_shoot = true)
	
func apply_upgrade(upgrade: Upgrade):
	velocity = upgrade.fma("cannon_velocity", velocity)
	rotation_speed = upgrade.fma("cannon_rotation_speed", rotation_speed)
	shooting_delay = upgrade.fma("cannon_shooting_delay", shooting_delay)
	damage = upgrade.fma("cannon_ball_damage", damage)
	knockback = upgrade.fma("cannon_ball_knockback", knockback)
	ball_size = upgrade.fma("cannon_ball_size", ball_size)
	burst_count = upgrade.fma("cannon_ball_burst_count", burst_count)
	burst_delay = upgrade.fma("cannon_ball_burst_delay", burst_delay)
	spray_count = upgrade.fma("cannon_ball_spray_count", spray_count)
	scale = Vector2.ONE * upgrade.fma("cannon_size", scale.x)
	flight_range = upgrade.fma("cannon_ball_flight_range", flight_range)
	

func _process(delta: float) -> void:
	var target = global_position.angle_to_point(get_global_mouse_position())
	global_rotation = rotate_toward(global_rotation, target, delta * rotation_speed)
	
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		for burst in burst_count:
			var cannonball = CANNONBALL_SCENE.instantiate()
			get_tree().root.add_child(cannonball)
			cannonball.global_position = $SpawnAt.global_position
	
			var velocity_direction = Vector2(cos(global_rotation), sin(global_rotation))
			cannonball.velocity = velocity_direction * velocity + get_parent().velocity
			cannonball.is_enemy = false
			cannonball.scale = Vector2.ONE * ball_size
			cannonball.damage = damage
			cannonball.seconds_flight_time = flight_range
		
			camera.trigger_shake(0.5 * ball_size, 0.03, 1, global_rotation)
			await get_tree().create_timer(burst_delay).timeout
		
		reload_timer.start()
		
