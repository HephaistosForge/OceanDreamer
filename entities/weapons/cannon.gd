extends Node2D

const CANNONBALL_SCENE = preload("res://entities/weapons/cannonball.tscn")
const EXPLOSION_SCENE = preload("res://effects/explosion.tscn")

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
@export var bounce_count: int = 0
@export var pierce_count: int = 0
@export var fragmentate_count: int = 0
@export var ball_modulate = Color.WHITE

func god_mode():
	burst_count = 15
	spray_count = 15
	bounce_count = 1
	pierce_count = 1
	fragmentate_count = 1

@onready var camera = get_tree().get_first_node_in_group("camera")

var reload_timer: Timer = Timer.new()
var can_shoot = true
var reloaded = true
var dead = false


func _ready():
	# god_mode()
	add_child(reload_timer)
	reload_timer.wait_time = shooting_delay
	reload_timer.timeout.connect(func(): reloaded = true)


func apply_upgrade(upgrade: Upgrade):
	velocity = upgrade.fma("cannon_velocity", velocity)
	rotation_speed = upgrade.fma("cannon_rotation_speed", rotation_speed)
	shooting_delay = upgrade.fma("cannon_shooting_delay", shooting_delay)
	reload_timer.wait_time = shooting_delay
	damage = upgrade.fma("cannon_ball_damage", damage)
	knockback = upgrade.fma("cannon_ball_knockback", knockback)
	ball_size = upgrade.fma("cannon_ball_size", ball_size)
	burst_count = upgrade.fma("cannon_ball_burst_count", burst_count)
	burst_delay = upgrade.fma("cannon_ball_burst_delay", burst_delay)
	spray_count = upgrade.fma("cannon_ball_spray_count", spray_count)
	scale = Vector2.ONE * upgrade.fma("cannon_size", scale.x)
	flight_range = upgrade.fma("cannon_ball_flight_range", flight_range)
	bounce_count = upgrade.fma("cannon_ball_bounce_count", bounce_count)
	pierce_count = upgrade.fma("cannon_ball_pierce_count", pierce_count)
	fragmentate_count = upgrade.fma("cannon_ball_fragmentate_count", fragmentate_count)
	ball_modulate = ball_modulate.blend(upgrade.get_color())


func _process(delta: float) -> void:
	if dead: return
	
	var target = global_position.angle_to_point(get_global_mouse_position())
	global_rotation = rotate_toward(global_rotation, target, delta * rotation_speed)
	
	if Input.is_action_pressed("shoot") and reloaded and can_shoot:
		reload_timer.stop()
		reloaded = false
		shoot()
		reload_timer.start()

func shoot():
	for burst in burst_count:
		add_explosion()
		for spray in spray_count:
			
			var shot_angle = get_spray_angle(spray)

			var velocity_direction = Vector2(cos(shot_angle), sin(shot_angle))
			var _cannonball_velocity = velocity_direction * velocity + get_parent().velocity
			var _cannonball_scale = Vector2.ONE * ball_size * global_scale
			create_cannonball($SpawnAt.global_position, _cannonball_velocity, \
				false, _cannonball_scale, damage, flight_range, fragmentate_count, \
				bounce_count, pierce_count, ball_modulate, false)
		
			Audio.play("cannon_shoot")
			camera.trigger_shake(0.5 * ball_size, 0.03, 1, global_rotation)
		await get_tree().create_timer(burst_delay).timeout
			
func get_spray_angle(spray: int):
	if spray_count == 1:
		return global_rotation
	var range = deg_to_rad(min(75.0, spray_count / 2.0 * 15))
	var ratio = spray / float(spray_count-1)
	return global_rotation - range + range * 2 * ratio
	
func add_explosion():
	var explosion_effect = EXPLOSION_SCENE.instantiate()
	add_child(explosion_effect)
	explosion_effect.translate(Vector2(150, 0))
	explosion_effect.global_rotation = global_rotation + PI / 2
	explosion_effect.emitting = true
	explosion_effect.finished.connect(func(): explosion_effect.queue_free())

func create_cannonball(_global_position, _velocity, _is_enemy, _scale, _damage, _seconds_flight_time, _fragmentate_count, _bounce_count, _pierce_count, _color, _grace_period_active) -> void:
	var cannonball = CANNONBALL_SCENE.instantiate()
	get_tree().current_scene.call_deferred("add_child", cannonball)
	cannonball.global_position = _global_position
	cannonball.velocity = _velocity
	cannonball.init_velocity = _velocity
	cannonball.is_enemy = _is_enemy
	cannonball.scale = _scale
	cannonball.damage = _damage
	cannonball.seconds_flight_time = _seconds_flight_time
	cannonball.init_seconds_flight_time = _seconds_flight_time
	cannonball.fragmentate_count = _fragmentate_count
	cannonball.bounce_count = _bounce_count
	cannonball.pierce_count = _pierce_count
	cannonball.change_color(_color)
	cannonball.grace_period_active = _grace_period_active
