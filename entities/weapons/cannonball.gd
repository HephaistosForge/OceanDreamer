extends Area2D

const CANNONBALL_SCENE = preload("res://entities/weapons/cannonball.tscn")
const RIPPLE_SCENE = preload("res://effects/RippleEffect.tscn")
const GRACE_PERIOD_DURATION = .1
const SPRAY_FACTOR_ARRAY = [.5, 1, -.5, -1]

var ripple_effect: CPUParticles2D = null
var ripple_scale: float = 0.6

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var acceleration_cutoff_distance = 1
var distance_travelled = 0
var damage = 10
var is_enemy = true
var seconds_flight_time = 2
var fragmentate_count = 0
var bounce_count = 0
var pierce_count = 0

var grace_period_active = false # Duration in which cannonball does not interact with hit bodies

var init_velocity = Vector2.ZERO
var init_seconds_flight_time = 0


func _ready() -> void:
	get_tree().create_timer(seconds_flight_time * 1.5).timeout.connect(despawn)
	
	if grace_period_active: _activate_grace_period()
	
	ripple_effect = RIPPLE_SCENE.instantiate()
	self.add_child(ripple_effect)
	ripple_effect.scale_amount_max = ripple_scale
	ripple_effect.scale_amount_min = ripple_effect.scale_amount_max
	ripple_effect.amount = 3
	ripple_effect.one_shot = true
	ripple_effect.emitting = false


func despawn():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "self_modulate", Color(0.3, 0.3, 0.6, 0), 3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 6) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(queue_free)
	
	ripple_effect.emitting = true
	velocity *= 0.5


func _activate_grace_period() -> void:
	grace_period_active = true
	get_tree().create_timer(GRACE_PERIOD_DURATION).timeout.connect(func(): grace_period_active = false)


func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity -= velocity * delta / seconds_flight_time


func _on_entity_entered(body: Node2D) -> void:
	if not grace_period_active and body is Entity and body.is_enemy != is_enemy:
		body.take_damage(damage)
		
		var cannon = get_tree().get_first_node_in_group("cannon")
		
		for i in fragmentate_count:
			var randomizer_vec = Vector2(SPRAY_FACTOR_ARRAY[randi() % SPRAY_FACTOR_ARRAY.size()], SPRAY_FACTOR_ARRAY[randi() % SPRAY_FACTOR_ARRAY.size()])
			var _cannonball_velocity = velocity * randomizer_vec
			cannon.create_cannonball(position, _cannonball_velocity, false, \
				scale * 0.5, damage * 0.25, init_seconds_flight_time, 0, 0, 
				bounce_count - 1, $Sprite.self_modulate, true)
		
		if bounce_count > 0:
			var randomizer_vec = Vector2(SPRAY_FACTOR_ARRAY[randi() % SPRAY_FACTOR_ARRAY.size()], SPRAY_FACTOR_ARRAY[randi() % SPRAY_FACTOR_ARRAY.size()])
			var _cannonball_velocity = init_velocity * randomizer_vec
			cannon.create_cannonball(position, _cannonball_velocity, false, \
				scale, damage, init_seconds_flight_time, fragmentate_count, 0, \
				bounce_count - 1, $Sprite.self_modulate, true)
		
		if pierce_count > 0:
			pierce_count -= 1
			_activate_grace_period()
			# Half damage but increase velocity so that piercing bullet can still travel further
			velocity *= 2
			damage *= 0.5
		else:
			queue_free()


func change_color(color: Color) -> void:
	$Sprite2D.self_modulate = color
