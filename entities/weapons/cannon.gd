extends Node2D

const CANNONBALL_SCENE = preload("res://entities/weapons/cannonball.tscn")

@export var rotation_speed: float = 10.0
@export var shooting_delay: float = 0.5
@export var acceleration: float = 300
@export var damage: float = 10
@export var knockback: float = 0
@export var ball_size: float = 1

@onready var camera = get_tree().get_first_node_in_group("camera")

var reload_timer: Timer = Timer.new()
var can_shoot = true

func _ready():
	add_child(reload_timer)
	reload_timer.wait_time = shooting_delay
	reload_timer.timeout.connect(func(): can_shoot = true)
	
func apply_upgrade(upgrade: Upgrade):
	acceleration = upgrade.fma("cannon_velocity", acceleration)
	rotation_speed = upgrade.fma("cannon_rotation_speed", rotation_speed)
	shooting_delay = upgrade.fma("cannon_shooting_delay", shooting_delay)
	damage = upgrade.fma("cannon_ball_damage", damage)
	knockback = upgrade.fma("cannon_ball_knockback", knockback)
	ball_size = upgrade.fma("cannon_ball_size", ball_size)
	

func _process(delta: float) -> void:
	var target = global_position.angle_to_point(get_global_mouse_position())
	global_rotation = rotate_toward(global_rotation, target, delta * rotation_speed)
	
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		reload_timer.start()
		var cannonball = CANNONBALL_SCENE.instantiate()
		get_tree().root.add_child(cannonball)
		cannonball.global_position = global_position
		cannonball.acceleration_cutoff_distance = $SpawnAt.global_position.distance_to($AccelerateTo.global_position)
		cannonball.acceleration = Vector2(cos(global_rotation), sin(global_rotation)) * acceleration
		cannonball.is_enemy = false
		cannonball.damage = damage
		
		camera.trigger_shake(2.0, 0.03, 1, global_rotation)
