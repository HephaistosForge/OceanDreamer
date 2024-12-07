extends Area2D

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var acceleration_cutoff_distance = 1
var distance_travelled = 0
var damage = 10
var is_enemy = true
var seconds_flight_time = 2

func _ready() -> void:
	get_tree().create_timer(seconds_flight_time).timeout.connect(despawn)
	
func despawn():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.1) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(queue_free)
	

func _physics_process(delta: float) -> void:
	position += velocity * delta
	distance_travelled += (velocity * delta).length()
	if distance_travelled < acceleration_cutoff_distance:
		velocity += acceleration
	else:
		velocity -= velocity * delta / seconds_flight_time


func _on_entity_entered(body: Node2D) -> void:
	if body is Entity and body.is_enemy != is_enemy:
		body.take_damage(damage)
		queue_free()
