extends Area2D

const RIPPLE_SCENE = preload("res://effects/RippleEffect.tscn")

var ripple_effect: CPUParticles2D = null
var ripple_scale: float = 0.6

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var acceleration_cutoff_distance = 1
var distance_travelled = 0
var damage = 10
var is_enemy = true
var seconds_flight_time = 2

func _ready() -> void:
	get_tree().create_timer(seconds_flight_time * 1.5).timeout.connect(despawn)
	
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
	

func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity -= velocity * delta / seconds_flight_time


func _on_entity_entered(body: Node2D) -> void:
	if body is Entity and body.is_enemy != is_enemy:
		body.take_damage(damage)
		queue_free()
