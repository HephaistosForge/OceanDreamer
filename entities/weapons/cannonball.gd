extends Area2D

const CANNONBALL_SCENE = preload("res://entities/weapons/cannonball.tscn")
const RIPPLE_SCENE = preload("res://effects/RippleEffect.tscn")
const GRACE_PERIOD_DURATION = .1
const SPRAY_FACTOR_ARRAY = [.5, 1, -.5, -1]

@onready var ripple_effect: CPUParticles2D = $RippleEffect
var ripple_scale: float = 0.2 * 4

var stats: CannonStats

var velocity = Vector2.ZERO
var is_enemy = false

var grace_period_active = false # Duration in which cannonball does not interact with hit bodies

var init_velocity = Vector2.ZERO
var init_seconds_flight_time = 0

var curr_flight_time = 0
var pierced = 0

func _ready():
	get_tree().create_timer(stats.shot_range).timeout.connect(despawn)
	ripple_effect.scale_amount_max = ripple_scale * scale.length()
	ripple_effect.scale_amount_min = ripple_scale * scale.length()
	
func setup(_position, _velocity, _scale, _stats, _grace_period_active=false) -> void:
	self.stats = _stats
	
	
	global_position = _position
	velocity = _velocity
	init_velocity = _velocity
	scale = _scale
	
	grace_period_active = _grace_period_active
	if grace_period_active: _activate_grace_period()

func clone(_velocity, _scale, stats):
	var cloned = duplicate()
	cloned.setup(global_position, _velocity, _scale, stats)
	return cloned

func despawn():
	monitorable = false
	monitoring = false
	var tween = create_tween()
	tween.tween_property($Sprite2D, "self_modulate", Color(0.3, 0.3, 0.6, 0), 2) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 4) \
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


func _on_entity_entered(body: Node2D) -> void:
	if not grace_period_active and body is Entity and body.is_enemy != is_enemy:
		body.take_damage(stats.shot_damage)
		
		# var cannon = get_tree().get_first_node_in_group("cannon")
		
		for i in stats.shot_fragmentate_count:
			var randomizer_vec = Vector2(SPRAY_FACTOR_ARRAY.pick_random(), SPRAY_FACTOR_ARRAY.pick_random())
			var _cannonball_velocity = velocity * randomizer_vec
			# TODO: apply damage reduction via stats
			clone(_cannonball_velocity, scale*0.5, stats)
			
		
		if stats.shot_bounce_count > 0:
			var randomizer_vec = Vector2(SPRAY_FACTOR_ARRAY.pick_random(), SPRAY_FACTOR_ARRAY.pick_random())
			var _cannonball_velocity = init_velocity * randomizer_vec
			clone(_cannonball_velocity, scale, stats)
		
		if pierced < stats.shot_pierce_count:
			pierced -= 1
			_activate_grace_period()
		else:
			queue_free()


func change_color(color: Color) -> void:
	$Sprite2D.self_modulate = color
