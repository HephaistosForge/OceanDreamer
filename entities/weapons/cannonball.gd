extends Area2D

const CANNONBALL_SCENE = preload("res://entities/weapons/cannonball.tscn")
const RIPPLE_SCENE = preload("res://effects/RippleEffect.tscn")
const GRACE_PERIOD_DURATION = .2
const BOUNCE_FACTOR_ARRAY = [.5, 1, -.5, -1]

var ripple_effect: CPUParticles2D = null
var ripple_scale: float = 0.6

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var acceleration_cutoff_distance = 1
var distance_travelled = 0
var damage = 10
var is_enemy = true
var seconds_flight_time = 2
var bounce_count = 0

var grace_period_active = false

var init_velocity = Vector2.ZERO
var init_seconds_flight_time = 0


func _ready() -> void:
	get_tree().create_timer(seconds_flight_time * 1.5).timeout.connect(despawn)
	
	if grace_period_active:
		get_tree().create_timer(GRACE_PERIOD_DURATION).timeout.connect(func(): grace_period_active = false)
	
	ripple_effect = RIPPLE_SCENE.instantiate()
	self.add_child(ripple_effect)
	ripple_effect.scale_amount_max = ripple_scale
	ripple_effect.scale_amount_min = ripple_effect.scale_amount_max
	ripple_effect.amount = 3
	ripple_effect.one_shot = true
	ripple_effect.emitting = false
	
	print(bounce_count)


func despawn():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "self_modulate", Color(0.3, 0.3, 0.6, 0), 3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 6) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(queue_free)
	
	ripple_effect.emitting = true
	velocity *= 0.5


func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity -= velocity * delta / seconds_flight_time


func _on_entity_entered(body: Node2D) -> void:
	if not grace_period_active and body is Entity and body.is_enemy != is_enemy:
		body.take_damage(damage)
		
		if bounce_count > 0:
			var cannonball = CANNONBALL_SCENE.instantiate()
			get_tree().root.add_child(cannonball)
			cannonball.position = position
			var randomizer_vec = Vector2(BOUNCE_FACTOR_ARRAY[randi() % BOUNCE_FACTOR_ARRAY.size()], BOUNCE_FACTOR_ARRAY[randi() % BOUNCE_FACTOR_ARRAY.size()])
			cannonball.velocity = init_velocity * randomizer_vec
			cannonball.seconds_flight_time = init_seconds_flight_time
			cannonball.bounce_count = bounce_count - 1
			cannonball.change_color(Color(240, 0, 0, 255))
			cannonball.is_enemy = false
			cannonball.grace_period_active = true
		
		queue_free()


func change_color(color: Color) -> void:
	$Sprite2D.self_modulate = color
