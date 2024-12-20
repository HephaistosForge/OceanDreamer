extends Area2D

const CANNONBALL_SCENE = preload("res://entities/weapons/cannonball.tscn")
const RIPPLE_SCENE = preload("res://effects/RippleEffect.tscn")
const GRACE_PERIOD_DURATION = .1

@onready var ripple_effect: CPUParticles2D = $RippleEffect
var ripple_scale: float = 0.2 * 4

var stats: CannonStats

var velocity = Vector2.ZERO
var is_enemy = false

var grace_period_active = false # Duration in which cannonball does not interact with hit bodies

var init_velocity = Vector2.ZERO
var init_seconds_flight_time = 0

var curr_flight_time = 0
var fragmentate = true
var pierced = 0
var bounced = 0
var damage_multiplier = 1

func _ready():
	get_tree().create_timer(stats.shot_range).timeout.connect(despawn)
	ripple_effect.scale_amount_max = ripple_scale * scale.length()
	ripple_effect.scale_amount_min = ripple_scale * scale.length()
	if grace_period_active: _activate_grace_period()
	
func setup(_position, _velocity, _scale, _stats, _grace_period_active=false) -> void:
	self.stats = _stats
	
	global_position = _position
	velocity = _velocity
	init_velocity = _velocity
	scale = _scale
	modulate = modulate.blend(stats.shot_modulate)
	grace_period_active = _grace_period_active

func clone(_velocity, _scale, stats):
	var cloned = duplicate()
	cloned.setup(global_position, _velocity, _scale, stats, true)
	cloned.fragmentate = false
	cloned.pierced = 999999
	cloned.bounced = bounced
	get_tree().current_scene.add_child.call_deferred(cloned)
	return cloned

func despawn():
	#monitorable = false
	#monitoring = false
	var tween = create_tween()
	tween.tween_property($Sprite2D, "self_modulate", Color(0.3, 0.3, 0.6, 0), 1.5) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 2) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(queue_free)
	
	# tmuripple_effect.emitting = true
	velocity *= 0.3


func _activate_grace_period() -> void:
	grace_period_active = true
	get_tree().create_timer(GRACE_PERIOD_DURATION).timeout.connect(func(): grace_period_active = false)


func _process(delta: float) -> void:
	curr_flight_time += delta
	position += velocity * delta
	velocity = init_velocity * exp(-curr_flight_time)

func _random_direction() -> Vector2:
	# https://www.desmos.com/calculator/mukpqhzoet
	var amplitude = randfn(0.75, 0.15)
	var angle = randf_range(0, PI)
	return Vector2.from_angle(angle) * amplitude

func _on_entity_entered(body: Node2D) -> void:
	if not grace_period_active and body is Entity and body.is_enemy != is_enemy:
		body.take_damage(stats.shot_damage * damage_multiplier)
		
		body.acceleration += stats.shot_knockback * velocity * stats.shot_size / body.scale / body.weight
		
		if fragmentate:
			for i in stats.shot_fragmentate_count:
				var _cannonball_velocity = velocity * _random_direction()
				var cloned = clone(_cannonball_velocity, scale*0.5, stats)
				cloned.damage_multiplier *= 0.25
			fragmentate = false
			
		if pierced < stats.shot_pierce_count:
			pierced += 1
			_activate_grace_period()
			return
		elif bounced < stats.shot_bounce_count:
			var _cannonball_velocity = init_velocity * _random_direction()
			var cloned = clone(_cannonball_velocity, scale, stats)
			cloned.bounced = bounced + 1
		queue_free()


func change_color(color: Color) -> void:
	$Sprite2D.self_modulate = color
