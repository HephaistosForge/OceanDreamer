extends Weapon

const CANNONBALL_SCENE = preload("res://entities/weapons/cannonball.tscn")
const EXPLOSION_SCENE = preload("res://effects/explosion.tscn")

@onready var camera = get_tree().get_first_node_in_group("camera")

var can_shoot = true
var reloaded = true
var dead = false


func _process(delta: float) -> void:
	if dead: return
	
	var target = global_position.angle_to_point(get_global_mouse_position())
	global_rotation = rotate_toward(global_rotation, target, delta * stats.turn_speed)
	
	if Input.is_action_pressed("shoot") and reloaded and can_shoot:
		shoot()

func shoot():
	reloaded = false
	for burst in stats.burst_count:
		add_explosion()
		for spray in stats.spray_count:
			
			var shot_angle = get_spray_angle(spray)

			var velocity_direction = Vector2(cos(shot_angle), sin(shot_angle))
			var _cannonball_velocity = velocity_direction * stats.shot_velocity + get_parent().velocity
			var _cannonball_scale = Vector2.ONE * stats.shot_size * global_scale
			
			var cannonball = CANNONBALL_SCENE.instantiate()
			cannonball.setup($SpawnAt.global_position, _cannonball_velocity, _cannonball_scale, stats)
			get_tree().current_scene.call_deferred("add_child", cannonball)
		
			Audio.play("cannon_shoot")
			camera.trigger_shake(0.5 * stats.shot_size, 0.03, 1, global_rotation)
		await get_tree().create_timer(stats.intra_clip_delay).timeout
	get_tree().create_timer(stats.clip_delay).timeout.connect(func(): reloaded = true)
			
func get_spray_angle(spray: int):
	if stats.spray_count == 1:
		return global_rotation
	var range = deg_to_rad(min(75.0, stats.spray_count / 2.0 * 15))
	var ratio = spray / float(stats.spray_count-1)
	return global_rotation - range + range * 2 * ratio
	
func add_explosion():
	var explosion_effect = EXPLOSION_SCENE.instantiate()
	add_child(explosion_effect)
	explosion_effect.translate(Vector2(150, 0))
	explosion_effect.global_rotation = global_rotation + PI / 2
	explosion_effect.emitting = true
	explosion_effect.finished.connect(func(): explosion_effect.queue_free())
